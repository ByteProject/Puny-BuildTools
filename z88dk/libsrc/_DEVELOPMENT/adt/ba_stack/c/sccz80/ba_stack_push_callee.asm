
; int ba_stack_push(ba_stack_t *s, int c)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC ba_stack_push_callee

EXTERN b_array_append_callee

defc ba_stack_push_callee = b_array_append_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ba_stack_push_callee
defc _ba_stack_push_callee = ba_stack_push_callee
ENDIF

