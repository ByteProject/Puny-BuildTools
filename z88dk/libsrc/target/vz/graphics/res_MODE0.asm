
	SECTION	code_clib

	PUBLIC	res_MODE0

.res_MODE0
        ld      a,l
        cp      32
        ret     nc
	ld	a,h
	cp	64
	ret	nc

        defc    NEEDunplot = 1
        INCLUDE "gfx/gencon/pixel.inc"
