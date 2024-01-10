#!/bin/bash
# cpc_pcw.sh - Amstrad CPC/PCW disc builder
# Puny BuildTools, (c) 2023 Stefan Vogt

#read config file 
source config.sh

echo -e "\ncpc_pcw.sh 2.5 - Amstrad CPC/PCW disc builder"
echo -e "Puny BuildTools, (c) 2023 Stefan Vogt\n"

#story check / arrangement
if ! [ -f ${STORY}.z${ZVERSION} ] ; then
    echo -e "Story file '${STORY}.z${ZVERSION}' not found. Operation aborted.\n"
    exit 1;
fi 

#cleanup 
if [ -f ${STORY}_cpc_pcw.dsk ] ; then
    rm ${STORY}_cpc_pcw.dsk
fi

#copy resources
cp ~/FictionTools/Templates/Interpreters/cpc_vezza.dsk .
mv cpc_vezza.dsk ${STORY}.dsk

#prepare story 
cp ${STORY}.z${ZVERSION} STORY.DAT

#place story on disk image
idsk ${STORY}.dsk -i STORY.DAT -t 0

# build disc with or without loading screen
if ! [ -f Resources/SCREEN.SCR ] ; then
    mv ${STORY}.dsk ${STORY}_cpc_pcw.dsk
    echo -e "\nNo SCREEN.SCR, SCREEN.PAL and SCREEN.BAS found in /Resources dir."
    echo -e "CPC/PCW disc without loading screen successfully built.\n"
    rm STORY.DAT
else
    cp ~/FictionTools/Templates/Interpreters/DISC.BAS .
    idsk ${STORY}.dsk -i DISC.BAS
    cp ~/FictionTools/Templates/Interpreters/GAME.BAS .
    idsk ${STORY}.dsk -i GAME.BAS
    cp ./Resources/SCREEN.SCR .
    idsk ${STORY}.dsk -i SCREEN.SCR #-t 1 -c c000
    cp ./Resources/SCREEN.PAL .
    idsk ${STORY}.dsk -i SCREEN.PAL #-t 1 -c a000
    cp ./Resources/SCREEN.BAS .
    idsk ${STORY}.dsk -i SCREEN.BAS #-t 1 -c a000
    echo -e "\nSCREEN.SCR, SCREEN.PAL and SCREEN.BAS found in /Resources dir."
    echo -e "CPC/PCW disc with loading screen successfully built.\n"
    mv ${STORY}.dsk ${STORY}_cpc_pcw.dsk
    rm STORY.DAT
    rm DISC.BAS
    rm GAME.BAS
    rm SCREEN.BAS
    rm SCREEN.SCR
    rm SCREEN.PAL
fi
