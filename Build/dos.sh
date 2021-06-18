#!/bin/bash
# builds MS-DOS release

#read config file 
source config.sh

#copy resources
cp ./Interpreters/FROTZ.EXE ./Releases/DOS/PUDDLE.EXE

#compile
${WRAPPER} -5 ${STORY}.inf

#prepare story 
cp ${STORY}.z5 STORY.DAT

#place story in release directory
mv STORY.DAT ./Releases/DOS/
