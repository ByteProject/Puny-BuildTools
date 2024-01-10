/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2019
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk
*/

#include "alloc.h"
#include "codearea.h"
#include "errors.h"
#include "expr.h"
#include "fileutil.h"
#include "listfile.h"
#include "modlink.h"
#include "options.h"
#include "scan.h"
#include "str.h"
#include "strutil.h"
#include "sym.h"
#include "symbol.h"
#include "z80asm.h"
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/* external functions */
struct libfile *NewLibrary( void );

/* local functions */
int LinkModule(const char *filename, long fptr_base, StrHash *extern_syms);
int LinkTracedModule(const char *filename, long baseptr );
int LinkLibModule(struct libfile *library, long curmodule, const char *modname, StrHash *extern_syms);
void CreateBinFile(void);
void ReadNames(const char *filename, FILE *file);
void ReleaseLinkInfo( void );
static void merge_modules(StrHash *extern_syms);

/* global variables */
extern char Z80objhdr[];
extern byte_t reloc_routine[];
extern struct liblist *libraryhdr;
extern char *reloctable, *relocptr;

struct linklist *linkhdr;
int totaladdr, curroffset;

static void ReadNames_1(const char *filename, FILE *file,
						str_t *section_name, str_t *name, str_t *def_filename)
{
    int scope, symbol_char;
	sym_type_t type = TYPE_UNKNOWN;
    long value;
	long line_nr;
	Symbol *sym = NULL;

    while (true)
    {
        scope = xfread_byte(file);
		if ( scope == 0 )
			break;								/* terminator */

        symbol_char	= xfread_byte(file);		/* type of name   */

		xfread_bcount_str(section_name, file);	/* read section name */

		value		= xfread_dword(file);		/* read symbol (long) integer */
		xfread_bcount_str(name, file);			/* read symbol name */

		// read symbol definition location
		xfread_bcount_str(def_filename, file);
		line_nr = xfread_dword(file);

		new_section( str_data(section_name) );		/* define CURRENTSECTION */

        switch ( symbol_char )
        {
        case 'A': type = TYPE_ADDRESS;  break;
        case 'C': type = TYPE_CONSTANT; break;
        case '=': type = TYPE_COMPUTED; break;
        default:
            error_not_obj_file( filename );
        }

        switch ( scope )
        {
		case 'L': sym = define_local_sym(str_data(name), value, type); break;
		case 'G': sym = define_global_sym(str_data(name), value, type); break;
        default:
            error_not_obj_file( filename );
        }

		// set symbol definition
		if (sym) {
			sym->filename = spool_add(str_data(def_filename));
			sym->line_nr = line_nr;
		}
    }
}

void ReadNames(const char *filename, FILE *file)
{
	str_t *section_name = str_new();
	str_t *name = str_new();
	str_t *def_filename = str_new();

	ReadNames_1(filename, file, 
				section_name, name, def_filename);

	str_free(section_name);
	str_free(name);
	str_free(def_filename);
}


/* set environment to compute expression */
static void set_asmpc_env(Module *module, const char *section_name,
	const char *filename, int line_nr,
	int asmpc,
	bool module_relative_addr)
{
	int base_addr, offset;

	/* point to current module */
	set_cur_module( module );

	/* source file and line number */
	set_error_file( filename );
	set_error_line( line_nr );

	/* assembler PC as absolute address */
	new_section( section_name );

	if ( module_relative_addr ) {
		set_PC( asmpc );
	}
	else {
		base_addr = CURRENTSECTION->addr;
		offset    = get_cur_module_start(); 
		set_PC( asmpc + base_addr + offset );
	}
}

/* set environment to compute expression */
static void set_expr_env( Expr *expr, bool module_relative_addr )
{
	set_asmpc_env( expr->module, expr->section->name, 
				   expr->filename, expr->line_nr, 
				   expr->asmpc,
				   module_relative_addr );
}

