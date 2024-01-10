
	SECTION code_clib
	PUBLIC	pointxy

	EXTERN	textpixl
	EXTERN	__gfx_coords

;
;	$Id: pointxy.asm,v 1.1 2016-08-05 08:15:07 stefano Exp $
;

; ******************************************************************
;
; Get pixel at (x,y) coordinate.
;
; ZX 80 version.  
; 64x48 dots.
;
;
.pointxy
				ld	a,h
				cp	64
				ret	nc
				ld	a,l
				;cp	maxy
				cp	48
				ret	nc		; y0	out of range
				
				ld	(__gfx_coords),hl
				
				push	hl		;save coordinates

				ld	c,l
				ld	b,h

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

			ex	(sp),hl		; save char address <=> restore x,y

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
			
			and	b
			
			pop	bc
			
			ret

