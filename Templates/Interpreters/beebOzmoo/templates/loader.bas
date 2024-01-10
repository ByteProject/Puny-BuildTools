REM SFTODO: Check SFTODOs etc in original loader as some of them may still be valid and need transferring across here

REM The loader uses some of the resident integer variables (or at least the
REM corresponding memory) to communicate with the Ozmoo executable. This
REM means it's probably least error prone to avoid using resident integer
REM variables gratuitously in this code.

REM As this code is not performance-critical, I have used real variables instead
REM of integer variables most of the time to shorten things slightly by avoiding
REM constant use of "%".

REM SFTODO: It would be nice if the loader and build system could work
REM together to allow the user to *optionally* specify a high-res title
REM screen before we go into the mode 7 loader.

REM SFTODO: Note that for Z3 games, anything shown on the top line of
REM the screen will remain present occupying the not-yet-displayed
REM status line until the game starts. This means that if any disc
REM errors occur during the initial loading, the screen may scroll
REM but the top line won't. This isn't a big deal but for the nicest
REM possible appearance in this admittedly unlikely situation either
REM clear the top line before running the Ozmoo executable or make
REM sure it has something that looks OK on its own. (For example,
REM *not* the top half of some double-height text.)

*FX229,1
*FX4,1
ON ERROR PROCerror

A%=&85:X%=135:potential_himem=(USR&FFF4 AND &FFFF00) DIV &100
!ifndef SPLASH {
REM With third-party shadow RAM on an Electron or BBC B, we *may* experience
REM corruption of memory from &3000 upwards when changing between shadow and
REM non-shadow modes. Normally !BOOT selects a shadow mode to avoid this
REM problem, but as a fallback (e.g. if we've been copied to a hard drive and
REM our !BOOT isn't in use any more) we re-execute ourself after switching to
REM shadow mode if we're not already in a shadow mode. This line of the program
REM will almost certainly be below &3000 so won't be corrupted by the switch.
IF potential_himem=&8000 AND HIMEM<&8000 THEN MODE 135:CHAIN "LOADER"
} else {
REM If we have a splash screen, the preloader has taken care of these issues.
REM We might be very tight for memory though; if we are, change to mode 135
REM early.
IF HIMEM-TOP<512 THEN MODE 135:VDU 23,1,0;0;0;0;
}

REM In a few places in the loader (not the Ozmoo binary) we assume printing at
REM the bottom right of the screen will cause a scroll. Override any "No Scroll"
REM configuration on a Master to make this assumption valid.
VDU 23,16,0,254,0;0;0;

fg_colour=${fg_colour}
bg_colour=${bg_colour}
screen_mode=${screen_mode}
DIM block% 256

REM Do the hardware detection (which is slightly slow, especially the sideways RAM
REM detection as that requires running a separate executable) before we change
REM screen mode; this way if there's a splash screen it's visible during this delay.
PROCdetect_swr
shadow=potential_himem=&8000
tube=PAGE<&E00
IF tube THEN PROCdetect_turbo

A%=0:X%=1:host_os=(USR&FFF4 AND &FF00) DIV &100:electron=host_os=0
MODE 135:VDU 23,1,0;0;0;0;
?fg_colour=${DEFAULT_FG_COLOUR}:?bg_colour=${DEFAULT_BG_COLOUR}
IF electron THEN VDU 19,0,?bg_colour,0;0,19,7,?fg_colour,0;0
IF electron THEN PROCelectron_header_footer ELSE PROCbbc_header_footer

normal_fg=${NORMAL_FG}:header_fg=${HEADER_FG}:highlight_fg=${HIGHLIGHT_FG}:highlight_bg=${HIGHLIGHT_BG}:electron_space=0
IF electron THEN normal_fg=0:header_fg=0:electron_space=32

REM We always report sideways RAM, even if it's irrelevant (e.g. we're on a
REM second processor and the game fits entirely in RAM or the host cache isn't
REM enabled), as it seems potentially confusing if we sometimes apparently
REM fail to detect sideways RAM.
PRINT CHR$header_fg;"Hardware detected:"
vpos=VPOS
IF tube THEN PRINT CHR$normal_fg;"  Second processor (";tube_ram$;")"
IF shadow THEN PRINT CHR$normal_fg;"  Shadow RAM"
IF swr$<>"" THEN PRINT CHR$normal_fg;"  ";swr$
IF vpos=VPOS THEN PRINT CHR$normal_fg;"  None"
PRINT
die_top_y=VPOS

