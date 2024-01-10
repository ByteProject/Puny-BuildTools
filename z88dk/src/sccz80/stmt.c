/*
 *      Small C+ Compiler
 *      Split into parts djm 3/3/99
 *
 *      This part deals with statements
 *
 *      $Id: stmt.c,v 1.22 2016-04-05 20:23:34 dom Exp $
 */

#include "ccdefs.h"

static void     ns(void);
static void     compound(void);
static void     doiferror(void);
static void     doif(void);
static Type    *doexpr(void);
static void     dowhile(void);
static void     dodo(void);
static void     dofor(void);
static void     doswitch(void);
static void     docase(void);
static void     dodefault(void);
static void     doreturn(char);
static void     dobreak(void);
static void     docont(void);
static void     dostaticassert(void);

/*
 *      Some variables for goto and cleaning up after compound 
 *      statements
 */

extern void dogoto(void);
extern int dolabel(void);
static void docritical(void);
static int stkstor[MAX_LEVELS]; /* ZSp for each compound level */
static int lastline = 0;



static int swactive = 0; /* true inside a switch */
static int swdefault = 0; /* default label number, else 0 */

static int incritical = 0;  /* Are we in a __critical block */


/*
 *      Statement parser
 *
 * called whenever syntax requires a statement.
 * this routine performs that statement
 * and returns a number telling which one
 */
int statement()
{
    int st;
    int locstatic; /* have we had the static keyword */

    blanks();
    if (lineno != lastline) {
        lastline = lineno;
        EmitLine(lineno);
    }
    if (ch() == 0 && eof) {
        return (lastst = STEXP);
    } else {

        if (amatch("extern")) {
            dodeclare(EXTERNAL);
            return lastst;
        }
        /* Ignore the register and auto keywords! */
        swallow("register");
        swallow("auto");

        /* Check to see if specified as static, and also for far and near */
        locstatic = amatch("static");

        if ( declare_local(locstatic) ) {
            return lastst;
        }        
        /* not a definition */
        if (declared >= 0) {
            Zsp = modstk(Zsp - declared, KIND_NONE, NO, YES);
            declared = 0;
        }
        st = -1;
        switch (ch()) {
        case '{':
            inbyte();
            compound();
            st = lastst;
            break;
        case 'i':
            if (amatch("iferror")) {
                doiferror();
                st = STIF;
            } else if (amatch("if")) {
                doif();
                st = STIF;
            }
            break;
        case 'w':
            if (amatch("while")) {
                dowhile();
                st = STWHILE;
            }
            break;
        case 'd':
            if (amatch("do")) {
                dodo();
                st = STDO;
            } else if (amatch("default")) {
                dodefault();
                st = STDEF;
            }
            break;
        case 'f':
            if (amatch("for")) {
                dofor();
                st = STFOR;
            }
            break;
        case 's':
            if (amatch("switch")) {
                doswitch();
                st = STSWITCH;
            }
            break;
        case 'c':
            if (amatch("case")) {
                docase();
                st = STCASE;
            } else if (amatch("continue")) {
                docont();
                ns();
                st = STCONT;
            }
            break;
        case 'r':
            if (amatch("return")) {
                doreturn(0);
                ns();
                st = STRETURN;
            } else if (amatch("return_c")) {
                doreturn(1);
                ns();
                st = STRETURN;
            } else if (amatch("return_nc")) {
                doreturn(2);
                ns();
                st = STRETURN;
            }
            break;
        case 'b':
            if (amatch("break")) {
                dobreak();
                ns();
                st = STBREAK;
            }
            break;
        case ';':
            inbyte();
            st = lastst;
            break;
        case 'a':
            if (amatch("asm")) {
                doasmfunc(YES);
                ns();
                st = STASM;
            }
            break;
        case 'g':
            if (amatch("goto")) {
                dogoto();
                ns();
                st = STGOTO;
            }
            break;
        case '#':
            if (match("#asm")) {
                doasm();
                st = STASM;
            }
            break;
        case '_':
            if (match("_Static_assert")) {
                dostaticassert();
                st = STASSERT;
            } else if (match("__critical")) {
                docritical();
                st = STCRITICAL;
            }
        }
        if (st == -1) {
            /* if nothing else, assume it's an expression */
            if (dolabel() == 0) {
                doexpr();
                ns();
            }
            st = STEXP;
        }
    }
    return (lastst = st);
}

/*
 *      Semicolon enforcer
 *
 * called whenever syntax requires a semicolon
 */
void ns()
{
    if (cmatch(';') == 0)
        errorfmt("Expected ';'",1);
}

/*
 *      Compound statement
 *
 * allow any number of statements to fall between "{}"
 */
