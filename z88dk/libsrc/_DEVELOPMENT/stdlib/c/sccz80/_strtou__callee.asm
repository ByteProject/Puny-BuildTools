
; unsigned int _strtou_(const char *nptr, char **endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC _strtou__callee

EXTERN asm__strtou

_strtou__callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm__strtou

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC __strtou__callee
defc __strtou__callee = _strtou__callee
ENDIF

