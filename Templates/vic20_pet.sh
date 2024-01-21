#!/bin/bash
# vic20_pet.sh - VIC20/PET disk builder
# Puny BuildTools, (c) 2024 Stefan Vogt

#read config file 
source config.sh

echo -e "\nvic20_pet.sh 1.0 - Commodore VIC20/PET disk builder"
echo -e "Puny BuildTools, (c) 2024 Stefan Vogt\n"

# Z-machine version check
if ! [[ $ZVERSION == 3 ]] ; then
    echo -e "This target only supports Z-machine version 3. Operation aborted.\n"
    exit 1
fi

#story check / arrangement
if ! [ -f ${STORY}.z${ZVERSION} ] ; then
    echo -e "Story file '${STORY}.z${ZVERSION}' not found. Operation aborted.\n"
    exit 1
fi

#cleanup 
if [ -f {STORY}_vic20_pet.d64 ] ; then
    rm ${STORY}_vic20_pet.d64
fi

#create disk image for all versions except C64
c1541 -format "${STORY},if" D64 "${STORY}_vic20_pet.d64" 8
c1541 -attach "${STORY}_vic20_pet.d64" -write Interpreters/z3-vic "game-vic"
c1541 -attach "${STORY}_vic20_pet.d64" -write Interpreters/z3-pet "game-pet"
c1541 -attach "${STORY}_vic20_pet.d64" -write ${STORY}.z${ZVERSION} "z3 story,s"
c1541 -attach "${STORY}_vic20_pet.d64" -write Interpreters/config.seq "config,s"
