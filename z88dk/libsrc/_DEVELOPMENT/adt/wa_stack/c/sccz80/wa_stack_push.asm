
; int wa_stack_push(wa_stack_t *s, void *item)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC wa_stack_push

EXTERN w_array_append

defc wa_stack_push = w_array_append

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _wa_stack_push
defc _wa_stack_push = wa_stack_push
ENDIF

