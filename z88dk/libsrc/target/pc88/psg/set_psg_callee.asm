;
;	PC-8801 specific routines
;
;	int set_psg(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg_callee.asm $
;

	SECTION code_clib
	PUBLIC	set_psg_callee
	PUBLIC	_set_psg_callee

	EXTERN	__psg_port
	
	PUBLIC ASMDISP_SET_PSG_CALLEE

	
set_psg_callee:
_set_psg_callee:

   pop hl
   pop de
   ex (sp),hl
	
.asmentry
	ld	bc,(__psg_port)
	
	ld	b,a
busyloop:
	in a,(c) 
	rlca 
	jr c, busyloop
	ld	a,b

	out	(c),l
	inc bc
	ld a,(ix+0)		; dummy instruction used to pause
	out	(c),e
	ret

DEFC ASMDISP_SET_PSG_CALLEE = asmentry - set_psg_callee
