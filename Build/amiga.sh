#!/bin/bash
# builds Commodore Amiga release

#read config file 
source config.sh

#cleanup
rm ${STORY}_amiga.adf

#compile
${WRAPPER} ${STORY}.inf

#prepare story 
cp ${STORY}.z3 Story.Data

#copy Amiga disk image template
cp Interpreters/amiga_ZIP_pic.adf ./
mv amiga_ZIP_pic.adf ${STORY}_amiga.adf

#add file to Amiga disk image
xdftool ${STORY}_amiga.adf write Story.Data

#post cleanup
rm Story.Data
