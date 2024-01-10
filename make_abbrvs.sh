#!/bin/bash
# Puny BuildTools v2.0
# make_abbrvs.sh - creates optimized abbreviations for your story
# using ZAbbrevMaker by Henrik Åsman
# (c) 2023 Stefan Vogt

#read config file 
source config.sh

#cleanup
rm abbrvs.h

#generate
ZAbbrevMaker -cu -v -i > abbrvs.h
