
; int wv_priority_queue_shrink_to_fit(wv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC wv_priority_queue_shrink_to_fit

EXTERN asm_wv_priority_queue_shrink_to_fit

defc wv_priority_queue_shrink_to_fit = asm_wv_priority_queue_shrink_to_fit

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _wv_priority_queue_shrink_to_fit
defc _wv_priority_queue_shrink_to_fit = wv_priority_queue_shrink_to_fit
ENDIF

