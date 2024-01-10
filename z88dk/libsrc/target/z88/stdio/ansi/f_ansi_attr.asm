;
;       Spectrum C Library
;
; 	ANSI Video handling for z88
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;	The most difficult thing to port:
;	Be careful here...
;
;	djm 6/6/2000
;
;
;	$Id: f_ansi_attr.asm,v 1.6 2016-04-04 18:31:23 dom Exp $
;

	SECTION code_clib
	PUBLIC	ansi_attr

	EXTERN	invrs

	INCLUDE	"stdio.def"

.ansi_attr
        and     a
        jr      nz,noreset
	ld	a,1
	call_oz(os_out)
	ld	a,127
	call_oz(os_out)
        ret
.noreset
        cp      1
        jr      nz,nobold
	ld	hl,boldtxt
	call_oz(gn_sop)
        ret
.boldtxt
	defb	1,'2','+','B',0
.nobold
        cp      2
        jr      z,dim
        cp      8
        jr      nz,nodim
.dim
	ld	hl,dimtxt
	call_oz(gn_sop)
        ret
.dimtxt
	defb	1,'2','-','B',0
.nodim
        cp      4
        jr      nz,nounderline
	ld	hl,undertxt
	call_oz(gn_sop)
        ret
.undertxt
	defb	1,'2','+','U',0
.nounderline
        cp      24
        jr      nz,noCunderline
	ld	hl,noundertxt
	call_oz(gn_sop)
        ret
.noundertxt
	defb	1,'2','-','U',0
.noCunderline
        cp      5
        jr      nz,noblink
	ld	hl,blinktxt
	call_oz(gn_sop)
        ret
.blinktxt
	defb	1,'2','+','F',0
.noblink
        cp      25
        jr      nz,nocblink
	ld	hl,noblinktxt
	call_oz(gn_sop)
        ret
.noblinktxt
	defb	1,'2','-','F',0
.nocblink
        cp      7
        jr      nz,noreverse
	ld	hl,invstxt
	call_oz(gn_sop)
        ret
;        ld      (INVRS),a     ; inverse 1
.invstxt
	defb	1,'2','+','R',0
.noreverse
        cp      27
        jr      nz,noCreverse
	ld	hl,noinvstxt
	call_oz(gn_sop)
        ret
.noinvstxt
	defb	1,'2','-','R',0
.noCreverse
        cp      8
        jr      nz,noinvis
; Pass, make the text invisible..(tiny)
	ld	hl,tinytext
	call_oz(gn_sop)
        ret
.tinytext
	defb	1,'3','+','G','T',0
.noinvis
        cp      28
        jr      nz,nocinvis
; Pass, make text visible again
	ld	hl,notinytxt
	call_oz(gn_sop)
        ret
.notinytxt
	defb	1,'3','-','G','T',0
.nocinvis
	ret
