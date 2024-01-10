; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_drawTW_raw(unsigned int tile, unsigned int lin, unsigned int col)
; callee

SECTION code_clib
SECTION code_nirvanam

PUBLIC NIRVANAM_drawTW_raw_callee

EXTERN asm_NIRVANAM_drawTW

NIRVANAM_drawTW_raw_callee:

        pop hl          ; RET address
        pop de          ; col
        pop bc
        ld d,c          ; lin
        ex (sp),hl      ; tile
        ld a,l

	jp asm_NIRVANAM_drawTW
