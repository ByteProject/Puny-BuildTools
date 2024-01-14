
	SECTION code_clib
	PUBLIC	plotpixel

	EXTERN	textpixl
	EXTERN	__gfx_coords

;
;	$Id: plotpixl.asm,v 1.5 2016-07-02 09:01:36 dom Exp $
;

; ******************************************************************
;
; Plot pixel at (x,y) coordinate.
;
; ZX 80 version.  
; 64x48 dots.
;
;
.plotpixel
				ld	a,h
				cp	64
				ret	nc
				ld	a,l
				;cp	maxy
				cp	48
				ret	nc		; y0	out of range
				
				ld	(__gfx_coords),hl
				
				push	bc

				ld	c,l
				ld	b,h

				push	bc
				
				srl	b
				srl	c
				ld	hl,(16396)
				inc	hl
				ld	a,c
				ld	c,b	; !!
				ld	de,33	; 32+1. Every text line ends with an HALT
				and	a
				jr	z,r_zero
				ld	b,a
.r_loop
				add	hl,de
				djnz	r_loop
.r_zero						; hl = char address
				ld	e,c
				add	hl,de
				
				ld	a,(hl)		; get current symbol
				
			ld	e,a

			push	hl
			ld	hl,textpixl
			ld	e,0
			ld	b,16
.ckmap			cp	(hl)
			jr	z,chfound
			inc	hl
			inc	e
			djnz	ckmap
			ld	e,0
.chfound		ld	a,e
			pop	hl

.islow				ex	(sp),hl		; save char address <=> restore x,y

;				cp	16		; Just to be sure:
;				jr	c,issym		; if it isn't a symbol...
;				xor	a		; .. force to blank sym
;.issym
				ld	b,a

				ld	a,1		; the bit we want to draw
				
				bit	0,h
				jr	z,iseven
				add	a,a		; move right the bit

.iseven
				bit	0,l
				jr	z,evenrow
				add	a,a
				add	a,a		; move down the bit
.evenrow
				or	b

			ld	hl,textpixl
			ld	d,0
			ld	e,a
			add	hl,de
			ld	a,(hl)

			pop	hl
			ld	(hl),a
				
				pop	bc
				ret
