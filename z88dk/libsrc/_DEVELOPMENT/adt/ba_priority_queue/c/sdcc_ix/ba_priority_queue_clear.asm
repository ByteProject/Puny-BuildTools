
; void ba_priority_queue_clear(ba_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC _ba_priority_queue_clear

EXTERN asm_ba_priority_queue_clear

_ba_priority_queue_clear:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_ba_priority_queue_clear
