;       CRT0 for the ZX81 - HIGH RESOLUTION MODE (arx816 trick by Andy Rea)
;       Display handler modifications (to preserve IY) by Stefano Bodrato
;
;
; - - - - - - -
;
;       $Id: zx81_hrg_arx.def,v 1.13 2015-07-07 07:11:17 stefano Exp $
;
; - - - - - - -

PUBLIC	hrg_on
PUBLIC	_hrg_on
PUBLIC	hrg_off
PUBLIC	_hrg_off
PUBLIC	HRG_LineStart
PUBLIC	HRG_handler
PUBLIC	zx_blank
PUBLIC	_zx_blank
PUBLIC	zx_noblank
PUBLIC	_zx_noblank
PUBLIC	zx_fast
PUBLIC	_zx_fast
PUBLIC	zx_slow
PUBLIC	_zx_slow


IF ((startup=13)|(startup=15))
hrgbrkflag:
        defb    0
ENDIF

;--------------------------------------------------------------
;--------------------------------------------------------------

;------------------------------------------
;
;   ZX81 system variables
;
;------------------------------------------
;DEFC   ERR_NR  = 16384 ;byte   one less than the report code
;DEFC   FLAGS   = 16385 ;byte   flags to control the BASIC system.
;DEFC   MODE    = 16390 ;byte   Specified K, L, F or G cursor.
;DEFC   PPC     = 16391 ;word   Line number of statement currently being executed

DEFC    ERR_SP  = 16386 ;word   Address of first item on machine stack (after GOSUB returns).
DEFC    RAMTOP  = 16388 ;word   Address of first byte above BASIC system area. 


;----------------------------------------------------------------
;
; Enter in FAST mode 
;
;----------------------------------------------------------------
zx_fast:
_zx_fast:
	call restore81
	jp	$F23		; FAST !

;----------------------------------------------------------------
;
; Switch to HRG mode 
; "base_graphics" has to point to a reasonable adress
;
;----------------------------------------------------------------
zx_slow:
_zx_slow:
hrg_on:
_hrg_on:
		call   restore81
		call   $F2B	; SLOW
IF !DEFINED_hrgpage
        ld      hl,(base_graphics)
        ld      a,h
        or      l
        jr      nz,no_default_base
        ld      hl,$2000      ; set base_graphics
        ld      (base_graphics),hl
.no_default_base
ENDIF
IF (startup=17)
        ld  hl,(base_graphics)
        ld	(graybit1),hl
        ld	de,$2000
        add	hl,de
        ld	(graybit2),hl
        ld	(current_graphics),hl
ENDIF

;----------------------------------------------------------------
zx_noblank:
_zx_noblank:
        ld      hl,HRG_handler  ; starts the hires mode when JP (IX) is made
        call	HRG_Sync
IF (startup<15)
		ld	a,-8
		ld	(HRG_blank_patch+1),a
ENDIF
        ret

;----------------------------------------------------------------
zx_blank:
_zx_blank:
        ld      hl,HRG_BlankHandler
        call	HRG_Sync
IF (startup<15)
		ld	a,140-8
		ld	(HRG_blank_patch+1),a
ENDIF
        ret

;----------------------------------------------------------------
;
; Switch to TXT mode
;
;----------------------------------------------------------------
hrg_off:
_hrg_off:
IF DEFINED_noslowfix
		jp		zx_fast
ELSE
		call	hrg_on     ; restore registers and make sure we are in SLOW mode

        ld      hl,L0281    ; switch back to text (fixed video routine)

        call	HRG_Sync
        ld      a,$1e
        ld      i,a
        ret
ENDIF

;----------------------------------------------------------------
;
; Sync display before mode switching
;
;----------------------------------------------------------------
HRG_Sync:
        push   hl
        ld     a,(16443)	; test CDFLAG
        and    128			; is in FAST mode ?
        jr     z,nosync
        ld     hl,$4034        ; FRAMES counter
        ld     a,(hl)          ; get old FRAMES
HRG_Sync1:
        cp     (hl)            ; compare to new FRAMES
        jp     z,HRG_Sync1     ; exit after a change is detected
nosync:
        pop    hl
        push   hl
        ld     (HRG_handler_patch+2),hl
        pop    iy
        ret


IF !DEFINED_noslowfix
        INCLUDE "zx81_altint_core.asm"
ENDIF
        

;----------------------------------------------------------------
;
; Entry for the HRG handler in blank mode
;
;----------------------------------------------------------------

HRG_BlankHandler:
        ld	a,123	; 52+8+8+55	..work always in 64 rows mode
                    ; to stay in the counter range   ;)
		ld (16424),a      ; MARGIN will ..cover the whole screen !
		jp HRG_postproc

;----------------------------------------------------------------
;
; This is the HRG handler
;
; I need to sync my lines with the ULA row counter the effect
; is to slow down basic execution a bit, not sure how much but
; it's effectively 8 scanlline
;
;----------------------------------------------------------------

HRG_handler:
        ld      b,120           ; delay sets the left edge of the screen (was 6 on WRX)
								; Between here and the first execution of the
                                ; LineStart bytes, total delay is equal to 8 scanlines.
HRG_wait_left:
        djnz    HRG_wait_left 
        inc     bc              ;
        nop                     ; 4 T delay fine tuning here!
								; (is it really needed ?)

        ld      d,8
IF (startup>=15)
        ld      b,4             ; 64 /8 scanlines /2 buffers ?