/* read the current modules' expressions to the given list */
static void read_cur_module_exprs_1(ExprList *exprs, FILE *file, char *filename,
	str_t *expr_text, str_t *last_filename, str_t *source_filename, 
	str_t *section_name, str_t *target_name)
{
	int line_nr;
	int type;
    Expr *expr;
    int asmpc, code_pos;

	while (1) 
	{
        type = xfread_byte(file);
		if ( type == 0 )
			break;			/* end marker */

		/* source file and line number */
		xfread_wcount_str(source_filename, file);
		if ( str_len(source_filename) == 0 )
			str_set( source_filename, str_data(last_filename) );
		else
			str_set( last_filename, str_data(source_filename) );

		line_nr = xfread_dword(file);

		/* patch location */
		xfread_bcount_str(section_name, file);

		asmpc		= xfread_word(file);
        code_pos	= xfread_word(file);

		xfread_bcount_str(target_name, file);	/* get expression EQU target, if not empty */
		xfread_wcount_str(expr_text, file);		/* get expression */

		/* read expression followed by newline */
		str_append(expr_text, "\n");
		SetTemporaryLine( str_data(expr_text) );			/* read expression */

        EOL = false;                /* reset end of line parsing flag - a line is to be parsed... */

		scan_expect_operands();
        GetSym();

		/* parse and store expression in the list */
		set_asmpc_env( CURRENTMODULE, str_data(section_name), 
					   str_data(source_filename), line_nr, 
					   asmpc,
					   false );
        if ( ( expr = expr_parse() ) != NULL )
        {
			expr->range = 0;
            switch ( type )
            {
            case 'U': expr->range = RANGE_BYTE_UNSIGNED; break;
            case 'S': expr->range = RANGE_BYTE_SIGNED;  break;
            case 'u': expr->range = RANGE_BYTE_TO_WORD_UNSIGNED; break;
            case 's': expr->range = RANGE_BYTE_TO_WORD_SIGNED; break;
            case 'C': expr->range = RANGE_WORD;			break;
			case 'B': expr->range = RANGE_WORD_BE;		break;
			case 'L': expr->range = RANGE_DWORD;		break;
			case 'J': expr->range = RANGE_JR_OFFSET;	break;
			case '=': expr->range = RANGE_WORD;
					  xassert( str_len(target_name) > 0 );
					  expr->target_name = spool_add( str_data(target_name) );	/* define expression as EQU */
					  break;
			default:
				error_not_obj_file( filename );
            }

			expr->module	= CURRENTMODULE;
			expr->section	= CURRENTSECTION;
			expr->asmpc		= asmpc;
			expr->code_pos	= code_pos;
			expr->filename	= spool_add( str_data(source_filename) );
			expr->line_nr	= line_nr;
			expr->listpos	= -1;

			ExprList_push( & exprs, expr );
		}
    }
}

static void read_cur_module_exprs(ExprList *exprs, FILE *file, char *filename)
{
	str_t *expr_text = str_new();
	str_t *last_filename = str_new();
	str_t *source_filename = str_new();
	str_t *section_name = str_new();
	str_t *target_name = str_new();

	read_cur_module_exprs_1(exprs, file, filename, 
		expr_text, last_filename, source_filename, section_name, target_name);

	str_free(expr_text);
	str_free(last_filename);
	str_free(source_filename);
	str_free(section_name);
	str_free(target_name);

}

/* read all the modules' expressions to the given list, or to the module's if NULL */
static void read_module_exprs( ExprList *exprs )
{
    long fptr_exprdecl;
    long fptr_base;
    struct linkedmod *curlink;
	FILE *file;

    curlink = linkhdr->firstlink;

    do
    {
		set_cur_module( curlink->moduleinfo );

        fptr_base = curlink->modulestart;

        set_error_null();

        /* open relocatable file for reading */
        file = fopen( curlink->objfilename, "rb" );	
		if (!file) {
			error_read_file(curlink->objfilename);
		}
		else {
			fseek(file, fptr_base + 8, SEEK_SET);			/* point at module name  pointer   */
			/*fptr_modname*/  xfread_dword(file);			/* get file pointer to module name */
			fptr_exprdecl = xfread_dword(file);			/* get file pointer to expression declarations */
			/*fptr_namedecl*/ xfread_dword(file);			/* get file pointer to name declarations */
			/*fptr_libnmdecl*/xfread_dword(file);			/* get file pointer to library name declarations */

			if (fptr_exprdecl != -1)
			{
				fseek(file, fptr_base + fptr_exprdecl, SEEK_SET);
				if (exprs != NULL)
					read_cur_module_exprs(exprs, file, curlink->objfilename);
				else
					read_cur_module_exprs(CURRENTMODULE->exprs, file, curlink->objfilename);
			}

			xfclose(file);
		}

        curlink = curlink->nextlink;
    }
    while ( curlink != NULL );

    set_error_null();
}

