
; double strtod(const char *nptr, char **endptr)

SECTION code_clib
SECTION code_stdlib

PUBLIC strtod_callee

EXTERN asm_strtod

strtod_callee:

   pop hl
   pop de
   ex (sp),hl

   jp asm_strtod

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strtod_callee
defc _strtod_callee = strtod_callee
ENDIF

