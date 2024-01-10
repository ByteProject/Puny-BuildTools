
; bv_priority_queue_t *
; bv_priority_queue_init(void *p, size_t capacity, size_t max_size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC bv_priority_queue_init_callee

EXTERN asm_bv_priority_queue_init

bv_priority_queue_init_callee:

   pop af
   pop ix
   pop hl
   pop bc
   pop de
   push af
   
   jp asm_bv_priority_queue_init

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _bv_priority_queue_init_callee
defc _bv_priority_queue_init_callee = bv_priority_queue_init_callee
ENDIF