void compound()
{
    SYMBOL* savloc;

    if (ncmp == MAX_LEVELS)
        errorfmt("Maximum nesting level reached (%d)", 1, ncmp);

    stkstor[ncmp] = Zsp;
    savloc = locptr;
    declared = 0; /* may declare local variables */
    ++ncmp; /* new level open */
    while (cmatch('}') == 0)
        statement(); /* do one */
    --ncmp; /* close current level */
    if (lastst != STRETURN) {
        modstk(stkstor[ncmp], KIND_NONE, NO, YES); /* delete local variable space */
    }
    Zsp = stkstor[ncmp];
    locptr = savloc; /* delete local symbols */
    declared = 0;
}

/*
 *    "iferror" statement
 *    This is z88dk specific and is used to check for
 *    an error from a package call..highly non standard!
 *
 *    I sense getting into trouble with purists but trying
 *    to combine C and asm compactly and efficiently requires
 *     this sort of extension (much like return_c/_nc
 */
void doiferror()
{
    int flab1, flab2;
    flab1 = getlabel(); /* Get label for false branch */
    jumpnc(flab1);
    statement();
    if (amatch("else") == 0) {
        /* no else, print false label and exit  */
        postlabel(flab1);
        return;
    }
    /* an "if...else" statement. */
    flab2 = getlabel();
    if (lastst != STRETURN) {
        /* if last statement of 'if' was 'return' we needn't skip 'else' code */
        jump(flab2);
    }
    postlabel(flab1); /* print false label */
    statement(); /* and do 'else' clause */
    postlabel(flab2);
}   

/*
 *              "if" statement
 */
void doif()
{
    int flab1, flab2;
    int testtype;
    t_buffer *buf;
    
    flab1 = getlabel(); /* get label for false branch */
    testtype = test(flab1, YES); /* get expression, and branch false */

    buf = startbuffer(100);
    statement();

    if ( testtype == 0 ) {
        discardbuffer(buf);
        buf = NULL;
        lastst = STRETURN;
    }

    if (amatch("else") == 0) {
        /* no else, print false label and exit  */
        if ( testtype < 0 ) {
            postlabel(flab1);
            clearbuffer(buf);
        } else if  (testtype ==  1 ) { /* Evaluate to true */
            clearbuffer(buf);
        }
        return;
    }

    clearbuffer(buf);
    if ( testtype == 1 ) {
        // We evaluated the if to true, so we can discard the else
        t_buffer *buf2 = startbuffer(100);
        statement();
        discardbuffer(buf2);
        return;
    } 
    /* an "if...else" statement. */
    flab2 = getlabel();
    if (lastst != STRETURN) {
        /* if last statement of 'if' was 'return' we needn't skip 'else' code */
        jump(flab2);
    }
    if ( testtype != 0 ) {
        postlabel(flab1); /* print false label */
    }
    statement(); /* and do 'else' clause */
    if ( testtype != 0 ) {
        postlabel(flab2); /* print true label */
    }
}

/*
 * perform expression (including commas)
 */
Type *doexpr()
{
    char *before, *start;
    double val;
    int    vconst;
    Kind    type;
    Type   *type_ptr;
    
    while (1) {
        setstage(&before, &start);
        type = expression(&vconst, &val, &type_ptr);
        clearstage(before, start);
        if (ch() != ',')
            return type_ptr;
        inbyte();
    }
}

/*
 *      "while" statement
 */
void dowhile()
{
    WHILE_TAB wq; /* allocate local queue */
    t_buffer  *buf;
    int       exprconstant;

    addwhile(&wq); /* add entry to queue */
    /* (for "break" statement) */
    buf = startbuffer(100);
    postlabel(wq.loop); /* loop label */
    exprconstant = test(wq.exit, YES); /* see if true */
    if ( exprconstant == 0 ) {
        t_buffer *buf2 = startbuffer(100);
        statement();
        discardbuffer(buf2);
        clearbuffer(buf);
    } else {
        statement(); /* if so, do a statement */
        jump(wq.loop); /* loop to label */
        postlabel(wq.exit); /* exit label */
        clearbuffer(buf);
    }
    delwhile(); /* delete queue entry */
}

/*
 * "do - while" statement
 */
void dodo()
{
    WHILE_TAB wq;
    int top;
    int testresult;

    addwhile(&wq);
    postlabel(top = getlabel());
    statement();
    needtoken("while");
    postlabel(wq.loop);
    testresult = test(wq.exit, YES);
    if ( testresult == 0 ) { // False
        // We don't need to do anything
    } else {
        jump(top);
        postlabel(wq.exit);
    }
    delwhile();
    ns();
}

