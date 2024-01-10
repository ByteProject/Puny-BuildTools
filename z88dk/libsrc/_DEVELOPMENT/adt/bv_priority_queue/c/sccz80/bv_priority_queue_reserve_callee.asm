
; int bv_priority_queue_reserve(bv_priority_queue_t *q, size_t n)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC bv_priority_queue_reserve_callee

EXTERN asm_bv_priority_queue_reserve

bv_priority_queue_reserve_callee:

   pop hl
   pop bc
   ex (sp),hl

   jp asm_bv_priority_queue_reserve

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _bv_priority_queue_reserve_callee
defc _bv_priority_queue_reserve_callee = bv_priority_queue_reserve_callee
ENDIF

