; unsigned int zxn_mangle_bank_state(unsigned int state)

SECTION code_clib
SECTION code_arch

PUBLIC _zxn_mangle_bank_state_fastcall

EXTERN asm_zxn_mangle_bank_state

defc _zxn_mangle_bank_state_fastcall = asm_zxn_mangle_bank_state
