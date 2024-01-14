;
;	ZX Spectrum specific routines
;
;	int zx_interface1();
;
;	The result is:
;	- 0 (false) if the ZX Interface1 is missing
;	- 1 (true) if the ZX Interface1 is connected
;
;	This function has the side of loading the Interface 1
;	system variables if they aren't already present.
;
;	Shouldn't conflict with other interfaces.
;
;	$Id: zx_interface1.asm,v 1.3 2016-06-10 20:02:05 dom Exp $
;

	SECTION code_clib
	PUBLIC	zx_interface1
	PUBLIC	_zx_interface1
	EXTERN	if1_installed
	EXTERN	call_rom3

;IF FORts2068
;		INCLUDE  "target/ts2068/def/ts2068fp.def"
;ELSE
		INCLUDE  "target/zx/def/zxfp.def"
;ENDIF
	
zx_interface1:
_zx_interface1:
	ld	bc,($5c3d)
	push	bc		; save original ERR_SP
	ld	bc,return
	push	bc
	ld	($5c3d),sp	; update error handling routine

	; load zero to floating point stack
	rst	ZXFP_BEGIN_CALC
	defb	ZXFP_STK_ZERO
	defb	ZXFP_END_CALC
		
	call    call_rom3
;IF FORts2068
;	defw	$139F		; CLOSE	#0 (this should force IF1 to activate system variables)
;ELSE
	defw	$16e5		; CLOSE	#0 (this will force IF1 to activate system variables)
;ENDIF


	pop	bc

return:
	pop	bc
	ld	(iy+0),255	; reset ERR_NR

;	bit	0,(iy+124)	; test FLAGS3: coming from paged ROM ?
;	jr	nz,stderr
;	ld	(iy+124),0	; yes, reset FLAGS3
;stderr:

	ld	($5c3d),bc	; restore orginal ERR_SP

	jp	if1_installed
