[bits 64]
align 8
gdt_start:

gdt_null:
    dq 0x0000000000000000

gdt_code:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10011010b
    db 10100000b
    db 0x00

gdt_data:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10010010b
    db 00000000b
    db 0x00
    
gdt_tss:
    dw 104 - 1
    dw TSS_BASE & 0xFFFF
    db (TSS_BASE >> 16) & 0xFF
    db 10001001b
    db ((TSS_BASE >> 32) & 0xF) | 0x00
    db (TSS_BASE >> 24) & 0xFF
    dd (TSS_BASE >> 32) & 0xFFFFFFFF
    dd 0x00000000

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dq gdt_start

CODE_SEG equ 0x08
DATA_SEG equ 0x10
TSS_SEG  equ 0x18
TSS_BASE equ 0xB000