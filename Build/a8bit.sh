#!/bin/bash
# Puddle BuildTools for PunyInform
# Atari 8-bit Disk Image Creator
# builds Atari 8-bit release
#
# synopsis: use argument -1 or no argument for single disk output (early Infocom interpreter)
#           use argument -2 for multidisk output (late Infocom interpreter, good for big story files)
#
# example: a8bit.sh -2 --> creates multidisk distribution

#read config file 
source config.sh

#cleanup
rm ${STORY}*.atr

#compile
${WRAPPER} ${STORY}.inf

suffix=_atari8bit
a8bin=~/FictionTools/atari8bit/a8_g.bin #change to b or e for an earlier 2-disk interpreter, g recommended

printf "Infocom Atari 8-bit Disk Creator 1.0 by Stefan Vogt\n" #quite some code, it should have a name
printf "%s story file is Z-machine version 3\n\n" ${STORY}

multidisk()
{
    offset=36864 # it has to be this offset, as the interpreter expects story part 1 to end at 8FFF

    printf "[multidisk distribution selected, late Infocom interpreter]\n\n"

    #split story file at offset defined in the z-file's header
    printf "creating story chunk 1:\n"
    dd if=${STORY}.z3 of=${STORY}.chunk1 conv=notrunc bs=1 count=${offset} >/dev/null
    printf "\ncreating story chunk 2:\n"
    dd if=${STORY}.z3 of=${STORY}.chunk2 conv=notrunc bs=1 skip=${offset} >/dev/null

    cp ~/FictionTools/atari8bit/a8_2d_bit.bin . # copy binary templates from FictionTools folder
    cp ~/FictionTools/atari8bit/a8_hmmarker.bin .
    mv a8_2d_bit.bin tmp #rename files to tmp, for err... reasons (no particular reasons)
    mv a8_hmmarker.bin tmp2

    #setting byte 1 to 4, which is the flag for two disk story files
    printf "\nZ-machine story patch... set multidisk flag, push highmem to 8FFF in header:\n"
    dd if=tmp of=${STORY}.chunk1 bs=1 seek=0 count=2 conv=notrunc

    #push highmem marker to 8FFF in the Z-machine header of the story file 
    dd if=tmp2 of=${STORY}.chunk1 bs=1 seek=4 count=2 conv=notrunc

    #append Atari 8-bit disk header to chunk 2
    mv ${STORY}.chunk2 temp.chunk2
    cp ~/FictionTools/atari8bit/a8_header130.bin .
    mv a8_header130.bin ${STORY}.chunk2
    dd if=temp.chunk2 of=${STORY}.chunk2 bs=1G oflag=append conv=notrunc

    #create the actual Atari disk images
    cat $a8bin ${STORY}.chunk1 > ${STORY}${suffix}_1.atr 2>/dev/null
    size=`ls -l ${STORY}${suffix}_1.atr | cut -d' ' -f5`
    head --bytes $((133136-$size)) /dev/zero >> ${STORY}${suffix}_1.atr

    cat ${STORY}.chunk2 > ${STORY}${suffix}_2.atr 2>/dev/null
    size=`ls -l ${STORY}${suffix}_2.atr | cut -d' ' -f5`
    head --bytes $((133136-$size)) /dev/zero >> ${STORY}${suffix}_2.atr

    rm tmp #remove temporary crap
    rm tmp2
    rm temp.chunk2
    rm *.chunk*

    printf "... done.\n\n" #just for cosmetical reasons
    exit 0
}

singledisk()
{
    a8bin=~/FictionTools/atari8bit/a8.bin # use the early (single disk) Infocom interpreter

    printf "[single disk distribution selected, early Infocom interpreter]... done.\n"
    cat $a8bin ${STORY}.z3 > ${STORY}${suffix}.atr 2>/dev/null
    size=`ls -l ${STORY}${suffix}.atr | cut -d' ' -f5`
    head --bytes $((133136-$size)) /dev/zero >> ${STORY}${suffix}.atr

    printf "\n" #just for cosmetical reasons
    exit 0
}

while getopts 21h opts
do
	case $opts in
		2) multidisk
		;;
        1) singledisk
        ;;
		*) printf "\nSynopsis: argument -1 for single disk output (early Infocom interpreter)\n          argument -2 for multidisk output (late Infocom interpreter)\n\nWrong argument passed, defaulting to single disk option.\n"
           singledisk
		;;
	esac
done

if [ $OPTIND -eq 1 ]; then printf "Synopsis: argument -1 for single disk output (early Infocom interpreter)\n          argument -2 for multidisk output (late Infocom interpreter)\n\nNo argument passed, defaulting to single disk option.\n"; singledisk; fi
