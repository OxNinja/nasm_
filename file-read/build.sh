#!/bin/sh
x=$(basename *.asm .asm)
nasm -f elf64 $x.asm
ld -o $x $x.o

# write something in /tmp/in
echo "file content" > /tmp/in