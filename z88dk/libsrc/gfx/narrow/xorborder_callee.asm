
	SECTION code_graphics
	
	PUBLIC	xorborder_callee
	PUBLIC   _xorborder_callee
   
	PUBLIC	ASMDISP_XORBORDER_CALLEE
   
	EXTERN	xorpixel
	
        EXTERN     swapgfxbk
        EXTERN     swapgfxbk1

;
;	$Id: xorborder_callee.asm $
;

; ***********************************************************************
;
; XORs a dotted box.  Useful for GUIs.
; Generic version
;
; Stefano Bodrato - March 2002
;
;
; IN:	HL	= (x,y)
;	BC	= (width,heigth)
;

.xorborder_callee
._xorborder_callee

		pop af
		pop bc	; height
		pop de
		ld	b,e	; width
		pop hl	; x
		pop	de
		ld	h,e	; y		
		push af
		
.asmentry

		call	swapgfxbk
		
		push	bc
		push	hl

; -- Vertical lines --
		push	hl
		ld	a,h
		add	a,b
		;ret	c	; overflow ?
		dec	a
		ld	h,a
		pop	de
.rowloop
		push	bc
		
		inc	l
		ex	de,hl
		push	hl
		push	de
		call	xorpixel
		pop	de
		pop	hl
		inc	l

		pop	bc
		dec	c
		jr	nz,rowloop

		pop	hl
		pop	bc

; -- Horizontal lines --
		push	hl
		ld	a,l
		add	a,c
		;ret	c	; overflow ?
		dec	a
		ld	l,a
		pop	de

.vrowloop
		push	bc
		
		push	hl
		push	de
		call	xorpixel
		pop	de
		pop	hl
		inc	h
		ex	de,hl
		inc	h
		
		pop	bc
		
		djnz	vrowloop
		
		jp	swapgfxbk1

DEFC ASMDISP_XORBORDER_CALLEE = asmentry - xorborder_callee
