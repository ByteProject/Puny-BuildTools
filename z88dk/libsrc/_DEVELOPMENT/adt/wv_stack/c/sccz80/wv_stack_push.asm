
; int wv_stack_push(wv_stack_t *s, void *item)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC wv_stack_push

EXTERN w_vector_append

defc wv_stack_push = w_vector_append

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _wv_stack_push
defc _wv_stack_push = wv_stack_push
ENDIF

