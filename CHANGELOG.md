# Changelog

## 1.4

* added Atari 8-bit disk creator utility, which allows to bundle games using either the early Infocom interpreter (single disk) or the late Infocom interpreter (two disks) working around the constraints of Atari disks when having a large story file
* added multiple binary template files used by the Atari 8-bit disk creator utility
* added version B, E and G of the late Infocom Atari 8-bit interpreter, the creator utility uses version G by default
* the puny wrapper tool no longer auto-generates Atari 8-bit images as the target has its own build script in the Build directory now (a8bit.sh)
* updated documentation, added Atari 8-bit disk creator usage (see interpreters section)
* updated the Hibernated 1 Director's Cut sources to R10


## 1.3

* the line to include the generic abbreviations in shell.inf is no longer commented, which absolutely made no sense anyway
* moved the abbreviations wrapper script to the build directory
* added ZAbbrevMaker by Henrik Åsman @heasm66 as standard tool for generating optimized story abbreviations
* fixed an error in the H1DC source that originated from a default message suffix change in PunyInform, thanks to @spacehobo for the pull request
* upgrade to Inform 6 compiler v6.36 (dev) as the new version comes with a much better abbreviations logic

## 1.2

* appended Apple II target to z5_all.sh
* added Infocom's Apple IIe z5 interpreter
* optional interpreter Amiga Frotz (z3 and z5 capable) included
* new binary cc1541 in FictionTools

## 1.1

* added script that allows you to build a Z-machine version 5 game for all targets capable of running z5
* own DrawStatusLine routine for z5 games as Puny's routine might cause misbehavior with some of the Infocom interpreters (see shell.inf)
* added templates with Infocom's only Amiga based Z-Machine version 5 interpreter
* upgrade to Inform 6 compiler v6.36 (dev)
* documentation update

## 1.0

* initial release