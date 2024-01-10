
; void *p_list_push_back(p_list_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC p_list_push_back

EXTERN asm_p_list_push_back

p_list_push_back:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af

   jp asm_p_list_push_back

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_list_push_back
defc _p_list_push_back = p_list_push_back
ENDIF

