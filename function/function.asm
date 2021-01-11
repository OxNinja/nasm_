; entrypoint is _start
global _start

; our strings
section .rodata
    str: db "From a function", 0xa
    str_len: equ $-str

; our code
section .text
; main
_start:
    call _func

    ; exit properly
    mov rax, 0x3c
    mov rdi, 0x0
    syscall

; our function with stackframe
_func:
    ; start of stackframe
    push rbp
    mov rbp, rsp

    ; print str to stdout
    mov rax, 0x1
    mov rdi, 0x1
    mov rsi, str
    mov rdx, str_len
    syscall

    ; end of stackframe
    leave
    ret