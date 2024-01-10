
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t wv_priority_queue_capacity(wv_priority_queue_t *q)
;
; Return the amount of space allocated for the queue in words.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC asm_wv_priority_queue_capacity

EXTERN l_readword_2_hl

defc asm_wv_priority_queue_capacity = l_readword_2_hl - 6

   ; enter : hl = priority_queue *
   ;
   ; exit  : hl = capacity in words
   ;
   ; uses  : a, hl
