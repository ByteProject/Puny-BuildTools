
; size_t strlcat(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strlcat_callee

EXTERN asm_strlcat

strlcat_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   jp asm_strlcat

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strlcat_callee
defc _strlcat_callee = strlcat_callee
ENDIF

