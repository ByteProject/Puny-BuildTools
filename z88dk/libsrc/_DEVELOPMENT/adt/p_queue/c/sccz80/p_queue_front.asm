
; void *p_queue_front(p_queue_t *q)

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC p_queue_front

EXTERN asm_p_queue_front

defc p_queue_front = asm_p_queue_front

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_queue_front
defc _p_queue_front = p_queue_front
ENDIF

