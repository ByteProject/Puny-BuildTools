//-----------------------------------------------------------------------------
// z80asm unit tests
// Copyright (C) Paulo Custodio, 2011-2019
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#include "unity.h"
#include "die.h"

#include <stdlib.h>
#include <string.h>

void setUp() {}
void tearDown() {}

#define T(name) \
			extern void name(void); \
			RUN_TEST(name)

int main(int argc, char *argv[])
{
	if (argc == 2) {
#include "test1.hh"
		xassert(0);
	}
	else {
		UNITY_BEGIN();
#include "test2.hh"
		return UNITY_END();
	}
}
