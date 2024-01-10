
; int _strtoi_(const char *nptr, char **endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC _strtoi__callee

EXTERN asm__strtoi

_strtoi__callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm__strtoi

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC __strtoi__callee
defc __strtoi__callee = _strtoi__callee
ENDIF

