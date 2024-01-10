
; void *p_forward_list_remove(p_forward_list_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC p_forward_list_remove_callee

EXTERN asm_p_forward_list_remove

p_forward_list_remove_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_p_forward_list_remove

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_forward_list_remove_callee
defc _p_forward_list_remove_callee = p_forward_list_remove_callee
ENDIF

