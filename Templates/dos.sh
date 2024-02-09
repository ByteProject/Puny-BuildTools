#!/bin/bash
# dos.sh - MS-DOS release builder
# Puny BuildTools, (c) 2024 Stefan Vogt

#read config file 
source config.sh

echo -e "\ndos.sh 2.1 - MS-DOS release builder"
echo -e "Puny BuildTools, (c) 2024 Stefan Vogt\n"

#story check / arrangement
if ! [ -f ${STORY}.z${ZVERSION} ] ; then
    echo -e "Story file '${STORY}.z${ZVERSION}' not found. Operation aborted.\n"
    exit 1;
fi 
cp ${STORY}.z${ZVERSION} STORY.DAT

#pre-cleanup
if [ -d Releases/DOS ] ; then
    rm -rf Releases/DOS
fi

#copy resources
zvalue="$ZVERSION"
if [[ $zvalue == 5 ]] ; then
    cp ~/FictionTools/Templates/Interpreters/DOS_I_Z5.EXE ~/FictionTools/Templates/Interpreters/DOSTEMP/MOONM.EXE
fi
if [[ $zvalue == 3 ]] ; then
    cp ~/FictionTools/Templates/Interpreters/DOS_I_Z3.COM ~/FictionTools/Templates/Interpreters/DOSTEMP/MOONM.COM
fi

#place story in temporary directory
mv STORY.DAT ~/FictionTools/Templates/Interpreters/DOSTEMP

#copy content to Release directory
cp -r ~/FictionTools/Templates/Interpreters/DOSTEMP Releases/DOS

#post-cleanup
if [ -f ~/FictionTools/Templates/Interpreters/DOSTEMP/MOONM.EXE ] ; then
    rm ~/FictionTools/Templates/Interpreters/DOSTEMP/MOONM.EXE
fi
if [ -f ~/FictionTools/Templates/Interpreters/DOSTEMP/MOONM.COM ] ; then
    rm ~/FictionTools/Templates/Interpreters/DOSTEMP/MOONM.COM
fi

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
