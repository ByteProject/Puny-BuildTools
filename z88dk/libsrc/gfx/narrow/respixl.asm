	INCLUDE	"graphics/grafix.inc"

        SECTION code_graphics
	PUBLIC	respixel

	EXTERN	pixeladdress
	EXTERN	__gfx_coords

;
;	$Id: respixl.asm,v 1.7 2016-07-02 09:01:35 dom Exp $
;

; ******************************************************************
;
; Reset pixel at (x,y) coordinate
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; in:  hl = (x,y) coordinate of pixel (h,l)
;
; registers changed	after return:
;  ..bc..../ixiy same
;  af..dehl/.... different
;
.respixel
			IF maxx <> 256
				ld	a,h
				cp	maxx
				ret	nc
			ENDIF

			IF maxy <> 256
				ld	a,l
				cp	maxy
				ret	nc			; y0	out of range
			ENDIF

				ld	(__gfx_coords),hl

				push	bc
				call	pixeladdress
				ld	b,a
				ld	a,1
				jr	z, reset_pixel
.reset_position	rlca
				djnz	reset_position
.reset_pixel			ex	de,hl
				cpl
				and	(hl)
				ld	(hl),a
				pop	bc
				ret