PROCchoose_version_and_check_ram

!ifdef SPLASH {
REM Flush the keyboard buffer to reduce confusion if the user held down SPACE
REM or RETURN for a while in order to dismiss the loader screen.
*FX21
}

!ifdef AUTO_START {
IF tube OR shadow THEN ?screen_mode=${default_mode} ELSE ?screen_mode=7+electron
mode_keys_vpos=VPOS:PROCshow_mode_keys
} else {
IF tube OR shadow THEN PROCmode_menu ELSE ?screen_mode=7+electron:mode_keys_vpos=VPOS:PROCshow_mode_keys:PROCspace:REPEAT UNTIL FNhandle_common_key(GET)
}

IF ?screen_mode=7 THEN ?fg_colour=${DEFAULT_M7_STATUS_COLOUR}
PRINTTAB(0,space_y);CHR$normal_fg;"Loading, please wait...                ";
!ifdef CACHE2P_BINARY {
IF tube THEN */${CACHE2P_BINARY}
}
fs=FNfs
IF fs<>4 THEN path$=FNpath
REM Select user's home directory on NFS
IF fs=5 THEN *DIR
REM On non-DFS, select a SAVES directory if it exists but don't worry if it doesn't.
ON ERROR GOTO 1000
IF fs=4 THEN PROCoscli("DIR S") ELSE *DIR SAVES
1000ON ERROR PROCerror
REM On DFS this is actually a * command, not a filename, hence the leading "/" (="*RUN").
IF fs=4 THEN filename$="/"+binary$ ELSE filename$=path$+".DATA"
IF LENfilename$>=${filename_size} THEN PROCdie("Game data path too long")
REM We do this last, as it uses a lot of resident integer variable space and this reduces
REM the chances of it accidentally getting corrupted.
filename_data=${game_data_filename_or_restart_command}
$filename_data=filename$
*FX4,0
REM SFTODO: Should test with BASIC I at some point, probably work fine but galling to do things like PROCoscli and still not work on BASIC I!
IF fs=4 THEN PROCoscli($filename_data) ELSE PROCoscli("/"+path$+"."+binary$)
END

DEF PROCerror:CLS:REPORT:PRINT" at line ";ERL:PROCfinalise

DEF PROCdie(message$)
VDU 28,0,space_y,39,die_top_y,12
PROCpretty_print(normal_fg,message$)
PRINT
REM Fall through to PROCfinalise
DEF PROCfinalise
*FX229,0
*FX4,0
END

DEF PROCelectron_header_footer
VDU 23,128,0;0,255,255,0,0;
PRINTTAB(0,23);STRING$(40,CHR$128);"${OZMOO}";
IF POS=0 THEN VDU 30,11 ELSE VDU 30
PRINT "${TITLE}";:IF POS>0 THEN PRINT
PRINTSTRING$(40,CHR$128);
!ifdef SUBTITLE {
PRINT "${SUBTITLE}";:IF POS>0 THEN PRINT
}
PRINT:space_y=22
ENDPROC

DEF PROCbbc_header_footer
PRINTTAB(0,${FOOTER_Y});:${FOOTER}
IF POS=0 THEN VDU 30,11 ELSE VDU 30
${HEADER}
PRINTTAB(0,${MIDDLE_START_Y});:space_y=${SPACE_Y}
ENDPROC