/* compute equ expressions and remove them from the list 
   return >0: number of computed expressions
   return 0 : nothing done, all EQU expression computed and removed from list
   return <0: -(number of expressions with unresolved symbols)
*/
static int compute_equ_exprs_once( ExprList *exprs, bool show_error, bool module_relative_addr )
{
	ExprListElem *iter;
    Expr *expr, *expr2;
	long value;
	int  num_computed   = 0;
	int  num_unresolved = 0;
	bool computed;

	iter = ExprList_first( exprs );
	while ( iter != NULL )
	{
		expr = iter->obj;
		computed = false;

		if ( expr->target_name )
		{
			/* touch symbol so that it ends in object file */
			Symbol *sym = get_used_symbol(expr->target_name);
			sym->is_touched = true;

			/* expressions with symbols from other sections need to be passed to the link phase */
			if (!module_relative_addr || /* link phase */
				(Expr_is_local_in_section(expr, CURRENTMODULE, CURRENTSECTION) &&	/* or symbols from other sections */
				 Expr_without_addresses(expr))		/* expression addressees - needs to be computed at link time */
				)
			{
				set_expr_env(expr, module_relative_addr);
				value = Expr_eval(expr, show_error);
				if (expr->result.not_evaluable)		/* unresolved */
				{
					num_unresolved++;
				}
				else if (!expr->is_computed)
				{
					/* expression depends on other variables not yet computed */
				}
				else
				{
					num_computed++;
					computed = true;
					update_symbol(expr->target_name, value, expr->type);
				}
			}
		}

		/* continue loop - delete expression if computed */
		if ( computed )
		{
			/* remove current expression, advance iterator */
			expr2 = ExprList_remove( exprs, &iter );
			xassert( expr == expr2 );

			OBJ_DELETE( expr );	
		}
		else
			iter = ExprList_next( iter );
	}

	if ( num_computed > 0 )
		return num_computed;
	else if ( num_unresolved > 0 )
		return - num_unresolved;
	else 
		return 0;
}

/* compute all equ expressions, removing them from the list */
void compute_equ_exprs( ExprList *exprs, bool show_error, bool module_relative_addr )
{
	int  compute_result;

	/* loop to solve dependencies while some are solved */
	do {
		compute_result = compute_equ_exprs_once( exprs, false, module_relative_addr );
	} while ( compute_result > 0 );

	/* if some unresolved, give up and show error */
	if ( show_error && compute_result < 0 )
		compute_equ_exprs_once( exprs, true, module_relative_addr );
}

/* compute and patch expressions */
static void patch_exprs( ExprList *exprs )
{
	ExprListElem *iter;
    Expr *expr, *expr2;
	long value, asmpc;

	iter = ExprList_first( exprs );
	while ( iter != NULL )
	{
		expr = iter->obj;
		xassert( expr->target_name == NULL );		/* EQU expressions are already computed */

		set_expr_env( expr, false );
		value = Expr_eval(expr, true);

		if (!expr->result.not_evaluable)			/* not unresolved */
		{
            switch ( expr->range )
            {
            case RANGE_BYTE_UNSIGNED:
                if ( value < -128 || value > 255 )
                    warn_int_range( value );

				patch_byte(expr->code_pos, (byte_t)value);
                break;

            case RANGE_BYTE_SIGNED:
                if ( value < -128 || value > 127 )
                    warn_int_range( value );

				patch_byte(expr->code_pos, (byte_t)value);
                break;

            case RANGE_BYTE_TO_WORD_UNSIGNED:
                if (value < 0 || value > 255)
                    warn_int_range(value);

                patch_byte(expr->code_pos, (byte_t)value);
                patch_byte(expr->code_pos+1, 0);
                break;

            case RANGE_BYTE_TO_WORD_SIGNED:
                if (value < -128 || value > 127)
                    warn_int_range(value);

                patch_byte(expr->code_pos, (byte_t)value);
                patch_byte(expr->code_pos + 1, value < 0 || value > 127 ? 0xff : 0);
                break;

            case RANGE_WORD:
				patch_word(expr->code_pos, value); 

				/* Expression contains relocatable address */
				if (expr->type == TYPE_ADDRESS) {

					/* save section reloc data */
					*(intArray_push(expr->section->reloc)) = expr->code_pos + get_cur_module_start();
				
					/* relocate code */
					if (opts.relocatable)
					{
						int offset = get_cur_module_start() + expr->section->addr;
						int distance = expr->code_pos + offset - curroffset;

						if (distance > 0 && distance < 256)	// Bugfix: when zero, need to use 3 bytes
						{
							*relocptr++ = (byte_t)distance;
							sizeof_reloctable++;
						}
						else
						{
							*relocptr++ = 0;
							*relocptr++ = distance & 0xFF;
							*relocptr++ = distance >> 8;
							sizeof_reloctable += 3;
						}

						totaladdr++;
						curroffset = expr->code_pos + offset;
					}
				}                
                break;

			case RANGE_WORD_BE:
				patch_word_be(expr->code_pos, value);
				break;

			case RANGE_DWORD:
				patch_long(expr->code_pos, value);
                break;

			case RANGE_JR_OFFSET:
				asmpc = get_phased_PC() >= 0 ? get_phased_PC() : get_PC();
				value -= asmpc + 2;		/* get module PC at JR instruction */

				if (value < -128 || value > 127)
					error_int_range(value);

				patch_byte(expr->code_pos, (byte_t)value);
				break;

			default: xassert(0);
            }

		}

		/* remove current expression, advance iterator */
		expr2 = ExprList_remove( exprs, &iter );
		xassert( expr == expr2 );

		OBJ_DELETE( expr );	
	}
}

