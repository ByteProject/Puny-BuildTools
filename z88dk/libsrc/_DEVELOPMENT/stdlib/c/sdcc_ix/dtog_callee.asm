
; size_t dtog(double x, char *buf, uint16_t prec, uint16_t flag) __z88dk_callee

SECTION code_clib
SECTION code_stdlib

PUBLIC _dtog_callee, l0_dtog_callee

EXTERN dcallee1, asm_dtog

_dtog_callee:

   call dcallee1               ; AC' = x
   
   pop af
   pop hl
   pop de
   pop bc
   push af

l0_dtog_callee:

   push ix
   
   call asm_dtog
   
   pop ix
   ret
