
; uint8_t z180_inp(uint16_t port)

SECTION code_clib
SECTION code_z180

PUBLIC _z180_inp

EXTERN asm_z180_inp

_z180_inp:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_z180_inp