/*-----------------------------------------------------------------------------
*   relocate all SYM_ADDR symbols based on address from start of sections
*----------------------------------------------------------------------------*/
static void relocate_symbols_symtab( SymbolHash *symtab )
{
    SymbolHashElem *iter;
    Symbol         *sym;
	int			base_addr;
	int			offset;

    for ( iter = SymbolHash_first( symtab ); iter; iter = SymbolHash_next( iter ) )
    {
        sym = (Symbol *) iter->value;
		if ( sym->type == TYPE_ADDRESS ) 
		{
			xassert( sym->module );				/* owner should exist except for -D defines */
			
			/* set base address for symbol */
			set_cur_module(  sym->module );
			set_cur_section( sym->section );

 			base_addr = sym->section->addr;
			offset    = get_cur_module_start();

            sym->value += base_addr + offset;	/* Absolute address */
			sym->is_computed = true;
		}
	}
}

static void relocate_symbols( void )
{
    Module		   *module;
	ModuleListElem *iter;

	for ( module = get_first_module( &iter ) ; module != NULL  ;
		  module = get_next_module( &iter ) )  
    {
		relocate_symbols_symtab( module->local_symtab );
	}
	relocate_symbols_symtab( global_symtab );
}

/*-----------------------------------------------------------------------------
*   Define symbols with sections and code start, end and size
*----------------------------------------------------------------------------*/
static void define_location_symbols( void )
{
	Section *section;
	SectionHashElem *iter;
	STR_DEFINE( name, STR_SIZE );
	int start_addr, end_addr;

	/* global code size */
	start_addr = get_first_section(NULL)->addr;
	section    = get_last_section();
	end_addr   = section->addr + get_section_size( section );
	
	if (opts.verbose)
		printf("Code size: %d bytes ($%04X to $%04X)\n",
			(int)(get_sections_size()), (int)start_addr, (int)end_addr - 1);

	Str_sprintf( name, ASMHEAD_KW, "", "" ); 
	define_global_def_sym( Str_data(name), start_addr );
	
	Str_sprintf( name, ASMTAIL_KW, "", "" ); 
	define_global_def_sym( Str_data(name), end_addr );
	
	Str_sprintf( name, ASMSIZE_KW, "", "" ); 
	define_global_def_sym( Str_data(name), end_addr - start_addr );

	/* size of each named section - skip "" section */
	for ( section = get_first_section( &iter ) ; section != NULL ; 
		  section = get_next_section( &iter ) )
	{
		if ( *(section->name) != '\0' )
		{
			start_addr = section->addr;
			end_addr   = start_addr + get_section_size( section );

			if (opts.verbose)
				printf("Section '%s' size: %d bytes ($%04X to $%04X)\n",
					section->name, (int)(end_addr - start_addr),
					(unsigned int)start_addr, (unsigned int)end_addr - 1);

			Str_sprintf(name, ASMHEAD_KW, section->name, "_");
			define_global_def_sym(Str_data(name), start_addr);

			Str_sprintf(name, ASMTAIL_KW, section->name, "_");
			define_global_def_sym(Str_data(name), end_addr);

			Str_sprintf(name, ASMSIZE_KW, section->name, "_");
			define_global_def_sym(Str_data(name), end_addr - start_addr);
		}
	}

	STR_DELETE(name);
}

/*-----------------------------------------------------------------------------
*   link used libraries
*----------------------------------------------------------------------------*/

/* check if there are symbols not yet linked */
static bool pending_syms(StrHash *extern_syms)
{
	StrHashElem *elem, *next;

	/* delete defined symbols */
	for (elem = StrHash_first(extern_syms); elem != NULL; elem = next) {
		next = StrHash_next(elem);
		if (find_global_symbol(elem->key) != NULL) {		/* symbol defined */
			StrHash_remove_elem(extern_syms, elem);
		}
	}

	if (StrHash_empty(extern_syms))
		return false;
	else
		return true;
}

/* search one module for unresolved symbols and link if needed */
/* ignore module name - check only symbols */
static bool linked_module(struct libfile *lib, FILE *file, long obj_fpos, StrHash *extern_syms)
{
	long names_fpos, modname_fpos;
	bool linked = false;
	bool found_symbol;
	
	str_t *module_name = str_new();
	str_t *def_filename = str_new();
	str_t *symbol_name = str_new();
	str_t *section_name = str_new();

	/* read module name */
	fseek(file, obj_fpos + 8, SEEK_SET);
	modname_fpos = xfread_dword(file);
	fseek(file, obj_fpos + modname_fpos, SEEK_SET);
	xfread_bcount_str(module_name, file);

	/* names section */
	fseek(file, obj_fpos + 8 + 4 + 4, SEEK_SET);
	names_fpos = xfread_dword(file);

	if (names_fpos != -1) {
		fseek(file, obj_fpos + names_fpos, SEEK_SET);

		/* search list of defined symbols */
		for (found_symbol = false; !found_symbol;) {
			int scope;

			scope = xfread_byte(file);
			if (scope == 0)
				break;

			xfread_byte(file);			/* type */
			xfread_bcount_str(section_name, file);
			xfread_dword(file);			/* value */
			xfread_bcount_str(symbol_name, file);
			xfread_bcount_str(def_filename, file);
			xfread_dword(file);			/* line_nr */

			if (scope == 'G' && StrHash_exists(extern_syms, str_data(symbol_name)))
				found_symbol = true;
		}

		/* link module if found one needed symbol */
		if (found_symbol) {
			LinkLibModule(lib, obj_fpos, str_data(module_name), extern_syms);
			linked = true;
		}
	}

	str_free(module_name);
	str_free(def_filename);
	str_free(symbol_name);
	str_free(section_name);

	return linked;
}

