#!/bin/bash
# builds MSX1 and MSX2 release 

#read config file 
source config.sh

#cleanup
rm ${STORY}_MSX.dsk

#compile
${WRAPPER} ${STORY}.inf

#prepare story 
cp ${STORY}.z3 STORY.DAT

#copy interpreter and resources
cp Interpreters/MSXTERP.DSK ./
cp Resources/LPIC.SC2 ./
mv MSXTERP.DSK ${STORY}_MSX.dsk

#create MSX disk image (720k)
#dsktool c 720 hibernated2_MSX.dsk

#copy files on MSX disk
dsktool a ${STORY}_MSX.dsk LPIC.SC2 STORY.DAT

#post cleanup
rm STORY.DAT
rm LPIC.SC2

