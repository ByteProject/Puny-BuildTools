
; float exp2(float x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_exp2

EXTERN cm48_sdccix_exp2_fastcall

cm48_sdccix_exp2:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp cm48_sdccix_exp2_fastcall
