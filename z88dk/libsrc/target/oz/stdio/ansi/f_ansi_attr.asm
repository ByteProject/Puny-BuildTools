;
; 	ANSI Video handling for Sharp OZ family
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;
;	Stefano Bodrato - Aug. 2002
;
;	$Id: f_ansi_attr.asm $
;

        SECTION code_clib
	PUBLIC	ansi_attr

	EXTERN	INVRS
	EXTERN	BOLD

.ansi_attr
        and     a
        jr      nz,noreset
        ld	(BOLD),a
        ld	(BOLD+1),a
        ret
.noreset
        cp      1
        jr      nz,nobold
        ld	a,23
        ld	(BOLD),a
        ld	a,182
        ld	(BOLD+1),a
        ret
.nobold
        cp      2
        jr      z,dim
        cp      8
        jr      nz,nodim
.dim
	xor	a
        ld	(BOLD),a
        ld	(BOLD+1),a
        ret
.nodim
        cp      4
        jr      nz,nounderline
        ld      a,32
        ld      (INVRS+2),a   ; underline 1
        ret
.nounderline
        cp      24
        jr      nz,noCunderline
        ld      a, 24
        ld      (INVRS+2),a   ; underline 0
        ret
.noCunderline
        cp      5
        jr      nz,noblink
        ld      a,32
        ld      (INVRS+2),a   ; underline (blink emulation) 1
        ret
.noblink
        cp      25
        jr      nz,nocblink
        ld      a, 24
        ld      (INVRS+2),a   ; underline (blink emulation) 0
        ret
.nocblink
        cp      7
        jr      nz,noreverse
        ld      a,47
        ld      (INVRS),a     ; inverse 1
        ret
.noreverse
        cp      27
        jr      nz,noCreverse
        xor     a
        ld      (INVRS),a      ; inverse 0
        ret
.noCreverse
        ret