DEF PROCchoose_version_and_check_ram
REM The tube build works on both the BBC and Electron, so we check that first.
!ifdef OZMOO2P_BINARY {
IF tube THEN binary$="${OZMOO2P_BINARY}":ENDPROC
} else {
IF tube THEN PROCunsupported_machine("a second processor")
}
PROCchoose_non_tube_version

REM For builds which can use sideways RAM, we need to check if we have enough
REM main RAM and/or sideways RAM to run successfully.
REM SFTODO: We shouldn't emit this block of code if we *only* support tube.
REM The use of 'p' in the next line is to work around a beebasm bug.
REM (https://github.com/stardot/beebasm/issues/45)
IF PAGE>max_page THEN PROCdie("Sorry, you need PAGE<=&"+STR$~max_page+"; it is &"+STR$~PAGE+".")
IF relocatable THEN extra_main_ram=max_page-PAGE:p=PAGE:?${ozmoo_relocate_target}=p DIV 256 ELSE extra_main_ram=0
swr_dynmem_needed=swr_dynmem_needed-&4000*?${ram_bank_count}
REM On the BBC extra_main_ram will reduce the need for sideways RAM for dynamic
REM memory, but on the Electron it is used as swappable memory only.
vmem_needed=${MIN_VMEM_BYTES}-extra_main_ram
IF electron AND swr_dynmem_needed>0 THEN PROCdie_ram(swr_dynmem_needed+FNmax(vmem_needed,0),"sideways RAM")
mem_needed=swr_dynmem_needed+vmem_needed
IF mem_needed>0 THEN PROCdie_ram(mem_needed,"main or sideways RAM")
ENDPROC

DEF PROCchoose_non_tube_version
!ifdef ONLY_80_COLUMN {
IF NOT shadow THEN PROCunsupported_machine("a machine without shadow RAM or a second processor")
}
!ifdef OZMOOE_BINARY {
IF electron THEN binary$="${OZMOOE_BINARY}":max_page=${OZMOOE_MAX_PAGE}:relocatable=${OZMOOE_RELOCATABLE}:swr_dynmem_needed=${OZMOOE_SWR_DYNMEM}:ENDPROC
} else {
IF electron THEN PROCunsupported_machine("an Electron")
}
!ifdef OZMOOSH_BINARY {
IF shadow THEN binary$="${OZMOOSH_BINARY}":max_page=${OZMOOSH_MAX_PAGE}:relocatable=${OZMOOSH_RELOCATABLE}:swr_dynmem_needed=${OZMOOSH_SWR_DYNMEM}:ENDPROC
} else {
REM OZMOOB_BINARY only works on a model B because of the mode-7-at-&3C00 trick,
REM so if we don't have OZMOOSH_BINARY we must refuse to work on anything
REM else.
IF host_os<>1 THEN PROCunsupported_machine("a BBC B+/Master")
}
!ifdef OZMOOB_BINARY {
binary$="${OZMOOB_BINARY}":max_page=${OZMOOB_MAX_PAGE}:relocatable=${OZMOOB_RELOCATABLE}:swr_dynmem_needed=${OZMOOB_SWR_DYNMEM}
} else {
!ifdef OZMOOSH_BINARY {
PROCunsupported_machine("a BBC B without shadow RAM")
} else {
PROCunsupported_machine("a BBC B")
}
}
ENDPROC

!ifndef AUTO_START {
DEF PROCmode_menu
DIM mode_x(8),mode_y(8)
REM It's tempting to derive mode_list$ from the contents of menu$, but it's more
REM trouble than it's worth, because it's shown (with inserted "/" characters)
REM on screen and for neatness we want it to be sorted into numerical order.
!ifdef ONLY_80_COLUMN {
max_x=1
max_y=0
DIM menu$(max_x,max_y),menu_x(max_x)
menu$(0,0)="0) 80x32"
menu$(1,0)="3) 80x25"
mode_list$="03"
}
!ifdef ONLY_40_COLUMN {
max_x=1
max_y=1
DIM menu$(max_x,max_y),menu_x(max_x)
IF electron THEN max_y=0:menu$(0,0)="4) 40x32":menu$(1,0)="6) 40x25":mode_list$="46" ELSE menu$(0,0)="4) 40x32":menu$(0,1)="6) 40x25":menu$(1,0)="7) 40x25   ":menu$(1,1)="   teletext":mode_list$="467"
}
!ifdef NO_ONLY_COLUMN {
max_x=2
max_y=1
DIM menu$(max_x,max_y),menu_x(max_x)
menu$(0,0)="0) 80x32"
menu$(0,1)="3) 80x25"
menu$(1,0)="4) 40x32"
menu$(1,1)="6) 40x25"
menu$(2,0)="7) 40x25   "
menu$(2,1)="   teletext"
IF electron THEN max_x=1:mode_list$="0346" ELSE mode_list$="03467"
}
REM The y loop here is done in reverse as VAL(" ") is 0 and we want to get the
REM second line of the mode 7 entry over with before it can corrupt the mode 0
REM entry, which will always be in the first line if it's present.
FOR y=max_y TO 0 STEP -1:FOR x=0 TO max_x:mode=VALLEFT$(menu$(x,y),1):mode_x(mode)=x:mode_y(mode)=y:NEXT:NEXT
PRINT CHR$header_fg;"Screen mode:";CHR$normal_fg;CHR$electron_space;"(hit ";:sep$="":FOR i=1 TO LEN(mode_list$):PRINT sep$;MID$(mode_list$,i,1);:sep$="/":NEXT:PRINT " to change)"
menu_top_y=VPOS
IF max_x=2 THEN gutter=0 ELSE gutter=5
FOR y=0 TO max_y:PRINTTAB(0,menu_top_y+y);CHR$normal_fg;:FOR x=0 TO max_x:menu_x(x)=POS:PRINT SPC2;menu$(x,y);SPC(2+gutter);:NEXT:NEXT
mode_keys_vpos=menu_top_y+max_y+2
mode$="${default_mode}":IF INSTR(mode_list$,mode$)=0 THEN mode$=RIGHT$(mode_list$,1)
x=mode_x(VALmode$):y=mode_y(VALmode$):PROChighlight(x,y,TRUE):PROCspace
REPEAT
old_x=x:old_y=y
key=GET
IF key=136 AND x>0 THEN x=x-1
IF key=137 AND x<max_x THEN x=x+1
IF key=138 AND y<max_y THEN y=y+1
IF key=139 AND y>0 THEN y=y-1
REM We don't set y if mode 7 is selected by pressing "7" so subsequent movement
REM with cursor keys remembers the old y position.
key$=CHR$key:IF INSTR(mode_list$,key$)<>0 THEN x=mode_x(VALkey$):IF NOT FNis_mode_7(x) THEN y=mode_y(VALkey$)
IF x<>old_x OR (y<>old_y AND NOT FNis_mode_7(x)) THEN PROChighlight(old_x,old_y,FALSE):PROChighlight(x,y,TRUE)
UNTIL FNhandle_common_key(key)
ENDPROC

DEF FNhandle_common_key(key)
IF electron AND key=2 THEN ?bg_colour=(?bg_colour+1) MOD 8:VDU 19,0,?bg_colour,0;0
IF electron AND key=6 THEN ?fg_colour=(?fg_colour+1) MOD 8:VDU 19,7,?fg_colour,0;0
=key=32 OR key=13

DEF PROChighlight(x,y,on)
IF on AND FNis_mode_7(x) THEN ?screen_mode=7 ELSE IF on THEN ?screen_mode=VAL(menu$(x,y))
IF on THEN PROCshow_mode_keys
IF electron THEN PROChighlight_internal_electron(x,y,on):ENDPROC
IF FNis_mode_7(x) THEN PROChighlight_internal(x,0,on):y=1
DEF PROChighlight_internal(x,y,on)
REM We put the "normal background" code in at the right hand side first before
REM (maybe) putting a "coloured backgroudn" code in at the left hand side to try
REM to reduce visual glitches.
IF x<2 THEN PRINTTAB(menu_x(x)+3+LENmenu$(x,y),menu_top_y+y);CHR$normal_fg;CHR$156;
PRINTTAB(menu_x(x)-1,menu_top_y+y);
IF on THEN PRINT CHR$highlight_bg;CHR$157;CHR$highlight_fg ELSE PRINT "  ";CHR$normal_fg
ENDPROC
DEF PROChighlight_internal_electron(x,y,on)
PRINTTAB(menu_x(x),menu_top_y+y);
IF on THEN COLOUR 135:COLOUR 0 ELSE COLOUR 128:COLOUR 7
PRINT SPC(2);menu$(x,y);SPC(2);
COLOUR 128:COLOUR 7
ENDPROC
}

REM This is not a completely general pretty-print routine, e.g. it doesn't make
REM any attempt to handle words which are longer than the screen width. It's
REM good enough for our needs.
REM
REM colour should be 0 or a teletext colour control code.
REM
REM The current X text cursor position will be used as the left margin for the
REM output; if colour<>0 there will be an additional one character indent.
DEF PROCpretty_print(colour,message$)
prefix$=CHR$colour+STRING$(POS," ")
i=1
VDU colour
REPEAT
space=INSTR(message$," ",i+1)
IF space=0 THEN word$=MID$(message$,i) ELSE word$=MID$(message$,i,space-i)
new_pos=POS+LENword$
IF new_pos<40 THEN PRINT word$;" "; ELSE IF new_pos=40 THEN PRINT word$; ELSE PRINT'prefix$;word$;" ";
IF POS=0 AND space<>0 THEN PRINT prefix$;
i=space+1
UNTIL space=0
IF POS<>0 THEN PRINT
ENDPROC

DEF PROCdetect_turbo
REM SFTODO: Can/should we detect this via modified A register with OSBYTE &84 instead? (We probably still need to enable turbo mode first.)
REM SFTODO: Once the Ozmoo executable has started poking non-0 into page 3, will BASIC crash on a soft-break? I suspect the re-enter language will disable turbo mode, but test this.
!&70=block%:?block%=0
P%=block%+1
[OPT 0
\ Set all banks to 0 to start with before turning turbo mode on.
\ (The Ozmoo executable relies on this, and if we didn't do it BASIC might crash
\ when its (zp),y accesses start accessing random banks once we've turned on
\ turbo mode.)
LDY #0:TYA
.loop
STA &300,Y
DEY:BNE loop
\ Try to turn turbo mode on.
LDA #&80:STA &FEF0
\ See if we do actually have multiple 64K banks available.
LDA #1:STA &371:STA (&70),Y
STY &371:LDA (&70),Y
\ Note that &371 is left as 0, so all banks are still 0.
RTS
]
turbo=(USR(block%+1) AND &FF)=0
IF turbo THEN tube_ram$="256K" ELSE tube_ram$="64K"
!ifdef ACORN_TURBO_SUPPORTED {
?${is_turbo}=turbo:REM we only care about bit 7 being set
}
ENDPROC

DEF PROCdetect_swr
*/FINDSWR
REM We use FNpeek here because FINDSWR runs on the host and we may be running on
REM a second processor.
swr_banks=FNpeek(${ram_bank_count}):swr$=""
IF FNpeek(${swr_type})>2 THEN swr$="("+STR$(swr_banks*16)+"K unsupported sideways RAM)"
IF swr_banks=0 THEN ENDPROC
swr$=STR$(swr_banks*16)+"K sideways RAM (bank":IF swr_banks>1 THEN swr$=swr$+"s"
swr$=swr$+" &":FOR i=0 TO swr_banks-1:swr$=swr$+STR$~FNpeek(${ram_bank_list}+i):NEXT:swr$=swr$+")"
ENDPROC

DEF PROCunsupported_machine(machine$):PROCdie("Sorry, this game won't run on "+machine$+".")
DEF PROCdie_ram(amount,ram_type$):PROCdie("Sorry, you need at least "+STR$(amount/1024)+"K more "+ram_type$+".")

DEF PROCshow_mode_keys
mode_7_no_hw_scroll=NOT (shadow OR tube OR electron)
!ifndef MODE_7_STATUS {
IF mode_7_no_hw_scroll THEN ENDPROC
}
mode_keys_last_max_y=mode_keys_last_max_y:REM set variable to 0 if it doesn't exist
IF mode_keys_last_max_y=0 THEN PRINTTAB(0,mode_keys_vpos);CHR$header_fg;"In-game controls:" ELSE PRINTTAB(0,mode_keys_vpos+1);
REM The odd indentation on the next few lines is so a) it's easy to see all the
REM different possible output lines have the same length and will completely
REM obliterate each other b) the build script will strip off the extra
REM indentation as it's at the start of the line.
                                PRINT CHR$normal_fg;"  SHIFT:  show next page of text"
