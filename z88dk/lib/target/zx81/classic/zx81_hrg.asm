;       CRT0 for the ZX81 - HIGH RESOLUTION MODE (WRX trick by Wilf Rigter)
;
;       This code comes from the 'HRG_Tool'  by Matthias Swatosch
;       The Chroma81 version is also derived by the "SPONZY" ZX Spectrum emulator by Zsolt
;                (adapted to Chroma81 and z88dk by Kmurta and Olofsen)
;
;       Display handler modifications to preserve IY and 64 row mode by Stefano Bodrato
;
;
; - - - - - - -
;
;       $Id: zx81_hrg.def,v 1.26 2015-01-23 07:30:51 stefano Exp $
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


IF (((startup>=5)&(startup<13))|(startup>=25))
 IF ((startup=7)|(startup=27))
  IF DEFINED_MEM8K
    DEFC  TOPOFRAM    = $6000
    DEFC  BASE_VRAM   = $5000
    DEFC  NEW_RAMTOP  = $4F80
  ELSE
    DEFC  TOPOFRAM    = $8000
    DEFC  BASE_VRAM   = $7000
    DEFC  NEW_RAMTOP  = $6F80
  ENDIF
    DEFC  WHOLEMEM    = 4096+128   ; size of graphics map in grayscale mode
 ELSE
  IF DEFINED_MEM8K
    DEFC  TOPOFRAM    = $6000
    DEFC  BASE_VRAM   = $5800
    DEFC  NEW_RAMTOP  = $5780
  ELSE
    DEFC  TOPOFRAM    = $8000
    DEFC  BASE_VRAM   = $7800
    DEFC  NEW_RAMTOP  = $7780
  ENDIF
    DEFC  WHOLEMEM    = 2048+128   ; size of graphics map in 256x64 mode
 ENDIF
ELSE
 IF DEFINED_MEM8K
    DEFC  TOPOFRAM    = $6000
    DEFC  BASE_VRAM   = $4800
    DEFC  NEW_RAMTOP  = $4780
 ELSE
    DEFC  TOPOFRAM    = $8000
    DEFC  BASE_VRAM   = $6800
    DEFC  NEW_RAMTOP  = $6780
 ENDIF
    DEFC  WHOLEMEM    = 6144+128   ; size of graphics map in 256x192 mode
ENDIF

IF ((startup=3)|(startup=5)|(startup=23)|(startup=25))
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
        call    z,HRG_Interface_BaseRamtop	; if zero, make space and adjust ramtop for 16K
ENDIF
IF ((startup=7)|(startup=27))
        ld      hl,(base_graphics)
        ld      (graybit1),hl
	ld	de,2048
	add	hl,de
	ld	(graybit2),hl
        ld	(current_graphics),hl
ENDIF

zx_noblank:
_zx_noblank:
        ld      hl,HRG_handler  ; starts the hires mode when JP (IX) is made

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

zx_blank:
_zx_blank:
        ld      hl,HRG_BlankHandler
        jr    HRG_Sync

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

        INCLUDE "target/zx81/classic/zx81_altint_core.asm"
ENDIF

;----------------------------------------------------------------
;
; Entry for the HRG handler in blank mode
;
;----------------------------------------------------------------

HRG_BlankHandler:
IF (((startup>=5)&(startup<13))|(startup>=25))
        ld	a,107	; 52 + 55
        ;ld	a,200	; tweaked for speed
ELSE
        ld	a,247	; 192+55
        ;ld	a,255	; tweaked for speed
ENDIF
		ld (16424),a      ; MARGIN will ..cover the whole screen !
		jp HRG_postproc


;----------------------------------------------------------------
;
; This is the HRG handler
;
;----------------------------------------------------------------
;calculation of label above 32k

HRG_handler:
IF (startup>=23)		; CHROMA_81

		ld	bc,0            ; delay fine tuning here! Do not change!
		ld	bc,0
		ld	bc,0
		nop

ELSE					; WRX

        ld      b,6             ; delay sets the left edge of the screen
HRG_wait_left:
        djnz    HRG_wait_left   ; delay loop
        
        ld hl,0                 ; delay fine tuning here! Do not change!
        nop                     ; delay fine tuning here! Do not change!
                                ; (Originally the delay was obtained setting B to 7)

        dec     b               ; make Z flag=0

ENDIF
		
IF ((startup=7)|(startup=27))
        ld      hl,(current_graphics)
ELSE
        ld      hl,(base_graphics)
ENDIF


IF (startup>=23)		; CHROMA_81

		ld	(SAVE_SP),sp
		ld	sp,HRG_STACK
		ld	iy,HRG_LineStart+$8000
		ret

ELSE					; WRX

        ld      de,32           ; 32 bytes offset is added to HL for next hline