/*
 * "for" statement (zrin)
 */
void dofor()
{
    WHILE_TAB wq;
    int l_condition;
    int savedsp;
    int testresult = 1; // Default is true

    SYMBOL *savedloc;
    t_buffer *buf2, *buf3,*buf4;

    addwhile(&wq);
    l_condition = getlabel();
    savedsp = Zsp;
    savedloc = locptr;

    needchar('(');
    ++ncmp;
    if (cmatch(';') == 0) {
        if ( declare_local(0) == 0 ) {
            doexpr(); /*         initialization             */
            ns();
        }
        (wqptr-1)->sp = wq.sp = Zsp;
    }

    buf2 = startbuffer(1); /* save condition to buf2 */
    if (cmatch(';') == 0) {
        testresult = test(wq.exit, NO); /* expr 2 */
        ns();
    }
    suspendbuffer();

    buf3 = startbuffer(1); /* save modification to buf3 */
    if (cmatch(')') == 0) {
        doexpr(); /* expr 3 */
        needchar(')');
    }
    suspendbuffer();

    if ( testresult != 0 ) {  /* So it's either true or non-constant */
        jump(l_condition); /*         goto condition             */
        postlabel(wq.loop); /* .loop                              */
        clearbuffer(buf3); /*         modification               */
        postlabel(l_condition); /* .condition                         */
        clearbuffer(buf2); /*         if (!condition) goto exit  */
        statement(); /*         statement                  */
        jump(wq.loop); /*         goto loop                  */
        postlabel(wq.exit); /* .exit                              */
    } else {
        clearbuffer(buf2); // Condition 
        buf4 = startbuffer(100);
        statement(); // Evaluate it
        discardbuffer(buf4);
    }
    --ncmp;
    modstk(savedsp, KIND_NONE, NO, YES);
    Zsp = savedsp;
    locptr = savedloc;
    declared = 0;
    delwhile();
}

/*
 * "switch" statement
 */
void doswitch()
{
    WHILE_TAB wq;
    int endlab, swact, swdef;
    SW_TAB *swnex, *swptr;
    Type   *switch_type;
    t_buffer* buf;

    swact = swactive;
    swdef = swdefault;
    swnex = swptr = swnext;
    addwhile(&wq);
    (wqptr - 1)->loop = 0;
    needchar('(');
    switch_type = doexpr(); /* evaluate switch expression */
    needchar(')');
    swdefault = 0;
    swactive = 1;
    endlab = getlabel();
    /* jump(endlab) ; */

    buf = startbuffer(100);
    statement(); /* cases, etc. */
    /* jump(wq.exit) ; */
    suspendbuffer();

    postlabel(endlab);
    if (switch_type->kind == KIND_CHAR) {
        LoadAccum();
        while (swptr < swnext) {
            CpCharVal(swptr->value);
            opjump("z,", swptr->label);
            ++swptr;
        }
    } else {
        sw(switch_type->kind); /* insert code to match cases */
        while (swptr < swnext) {
            defword();
            printlabel(swptr->label); /* case label */
            if (switch_type->kind == KIND_LONG) {
                outbyte('\n');
                deflong();
            } else
                outbyte(',');
            outdec(swptr->value); /* case value */
            nl();
            ++swptr;
        }
        defword();
        outdec(0);
        nl();
    }
    if (swdefault)
        jump(swdefault);
    else
        jump(wq.exit);

    clearbuffer(buf);

    postlabel(wq.exit);
    delwhile();
    swnext = swnex;
    swdefault = swdef;
    swactive = swact;
}

/*
 * "case" statement
 */
void docase()
{
    double value;
    Kind   valtype;
    if (swactive == 0)
        errorfmt("Not in switch", 0 );
    if (swnext > swend) {
        errorfmt("Too many cases", 0 );
        return;
    }
    postlabel(swnext->label = getlabel());
    constexpr(&value,&valtype, 1);
    if ( valtype == KIND_DOUBLE ) 
        warningfmt("invalid-value","Unexpected floating point encountered, taking int value");
    swnext->value = value;
    needchar(':');
    ++swnext;
}

void dodefault()
{
    if (swactive) {
        if (swdefault)
            errorfmt("Multiple defaults", 0);
    } else
        errorfmt("Not in switch", 0 );
    needchar(':');
    postlabel(swdefault = getlabel());
}

/*
 *      "return" statement
 */
void doreturn(char type)
{
    /* if not end of statement, get an expression */
    if (endst() == 0) {
        Type *expr = doexpr();
        force(currfn->ctype->return_type->kind, expr->kind, currfn->ctype->return_type->isunsigned, expr->isunsigned, 0);
        leave(currfn->ctype->return_type->kind, type, incritical);
    } else {
        leave(KIND_INT, type, incritical);
    }
}



