/*
 *	Abandon a file (+3 DOS)
 *
 *	30/4/2001 djm
 *
 *	$Id: fabandon.c,v 1.4 2015-01-21 08:27:13 stefano Exp $
 */

#include <stdio.h>
#include <spectrum.h>

extern void __LIB__ freehand(int);

static int fabandon1(int fd);

void fabandon(FILE *fp)
{
	fabandon1(fp->desc.fd);
	fp->desc.fd=0;
	fp->flags=0;
	fp->ungetc=0;
}

static int fabandon1(int fd)
{
#asm
	INCLUDE	"target/zx/def/p3dos.def"
	EXTERN	dodos
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	b,l
	push	bc
	ld	iy,DOS_ABANDON
	push	ix
	call	dodos
	pop	ix
	pop	de
	ld	hl,-1	;error!
	ret	nc	;error
	ex	de,hl
	call	freehand
	ld	hl,0
#endasm
}


