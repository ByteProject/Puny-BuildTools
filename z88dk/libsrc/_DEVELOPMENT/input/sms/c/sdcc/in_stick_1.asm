
; uint16_t in_stick_1(void)

SECTION code_clib
SECTION code_input

PUBLIC _in_stick_1

EXTERN asm_in_stick_1

defc _in_stick_1 = asm_in_stick_1
