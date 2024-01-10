/*
 *			    C P P 4 . C
 *		M a c r o  D e f i n i t i o n s
 *
 * $Id: cpp4.c,v 1.8 2016-03-29 11:44:18 dom Exp $
 *
 *
 * Edit History
 * 31-Aug-84	MM	USENET net.sources release
 * 04-Oct-84	MM	__LINE__ and __FILE__ must call ungetstring()
 *			so they work correctly with token concatenation.
 *			Added string formal recognition.
 * 25-Oct-84	MM	"Short-circuit" evaluate #if's so that we
 *			don't print unnecessary error messages for
 *			#if !defined(FOO) && FOO != 0 && 10 / FOO ...
 * 31-Oct-84	ado/MM	Added token concatenation
 *  6-Nov-84	MM	Split off eval stuff
 *
 */

#include	<stdio.h>
#include	<ctype.h>
#include	<stdlib.h>
#include	<string.h>
#include	"cppdef.h"
#include	"cpp.h"
/*
 * parm[], parmp, and parlist[] are used to store #define() argument
 * lists.  nargs contains the actual number of parameters stored.
 */
static char	parm[NPARMWORK + 1];	/* define param work buffer 	*/
static char	*parmp;			/* Free space in parm		*/
static char	*parlist[LASTPARM];	/* -> start of each parameter	*/
static int	nargs;			/* Parameters for this macro	*/

FILE_LOCAL void stparmscan(int delim);
FILE_LOCAL void checkparm(register int	c, DEFBUF *dp);
FILE_LOCAL void charput(int c);
FILE_LOCAL int expcollect();
FILE_LOCAL void expstuff(DEFBUF *tokenp);	/* Current macro being expanded	*/

