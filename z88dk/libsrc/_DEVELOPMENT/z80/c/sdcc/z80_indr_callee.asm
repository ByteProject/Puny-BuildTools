
; void *z80_indr_callee(void *dst, uint8_t port, uint8_t num)

SECTION code_clib
SECTION code_z80

PUBLIC _z80_indr_callee

EXTERN asm_z80_indr

_z80_indr_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_z80_indr
