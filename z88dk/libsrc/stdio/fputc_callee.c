/*
 *      New stdio functions for Small C+
 *
 *      djm 4/5/99
 *
 * --------
 * $Id: fputc_callee.c $
 */


#define ANSI_STDIO

#ifdef Z80
#define STDIO_ASM
#endif

#include <stdio.h>
#include <fcntl.h>



static void wrapper_fputc_callee() __naked
{
//#ifdef Z80
#asm
	PUBLIC	_fputc_callee
fputc_callee:
_fputc_callee:

    pop     de
    pop     hl	;fp
    pop     bc	;c
    push 	de

IF !__CPU_INTEL__ && !__CPU_GBZ80__
    push    ix
  IF __CPU_R2K__ | __CPU_R3K__
    ld      ix,hl
  ELSE
	push    hl
	pop     ix
  ENDIF
ENDIF
    call    asm_fputc_callee
IF __CPU_GBZ80__
    ld      d,h
    ld      e,l
ELIF !__CPU_INTEL__ 
    pop     ix
ENDIF
    ret
#endasm
}


static void wrapper_fputc_callee_z80() __naked
{
#asm
	PUBLIC	asm_fputc_callee

IF !__CPU_INTEL__ && !__CPU_GBZ80__
; Entry:	ix = fp
; 		bc = character to print
; Exit:		hl = byte written
asm_fputc_callee:
	ld	hl,-1	;EOF
	ld	a,(ix+fp_flags)
	and	a	;no thing
	ret	z

;	Check removed to allow READ+WRITE streams 
;	and	_IOREAD
;	ret	nz	;don`t want reading streams

	ld	a,(ix+fp_flags)
	and	_IOSTRING
	jr	z,no_string
	ld	e,(ix+fp_extra)
	ld	d,(ix+fp_extra+1)
	ld	a,d
	or	e
	jr	nz,print_char_to_buf
	ex	de,hl		;hl = 0
	dec	hl		;hl = -1, EOF
	ret
.print_char_to_buf
	dec	de
	ld	(ix+fp_extra),e
	ld	(ix+fp_extra+1),d
IF __CPU_R2K__ | __CPU_R3K__
	ld	hl,(ix+fp_desc)
ELSE
	ld	l,(ix+fp_desc)
	ld	h,(ix+fp_desc+1)
ENDIF
	ld	(hl),c
	inc	hl
IF __CPU_R2K__ | __CPU_R3K__
	ld	(ix+fp_desc),hl
ELSE
	ld	(ix+fp_desc),l
	ld	(ix+fp_desc+1),h
ENDIF
	ld	l,c	;load char to return
	ld	h,0
	ret
.no_string
	ld	a,(ix+fp_flags)
	and	_IOEXTRA
	jr	z,no_net
IF __CPU_R2K__ | __CPU_R3K__
	ld	hl,(ix+fp_extra)
ELSE
	ld	l,(ix+fp_extra)
	ld	h,(ix+fp_extra+1)
ENDIF
        ld      a,__STDIO_MSG_PUTC
	push	bc		;save byte writte
        call	l_jphl
	pop	hl		;return byte written
	ret
.no_net
	push	ix
	call	fchkstd	;preserves bc
	pop	ix
	jr	c,no_cons
; Output to console
	push	bc
	call	fputc_cons
	pop	hl
	ret
.no_cons
; Output to file
IF __CPU_R2K__ | __CPU_R3K__
	ld	hl,(ix+fp_desc)
ELSE
	ld	l,(ix+fp_desc)
	ld	h,(ix+fp_desc+1)
ENDIF
	push	hl	;fd
#ifdef __STDIO_BINARY
#ifdef __STDIO_CRLF
	ld	a,_IOTEXT	;check for text mode
	and	(ix+fp_flags)
	jr	z,no_binary
	ld	a,c		;load bytes
	cp	13
	jr	nz,no_binary
	push	bc	;c
	call	writebyte
	pop	bc
	ld	c,10
.no_binary
#endif
#endif
	push	bc	;c
	call	writebyte
	pop	hl	;discard values
	pop	bc	; fd
	ret
ENDIF
#endasm
}

static void wrapper_fputc_callee_8080() __naked
{
//#ifdef Z80
#asm
IF __CPU_INTEL__ | __CPU_GBZ80__
; Entry:	hl = fp
; 		bc = character to print
; Exit:		hl = byte written
asm_fputc_callee:
    ex      de,hl
    ld      hl,-1   ;EOF
    inc     de
    inc     de      ;fp_flags
    ld      a,(de)
    and     a       ;no thing
    ret     z
    and     _IOREAD
    ret     nz      ;don`t want reading streams
    ld      a,(de)
    and     _IOSTRING
    jr      z,no_string
    ex      de,hl
    dec     hl      ;fp_desc+1
    ld      d,(hl)
    dec     hl      ;&fp_desc
    ld      e,(hl)
    ld      a,c     ;store character
    ld      (de),a
    inc     de      ;inc pointer and store
    ld      (hl),e
    inc     hl      ;fp_desc+1
    ld      (hl),d
    ld      l,c     ;load char to return
    ld      h,0
    ret
.no_string
    dec     de
    dec     de      ;fp_desc
    push    de
    call    fchkstd ;preserves bc
    pop     de
    jr      c,no_cons
; Output to console
    push    bc
    call    fputc_cons
    pop     hl
    ret
.no_cons
; Output to file
    ex      de,hl
    ld      e,(hl)  ;fp_desc
    inc     hl
    ld      d,(hl)
    push    de      ;fd
    push    bc      ;c
    call    writebyte
    pop     bc      ;discard values
    pop     bc
	ret
ENDIF
#endasm
}
