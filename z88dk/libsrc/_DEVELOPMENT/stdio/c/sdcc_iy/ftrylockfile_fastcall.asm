
; int ftrylockfile_fastcall(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _ftrylockfile_fastcall

EXTERN asm_ftrylockfile

_ftrylockfile_fastcall:
   
   push hl
   pop ix
   
   jp asm_ftrylockfile
