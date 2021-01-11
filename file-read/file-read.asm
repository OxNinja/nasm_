global _start

section .rodata
    file_in: db "/tmp/in"       ; file we will read
    file_in_len: equ $-file_in
    size: equ 0x20              ; bytes we read

; our variables
section .bss
    buff: resb 0x20             ; our buffer for read/write
    fd_file_in: resb 0x1        ; file descriptor for file_in

section .text
_start:
    ; open file_in
    mov rax, 0x2                ; open
    mov rdi, file_in
    mov rsi, 0x0                ; no mode
    mov rdx, 0x0                ; read-only
    syscall

    mov [fd_file_in], rax       ; rax is the file descriptor of opened file

    ; read file_in
    mov rax, 0x0                ; read
    mov rdi, [fd_file_in]
    mov rsi, buff               ; buffer we will use
    mov rdx, size               ; read 32 bytes
    syscall

    ; close file_in
    mov rax, 0x3                ; close
    mov rdi, [fd_file_in]
    syscall

    ; write to stdout the content of file_in, stored in buff
    mov rax, 0x1
    mov rdi, 0x1
    mov rsi, buff
    mov rdx, size
    syscall

    mov rax, 0x3c
    mov rdi, 0
    syscall