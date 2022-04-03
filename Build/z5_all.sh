#!/bin/bash
# builds all Z-machine v5 capable targets to z5:
# Commodore 64, Commodore Amiga, Atari ST, Spectrum Next, MS-DOS, BBC Micro, Apple 2, 
# Acorn Electron, Commodore 128, Mega 65, Commodore Plus/4, classic Macintosh.

#read config file 
source config.sh

############### Commodore 64 ###############

#cleanup
rm ${STORY}_c64.d64

#compile
${WRAPPER} -5 ${STORY}.inf
ruby Interpreters/Ozmoo/make.rb -t:c64 -dc:6:9 -cc:8 -ss1:"${LABEL}" -ss2:"Interactive Fiction" -ss3:"${SUBTITLE}" -sw:6 ${STORY}.z5

mv c64_${STORY}.d64 ${STORY}_c64.d64

############### Amiga ###############

#cleanup
rm ${STORY}_amiga.adf

#compile
${WRAPPER} -5 ${STORY}.inf

#prepare story 
cp ${STORY}.z5 Story.Data

#copy Amiga disk image template
cp Interpreters/amiga_Infocom_z5.adf ./
mv amiga_Infocom_z5.adf ${STORY}_amiga.adf

#add file to Amiga disk image
xdftool ${STORY}_amiga.adf write Story.Data

#post cleanup
rm Story.Data

############### Atari ST ###############

#cleanup
rm ${STORY}_atarist.st

#compile
${WRAPPER} -5 ${STORY}.inf

#prepare story 
cp ${STORY}.z5 STORY.DAT

#copy interpreter
cp Interpreters/ATARIST.PRG ./
mv ATARIST.PRG PLAY.PRG

#arrange resources
#mkdir AUTO
#cp Resources/INTRO.PRG ./AUTO/INTRO.PRG

#create ATARI disk image
zip -v ${STORY}.zip PLAY.PRG PLAY.PRG
zip -rv ${STORY}.zip STORY.DAT STORY.DAT
#zip -rv ${STORY}.zip AUTO/INTRO.PRG AUTO/INTRO.PRG
zip2st ${STORY}.zip ${STORY}.st

#post cleanup
rm STORY.DAT
rm PLAY.PRG
rm ${STORY}.zip
#rm -rf AUTO
mv ${STORY}.st ${STORY}_atarist.st

############### Spectrum Next ###############

# the Speccy Next has built-in support for z5 so you may
# distribute the z5 file directly

############### MS-DOS ###############

#copy resources
cp ./Interpreters/FROTZ.EXE ./Releases/DOS/PUDDLE.EXE

#compile
${WRAPPER} -5 ${STORY}.inf

#prepare story 
cp ${STORY}.z5 STORY.DAT

#place story in release directory
mv STORY.DAT ./Releases/DOS/

############### BBC Micro / Acorn Electron ###############

#cleanup
rm ${STORY}_bbc_elk.ssd

#compile
${WRAPPER} -5 ${STORY}.inf
cp ${STORY}.z5 ./Interpreters/beebOzmoo/
#cp ./Resources/screen.bbc ./Interpreters/beebOzmoo
cd Interpreters/beebOzmoo
#python make-acorn.py -v --splash-image screen.bbc --splash-mode 2 --title "${STORY}" --subtitle "${SUBTITLE}" --default-fg-colour 7 --default-bg-colour 0 --default-mode-7-status-colour 6 ${STORY}.z5
python make-acorn.py -v --title "${STORY}" --subtitle "${SUBTITLE}" --default-fg-colour 7 --default-bg-colour 0 --default-mode-7-status-colour 6 ${STORY}.z5
rm ${STORY}.z5
#rm screen.bbc
mv ${STORY}.ssd ${STORY}_bbc_elk.ssd
mv ${STORY}_bbc_elk.ssd ../../

cd ../../

############### Commodore 128 ###############

#cleanup
rm ${STORY}_c128.d71

#compile
${WRAPPER} -5 ${STORY}.inf
cp ${STORY}.z5 ${STORY}_c128.z5
#mv Interpreters/Ozmoo/asm/splashlines.tpl Interpreters/Ozmoo/asm/splashlines40.tpl
#mv Interpreters/Ozmoo/asm/splashlines80.tpl Interpreters/Ozmoo/asm/splashlines.tpl
ruby Interpreters/Ozmoo/make.rb -t:c128 -dc:6:9 -cc:8 -sw:6 ${STORY}_c128.z5
#mv Interpreters/Ozmoo/asm/splashlines.tpl Interpreters/Ozmoo/asm/splashlines80.tpl
#mv Interpreters/Ozmoo/asm/splashlines40.tpl Interpreters/Ozmoo/asm/splashlines.tpl

