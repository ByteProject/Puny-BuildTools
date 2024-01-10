
; char *ltoa(unsigned long num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC ltoa

EXTERN asm_ltoa

ltoa:

   pop af
   pop bc
   pop ix
   pop hl
   pop de
   
   push de
   push hl
   push hl
   push bc
   push af
   
   jp asm_ltoa

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ltoa
defc _ltoa = ltoa
ENDIF

