
; int bv_stack_pop(bv_stack_t *s)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC bv_stack_pop

EXTERN asm_bv_stack_pop

defc bv_stack_pop = asm_bv_stack_pop

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _bv_stack_pop
defc _bv_stack_pop = bv_stack_pop
ENDIF

