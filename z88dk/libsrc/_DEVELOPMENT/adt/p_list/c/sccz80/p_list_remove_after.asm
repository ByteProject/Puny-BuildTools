
; void *p_list_remove_after(p_list_t *list, void *list_item)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC p_list_remove_after

EXTERN asm_p_list_remove_after

p_list_remove_after:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_p_list_remove_after

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_list_remove_after
defc _p_list_remove_after = p_list_remove_after
ENDIF

