#!/bin/sh

nasm -f elf64 function.asm
ld -o function function.o