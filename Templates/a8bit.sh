#!/bin/bash
# a8bit.sh - Atari 8-bit disk builder
# Puny BuildTools, (c) 2023 Stefan Vogt

#read config file 
source config.sh

 echo -e "\na8bit.sh 3.0 - Atari 8-bit disk builder"
 echo -e "Puny BuildTools, (c) 2023 Stefan Vogt\n"

#story check / arrangement
if ! [ -f ${STORY}.z${ZVERSION} ] ; then
    echo -e "Story file '${STORY}.z${ZVERSION}' not found. Operation aborted.\n"
    exit 1;
fi 

#cleanup 
if [ -f ${STORY}_a8bit.dsk ] ; then
    rm ${STORY}_a8bit.dsk
fi

suffix=_atari8bit

zmachine3()
{
    a8bin=~/FictionTools/atari8bit/a8.bin # Infocom's early terp, 130kb disk image, 40 columns
    printf "Interpreter: Infocom early single-disk [ZIP]\n"
    printf "Columns: 40\n"
    printf "Memory: min. 48kb\n"
    printf "Disk: Single-Sided, Enhanced-Density, 130kb capacity\n"
    printf "Disk Drive: 1050 and XF551\n\n"
    printf "Disk image built. Booting with BASIC enabled/disabled possible.\n"
    cat $a8bin ${STORY}.z3 > ${STORY}${suffix}.atr 2>/dev/null
    size=`ls -l ${STORY}${suffix}.atr | cut -d' ' -f5`
    head --bytes $((133136-$size)) /dev/zero >> ${STORY}${suffix}.atr
    printf "\n" #just for cosmetical reasons
    exit 0
}

zmachine5()
{
    a8bin=~/FictionTools/atari8bit/new8_40_dd_z5.bin # Jindroush's terp, 180kb disk image, 40 columns
    printf "Interpreter: Jindroush/Infocom version H [XZIP]\n"
    printf "Columns: 40\n"
    printf "Memory: min. 128kb of extended memory\n"
    printf "Disk: Single-Sided, Double-Density, 180kb capacity\n"
    printf "Disk Drive: 1050 and XF551\n\n"
    printf "Disk image built. Boot with BASIC disabled.\n"
    cat $a8bin ${STORY}.z5 > ${STORY}${suffix}.atr 2>/dev/null
    size=`ls -l ${STORY}${suffix}.atr | cut -d' ' -f5`
    head --bytes $((183952-$size)) /dev/zero >> ${STORY}${suffix}.atr
    printf "\n" #just for cosmetical reasons
    exit 0
}

# Z-machine version check
zvalue="$ZVERSION"
if [[ $zvalue == 5 ]] ; then
    zmachine5
elif [[ $zvalue == 3 ]] ; then
    zmachine3
fi
