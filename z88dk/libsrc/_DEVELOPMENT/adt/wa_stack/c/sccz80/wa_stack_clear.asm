
; void wa_stack_clear(wa_stack_t *s)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC wa_stack_clear

EXTERN asm_wa_stack_clear

defc wa_stack_clear = asm_wa_stack_clear

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _wa_stack_clear
defc _wa_stack_clear = wa_stack_clear
ENDIF

