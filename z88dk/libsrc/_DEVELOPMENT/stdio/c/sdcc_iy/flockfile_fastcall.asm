
; void flockfile_fastcall(FILE *file)

SECTION code_clib
SECTION code_stdio

PUBLIC _flockfile_fastcall

EXTERN asm_flockfile

_flockfile_fastcall:
   
   push hl
   pop ix
   
   jp asm_flockfile
