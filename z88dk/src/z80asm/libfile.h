/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2019
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Handle library file contruction, reading and writing
*/

#pragma once

#include "strutil.h"

extern char Z80libhdr[];

/* make library from list of files; convert each source to object file name */
extern void make_library(const char *lib_filename, argv_t *src_files);

// check if the given filename exists and is a library file of the correct version
extern bool check_library_file(const char *src_filename);
