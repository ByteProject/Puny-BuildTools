#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2019
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#
# Test error messages

use Modern::Perl;
use Test::More;
use File::Copy;
use Time::HiRes 'sleep';
use File::Path qw(make_path remove_tree);;
use Capture::Tiny::Extended 'capture';
use Test::Differences;
use Path::Tiny;
require './t/test_utils.pl';

#------------------------------------------------------------------------------
# Black box tests
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# error_read_file
# CH_0012 : wrappers on OS calls to raise fatal error
unlink_testfiles();
t_z80asm_capture(asm_file(), "",
		"Error: cannot read file '".asm_file()."'\n",
		1);

unlink_testfiles();
t_z80asm_error('
	binary "'.inc_file().'"
	',
	"Error at file 'test.asm' line 2: cannot read file 'test.inc'",
	"-l");

unlink_testfiles();
write_file(asm_file(), "nop");
t_z80asm_capture("-b -ixxxx ".asm_file(), "",
		"Error: cannot read file 'xxxx.lib'\n",
		1);

#------------------------------------------------------------------------------
# error_expression
unlink_testfiles();
write_binfile(o_file(), objfile( NAME => "test",
								   CODE => [["", -1, 1, "\0\0"]],
								   EXPR => [ ["C", "test.asm",1, "", 0, 0, "", "*+VAL"] ] ));
t_z80asm_capture("-b -d ".o_file(),
				 "",
				 "Error at file 'test.asm' line 1: syntax error in expression\n",
				 1);

#------------------------------------------------------------------------------
# warn_int_range / error_int_range on pass2 and multi-module assembly
unlink_testfiles();

write_file(asm_file(), <<'ASM');
	extern G_129, G_128, G0, G127, G128, G255, G256

; Byte = -129
	ld	a, L_129
	ld	a, G_129
	ld	a, G0 - 129

; Byte = -128
	ld	a, L_128
	ld	a, G_128
	ld	a, G0 - 128

; Byte = 255
	ld	a, L255
	ld	a, G255
	ld	a, G0 + 255

; Byte = 256
	ld	a, L256
	ld	a, G256
	ld	a, G0 + 256

; SignedByte = -129
	ld	(ix + L_129), -1
	ld	(ix + G_129), -1
	ld	(ix + G0 -129), -1

; SignedByte = -128
	ld	(ix + L_128), -1
	ld	(ix + G_128), -1
	ld	(ix + G0 -128), -1

; SignedByte = 127
	ld	(ix + L127), -1
	ld	(ix + G127), -1
	ld	(ix + G0 + 127), -1

; SignedByte = 128
	ld	(ix + L128), -1
	ld	(ix + G128), -1
	ld	(ix + G0 + 128), -1

; Local variables
	defc L_129   = -129
	defc L_128   = -128
	defc L255    =  255
	defc L256    =  256
	defc L127    =  127
	defc L128    =  128
ASM

write_file(asm1_file(), <<'ASM1');

; Global variables
	public G_129, G_128, G0, G127, G128, G255, G256
	defc G_129   = -129
	defc G_128   = -128
	defc G0      =  0
	defc G127    =  127
	defc G128    =  128
	defc G255    =  255
	defc G256    =  256
ASM1

t_z80asm_capture("-b ".asm_file()." ".asm1_file(), "", <<'ERR', 0);
Warning at file 'test.asm' line 4: integer '-129' out of range
Warning at file 'test.asm' line 19: integer '256' out of range
Warning at file 'test.asm' line 24: integer '-129' out of range
Warning at file 'test.asm' line 39: integer '128' out of range
Warning at file 'test.asm' line 5: integer '-129' out of range
Warning at file 'test.asm' line 6: integer '-129' out of range
Warning at file 'test.asm' line 20: integer '256' out of range
Warning at file 'test.asm' line 21: integer '256' out of range
Warning at file 'test.asm' line 25: integer '-129' out of range
Warning at file 'test.asm' line 26: integer '-129' out of range
Warning at file 'test.asm' line 40: integer '128' out of range
Warning at file 'test.asm' line 41: integer '128' out of range
ERR

