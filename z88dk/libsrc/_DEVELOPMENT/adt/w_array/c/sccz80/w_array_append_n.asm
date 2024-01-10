
; size_t w_array_append_n(w_array_t *a, size_t n, void *item)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_append_n

EXTERN asm_w_array_append_n

w_array_append_n:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_w_array_append_n

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _w_array_append_n
defc _w_array_append_n = w_array_append_n
ENDIF

