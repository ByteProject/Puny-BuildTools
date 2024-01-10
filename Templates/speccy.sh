#!/bin/bash
# speccy.sh - Sinclair ZX Spectrum +3 disk builder
# Puny BuildTools, (c) 2023 Stefan Vogt

#read config file 
source config.sh

echo -e "\nspeccy.sh 2.5 - Sinclair ZX Spectrum +3 disk builder"
echo -e "Puny BuildTools, (c) 2023 Stefan Vogt\n"

#story check / arrangement
if ! [ -f ${STORY}.z${ZVERSION} ] ; then
    echo -e "Story file '${STORY}.z${ZVERSION}' not found. Operation aborted.\n"
    exit 1;
fi 

#cleanup 
if [ -f ${STORY}_speccy.dsk ] ; then
    rm ${STORY}_speccy.dsk
fi

#prepare story 
cp ${STORY}.z${ZVERSION} STORY.DAT

# build disc with or without loading screen
if ! [ -f Resources/SCRLOAD.COM ] ; then
    cp ~/FictionTools/Templates/Interpreters/Spec_Vezza.dsk .
    mv Spec_Vezza.dsk ${STORY}_speccy.dsk
    idsk ${STORY}_speccy.dsk -i STORY.DAT -t 0
    echo -e "\nNo SCRLOAD.COM found in /Resources dir."
    echo -e "ZX Spectrum +3 disk without loading screen successfully built.\n"
    rm STORY.DAT
    exit 0
else
    cp ~/FictionTools/Templates/Interpreters/Spec_Vezza_SCR.dsk .
    cp Resources/SCRLOAD.COM .
    mv Spec_Vezza_SCR.dsk ${STORY}_speccy.dsk
    idsk ${STORY}_speccy.dsk -i STORY.DAT -t 0
    idsk ${STORY}_speccy.dsk -i SCRLOAD.COM -t 0
    echo -e "\nSCRLOAD.COM found in /Resources dir."
    echo -e "ZX Spectrum +3 disk with loading screen successfully built.\n"
    rm STORY.DAT
    rm SCRLOAD.COM
    exit 0
fi
