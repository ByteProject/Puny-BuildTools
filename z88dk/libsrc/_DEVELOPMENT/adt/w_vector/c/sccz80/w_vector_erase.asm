
; size_t w_vector_erase(w_vector_t *v, size_t idx)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_erase

EXTERN w_array_erase

defc w_vector_erase = w_array_erase

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _w_vector_erase
defc _w_vector_erase = w_vector_erase
ENDIF