t_binary(read_binfile(bin_file()), pack("C*",
		0x3E, 0x7F,
		0x3E, 0x7F,
		0x3E, 0x7F,
		0x3E, 0x80,
		0x3E, 0x80,
		0x3E, 0x80,
		0x3E, 0xFF,
		0x3E, 0xFF,
		0x3E, 0xFF,
		0x3E, 0x00,
		0x3E, 0x00,
		0x3E, 0x00,
		0xDD, 0x36, 0x7F, 0xFF,
		0xDD, 0x36, 0x7F, 0xFF,
		0xDD, 0x36, 0x7F, 0xFF,
		0xDD, 0x36, 0x80, 0xFF,
		0xDD, 0x36, 0x80, 0xFF,
		0xDD, 0x36, 0x80, 0xFF,
		0xDD, 0x36, 0x7F, 0xFF,
		0xDD, 0x36, 0x7F, 0xFF,
		0xDD, 0x36, 0x7F, 0xFF,
		0xDD, 0x36, 0x80, 0xFF,
		0xDD, 0x36, 0x80, 0xFF,
		0xDD, 0x36, 0x80, 0xFF,
));

# defvar out of range - tested in directives.t
# defs out of range - tested in opcodes.t
# org out of range - tested in directives.t

# JR / DJNZ
for ([jr => chr(0x18)], [djnz => chr(0x10)])
{
	my($jump, $opcode) = @$_;

	t_z80asm(
		asm		=> "$jump ASMPC+2-129",
		err		=> "Error at file 'test.asm' line 1: integer '-129' out of range",
	);

	t_z80asm(
		asm		=> "$jump label : defc label = ASMPC-129",
		linkerr	=> "Error at file 'test.asm' line 1: integer '-129' out of range",
	);

	t_z80asm(
		asm		=> "$jump ASMPC+2+128",
		err		=> "Error at file 'test.asm' line 1: integer '128' out of range",
	);

	t_z80asm(
		asm		=> "$jump label : defc label = ASMPC+128",
		linkerr	=> "Error at file 'test.asm' line 1: integer '128' out of range",
	);

	for my $org (0, 0x8000, 0xFFFE) {
		t_z80asm(
			org		=> $org,
			asm		=> "$jump ASMPC+2-128",
			bin		=> "$opcode\x80",
		);

		t_z80asm(
			org		=> $org,
			asm		=> "$jump label : defc label = ASMPC-128",
			bin		=> "$opcode\x80",
		);

		t_z80asm(
			org		=> $org,
			asm		=> "$jump ASMPC+2+127",
			bin		=> "$opcode\x7F",
		);

		t_z80asm(
			org		=> $org,
			asm		=> "$jump label : defc label = ASMPC+127",
			bin		=> "$opcode\x7F",
		);

	}
}

#------------------------------------------------------------------------------
# error_unbanlanced_paren
unlink_testfiles();
t_z80asm_ok(0, "ld a,2*(1+2)", "\x3E\x06");
t_z80asm_ok(0, "ld a,2*[1+2]", "\x3E\x06");
t_z80asm_error("ld a,2*(1+2", 	"Error at file 'test.asm' line 1: syntax error in expression");
t_z80asm_error("ld a,2*(1+2]", 	"Error at file 'test.asm' line 1: syntax error in expression");
t_z80asm_error("ld a,2*[1+2", 	"Error at file 'test.asm' line 1: syntax error in expression");
t_z80asm_error("ld a,2*[1+2)", 	"Error at file 'test.asm' line 1: syntax error in expression");

#------------------------------------------------------------------------------
# error_not_defined
unlink_testfiles();
t_z80asm_error("ld a,NOSYMBOL", "Error at file 'test.asm' line 1: symbol 'NOSYMBOL' not defined");

#------------------------------------------------------------------------------
# error_not_defined_expr
my $lib = lib_file(); $lib =~ s/\.lib$/2.lib/i;
unlink_testfiles($lib);
write_file(asm_file(), "main: ret");
t_z80asm_capture("-x".$lib." ".asm_file(), "", "", 0);
ok -f $lib;
write_file(asm_file(), "EXTERN main \n call main");
t_z80asm_capture("-b -i".$lib." ".asm_file(), "",
		"Error at file 'test.asm' line 2: symbol 'main' not defined\n",
		1);

