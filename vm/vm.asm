global _start

section .rodata
  greet: db "Welcome to the VM", 0xa
  greet_len: equ $-greet

  goodbye: db "Goodbye", 0xa
  goodbye_len: equ $-goodbye

section .text

_start:
  call _greet

  ; real shit
  call _clear

  ; custom instruction
  mov rax, 0x1
  mov rbx, 0x1
  mov rcx, 0x1
  mov rdx, 0x1
  mov r8, 0x1

  ; call custom instruction
  cmp rax, 0x1
  je mov_a_b

  cmp rax, 0x2
  je push_a
  ; end of real shit

  call _exit

_clear:
  push rbp
  mov rbp, rsp

  xor rax, rax
  xor rbx, rbx
  xor rcx, rcx
  xor rdx, rdx
  xor r8, r8

  leave
  ret

_greet:
  push rbp
  mov rbp, rsp

  mov rax, 0x1
  mov rdi, 0x1
  mov rsi, greet
  mov rdx, greet_len
  syscall

  leave
  ret

_goodbye:
  push rbp
  mov rbp, rsp

  mov rax, 0x1
  mov rdi, 0x1
  mov rsi, goodbye
  mov rdx, goodbye_len
  syscall

  leave
  ret

_exit:
  call _goodbye

  mov rax, 0x3c
  mov rdi, 0x0
  syscall

mov_a_b:
  push rbp

  call _greet

  mov rbx, rcx

  ret

push_a:
  push rbp

  call _goodbye

  push rbx

  ret
