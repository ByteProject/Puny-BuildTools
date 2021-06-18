#!/bin/bash
# builds VIC-20 and PET release

#read config file 
source config.sh

#cleanup
rm ${STORY}_vic20_pet.d64

#compile
${WRAPPER} ${STORY}.inf

#create disk image for all versions except C64
c1541 -format "${STORY},if" D64 "${STORY}_vic20_pet.d64" 8
c1541 -attach "${STORY}_vic20_pet.d64" -write Interpreters/z3-vic "game-vic"
c1541 -attach "${STORY}_vic20_pet.d64" -write Interpreters/z3-pet "game-pet"
c1541 -attach "${STORY}_vic20_pet.d64" -write ${STORY}.z3 "z3 story,s"
c1541 -attach "${STORY}_vic20_pet.d64" -write Interpreters/config.seq "config,s"
