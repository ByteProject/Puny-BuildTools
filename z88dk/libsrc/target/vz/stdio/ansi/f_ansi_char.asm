;
; 	ANSI Video handling for the VZ200
;
;	set it up with:
;	.__console_w	= max columns
;	.__console_h	= max rows
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.4 2016-06-10 23:56:01 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_CHAR
	
	EXTERN	__console_y
	EXTERN	__console_x
	
	EXTERN	vz_inverse


.ansi_CHAR

; 193 Inverse characters starting from "@".
; 64  "@" char (as normal).
; 127-192 Pseudo-Graphics Chars (like ZX81)

	; Some undercase text?  Transform in UPPER !
	cp	97
	jr	c,isupper
	sub	32
.isupper
	and	@00111111
	ld	hl,vz_inverse
	or	(hl)

.setout
	push	af
	ld	hl,$7000
	ld	a,(__console_y)
	and	a
	jr	z,r_zero
	ld	b,a
	ld	de,32
.r_loop
	add	hl,de
	djnz	r_loop
.r_zero
	ld	a,(__console_x)
	ld	d,0
	ld	e,a
	add	hl,de
	pop	af
	ld	(hl),a
	ret

