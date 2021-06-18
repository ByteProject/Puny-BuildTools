#!/bin/bash
# builds a Macintosh Classic release

#read config file 
source config.sh

#cleanup
rm ${STORY}_mac.dsk

#copy resources
cp ./Interpreters/ClassicMac_MaxZip.dsk ./
mv ClassicMac_MaxZip.dsk ${STORY}_mac.dsk

#compile
${WRAPPER} ${STORY}.inf

#prepare story 
cp ${STORY}.z3 game.story

#place story on Macintosh 800k disk image
hmount ${STORY}_mac.dsk
hcopy game.story :
hls
humount

#post cleanup
rm game.story
