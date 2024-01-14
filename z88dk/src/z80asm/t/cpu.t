#!perl

#------------------------------------------------------------------------------
# Test cpu opcode files created by ../dev/cpu/cpu.pl
#------------------------------------------------------------------------------
use Modern::Perl;
use Test::More;
use File::Basename;
use Config;

# make sure to use our z80asm
$ENV{PATH} = ".".$Config{path_sep}.$ENV{PATH};

for my $file (<dev/cpu/cpu_test*.asm>) {
	# build cpu, ixiy, ok options from file name
	my $base = basename($file, ".asm");
	my $ok = $base =~ s/_ok//; $base =~ s/_err//;
	my $ixiy = $base =~ s/_ixiy//;
	my($cpu) = $base =~ /cpu_test(?:old)?_(\w+)$/; $cpu =~ tr/_/-/;
	
	# build command line
	my $cmd = "z80asm -m$cpu ".
			($ixiy ? "--IXIY " : "").
			" -m -l -b $file 2> test.err";
	
	# assembler output files
	(my $file_bin = $file) =~ s/\.asm$/.bin/;
	(my $file_o   = $file) =~ s/\.asm$/.o/;
	(my $file_err = $file) =~ s/\.asm$/.err/;
	(my $file_lis = $file) =~ s/\.asm$/.lis/;
	(my $file_map = $file) =~ s/\.asm$/.map/;
	unlink "test.err", $file_bin, $file_o, $file_err, $file_lis, $file_map;
	
	if ($ok) {
		# build binary image
		my $addr = 0;
		my %labels;
		my @patch;
		my @bin;
		if ($ok) {
			local(@ARGV) = $file;
			while (<>) {
				if (/^(\w+):/) {
					$labels{$1} = $addr;
				}
				else {
					s/.*;//;
					for (split(' ', $_)) {
						if (/^@(\w+)/) {
							push @patch, [$addr, $1];
							$bin[$addr++] = 0;
							$bin[$addr++] = 0;
						}
						else {
							$bin[$addr++] = hex($_);							
						}
					}
				}
			}
		}
		my $length = $addr;		# only compare output up to $length
		
		# run assembler
		ok system($cmd)==0, $cmd;
		ok -s "test.err" == 0, "no errors in stderr";
		ok !-f $file_err, "no $file_err";
		if (-f $file_err) {
			diag slurp($file_err);
		}

		# read labels from map file and patch @bin
		{
			local(@ARGV) = $file_map;
			while (<>) {
				if (/^ (\w+) \s* = \s* \$ ([0-9a-f]+) \s* ; \s* \w+ , \s+ public /ix) {
					my($name, $addr) = ($1, hex($2));
					if (exists $labels{$name}) {
						$labels{$name} == $addr or die "$name address mismatch";
					}
					else {
						$labels{$name} = $addr;
					}
				}
			}
			for (@patch) {
				my($addr, $name) = @$_;
				defined(my $value = $labels{$name}) or die "$name not found";
				$bin[$addr++] = $value & 0xFF;
				$bin[$addr++] = ($value >> 8) & 0xFF;
			}
		}
		my $bin = join('', map {chr} @bin);
		
		my $out_bin = substr(slurp($file_bin), 0, $length);
		ok $out_bin eq $bin, "$file_bin ok";
		if ($out_bin ne $bin) {
			my $addr = 0;
			while ($addr < length($out_bin) && $addr < length($bin) 
					&& substr($out_bin, $addr, 1) eq substr($bin, $addr, 1)) {
				$addr++;
			}
			diag sprintf("Output difers at \$%04X", $addr);
			diag "expected ", hexdump(substr($bin, $addr, 10));
			diag "got      ", hexdump(substr($out_bin, $addr, 10));
		}
	}
	else {
		# check that all lines have error messages
		my $num_lines = (slurp($file) =~ tr/\n/\n/);
		my @err_lines;
		
		# run assembler
		ok system($cmd)!=0, $cmd;
		ok -s "test.err", "errors in stderr";
		ok -f $file_err, "$file_err exists";
		local(@ARGV) = $file_err;
		while (<>) {
			if (/^Error .*? line (\d+)/ ||
				/^Warning .* line (\d+): interpreting indirect value as immediate/) {
				$err_lines[$1]++;
			}			
		}
		
		my @failed;
		for (1..$num_lines) {
			if (!$err_lines[$_]) { push @failed, $_; }
		}
		ok @failed==0, "all lines output errors";
		if (@failed) { diag "Failed tests: @failed"; }
	}
	
	if (Test::More->builder->is_passing) {
		unlink "test.err", $file_bin, $file_o, $file_err, $file_lis, $file_map;
	}
    else { 
        die;
    }
}

done_testing;

sub slurp {
	my($file) = @_;
	local $/;
	open(my $fh, "<:raw", $file) or die "$file: $!";
	return <$fh>;
}

sub hexdump {
	my($str) = @_;
	my $ret = '';
	for (split //, $str) {
		$ret .= sprintf("%02X ", ord($_));
	}
	return $ret;
}
