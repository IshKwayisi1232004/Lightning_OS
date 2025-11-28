/* linker.ld - place kernel at 1MB */
OUTPUT_FORMAT(elf32-i386)
OUTPUT_ARCH(i386)
ENTRY(multiboot_header)

SECTIONS
{
    /* example load address, often 1MB */
    . = 1M;

    /* multiboot header */
    .multiboot : 
    { 
        *(.multiboot) 
    }

    .text : 
    { 
        *(.text*) 
    }

    .rodata : 
    { 
        *(rodata*) 
    }

    .data : 
    { 
        *(.data*) 
    }

    .bss : 
    { 
        *(COMMON)
        *(.bss*) 
    }
}