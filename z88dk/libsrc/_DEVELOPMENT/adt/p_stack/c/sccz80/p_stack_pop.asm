
; void *p_stack_pop(p_stack_t *s)

SECTION code_clib
SECTION code_adt_p_stack

PUBLIC p_stack_pop

EXTERN asm_p_stack_pop

defc p_stack_pop = asm_p_stack_pop

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_stack_pop
defc _p_stack_pop = p_stack_pop
ENDIF