!ifdef MODE_7_STATUS {
         IF ?screen_mode=7 THEN PRINT CHR$normal_fg;"  CTRL-F: change status line colour"
}
        IF ?screen_mode<>7 THEN PRINT CHR$normal_fg;"  CTRL-F: change foreground colour "
        IF ?screen_mode<>7 THEN PRINT CHR$normal_fg;"  CTRL-B: change background colour "
IF NOT mode_7_no_hw_scroll THEN PRINT CHR$normal_fg;"  CTRL-S: change scrolling mode    "
REM Clear any additional rows which we used last time but haven't used this time.
IF VPOS<mode_keys_last_max_y THEN PRINT SPC(40*(mode_keys_last_max_y-VPOS));
mode_keys_last_max_y=VPOS
ENDPROC

DEF PROCspace
PRINTTAB(0,space_y);CHR$normal_fg;"Press SPACE/RETURN to start the game...";
ENDPROC

DEF FNis_mode_7(x)=LEFT$(menu$(x,0),1)="7"

DEF PROCoscli($block%):X%=block%:Y%=X%DIV256:CALL&FFF7:ENDPROC

DEF FNpeek(addr):!block%=&FFFF0000 OR addr:A%=5:X%=block%:Y%=block% DIV 256:CALL &FFF1:=block%?4

