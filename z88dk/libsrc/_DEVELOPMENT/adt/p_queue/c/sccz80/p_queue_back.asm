
; void *p_queue_back(p_queue_t *q)

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC p_queue_back

EXTERN asm_p_queue_back

defc p_queue_back = asm_p_queue_back

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_queue_back
defc _p_queue_back = p_queue_back
ENDIF