/*
 *      "break" statement
 */
void dobreak()
{
    WHILE_TAB* ptr;

    /* see if any "whiles" are open */
    if ((ptr = readwhile(wqptr)) == 0)
        return; /* no */
    modstk(ptr->sp, KIND_NONE, NO, YES); /* else clean up stk ptr */
    jump(ptr->exit); /* jump to exit label */
}

/*
 *      "continue" statement
 */
void docont()
{
    WHILE_TAB* ptr;

    /* see if any "whiles" are open */
    ptr = wqptr;
    while (1) {
        if ((ptr = readwhile(ptr)) == 0)
            return;
        /* try again if loop is zero (that's a switch statement) */
        if (ptr->loop)
            break;
    }
    modstk(ptr->sp, KIND_NONE, NO, YES); /* else clean up stk ptr */
    jump(ptr->loop); /* jump to loop label */
}

static void docritical(void)
{
    if ( incritical ) {
        errorfmt("Cannot nest __critical sections", 1);
    }
    incritical = 1;
    zentercritical();
    Zsp -= zcriticaloffset();
    statement();
    zleavecritical();
    incritical = 0;
    Zsp += zcriticaloffset();
}

/*
 *      asm()   statement
 *
 *      This doesn't do any label expansions - just chucks it out to
 *      the file, it might be useful for setting a value to machine
 *      code thing
 *      
 *      If wantbr==YES then we need the opening bracket (called by
 *      itself)
 *
 *      Actually, this caution may be unneccesary because it is also
 *      dealt with as a function, we'll just have to see - i.e. maybe
 *      it doesn't have to be statement as well!
 *
 *      New: 3/3/99 djm
 */

void doasmfunc(char wantbr)
{
    char c;
    int  lastwasLF = 0;
    if (wantbr)
        needchar('(');

    outbyte('\t');
    needchar('"');
    do {
        while (!acmatch('"')) {
            c = litchar();
            if (c == 0)
                break;
            if ( lastwasLF && c != '\t' ) {
                outstr("\t");
            }
            if (c == '\n' || c == '\r') {
                lastwasLF = 1;
                outbyte('\n');
            } else {
                lastwasLF = 0;
                outbyte(c);
            }
        }
    } while (cmatch('"'));
    needchar(')');
    if ( !lastwasLF ) {
        outbyte('\n');
    }
}

/*
 *      "asm" pseudo-statement (for #asm/#endasm)
 *      enters mode where assembly language statement are
 *      passed intact through parser
 */

void doasm()
{
    cmode = 0; /* mark mode as "asm" */

#ifdef INBUILT_OPTIMIZER
    generate(); /* Dump queued stuff to be opt'd */
#endif
    while (1) {
        preprocess(); /* get and print lines */
        if (match("#endasm") || eof) {
            break;
        }
        outfmt("%s\n",line);
    }
    clear(); /* invalidate line */
    if (eof)
        errorfmt("Unterminated assembler code",1);
    cmode = 1; /* then back to parse level */
}

static void set_section(char **dest_section) 
{
    char sname[NAMESIZE];

    if (symname(sname) == 0) {
        illname(sname);
        clear();
        return;
    }

    *dest_section = STRDUP(sname);
}

/* #pragma statement */
void dopragma()
{
    blanks();
    if (amatch("proto"))
        addmac();
    else if (amatch("set"))
        addmac();
    else if (amatch("unproto"))
        delmac();
    else if (amatch("unset"))
        delmac();
    else if (amatch("codeseg"))
        set_section(&c_code_section);
    else if (amatch("constseg"))
        set_section(&c_rodata_section);
    else if (amatch("dataseg"))
        set_section(&c_data_section);
    else if (amatch("bssseg"))
        set_section(&c_bss_section);
    else if (amatch("initseg"))
        set_section(&c_init_section);
    else {
        warningfmt("unknown-pragmas","Unknown #pragma directive");
        clear();
    }
}

static void dostaticassert() 
{
    Kind   valtype;
    double val;
    double global_start;
    char   *before, *start;

    needchar('(');
    setstage(&before, &start);
    if (constexpr(&val,&valtype, 1) == 0) {
        val = 0;
    }
    needchar(',');
    qstr(&global_start);
    needchar(')');
    if ( val == 0 ) {
        errorfmt("_Static_assert failed: '%s'",1,&glbq[(int)global_start]);
    }
    // Restore literal queue
    gltptr = global_start;
    clearstage(before, NULL);

}
