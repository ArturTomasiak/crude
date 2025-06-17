# crude
A bootloader into long mode with I/O interrupts for baremetal (x86) BIOS.

## list of interrupts

| interrupt | description |
|-----------|-------------|
| int 0h RAX=01h | clears entire text mode screen |
| int 0h RAX=02h BL=char | prints char, if BL=0x0D prints new line |
| int 0h RAX=03h | waits till user presses key, then stores scan code in AL and ascii in AH |
| int 1h RAX=01h RDI=buffer | prints 0h terminated string |
| int 1h RAX=02h RDI=buffer | user input with echo where buffer's first byte is max length |

## requirements 

- nasm 
- qemu (for testing on a virtual machine)

for debian

sudo apt install nasm qemu-system

## building and launching 
```bash
bash build.sh
```

then, either test it in qemu via

```bash
qemu-system-x86_64 -drive file=bin/crude.img,format=raw
```

or create a bootable pendrive via

```bash
sudo dd if=bin/crude.img of=usb_device bs=512 status=progress conv=fsync
```