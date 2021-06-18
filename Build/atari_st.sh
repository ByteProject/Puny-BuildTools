#!/bin/bash
# builds Atari ST release

#read config file 
source config.sh

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
mkdir AUTO
cp Resources/INTRO.PRG ./AUTO/INTRO.PRG

#create ATARI disk image
zip -v ${STORY}.zip PLAY.PRG PLAY.PRG
zip -rv ${STORY}.zip STORY.DAT STORY.DAT
zip -rv ${STORY}.zip AUTO/INTRO.PRG AUTO/INTRO.PRG
zip2st ${STORY}.zip ${STORY}.st

#post cleanup
rm STORY.DAT
rm PLAY.PRG
rm ${STORY}.zip
rm -rf AUTO
mv ${STORY}.st ${STORY}_atarist.st
