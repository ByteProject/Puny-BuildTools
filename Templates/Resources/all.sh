#!/bin/bash
# all.sh  - local script to build all targets of your project
# Puny BuildTools, (c) 2024 Stefan Vogt

# By standard, all.sh will only build the recommended disk images. You can
# force building deprecated systems using the -d switch, e.g. ./all.sh -d

main()
{
	printf "all.sh - building disk images [...]\n"
	# Z-machine version 5 systems (recommended)
    puny -b c64 -b apple2 -b bbc_acorn -b speccy -b plus4 -b macintosh -b atari_st -b mega65 -b msx -b trs80_m3 -b trs80_m4 -b c128 -b sam_coupe -b cpc_pcw -b dos -b amiga -b a8bit
}

deprecated()
{
	printf "\nall.sh - building deprecated disk images [...]\n"
    # Z-machine version 3 only systems (deprecated)
    puny -b decrainbow -b kaypro -b osborne1 -b trs_coco_dragon64 -b vic20_pet -b oric -b ti99
}

# Always run main but check for -d flag
main

while getopts d opts
do
	case $opts in
		d) deprecated
		;;
	esac
done

exit 0
