#!/bin/bash
# Puny BuildTools
# bundle.sh - the game release archiver
# (c) 2024 Stefan Vogt

# bundles your game files and places them in an archive at a given path

#read config file 
source config.sh

echo "bundle.sh 2.1 - the game release archiver"
echo -e "Puny BuildTools, (c) 2024 Stefan Vogt\n"

while getopts ':t:h' opt; do
  case "$opt" in
    t)
      arg="$OPTARG"
      if [ -d ${OPTARG} ]; then
        echo "Generating '${RELEASE}' archive [...] path: ${OPTARG}"
      
        cp Releases/PlayIF.pdf .
        cp Releases/readme.txt .
        cp Releases/licenses.txt .
        cp Releases/game.transcript .
        cp ~/FictionTools/Templates/Interpreters/Pro-DOS-v2.dsk .
        cp ~/FictionTools/Templates/Interpreters/CPM_Plus_speccy.dsk .
        cp -R Releases/DOS .
      
        # by standard all possible z5/multi-z targets are enabled, 
        # all z3-only targets are disabled (see below)
        zip -r ${STORY}_${RELEASE}.zip ${STORY}_apple2_s1.dsk ${STORY}_apple2_s2.dsk ${STORY}_speccy.dsk ${STORY}_amiga.adf ${STORY}_atari8bit.atr ${STORY}_c128.d71 ${STORY}_plus4.d64 ${STORY}_c64.d64 ${STORY}_mega65.d81 ${STORY}_cpc_pcw.dsk ${STORY}_atarist.st ${STORY}.z5 ${STORY}_bbc_elk.ssd ${STORY}_MSX.dsk CPM_Plus_speccy.dsk ${STORY}_mac.dsk ${STORY}_sam_coupe.cpm Pro-DOS-v2.dsk PlayIF.pdf readme.txt licenses.txt game.transcript DOS

        if [ -f ${STORY}_c128.d64 ] ; then
            zip ${STORY}_${RELEASE}.zip ${STORY}_c128.d64
        fi
        if [ -f ${STORY}_trs80_m3.dsk ] ; then
            zip ${STORY}_${RELEASE}.zip ${STORY}_trs80_m3.dsk
        fi
        if [ -f ${STORY}_trs80_m4.dsk ] ; then
            zip ${STORY}_${RELEASE}.zip ${STORY}_trs80_m4.dsk
        fi

        # these targets only support z3 and are deactivated by default, 
        # add them to the zip line above if desired
        # ${STORY}.z3 ${STORY}_ti99.dsk ${STORY}_oric_1.dsk ${STORY}_oric_2.dsk ${STORY}_vic20_pet.d64 ${STORY}_trs_coco.dsk ${STORY}_dragon64.vdk dragon64_loader.vdk ${STORY}_osborne1.cpm ${STORY}_kaypro.cpm ${STORY}_decrainbow.cpm

        rm PlayIF.pdf
        rm readme.txt
        rm licenses.txt
        rm game.transcript
        rm CPM_Plus_speccy.dsk
        rm Pro-DOS-v2.dsk
        cp ${STORY}_${RELEASE}.zip ${OPTARG}
        rm -rf DOS
        rm ${STORY}_${RELEASE}.zip
        echo -e "\nDistribution archive for '${STORY}' successfully generated."
      else
        echo -e "The path you provided does not exist. Operation aborted.\n"
        exit 1
      fi  
      ;;

    h)
      echo "'bundle.sh' creates an archive for distributing your game. It is"
      echo "meant to be run right after you have compiled the disk images for"
      echo "all target systems using the 'all.sh' script. Note that 'bundle.sh',"
      echo "just like 'config.sh' and 'all.sh', is generated upon project dir"
      echo "initialization and needs to be executed from the project dir itself."
      echo "You may want to edit this script once after project init, so it is"
      echo -e "customized to suite your needs. Use it like this:\n"
      echo -e "./bundle.sh [-t path]\n\nwhere [path] stands for the directory you want the archive to be\nplaced, e.g. ./bundle.sh -t ~/Desktop\n"
      exit 0
      ;;

    :)
      echo -e "Option [-t] requires a valid path as an argument.\n\nSynopsis: ./$(basename $0) [-t path] or [-h] for help.\n"
      exit 1
      ;;

    ?)
      echo -e "Invalid command option.\n\nSynopsis: ./$(basename $0) [-t path] or [-h] for help.\n"
      exit 1
      ;;
  esac
done

if [ $OPTIND -eq 1 ]; then echo -e "Nothing to be done. No options passed. Use [-h] for help."; fi
shift "$(($OPTIND -1))"

echo -e
exit 0;
