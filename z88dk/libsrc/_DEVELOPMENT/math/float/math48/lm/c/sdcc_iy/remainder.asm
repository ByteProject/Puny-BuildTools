
SECTION code_clib
SECTION code_fp_math48

PUBLIC _remainder

EXTERN cm48_sdcciy_remainder

defc _remainder = cm48_sdcciy_remainder
