#------------------------------------------------------------------------------
# z80asm assembler
# Test z80asm-*.lib
# Copyright (C) Paulo Custodio, 2011-2019
# License: http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------

use Modern::Perl;
use Test::More;
use Path::Tiny;
require '../../t/testlib.pl';

my @CPUS = (qw( 8080 8085 gbz80 z80 r2k ));

my $test_nr;

for my $cpu (@CPUS) {
	for my $reg (qw( BC DE HL )) {
		for my $carry (0, 1) {
			for my $init (0, 0x1111, 0x2222, 0x8888) {
                $test_nr++;
                note "Test $test_nr: cpu:$cpu reg:$reg carry:$carry init:$init";
                my $init_carry = $carry ? "scf" : "and a";
                my $r = ticks(<<END, "-m$cpu");
                        ld		$reg, $init
                        $init_carry 
                        sra     $reg
                        jr	 	0		; need to keep SP
END
                my $res = ($init & 0x8000)|($init >> 1);
                
                is $r->{F_C}, ($init & 1) ? 1 : 0, "carry";
                is $r->{$reg}, $res, "result";
                        
                (Test::More->builder->is_passing) or die;
			}
		}
	}
}

unlink_testfiles();
done_testing();
