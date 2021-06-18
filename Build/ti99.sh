#!/bin/bash
# builds TI99/4a release

#read config file 
source config.sh

#cleanup
rm ${STORY}_ti99.dsk

#compile
${WRAPPER} ${STORY}.inf

#copy TI99/4a disk image template
cp Interpreters/ti994a.dsk ./
mv ti994a.dsk ${STORY}_ti99.dsk

#create TI99/4a story chunks
z3toTI994A ${STORY}.z3

#place files on TI99/4A disk image
tidisk --add=STRY1 ${STORY}_ti99.dsk
tidisk --add=STRY2 ${STORY}_ti99.dsk

#post cleanup
rm STRY1
rm STRY2
