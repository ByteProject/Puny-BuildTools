
; void p_forward_list_alt_push_front(p_forward_list_alt_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC p_forward_list_alt_push_front

EXTERN asm_p_forward_list_alt_push_front

p_forward_list_alt_push_front:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   jp asm_p_forward_list_alt_push_front

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_forward_list_alt_push_front
defc _p_forward_list_alt_push_front = p_forward_list_alt_push_front
ENDIF

