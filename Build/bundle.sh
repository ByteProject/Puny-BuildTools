#!/bin/bash
# bundles your game files and places them in an archive on the desktop

#read config file 
source config.sh

cp Releases/PlayIF.pdf .
cp Releases/readme.txt .
cp Releases/licenses.txt .
cp Interpreters/Pro-DOS-v2.dsk .
cp Interpreters/dragon64_loader.vdk .
cp -R Releases/DOS .
cp -R Releases/Modern/Release .
mv Release Modern_PC

zip -r ${STORY}_${RELEASE}.zip ${STORY}_speccy.dsk ${STORY}_amiga.adf ${STORY}_apple2.dsk ${STORY}_atari8bit.atr ${STORY}_c128.d71 ${STORY}_plus4.d64 ${STORY}_ti99.dsk ${STORY}_vic20_pet.d64 ${STORY}_c64.d64 ${STORY}_mega65.d81 ${STORY}_cpc_pcw.dsk ${STORY}_atarist.st ${STORY}.z3 ${STORY}.z5 ${STORY}_bbc_elk.ssd ${STORY}_MSX.dsk ${STORY}_oric_1.dsk ${STORY}_oric_2.dsk cpm_plus_speccy.dsk ${STORY}_mac.dsk ${STORY}_trs_coco.dsk ${STORY}_dragon64.vdk dragon64_loader.vdk ${STORY}_sam_coupe.cpm ${STORY}_trs80_m3.dsk ${STORY}_trs80_m4.dsk ${STORY}_osborne1.cpm ${STORY}_kaypro.cpm ${STORY}_decrainbow.cpm Pro-DOS-v2.dsk PlayIF.pdf readme.txt licenses.txt Modern_PC DOS

rm PlayIF.pdf
rm readme.txt
rm licenses.txt
rm cpm_plus_speccy.dsk
rm Pro-DOS-v2.dsk
rm dragon64_loader.vdk
cp ${STORY}_${RELEASE}.zip $windesk
rm -rf DOS
rm -rf Modern_PC
rm ${STORY}_${RELEASE}.zip

