
; void *p_list_insert_after_callee(p_list_t *list, void *list_item, void *item)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC _p_list_insert_after_callee

EXTERN asm_p_list_insert_after

_p_list_insert_after_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   jp asm_p_list_insert_after
