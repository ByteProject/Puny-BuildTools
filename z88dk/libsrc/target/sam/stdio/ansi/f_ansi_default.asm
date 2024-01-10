;
;       SAM Coup� C Library
;
; 	ANSI Video handling for SAM Coup�
;
; 	Sets the attributes to default
;	
;
;	Frode Tenneb� - 29/12/2002
;

        SECTION code_clib
	PUBLIC	ansi_default
	
.ansi_default
        ld      a,16            ; INK
        rst     16
        ld      a,7             ; default colour
        rst     16

        ld      a,17            ; PAPER
        rst     16
        xor     a               ; default colour
        rst     16

        ret

