#!/bin/bash
# c128.sh - C128 disk builder
# Puny BuildTools, (c) 2024 Stefan Vogt

#read config file 
source config.sh

echo -e "\nc128.sh 2.2 - C128 disk builder"
echo -e "Puny BuildTools, (c) 2024 Stefan Vogt\n"

#story check / arrangement
if ! [ -f ${STORY}.z${ZVERSION} ] ; then
    echo -e "Story file '${STORY}.z${ZVERSION}' not found. Operation aborted.\n"
    exit 1;
fi 

#cleanup 
if [ -f ${STORY}_c128.d71 ] ; then
    rm ${STORY}_c128.d71
fi
if [ -f ${STORY}_c128.d64 ] ; then
    rm ${STORY}_c128.d64
fi

#compile
ruby ~/FictionTools/Templates/Interpreters/Ozmoo/make.rb -t:c128 -dc:2:9 -ss1:"${LABEL}" -ss2:"Interactive Fiction" -ss3:"${SUBTITLE}" -sw:6 -dm:0 ${STORY}.z${ZVERSION}

mv c128_${STORY}.d71 ${STORY}_c128.d71

if [ -f ${STORY}_c128.d71 ] ; then
    echo -e "\nC128 disk successfully built.\n"
else
    echo -e "\n"
fi
