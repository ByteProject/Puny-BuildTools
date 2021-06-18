#!/bin/bash
# builds Acorn Electron / BBC release

#read config file 
source config.sh

#cleanup
rm ${STORY}_bbc_elk.ssd

#compile
${WRAPPER} ${STORY}.inf
cp ${STORY}.z3 ./Interpreters/beebOzmoo/
cp ./Resources/screen.bbc ./Interpreters/beebOzmoo
cd Interpreters/beebOzmoo
python make-acorn.py -v --splash-image screen.bbc --splash-mode 2 --title "${STORY}" --subtitle "${SUBTITLE}" --default-fg-colour 7 --default-bg-colour 0 --default-mode-7-status-colour 6 ${STORY}.z3
rm ${STORY}.z3
rm screen.bbc
mv ${STORY}.ssd ${STORY}_bbc_elk.ssd
mv ${STORY}_bbc_elk.ssd ../../