#------------------------------------------------------------------------------
# error_no_src_file
unlink_testfiles();
t_z80asm_capture("-b", "",
		"Error: source file missing\n", 1);

#------------------------------------------------------------------------------
# error_illegal_option
unlink_testfiles();
write_file(asm_file(), "");
t_z80asm_capture("-Zillegaloption ".asm_file(), "",
		"Error: illegal option: -Zillegaloption\n",
		1);
t_z80asm_capture("+Zillegaloption ".asm_file(), "",
		"Error: illegal option: +Zillegaloption\n",
		1);

#------------------------------------------------------------------------------
# fatal_max_codesize
unlink_testfiles();

# DEFM
t_z80asm_ok(0, "defs 65535, 'a' \n defm \"a\" \n",
	    "a" x 65536);
t_z80asm_error("defs 65536, 'a' \n defm \"a\" \n",
	       "Error at file 'test.asm' line 2: max. code size of 65536 bytes reached");

t_z80asm_ok(0, "defs 65534, 'a' \n defm \"aa\" \n",
	    "a" x 65536);
t_z80asm_error("defs 65535, 'a' \n defm \"aa\" \n",
	       "Error at file 'test.asm' line 2: max. code size of 65536 bytes reached");

t_z80asm_ok(0, "defs 65534, 'a' \n defm 97, \"a\" \n",
	    "a" x 65536);
t_z80asm_error("defs 65535, 'a' \n defm 97, \"a\" \n",
	       "Error at file 'test.asm' line 2: max. code size of 65536 bytes reached");

t_z80asm_ok(0, "defs 65534, 'a' \n defm 97 , \"a\" \n",
	    "a" x 65536);
t_z80asm_error("defs 65535, 'a' \n defm 97 , \"a\" \n",
	       "Error at file 'test.asm' line 2: max. code size of 65536 bytes reached");

t_z80asm_ok(0, "defs 65534, 'a' \n defm \"a\" , 97 \n",
	    "a" x 65536);
t_z80asm_error("defs 65535, 'a' \n defm \"a\" , 97 \n",
	       "Error at file 'test.asm' line 2: max. code size of 65536 bytes reached");

# BINARY - tested in directives.t

# Linker
write_file(asm1_file(), "defb 0xAA");

write_file(asm_file(), "defs 65535, 0xAA");
t_z80asm_capture(asm_file()." ".asm1_file(), "", "", 0);
t_z80asm_capture("-d -b ".asm_file()." ".asm1_file(), "", "", 0);
t_binary(read_binfile(bin_file()),
	"\xAA" x 65536);

write_file(asm_file(), "defs 65536, 0xAA");
t_z80asm_capture(asm_file()." ".asm1_file(), "", "", 0);
t_z80asm_capture("-d -b ".asm_file()." ".asm1_file(), "",
	"Error: max. code size of 65536 bytes reached\n", 1);

# parseline
t_z80asm_ok(0, "defs 65535, 0xAA \n defb 0xAA \n",
	    "\xAA" x 65536);
t_z80asm_error("defs 65536, 0xAA \n defb 0xAA \n",
	       "Error at file 'test.asm' line 2: max. code size of 65536 bytes reached");


#------------------------------------------------------------------------------
# error_symbol_redefined 		-> tested in symtab.t
# error_symbol_redefined_module	-> tested in symtab.t
# error_symbol_decl_local  		-> tested in symtab.t
# error_symbol_redecl			-> tested in symtab.t

#------------------------------------------------------------------------------
# error_illegal_src_filename
unlink_testfiles();
write_file(asm_file(), "nop");
t_z80asm_capture(asm_file()." -IllegalFilename", "",
		"Error: cannot read file '-IllegalFilename'\n", 1);

#------------------------------------------------------------------------------
# error_org_redefined - tested in directives.t

#------------------------------------------------------------------------------
# error_jr_not_local
unlink_testfiles();

t_z80asm(
	asm		=> " extern loop \n jr loop ",
	asm1	=> " public loop \n loop: ret ",
	bin		=> pack("C*", 0x18, 0x00, 0xc9),
);

