;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: deg.asm,v 1.4 2016-06-22 19:50:48 dom Exp $
;

                SECTION         smc_fp
		INCLUDE		"target/cpc/def/cpcfirm.def"
		INCLUDE		"target/cpc/def/cpcfp.def"

		PUBLIC		deg
		PUBLIC		degc



.deg	ld      a,1
        call    firmware
.degc   defw	CPCFP_FLO_DEG_RAD
		ret

