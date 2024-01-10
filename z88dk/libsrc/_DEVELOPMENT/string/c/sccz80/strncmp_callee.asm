
; int strncmp(const char *s1, const char *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strncmp_callee

EXTERN asm_strncmp

strncmp_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   jp asm_strncmp

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strncmp_callee
defc _strncmp_callee = strncmp_callee
ENDIF