IF (((startup>=5)&(startup<13))|(startup>=25))
        ld      b,64            ; 64 lines per hires screen
ELSE
        ld      b,192            ; 192 lines per hires screen
ENDIF

HRG_outloop:
        ld      a,h             ; get HGR address MSB from HL
        ld      i,a             ; load MSB into I register which is RFSH address MSB
        ld      a,l             ; get HGR address LSB from HL
        call    HRG_LineStart+$8000
        add     hl,de           ; add 32 to HL to point to next hline
        dec     b               ; decrement line counter
        jp      nz,HRG_outloop  ; test for last line
ENDIF

; -------------------------------------------------------
;
HRG_postproc:

IF (startup>=23)		; CHROMA_81
		ld	sp,(SAVE_SP)
ENDIF
		;call   $0292          ; return to application program

; Different from original call to keep IY unchanged
; and to eventually add blank lines

        ld      iy,pointedbyix ; in ROM we'd have had a POP IX and JP IX as a 'return'
        ld      a,(16424)      ; 33 or 19 blank lines in bottom MARGIN

; this idea comes from the Wilf Rigter's WRX1K hi-resolution implementation
; if we run in 64 lines mode we need to increase the number of border's lines

IF (((startup>=5)&(startup<13))|(startup>=25))
        add     140             ; more blank lines for fast application code and correct sync
        			; Siegfried Engel reports that values between 80 and 159 worked
        			; fine on both a normal TV and an LCD one
ENDIF

        ld      c,a            ; load C with MARGIN
         ;ld      a,(16443)     ; test CDFLAG
         ;and     128
         ;bit     7,a
        and      a             ; setting zero flag is enough, 
                               ; ..we know MARGIN will always be > 0  ;)

        jp      $29b           ; save blank lines, start NMI, POP registers and RETURN

pointedbyix:        
        push    ix
        ld      ix,16384

        call    $0220          ; first PUSH register, then do VSYNC and get KEYBD

IF ((startup=3)|(startup=5))
        call    $0F46          ; check break (space) key
        jp      c,nobrkk
        ld      a,(hrgbrkflag)     ; set to '0' if program isn't running
        and	a
        jr	z,nobrkk
        SCF
nobrkk:
ENDIF

        pop     ix

IF ((startup=3)|(startup=5))
		jp		c,nobrkk2
        ld      a,$1e           ; the I register is restored with the MSB address
        ld      i,a             ; of the ROM pattern table in case of BREAK key down
        jp      $02A4
nobrkk2:
ENDIF

        ld    hl,($4034)        ; FRAMES, used also by clock handler
        dec   hl
        ld    ($4034),hl

IF ((startup=7)|(startup=27))
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
        jp      $02A4           ; now return to BASIC and other application programs

;----------------------------------------------------------------
;  Variables for grayscale graphics
;----------------------------------------------------------------

IF ((startup=7)|(startup=27))
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
; This is a dummy-line used for HRG output
;
;----------------------------------------------------------------
IF (startup<13)

HRG_LineStart:
        ld      r,a             ; load LSB to R register which is RFSH address LSB
        defb    0, 0, 0, 0      ; 32 NOPs = 32x8 bits = 256 pixels each HLINE
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret     nz              ; always returns because Z flag=0

ELSE		; CHROMA_81

HRG_LineStart:
        ld      r,a             ; load LSB to R register which is RFSH address LSB
        defb    0, 0, 0, 0      ; 32 NOPs = 32x8 bits = 256 pixels each HLINE
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret

HRG_LineStart01:
        ld      r,a
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret

HRG_LineStart02:
        ld      r,a
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret

HRG_LineStart03:
        ld      r,a
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret

HRG_LineStart04:
        ld      r,a
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret

HRG_LineStart05:
        ld      r,a
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret

HRG_LineStart06:
        ld      r,a
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret

HRG_LineStart07:
        ld      r,a
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret

HRG_LineStart08:
        ld      r,a
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret

HRG_LineStart09:
        ld      r,a
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret

HRG_LineStart0a:
        ld      r,a
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret

HRG_LineStart0b:
        ld      r,a
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret

HRG_LineStart0c:
        ld      r,a
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret

HRG_LineStart0d:
        ld      r,a
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret

HRG_LineStart0e:
        ld      r,a
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret

HRG_LineStart0f:
        ld      r,a
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret

HRG_LineStart10:
        ld      r,a
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret

HRG_LineStart11:
        ld      r,a
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret

HRG_LineStart12:
        ld      r,a
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret

HRG_LineStart13:
        ld      r,a
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret

HRG_LineStart14:
        ld      r,a
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret

HRG_LineStart15:
        ld      r,a
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret

HRG_LineStart16:
        ld      r,a
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret

