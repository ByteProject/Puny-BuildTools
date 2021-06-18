#!/bin/bash
# builds a Commodore 64 release with loader

#read config file 
source config.sh

#cleanup
rm ${STORY}_c64.d64

#compile
${WRAPPER} ${STORY}.inf

cd Interpreters/Ozmoo/OzmooLoadPic
sh build.sh

cd ../../..

#compile C64 version
ruby Interpreters/Ozmoo/make.rb -dc:6:9 -sc:8 -cc:8 -ic:8 -ss1:"${LABEL}" -ss2:"Interactive Fiction" -ss3:"${SUBTITLE}" -sw:6 ${STORY}.z3

mv c64_${STORY}.d64 ${STORY}.d64

#get the loader binary on disk
c1541 -attach "${STORY}.d64" -read "story"
c1541 -attach "${STORY}.d64" -delete "story"
cp Interpreters/Ozmoo/OzmooLoadPic/exomloader ./
mv exomloader ${STORY}
c1541 -attach "${STORY}.d64" -write "${STORY}"
c1541 -attach "${STORY}.d64" -write "story"

#append directory art
cp Resources/buildtools.d64 ./
mv ${STORY}.d64 merge.d64
d64merge merge.d64 buildtools.d64 ${STORY}.d64

#clean temp files
rm story
rm ${STORY}
rm buildtools.d64
rm merge.d64
mv ${STORY}.d64 ${STORY}_c64.d64

