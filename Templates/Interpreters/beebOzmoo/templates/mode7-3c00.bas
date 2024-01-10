MODE 7
HIMEM=&3C00
IF INKEY-256<>-1 THEN PRINT "Sorry, BBC B only!":END
vdu_status=&D0
wrchv=&20E
keyv=&228
rts_opcode=&60
crtc_screen_start_high=12
crtc_cursor_start_high=14
crtc_register=&FE00
crtc_data=&FE01
FOR opt%=0 TO 2 STEP 2
P%=&900
[OPT opt%
.start
.nop_to_patch
nop
LDA #rts_opcode:STA nop_to_patch
\ We install a wrapper around OSWRCH which adjusts the CRTC cursor position
\ after every character output, otherwise the cursor is invisible.
LDA wrchv:STA call_old_wrchv+1
LDA wrchv+1:STA call_old_wrchv+2
LDA #our_oswrch MOD 256:STA wrchv
LDA #our_oswrch DIV 256:STA wrchv+1
\ In order to make cursor editing work, we need to adjust the CRTC cursor
\ position during that too. Hooking the keyboard timer interrupt is the best
\ way I've thought of to get a chance to do this.
LDA keyv:STA call_old_keyv+1
LDA keyv+1:STA call_old_keyv+2
LDA #our_keyv MOD 256:STA keyv
LDA #our_keyv DIV 256:STA keyv+1
RTS
\
.our_oswrch
.call_old_wrchv
JSR &FFFF \ patched
PHA
OPT FNadjust_cursor(opt%)
PLA
RTS
\
.our_keyv
BCC call_old_keyv
BVC call_old_keyv
\ keyboard timer interrupt entry
JSR call_old_keyv
PHP
PHA
BIT vdu_status
BVC not_cursor_editing
OPT FNadjust_cursor(opt%)
.not_cursor_editing
PLA
PLP
RTS
.call_old_keyv
JMP &FFFF \ patched
]
NEXT
CALL &900
:
VDU 28,0,24,39,0
PROCcrtc(crtc_screen_start_high, &20)
?&34E=&3C:REM high byte of bottom of screen memory
?&351=&3C:REM high byte display start address for 6845
PRINT CHR$(12);:REM force OS to pick up new settings
$&7C00="Hello, world!":REM note this doesn't appear on screen
PRINT "We're now in mode 7 with the screen RAM"'"at &3C00. The OS is happy, as long as wedon't do VDU 26. Cursor editing works"'"too."
END
:
DEF PROCcrtc(R%,V%)
VDU 23,0,R%,V%,0,0,0,0,0,0
ENDPROC
:
DEF FNadjust_cursor(opt%)
[OPT opt%
LDA #crtc_cursor_start_high:STA crtc_register
LDA &34B:SEC:SBC #&1C:STA crtc_data
]
=opt%