/* search chain of libraries for modules that resolve any of the pending syms, break search after first found module */
static bool linked_libraries(StrHash *extern_syms)
{
	bool linked = false;
	struct libfile *lib;
	FILE *file;
	long obj_fpos, obj_next_fpos, module_size;

	/* search library chain */
	for (lib = libraryhdr->firstlib; !linked && lib != NULL; lib = lib->nextlib) {
		
		file = fopen(lib->libfilename, "rb");
		if (!file) {
			error_read_file(lib->libfilename);
		}
		else {
			/* search object module chain */
			for (obj_fpos = 8; !linked && obj_fpos != -1; obj_fpos = obj_next_fpos) {
				fseek(file, obj_fpos, SEEK_SET);			/* point at beginning of a module */
				
				// check if library file ended prematurely
				int c = fgetc(file);
				if (c == EOF)
					break;									// end of library file, exit loop
				else
					ungetc(c, file);

				obj_next_fpos = xfread_dword(file);			/* get file pointer to next module in library */
				module_size = xfread_dword(file);			/* get size of current module */

				if (module_size == 0)
					continue;								/* deleted module */

				if (linked_module(lib, file, obj_fpos + 4 + 4, extern_syms))
					linked = true;
			}

			xfclose(file);
		}
	}

	return linked;
}

/* link libraries in the order given in the command line */
static void link_libraries(StrHash *extern_syms)
{
	/* while symbols to resolve and new module pulled in */
	while (pending_syms(extern_syms) && linked_libraries(extern_syms)) {
		/* loop */
	}
}

/*-----------------------------------------------------------------------------
*   link
*----------------------------------------------------------------------------*/
void link_modules( void )
{
    Module *module, *first_obj_module;
	ModuleListElem *iter;
	ExprList *exprs = NULL;
	StrHash *extern_syms = OBJ_NEW(StrHash);

    opts.cur_list = false;
    linkhdr = NULL;

    if ( opts.relocatable )
    {
        reloctable = m_new_n( char, 32768U );
        relocptr = reloctable;
        relocptr += 4;  /* point at first offset to store */
        totaladdr = 0;
        sizeof_reloctable = 0;  /* relocation table, still 0 elements .. */
        curroffset = 0;
    }
    else
    {
        reloctable = NULL;
    }

	/* remember current first modules */
	first_obj_module = get_first_module(&iter);

	/* link machine code & read symbols in all modules */
	for (module = first_obj_module; module != NULL; module = get_next_module(&iter))
	{
		set_cur_module(module);

		/* open error file on first module */
		if (CURRENTMODULE == first_obj_module)
			open_error_file(CURRENTMODULE->filename);

		set_error_null();
		set_error_module(CURRENTMODULE->modname);

		/* overwrite '.asm' extension with * '.o' */
		const char *obj_filename = get_obj_filename(CURRENTMODULE->filename);

		/* open relocatable file for reading */
		if (!check_object_file(obj_filename))
			break;

		/* link code & read name definitions */
		LinkModule(obj_filename, 0, extern_syms);       
	}

	/* link libraries */
	/* consol_obj_file do not include libraries */
	if (!get_num_errors() && !opts.consol_obj_file && opts.library)
		link_libraries(extern_syms);

	set_error_null();

	/* allocate segment addresses and compute absolute addresses of symbols */
	/* in consol_obj_file sections are zero-based */
	if (!get_num_errors() && !opts.consol_obj_file)	
		sections_alloc_addr();

	/* relocate address symbols */
	if (!get_num_errors())
		relocate_symbols();

	/* define assembly size */
	if (!get_num_errors() && !opts.consol_obj_file)
		define_location_symbols();

	if (opts.consol_obj_file) {
		if (!get_num_errors())
			merge_modules(extern_syms);
	}
	else {
		/* collect expressions from all modules */
		exprs = OBJ_NEW(ExprList);
		if (!get_num_errors())
			read_module_exprs(exprs);

		/* compute all EQU expressions */
		if (!get_num_errors())
			compute_equ_exprs(exprs, true, false);

		/* patch all other expressions */
		if (!get_num_errors())
			patch_exprs(exprs);

		OBJ_DELETE(exprs);
	}

	set_error_null();

	ReleaseLinkInfo();              /* Release module link information */

	close_error_file();

	if (!get_num_errors()) {
		if (opts.map)
			write_map_file();

		if (opts.globaldef)
			write_def_file();
	}

	OBJ_DELETE(extern_syms);
}




