
; void clearerr_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _clearerr_unlocked

EXTERN asm_clearerr_unlocked

_clearerr_unlocked:

   pop af
   pop ix
   
   push hl
   push af
   
   jp asm_clearerr_unlocked
