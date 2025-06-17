; requirement AH=0Eh
nl:
    mov AL, 0Ah
    int 10h
    mov AL, 0Dh
    int 10h
ret

print_str:
    mov AH, 0Eh
    print_str_loop:
        mov AL, [SI]
        cmp AL, '$'
            je print_str_end
        int 10h
        inc SI
    jmp print_str_loop
print_str_end:
    call nl
ret

print_disk_error:
    mov SI, err_msg
    call print_str
ret


err_msg db 'int 13h AH=42 failed$'