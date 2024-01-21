#!/bin/bash
# kaypro.sh - Kaypro II/4 disk builder
# Puny BuildTools, (c) 2024 Stefan Vogt

#read config file 
source config.sh

echo -e "\nkaypro.sh 1.0 - Kaypro II/4 disk builder"
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
if [ -f ${STORY}_kaypro.cpm ] ; then
    rm ${STORY}_kaypro.cpm
fi

#prepare story 
cp ${STORY}.z${ZVERSION} game.dat

#copy resources
cp ./Interpreters/kaypro.cpm ./
mv kaypro.cpm ${STORY}_kaypro.cpm

#place story on disk image
cpmcp -f kpii ${STORY}_kaypro.cpm game.dat 0:game.dat
cpmls -f kpii ${STORY}_kaypro.cpm

#post cleanup
rm game.dat
