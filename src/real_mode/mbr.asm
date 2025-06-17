[org 0x7C00]
[bits 16]
    mov SI, disk_address_packet
    mov AH, 042h
    mov DL, 0x80
    int 13h
    jc disk_error 

    cli

    call remap_pic

    mov AX, 0x9000
    mov SS, AX
    mov SP, 0x0000

    lgdt [gdt_descriptor]

    mov EAX, CR0
    or EAX, 1h
    mov CR0, EAX

    jmp CODE_SEG:BOOTLOADER
cli
hlt

disk_error:
    call print_disk_error
cli
hlt

%include "src/real_mode/16bit_gdt.asm"
%include "src/real_mode/16bit_print.asm"
%include "src/real_mode/remap_pic.asm"

disk_address_packet:
    db 0x10
    db 0
    dw 54
    dw BOOTLOADER
    dw 0x0000
    dq 1

times 510-($-$$) db 0
dw 0xAA55

BOOTLOADER equ 0x7E00