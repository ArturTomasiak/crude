[org 0x8000]
[bits 64]

ALIGN 4096
pml4_table:
    dq pdpt_low + 0x3
    times 511 dq 0

ALIGN 4096
pdpt_low:
    dq pd_low + 0x3
    times 511 dq 0

ALIGN 4096
pd_low:
    %assign i 0
    %rep 256
        dq (i * 0x200000) | 0x83
        %assign i i+1
    %endrep
    times (512-256) dq 0
