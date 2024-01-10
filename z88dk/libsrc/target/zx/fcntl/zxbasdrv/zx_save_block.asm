;
; Load a whole file by the BASIC driver
;
; Stefano - 28/06/2007
;
; int zx_save_block(char *name, void *addr, size_t len)
;
; $Id: zx_save_block.asm,v 1.3 2016-06-23 20:40:25 dom Exp $

	SECTION code_clib
	PUBLIC	zx_save_block
	PUBLIC	_zx_save_block
	
	EXTERN	zx_setint
	EXTERN	zx_goto
	EXTERN	zxgetfname



.zx_save_block
._zx_save_block

	pop	af
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl
	push	bc
	push	af
	
	push	hl
	push	bc

	ld	hl,lvar		; BASIC variable L
	push	hl
	push	de		; size
	call	zx_setint
	pop	de
	pop	hl

	pop	bc
	
	ld	hl,avar		; BASIC variable A
	push	hl
	push	bc		; ptr to address
	call	zx_setint
	pop	bc
	pop	hl

	call	zxgetfname	; HL is pointing to file name
	
	pop	hl

;7650 - SAVE block
;a=addess
;l=length
;d=drive number
;n$=file name

	ld	hl,7650
	call	zx_goto

	ld	a,l
	
	ld	hl,0
	and	a
	ret	z

	dec	hl
	ret

; BASIC variable name
	SECTION rodata_clib
.avar	defb 'A',0
.lvar	defb 'L',0
