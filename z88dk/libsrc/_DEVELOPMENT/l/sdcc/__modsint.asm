
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __modsint

EXTERN l_divs_16_16x16

__modsint:

   ; signed 16-bit mode
   ;
   ; enter : stack = divisor, dividend, ret
   ;
   ; exit  : hl = remainder
   ;         de = quotient
   
   pop af
   pop hl                      ; hl = dividend
   pop de                      ; de = divisor
   
   push de
   push hl
   push af
   
   call l_divs_16_16x16

   ex de,hl
   ret