#t_z80asm_error("
#	EXTERN loop
#	jr loop
#", "Error at file 'test.asm' line 3: relative jump address must be local");

#------------------------------------------------------------------------------
# error_obj_file_version
unlink_testfiles();
my $obj = objfile(NAME => "test", CODE => [["", -1, 1, "\x00"]] );
substr($obj,6,2)="99";		# change version
write_file(o_file(), $obj);
t_z80asm_capture("-b  ".o_file(), "", <<"END", 1);
Error: object file 'test.o' version 99, expected version 13
END

#------------------------------------------------------------------------------
# error_not_obj_file
unlink_testfiles();
write_file(o_file(), "not an object");
sleep 0.500;
write_file(asm_file(), "nop");
t_z80asm_capture("-b -d ".asm_file(), "", "", 0);
t_binary(read_binfile(o_file()), objfile(NAME => "test",
										   CODE => [["", -1, 1, "\x00"]],
										   ));
t_binary(read_binfile(bin_file()), "\x00");

# CreateLib uses a different error call
unlink_testfiles();
write_file(o_file(), "not an object");
sleep 0.500;
write_file(asm_file(), "nop");
t_z80asm_capture("-x".lib_file()." -d ".asm_file(), "", "", 0);
t_binary(read_binfile(lib_file()), libfile(objfile(NAME => "test",
												   CODE => [["", -1, 1, "\x00"]])));
unlink_testfiles();
write_binfile(o_file(), objfile( NAME => "test",
								   CODE => [["", -1, 1, "\0\0"]],
								   SYMBOLS => [ ["Z", "Z", "", 0, "ABCD", "", 0] ] ));
t_z80asm_capture("-b -d ".o_file(),
				 "",
				 "Error at module 'test': file 'test.o' not an object file\n".
				 "Error at module 'test': file 'test.o' not an object file\n",
				 1);

#------------------------------------------------------------------------------
# error_not_lib_file
unlink_testfiles();
write_file(asm_file(), "nop");
write_file(lib_file(), "not a library");
t_z80asm_capture("-b -i".lib_file()." ".asm_file(), "",
		"Error: file 'test.lib' not a library file\n",
		1);

#------------------------------------------------------------------------------
# error_lib_file_version
unlink_testfiles();
$lib = libfile(objfile(NAME => "test", CODE => [["", -1, 1, "\x00"]] ));
substr($lib,6,2)="99";		# change version
write_file(asm_file(), "nop");
write_file(lib_file(), $lib);
t_z80asm_capture("-b -i".lib_file()." ".asm_file(), "", <<"END", 1);
Error: library file 'test.lib' version 99, expected version 13
END

#------------------------------------------------------------------------------
# warn_expr_in_parens
unlink_testfiles();
write_file("test.asm", "cp (16)");
t_z80asm_capture("-b test.asm", "",
		"Warning at file 'test.asm' line 1: interpreting indirect value as immediate\n",
		0);
t_binary(read_binfile("test.bin"), "\xFE\x10");

unlink_testfiles();
write_file("test.asm", "cp +(16)");
t_z80asm_capture("-b test.asm", "",
		"",
		0);
t_binary(read_binfile("test.bin"), "\xFE\x10");

#------------------------------------------------------------------------------
# White box tests
#------------------------------------------------------------------------------
unlink_testfiles();

my $objs = "errors.o error_func.o scan.o lib/array.o lib/class.o lib/str.o lib/strhash.o lib/list.o  ../common/fileutil.o ../common/strutil.o ../common/die.o ../common/objfile.o ../../ext/regex/regcomp.o ../../ext/regex/regerror.o ../../ext/regex/regexec.o ../../ext/regex/regfree.o options.o model.o module.o sym.o symtab.o codearea.o expr.o listfile.o lib/srcfile.o macros.o hist.o lib/dbg.o ";
if ($^O eq 'MSWin32' || $^O eq 'msys') {
	  $objs .= "../../ext/UNIXem/src/glob.o ../../ext/UNIXem/src/dirent.o ";
}

# get init code except init() and main()
my $init = <<'END';

FILE *errfile;
char *GetLibfile( char *filename ) {return NULL;}

