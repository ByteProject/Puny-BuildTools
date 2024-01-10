;size_t read(int fd, void *ptr, size_t len)
;returns number of written bytes
;
;	$Id: read.asm,v 1.3 2016-06-23 20:31:34 dom Exp $
;

	SECTION code_clib
	PUBLIC	read
	PUBLIC	_read

.read
._read
	push	ix		;save caller
	LD	IX,4
	ADD	IX,SP
	LD	C,(IX+0)	;len
	LD	B,(IX+1)
	LD	L,(IX+2)	;ptr
	LD	H,(IX+3)
	LD	D,(IX+5)	;fd
	RST	8
	DEFB	$D4		;exits with BC=bytes read
	LD	L,C
	LD	H,B
	pop	ix		;restore caller
	RET
