
; void im2_append_generic_callback(uint8_t vector, void *callback)

SECTION code_clib
SECTION code_z80

PUBLIC _im2_append_generic_callback

EXTERN asm_im2_append_generic_callback

_im2_append_generic_callback:

   pop af
   dec sp
   pop hl
   pop de

   push de
   push hl
   inc sp
   push af

   ld l,h
   jp asm_im2_append_generic_callback
