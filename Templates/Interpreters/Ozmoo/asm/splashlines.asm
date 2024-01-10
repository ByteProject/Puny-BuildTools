splashline0 
	!pet "Spacewhale", 0
splashline1
	!pet "Interactive Fiction", 0
splashline2
	!pet "jpking.itch.io", 0
splashline3
	!pet "", 0
splashline4
!ifdef UNDO {
	!pet "          Ozmoo 13.5 with Undo",0
} else {
	!pet "               Ozmoo 13.5",0
}

splashline5
!ifndef NODARKMODE {
	!ifdef SCROLLBACK {
		!pet "        F1=Darkmode F5=Scrollback",0
	} else {
		!pet "               F1=Darkmode",0
	}
} else {
	!ifdef SCROLLBACK {
		!pet "              F5=Scrollback",0
	} else {
		!pet " ",0
	}
}
!ifdef UNDO {
!ifndef Z5PLUS {
SHOWUNDO=1
}
}

splashline6
!ifdef SHOWUNDO {
	!pet " Ctrl: D=Reset device# K=Key rpt U=Undo",0
} else {
	!pet "   Ctrl: D=Reset device# K=Key repeat",0
}

splashline7
!ifdef SMOOTHSCROLL {
	!pet "  0-8=Scroll slowness, 9=Smooth scroll",0
!ifdef TARGET_C128 {
splashline7alt
	!pet "           0-8=Scroll slowness",0
}
} else {
	!pet "           0-8=Scroll slowness",0
}


splash_index_col
	!byte 15, 11, 13, 0, 0, 0, 0, 0

