
; wa_stack_t *wa_stack_init(void *p, void *data, size_t capacity)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC wa_stack_init

EXTERN w_array_init

defc wa_stack_init = w_array_init

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _wa_stack_init
defc _wa_stack_init = wa_stack_init
ENDIF

