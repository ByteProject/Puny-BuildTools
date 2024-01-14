;
;	z88dk GFX library
;
;	Render the "stencil" surface onto the specified screen buffer.
;	The dithered horizontal lines base their pattern on the Y coordinate
;	and on an 'intensity' parameter (0..11).
;	Basic concept by Rafael de Oliveira Jannone
;	
;	Machine code version by Stefano Bodrato, 18/3/2009
;
;	surface_stencil_render(surface_t *s, unsigned char *stencil, unsigned char intensity)
;

	INCLUDE	"graphics/grafix.inc"

	SECTION code_clib
	PUBLIC	surface_stencil_render
	PUBLIC	_surface_stencil_render
	EXTERN	base_graphics
	EXTERN	dither_pattern

	EXTERN swapgfxbk
	EXTERN surface_pixeladdress
	EXTERN leftbitmask, rightbitmask
	;EXTERN swapgfxbk1
	
	EXTERN __graphics_end

;	
;	$Id: surface_stencil_render.asm $
;

.surface_stencil_render
._surface_stencil_render
		push	ix		;save callers
		ld	ix,0
		add	ix,sp
				
		ld	l,(ix+8)	; surface struct
		ld	h,(ix+9)
		ld	de,6		; shift to screen buffer ptr
		add	hl,de
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		ld	(base_graphics),de

		call	swapgfxbk

		ld	c,maxy
		push	bc
.yloop		pop	bc
		dec	c
		;jp	z,swapgfxbk1
		jp	z,__graphics_end

		push	bc
		
		ld	d,0
		ld	e,c

		ld	l,(ix+6)	; stencil
		ld	h,(ix+7)
		add	hl,de
		ld	a,(hl)		;X1
		
		ld	e,maxy
		add	hl,de
		cp	(hl)		; if x1>x2, return
		jr	z,xequal
		jr	nc,yloop
.xequal		
					; C still holds Y
		push	af		; X1
		ld	a,(hl)
		ld	b,a		; X2
		
		ld	a,(ix+4)	; intensity
		call	dither_pattern
		ld	(pattern1+1),a
		ld	(pattern2+1),a

			pop	af
			ld	h,a	; X1
			ld	l,c	; Y
			
			push	bc
			call	surface_pixeladdress	; bitpos0 = surface_pixeladdress(x,y)
			call	leftbitmask		; LeftBitMask(bitpos0)
			pop	bc
			push	de
			
			ld	h,d
			ld	l,e

			call	mask_pattern
			push	af
			;ld	(hl),a
			
			ld	h,b		; X2
			ld	l,c		; Y

			call	surface_pixeladdress	; bitpos1 = surface_pixeladdress(x+width-1,y)
			call	rightbitmask		; RightBitMask(bitpos1)
			ld	(bitmaskr+1),a		; bitmask1 = LeftBitMask(bitpos0)

			pop	af	; pattern to be drawn (left-masked)
			pop	hl	; adr0
			push	hl
			ex	de,hl
			and	a
			sbc	hl,de

			rr	h
			rr	l
			rr	h
			rr	l
			rr	h
			rr	l

			jr	z,onebyte	; area is within the same address...

			ld	b,l		; number of full bytes in a row
			pop	hl
			
			ld	de,8

			ld	(hl),a			; (offset) = (offset) AND bitmask0
			
			add	hl,de
			;inc	hl			; offset += 1 (8 bits)

.pattern2			ld	a,0
				dec	b
				jr	z,bitmaskr

.fill_row_loop							; do
				ld	(hl),a			; (offset) = pattern
				add	hl,de
				;inc	hl			; offset += 1 (8 bits)
				djnz	fill_row_loop		; while ( r-- != 0 )


.bitmaskr		ld	a,0
			call	mask_pattern
			ld	(hl),a

			jr	yloop


.onebyte	pop	hl
		ld	(pattern1+1),a
		jr	bitmaskr


		; Prepare an edge byte, basing on the byte mask in A
		; and on the pattern being set in (pattern1+1)
.mask_pattern
		ld	d,a		; keep a copy of mask
		and	(hl)		; mask data on screen
		ld	e,a		; save masked data
		ld	a,d		; retrieve mask
		cpl			; invert it
.pattern1	and	0		; prepare fill pattern portion
		or	e		; mix with masked data
		ret
