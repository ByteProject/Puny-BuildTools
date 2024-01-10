; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_drawTilePosH(unsigned char lin,unsigned char col,unsigned char attr)
; callee

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_drawTilePosH_callee

EXTERN asm_BIFROSTH_drawTilePosH

_BIFROSTH_drawTilePosH_callee:

   pop hl
	pop bc
	dec sp
	ex (sp),hl
	ld d,c          ; D = lin
	ld e,b          ; E = col
	ld c,h          ; C = attr
	
	jp asm_BIFROSTH_drawTilePosH
