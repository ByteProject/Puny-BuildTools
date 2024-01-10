
; float _fmin (float left, float right)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sccz80_fmin

EXTERN cm32_sccz80_fsread1, cm32_sccz80_fsreadl, m32_compare

    ; minimum of two sccz80 floats
    ;
    ; enter : stack = sccz80_float left, sccz80_float right, ret
    ;
    ; exit  : stack = sccz80_float left, sccz80_float right, ret
    ;          DEHL = sccz80_float
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

.cm32_sccz80_fmin
    call m32_compare        ; compare two floats on the stack
    jp NC,cm32_sccz80_fsreadl
    jp cm32_sccz80_fsread1  ; enter  stack = sccz80_float left, sccz80_float right, ret
                            ; return stack = sccz80_float left, sccz80_float right, ret
                            ;         DEHL = sccz80_float min
