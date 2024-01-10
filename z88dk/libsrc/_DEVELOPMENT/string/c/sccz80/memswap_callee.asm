
; void *memswap(void *s1, void *s2, size_t n)
IF !__CPU_GBZ80__
SECTION code_clib
SECTION code_string

PUBLIC memswap_callee

EXTERN asm_memswap

memswap_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm_memswap

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memswap_callee
defc _memswap_callee = memswap_callee
ENDIF

ENDIF
