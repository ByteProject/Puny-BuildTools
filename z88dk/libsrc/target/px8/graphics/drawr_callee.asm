;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       PX8 variant by Stefano Bodrato
;
; ----- void __CALLEE__ drawr(int x2, int y2)
;
;	$Id: drawr_callee.asm $
;

	SECTION   code_graphics

	PUBLIC    drawr_callee
	PUBLIC    _drawr_callee
	
	PUBLIC    ASMDISP_DRAWR_CALLEE

	EXTERN    do_drawr


.drawr_callee
._drawr_callee	
	pop	af	; ret addr
	pop de	; y
	pop hl	; x
	push	af	; ret addr
	
.asmentry
	ld		a,2
	jp      do_drawr


DEFC ASMDISP_DRAWR_CALLEE = asmentry - drawr_callee
