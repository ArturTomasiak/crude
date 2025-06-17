[org 0xD800]
[bits 64]

    mov RSP, 0x90000

    mov ax, 0x18 
    ltr ax

    lidt [idtr]

    sti

    mov RAX, 01h
    int 0h

    mov RDI, msg
    int 1h

    mov RAX, 02h
    mov BL, 0Dh
    int 0h
    mov BL, ':'
    int 0h
    mov BL, ')'
    int 0h
    mov BL, 0Dh 
    int 0h

main:
    mov RAX, 02h
    mov RDI, buffer
    int 1h

    mov BL, 0Dh
    int 0h

    mov RAX, 01h
    inc RDI
    int 1h 

    mov RAX, 02h
    mov BL, 0Dh
    int 0h
jmp main

cli
hlt

buffer db 20
times 20 db 0
%include "src/idt.asm"
msg db "succesfully entered long mode!", 0h