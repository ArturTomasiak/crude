[org 0xD600]
[bits 64]
jmp start

start:
    push RAX
    push RBX
    push RCX
    push RDX
    push RSI
    push RDI
    push RBP
    push R8
    push R9
    cmp RAX, 01h
        je print_string
    cmp RAX, 02h
        je input
end:
    pop R9
    pop R8
    pop RBP
    pop RDI
    pop RSI
    pop RDX
    pop RCX
    pop RBX
    pop RAX
iretq

; RAX=01h RDI=buffer
print_string:
    mov RAX, 02h
    str_loop:
        mov BL, [RDI]
        cmp BL, 0h
            je end
        int 0h
        inc RDI
    jmp str_loop

; RAX=02h RDI=buffer
input:
    movzx R8, byte [RDI]
    inc RDI
    mov RSI, RDI
    mov R9, 0
input_loop:
    cmp R9, R8
        je input_end

    mov RAX, 03h
    int 0h

    cmp AH, 0
        je skip_print
    cmp AH, 0Dh
        je input_end

    mov BL, AH
    mov RAX, 02h
    int 0h
    
    mov [RSI], BL
    inc RSI
    inc R9

skip_print:

    inc RDI
jmp input_loop
input_end:
    mov byte [RSI], 0h
jmp end 