DEF FNfs:A%=0:Y%=0:=USR&FFDA AND &FF

REM SFTODO: FNpath AND FNstrip CAN BE OMITTED IF THIS IS A DFS BUILD (THOUGH ULTIMATELY I REALLY MEAN "OSWORD 7F", AS IT MAY BE I WANT TO BUILD DFS-WITH-OSGBPB FOR INSTALL ON NFS INSTEAD OF HAVING TO VIA ADFS)
DEF FNpath
DIM data% 256
path$=""
REPEAT
block%!1=data%
A%=6:X%=block%:Y%=block% DIV 256:CALL &FFD1
name=data%+1+?data%
name?(1+?name)=13
name$=FNstrip($(name+1))
path$=name$+"."+path$
REM On Econet, you can't do *DIR ^ when in the root.
REM SFTODO: You can't always do *DIR ^ on Econet; can/should I try to work around this?
IF name$<>"$" AND name$<>"&" THEN *DIR ^
UNTIL name$="$" OR name$="&"
path$=LEFT$(path$,LEN(path$)-1)
?name=13
drive$=FNstrip($(data%+1))
IF drive$<>"" THEN path$=":"+drive$+"."+path$
PROCoscli("DIR "+path$)
=path$

DEF FNstrip(s$)
s$=s$+" "
REPEAT:s$=LEFT$(s$,LEN(s$)-1):UNTIL RIGHT$(s$,1)<>" "
=s$

DEF FNmax(a,b):IF a<b THEN =b ELSE =a
