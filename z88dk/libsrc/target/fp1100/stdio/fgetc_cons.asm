
		MODULE	fgetc_cons
		SECTION	code_clib
		PUBLIC	fgetc_cons
		PUBLIC	_fgetc_cons
		EXTERN	getk

fgetc_cons:
_fgetc_cons:
	call	getk
	ld	a,h
	or	l
	jr	z,fgetc_cons
	ret
