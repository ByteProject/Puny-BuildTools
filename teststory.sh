#!/bin/bash
# teststory.sh - launches Frotz for testing the project
# Puny BuildTools, (c) 2023 Stefan Vogt

#read config file 
source config.sh

#compile
puny -c
read -n 1 -s -r -p "Press ANY KEY to launch Frotz..."

#launch compiled story file in Frotz
frotz ${STORY}.z${ZVERSION}