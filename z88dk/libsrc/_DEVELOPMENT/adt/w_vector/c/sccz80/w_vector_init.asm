
; w_vector_t *w_vector_init(void *p, size_t capacity, size_t max_size)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_init

EXTERN asm_w_vector_init

w_vector_init:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   jp asm_w_vector_init

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _w_vector_init
defc _w_vector_init = w_vector_init
ENDIF

