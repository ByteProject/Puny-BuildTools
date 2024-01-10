;--------------------------------------------------------------
; HRG screen effects
; for the ZX81
;--------------------------------------------------------------
;
;       Shift left the TV picture in hrg mode
;
;       Stefano - Oct 2011
;
;
;	$Id: hrg_tune_left.asm,v 1.3 2016-06-27 20:26:33 dom Exp $
;

		SECTION code_clib
                PUBLIC	hrg_tune_left
                PUBLIC	_hrg_tune_left
				
		EXTERN	HRG_Handler

hrg_tune_left:
_hrg_tune_left:
		ld	hl,HRG_Handler+1
		dec (hl)
		ret
