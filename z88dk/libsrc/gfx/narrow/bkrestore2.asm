;
;	Fast background save
;
;	Generic version (just a bit slow)
;
;	$Id: bkrestore2.asm $
;

	SECTION   code_clib
	
	PUBLIC    bkrestore
	PUBLIC    _bkrestore
	
	EXTERN	putsprite
	EXTERN	clga_callee
	EXTERN	ASMDISP_CLGA_CALLEE


.bkrestore
._bkrestore

	; __FASTCALL__ !!   HL = sprite address

	inc hl	; skip first X xs
	inc hl	; skip first Y ys
	
; spr_and:  166+47*256 // CPL - AND (HL)
; spr_or:   182 // OR (HL)

	ld	de,182	; spr_or
	push de

	ld      e,(hl)	; x pos
	inc hl
	ld		a,e
	;ld      d,0	<- d=0 already
	push    de
	
	ld      e,(hl)	; Y pos
	inc hl
	push    de
	
	push	hl		; sprite addr
	
	ld      b,(hl)	; saved X sz
	inc		hl
	ld      c,(hl)	; saved Y sz
	
	ld	h,a	; X
	ld	l,e	; Y
	
	; HL	= (x,y)
	; BC	= (width,heigth)
	call clga_callee + ASMDISP_CLGA_CALLEE
	
	call    putsprite
	
	pop     hl
	pop     de
	pop     de
	pop		de
	
	ret
