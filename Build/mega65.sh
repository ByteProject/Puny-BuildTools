#!/bin/bash
# builds Mega65 release

#read config file 
source config.sh

#cleanup
rm ${STORY}_mega65.d81

#compile
${WRAPPER} ${STORY}.inf
cp ${STORY}.z3 ./Interpreters/Ozmoo/
cd Interpreters/Ozmoo
#mv asm/splashlines.tpl asm/splashlines40.tpl
#mv asm/splashlines80.tpl asm/splashlines.tpl
ruby make.rb -t:mega65 -dc:6:9 -sc:8 -cc:8 -sw:6 ${STORY}.z3
#mv asm/splashlines.tpl asm/splashlines80.tpl
#mv asm/splashlines40.tpl asm/splashlines.tpl
rm ${STORY}.z3
mv mega65_${STORY}.d81 ${STORY}_mega65.d81
mv ${STORY}_mega65.d81 ../../
