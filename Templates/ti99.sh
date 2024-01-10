#!/bin/bash
# ti99.sh - TI99/4a disk builder
# Puny BuildTools, (c) 2023 Stefan Vogt

#read config file 
source config.sh

echo -e "\nti99.sh 1.0 - TI99/4a disk builder"
echo -e "Puny BuildTools, (c) 2023 Stefan Vogt\n"

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
if [ -f ${STORY}_ti99.dsk ] ; then
    rm ${STORY}_ti99.dsk
fi

#copy TI99/4a disk image template
cp Interpreters/ti994a.dsk ./
mv ti994a.dsk ${STORY}_ti99.dsk

#create TI99/4a story chunks
z3toTI994A ${STORY}.z3

#place files on TI99/4A disk image
tidisk --add=STRY1 ${STORY}_ti99.dsk
tidisk --add=STRY2 ${STORY}_ti99.dsk

#post cleanup
rm STRY1
rm STRY2
