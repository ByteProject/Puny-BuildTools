;
; 	ANSI Video handling for the TS2068 64 columns
;	By Stefano Bodrato - May 2011
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;	The most difficult thing to port:
;	Be careful here...
;
;
;	$Id: f_ansi_attr64.asm,v 1.4 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_attr

	EXTERN	INVRS
	EXTERN	BOLD
	EXTERN	UNDERLINE

.ansi_attr
        and     a
        jr      nz,noreset
        ld	(BOLD),a
        ld	(BOLD+1),a
        ld      (INVRS),a      ; inverse 0
        ld      a, 201
        ld      (UNDERLINE),a ; ret - underline 0
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
        xor     a
        ld      (UNDERLINE),a ; nop - underline 1
        ret
.nounderline
        cp      24
        jr      nz,noCunderline
        ld      a, 201
        ld      (UNDERLINE),a; ret - underline 0
        ret
.noCunderline
        cp      5
        jr      nz,noblink
        xor     a
        ld      (UNDERLINE),a ; nop - underline (blink emulation) 1
        ret
.noblink
        cp      25
        jr      nz,nocblink
        ld      a, 201
        ld      (UNDERLINE),a; ret - underline (blink emulation) 0
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
