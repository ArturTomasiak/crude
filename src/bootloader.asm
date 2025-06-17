[org 0x7E00]
[bits 32]
    mov AX, DATA_SEG
    mov DS, AX
    mov SS, AX
    mov ES, AX
    mov FS, AX
    mov GS, AX

    mov EBP, 0x90000
    mov ESP, EBP

    mov eax, cr0
    and eax, ~(1 << 31)
    mov cr0, eax

    mov eax, PAGES
    mov cr3, eax

    mov eax, cr4
    or eax, (1 << 5)
    mov cr4, eax

    mov ecx, 0xC0000080
    rdmsr
    or eax, (1 << 8)
    wrmsr

    mov eax, cr0
    or eax, (1 << 31) | (1 << 0)
    mov cr0, eax

    lgdt [gdt_descriptor]

    jmp CODE_SEG:KERNEL
cli
hlt
%include "src/gdt.asm"
KERNEL   equ 0xD800
PAGES    equ 0x8000
times 512-($-$$) db 0