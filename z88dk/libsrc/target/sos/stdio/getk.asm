;
;	S-OS (The Sentinel) Japanese OS - Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato, 2013
;
;
;	$Id: getk.asm,v 1.3 2016-06-12 17:32:01 dom Exp $
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

.getk
._getk
	call	1FD0h
IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF
	ld	l, a
	ld	h,0
	ret
