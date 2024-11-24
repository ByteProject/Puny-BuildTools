#!/bin/bash
# decrainbow.sh - DEC Rainbow 100 disk builder
# Puny BuildTools, (c) 2024 Stefan Vogt

#read config file 
source config.sh

echo -e "\ndecrainbow.sh 1.0 - DEC Rainbow 100 disk builder"
echo -e "Puny BuildTools, (c) 2024 Stefan Vogt\n"

# Z-machine version check
if ! [[ $ZVERSION == 3 ]] ; then
    echo -e "This target only supports Z-machine version 3. Operation aborted.\n"
    exit 1
fi

#story check / arrangement
if ! [ -f ${STORY}.z${ZVERSION} ] ; then
    echo -e "Story file '${STORY}.z${ZVERSION}' not found. Operation aborted.\n"
    exit 1
fi

#cleanup 
if [ -f ${STORY}_decrainbow.cpm ] ; then
    rm ${STORY}_decrainbow.cpm
fi

#copy resources
cp ~/FictionTools/Templates/Interpreters/decrainbow.cpm ./
mv decrainbow.cpm ${STORY}_decrainbow.cpm

#prepare story 
cp ${STORY}.z3 story.dat

#place story on disk image
cpmcp -f dec2 ${STORY}_decrainbow.cpm story.dat 0:story.dat
cpmls -f dec2 ${STORY}_decrainbow.cpm

#post cleanup
rm story.dat
