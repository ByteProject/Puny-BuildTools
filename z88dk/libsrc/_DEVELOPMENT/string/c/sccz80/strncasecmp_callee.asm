
; int strncasecmp(const char *s1, const char *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strncasecmp_callee

EXTERN asm_strncasecmp

strncasecmp_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   jp asm_strncasecmp

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strncasecmp_callee
defc _strncasecmp_callee = strncasecmp_callee
ENDIF

