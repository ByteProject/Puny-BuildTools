
; void dzx7_standard_back_callee(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx7

PUBLIC _dzx7_standard_back_callee

EXTERN asm_dzx7_standard_back

_dzx7_standard_back_callee:

   pop af
   pop hl
   pop de
   push af

   jp asm_dzx7_standard_back
