

#include <fcntl.h>

ssize_t write(int handle, void *buf, size_t len) __naked
{
#asm 
	EXTERN	asm_esxdos_f_write

	pop	af	;ret
	pop	bc	;size
	pop	hl	;ret
	pop	de	;file handle
	push	de
	push	hl
	push	bc
	push	af
	push	ix	;save users
	ld	a,e	; handle
	call	asm_esxdos_f_write
	pop	ix
	ret
#endasm
}

