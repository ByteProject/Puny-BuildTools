
; void z80_outp(uint16_t port, uint8_t data)

SECTION code_clib
SECTION code_z80

PUBLIC z80_outp_callee

EXTERN asm_z80_outp

z80_outp_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_z80_outp
