#!/bin/bash
# makescr.sh 1.0  - ZX Spectrum CPM+ loading screen maker
# Puny BuildTools, (c) 2023 Stefan Vogt

echo "makescr.sh 1.0 - ZX Spectrum CPM+ loading screen maker"
echo "Puny BuildTools, (c) 2023 Stefan Vogt"
echo -e "CPM+ SCR loader code (c) 2020 George Beckett\n"

make -f Makefile_scrload
rm scrload
rm scrload.o
echo -e "output file: SCRLOAD.COM\n"
