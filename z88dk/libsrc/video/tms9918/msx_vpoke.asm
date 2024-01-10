;
;	MSX specific routines
;	by Stefano Bodrato, 29/11/2007
;
;	void msx_vpoke(int address, int value);
;
;	Improved functions by Rafael de Oliveira Jannone
;	Originally released in 2004 for GFX - a small graphics library
;
;	$Id: msx_vpoke.asm$
;

        SECTION code_clib
	PUBLIC	vpoke
	PUBLIC	_vpoke
	PUBLIC	msx_vpoke
	PUBLIC	_msx_vpoke
	
EXTERN msx_vpoke_callee
EXTERN ASMDISP_MSX_VPOKE_CALLEE


vpoke:
_vpoke:
msx_vpoke:
_msx_vpoke:

	pop	bc
	pop	de
	pop	hl
	push	hl	; VRAM address
	push	de	; value
	push	bc	; RET address
	
   jp msx_vpoke_callee + ASMDISP_MSX_VPOKE_CALLEE

