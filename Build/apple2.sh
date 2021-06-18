#!/bin/bash
# builds Apple II release

#read config file 
source config.sh

#cleanup
rm ${STORY}_apple2.dsk

#compile
${WRAPPER} ${STORY}.inf

#create disk image
interlz3 ./Interpreters/info3k.bin ${STORY}.z3 ${STORY}_apple2.dsk
