
; int wa_stack_empty(wa_stack_t *s)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC wa_stack_empty

EXTERN asm_wa_stack_empty

defc wa_stack_empty = asm_wa_stack_empty

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _wa_stack_empty
defc _wa_stack_empty = wa_stack_empty
ENDIF

