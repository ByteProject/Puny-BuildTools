; $Id: bit_close.asm,v 1.3 2016-06-16 20:23:52 dom Exp $
;
; TRS-80 1 bit sound functions
;
; void bit_click();
;
; Stefano Bodrato - 8/4/2008
;

    SECTION code_clib
    PUBLIC     bit_close
    PUBLIC     _bit_close

.bit_close
._bit_close
          xor  a
          out  ($ff),a
          ret

