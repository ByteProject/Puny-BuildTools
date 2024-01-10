;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: plot.asm,v 1.8 2016-04-13 21:09:09 dom Exp $
;

;Usage: plot(int x, int y)



		SECTION code_graphics
                PUBLIC    c_plot
                PUBLIC    _c_plot
                EXTERN     swapgfxbk
                EXTERN    __graphics_end

                EXTERN     c_plotpixel

.c_plot
._c_plot
IF __CPU_INTEL__
		pop	bc
		pop	hl
		pop	de
		push	de
		push	hl
		push	bc
		ld	h,e
ELSE
		push	ix
		ld	ix,2
		add	ix,sp
		ld	l,(ix+2)
		ld	h,(ix+4)
ENDIF
                call    swapgfxbk
                call    c_plotpixel
                jp      __graphics_end

