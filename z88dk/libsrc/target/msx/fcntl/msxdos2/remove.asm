                SECTION code_clib


		INCLUDE	"target/msx/def/msxdos2.def"
		PUBLIC	remove
		PUBLIC	_remove

		EXTERN	MSXDOS
		EXTERN	msxdos_error

.remove
._remove
	ex	de,hl
	ld	c,$4d
	call	MSXDOS
	ld	(msxdos_error),a
	ld	hl,0
	and	a
	ret	z
	dec	hl
