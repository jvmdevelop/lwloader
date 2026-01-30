org 0x7C00
bits 16

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    call enable_a20

    mov si, msg_boot
    call print_string

    mov ax, 0x1000      ; сегмент для ебли ядра
    mov es, ax
    xor bx, bx          
    
    mov ah, 0x02       
    mov al, 9           
    mov ch, 0           
    mov cl, 2           
    mov dh, 0           ; головка члена 0
    mov dl, 0x80        ; hdd
    int 0x13
    jc hang

    lgdt [gdt_desc]

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp CODE_SEG:pm_start

hang:
    mov si, msg_error
    call print_string
    hlt
    jmp hang

enable_a20:
    in al, 0x92
    or al, 2
    out 0x92, al
    ret

print_string:
    lodsb
    test al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

bits 32
pm_start:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000

    
    jmp 0x10000 

gdt:
    dq 0x0000000000000000          
    dq 0x00CF9A000000FFFF          
    dq 0x00CF92000000FFFF          

gdt_desc:
    dw gdt_desc - gdt - 1
    dd gdt

CODE_SEG equ 0x08
DATA_SEG equ 0x10

msg_boot  db "Loading kernel...", 13, 10, 0
msg_error db "Disk Error!", 0

times 510-($-$$) db 0
dw 0xAA55