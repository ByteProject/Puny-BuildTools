
; size_t b_array_erase(b_array_t *a, size_t idx)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_erase_callee

EXTERN asm_b_array_erase

b_array_erase_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_b_array_erase

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_array_erase_callee
defc _b_array_erase_callee = b_array_erase_callee
ENDIF

