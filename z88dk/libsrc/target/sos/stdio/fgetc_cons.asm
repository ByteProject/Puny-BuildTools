;
;	S-OS (The Sentinel) Japanese OS - Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato, 2013
;
;
;	$Id: fgetc_cons.asm,v 1.3 2016-06-12 17:32:01 dom Exp $
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

fgetc_cons:
_fgetc_cons:
	call	1FCAh
IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF
	ld	l,a
	ld	h,0
	ret
