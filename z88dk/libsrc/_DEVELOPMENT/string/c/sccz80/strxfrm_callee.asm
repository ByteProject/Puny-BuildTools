
; size_t strxfrm(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strxfrm_callee

EXTERN asm_strxfrm

strxfrm_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   jp asm_strxfrm

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strxfrm_callee
defc _strxfrm_callee = strxfrm_callee
ENDIF

