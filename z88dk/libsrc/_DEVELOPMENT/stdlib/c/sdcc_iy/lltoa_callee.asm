
; char *lltoa(uint64_t num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC _lltoa_callee

EXTERN asm_lltoa

_lltoa_callee:

   pop af
   pop hl
   pop de
   exx
   pop hl
   pop de
   pop ix
   exx
   pop bc
   push af
   
   jp asm_lltoa

