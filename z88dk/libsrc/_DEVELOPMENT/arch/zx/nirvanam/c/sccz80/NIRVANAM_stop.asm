; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_stop(void)

SECTION code_clib
SECTION code_nirvanam

PUBLIC NIRVANAM_stop

EXTERN asm_NIRVANAM_stop

defc NIRVANAM_stop = asm_NIRVANAM_stop
