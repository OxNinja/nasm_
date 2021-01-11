; entrypoint is _start
global _start

; our strings
section .rodata
    str: db "Wasup", 0xa
    str_len: equ $-str

; code
section .text
_start:
    ; write str to stdout
    mov rax, 0x1        ; write
    mov rdi, 0x1        ; stdout
    mov rsi, str
    mov rdx, str_len
    syscall

    ; exit properly
    mov rax, 0x3c       ; exit
    mov rdi, 0x0        ; EXIT_SUCCESS
    syscall