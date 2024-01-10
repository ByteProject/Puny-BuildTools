#!/bin/bash
# ifftool.sh - Commodore Amiga/MEGA65 IFF screen maker
# Puny BuildTools, (c) 2023 Stefan Vogt
# NOTE: Requires ImageMagick at path

echo "ifftool.sh 1.2 - Commodore Amiga/MEGA65 IFF screen maker"
echo -e "Puny BuildTools, (c) 2023 Stefan Vogt\n"

while getopts ':l:m:a:c:h' opts
do
	case $opts in
		l)  # MEGA65 reduced .IFF image
            if ! [ -f ${OPTARG} ] ; then
                echo -e "File ${OPTARG} not found. Aborting operation.\n"
                exit 1
            fi
            convert ${OPTARG} -resize 320x200\! -colors 16 -depth 4 megascr.ppm
            ppmtoilbm -maxplanes 8 megascr.ppm >screen16.iff
            rm megascr.ppm
            echo
            exit 0
		    ;;

		m)  # MEGA65 full color palette .IFF image
            if ! [ -f ${OPTARG} ] ; then
                echo -e "File ${OPTARG} not found. Aborting operation.\n"
                exit 1;
            fi
            convert ${OPTARG} -resize 320x200\! -colors 256 -depth 8 megascr.ppm
            ppmtoilbm -maxplanes 8 megascr.ppm >screen256.iff
            rm megascr.ppm
            echo
            exit 0
		    ;;

		c)  # convert image to Amiga resolution loader binary
            if ! [ -f ${OPTARG} ] ; then
                echo -e "File ${OPTARG} not found. Aborting operation.\n"
                exit 1
            fi
            convert ${OPTARG} -resize 320x256\! -colors 32 -depth 8 amigascr.ppm
            ppmtoilbm -maxplanes 8 amigascr.ppm >amigascr.iff
            vamos ~/FictionTools/s-pic amigascr.iff loader
            rm amigascr.ppm
            rm amigascr.iff
            if [ -f loader ] ; then
                echo -e "'loader' successfully compiled.\n"
                exit 0
            else
                echo -e "Something went wrong. Is ${OPTARG} a valid .IFF file?\n"
                exit 1
            fi
		    ;;

		a)  # create IFF from PNG/JPEG in Amiga resolution
            if ! [ -f ${OPTARG} ] ; then
                echo -e "File ${OPTARG} not found. Aborting operation.\n"
                exit 1;
            fi
            convert ${OPTARG} -resize 320x256\! -colors 32 -depth 8 amigascr.ppm
            ppmtoilbm -maxplanes 8 amigascr.ppm >screen_amiga.iff
            rm amigascr.ppm
            echo
            exit 0
		    ;;

        h) 
            echo "Converts .PNG to .IFF images in Amiga and MEGA65 resolutions. Also"
            echo -e "compiles .PNG images to executable Amiga binaries, the format used"
            echo -e "by the puny CLI 'amiga' target to build disks with loading screen.\n" 
            echo -e "Switches:"
            echo -e "   [-l image.png] -> 16 color MEGA65 .IFF 320x200"
            echo -e "   good for importing gfx with reduced palette, e.g. Atari ST .PI1"
            echo -e "   output will be: 'screen16.iff'\n"
            echo -e "   [-m image.png] -> 256 color MEGA65 .IFF 320x200"
            echo -e "   output will be 'screen256.iff'\n"
            echo -e "   [-a image.png] -> 32 color Amiga .IFF 320x256"
            echo -e "   output will be 'screen_amiga.iff'\n"
            echo -e "   [-c image.png] -> 32 color Amiga loading screen binary 320x256"
            echo -e "   output will be 'loader'\n"
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
