%define INT0 0xD200
%define INT1 0xD600
align 16

idt:
    dw INT0 & 0xFFFF
    dw 0x08
    db 0x1
    db 0x8E
    dw (INT0 >> 16) & 0xFFFF
    dd (INT0 >> 32) & 0xFFFFFFFF
    dd 0

    dw INT1 & 0xFFFF
    dw 0x08
    db 0x2
    db 0x8E
    dw (INT1 >> 16) & 0xFFFF
    dd (INT1 >> 32) & 0xFFFFFFFF
    dd 0

    times 254 dq 0, 0

idt_end:

idtr:
    dw idt_end - idt - 1
    dq idt