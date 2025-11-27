// src/kerel.c

typedef unsigned long size_t;
extern void kernel_main(void);

static inline void outb(unsigned short port, unsigned char val){
    __asm__ volatile ("outb %0, %1" : : "a"(val), "Nd"(port));
}

static int vga_pos = 0;

// write a character VGA text buffer at given position
static void putchar_at(char c){
    volatile unsigned short *vga = (unsigned short*)0xB8000;
    vga[vga_pos++] = (unsigned short) c | (unsigned short)(0x07 << 8);
    if (vga_pos >= 80*25) vga_pos = 0; // wrap around
}

void kprint(const char *s){
    for(int i = 0; s[i]; ++i){
        putchar_at(s[i]);
    }
}

void kernel_main(void){
    kprint("Welcome to Lightning OS (x86_64)!");
    // simple loop so kernel doesn't exit
    kprint(" Line 2 example");
    for (;;) {__asm__ volatile ("hlt"); }
}