#!/bin/bash
# msx.sh - MSX1/MSX2 disk builder
# Puny BuildTools, (c) 2023 Stefan Vogt

#read config file 
source config.sh

echo -e "\nmsx.sh 2.5 - MSX1/MSX2 disk builder"
echo -e "Puny BuildTools, (c) 2023 Stefan Vogt\n"

#story check / arrangement
if ! [ -f ${STORY}.z${ZVERSION} ] ; then
    echo -e "Story file '${STORY}.z${ZVERSION}' not found. Operation aborted.\n"
    exit 1;
fi 

#cleanup 
if [ -f ${STORY}_MSX.dsk ] ; then
    rm ${STORY}_MSX.dsk
fi

#prepare story 
cp ${STORY}.z${ZVERSION} STORY.DAT

# build disc with or without loading screen
if ! [ -f Resources/LPIC.SC2 ] ; then
    cp ~/FictionTools/Templates/Interpreters/MSXNOPIC.DSK .
    mv MSXNOPIC.DSK ${STORY}_MSX.dsk
    dsktool a ${STORY}_MSX.dsk STORY.DAT
    echo -e "\nNo LPIC.SC2 found in /Resources dir."
    echo -e "MSX1/MSX2 disk without loading screen successfully built.\n"
    rm STORY.DAT
    exit 0
else
    cp ~/FictionTools/Templates/Interpreters/MSXTERP.DSK .
    cp Resources/LPIC.SC2 .
    mv MSXTERP.DSK ${STORY}_MSX.dsk
    dsktool a ${STORY}_MSX.dsk LPIC.SC2 STORY.DAT
    echo -e "\nLPIC.SC2 found in /Resources dir."
    echo -e "MSX1/MSX2 disk with loading screen successfully built.\n"
    rm STORY.DAT
    rm LPIC.SC2
    exit 0
fi
