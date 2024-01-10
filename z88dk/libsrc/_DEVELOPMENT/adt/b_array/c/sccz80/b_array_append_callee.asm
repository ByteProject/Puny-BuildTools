
; size_t b_array_append(b_array_t *a, int c)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_append_callee

EXTERN asm_b_array_append

b_array_append_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_b_array_append

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_array_append_callee
defc _b_array_append_callee = b_array_append_callee
ENDIF

