
; void *w_array_back(w_array_t *a)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_back

EXTERN asm_w_array_back

defc w_array_back = asm_w_array_back

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _w_array_back
defc _w_array_back = w_array_back
ENDIF

