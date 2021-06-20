#!/bin/bash
# builds Amstrad CPC / PCW release

#read config file 
source config.sh

#cleanup
rm ${STORY}_cpc_pcw.dsk

#copy resources
cp ./Interpreters/cpc_pcw.dsk ./
mv cpc_pcw.dsk ${STORY}.dsk

#compile
${WRAPPER} ${STORY}.inf

#prepare story 
cp ${STORY}.z3 STORY.DAT

#place autostart and story on disk image
echo -e "INTERPRE.COM\r" >PROFILE.SUB
idsk ${STORY}.dsk -i PROFILE.SUB -t 0
idsk ${STORY}.dsk -i STORY.DAT -t 0

#place loader and resources
cp ./Resources/DISC ./
idsk ${STORY}.dsk -i DISC
cp ./Resources/SCREEN ./
idsk ${STORY}.dsk -i SCREEN -t 1 -c c000
cp ./Resources/PAL ./
idsk ${STORY}.dsk -i PAL -t 1 -c a000

#post cleanup
rm PROFILE.SUB
rm STORY.DAT
rm DISC
rm SCREEN
rm PAL
mv ${STORY}.dsk ${STORY}_cpc_pcw.dsk
