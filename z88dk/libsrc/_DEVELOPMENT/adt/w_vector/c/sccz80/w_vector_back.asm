
; void *w_vector_back(b_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_back

EXTERN asm_w_vector_back

defc w_vector_back = asm_w_vector_back

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _w_vector_back
defc _w_vector_back = w_vector_back
ENDIF

