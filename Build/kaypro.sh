#!/bin/bash
# builds Kaypro II / Kaypro 4 release

# NOTE: The raw disk format that CPMTOOLS puts out is very common and lots of
# emulators for different machines implement it. Mame currently does not support
# it, which severely limits the possibility of playing this via emulation. It's
# easy though to create HFE or real media from this raw disk image so that you
# may enjoy the game on original hardware.

#read config file 
source config.sh

#cleanup
rm ${STORY}_kaypro.cpm

#copy resources
cp ./Interpreters/kaypro.cpm ./
mv kaypro.cpm ${STORY}_kaypro.cpm

#compile
${WRAPPER} ${STORY}.inf

#prepare story 
cp ${STORY}.z3 game.dat

#place story on disk image
cpmcp -f kpii ${STORY}_kaypro.cpm game.dat 0:game.dat
cpmls -f kpii ${STORY}_kaypro.cpm

#post cleanup
rm game.dat
