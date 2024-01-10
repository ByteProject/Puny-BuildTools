
        MODULE  init_tt

        PUBLIC  init_vram
        PUBLIC  _init_vram
        PUBLIC  init_tt
        PUBLIC  _init_tt
        PUBLIC  init_wtt
        PUBLIC  _init_wtt
        PUBLIC  init_btt
        PUBLIC  _init_btt

        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"



	;; Initialize part (size = DE) of the VRAM at (HL) with B
init_vram:
_init_vram:
	LDH	A,(STAT)
	AND	0x02
	JR	NZ,init_vram

	LD	(HL),B
	INC	HL
	DEC	DE
	LD	A,D
	OR	E
	JR	NZ,init_vram
	RET

	;; Initialize window tile table with B
init_wtt:
_init_wtt:
	LDH	A,(LCDC)
	BIT	6,A
	JR	NZ,init_wtt1
	LD	HL,0x9800	; HL = origin
	JR	init_tt

init_wtt1:
	LD	HL,0x9C00	; HL = origin
	JR	init_tt
	;; Initialize background tile table with B
init_btt:
_init_btt:
	LDH	A,(LCDC)
	BIT	3,A
	JR	NZ,init_btt1
	LD	HL,0x9800	; HL = origin
	JR	init_tt
init_btt1:
	LD	HL,0x9C00	; HL = origin
;	JR	init_tt
init_tt:
_init_tt:
	LD	DE,0x0400	; One whole GB Screen
	JP	init_vram
