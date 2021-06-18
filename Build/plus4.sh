#!/bin/bash
# builds Commodore Plus/4 release

#read config file 
source config.sh

#cleanup
rm ${STORY}_plus4.d64

#copy resources
cp Resources/picplus4.mb .

#compile
${WRAPPER} ${STORY}.inf
cp ${STORY}.z3 ${STORY}_plus4.z3
ruby Interpreters/Ozmoo/make.rb -t:plus4 -i picplus4.mb -dc:6:9 -sc:8 -cc:8 -ss1:"${LABEL}" -ss2:"Interactive Fiction" -ss3:"${SUBTITLE}" -sw:6 ${STORY}_plus4.z3

mv plus4_${STORY}_plus4.d64 ${STORY}_plus4.d64

#append directory art
cp Resources/dirart.d64 ./
mv ${STORY}_plus4.d64 mergep4.d64
d64merge mergep4.d64 dirart.d64 ${STORY}_plus4.d64

#remove obsolete files
rm ${STORY}_plus4.z3
rm mergep4.d64
rm dirart.d64
rm picplus4.mb


