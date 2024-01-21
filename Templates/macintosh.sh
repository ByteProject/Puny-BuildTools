#!/bin/bash
# macintosh.sh - Macintosh Classic disk builder
# Puny BuildTools, (c) 2024 Stefan Vogt

#read config file 
source config.sh

echo -e "\nmacintosh.sh 2.0 - Macintosh Classic disk builder"
echo -e "Puny BuildTools, (c) 2024 Stefan Vogt\n"

#story check / arrangement
if ! [ -f ${STORY}.z${ZVERSION} ] ; then
    echo -e "Story file '${STORY}.z${ZVERSION}' not found. Operation aborted.\n"
    exit 1;
fi 

#cleanup 
if [ -f ${STORY}_mac.dsk ] ; then
    rm ${STORY}_mac.dsk
fi

#copy resources
cp ~/FictionTools/Templates/Interpreters/ClassicMac_MaxZip.dsk ./
mv ClassicMac_MaxZip.dsk ${STORY}_mac.dsk

#prepare story 
cp ${STORY}.z${ZVERSION} game.story

#place story on Macintosh 800k disk image
hmount ${STORY}_mac.dsk
hcopy game.story :
hls
humount

#post cleanup
rm game.story

echo -e "\nMacintosh disk image (System 7 or higher) successfully built.\n"