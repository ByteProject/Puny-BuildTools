#!/bin/bash
# osborne1.sh - Osborne 1 disk builder
# Puny BuildTools, (c) 2024 Stefan Vogt

#read config file 
source config.sh

echo -e "\nosborne1.sh 1.0 - Osborne 1 disk builder"
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
if [ -f ${STORY}_osborne1.cpm ] ; then
    rm ${STORY}_osborne1.cpm
fi

#copy resources
cp ~/FictionTools/Templates/Interpreters/osborne1.cpm ./
mv osborne1.cpm ${STORY}_osborne1.cpm

#prepare story 
cp ${STORY}.z3 story.dat

#place story on disk image
cpmcp -f osborne1 ${STORY}_osborne1.cpm story.dat 0:story.dat
cpmls -f osborne1 ${STORY}_osborne1.cpm

#post cleanup
rm story.dat
