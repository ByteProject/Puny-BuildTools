
; void *w_array_pop_back(w_array_t *a)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_pop_back

EXTERN asm_w_array_pop_back

_w_array_pop_back:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_w_array_pop_back
