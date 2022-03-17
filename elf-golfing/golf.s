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
  ;; declaring variables in the wild
  str: db "Hello!", 0xa
  strl: equ $-str
  db 0x00               ; eident_pad (padding)

  dw 0x02               ; e_type
  dw 0x03               ; e_machine (x86, mips...)
  dd 0x01               ; e_version (:shrug: not used)
  dd _start             ; e_entry
  dd _pht-$$            ; e_phoff (program header table)
  
;; exit part, last instructions of the program
_exit:
  int 0x80

  ;; exit 0
  mov al, 0x01
  xor bl, bl
  int 0x80
;; end exit

  dw eident_s           ; e_ehsize (usually 52 or 64 bytes)
  dw pht_s              ; e_phentsize (size program header table entry)
;; overlapping PHT on ELF header
_pht:
  dw 0x01               ; e_phnum (num of program header table entries)                         p_type1
  dw 0x00               ; e_shentsize (size of section header table entry, :shrug: not used)    p_type2
  dw 0x00               ; e_shnum (num of section header table entries)                         p_offset1
  dw 0x00               ; e_shstrndx (index of section header table with section names)         p_offset2
  ;; end header

eident_s equ $-_eident

  ;; continue program header table
  dd $$                 ; p_vaddr (addr of segment)
  dd $$                 ; p_paddr (physical addr of segment)
  
  dd file_s             ; p_filesz (size of segment in image)
  dd file_s             ; p_memsz (size of segment in memory)
  dd 0x05               ; p_flags (0x05 == +rx)
  dd 0x1000             ; p_align
  ;; end program header table
pht_s equ $-_pht


_start:
  ;; write Hello! to stdout
  mov al, 0x04
  inc bl
  mov ecx, str
  mov dl, strl

  jmp short _exit
  
file_s equ $-$$
