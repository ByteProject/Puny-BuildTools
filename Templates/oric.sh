#!/bin/bash
# oric.sh - Oric disk builder
# Puny BuildTools, (c) 2023 Stefan Vogt

#read config file 
source config.sh

echo -e "\noric.sh 1.0 - Oric disk builder"
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
if [ -f ${STORY}_oric_1.dsk ] ; then
    rm ${STORY}_oric_1.dsk
fi
if [ -f ${STORY}_oric_2.dsk ] ; then
    rm ${STORY}_oric_2.dsk
fi

#copy resources
cp ./Interpreters/pinforic.dsk ./
mv pinforic.dsk ${STORY}_oric_1.dsk

#prepare story file
cp ${STORY}.z3 STORY.DAT

#create raw DOS disk image
mkdosfs -C ${STORY}_oric_2.dsk 360

#copy story file on disk
mcopy -i ${STORY}_oric_2.dsk STORY.DAT ::STORY.DAT

#create Oric disk from raw DOS disk image
raw2mfm ${STORY}_oric_2.dsk

#post cleanup
rm STORY.DAT
