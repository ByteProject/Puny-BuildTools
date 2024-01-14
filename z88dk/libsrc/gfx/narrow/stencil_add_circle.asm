;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;	Compute the line coordinates and put into a vector
;	Basic concept by Rafael de Oliveira Jannone (calculate_side)
;
;       Stefano Bodrato - 13/3/2009
;
;
;	$Id: stencil_add_circle.asm,v 1.6 2016-04-22 20:29:51 dom Exp $
;

;; void stencil_add_circle(int x1, int y1, int x2, int y2, unsigned char *stencil)


		SECTION	  code_graphics
                PUBLIC    stencil_add_circle
                PUBLIC    _stencil_add_circle

                EXTERN     draw_circle
                EXTERN	stencil_add_pixel 

                EXTERN     swapgfxbk
                EXTERN    swapgfxbk1

                EXTERN	stencil_ptr
		EXTERN	__graphics_end

.stencil_add_circle
._stencil_add_circle
		push	ix
		ld	ix,2
		add	ix,sp

		ld	l,(ix+2)	;pointer to stencil
		ld	h,(ix+3)
		ld	(stencil_ptr),hl

		;ld	l,(ix+4)	;pointer to leftmost vector
		;ld	h,(ix+5)
		;ld	(gfx_area),hl

		ld	e,(ix+4)	;skip
		ld	d,(ix+6)	;radius
		ld	c,(ix+8)	;y
		ld	b,(ix+10)	;x

		call    swapgfxbk
		
                ld      ix,stencil_add_pixel
                call    draw_circle
		jp	__graphics_end

