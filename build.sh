#!/bin/bash
if [ ! -d "./bin" ]; then
    mkdir bin
fi
nasm -f bin src/real_mode/mbr.asm    -o bin/mbr.bin
nasm -f bin src/bootloader.asm       -o bin/bootloader.bin
nasm -f bin src/pages.asm            -o bin/pages.bin
nasm -f bin src/tss.asm              -o bin/tss.bin
nasm -f bin src/kernel.asm           -o bin/kernel.bin
nasm -f bin src/interrupts/int0h.asm -o bin/int0h.bin
nasm -f bin src/interrupts/int1h.asm -o bin/int1h.bin

dd if=bin/mbr.bin           of=bin/crude.img bs=512 seek=0           conv=notrunc
dd if=bin/bootloader.bin    of=bin/crude.img bs=512 seek=1           conv=notrunc
dd if=bin/pages.bin         of=bin/crude.img bs=512 seek=2  count=24 conv=notrunc
dd if=bin/tss.bin           of=bin/crude.img bs=512 seek=26 count=17 conv=notrunc
dd if=bin/int0h.bin         of=bin/crude.img bs=512 seek=43 count=2  conv=notrunc
dd if=bin/int1h.bin         of=bin/crude.img bs=512 seek=45 count=1  conv=notrunc
dd if=bin/kernel.bin        of=bin/crude.img bs=512 seek=46 count=10 conv=notrunc