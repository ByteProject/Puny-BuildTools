#!/bin/bash
# bbc_acorn.sh - BBC Micro/Acorn Electron disk builder
# Puny BuildTools, (c) 2024 Stefan Vogt

#read config file 
source config.sh

echo -e "\nbbc_acorn.sh 2.2 - BBC Micro/Acorn Electron disk builder"
echo -e "Puny BuildTools, (c) 2024 Stefan Vogt\n"

#story check / arrangement
if ! [ -f ${STORY}.z${ZVERSION} ] ; then
    echo -e "Story file '${STORY}.z${ZVERSION}' not found. Operation aborted.\n"
    exit 1;
fi 

#cleanup 
if [ -f ${STORY}_bbc_elk.ssd ] ; then
    rm ${STORY}_bbc_elk.ssd
fi

#store current working directory
workingDir=$(pwd)

#check for loading screen and arrange resources
LOADSCRFLAG="--splash-image screen.bbc --splash-mode 2 "
if ! [ -f Resources/screen.bbc ] ; then
    LOADSCRFLAG=""
else
    cp Resources/screen.bbc ~/FictionTools/Templates/Interpreters/beebOzmoo
fi

#for BeebOzmoo, we need to switch to the Interpreters folder
cp ${STORY}.z${ZVERSION} ~/FictionTools/Templates/Interpreters/beebOzmoo/
cd ~/FictionTools/Templates/Interpreters/beebOzmoo
python make-acorn.py -v ${LOADSCRFLAG}--title "${STORY}" --subtitle "${SUBTITLE}" --default-fg-colour 7 --default-bg-colour 0 --default-mode-7-status-colour 6 ${STORY}.z${ZVERSION}
rm ${STORY}.z${ZVERSION}

#cleanup
mv ${STORY}.ssd ${STORY}_bbc_elk.ssd
mv ${STORY}_bbc_elk.ssd "${workingDir}"
cd "${workingDir}"

#post-notification and cleanup
if ! [ -f Resources/screen.bbc ] ; then
    echo -e "\nNo screen.bbc found in /Resources dir. Building disk without loading screen."
else
    rm ~/FictionTools/Templates/Interpreters/beebOzmoo/screen.bbc
    echo -e "\nscreen.bbc found in /Resources dir. Building disk with loading screen."
fi

if [ -f ${STORY}_bbc_elk.ssd ] ; then
    echo -e "BBC/Electron disk image '${STORY}_bbc_elk.ssd' successfully built.\n"
    exit 0
else
    echo -e "Something went wrong, please check the build log.\n"
    exit 1
fi
