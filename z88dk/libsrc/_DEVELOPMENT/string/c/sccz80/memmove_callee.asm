
; void *memmove(void *s1, const void *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memmove_callee

EXTERN asm_memmove

memmove_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   jp asm_memmove

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memmove_callee
defc _memmove_callee = memmove_callee
ENDIF