void dodefine()
/*
 * Called from control when a #define is scanned.  This module
 * parses formal parameters and the replacement string.  When
 * the formal parameter name is encountered in the replacement
 * string, it is replaced by a character in the range 128 to
 * 128+NPARAM (this allows up to 32 parameters within the
 * Dec Multinational range).  If cpp is ported to an EBCDIC
 * machine, you will have to make other arrangements.
 *
 * There is some special case code to distinguish
 *	#define foo	bar
 * from	#define foo()	bar
 *
 * Also, we make sure that
 *	#define	foo	foo
 * expands to "foo" but doesn't put cpp into an infinite loop.
 *
 * A warning message is printed if you redefine a symbol to a
 * different text.  I.e,
 *	#define	foo	123
 *	#define foo	123
 * is ok, but
 *	#define foo	123
 *	#define	foo	+123
 * is not.
 *
 * The following subroutines are called from define():
 * checkparm	called when a token is scanned.  It checks through the
 *		array of formal parameters.  If a match is found, the
 *		token is replaced by a control byte which will be used
 *		to locate the parameter when the macro is expanded.
 * textput	puts a string in the macro work area (parm[]), updating
 *		parmp to point to the first free byte in parm[].
 *		textput() tests for work buffer overflow.
 * charput	puts a single character in the macro work area (parm[])
 *		in a manner analogous to textput().
 */
{
	register int		c;
	register DEFBUF		*dp;		/* -> new definition	*/
	int			isredefine;	/* TRUE if redefined	*/
	char			*old;		/* Remember redefined	*/

	if (type[(c = skipws())] != LET)
	    goto bad_define;
	isredefine = FALSE;			/* Set if redefining	*/
	if ((dp = lookid(c)) == NULL)		/* If not known now	*/
	    dp = defendel(token, FALSE);	/* Save the name	*/
	else {					/* It's known:		*/
	    isredefine = TRUE;			/* Remember this fact	*/
	    old = dp->repl;			/* Remember replacement	*/
	    dp->repl = NULL;			/* No replacement now	*/
	}
	parlist[0] = parmp = parm;		/* Setup parm buffer	*/
	if ((c = get()) == '(') {		/* With arguments?	*/
	    nargs = 0;				/* Init formals counter	*/
	    do {				/* Collect formal parms	*/
		if (nargs >= LASTPARM)
		    cfatal("Too many arguments for macro", NULLST);
		else if ((c = skipws()) == ')')
		    break;			/* Got them all		*/
		else if (type[c] != LET)	/* Bad formal syntax	*/
		    goto bad_define;
		scanid(c);			/* Get the formal param	*/
		parlist[nargs++] = parmp;	/* Save its start	*/
		textput(token);			/* Save text in parm[]	*/
	    } while ((c = skipws()) == ',');	/* Get another argument	*/
	    if (c != ')')			/* Must end at )	*/
		goto bad_define;
	    c = ' ';				/* Will skip to body	*/
	}
	else {
	    /*
	     * DEF_NOARGS is needed to distinguish between
	     * "#define foo" and "#define foo()".
	     */
	    nargs = DEF_NOARGS;			/* No () parameters	*/
	}
	if (type[c] == SPA)			/* At whitespace?	*/
	    c = skipws();			/* Not any more.	*/
	workp = work;				/* Replacement put here	*/
	inmacro = TRUE;				/* Keep \<newline> now	*/
	while (c != EOF_CHAR && c != '\n') {	/* Compile macro body	*/
#if OK_CONCAT
#if COMMENT_INVISIBLE
	    if (c == COM_SEP) {			/* Token concatenation? */
		save(TOK_SEP);			/* Stuff a delimiter	*/
		c = get();
#else
	    if (c == '#') {			/* Token concatenation?	*/
	        int q;

	        if (get()=='#') q=0; else { q=1; unget(); }
		while (workp > work && type[(int)workp[-1]] == SPA)
		    --workp;			/* Erase leading spaces	*/
		if (q) save(TOK_QUOTE); else save(TOK_SEP);	/* Stuff a delimiter	*/
		c = skipws();			/* Eat whitespace	*/
#endif
		if (type[c] == LET)		/* Another token here?	*/
		    ;				/* Stuff it normally	*/
		else if (type[c] == DIG) {	/* Digit string after?	*/
		    while (type[c] == DIG) {	/* Stuff the digits	*/
			save(c);
			c = get();
		    } 
                    unget(c);
                    c = TOK_SEP;
		    if (!q) save(TOK_SEP);		/* Delimit 2nd token	*/
		}
		else {
#if ! COMMENT_INVISIBLE
		    ciwarn("Strange character after # or ## (%d.)", c);
#endif
                    continue;
                }
            }
#endif
	    switch (type[c]) {
	    case LET:
		checkparm(c, dp);		/* Might be a formal	*/
		break;

	    case DIG:				/* Number in mac. body	*/
	    case DOT:				/* Maybe a float number	*/
		scannumber(c, save);		/* Scan it off		*/
		break;

	    case QUO:				/* String in mac. body	*/
#if STRING_FORMAL
		stparmscan(c, dp);		/* Do string magic	*/
#else
		stparmscan(c);
#endif
		break;

	    case BSH:				/* Backslash		*/
		save('\\');
		if ((c = get()) == '\n')
		    wrongline = TRUE;
		save(c);
		break;

	    case SPA:				/* Absorb whitespace	*/
		/*
		 * Note: the "end of comment" marker is passed on
		 * to allow comments to separate tokens.
		 */
		if (workp[-1] == ' ')		/* Absorb multiple	*/
		    break;			/* spaces		*/
		else if (c == '\t')
		    c = ' ';			/* Normalize tabs	*/
		/* Fall through to store character			*/
	    default:				/* Other character	*/
		save(c);
		break;
	    }
	    c = get();
	}
	inmacro = FALSE;			/* Stop newline hack	*/
	unget();				/* For control check	*/
	if (workp > work && workp[-1] == ' ')	/* Drop trailing blank	*/
	    workp--;
	*workp = EOS;				/* Terminate work	*/
	dp->repl = savestring(work);		/* Save the string	*/
	dp->nargs = nargs;			/* Save arg count	*/
#if DEBUG
	if (debug)
	    dumpadef("macro definition", dp);
#endif
	if (isredefine) {			/* Error if redefined	*/
	    if ((old != NULL && dp->repl != NULL && !streq(old, dp->repl))
	     || (old == NULL && dp->repl != NULL)
	     || (old != NULL && dp->repl == NULL)) {
#ifdef STRICT_UNDEF
		cerror("Redefining defined variable \"%s\"", dp->name);
#else
		cwarn("Redefining defined variable \"%s\"", dp->name);
#endif
	    }
	    if (old != NULL)			/* We don't need the	*/
		free(old);			/* old definition now.	*/
	}	 
	return;

bad_define:
	cerror("#define syntax error", NULLST);
	inmacro = FALSE;			/* Stop <newline> hack	*/
}

void checkparm(c, dp)
register int	c;
DEFBUF		*dp;
/*
 * Replace this param if it's defined.  Note that the macro name is a
 * possible replacement token.  We stuff DEF_MAGIC in front of the token
 * which is treated as a LETTER by the token scanner and eaten by
 * the output routine.  This prevents the macro expander from
 * looping if someone writes "#define foo foo".
 */
{
	register int		i;
	register char		*cp;

	scanid(c);				/* Get parm to token[]	*/
	for (i = 0; i < nargs; i++) {		/* For each argument	*/
	    if (streq(parlist[i], token)) {	/* If it's known	*/
		save(i + MAC_PARM);		/* Save a magic cookie	*/
		return;				/* And exit the search	*/
	    }
	}
	if (streq(dp->name, token))		/* Macro name in body?	*/
	    save(DEF_MAGIC);			/* Save magic marker	*/
	for (cp = token; *cp != EOS;)		/* And save		*/
	    save(*cp++);			/* The token itself	*/
}

#if STRING_FORMAL
void stparmscan(delim, dp)
int		delim;
register DEFBUF	*dp;
/*
 * Scan the string (starting with the given delimiter).
 * The token is replaced if it is the only text in this string or
 * character constant.  The algorithm follows checkparm() above.
 * Note that scanstring() has approved of the string.
 */
{
	register int		c;

	/*
	 * Warning -- this code hasn't been tested for a while.
	 * It exists only to preserve compatibility with earlier
	 * implementations of cpp.  It is not part of the Draft
	 * ANSI Standard C language.
	 */
	save(delim);
	instring = TRUE;
	while ((c = get()) != delim
	     && c != '\n'
	     && c != EOF_CHAR) {
	    if (type[c] == LET)			/* Maybe formal parm	*/
		checkparm(c, dp);
	    else {
		save(c);
		if (c == '\\')
		    save(get());
	    }
	}
	instring = FALSE;
	if (c != delim)
	    cerror("Unterminated string in macro body", NULLST);
	save(c);
}
#else
void stparmscan(delim)
int		delim;
/*
 * Normal string parameter scan.
 */
{
	register char		*wp;
	register int		i;

	wp = workp;			/* Here's where it starts	*/
	if (!scanstring(delim, save))
	    return;			/* Exit on scanstring error	*/
	workp[-1] = EOS;		/* Erase trailing quote		*/
	wp++;				/* -> first string content byte	*/ 
	for (i = 0; i < nargs; i++) {
	    if (streq(parlist[i], wp)) {
		*wp++ = MAC_PARM + PAR_MAC;	/* Stuff a magic marker	*/
		*wp++ = (i + MAC_PARM);		/* Make a formal marker	*/
		*wp = wp[-3];			/* Add on closing quote	*/
		workp = wp + 1;			/* Reset string end	*/
		return;
	    }
	}
	workp[-1] = wp[-1];		/* Nope, reset end quote.	*/
}
#endif

void doundef()
/*
 * Remove the symbol from the defined list.
 * Called from the #control processor.
 */
{
	register int		c;

	if (type[(c = skipws())] != LET)
	    cerror("Illegal #undef argument", NULLST);
	else {
	    scanid(c);				/* Get name to token[]	*/
	    if (defendel(token, TRUE) == NULL) {
#ifdef STRICT_UNDEF
		cwarn("Symbol \"%s\" not defined in #undef", token);
#endif
	    }
	}
}

void textput(text)
char		*text;
/*
 * Put the string in the parm[] buffer.
 */
{
	register int	size;

	size = strlen(text) + 1;
	if ((parmp + size) >= &parm[NPARMWORK])
	    cfatal("Macro work area overflow", NULLST);
	else {
	    strcpy(parmp, text);
	    parmp += size;
	}
}

void charput(c)
register int	c;
/*
 * Put the byte in the parm[] buffer.
 */
{
	if (parmp >= &parm[NPARMWORK])
	    cfatal("Macro work area overflow", NULLST);
	else {
	    *parmp++ = c;
	}
}

/*
 *		M a c r o   E x p a n s i o n
 */

static DEFBUF	*macro;		/* Catches start of infinite macro	*/

void expand(tokenp)
register DEFBUF	*tokenp;
/*
 * Expand a macro.  Called from the cpp mainline routine (via subroutine
 * macroid()) when a token is found in the symbol table.  It calls
 * expcollect() to parse actual parameters, checking for the correct number.
 * It then creates a "file" containing a single line containing the
 * macro with actual parameters inserted appropriately.  This is
 * "pushed back" onto the input stream.  (When the get() routine runs
 * off the end of the macro line, it will dismiss the macro itself.)
 */
{
	register int		c;
	register FILEINFO	*file;
	extern FILEINFO		*getfile();

#if DEBUG
	if (debug)
	    dumpadef("expand entry", tokenp);
#endif
	/*
	 * If no macro is pending, save the name of this macro
	 * for an eventual error message.
	 */
	if (recursion++ == 0)
	    macro = tokenp;
	else if (recursion == RECURSION_LIMIT) {
	    cerror("Recursive macro definition of \"%s\"", tokenp->name);
	    fprintf(stderr, "(Defined by \"%s\")\n", macro->name);
	    if (rec_recover) {
		do {
		    c = get();
		} while (infile != NULL && infile->fp == NULL);
		unget();
		recursion = 0;
		return;
	    }
	}
	/*
	 * Here's a macro to expand.
	 */
	nargs = 0;				/* Formals counter	*/
	parmp = parm;				/* Setup parm buffer	*/
	switch (tokenp->nargs) {
	case (-2):				/* __LINE__		*/
	    for (file = infile; file != NULL; file = file->parent) {
	    	if (file->fp != NULL) {
	    	    sprintf(work, "%d", file->line);
	    	    ungetstring(work);
	    	    break;
	    	}
	    }
	    break;

	case (-3):				/* __FILE__		*/
	    for (file = infile; file != NULL; file = file->parent) {
		if (file->fp != NULL) {
		    sprintf(work, "\"%s\"", (file->progname != NULL)
			? file->progname : file->filename);
		    ungetstring(work);
		    break;
		}
	    }
	    break;

	default:
	    /*
	     * Nothing funny about this macro.
	     */
	    if (tokenp->nargs < 0)
		cfatal("Bug: Illegal __ macro \"%s\"", tokenp->name);
	    while ((c = skipws()) == '\n')	/* Look for (, skipping	*/
		wrongline = TRUE;		/* spaces and newlines	*/
	    if (c != '(') {
		/*
		 * If the programmer writes
		 *	#define foo() ...
		 *	...
		 *	foo [no ()]
		 * just write foo to the output stream.
		 */
		unget();
#if 0
		cwarn("Macro \"%s\" needs arguments", tokenp->name);
#endif
		fputs(tokenp->name, stdout);
		return;
	    }
	    else if (expcollect()) {		/* Collect arguments	*/
		if (tokenp->nargs != nargs) {	/* Should be an error?	*/
		    cwarn("Wrong number of macro arguments for \"%s\"",
			tokenp->name);
		}
#if DEBUG
		if (debug)
		    dumpparm("expand");
#endif
	    }					/* Collect arguments		*/
	case DEF_NOARGS:		/* No parameters just stuffs	*/
	    expstuff(tokenp);		/* Do actual parameters		*/
	}				/* nargs switch			*/
}

FILE_LOCAL int
expcollect()
/*
 * Collect the actual parameters for this macro.  TRUE if ok.
 */
{
	register int	c;
	register int	paren;			/* For embedded ()'s	*/

	for (;;) {
	    paren = 0;				/* Collect next arg.	*/
	    while ((c = skipws()) == '\n')	/* Skip over whitespace	*/
		wrongline = TRUE;		/* and newlines.	*/
	    if (c == ')') {			/* At end of all args?	*/
		/*
		 * Note that there is a guard byte in parm[]
		 * so we don't have to check for overflow here.
		 */
		*parmp = EOS;			/* Make sure terminated	*/
		break;				/* Exit collection loop	*/
	    }
	    else if (nargs >= LASTPARM)
		cfatal("Too many arguments in macro expansion", NULLST);
	    parlist[nargs++] = parmp;		/* At start of new arg	*/
	    for (;; c = cget()) {		/* Collect arg's bytes	*/
		if (c == EOF_CHAR) {
		    cerror("end of file within macro argument", NULLST);
		    return (FALSE);		/* Sorry.		*/
		}
		else if (c == '\\') {		/* Quote next character	*/
		    charput(c);			/* Save the \ for later	*/
		    charput(cget());		/* Save the next char.	*/
		    continue;			/* And go get another	*/
		}
		else if (type[c] == QUO) {	/* Start of string?	*/
		    scanstring(c, charput);	/* Scan it off		*/
		    continue;			/* Go get next char	*/
		}
		else if (c == '(')		/* Worry about balance	*/
		    paren++;			/* To know about commas	*/
		else if (c == ')') {		/* Other side too	*/
		    if (paren == 0) {		/* At the end?		*/
			unget();		/* Look at it later	*/
			break;			/* Exit arg getter.	*/
		    }
		    paren--;			/* More to come.	*/
		}
		else if (c == ',' && paren == 0) /* Comma delimits args	*/
		    break;
		else if (c == '\n')		/* Newline inside arg?	*/
		    wrongline = TRUE;		/* We'll need a #line	*/
		charput(c);			/* Store this one	*/
	    }					/* Collect an argument	*/
	    charput(EOS);			/* Terminate argument	*/
#if DEBUG
	    if (debug)
	        printf("parm[%d] = \"%s\"\n", nargs, parlist[nargs - 1]);
#endif
	}					/* Collect all args.	*/
	return (TRUE);				/* Normal return	*/
}

FILE_LOCAL
void expstuff(tokenp)
DEFBUF		*tokenp;		/* Current macro being expanded	*/
/*
 * Stuff the macro body, replacing formal parameters by actual parameters.
 */
{
	register int	c;			/* Current character	*/
	register char	*inp;			/* -> repl string	*/
	register char	*defp;			/* -> macro output buff	*/
	int		size;			/* Actual parm. size	*/
	char		*defend;		/* -> output buff end	*/
	int		string_magic;		/* String formal hack	*/
	FILEINFO	*file;			/* Funny #include	*/
	int		endquote;
	extern FILEINFO	*getfile();

	file = getfile(NBUFF, tokenp->name);
	inp = tokenp->repl;			/* -> macro replacement	*/
	defp = file->buffer;			/* -> output buffer	*/
	defend = defp + (NBUFF - 1);		/* Note its end		*/
	endquote = 0;
	if (inp != NULL) {
	    while ((c = (*inp++ & 0xFF)) != EOS) {
		if (c >= MAC_PARM && c <= (MAC_PARM + PAR_MAC)) {
		    string_magic = (c == (MAC_PARM + PAR_MAC));
		    if (string_magic)
		 	c = (*inp++ & 0xFF);
		    /*
		     * Replace formal parameter by actual parameter string.
		     */
		    if ((c -= MAC_PARM) < nargs) {
			size = strlen(parlist[c]);
			if ((defp + size) >= defend)
			    goto nospace;
			/*
			 * Erase the extra set of quotes.
			 */
			if (string_magic && defp[-1] == parlist[c][0]) {
			    strcpy(defp-1, parlist[c]);
			    defp += (size - 2);
			}
			else {
			    strcpy(defp, parlist[c]);
			    defp += size;
			}
		    }
		    if (endquote) { if (defp+1 >= defend) goto nospace; *defp++=DBL_QUOTE; endquote=0; }
		}
		else if (defp >= defend) {
nospace:	    cfatal("Out of space in macro \"%s\" arg expansion",
			tokenp->name);
		}
		else if (c == TOK_QUOTE)
		{
		    *defp++ = DBL_QUOTE;
		    endquote = 1;
                }
		else {
		    *defp++ = c;
		}
	    }
	}
	*defp = EOS;
#if DEBUG
	if (debug > 1)
	    printf("macroline: \"%s\"\n", file->buffer);
#endif
}

#if DEBUG
dumpparm(why)
char		*why;
/*
 * Dump parameter list.
 */
{
	register int	i;

	printf("dump of %d parameters (%d bytes total) %s\n",
	    nargs, parmp - parm, why);
	for (i = 0; i < nargs; i++) {
	    printf("parm[%d] (%d) = \"%s\"\n",
		i + 1, strlen(parlist[i]), parlist[i]);
	}
}
#endif
