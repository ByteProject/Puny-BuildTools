@ECHO OFF
SET Z88DK=Z:\Data\_code\_cWorkspace\z88dk.git

REM Change to git version
SET ZCCCFG=%Z88DK%\lib\config
SET PATH=%PATH%;%Z88DK%\bin

REM Which source file to compile?
SET PROGNAME=hello
REM SET PROGNAME=test
REM SET SRCPATH=..\
REM SET PROGNAME=eliza
REM SET PROGNAME=heapsort
REM SET PROGNAME=beepfx

REM Which model to compile for?
SET VGLMODEL=2000

REM Which model to use for emulation?
SET EMUMODEL=gl%VGLMODEL%

SET VGLOPTS=-subtype=%VGLMODEL%_rom_autostart
REM SET VGLOPTS=-subtype=payload
REM SET VGLOPTS=-subtype=%VGLMODEL%_rom


:COMPILE
REM Pre-Clean
DEL %PROGNAME%.bin

REM Use SCCZ80 compiler
SET ZCCCMD=zcc +vgl -vn -clib=new %VGLOPTS% %SRCPATH%%PROGNAME%.c -o %PROGNAME% -create-app

REM Use SDCC compiler (can not handle inline #asm/#endasm in C!)
REM SET ZCCCMD=zcc +vgl -vn -clib=sdcc_iy -SO3 --max-allocs-per-node200000 %PROGNAME%.c -o %PROGNAME% -create-app
REM SET ZCCCMD=zcc +vgl -v -clib=sdcc_iy -SO3 --max-allocs-per-node200000 %PROGNAME%.c -o %PROGNAME% -create-app


ECHO Running %ZCCCMD%
%ZCCCMD%
IF ERRORLEVEL 1 GOTO:ERROR
GOTO:NOERROR


:NOERROR
REM Post-Clean
DEL zcc_opt.def
DEL %PROGNAME%_BSS.bin
DEL %PROGNAME%_CODE.bin
DEL %PROGNAME%_DATA.bin
DEL %PROGNAME%_interrupt_vectors.bin

:EMU
CALL emu.bat %PROGNAME% %EMUMODEL%
GOTO:END


:ERROR
ECHO Compiler did not exit cleanly :-(

:END