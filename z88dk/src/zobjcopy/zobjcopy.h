//-----------------------------------------------------------------------------
// zobjcopy - manipulate z80asm object files
// Copyright (C) Paulo Custodio, 2011-2019
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#include "die.h"
#include "objfile.h"
#include "optparse.h"
#include "utlist.h"
#include "strutil.h"

#include <sys/types.h>	// needed before regex.h
#include "regex.h"

#include <ctype.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
