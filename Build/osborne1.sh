#!/bin/bash
# builds Osborne 1 release

# NOTE: there is no real solution to play the generated image using emulation.
# This is a flaw in MAME, which currently is the only emulator supporting the
# Osborne-1. As of today it runs TD0 images only, generated through a preservation
# device. The raw disk format that CPMTOOLS puts out is very common and lots of
# emulators for different machines implement it. I hope Mame's support will add
# raw disk image formats in the future. It should notably support HFE and IMD but
# for whatever the reason is, it fails on these. However, you can quite easily
# make HFE or real disk from the provided image file to play the game on original
# hardware. This interpreter is modifed to work with the Osborne's escape codes
# and has a pretty beautiful presentation.

#read config file 
source config.sh

#cleanup
rm ${STORY}_osborne1.cpm

#copy resources
cp ./Interpreters/osborne1.cpm ./
mv osborne1.cpm ${STORY}_osborne1.cpm

#compile
${WRAPPER} ${STORY}.inf

#prepare story 
cp ${STORY}.z3 story.dat

#place story on disk image
cpmcp -f osborne1 ${STORY}_osborne1.cpm story.dat 0:story.dat
cpmls -f osborne1 ${STORY}_osborne1.cpm

#post cleanup
rm story.dat
