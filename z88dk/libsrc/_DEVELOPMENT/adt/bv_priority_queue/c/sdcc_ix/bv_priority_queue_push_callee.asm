
; int bv_priority_queue_push_callee(bv_priority_queue_t *q, int c)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC _bv_priority_queue_push_callee, l0_bv_priority_queue_push_callee

EXTERN asm_bv_priority_queue_push

_bv_priority_queue_push_callee:

   pop af
   pop hl
   pop bc
   push af

l0_bv_priority_queue_push_callee:

   push ix
   call asm_bv_priority_queue_push
   pop ix
   
   ret
