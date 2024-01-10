; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_fillC(unsigned char attr, unsigned char lin, unsigned char col)

SECTION code_clib
SECTION code_nirvanap

PUBLIC _NIRVANAP_fillC

EXTERN asm_NIRVANAP_fillC

_NIRVANAP_fillC:

	ld hl,2
	add hl,sp
	ld c,(hl)       ; attr
	inc hl
	ld d,(hl)       ; lin
	inc hl
	ld e,(hl)       ; col
   
   jp asm_NIRVANAP_fillC
