
; size_t strcspn_callee(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC _strcspn_callee

EXTERN asm_strcspn

_strcspn_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_strcspn