HRG_LineStart17:
        ld      r,a
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        defb    0, 0, 0, 0
        ret

HRG_STACK:
	defw	HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA
	defw	HRGRB,HRG_LineStart01+$8000,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA
	defw	HRGRB,HRG_LineStart02+$8000,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA
	defw	HRGRB,HRG_LineStart03+$8000,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA
	defw	HRGRB,HRG_LineStart04+$8000,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA
	defw	HRGRB,HRG_LineStart05+$8000,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA
	defw	HRGRB,HRG_LineStart06+$8000,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA
	defw	HRGRB,HRG_LineStart07+$8000,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA
	defw	HRGRB,HRG_LineStart08+$8000,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA
	defw	HRGRB,HRG_LineStart09+$8000,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA
	defw	HRGRB,HRG_LineStart0a+$8000,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA
	defw	HRGRB,HRG_LineStart0b+$8000,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA
	defw	HRGRB,HRG_LineStart0c+$8000,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA
	defw	HRGRB,HRG_LineStart0d+$8000,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA
	defw	HRGRB,HRG_LineStart0e+$8000,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA
	defw	HRGRB,HRG_LineStart0f+$8000,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA
	defw	HRGRB,HRG_LineStart10+$8000,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA
	defw	HRGRB,HRG_LineStart11+$8000,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA
	defw	HRGRB,HRG_LineStart12+$8000,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA
	defw	HRGRB,HRG_LineStart13+$8000,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA
	defw	HRGRB,HRG_LineStart14+$8000,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA
	defw	HRGRB,HRG_LineStart15+$8000,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA
	defw	HRGRB,HRG_LineStart16+$8000,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA
	defw	HRGRB,HRG_LineStart17+$8000,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA,HRGRA
	defw	HRG_postproc

SAVE_SP:
	defw	0

HRGRA:
	ld	de,32
	ld	de,32
	nop
	ld	a,h
	ld	i,a
	ld	a,l
	add	hl,de
	jp	(iy)

HRGRB:
	pop	iy
	ld	de,32
	ld	a,h
	ld	i,a
	ld	a,l
	add	hl,de
	jp	(iy)

ENDIF

;----------------------------------------------------------------
;
; End of HRG handler
;
;----------------------------------------------------------------


IF !DEFINED_hrgpage
;--------------------------------------------------------------
;
; HRG_Interface_BaseRamtop
;
; checks if RAMTOP is set to 16k ram pack
; if so it lowers RAMTOP, copies stack and adapts all
; needed variables so that the program can continue with
; no need to issue a NEW command to redirect pointers.
; HRG base is set to the location over RAMTOP
;
;--------------------------------------------------------------
HRG_Interface_BaseRamtop:

        ld      hl,(RAMTOP)
        ld      de,TOPOFRAM     ;is RAMTOP in original 8k/16k position?
        xor     a
        sbc     hl,de
        ld      a,h
        or      l
        jr      z,HRG_Interface_BaseRamtopModify
        ld      hl,(RAMTOP)
        ld      de,NEW_RAMTOP    ;is RAMTOP already lowered?
        xor     a
        sbc     hl,de
        ld      a,h
        or      l               ;no, so this is a problem!
        jr      nz,HRG_Interface_BaseRamError

        ld      hl,BASE_VRAM      ;yes, then set base_graphics
        ld      (base_graphics),hl
        ret


HRG_Interface_BaseRamtopModify: 
        ld      hl,BASE_VRAM
        ld      (base_graphics),hl

        ld      hl,NEW_RAMTOP    ;lower RAMTOP
        ld      (RAMTOP),hl
        
        ld      hl,(ERR_SP)
        ld      de,WHOLEMEM
        xor     a
        sbc     hl,de
        ld      (ERR_SP),hl     ;lower ERR_SP


        ld      hl,$0000
        add     hl,sp           ;load SP into HL
        push    hl		; *** stack pointer
        ld      de,TOPOFRAM     ;prepare to copy the stack
        ex      de,hl
        xor     a
        sbc     hl,de
        ld      de,$0040
        add     hl,de           ;stackdeepth in HL
        push    hl
        pop     bc              ;stackdeepth in BC
        
        ld	hl,TOPOFRAM-1   ;make a copy of the stack
        ld      de,NEW_RAMTOP-1
        lddr

        pop     hl              ; *** stackpointer in HL
        ld      de,WHOLEMEM
        xor     a
        sbc     hl,de           ;lower the stackpointer
        ld      sp,hl           ;WOW!


HRG_Interface_BaseRamError:

        ;rst     $08             ;error
        ;defb    $1a             ;type R

	; Nothig is as expected: let's put graphics just above the actual RAMTOP
	; and cross fingers

        ld      hl,(RAMTOP)
        ld      (base_graphics),hl
        
        ret

ENDIF
