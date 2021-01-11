#!/bin/sh
x=$(basename *.asm .asm)
nasm -f elf64 $x.asm
ld -o $x $x.o