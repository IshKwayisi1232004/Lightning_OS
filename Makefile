# Makefile - builds kernel ELF, creates ISO, runs QEMU
CC = gcc
CFLAGS = -ffreestanding -O2 -g -Wall -Wextra -m32 \
	-fno-pic -fno-pie -fno-stack-protector
LDFLAGS = -nostdlib -T linker.ld -no-pie

SRC = src/kernel.c
OBJ = build/kernel.o
KERNEL = build/kernel.elf
ISO = myos.iso
BOOT_OBJ = build/boot.o

all: $(ISO)

build/:
	mkdir -p build

$(OBJ): $(SRC) | build/
	$(CC) $(CFLAGS) -c $(SRC) -o $(OBJ)

$(KERNEL): $(OBJ) $(BOOT_OBJ) linker.ld
	$(CC) $(CFLAGS) $(OBJ) $(BOOT_OBJ) -o $(KERNEL) $(LDFLAGS)

$(ISO): $(KERNEL)
	mkdir -p iso/boot/grub
	cp $(KERNEL) iso/boot/kernel.elf
	cp boot/grub.cfg iso/boot/grub/grub.cfg
	# grub-mkrescue requires xorriso; on Ubuntu this should work
# 	grub-mkrescue -o $(ISO) iso || (echo "grub-mkrescue failed - ensure grub-pc-bin and xorriso are installed"; exit 1)
	grub-mkrescue -o $(ISO) iso

$(BOOT_OBJ): src/boot.s | build/
	nasm -f elf32 src/boot.s -o $(BOOT_OBJ)

run: $(ISO)
	qemu-system-i386 -cdrom $(ISO) -m 512

debug: $(ISO)
	#QEMU will listen for gdb on tcp:1234 and freeze CPU (-S)
	qemu-system-x86_64 -cdrom $(ISO) -m 512 -S -s & \
	echo "QEMU started in debug mode; attach via gdb-multiarch build/kernel.elf (target remote :1234)"

clean:
	rm -rf build iso $(ISO)