END

t_compile_module($init, <<'END', $objs);
#define ERROR return __LINE__
#define check_count(e) if (get_num_errors() != e) ERROR;

	check_count(0);

	warn("Information\n");
	check_count(0);

	warn("Warning\n");
	warn_symbol_different("main", "MAIN");
	check_count(0);

	warn("Error\n");
	error_syntax();
	check_count(1);

	warn("File error not caught\n");
	error_read_file("file.asm");
	warn("end\n");
END

t_run_module([], '', <<'ERR', 0);
Information
Warning
Warning: symbol 'main' used as 'MAIN'
Error
Error: syntax error
File error not caught
Error: cannot read file 'file.asm'
end
ERR


t_compile_module($init, <<'END', $objs);
#define ERROR return __LINE__
#define check_count(e) if (get_num_errors() != e) ERROR;
#define SYNTAX(file,module,line) \
	_count = get_num_errors(); \
	set_error_file(file); \
	set_error_module(module); \
	set_error_line(line); \
	error_syntax(); \
	check_count(_count + 1)

#define DOUBLE(x) #x #x
	int _count;

	check_count(0);

	warn("File error\n");
	error_read_file("file.asm");
	check_count(1);

	SYNTAX(	NULL,		NULL,	0 );
	SYNTAX(	NULL,		NULL,	1 );
	SYNTAX(	NULL,		"TEST",	0 );
	SYNTAX(	NULL,		"TEST",	1 );
	SYNTAX(	"test.asm",	NULL,	0 );
	SYNTAX(	"test.asm",	NULL,	1 );
	SYNTAX(	"test.asm",	"TEST",	0 );
	SYNTAX(	"test.asm",	"TEST",	1 );

	set_error_null();
	check_count(9);
	error_syntax();
	check_count(10);

	reset_error_count();
	check_count(0);

	open_error_file("test1.err");
	close_error_file();

	error_syntax();

	open_error_file("test2.err");
	error_syntax();
	close_error_file();

	open_error_file("test3.err");
	error_syntax();

	open_error_file("test2.err");
	error_syntax();
	close_error_file();

END

t_run_module([], '', <<'ERR', 0);
File error
Error: cannot read file 'file.asm'
Error: syntax error
Error at line 1: syntax error
Error at module 'TEST': syntax error
Error at module 'TEST' line 1: syntax error
Error at file 'test.asm': syntax error
Error at file 'test.asm' line 1: syntax error
Error at file 'test.asm' module 'TEST': syntax error
Error at file 'test.asm' module 'TEST' line 1: syntax error
Error: syntax error
Error: syntax error
Error: syntax error
Error: syntax error
Error: syntax error
ERR

ok ! -f "test1.err", "no errors, file deleted";

is_text( scalar(read_file('test2.err')), <<'END' );
Error: syntax error
Error: syntax error
END

is_text( scalar(read_file('test3.err')), <<'END' );
Error: syntax error
END

#------------------------------------------------------------------------------
# error_expected_const_expr
unlink_testfiles();
write_file("test.asm", <<'END');
	extern ZERO
	bit ZERO,a
	set ZERO,a
	res ZERO,a
	im 	ZERO
	rst ZERO
	bit undefined,a
	set undefined,a
	res undefined,a
	im 	undefined
	rst	undefined
END
t_z80asm_capture("-b test.asm", "", <<'ERR', 1);
Error at file 'test.asm' line 2: expected constant expression
Error at file 'test.asm' line 3: expected constant expression
Error at file 'test.asm' line 4: expected constant expression
Error at file 'test.asm' line 5: expected constant expression
Error at file 'test.asm' line 6: expected constant expression
Error at file 'test.asm' line 7: symbol 'undefined' not defined
Error at file 'test.asm' line 8: symbol 'undefined' not defined
Error at file 'test.asm' line 9: symbol 'undefined' not defined
Error at file 'test.asm' line 10: symbol 'undefined' not defined
Error at file 'test.asm' line 10: expected constant expression
Error at file 'test.asm' line 11: symbol 'undefined' not defined
Error at file 'test.asm' line 11: expected constant expression
ERR

unlink_testfiles();
done_testing();
