
; size_t b_vector_erase(b_vector_t *v, size_t idx)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_erase

EXTERN b_array_erase

defc b_vector_erase = b_array_erase

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_vector_erase
defc _b_vector_erase = b_vector_erase
ENDIF

