; My try to make a tiny ELF

; 32 bits
bits 32
; vaddr mapping
org 0x80000

_eident:
  ;; header hardcoding
  db 0x7f, "ELF"        ; magic number
  db 0x01               ; eident_class (32/64bits)
  db 0x01               ; eident_data (big/little endian)
  db 0x01               ; eident_version (:shrug: not used)
  db 0x00               ; eident_osabi (linux, netbsd, solaris...)

  db 0x00               ; eident_abiversion (:shrug: not used)
  ;times 7 db 0x00       ; eident_pad (padding)
  ;; declaring variables in the wild
  str: db "Hello!", 0xa
  strl: equ $-str

  dw 0x02               ; e_type
  dw 0x03               ; e_machine (x86, mips...)
  dd 0x01               ; e_version (:shrug: not used)
  dd _start             ; e_entry
  dd _pht-$$            ; e_phoff (program header table)
  
  dd 0x00               ; e_shoff (header table)
  dd 0x00               ; e_flags (:shrug: depends on arch)
  dw eident_s           ; e_ehsize (usually 52 or 64 bytes)
  dw pht_s              ; e_phentsize (size program header table entry)
_pht:
  ;; program header table overlapping ELF header
  dw 0x01               ; e_phnum (num of program header table entries)                         p_type2
  dw 0x00               ; e_shentsize (size of section header table entry, :shrug: not used)    P_type1
  dw 0x00               ; e_shnum (num of section header table entries)                         p_offset2
  dw 0x00               ; e_shstrndx (index of section header table with section names)         p_offset1
  ;; end header

eident_s equ $-_eident

  ;; continue pgrogram header table
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
  mov bl, 0x01
  mov ecx, str
  mov dl, strl
  int 0x80

  ;; exit 0
  mov al, 0x01
  dec ebx ; ebx = 1
  int 0x80
  
file_s equ $-$$
