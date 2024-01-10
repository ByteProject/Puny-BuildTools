
; int ba_priority_queue_resize(ba_priority_queue_t *q, size_t n)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC ba_priority_queue_resize_callee

EXTERN asm_ba_priority_queue_resize

ba_priority_queue_resize_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_ba_priority_queue_resize

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ba_priority_queue_resize_callee
defc _ba_priority_queue_resize_callee = ba_priority_queue_resize_callee
ENDIF

