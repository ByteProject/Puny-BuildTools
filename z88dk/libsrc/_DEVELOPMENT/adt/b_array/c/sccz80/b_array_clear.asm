
; void b_array_clear(b_array_t *a)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_clear

EXTERN asm_b_array_clear

defc b_array_clear = asm_b_array_clear

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_array_clear
defc _b_array_clear = b_array_clear
ENDIF

