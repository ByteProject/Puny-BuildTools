
; char *lltoa(uint64_t num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC _lltoa

EXTERN asm_lltoa

_lltoa:

   pop af
   pop hl
   pop de
   exx
   pop hl
   pop de
   pop bc
   exx
   pop bc
   
   push bc
   push bc
   push de
   push hl
   push de
   push hl
   push af
   
   exx
   push bc
   exx
   ex (sp),ix

   call asm_lltoa
   
   pop ix
   ret
