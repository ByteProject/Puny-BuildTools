#!/bin/bash
# c64.sh - C64 disk builder
# Puny BuildTools, (c) 2024 Stefan Vogt

#read config file 
source config.sh

echo -e "\nc64.sh 2.1 - C64 disk builder"
echo -e "Puny BuildTools, (c) 2024 Stefan Vogt\n"

#story check / arrangement
if ! [ -f ${STORY}.z${ZVERSION} ] ; then
    echo -e "Story file '${STORY}.z${ZVERSION}' not found. Operation aborted.\n"
    exit 1;
fi 

#cleanup 
if [ -f ${STORY}_c64.d64 ] ; then
    rm ${STORY}_c64.d64
fi

#check for loading screen and arrange resources
LOADSCRFLAG="-i loadpic.kla "
if ! [ -f Resources/loadpic.kla ] ; then
    LOADSCRFLAG=""
else
    cp Resources/loadpic.kla .
fi

#compile
ruby ~/FictionTools/Templates/Interpreters/Ozmoo/make.rb -t:c64 ${LOADSCRFLAG}-dc:2:9 -ss1:"${LABEL}" -ss2:"Interactive Fiction" -ss3:"${SUBTITLE}" -sw:6 -dm:0 ${STORY}.z${ZVERSION}

mv c64_${STORY}.d64 ${STORY}_c64.d64

#post-notification and cleanup
if ! [ -f Resources/loadpic.kla ] ; then
    echo -e "\nNo loadpic.kla found in /Resources dir."
    echo -e "C64 disk without loading screen successfully built.\n"
else
    rm loadpic.kla
    echo -e "\nloadpic.kla found in /Resources dir."
    echo -e "C64 disk with loading screen successfully built.\n"
fi