mv c128_${STORY}_c128.d71 ${STORY}_c128.d71

#remove obsolete files
rm ${STORY}_c128.z5

############### Mega65 ###############

#cleanup
rm ${STORY}_mega65.d81

#compile
${WRAPPER} -5 ${STORY}.inf
cp ${STORY}.z5 ./Interpreters/Ozmoo/
cd Interpreters/Ozmoo
#mv asm/splashlines.tpl asm/splashlines40.tpl
#mv asm/splashlines80.tpl asm/splashlines.tpl
ruby make.rb -t:mega65 -dc:6:9 -cc:8 -sw:6 ${STORY}.z5
#mv asm/splashlines.tpl asm/splashlines80.tpl
#mv asm/splashlines40.tpl asm/splashlines.tpl
rm ${STORY}.z5
mv mega65_${STORY}.d81 ${STORY}_mega65.d81
mv ${STORY}_mega65.d81 ../../

cd ../../

############### Commodore Plus/4 ###############

#cleanup
rm ${STORY}_plus4.d64

#copy resources
#cp Resources/picplus4.mb .

#compile
${WRAPPER} -5 ${STORY}.inf
cp ${STORY}.z5 ${STORY}_plus4.z5
ruby Interpreters/Ozmoo/make.rb -t:plus4 -dc:6:9 -cc:8 -ss1:"${LABEL}" -ss2:"Interactive Fiction" -ss3:"${SUBTITLE}" -sw:6 ${STORY}_plus4.z5
#ruby Interpreters/Ozmoo/make.rb -t:plus4 -i picplus4.mb -dc:6:9 -sc:8 -cc:8 -ss1:"${LABEL}" -ss2:"Interactive Fiction" -ss3:"${SUBTITLE}" -sw:6 ${STORY}_plus4.z5

mv plus4_${STORY}_plus4.d64 ${STORY}_plus4.d64

#append directory art
#cp Resources/dirart.d64 ./
#mv ${STORY}_plus4.d64 mergep4.d64
#d64merge mergep4.d64 dirart.d64 ${STORY}_plus4.d64

#remove obsolete files
rm ${STORY}_plus4.z5
#rm mergep4.d64
#rm dirart.d64
#rm picplus4.mb

############### Classic Macintosh ###############

#cleanup
rm ${STORY}_mac.dsk

#copy resources
cp ./Interpreters/ClassicMac_MaxZip.dsk ./
mv ClassicMac_MaxZip.dsk ${STORY}_mac.dsk

#compile
${WRAPPER} -5 ${STORY}.inf

#prepare story 
cp ${STORY}.z5 game.story

#place story on Macintosh 800k disk image
hmount ${STORY}_mac.dsk
hcopy game.story :
hls
humount

#post cleanup
rm game.story

############### Apple II ###############

#cleanup
rm ${STORY}_apple2_s1.dsk
rm ${STORY}_apple2_s2.dsk

#compile
${WRAPPER} -5 ${STORY}.inf

#create disk image
interlz5 ./Interpreters/info5a.bin ${STORY}.z5 ${STORY}_apple2_s1.dsk
interlz5 ./Interpreters/info5a.bin ${STORY}.z5 ${STORY}_apple2_s1.dsk ${STORY}_apple2_s2.nib

############### TRS-80 Model 4 ###############

#cleanup
rm ${STORY}_trs80_m4.dsk

#compile
${WRAPPER} -5 ${STORY}.inf

#prepare story 
cp ${STORY}.z5 STORY.DAT

#copy disk template with interpreter
cp Interpreters/TRS80_M4.dsk $toolswin

#move story file on Windows partition
mv STORY.DAT $toolswin

#write story file on TRS-80 Model 3 (LDOS) disk image
/mnt/c/Program\ Files/PowerShell/7/pwsh.exe -Command "C:/FictionTools/trswrite.exe C:/FictionTools/TRS80_M4.dsk C:/FictionTools/STORY.DAT"
printf "\n" # only cosmetical
/mnt/c/Program\ Files/PowerShell/7/pwsh.exe -Command "C:/FictionTools/trsread.exe -v C:/FictionTools/TRS80_M4.dsk"

#grab prepared image from Windows partition and place it in project directory
mv $toolswin/TRS80_M4.dsk .

#post cleanup
rm $toolswin/STORY.DAT
mv TRS80_M4.dsk ${STORY}_trs80_m4.dsk
