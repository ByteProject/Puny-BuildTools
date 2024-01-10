;
; Small C z88 File functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
; 22 August 1998 ** UNTESTED **
;
; 11/3/99 Revised to allow input from stdin
;
; *** THIS IS A Z88 SPECIFIC ROUTINE!!! ***
;
; Is this better now garry?!?! djm 1/4/2000
;
; Now goes back to the correct print position
;
;
;	$Id: fgets_cons.asm,v 1.9 2016-07-02 13:52:45 dom Exp $
;

                INCLUDE "stdio.def"
                INCLUDE	"syspar.def"

		MODULE fgets_cons_z88
		SECTION	  code_clib

                PUBLIC    fgets_cons
                PUBLIC    _fgets_cons
                EXTERN    processcmd

;
; Read a string from the console
;
.fgets_cons
._fgets_cons
	xor	a
	ld	bc,nq_wcur
	call_oz(os_nq)		;gives x in c, y in b, preserves ix
	push	bc		;keep it
        ld      hl,4
        add     hl,sp
        ld      b,(hl)		;backwards cos OZ wants length in b
        inc     hl
	ld	a,b
	or	(hl)		;high byte of to read
        jr      z,fgets_abort   ;none required
        inc     hl              ;step up to buffer
        ld      e,(hl)          ;buffer
        inc     hl
        ld      d,(hl)
        ld      c,0             ;cursor position
        ld      a,8             ;allow return of ctrl chars
	dec	b		;decrement count so we can put in a \n
.loopyloo
        push    de              ;preserve buffer
        call_oz(gn_sip)		;preserves ix
        pop     hl
        push    af
        cp      $80
        jr      nc,fgets_gotcmd ; trapped a cmd
        pop     af
        jr      nc,fgets_stripeol
        jr      fgets_abort     ; return hl=0 - error

.fgets_gotcmd
        pop     af
        call    processcmd
.fgets_abort
	ld	hl,0
.fgets_out
	pop	bc	;xy posn
	ret

.fgets_stripeol
	cp	1		;escape
	jr	z,fgets_abort
        cp      13              ;terminating char
	jr	nz,fgets_unknown	;exit (NULL set by gn_sip)
; We now have to insert a \n into the line
	push	hl		;save hl
	ld	c,b
	ld	b,0
	add	hl,bc		;points to one beyond terminating NULL
	ld	(hl),0		;terminating null
	dec	hl
	ld	(hl),13		;put in the \n
	pop	hl		;get start of string back
	jr	fgets_out

.fgets_unknown
; Okay, unexpected thing, so go back in
; We've got ATP: hl=buffer
;		  b=line length (inputted)
;		  c=cursor position
	pop	de	;xy posn
	push	hl	;preserve stuff
	push	bc
	ld	hl,xystr
	call_oz(gn_sop)		;preserves ix
	ld	a,e
	add	a,32
	call_oz(os_out)		;preserves ix
	ld	a,d
	add	a,32
	call_oz(os_out)
	pop	bc
	pop	hl
	push	de	;keep xy posn on the stack once more
	ex	de,hl	;de=buffer now
	ld	hl,4	;cos we now have xy posn on stack
	add	hl,sp
	ld	b,(hl)	;max length of buffer
	ld	a,8 | 1	;return ctrl + buffer got data
	jr	loopyloo

	SECTION	rodata_clib

.xystr
	defb	1,'3','@',0
