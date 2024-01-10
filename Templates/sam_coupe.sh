#!/bin/bash
# sam_coupe.sh - SAM Coupe disk builder
# Puny BuildTools, (c) 2023 Stefan Vogt

#read config file 
source config.sh

echo -e "\nsam_coupe.sh 2.5 - SAM Coupe disk builder"
echo -e "Puny BuildTools, (c) 2023 Stefan Vogt\n"

#story check / arrangement
if ! [ -f ${STORY}.z${ZVERSION} ] ; then
    echo -e "Story file '${STORY}.z${ZVERSION}' not found. Operation aborted.\n"
    exit 1;
fi 

#cleanup 
if [ -f ${STORY}_sam_coupe.cpm ] ; then
    rm ${STORY}_sam_coupe.cpm
fi

#copy resources
cp ~/FictionTools/Templates/Interpreters/SAM_Vezza.cpm ./
mv SAM_Vezza.cpm ${STORY}_sam_coupe.cpm

#prepare story 
cp ${STORY}.z${ZVERSION} story.dat

#place story on disk image
cpmcp -f prodos ${STORY}_sam_coupe.cpm story.dat 0:story.dat
cpmls -f prodos ${STORY}_sam_coupe.cpm

#post cleanup
rm story.dat

echo -e "\nSAM Coupe disk image successfully built.\n"
