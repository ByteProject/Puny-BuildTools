

	SECTION	code_crt0_sccz80
	PUBLIC	l_mod
	EXTERN	___div16_bcde

; signed division
; hl = de/hl, de = de%hl
l_mod:
	; Delegate to the sdcc routine 
	; Entry BC=dividend, DE=divisor
	; Exit: BC=quotient, DE=remainder
	ld	c,l
	ld	b,h
	call	___div16_bcde
	ld	l,e
	ld	h,d
	ret
