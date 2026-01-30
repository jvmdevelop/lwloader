#include <stdint.h>

void kernel_main() {
    volatile uint16_t *vga = (uint16_t *)0xB8000;
    const uint16_t width = 80;
    const uint16_t height = 25;
    uint16_t k = ('X' | (0x07 << 8)); 

    for (uint16_t y = 0; y < height; y++) {
        for (uint16_t x = 0; x < width; x++) {
            vga[y * width + x] = k;
        }
    }

    for (;;) {} 
}
