
; int isgreaterequal(float x, float y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_isgreaterequal

EXTERN am48_isgreaterequal, cm48_sdcciyp_dread2

cm48_sdcciy_isgreaterequal:

   call cm48_sdcciyp_dread2
   
   ; AC'= y
   ; AC = x

   jp am48_isgreaterequal
