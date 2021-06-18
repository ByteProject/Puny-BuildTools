#!/bin/bash
# builds Commodore 64 release (without Koala Loader) but launches Windows Frotz for testing

#read config file 
source config.sh

#cleanup
rm ${STORY}_c64.d64

#compile
${WRAPPER} ${STORY}.inf
read -n 1 -p "Press ANY KEY to create D64 and launch Frotz..."
${WRAPPER} -5 ${STORY}.inf
ruby Interpreters/Ozmoo/make.rb -t:c64 -dc:6:9 -sc:8 -cc:8 -ic:8 -ss1:"${LABEL}" -ss2:"Interactive Fiction" -ss3:"${SUBTITLE}" -sw:6 ${STORY}.z3

mv c64_${STORY}.d64 ${STORY}_c64.d64

#run Frotz with the freshly generated Z-file (path defined in your bash.rc)
/mnt/c/Program\ Files\ \(x86\)/RetroTools/WindowsFrotz/Frotz.exe ${STORY}.z3