static int LinkModule_1(const char *filename, long fptr_base, str_t *section_name, StrHash *extern_syms)
{
    long fptr_namedecl, fptr_modname, fptr_modcode, fptr_libnmdecl;
    int code_size;
	FILE *file;
	Section *section;

    /* open object file for reading */
    file = fopen( filename, "rb" );           
	if (!file) {
		error_read_file(filename);
	}
	else {
		fseek(file, fptr_base + 8, SEEK_SET);

		fptr_modname = xfread_dword(file);	/* get file pointer to module name */
		xfread_dword(file);	/* get file pointer to expression declarations */
		fptr_namedecl = xfread_dword(file);	/* get file pointer to name declarations */
		fptr_libnmdecl = xfread_dword(file);	/* get file pointer to library name declarations */
		fptr_modcode = xfread_dword(file);	/* get file pointer to module code */

		if (fptr_modcode != -1)
		{
			fseek(file, fptr_base + fptr_modcode, SEEK_SET);  /* set file pointer to module code */

			while (true)	/* read sections until end marker */
			{
				code_size = xfread_dword(file);
				if (code_size < 0)
					break;

				/* load bytes to section */
				/* BUG_0015: was reading at current position in code area, swaping order of modules */
				xfread_bcount_str(section_name, file);
				section = new_section(str_data(section_name));
				read_origin(file, section);
				section->align = xfread_dword(file);

				/* if creating relocatable code, ignore origin */
				if (opts.relocatable && section->origin >= 0) {
					warn_org_ignored(filename, str_data(section_name));
					section->origin = -1;
					section->section_split = false;
				}

				patch_file_contents(file, 0, code_size);
			}
		}

		if (fptr_namedecl != -1)
		{
			fseek(file, fptr_base + fptr_namedecl, SEEK_SET);  /* set file pointer to point at name
															   * declarations */
			ReadNames(filename, file);
		}

		// collect list of external symbols
		if (fptr_libnmdecl != -1)
		{
			str_t *name = str_new();
			const char *name_p;
			long p;

			for (p = fptr_libnmdecl; p < fptr_modname;) {
				fseek(file, fptr_base + p, SEEK_SET);			/* set file pointer to point at external name declaration */
				xfread_bcount_str(name, file);					/* read library reference name */
				p += 1 + str_len(name);							/* point to next name */
				name_p = spool_add(str_data(name));
				StrHash_set(&extern_syms, name_p, (void*)name_p);		/* remember all extern references */
			}
			str_free(name);
		}

		xfclose(file);
	}

    return LinkTracedModule( filename, fptr_base );       /* Remember module for pass2 */
}

int LinkModule(const char *filename, long fptr_base, StrHash *extern_syms)
{
	str_t *section_name = str_new();
	int ret = LinkModule_1(filename, fptr_base, section_name, extern_syms);
	str_free(section_name);
	return ret;
}


int
LinkLibModule(struct libfile *library, long curmodule, const char *modname, StrHash *extern_syms)
{
    Module *tmpmodule, *lib_module;
    int flag;

    tmpmodule = get_cur_module();					/* remember current module */

	/* create new module to link library */
	lib_module = set_cur_module( new_module() );
	lib_module->modname = spool_add( modname );

    if ( opts.verbose )
        printf( "Linking library module '%s'\n", modname );

	flag = LinkModule(library->libfilename, curmodule, extern_syms);       /* link module & read names */

    set_cur_module( tmpmodule );		/* restore previous current module */
    return flag;
}


