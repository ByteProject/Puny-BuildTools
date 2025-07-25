#!/bin/bash
# Puny BuildTools v2.4
# make_abbrvs.sh - creates optimized abbreviations for your story
# using ZAbbrevMaker by Henrik Åsman
# (c) 2025 Stefan Vogt

#read config file 
source config.sh

#cleanup
rm abbrvs.h

#generate
zabbrev -cu -v -i > abbrvs.h
