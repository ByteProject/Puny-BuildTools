#!/bin/bash
# dos.sh - MS-DOS release builder
# Puny BuildTools, (c) 2023 Stefan Vogt

#read config file 
source config.sh

echo -e "\ndos.sh 2.0 - MS-DOS release builder"
echo -e "Puny BuildTools, (c) 2023 Stefan Vogt\n"

#story check / arrangement
if ! [ -f ${STORY}.z${ZVERSION} ] ; then
    echo -e "Story file '${STORY}.z${ZVERSION}' not found. Operation aborted.\n"
    exit 1;
fi 
cp ${STORY}.z${ZVERSION} STORY.DAT

#cleanup
if [ -d Releases/DOS ] ; then
    rm -rf Releases/DOS
fi

#copy resources
cp ~/FictionTools/Templates/Interpreters/FROTZ.EXE ~/FictionTools/Templates/Interpreters/DOSTEMP/MOONM.EXE

#place story in temporary directory
mv STORY.DAT ~/FictionTools/Templates/Interpreters/DOSTEMP

#copy content to Release directory
cp -r ~/FictionTools/Templates/Interpreters/DOSTEMP Releases/DOS

#check for loading screen and arrange resources
if ! [ -f Resources/SCREEN.PNG ] ; then
    rm Releases/DOS/PLAY.BAT
    rm Releases/DOS/PICTVIEW.CFG
    rm Releases/DOS/VIEWER.EXE
    mv Releases/DOS/PLAYONLY.BAT Releases/DOS/PLAY.BAT
    echo "No SCREEN.PNG found in /Resources dir."
    echo -e "MS-DOS release without loading screen successfully built.\n"
else
    cp Resources/SCREEN.PNG Releases/DOS
    rm Releases/DOS/PLAYONLY.BAT
    echo "SCREEN.PNG found in /Resources dir."
    echo -e "MS-DOS release with loading screen successfully built.\n"
fi
