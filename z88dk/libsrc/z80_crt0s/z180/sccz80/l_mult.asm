

	SECTION   code_crt0_sccz80
	PUBLIC		l_mult

; Entry: hl = value1
;        de = value2
; Exit:  hl = value1 * value2

l_mult:
	ld  a,d     ; a = xh
	ld  d,h     ; d = yh
	ld  h,a     ; h = xh
	ld  c,e     ; c = xl
	ld  b,l     ; b = yl
	mlt de      ; yh * xl
	mlt hl      ; xh * yl
	add hl,de   ; add cross products
	mlt bc      ; yl * xl
	ld a,l      ; cross products LSB
	add a,b     ; add to MSB final
	ld h,a
	ld l,c      ; hl = final
	ret
