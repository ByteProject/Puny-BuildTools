
; void b_vector_destroy(b_vector_t *v)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_destroy

EXTERN asm_b_vector_destroy

defc b_vector_destroy = asm_b_vector_destroy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_vector_destroy
defc _b_vector_destroy = b_vector_destroy
ENDIF

