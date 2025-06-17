[org 0xD200]
[bits 64]
jmp start

start:
    cmp RAX, 03h
        je read_key

    push RAX
    push RBX
    push RCX
    push RDX
    push RSI
    push RDI
    push RBP

    cmp RAX, 01h
        je clear_text_mode
    cmp RAX, 02h
        je print_char
end:
    pop RBP
    pop RDI
    pop RSI
    pop RDX
    pop RCX
    pop RBX
    pop RAX
iretq

; RAX=01h
clear_text_mode:
    mov byte [row], 0
    mov byte [col], 0
    mov RAX, 0
    mov RCX, 4000
    mov RDI, 0xB8000
    rep stosb
jmp end

; RAX=02h BL=char
nl:
    mov byte [col], 0
    cmp byte [row], 24
        jne not_full_row
    
    cld
    mov RSI, second_row
    mov RDI, 0xB8000
    mov RCX, rows_24
    rep movsb

    mov RAX, 0
    mov RCX, 160
    mov RDI, last_row
    rep stosb
ret
not_full_row:
    inc byte [row]
ret
print_char:
    cmp BL, 0Dh
        je handle_nl

    cmp byte [col], 160
        jne not_full_col
    call nl
not_full_col:
    movzx RAX, byte [row]
    mov RDX, 160
    mul RDX
    mov RDI, 0xB8000
    add RDI, RAX

    movzx RAX, byte [col]
    add RDI, RAX

    mov byte [RDI], BL
    inc RDI
    mov byte [RDI], 0x07

    add byte [col], 2
jmp end
handle_nl:
    call nl
jmp end

; RAX=03h
read_key:
    mov byte [shift_flag], 0
    push RBX
wait_for_key:
    in AL, 0x64
    test AL, 1
        jz wait_for_key

    in AL, 0x60
    mov BL, AL
    test AL, 0x80
        jnz release_key

    cmp Bl, 0x2A
        je set_shift
    cmp BL, 0x36
        je set_shift
    
    cmp BL, 128
        jae end_read_key
    
    movzx RBX, BL
    cmp byte [shift_flag], 1
        je read_shifted
    mov AH, [keymap + RBX]
    jmp end_read_key

read_shifted:
    mov AH, [shifted_keymap + RBX]
    jmp end_read_key

release_key:
    and BL, 0x7F
    cmp BL, 0x2A
    je unset_shift
    cmp BL, 0x36
    je unset_shift
    jmp end_read_key

set_shift:
    mov byte [shift_flag], 1
jmp wait_for_key

unset_shift:
    mov byte [shift_flag], 0
jmp wait_for_key

end_read_key:
    cmp AH, 0x20
        jl non_printable
    cmp AH, 0x7E
        jg non_printable
end_non_printable:
    pop RBX
iretq
non_printable:
    cmp AH, 0Dh
        je end_non_printable
    mov AH, 0
jmp end_non_printable

section .data
row db 0
col db 0
second_row equ 0xB80A0
last_row   equ 0xB8000 + 3840
rows_24    equ 3840

section .bss
shift_flag resb 1

section .rdata
keymap:
    db 0, 27
    db '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 8
    db 9
    db 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', 13
    db 0
    db 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', "'", '`', 0
    db '\', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 0
    db '*', 0
    db ' '
    db 0

    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0
    db 0

    db '7', '8', '9', '-', '4', '5', '6', '+', '1', '2', '3', '0', '.'
    db 0, 0, 0, 0
    db 0
    db 0
shifted_keymap:
    db 0, 27
    db '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', 8
    db 9
    db 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '{', '}', 13
    db 0
    db 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':', '"', '~', 0
    db '|', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '<', '>', '?', 0
    db '*', 0
    db ' '
    db 0

    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0
    db 0

    db '7', '8', '9', '-', '4', '5', '6', '+', '1', '2', '3', '0', '.'
    db 0, 0, 0, 0
    db 0
    db 0