;
;       SAM Coup� C Library
;
; 	ANSI Video handling for SAM Coup�
;
; 	CLS - Clear the screen
;	
;
;	Frode Tenneb� - 29/12/2002
;
;
;	$Id: f_ansi_cls.asm,v 1.3 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_cls

.ansi_cls
 	xor	a
	call	$014E
	ld	a,0xfe	;screen
	jp	$0112
