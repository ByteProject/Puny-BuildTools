
; float tan(float x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_tan

EXTERN cm48_sdccix_tan_fastcall

cm48_sdccix_tan:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp cm48_sdccix_tan_fastcall
