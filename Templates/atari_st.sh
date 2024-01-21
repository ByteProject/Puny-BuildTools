#!/bin/bash
# atari_st.sh - Atari ST disk builder
# Puny BuildTools, (c) 2024 Stefan Vogt

#read config file 
source config.sh

echo -e "\natari_st.sh 2.0 - Atari ST disk builder"
echo -e "Puny BuildTools, (c) 2024 Stefan Vogt\n"

#story check / arrangement
if ! [ -f ${STORY}.z${ZVERSION} ] ; then
    echo -e "Story file '${STORY}.z${ZVERSION}' not found. Operation aborted.\n"
    exit 1
fi 

#cleanup 
if [ -f ${STORY}_atarist.st ] ; then
    rm ${STORY}_atarist.st
fi

# set loading screen flag true or false
if [ -f Resources/ART.PI1 ] ; then
    buildWithLoader=true
else
    buildWithLoader=false
fi

#prepare story 
cp ${STORY}.z${ZVERSION} STORY.DAT

# copy disk image template and loader
zvalue="$ZVERSION"
if [[ $zvalue == 5 && $buildWithLoader == true ]] ; then
    echo "Configuring Z5 .ST template with pixel art viewer."
    cp ~/FictionTools/Templates/Interpreters/ATARIST.PRG .
    mv ATARIST.PRG PLAY.PRG
    cp ~/FictionTools/Templates/Interpreters/Tools/ARTVIEW.APP .
    cp Resources/ART.PI1 .
    zip -v ${STORY}.zip PLAY.PRG PLAY.PRG
    zip -rv ${STORY}.zip STORY.DAT STORY.DAT
    zip -rv ${STORY}.zip ARTVIEW.APP ARTVIEW.APP
    zip -rv ${STORY}.zip ART.PI1 ART.PI1
    zip2st ${STORY}.zip ${STORY}.st
elif [[ $zvalue == 5 && $buildWithLoader == false ]] ; then
    echo "Configuring Z5 .ST template without pixel art viewer."
    cp ~/FictionTools/Templates/Interpreters/ATARIST.PRG .
    mv ATARIST.PRG PLAY.PRG
    zip -v ${STORY}.zip PLAY.PRG PLAY.PRG
    zip -rv ${STORY}.zip STORY.DAT STORY.DAT
    zip2st ${STORY}.zip ${STORY}.st
elif [[ $zvalue == 3 && $buildWithLoader == true ]] ; then
    echo "Configuring Z3 .ST template with pixel art viewer."
    cp ~/FictionTools/Templates/Interpreters/ATARIST_Z3.PRG .
    mv ATARIST_Z3.PRG PLAY.PRG
    cp ~/FictionTools/Templates/Interpreters/Tools/ARTVIEW.APP .
    cp Resources/ART.PI1 .
    zip -v ${STORY}.zip PLAY.PRG PLAY.PRG
    zip -rv ${STORY}.zip STORY.DAT STORY.DAT
    zip -rv ${STORY}.zip ARTVIEW.APP ARTVIEW.APP
    zip -rv ${STORY}.zip ART.PI1 ART.PI1
    zip2st ${STORY}.zip ${STORY}.st
elif [[ $zvalue == 3 && $buildWithLoader == false ]] ; then
    echo "Configuring Z3 .ST template without pixel art viewer."
    cp ~/FictionTools/Templates/Interpreters/ATARIST_Z3.PRG .
    mv ATARIST_Z3.PRG PLAY.PRG
    zip -v ${STORY}.zip PLAY.PRG PLAY.PRG
    zip -rv ${STORY}.zip STORY.DAT STORY.DAT
    zip2st ${STORY}.zip ${STORY}.st
fi

#post-notification and cleanup
if ! [ -f ART.PI1 ] ; then
    echo -e "\nNo 'ART.PI1' found in /Resources dir."
    echo -e "Atari ST disk without loading screen successfully built.\n"
else
    rm ART.PI1
    rm ARTVIEW.APP
    echo -e "\n'ART.PI1' found in /Resources dir."
    echo -e "Atari ST disk with loading screen successfully built.\n"
fi
rm STORY.DAT
rm PLAY.PRG
rm ${STORY}.zip
mv ${STORY}.st ${STORY}_atarist.st
