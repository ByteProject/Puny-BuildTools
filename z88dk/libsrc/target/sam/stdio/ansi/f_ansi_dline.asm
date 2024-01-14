;
;       SAM Coup� C Library
;
; 	ANSI Video handling for SAM Coup�
;
;
; 	Clean a text line
;
;	Stefano Bodrato - Apr. 2000
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.3 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_del_line
 	EXTERN	ansi_default
	EXTERN	ansi_restore	
	
	EXTERN	__console_y
	
.ansi_del_line
 	ld	(__console_y),a

	call	ansi_default
	ld	b,32
.line
	ld	a,' '
	rst	16
	djnz	line

	jp	ansi_restore
	
