#!/bin/bash
# builds Oric release

#read config file 
source config.sh

#cleanup
rm ${STORY}_oric_1.dsk
rm ${STORY}_oric_2.dsk

#copy resources
cp ./Interpreters/pinforic.dsk ./
mv pinforic.dsk ${STORY}_oric_1.dsk

#compile
${WRAPPER} ${STORY}.inf

#prepare story file
cp ${STORY}.z3 STORY.DAT

#create raw DOS disk image
mkdosfs -C ${STORY}_oric_2.dsk 360

#copy story file on disk
mcopy -i ${STORY}_oric_2.dsk STORY.DAT ::STORY.DAT

#create Oric disk from raw DOS disk image
raw2mfm ${STORY}_oric_2.dsk

#post cleanup
rm STORY.DAT
