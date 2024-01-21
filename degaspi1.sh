#!/bin/bash
# degaspi1.sh - Atari ST (Degas .PI1) screen maker
# Puny BuildTools, (c) 2024 Stefan Vogt
# NOTE: Requires ImageMagick at path

echo "degaspi1.sh - Atari ST (Degas .PI1) screen maker"
echo -e "Puny BuildTools, (c) 2024 Stefan Vogt\n"

while getopts ':c:h' opts
do
	case $opts in
		c)
            if ! [ -f ${OPTARG} ] ; then
                echo -e "File ${OPTARG} not found. Aborting operation.\n"
                exit 1
            fi
            convert ${OPTARG} -resize 320x200\! -colors 16 -depth 4 degasscr.ppm
            ppmtopi1 degasscr.ppm >ART.PI1
            rm degasscr.ppm
            echo
            exit 0
		    ;;

        h) 
            echo "Converts .PNG images to Atari ST / Degas .PI1 format." 
            echo -e "Usage: [degaspi1.sh -c image.png] -> 16 color .PI1 320x200"
            echo -e "output will be 'ART.PI1'\n"
            ;;

        :)
            echo -e "Option [-${OPTARG}] requires an argument.\nType: $(basename $0) [-h] for help.\n"
            exit 
            ;;

		*)
            echo -e "Wrong argument passed.\nType: $(basename $0) [-h] for help.\n"
            exit 0
		    ;;
	esac
done

if [ $OPTIND -eq 1 ]; then echo -e "Nothing to be done. No options passed. Use [-h] for help.\n"; fi
shift "$(($OPTIND -1))"
