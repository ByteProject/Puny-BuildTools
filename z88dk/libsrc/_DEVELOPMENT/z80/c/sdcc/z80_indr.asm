
; void *z80_indr(void *dst, uint8_t port, uint8_t num)

SECTION code_clib
SECTION code_z80

PUBLIC _z80_indr

EXTERN asm_z80_indr

_z80_indr:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_z80_indr
