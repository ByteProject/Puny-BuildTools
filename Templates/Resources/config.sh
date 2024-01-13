#!/bin/bash
# config.sh - project configuration file
# Puny BuildTools 2.0, (c) 2023 Stefan Vogt

# --- project settings: --------------------------------------------------

# your Inform source or story file without .inf/.z3/.z5 suffix 
STORY="myproject"

# Z-machine version this project compiles to, 3 and 5 supported
ZVERSION="5"

# used by the bundle.sh utility for naming the release archive
RELEASE="R1"

# subtitle (it is recommended using your itch.io URL)
SUBTITLE="8bitgames.itch.io"

# the label you want to release your software under, e.g. Infocom
LABEL="Moonmist / ZZAP!64"

# --- system settings (don't touch unless you know what you do): ---------

CFGEDITOR="nano"
WRAPPER="pi6"
TESTTERP="frotz"
