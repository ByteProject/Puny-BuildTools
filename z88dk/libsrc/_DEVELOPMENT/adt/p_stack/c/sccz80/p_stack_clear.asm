
; void p_stack_clear(p_stack_t *s)

SECTION code_clib
SECTION code_adt_p_stack

PUBLIC p_stack_clear

EXTERN asm_p_stack_clear

defc p_stack_clear = asm_p_stack_clear

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_stack_clear
defc _p_stack_clear = p_stack_clear
ENDIF

