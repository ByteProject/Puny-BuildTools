
; int bv_stack_push(bv_stack_t *s, int c)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC bv_stack_push

EXTERN b_vector_append

defc bv_stack_push = b_vector_append

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _bv_stack_push
defc _bv_stack_push = bv_stack_push
ENDIF

