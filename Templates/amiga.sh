#!/bin/bash
# amiga.sh - Commodore Amiga disk builder
# Puny BuildTools, (c) 2023 Stefan Vogt

#read config file 
source config.sh

echo -e "\namiga.sh 2.0 - Commodore Amiga disk builder"
echo -e "Puny BuildTools, (c) 2023 Stefan Vogt\n"

#story check / arrangement
if ! [ -f ${STORY}.z${ZVERSION} ] ; then
    echo -e "Story file '${STORY}.z${ZVERSION}' not found. Operation aborted.\n"
    exit 1
fi 

#cleanup 
if [ -f ${STORY}_amiga.adf ] ; then
    rm ${STORY}_amiga.adf
fi

# set loading screen flag true or false
if [ -f Resources/loader ] ; then
    buildWithLoader=true
else
    buildWithLoader=false
fi

#prepare story 
cp ${STORY}.z${ZVERSION} Story.Data

# copy disk image template and loader
zvalue="$ZVERSION"
if [[ $zvalue == 5 && $buildWithLoader == true ]] ; then
    echo "Configuring Z5 .ADF template with loader."
    cp ~/FictionTools/Templates/Interpreters/amiga_Infocom_z5_pic.adf ./
    mv amiga_Infocom_z5_pic.adf ${STORY}_amiga.adf
    cp Resources/loader ./
elif [[ $zvalue == 5 && $buildWithLoader == false ]] ; then
    echo "Configuring Z5 .ADF template without loader."
    cp ~/FictionTools/Templates/Interpreters/amiga_Infocom_z5.adf ./
    mv amiga_Infocom_z5.adf ${STORY}_amiga.adf
elif [[ $zvalue == 3 && $buildWithLoader == true ]] ; then
    echo "Configuring Z3 .ADF template with loader."
    cp ~/FictionTools/Templates/Interpreters/amiga_ZIP_pic.adf ./
    mv amiga_ZIP_pic.adf ${STORY}_amiga.adf
    cp Resources/loader ./
elif [[ $zvalue == 3 && $buildWithLoader == false ]] ; then
    echo "Configuring Z3 .ADF template without loader."
    cp ~/FictionTools/Templates/Interpreters/amiga_ZIP.adf ./
    mv amiga_ZIP.adf ${STORY}_amiga.adf
fi

#add files to Amiga diks image
if [ -f loader ]; then
    xdftool ${STORY}_amiga.adf write loader
fi
xdftool ${STORY}_amiga.adf write Story.Data

#post-notification and cleanup
if ! [ -f loader ] ; then
    echo -e "\nNo 'loader' found in /Resources dir."
    echo -e "Commodore Amiga disk without loading screen successfully built.\n"
else
    rm loader
    echo -e "\n'loader' found in /Resources dir."
    echo -e "Commodore Amiga disk with loading screen successfully built.\n"
fi
rm Story.Data
