#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2019
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test https://github.com/z88dk/z88dk/issues/795
# Missing .lst file within lst file doesn't error

use Modern::Perl;
use Test::More;
require './t/testlib.pl';

unlink_testfiles();

spew("test1.asm", "defb 1");
spew("test2.asm", "defb 2");
spew("test1.lst", <<'...');
test1.asm
@test2.lst
test2.asm
...
unlink "test2.lst";

run('z80asm -b -otest.bin "@test1.lst"', 1, '', <<'...');
Error at file 'test1.lst' line 2: cannot read file 'test2.lst'
...


spew("test1.lst", <<'...');
test1.asm
@test2*.lst
test2.asm
...
unlink "test2.lst";

run('z80asm -b -otest.bin "@test1.lst"', 1, '', <<'...');
Error at file 'test1.lst' line 2: pattern 'test2*.lst' returned no files
...

unlink_testfiles();
done_testing();