void
CreateBinFile( void )
{
	FILE *binaryfile, *inital_binaryfile;
	FILE *relocfile, *initial_relocfile;
	const char *filename;
	bool is_relocatable = ( opts.relocatable && totaladdr != 0 );

    if ( opts.bin_file )        /* use predined output filename from command line */
        filename = opts.bin_file;
    else						/* create output filename, based on project filename */
        filename = get_bin_filename( get_first_module(NULL)->filename );		/* add '.bin' extension */

    /* binary output to filename.bin */
	if (opts.verbose)
		printf("Creating binary '%s'\n", path_canon(filename));

    binaryfile = xfopen( filename, "wb" );
	inital_binaryfile = binaryfile;

	relocfile = opts.relocatable ? NULL : opts.reloc_info ? xfopen(get_reloc_filename(filename), "wb") : NULL;
	initial_relocfile = relocfile;

	if (binaryfile)
	{
		if (is_relocatable)
		{
			/* relocate routine */
			xfwrite_bytes((char *)reloc_routine, sizeof_relocroutine, binaryfile);

			*(reloctable + 0) = (byte_t)totaladdr % 256U;
			*(reloctable + 1) = (byte_t)totaladdr / 256U;  /* total of relocation elements */
			*(reloctable + 2) = (byte_t)sizeof_reloctable % 256U;
			*(reloctable + 3) = (byte_t)sizeof_reloctable / 256U; /* total size of relocation table elements */

			/* write relocation table, inclusive 4 byte header */
			xfwrite_bytes(reloctable, sizeof_reloctable + 4, binaryfile);

			printf("Relocation header is %d bytes.\n", (int)(sizeof_relocroutine + sizeof_reloctable + 4));
		}

		fwrite_codearea(filename, &binaryfile, &relocfile);		/* write code as one big chunk */

		/* delete output file if empty, except main output file */
		if (binaryfile == inital_binaryfile)
			xfclose(binaryfile);
		else
			xfclose_remove_empty(binaryfile);

		if (relocfile != NULL) {
			if (relocfile == initial_relocfile)
				xfclose(relocfile);
			else
				xfclose_remove_empty(relocfile);
		}
	}
}


int
LinkTracedModule(const char *filename, long baseptr )
{
    struct linkedmod *newm;
    char *fname;

    if ( linkhdr == NULL )
    {
        linkhdr = m_new( struct linklist );
        linkhdr->firstlink = NULL;
        linkhdr->lastlink = NULL;       /* Library header initialised */
    }

    fname = m_strdup( filename );        /* get a copy module file name */

    newm = m_new( struct linkedmod );
    newm->nextlink = NULL;
    newm->objfilename = fname;
    newm->modulestart = baseptr;
    newm->moduleinfo = CURRENTMODULE;   /* pointer to current (active) module structure   */

    if ( linkhdr->firstlink == NULL )
    {
        linkhdr->firstlink = newm;
        linkhdr->lastlink = newm;       /* First module trace information */
    }
    else
    {
        linkhdr->lastlink->nextlink = newm;     /* current/last linked module points now at new current */
        linkhdr->lastlink = newm;               /* pointer to current linked module updated */
    }

    return 1;
}


void
ReleaseLinkInfo( void )
{
    struct linkedmod *m, *n;

    if ( linkhdr == NULL )
    {
        return;
    }

    m = linkhdr->firstlink;

    while ( m != NULL )               /* move test to start in case list is empty */
    {
        if ( m->objfilename != NULL )
        {
            m_free( m->objfilename );
        }

        n = m->nextlink;
        m_free( m );
        m = n;
    }

    m_free( linkhdr );

    linkhdr = NULL;
}

/* Consolidate object file */
static int sym_first(int c) { return c == '_' || isalpha(c); }
static int sym_next(int c)  { return c == '_' || isalnum(c); }

static void replace_names(Str *result, const char *input, StrHash *map)
{
	STR_DEFINE(key, STR_SIZE);
	const char *elem;
	const char *p0;
	const char *p1;
	Str_clear(result);

	p0 = input;
	while (*p0) {
		if (sym_first(*p0)) {
			p1 = p0 + 1;
			while (*p1 && sym_next(*p1))
				p1++;
			Str_set_n(key, p0, p1 - p0);
			elem = (const char*)StrHash_get(map, Str_data(key));
			if (elem)
				Str_append(result, (char *)elem);
			else
				Str_append(result, Str_data(key));
			p0 = p1;
		}
		else {				/* /\W+/ */
			p1 = p0 + 1;
			while (*p1 && !sym_first(*p1))
				p1++;
			Str_append_n(result, p0, p1 - p0);
			p0 = p1;
		}
	}
}

static void rename_module_local_symbols(Module *module)
{
	Symbol *sym;
	SymbolHashElem *sym_it;
	StrHash *old_syms = OBJ_NEW(StrHash);
	StrHashElem *name_it;
	Expr *expr;
	ExprListElem *expr_it;
	const char *old_name;
	const char *value;
	STR_DEFINE(new_name, STR_SIZE);
	STR_DEFINE(new_text, STR_SIZE);

	/* collect list of symbol names to change - cannot iterate through symbols hash while changing it */
	for (sym_it = SymbolHash_first(module->local_symtab); sym_it != NULL; sym_it = SymbolHash_next(sym_it)) {
		sym = (Symbol *)sym_it->value;

		old_name = spool_add(sym->name);
		Str_sprintf(new_name, "%s_%s", module->modname, old_name);
		StrHash_set(&old_syms, old_name, (void*)spool_add(Str_data(new_name)));
	}

	/* change symbol names */
	for (name_it = StrHash_first(old_syms); name_it != NULL; name_it = StrHash_next(name_it)) {
		value = spool_add(name_it->value);

		sym = SymbolHash_extract(module->local_symtab, name_it->key);
		sym->name = value;
		SymbolHash_set(&module->local_symtab, value, sym);
	}

	/* rename symbols in expressions */
	for (expr_it = ExprList_first(module->exprs); expr_it != NULL; expr_it = ExprList_next(expr_it)) {
		expr = expr_it->obj;

		/* rpn_ops already point to symbol table, no rename needed - change only text and target_name */
		replace_names(new_text, Str_data(expr->text), old_syms);
		Str_set(expr->text, Str_data(new_text));

		if (expr->target_name) {
			replace_names(new_text, expr->target_name, old_syms);
			expr->target_name = spool_add(Str_data(new_text));
		}
	}

	OBJ_DELETE(old_syms);
}

