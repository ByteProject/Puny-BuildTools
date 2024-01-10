
; ba_stack_t *ba_stack_init(void *p, void *data, size_t capacity)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC ba_stack_init_callee

EXTERN b_array_init_callee

defc ba_stack_init_callee = b_array_init_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ba_stack_init_callee
defc _ba_stack_init_callee = ba_stack_init_callee
ENDIF

