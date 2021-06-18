#!/bin/bash
# builds ZX Spectrum +3 release

#read config file 
source config.sh

#cleanup
rm ${STORY}_speccy.dsk

#copy resources
cp ./Interpreters/Spec_SCRload.dsk ./
mv Spec_SCRload.dsk ${STORY}_speccy.dsk

#compile
${WRAPPER} ${STORY}.inf

#prepare story 
cp ${STORY}.z3 STORY.DAT

#place story on disk image
idsk ${STORY}_speccy.dsk -i STORY.DAT -t 0

#post cleanup
rm STORY.DAT
