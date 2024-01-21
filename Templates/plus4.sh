#!/bin/bash
# plus4.sh - Plus/4 disk builder
# Puny BuildTools, (c) 2024 Stefan Vogt

#read config file 
source config.sh

echo -e "\nplus4.sh 2.0 - Plus/4 disk builder"
echo -e "Puny BuildTools, (c) 2024 Stefan Vogt\n"

#story check / arrangement
if ! [ -f ${STORY}.z${ZVERSION} ] ; then
    echo -e "Story file '${STORY}.z${ZVERSION}' not found. Operation aborted.\n"
    exit 1;
fi 

#cleanup 
if [ -f ${STORY}_plus4.d64 ] ; then
    rm ${STORY}_plus4.d64
fi

#check for loading screen and arrange resources
LOADSCRFLAG="-i picplus4.mb "
if ! [ -f Resources/picplus4.mb ] ; then
    LOADSCRFLAG=""
else
    cp Resources/picplus4.mb .
fi

#compile
ruby ~/FictionTools/Templates/Interpreters/Ozmoo/make.rb -t:plus4 ${LOADSCRFLAG}-dc:2:9 -ss1:"${LABEL}" -ss2:"Interactive Fiction" -ss3:"${SUBTITLE}" -sw:6 ${STORY}.z${ZVERSION}

mv plus4_${STORY}.d64 ${STORY}_plus4.d64

#post-notification and cleanup
if ! [ -f Resources/picplus4.mb ] ; then
    echo -e "\nNo picplus4.mb found in /Resources dir."
    echo -e "Plus/4 disk without loading screen successfully built.\n"
else
    rm picplus4.mb
    echo -e "\npicplus4.mb found in /Resources dir."
    echo -e "Plus/4 disk with loading screen successfully built.\n"
fi
