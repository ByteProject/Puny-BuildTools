
; int b_array_pop_back_fastcall(b_array_t *a)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_pop_back_fastcall

EXTERN asm_b_array_pop_back

defc _b_array_pop_back_fastcall = asm_b_array_pop_back
