
; int b_array_resize(b_array_t *a, size_t n)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_resize_callee

EXTERN asm_b_array_resize

b_array_resize_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_b_array_resize

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_array_resize_callee
defc _b_array_resize_callee = b_array_resize_callee
ENDIF

