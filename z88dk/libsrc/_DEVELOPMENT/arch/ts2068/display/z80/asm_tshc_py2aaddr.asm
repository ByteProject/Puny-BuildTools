; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_py2aaddr(uchar y)
;
; Attribute address of byte containing pixel at coordinate x = 0, y.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_py2aaddr

EXTERN asm0_zx_py2saddr

asm_tshc_py2aaddr:

   ld a,l
   and $07

IF __USE_SPECTRUM_128_SECOND_DFILE
   or $e0
ELSE
   or $60
ENDIF

   jp asm0_zx_py2saddr
