set -e

nasm -f bin bootloader.asm -o boot.bin

gcc -m32 -ffreestanding -fno-pic -fno-stack-protector \
    -nostdlib -c kernel.c -o kernel.o

ld -m elf_i386 -T linker.ld --oformat binary kernel.o -o kernel.bin

dd if=kernel.bin of=kernel.pad bs=512 count=8 conv=notrunc status=none

dd if=/dev/zero of=disk.img bs=512 count=64 status=none
dd if=boot.bin of=disk.img bs=512 seek=0 conv=notrunc
dd if=kernel.pad of=disk.img bs=512 seek=1 conv=notrunc

qemu-system-i386 disk.img
