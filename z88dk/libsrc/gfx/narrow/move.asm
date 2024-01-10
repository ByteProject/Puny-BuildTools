;
;       Turtle graphics library
;       Stefano - 11/2017
;
;       $Id: move.asm $
;

		SECTION         code_graphics
			PUBLIC    move
			PUBLIC    _move
			EXTERN     swapgfxbk
			EXTERN        __graphics_end

			EXTERN	__pen
			EXTERN     Line_r
			EXTERN     plotpixel
			EXTERN     setxy


.move
._move
		push	ix
		ld	ix,2
		add	ix,sp
		ld	e,(ix+2)	;py
		ld	d,(ix+3)
		ld	l,(ix+4)	;px
		ld	h,(ix+5)

		call    swapgfxbk
				
		ld	a,(__pen)
		ld	ix,setxy
		rla
		jr	nc,pen_up
		ld	ix,plotpixel
.pen_up
				
		call    Line_r
		jp      __graphics_end

