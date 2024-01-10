
; int wv_priority_queue_reserve(wv_priority_queue_t *q, size_t n)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC wv_priority_queue_reserve_callee

EXTERN asm_wv_priority_queue_reserve

wv_priority_queue_reserve_callee:

   pop hl
   pop bc
   ex (sp),hl

   jp asm_wv_priority_queue_reserve

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _wv_priority_queue_reserve_callee
defc _wv_priority_queue_reserve_callee = wv_priority_queue_reserve_callee
ENDIF

