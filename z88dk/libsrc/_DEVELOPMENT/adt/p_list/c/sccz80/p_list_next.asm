
; void *p_list_next(void *item)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC p_list_next

EXTERN asm_p_list_next

defc p_list_next = asm_p_list_next

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_list_next
defc _p_list_next = p_list_next
ENDIF

