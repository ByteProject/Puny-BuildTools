
; void *w_vector_front(w_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_front

EXTERN asm_w_vector_front

defc w_vector_front = asm_w_vector_front

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _w_vector_front
defc _w_vector_front = w_vector_front
ENDIF

