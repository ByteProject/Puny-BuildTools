
; int bv_priority_queue_shrink_to_fit(bv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC bv_priority_queue_shrink_to_fit

EXTERN asm_bv_priority_queue_shrink_to_fit

defc bv_priority_queue_shrink_to_fit = asm_bv_priority_queue_shrink_to_fit

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _bv_priority_queue_shrink_to_fit
defc _bv_priority_queue_shrink_to_fit = bv_priority_queue_shrink_to_fit
ENDIF

