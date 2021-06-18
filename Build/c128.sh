#!/usr/bin/env bash
# builds Commodore 128 release

#read config file 
source config.sh

#cleanup
rm ${STORY}_c128.d71

#compile
${WRAPPER} ${STORY}.inf
cp ${STORY}.z3 ${STORY}_c128.z3
#mv Interpreters/Ozmoo/asm/splashlines.tpl Interpreters/Ozmoo/asm/splashlines40.tpl
#mv Interpreters/Ozmoo/asm/splashlines80.tpl Interpreters/Ozmoo/asm/splashlines.tpl
ruby Interpreters/Ozmoo/make.rb -t:c128 -dc:6:9 -sc:8 -cc:8 -sw:6 ${STORY}_c128.z3
#mv Interpreters/Ozmoo/asm/splashlines.tpl Interpreters/Ozmoo/asm/splashlines80.tpl
#mv Interpreters/Ozmoo/asm/splashlines40.tpl Interpreters/Ozmoo/asm/splashlines.tpl

mv c128_${STORY}_c128.d71 ${STORY}_c128.d71

#remove obsolete files
rm ${STORY}_c128.z3
