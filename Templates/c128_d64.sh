#!/bin/bash
# c128_d64.sh - C128 .D64 disk builder
# Puny BuildTools, (c) 2024 Stefan Vogt

#read config file 
source config.sh

echo -e "\nc128_d64.sh 2.1 - C128 .D64 disk builder"
echo -e "Puny BuildTools, (c) 2024 Stefan Vogt\n"

#story check / arrangement
if ! [ -f ${STORY}.z${ZVERSION} ] ; then
    echo -e "Story file '${STORY}.z${ZVERSION}' not found. Operation aborted.\n"
    exit 1;
fi 

#cleanup 
if [ -f ${STORY}_c128.d64 ] ; then
    rm ${STORY}_c128.d64
fi

#compile
ruby ~/FictionTools/Templates/Interpreters/Ozmoo/make.rb -t:c128 -S1 -dc:2:9 -ss1:"${LABEL}" -ss2:"Interactive Fiction" -ss3:"${SUBTITLE}" -sw:6 ${STORY}.z${ZVERSION}

mv c128_${STORY}.d64 ${STORY}_c128.d64

if [ -f ${STORY}_c128.d64 ] ; then
    echo -e "\nC128 .D64 disk successfully built.\n"
else
    echo -e "\n"
fi
