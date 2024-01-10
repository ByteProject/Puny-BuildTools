;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
; ----- void __CALLEE__ setpos(int x2, int y2)
;
;	$Id: setpos.asm $
;

	SECTION   code_graphics

	PUBLIC    setpos
	PUBLIC    _setpos
	
	EXTERN    setpos_callee
	EXTERN    ASMDISP_SETPOS_CALLEE


.setpos
._setpos
	pop	af	; ret addr
	pop hl
	pop de
	push de
	push hl
	push	af	; ret addr
	
	jp setpos_callee + ASMDISP_SETPOS_CALLEE

