global _start

section .rodata
  greet: db "Welcome to the VM", 0xa
  greet_len: equ $-greet

  goodbye: db "Goodbye", 0xa
  goodbye_len: equ $-goodbye

section .text
_start:
  call _greet

  call get

  jmp _exec

get:
  push rbp
  mov rbp, rsp

  ; change here for custom instruction
  mov rax, 0x0
  mov rbx, 0x0
  mov rcx, 0x0
  mov rdx, 0x0
  mov r8, 0x0

  leave
  ret

_exec:
  call _clear

  ; call custom instruction
  cmp rax, 0x1
  je mov_a_b

  cmp rax, 0x2
  je push_a

  cmp rax, 0x3
  je add_a_b

  cmp rax, 0x4
  je sub_a_b

  cmp rax, 0x5
  je jump_a

  ; invalid instruction
  call _exit

_start_end:
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

; custom instructions set
mov_a_b:
  mov rbx, rcx

  jmp _start_end

push_a:
  push rbx

  jmp _start_end

add_a_b:
  add rax, rbx

  jmp _start_end

sub_a_b:
  sub rax, rbx

  jmp _start_end

jump_a:
  jmp rbx
