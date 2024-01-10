
; float __schar2fs_callee(signed char sc)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciyp_schar2ds_callee

EXTERN am48_double8, cm48_sdcciyp_m482d

cm48_sdcciyp_schar2ds_callee:

   ; signed char to double
   ;
   ; enter : stack = signed char sc, ret
   ;
   ; exit  : dehl = sdcc_float(sc)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   pop af
   pop hl
   dec sp
   push af

   call am48_double8
   
   jp cm48_sdcciyp_m482d
