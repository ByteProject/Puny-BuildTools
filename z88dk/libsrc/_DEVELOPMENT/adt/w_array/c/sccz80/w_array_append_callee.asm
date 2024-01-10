
; size_t w_array_append(w_array_t *a, void *item)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_append_callee

EXTERN asm_w_array_append

w_array_append_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_w_array_append

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _w_array_append_callee
defc _w_array_append_callee = w_array_append_callee
ENDIF

