;
;       SAM Coup� C Library
;
; 	ANSI Video handling for SAM Coup�
;
; 	Restors the attributes to previous setting
;	
;
;	Frode Tenneb� - 29/12/2002
;

        SECTION code_clib
	PUBLIC	ansi_restore
	
	EXTERN    FOREGR
	EXTERN    BACKGR

.ansi_restore
        ld      a,16            ; INK
        rst     16
        ld      a,(FOREGR)      ; fetch colour
        rst     16

        ld      a,17            ; PAPER
        rst     16
        ld      a,(BACKGR)      ; fetch colour
        rst     16

        ret
