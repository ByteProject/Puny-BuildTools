;       Z88 Small C+ Run time Library
;       l_gint variant to be used sometimes by the peephole optimizer
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_gintsp2de

l_gintsp2de:

	ex	de,hl
	pop	hl
	ex	(sp),hl
	ex	de,hl
	
	add hl,sp
	
;IF EZ80
;	defb	0xed, 0x27	;ld hl,(hl)
;ELSE

	ld a,(hl)
	inc     hl
	ld h,(hl)
	ld l,a
;ENDIF

	add	hl,hl		;*2
	add	hl,de
	
;IF EZ80
;	defb	0xed, 0x27	;ld	hl,(hl)
;ELSE
	ld a,(hl)
	inc     hl
	ld h,(hl)
	ld l,a
;ENDIF

	ret

