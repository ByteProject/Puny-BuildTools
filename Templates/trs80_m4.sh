#!/bin/bash
# trs80_m4.sh - TRS80 Model 4 disk builder
# Puny BuildTools, (c) 2024 Stefan Vogt

#read config file 
source config.sh

echo -e "\ntrs80_m4.sh 2.5 - TRS80 Model 4 disk builder"
echo -e "Puny BuildTools, (c) 2024 Stefan Vogt\n"

#story check / arrangement
if ! [ -f ${STORY}.z${ZVERSION} ] ; then
    echo -e "Story file '${STORY}.z${ZVERSION}' not found. Operation aborted.\n"
    exit 1;
fi 

#abort if Wine is not installed
if ! [ -f /usr/bin/wine ] ; then
    echo -e "You need Wine installed to build TRS80 Model 4 disks. Operation aborted.\n"
    exit 1;
fi 

#cleanup 
if [ -f ${STORY}_trs80_m4.dsk ] ; then
    rm ${STORY}_trs80_m4.dsk
fi

#prepare story 
cp ${STORY}.z${ZVERSION} STORY.DAT

#copy disk template with interpreter
cp ~/FictionTools/Templates/Interpreters/TRS80_M4.dsk .

#write story file on TRS-80 Model 3 (LDOS) disk image
mv TRS80_M4.dsk ${STORY}_trs80_m4.dsk
wine ~/FictionTools/trswrite.exe -o ${STORY}_trs80_m4.dsk STORY.DAT
printf "\n" # only cosmetical
wine ~/FictionTools/trsread.exe -v ${STORY}_trs80_m4.dsk

#post cleanup
rm STORY.DAT

echo -e "\nTRS80 Model 4 disk successfully built.\n"
