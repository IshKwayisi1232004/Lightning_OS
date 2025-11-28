; src/boot.s - Multiboot header for GRUB
; 32-bit Multiboot header, required by GRUB

section .text
align 4
global multiboot_header

multiboot_header:
    dd 0x1BADB002        ; magic number
    dd 0x00              ; flags
    dd -(0x1BADB002 + 0x00) ; checksum

section .text
align 4
global _start
extern kernel_main

_start: 
    ; simple stack setup: 16 KB stack
    mov esp, stack_top

    ; call C kernel
    call kernel_main

.hang:
    hlt
    jmp .hang

section .bss
align 16
stack_bottom:
    resb 16384
stack_top:
