
; float _ceilf (float number) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math32

PUBLIC  asm_ceilf

EXTERN  m32_ceil_fastcall

    ; Takes the closest higher integer 
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = ceilf(sccz80_float)
    ;
    ; uses  : af, bc, de, hl

defc asm_ceilf = m32_ceil_fastcall
