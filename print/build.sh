#!/bin/sh

nasm -f elf64 print.asm
ld -o print print.o