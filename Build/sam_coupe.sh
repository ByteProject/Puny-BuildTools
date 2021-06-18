#!/bin/bash
# builds SAM Coupe release

#read config file 
source config.sh

#cleanup
rm ${STORY}_sam_coupe.cpm

#copy resources
cp ./Interpreters/SAM_image.cpm ./
mv SAM_image.cpm ${STORY}_sam_coupe.cpm

#compile
${WRAPPER} ${STORY}.inf

#prepare story 
cp ${STORY}.z3 story.dat

#place story on disk image
cpmcp -f prodos ${STORY}_sam_coupe.cpm story.dat 0:story.dat
cpmls -f prodos ${STORY}_sam_coupe.cpm

#post cleanup
rm story.dat
