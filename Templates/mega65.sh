#!/bin/bash
# mega65.sh - MEGA65 disk builder
# Puny BuildTools, (c) 2024 Stefan Vogt

#read config file 
source config.sh

echo -e "\nmega65.sh 2.0 - MEGA65 disk builder"
echo -e "Puny BuildTools, (c) 2024 Stefan Vogt\n"

#story check / arrangement
if ! [ -f ${STORY}.z${ZVERSION} ] ; then
    echo -e "Story file '${STORY}.z${ZVERSION}' not found. Operation aborted.\n"
    exit 1;
fi 

#cleanup 
if [ -f ${STORY}_mega65.d81 ] ; then
    rm ${STORY}_mega65.d81
fi

#create disk
ruby ~/FictionTools/Templates/Interpreters/Ozmoo/make.rb -t:mega65 -dc:2:9 -ss1:"${LABEL}" -ss2:"Interactive Fiction" -ss3:"${SUBTITLE}" -sw:6 ${STORY}.z${ZVERSION}

#post-notification and cleanup
if [ -f Resources/screen16.iff ] ; then
    cp Resources/screen16.iff .
    c1541 -attach "mega65_${STORY}.d81" -read autoboot.c65
    mv autoboot.c65 ozmoo
    cp ~/FictionTools/Templates/Interpreters/autoboot.c65.16 .
    mv autoboot.c65.16 autoboot.c65
    c1541 -attach "mega65_${STORY}.d81" -read zcode,s
    c1541 -format "moonmist,if" D81 "${STORY}_mega65.d81" 8
    c1541 -attach "${STORY}_mega65.d81" -write autoboot.c65
    c1541 -attach "${STORY}_mega65.d81" -write ozmoo
    c1541 -attach "${STORY}_mega65.d81" -write screen16.iff "artsc"
    c1541 -attach "${STORY}_mega65.d81" -write zcode "zcode,s"
    echo -e "\nscreen16.iff found in /Resources dir."
    echo -e "MEGA65 disk with 16-color loading screen successfully built.\n"
    rm autoboot.c65
    rm ozmoo
    rm zcode
    rm screen16.iff
    rm mega65_${STORY}.d81
elif [ -f Resources/screen256.iff ] ; then
    cp Resources/screen256.iff .
    c1541 -attach "mega65_${STORY}.d81" -read autoboot.c65
    mv autoboot.c65 ozmoo
    cp ~/FictionTools/Templates/Interpreters/autoboot.c65.256 .
    mv autoboot.c65.256 autoboot.c65
    c1541 -attach "mega65_${STORY}.d81" -read zcode,s
    c1541 -format "moonmist,if" D81 "${STORY}_mega65.d81" 8
    c1541 -attach "${STORY}_mega65.d81" -write autoboot.c65
    c1541 -attach "${STORY}_mega65.d81" -write ozmoo
    c1541 -attach "${STORY}_mega65.d81" -write screen256.iff "artsc"
    c1541 -attach "${STORY}_mega65.d81" -write zcode "zcode,s"
    echo -e "\nscreen256.iff found in /Resources dir."
    echo -e "MEGA65 disk with 256-color loading screen successfully built.\n"
    rm autoboot.c65
    rm ozmoo
    rm zcode
    rm screen256.iff
    rm mega65_${STORY}.d81
else
    mv mega65_${STORY}.d81 ${STORY}_mega65.d81
    echo -e "\nNo screen.iff found in /Resources dir."
    echo -e "MEGA65 disk without loading screen successfully built.\n"
fi
