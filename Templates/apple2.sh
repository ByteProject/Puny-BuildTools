#!/bin/bash
# apple2.sh - Sinclair ZX Spectrum +3 disk builder
# Puny BuildTools, (c) 2023 Stefan Vogt

#read config file 
source config.sh

echo -e "\napple2.sh 2.5 - Apple II disk builder"
echo -e "Puny BuildTools, (c) 2023 Stefan Vogt\n"

#story check / arrangement
if ! [ -f ${STORY}.z${ZVERSION} ] ; then
    echo -e "Story file '${STORY}.z${ZVERSION}' not found. Operation aborted.\n"
    exit 1;
fi 

#cleanup 
if [ -f ${STORY}_apple2_s1.dsk ] ; then
    rm ${STORY}_apple2_s1.dsk
fi
if [ -f ${STORY}_apple2_s2.dsk ] ; then
    rm ${STORY}_apple2_s2.dsk
fi

#copy resources
cp ~/FictionTools/Templates/Interpreters/apple2_boot.dsk .
cp ~/FictionTools/Templates/Interpreters/apple2_template.dsk .

#add files to disk
cpmcp -f apple-do apple2_template.dsk ${STORY}.z${ZVERSION} 0:story.dat

#apply naming scheme
mv apple2_boot.dsk ${STORY}_apple2_s1.dsk
mv apple2_template.dsk ${STORY}_apple2_s2.dsk

#show disk contents
cpmls -f apple-do ${STORY}_apple2_s2.dsk

echo -e "\nApple II disk Side 1 and Side 2 successfully built."
echo -e "Boot in a system with CPM card installed.\n"
exit 0