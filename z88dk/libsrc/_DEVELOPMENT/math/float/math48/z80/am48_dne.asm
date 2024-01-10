
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dne

EXTERN am48_dcmp, error_oc, error_znc

am48_dne:

   ; Return bool (AC != AC')
   ;
   ; enter : AC'= double y
   ;         AC = double x
   ;
   ; exit  : HL = 0 and carry reset if false
   ;         HL = 1 and carry set if true
   ;
   ; uses  : af, hl
   
   call am48_dcmp
   
   jp nz, error_oc             ; if x != y true
   jp error_znc