ELSE
        ld      b,12            ; 192 /8 scanlines /2 buffers ?
ENDIF
        ld      c,d

IF (startup=17)                 ; 
        ld      a,(current_graphics+1)   ; 13 T We will get the MSB, $20 or $40
ELSE
        ld      a,$20                    ; 7 T
ENDIF
        ld      i,a             ; load MSB into I register which is RFSH address MSB


HRG_outloop1:
        call    HRG_LineStart+$8000
        nop                     ; 159 t states so far (138 from 1st buffer) timing
        dec     c               ;
        jp      z,HRG_outloop2
        ld      a,i             ; this way if not 8 scanlines
        ld      a,i
        nop
        jr      HRG_outloop1

HRG_outloop2:                   ; this route is taken if 8 scanlines have been completed.
        ld      a,i             ; just timing stuff
        inc     bc
        inc     bc
        ld      c,d
        ld      a,i
        
HRG_outloop3:                             ; start of the second inner loop
        call    HRG_LineStart2+$8000      ; fire the second "character row"
        dec     c                         ; 159 t states (138 from 2nd buffer)
        jp      z,HRG_outloop4
        ld      a,i             ; this way if not 8 scanlines
        ld      a,i
        inc     a               ; increment A by two,
        inc     a               ; ready for the other branch
        jr      HRG_outloop3
        
HRG_outloop4:
        ld      c,d             ; reset scan line counter
        ld      i,a             ; set i to next 512 byte block#
        ld      a,(hl)
        nop
        dec     b
        jp      nz,HRG_outloop1

; -------------------------------------------------------
; 
HRG_postproc:

        ;call   $0292          ; return to application program

; Different from original call to keep IY unchanged
; and to eventually add blank lines
        ld      iy,pointedbyix ; in ROM we'd have had a POP IX and JP IX as a 'return'
        ld      a,(16424)      ; 33 or 19 blank lines in bottom MARGIN

; this idea comes from the Wilf Rigter's WRX1K hi-resolution implementation
; if we run in 64 lines mode we need to increase the number of border's lines

HRG_blank_patch:	; WARNING: the values change due to the patching, don't tune here !!
IF (startup>=15)
        add     140-8    ; more blank lines for fast application code and correct sync
        			; For the WRX version Siegfried Engel reports that values between 
        			; 80 and 159 worked fine on both a normal TV and an LCD one
ELSE
        add		-8             ; reduce by 8 scan lines
ENDIF

        ld      c,a            ; load C with MARGIN
        ; ld      a,(16443)     ; test CDFLAG
        ; bit     7,a
        and      a             ; setting zero flag is enough, 
                               ; ..we know MARGIN will always be > 0  ;)

        jp      $29b           ; save blank lines, start NMI, POP registers and RETURN

pointedbyix:
        push    ix
        ld      ix,16384

        ld    hl,($4034)        ; FRAMES, used also by clock handler
        dec   hl
        ld    ($4034),hl

        call    $0220          ; first PUSH register, then do VSYNC and get KEYBD

IF ((startup=13)|(startup=15))
        call    $0F46          ; check break (space) key
        jp      c,nobrkk
        ld      a,(hrgbrkflag)     ; set to '0' if program isn't running
        and	a
        jr	z,nobrkk
        SCF
nobrkk:

ELSE
IF (startup=14)
        SCF
ENDIF
        nop
        nop
        nop
ENDIF

        pop     ix

IF ((startup=13)|(startup=15))
		jp		c,nobrkk2
        ld      a,$1e           ; the I register is restored with the MSB address
        ld      i,a             ; of the ROM pattern table in case of BREAK key down
        jp      $02A4
nobrkk2:
ENDIF

IF (startup=17)
	ld	hl,gcount
	;res	7,(hl)
	inc	(hl)
	ld	a,(hl)
	dec	a
	jp	z,Display_pic1
	dec	a
	jp	z,Display_pic2
	ld	(hl),0
Display_pic1:
	ld	hl,(graybit1)
	jp	setpage
Display_pic2:
	ld	hl,(graybit2)
setpage:
	ld	(current_graphics),hl
ENDIF

HRG_handler_patch:
        ld      iy,HRG_handler  ; reload vector if no BREAK or else SINCLAIR video
        ld      a,(16424)      ; 33 or 19 blank lines in bottom MARGIN
        sub     8              ; reduce by 8 scan lines

        jp      $029e           ; now update A', start NMI, POP registers and return to BASIC/programs

;----------------------------------------------------------------
;  Variables for grayscale graphics
;----------------------------------------------------------------

IF (startup=17)
		PUBLIC	graybit1
		PUBLIC	graybit2
gcount:
		defb	0
current_graphics:
		defw	0
graybit1:
		defw	0
graybit2:
		defw	0
ENDIF

;----------------------------------------------------------------
;
;	because of the way this ram is addressed during refresh
;	we need 2 dummy d-file lines, the first to do even character
;	rows, the second to do odd character rows. So basically the
;	h-file is laid out like 12 consecutive character maps.
;
;	each buffer is called 8 times as video bytes
;	both repeated 12 times in total,
;	(8+8)*12=192 scanlines.
;
;----------------------------------------------------------------

HRG_LineStart:
	defb 00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15
	defb 16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
	ret

HRG_LineStart2:
	defb 32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47
	defb 48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63
	ret


;----------------------------------------------------------------
;
; End of HRG handler
;
;----------------------------------------------------------------

