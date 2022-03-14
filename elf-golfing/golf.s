; My try to make a tiny ELF

; 32 bits
bits 32
; vaddr mapping
org 0x08000000

_eident:
  ;; header hardcoding
  db 0x7f, "ELF"        ; magic number
  db 0x01               ; eident_class (32/64bits)
  db 0x01               ; eident_data (big/little endian)
  db 0x01               ; eident_version (:shrug: not used)
  db 0x00               ; eident_osabi (linux, netbsd, solaris...)
  db 0x00               ; eident_abiversion (:shrug: not used)
  times 7 db 0x00       ; eident_pad (padding)

  dw 0x02               ; e_type
  dw 0x03               ; e_machine (x86, mips...)
  dd 0x01               ; e_version (:shrug: not used)
  dd _start             ; e_entry
  dd _pht-$$            ; e_phoff (program header table)
  
  dd 0x00               ; e_shoff (header table)
  dd 0x00               ; e_flags (:shrug: depends on arch)
  dw eident_s           ; e_ehsize (usually 52 or 64 bytes)
  dw pht_s              ; e_phentsize (size program header table entry)
  dw 0x01               ; e_phnum (num of program header table entries)
  dw 0x00               ; e_shentsize (size of section header table entry, :shrug: not used)
  dw 0x00               ; e_shnum (num of section header table entries)
  dw 0x00               ; e_shstrndx (index of section header table with section names)
  ;; end header

eident_s equ $-_eident

_pht:
  ;; program header table
  dd 0x01               ; p_type (load, null...)
  dd 0x00               ; p_offset
  dd $$                 ; p_vaddr (addr of segment)
  dd $$                 ; p_paddr (physical addr of segment)
  
  dd file_s             ; p_filesz (size of segment in image)
  dd file_s             ; p_memsz (size of segment in memory)
  dd 0x05               ; p_flags (0x05 == +rx)
  dd 0x1000             ; p_align
  ;; end program header table
pht_s equ $-_pht

;; declaring variables in the wild
str: db "Hello!", 0xa
strl: equ $-str

_start:
  ;; write Hello! to stdout
  mov eax, 0x4
  xor ebx, ebx
  inc ebx
  mov ecx, str
  mov edx, strl
  int 0x80

  ;; exit 0
  xor eax, eax
  inc eax
  xor ebx, ebx
  int 0x80
  
file_s equ $-$$
