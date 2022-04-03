#!/bin/bash
# builds DEC Rainbow 100 release

# NOTE: The raw disk format that CPMTOOLS puts out is very common and lots of
# emulators for different machines implement it. Mame currently does not support
# it, which severely limits the possibility of playing this via emulation. It's
# easy though to create HFE or real media from this raw disk image so that you
# may enjoy the game on original hardware.

#read config file 
source config.sh

#cleanup
rm ${STORY}_decrainbow.cpm

#copy resources
cp ./Interpreters/decrainbow.cpm ./
mv decrainbow.cpm ${STORY}_decrainbow.cpm

#compile
${WRAPPER} ${STORY}.inf

#prepare story 
cp ${STORY}.z3 story.dat

#place story on disk image
cpmcp -f dec2 ${STORY}_decrainbow.cpm story.dat 0:story.dat
cpmls -f dec2 ${STORY}_decrainbow.cpm

#post cleanup
rm story.dat
