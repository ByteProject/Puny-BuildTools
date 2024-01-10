;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_sub

l_sub:

   ; HL = DE - HL

   ex de,hl
   
   or a
   sbc hl,de
   
   ret
