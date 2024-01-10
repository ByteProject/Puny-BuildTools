
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __divsint_callee

EXTERN l_divs_16_16x16

__divsint_callee:

   ; signed 16-bit division
   ;
   ; enter : stack = divisor, dividend, ret
   ;
   ; exit  : hl = quotient
   ;         de = remainder
   
   pop af
   pop hl                      ; hl = dividend
   pop de                      ; de = divisor
   push af
   
   jp l_divs_16_16x16
