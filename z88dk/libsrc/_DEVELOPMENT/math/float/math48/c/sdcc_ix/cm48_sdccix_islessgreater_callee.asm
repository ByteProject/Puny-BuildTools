
; int islessgreater(float x, float y) __z88dk_callee

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_islessgreater_callee

EXTERN am48_islessgreater, cm48_sdccixp_dcallee2

cm48_sdccix_islessgreater_callee:

   call cm48_sdccixp_dcallee2
   
   ; AC'= y
   ; AC = x

   jp am48_islessgreater
