
; size_t wv_priority_queue_max_size(wv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC wv_priority_queue_max_size

EXTERN asm_wv_priority_queue_max_size

defc wv_priority_queue_max_size = asm_wv_priority_queue_max_size

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _wv_priority_queue_max_size
defc _wv_priority_queue_max_size = wv_priority_queue_max_size
ENDIF