static void merge_local_symbols(StrHash *extern_syms)
{
	Module *module;
	Module *first_module;
	ModuleListElem *it;
	Symbol *sym;
	SymbolHashElem *sym_it, *next_sym;
	Expr *expr;
	StrHashElem *elem, *next;
	int start;

	first_module = get_first_module(NULL); xassert(first_module != NULL);

	for (module = get_first_module(&it); module != NULL; module = get_next_module(&it)) {
		/* remove local symbols that are not defined */
		for (sym_it = SymbolHash_first(module->local_symtab); sym_it != NULL; sym_it = next_sym) {
			next_sym = SymbolHash_next(sym_it);
			sym = (Symbol *)sym_it->value;
			if (!sym->is_defined)
				SymbolHash_remove_elem(module->local_symtab, sym_it);
		}

		/* remove extern_syms defined in this module */
		for (elem = StrHash_first(extern_syms); elem != NULL; elem = next) {
			next = StrHash_next(elem);

			sym = find_local_symbol(elem->key);
			if (sym == NULL) 
				sym = find_global_symbol(elem->key);
			if (sym != NULL && sym->is_defined) {		/* symbol defined */
				StrHash_remove_elem(extern_syms, elem);
			}
		}

		/* prepend module name to all local symbols */
		rename_module_local_symbols(module);

		if (module != first_module) {
			/* move local symbols */
			while ((sym_it = SymbolHash_first(module->local_symtab)) != NULL) {
				sym = SymbolHash_extract(module->local_symtab, sym_it->key);
				SymbolHash_set(&first_module->local_symtab, sym->name, sym);
			}

			/* move local expressions */
			while ((expr = ExprList_pop(module->exprs)) != NULL) {
				ExprList_push(&first_module->exprs, expr);
				
				/* relocate expression address */
				set_cur_module(expr->module);
				set_cur_section(expr->section);
				start = get_cur_module_start();
				expr->asmpc += start;
				expr->code_pos += start;

				set_cur_module(first_module);
			}
		}
	}
}

static void merge_codearea()
{
	Section *section;
	SectionHashElem *iter;

	for (section = get_first_section(&iter); section != NULL; section = get_next_section(&iter)) {
		intArray_set_size(section->module_start, 1);		/* delete all module boundaries */
	}
}

static void touch_symtab_symbols(SymbolHash *symtab)
{
	SymbolHashElem *iter;
	Symbol         *sym;

	for (iter = SymbolHash_first(symtab); iter; iter = SymbolHash_next(iter)) {
		sym = (Symbol *)iter->value;
		//Bug 563 -- if (sym->type == TYPE_ADDRESS || sym->scope == SCOPE_EXTERN)
			sym->is_touched = true;
	}
}

static void touch_symbols()
{
	Module *module;
	ModuleListElem *it;

	for (module = get_first_module(&it); module != NULL; module = get_next_module(&it)) {
		touch_symtab_symbols(module->local_symtab);
	}
	touch_symtab_symbols(global_symtab);
}

static void create_extern_symbols(StrHash *extern_syms)
{
	StrHashElem *elem;

	for (elem = StrHash_first(extern_syms); elem != NULL; elem = StrHash_next(elem)) {
		const char *name = elem->key;
		if (!find_local_symbol(name) && !find_global_symbol(name))
			declare_extern_symbol(name);
	}
}

static void merge_modules(StrHash *extern_syms)
{
	Module *first_module;
	first_module = get_first_module(NULL); xassert(first_module != NULL);

	/* read each module's expression list */
	set_cur_module(first_module);
	read_module_exprs(NULL);

	/* merge local symbols to avoid name clashes in merged module */
	set_cur_module(first_module);
	merge_local_symbols(extern_syms);

	/* merge code areas */
	set_cur_module(first_module);
	merge_codearea();

	/* create extern symbols */
	set_cur_module(first_module);
	create_extern_symbols(extern_syms);

	/* touch symbols so that they are copied to the output object file */
	set_cur_module(first_module);
	touch_symbols();
}
