; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void BIFROST2_install()

SECTION code_clib
SECTION code_bifrost2

PUBLIC BIFROST2_install

EXTERN asm_BIFROST2_install

defc BIFROST2_install = asm_BIFROST2_install
