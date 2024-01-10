
; int memcmp(const void *s1, const void *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memcmp_callee

EXTERN asm_memcmp

memcmp_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   jp asm_memcmp

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memcmp_callee
defc _memcmp_callee = memcmp_callee
ENDIF

