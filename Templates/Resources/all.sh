#!/bin/bash
# all.sh  - local script to build all targets of your project
# Puny BuildTools, (c) 2023 Stefan Vogt

# Z-machine version 5 systems (standard config)
puny -b c64 -b apple2 -b bbc_acorn -b speccy -b plus4 -b macintosh -b atari_st -b mega65 -b msx -b trs80_m3 -b trs80_m4 -b c128 -b sam_coupe -b cpc_pcw -b dos -b amiga -b a8bit

# Z-machine version 3 only systems (enable if desired)
# puny -b decrainbow -b kaypro -b osborne1 -b trs_coco_dragon64 -b vic20_pet -b oric -b ti99 