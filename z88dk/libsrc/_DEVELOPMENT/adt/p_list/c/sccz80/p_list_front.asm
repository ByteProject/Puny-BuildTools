
; void *p_list_front(p_list_t *list)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC p_list_front

EXTERN asm_p_list_front

defc p_list_front = asm_p_list_front

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_list_front
defc _p_list_front = p_list_front
ENDIF

