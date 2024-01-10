
; size_t w_array_erase(w_array_t *a, size_t idx)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_erase_callee

EXTERN asm_w_array_erase

w_array_erase_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_w_array_erase

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _w_array_erase_callee
defc _w_array_erase_callee = w_array_erase_callee
ENDIF

