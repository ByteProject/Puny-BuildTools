
; int b_vector_reserve(b_vector_t *v, size_t n)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_reserve

EXTERN asm_b_vector_reserve

_b_vector_reserve:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_b_vector_reserve
