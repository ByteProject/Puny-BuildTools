
; int b_array_front(b_array_t *a)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_front

EXTERN asm_b_array_front

defc b_array_front = asm_b_array_front

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_array_front
defc _b_array_front = b_array_front
ENDIF

