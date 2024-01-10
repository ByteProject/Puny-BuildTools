#!/bin/bash
# cpcscr.sh - Amstrad CPC screen maker
# Puny BuildTools, (c) 2023 Stefan Vogt

echo "cpcscr 1.0 - Amstrad CPC screen maker"
echo -e "Puny BuildTools, (c) 2023 Stefan Vogt\n"

while getopts ':c:h' opts
do
	case $opts in
		c)
            if ! [ -f ${OPTARG} ] ; then
                echo -e "File ${OPTARG} not found. Aborting operation.\n"
                exit 1;
            fi
            cp ${OPTARG} SCREEN.PNG
            mkdir tempcpcscr
            mv SCREEN.PNG tempcpcscr
            cd tempcpcscr
            martine -in SCREEN.PNG -mode 0
            cp *.BAS ../SCREEN.BAS
            cp *.PAL ../SCREEN.PAL
            cp *.SCR ../SCREEN.SCR
            cd ..
            rm -rf tempcpcscr
            if [ -f SCREEN.SCR ] ; then
                echo -e "\nCPC loading screen, palette and loader successfully created."
                echo -e "You can safely ignore any errors you might see in the build log.\n"
            else
                echo
                exit 1
            fi
            exit 0
		    ;;

        h) 
            echo -e "synopsis: $(basename $0) [-c myimage.png]\n"
            echo "cpcscr.sh converts a .PNG image file to an Amstrad CPC"
            echo -e "loading screen, a colour palette file and a BASIC loader.\n"
            echo -e "Output will be: 'SCREEN.SCR', 'SCREEN.PAL' and 'SCREEN.BAS'.\n"
            ;;

        :)
            echo -e "Option [-${OPTARG}] requires an argument.\nType: $(basename $0) [-h] for help.\n"
            exit 1
            ;;

		*)
            echo -e "Wrong argument passed.\nType: $(basename $0) [-h] for help.\n"
            exit 0
		    ;;
	esac
done

if [ $OPTIND -eq 1 ]; then echo -e "Nothing to be done. No options passed. Use [-h] for help.\n"; fi
shift "$(($OPTIND -1))"
