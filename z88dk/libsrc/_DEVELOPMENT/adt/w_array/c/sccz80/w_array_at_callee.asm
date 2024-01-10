
; void *w_array_at(w_array_t *a, size_t idx)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_at_callee

EXTERN asm_w_array_at

w_array_at_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_w_array_at

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _w_array_at_callee
defc _w_array_at_callee = w_array_at_callee
ENDIF

