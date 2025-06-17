[org 0xB000]
[bits 64]
section .data
align 16

tss:
    dd 0
    dq 0
    dq 0
    dq 0
    dq 0
    dq stack0 + 4096 ; int 0h
    dq stack1 + 4096 ; int 1h
    dq 0
    dq 0
    dq 0
    dq 0
    dq 0
    dd 0
    dd 0
    dd 0

section .bss
stack0: resb 4096 ; if an interrupt uses the stack only for register preservation
stack1: resb 4096 ; changing to 128 is safe assuming you don't push more than 10 registers
