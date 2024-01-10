
; void *memcpy(void * restrict s1, const void * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memcpy_callee

EXTERN asm_memcpy

memcpy_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   jp asm_memcpy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memcpy_callee
defc _memcpy_callee = memcpy_callee
ENDIF

