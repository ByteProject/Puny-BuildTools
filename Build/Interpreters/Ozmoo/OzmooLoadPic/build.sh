#!/bin/bash
# builds Commodore 64 loader (multicolor Koala)

#cleanup
rm exomloader
rm picload.prg

#compile
acme --cpu 6510 --format cbm picloader.asm
exomizer sfx basic picload.prg

#rename binary
mv a.out exomloader

