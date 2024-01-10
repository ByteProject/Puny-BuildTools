
; size_t b_vector_append(b_vector_t *v, int c)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_append_callee

EXTERN asm_b_vector_append

b_vector_append_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_b_vector_append

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_vector_append_callee
defc _b_vector_append_callee = b_vector_append_callee
ENDIF

