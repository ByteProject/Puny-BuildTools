
; int b_vector_resize(b_vector_t *v, size_t n)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_resize_callee

EXTERN asm_b_vector_resize

b_vector_resize_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_b_vector_resize

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_vector_resize_callee
defc _b_vector_resize_callee = b_vector_resize_callee
ENDIF

