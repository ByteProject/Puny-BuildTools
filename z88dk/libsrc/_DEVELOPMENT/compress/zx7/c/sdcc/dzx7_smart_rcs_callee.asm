
; void dzx7_smart_rcs_callee(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx7

PUBLIC _dzx7_smart_rcs_callee

EXTERN asm_dzx7_smart_rcs

_dzx7_smart_rcs_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_dzx7_smart_rcs
