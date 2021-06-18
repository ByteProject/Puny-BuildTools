#!/bin/bash
# builds TRS CoCo and Dragon64 release

#read config file 
source config.sh

#cleanup
rm ${STORY}_trs_coco.dsk
rm ${STORY}_dragon64.vdk

#build game 
${WRAPPER} ${STORY}.inf

#copy resources
cp Interpreters/trs_coco.dsk .
mv trs_coco.dsk ${STORY}_trs_coco.dsk

# skip the first two tracks, they have the terp
dd if=${STORY}.z3 of=${STORY}_trs_coco.dsk conv=notrunc bs=1 seek=9216 count=64512 >/dev/null
# track starting at 64512 is the directory, for loadm + exec
dd if=${STORY}.z3 of=${STORY}_trs_coco.dsk conv=notrunc bs=1 skip=64512 seek=82944 count=69120 >/dev/null
# we're fine cause the boot track (34) is at 156672, and we land at 147 or 152 

# Dragon64 reference: http://www.retrowiki.es/viewtopic.php?t=200033991

# create an empty Dragon disk image
touch ${STORY}_dragon64.vdk

# append Dragon DOS header to file
dd if=Interpreters/dragondos_header of=${STORY}_dragon64.vdk bs=1G oflag=append conv=notrunc

# append TRS CoCo disk image to file
dd if=${STORY}_trs_coco.dsk of=${STORY}_dragon64.vdk bs=1G oflag=append conv=notrunc

# fill Dragon disk image with bytes for the correct file size
dd if=Interpreters/dragon_bytefill of=${STORY}_dragon64.vdk bs=1G oflag=append conv=notrunc
