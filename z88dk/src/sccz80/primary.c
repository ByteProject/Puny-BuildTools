/*
 *      Small C+ Compiler
 *      Split into parts djm 3/3/99
 *
 *      This part contains various routines to deal with constants
 *      and also finds variable names in the hash tables
 *
 *      $Id: primary.c,v 1.27 2016-11-25 19:46:20 dom Exp $
 */

#include "ccdefs.h"

static double   CalcStand(Kind left_kind, double left, void (*oper)(LVALUE *), double right);
static void     nstep(LVALUE *lval, int n, void (*unstep)(LVALUE *lval));
static void     store(LVALUE *lval);

int primary(LVALUE* lval)
{
    char sname[NAMESIZE];
    SYMBOL* ptr;
    int k;
    if (cmatch('(')) {
        do {
            k = heir1(lval);
        } while (cmatch(','));
        needchar(')');
        //if ( k == 1 && lval->cast_type) docast(lval, lval);
        return k;
    }

    memset(lval, 0, sizeof(LVALUE));

    if (symname(sname)) {
        if (strcmp(sname, "sizeof") == 0) {
            size_of(lval);
            return (0);
        } else if ( strcmp(sname, "__builtin_offsetof") == 0 ) {
            offset_of(lval);
            return(0);
        } else if ( strcmp(sname, "__func__") == 0 ) {
            int32_t litlab;
            // Stuff currfn->name into input stream, call const
            size_t len = strlen(currfn->name);
            storeq(len + 1, (unsigned char *)currfn->name, &litlab);
            lval->const_val = litlab;
            lval->is_const = 0; /* string address not constant */
            lval->ltype = make_pointer(type_char);
            lval->ptr_type = KIND_CHAR; /* djm 9/3/99 */
            lval->val_type = KIND_INT;
            lval->flags = FLAGS_NONE;
            immedlit(litlab,lval->const_val);
            nl();
            return 0;
        } else if ((ptr = findloc(sname))) {
            lval->base_offset = getloc(ptr, 0);
            lval->offset = 0;
            lval->symbol = ptr;
            lval->ltype = ptr->ctype;
            lval->val_type = lval->indirect_kind = ptr->type;
            lval->flags = ptr->flags;
            lval->ptr_type = KIND_NONE;
            if ( ispointer(lval->ltype) ) {
                lval->ptr_type = ptr->ctype->ptr->kind;
                /* djm long pointers */
                lval->indirect_kind = lval->val_type = lval->ltype->kind;
            }
            
            if ( lval->ltype->kind == KIND_ARRAY || lval->ltype->kind == KIND_STRUCT ) {
                /* djm pointer? */
                lval->ptr_type = lval->ltype->kind == KIND_ARRAY ? lval->ltype->ptr->kind : ptr->type;
                lval->val_type = KIND_PTR;
                return (0);
            } else
                return (1);
        }
        /* djm search for local statics */
        ptr = findstc(sname);
        if (!ptr)
            ptr = findglb(sname);
        if (ptr && ptr->ctype ) {
            if (ptr->ctype->kind != KIND_FUNC && !(ptr->ctype->kind == KIND_PTR && ptr->ctype->ptr->kind == KIND_FUNC) ) {
                if (ptr->ident == ID_ENUM)
                    errorfmt("Unknown symbol: %s", 1, sname);
                if (ptr->ctype->kind == KIND_ENUM) {
                    lval->symbol = NULL;
                    lval->ltype = type_int;
                    lval->val_type = KIND_INT;
                    lval->indirect_kind = KIND_NONE;
                    lval->is_const = 1;
                    lval->const_val = ptr->size;
                    lval->flags = FLAGS_NONE;
                    return (0);
                }
                lval->symbol = ptr;
                lval->ltype = ptr->ctype;
                lval->indirect_kind = KIND_NONE;
                lval->val_type = ptr->ctype->kind;
                lval->flags = ptr->flags;
                lval->ptr_type = KIND_NONE;
                if (lval->ltype->kind != KIND_ARRAY && lval->ltype->kind != KIND_STRUCT ) {
                    if (lval->ltype->kind == KIND_PTR) {
                        lval->ptr_type = ptr->ctype->ptr->kind;
                        lval->val_type = (ptr->flags & FARPTR ? KIND_CPTR : KIND_INT);
                    }
                    return (1);
                }
                /* Handle arrays... */
                address(ptr);
                /* djm sommat here about pointer types? */
                lval->indirect_kind = lval->ptr_type = ptr->type;
                if ( ispointer(lval->ltype) || lval->ltype->kind == KIND_ARRAY )
                    lval->ptr_type = lval->ltype->ptr->kind;
                lval->val_type = (ptr->flags & FARPTR ? KIND_CPTR : KIND_INT);
                return (0);
            } else {
                lval->symbol = ptr;
                lval->ltype = ptr->ctype;
                lval->val_type = KIND_INT;
                lval->ptr_type = KIND_NONE;
                lval->indirect_kind = KIND_NONE;
                return 1;
            }
        } else {
            /* Check to see if we have a right bracket, if we don't assume
             * it's a function then we can break an awful lot of code, do it
             * this way and it's safer... we're not GNU after all!
             */
            if (!rcmatch('(')) {
                errorfmt("Unknown symbol: %s", 1, sname);
                lval->symbol = addglb(sname, type_int, ID_VARIABLE, KIND_INT, 0, EXTERNAL);
                lval->ltype = type_int;
                lval->val_type = KIND_INT;
                lval->ptr_type = KIND_NONE;
                lval->indirect_kind = KIND_NONE;
	        return(1);
            } else {
                /* assume it's a function we haven't seen yet */
                /* NB value set to 0 */
                warningfmt("implicit-function-definition", "Implicit definition of function '%s' it will return an int. Prototype it explicitly if this is not what you want.", sname);
                ptr = addglb(sname, default_function(sname), 0, KIND_INT, 0, STATIK);
                ptr->size = 0;
                ptr->flags |= c_use_r2l_calling_convention == YES ? 0 : SMALLC;
            }
        }
        lval->symbol = ptr;
        lval->ltype = ptr->ctype;
        lval->indirect_kind = KIND_NONE;
        lval->val_type = ptr->type ; /* Null function, always int */
        lval->flags = ptr->flags;
        return (0);
    }
    if (constant(lval)) {
        // lval->ltype is set by constant()
        lval->symbol = NULL;
        lval->indirect_kind = KIND_NONE;
        return (0);
    } else {
        errorfmt("Invalid expression", 0);
        vconst(0);
        junk();
        return (0);
    }
}


/*
 * calculate constant expression (signed values)
 */
double calc(
    Kind   left_kind,
    double left,
    void (*oper)(LVALUE *),
    double right, int is16bit)
{
    if (oper == zdiv && right != 0.0)
        return (left / right);
    else if (oper == zmod)
        return ((int)left % (int)right);
    else if (oper == zle)
        return (left <= right);
    else if (oper == zge)
        return (left >= right);
    else if (oper == zlt)
        return (left < right);
    else if (oper == zgt)
        return (left > right);
    else if (oper == asr) {
        if ( ((left_kind == KIND_INT || left_kind == KIND_CHAR) && right >= 16) ||
             (left_kind == KIND_LONG && right >= 32) ) {
            warningfmt("limited-range", "Right shifting by more than size of object, changed to zero");
            right = 0;
        }
        if ( is16bit ) return ((int16_t)left >> (int16_t)right);
        else return ((int32_t)left >> (int)right);
    } else
        return (CalcStand(left_kind, left, oper, right));
}

double calcun(
    Kind   left_kind,
    double left,
    void (*oper)(LVALUE *),
    double right)
{
    if (oper == zdiv)   {
        return (left / right);
    } else if (oper == zmod)
        return ((unsigned int)left % (unsigned int)right);
    else if (oper == zle)
        return (left <= right);
    else if (oper == zge)
        return (left >= right);
    else if (oper == zlt)
        return (left < right);
    else if (oper == zgt)
        return (left > right);
    else if (oper == asr) {
         if ( ((left_kind == KIND_INT || left_kind == KIND_CHAR) && right >= 16) ||
             (left_kind == KIND_LONG && right >= 32) ) {
            warningfmt("limited-range", "Right shifting by more than size of object, changed to zero");
            right = 0;
        }
        return ((uint32_t)left >> (int)right);
    } else
        return (CalcStand(left_kind, left, oper, right));
}

/*
 * Calculations..standard ones - same for U & S 
 */

double CalcStand(
    Kind left_kind,
    double left,
    void (*oper)(LVALUE *),
    double right)
{
    if (oper == zor)
        return ((unsigned int)left | (unsigned int)right);
    else if (oper == zxor)
        return ((unsigned int)left ^ (unsigned int)right);
    else if (oper == zand)
        return ((unsigned int)left & (unsigned int)right);
    else if (oper == mult)
        return (left * right);
    else if (oper == asl) {
        if ( ((left_kind == KIND_INT || left_kind == KIND_CHAR) && right >= 16) ||
             (left_kind == KIND_LONG && right >= 32) ) {
            warningfmt("limited-range", "Left shifting by more than size of object, changed to zero");
            right = 0;
        }
        return ((unsigned int)left << (unsigned int)right);
    } else if (oper == zeq)
        return (left == right);
    else if (oper == zne)
        return (left != right);
    else
        return (0);
}

/* Complains if an operand isn't int */
int intcheck(LVALUE* lval, LVALUE* lval2)
{
    if (lval->val_type == KIND_DOUBLE || lval2->val_type == KIND_DOUBLE) {
        errorfmt("Operands must be int", 0);
        return -1;
    }
    return 0;
}

/* Forces result, having type t2, to have type t1 */
void force(Kind t1, Kind t2, char isunsigned1, char isunsigned2, int isconst)
{
    if (t2 == KIND_CARRY) {
        zcarryconv();
    }

    if (t1 == KIND_DOUBLE) {
        if (t2 != KIND_DOUBLE) {
            zconvert_to_double(t2, isunsigned2);
        }
    } else {
        if (t2 == KIND_DOUBLE) {
            zconvert_from_double(t1, isunsigned1);
            return;
        }
    }
    /* t2 =source, t1=dest */
    /* int to long, if signed, do sign, if not ld de,0 */
    /* Check to see if constant or not... */
    if (t1 == KIND_LONG) {
        if (t2 != KIND_LONG ) {
            if (isunsigned2 == NO && isunsigned1 == NO && t2 != KIND_CARRY) {
                convSint2long();
            } else
                convUint2long();
        }
        return;
    }

    /* Converting between pointer types..far and near */
    if (t1 == KIND_CPTR && t2 == KIND_INT)
        convUint2long();
    else if (t2 == KIND_CPTR && (t1 == KIND_INT || t1 == KIND_PTR))
        warningfmt("incompatible-pointer-types","Narrowing pointer from far to near");
        
    /* Char conversion */
    if (t1 == KIND_CHAR && isunsigned2 == NO && !isconst) {
        if (isunsigned1 == NO)
            convSint2char();
        else
            convUint2char();
    } else if (t1 == KIND_CHAR && isunsigned2 == YES && !isconst) {
        if (isunsigned1 == NO)
            convSint2char();
        else
            convUint2char();
    }
}

/*
 * If only one operand is KIND_DOUBLE, converts the other one to
 * KIND_DOUBLE.  Returns 1 if result will be KIND_DOUBLE
 *
 * Maybe should an operand in here for KIND_LONG?
 */
int widen(LVALUE* lval, LVALUE* lval2)
{
    if (lval2->val_type == KIND_DOUBLE) {
        if (lval->val_type != KIND_DOUBLE) {
            dpush_under(lval->ltype->kind); /* push 2nd operand UNDER 1st */
            mainpop();
            if (lval->val_type == KIND_LONG)
                zpop();
            zconvert_to_double(lval->val_type, lval->ltype->isunsigned);
            DoubSwap();
            lval->val_type = KIND_DOUBLE; /* type of result */
            lval->ltype = type_double;
        }
        return (1);
    } else {
        if (lval->val_type == KIND_DOUBLE) {
            zconvert_to_double(lval2->val_type, lval2->ltype->isunsigned);
            lval2->val_type = KIND_DOUBLE;
            lval2->ltype = type_double;
            return (1);
        } else
            return (0);
    }
}

void widenlong(LVALUE* lval, LVALUE* lval2)
{
    if (lval2->val_type == KIND_CARRY) {
        zcarryconv();
        lval2->ltype = type_int;
        lval2->val_type = KIND_INT;
    }

    if (lval2->val_type == KIND_LONG) {
        /* Second operator is long */
        if (lval->val_type != KIND_LONG) {
            doexx(); /* Preserve other operator */
            mainpop();
            force(KIND_LONG, lval->val_type, lval->ltype->isunsigned, lval->ltype->isunsigned, 0);
            lpush(); /* Put the new expansion on stk*/
            doexx(); /* Get it back again */
            if ( lval->ltype->isunsigned ) {
                lval->ltype = type_ulong;
            } else {
                lval->ltype = type_long;
            }
            lval->val_type = KIND_LONG;
        }
        return;
    }

    if (lval->val_type == KIND_LONG) {
        if (lval2->val_type != KIND_LONG && lval2->val_type != KIND_CPTR) {
            if ( lval->ltype->isunsigned ) {
                if ( !lval2->ltype->isunsigned ) {
                    // RHS is signed, 
                    convSint2long();
                } else {
                    convUint2long();
                }
                lval->ltype = type_ulong;
            } else {
                if ( lval2->ltype->isunsigned ) {
                    convUint2long();
                } else {
                    convSint2long();
                }
                lval->ltype = type_long;
            }
            lval->val_type = KIND_LONG;
        }
        return;
    }

    // Promote a char upto an int as necessary
    if ( lval->val_type == KIND_CHAR && lval2->val_type == KIND_INT ) {
        if ( lval->ltype->isunsigned != lval2->ltype->isunsigned ) {
            lval->ltype = type_uint;
        } else {
            lval->ltype = type_int;
        }
        lval->val_type = KIND_INT;
    }

    // Sign mismatch
    if ( lval->ltype->isunsigned != lval2->ltype->isunsigned ) {
        // Longs considered above
        if ( lval->ltype->kind == KIND_CHAR ) {
            lval->ltype = type_uchar;
        } else if ( lval->ltype->kind == KIND_INT ) {
            lval->ltype = type_uint;
        }
    }
}

/*
 * true if val1 -> int pointer or int array and
 * val2 not ptr or array
 */
int dbltest(LVALUE* lval, LVALUE* lval2)
{
    if (lval->ptr_type) {
        if (lval->ptr_type == KIND_CHAR)
            return (0);
        if (lval2->ptr_type)
            return (0);
        return (1);
    } else
        return (0);
}

/*
 * determine type of binary operation
 */
void result(LVALUE* lval, LVALUE* lval2)
{
    if (lval->ptr_type && lval2->ptr_type) {
        lval->ptr_type = KIND_NONE; /* ptr-ptr => int */
        if (lval->val_type == KIND_CPTR) {
            lval->val_type = KIND_LONG;
            lval->ltype = type_long;
        } else {
            lval->val_type = KIND_INT;
            lval->ltype = type_int;            
        }
        lval->indirect_kind = KIND_NONE;
    } else if (lval2->ptr_type) { /* ptr +- int => ptr */
        lval->symbol = lval2->symbol;
        lval->ltype = lval2->ltype;
        lval->indirect_kind = lval2->indirect_kind;
        lval->ptr_type = lval2->ptr_type;
    }
}

/*
 * prestep - preincrement or predecrement lvalue
 */

void prestep(
    LVALUE* lval,
    int n,
    void (*step)(LVALUE *lval))
{
    if (heira(lval) == 0) {
        needlval();
    } else {
        if (lval->indirect_kind) {
            addstk(lval);
            if (lval->flags & FARACC)
                lpush();
            else
                zpush();
        }
        rvalue(lval);
        //intcheck(lval, lval);
        switch (lval->ptr_type) {
        case KIND_DOUBLE:
            zadd_const(lval, n * c_fp_size);
            break;
        case KIND_STRUCT:
            zadd_const(lval, n * lval->ltype->ptr->tag->size);
            break;
        case KIND_LONG:
            (*step)(lval);
        case KIND_CPTR:
            (*step)(lval);
        case KIND_INT:
        case KIND_PTR:
            (*step)(lval);
        default:
            (*step)(lval);
            break;
        }
        store(lval);
    }
}

/*
 * poststep - postincrement or postdecrement lvalue
 */
void poststep(
    int k,
    LVALUE* lval,
    int n,
    void (*step)(LVALUE *lval),
    void (*unstep)(LVALUE *lval))
{
    if (k == 0) {
        needlval();
    } else {
        if (lval->indirect_kind) {
            addstk(lval);
            if (lval->flags & FARACC)
                lpush();
            else
                zpush();
        }
        rvalue(lval);
        switch (lval->ptr_type) {
        case KIND_DOUBLE:
            nstep(lval, n * c_fp_size, unstep);
            break;
        case KIND_STRUCT:
            nstep(lval, n * lval->ltype->ptr->tag->size, unstep);
            break;
        case KIND_LONG:
            nstep(lval, n * 4, unstep);
            break;
        case KIND_CPTR:
            nstep(lval, n * 3, unstep);
            break;
        case KIND_INT:
        case KIND_PTR:
            (*step)(lval);
        default:
            (*step)(lval);
            store(lval);
            if (unstep)
                (*unstep)(lval);
            if (lval->ptr_type == KIND_INT||lval->ptr_type ==KIND_PTR)
                if (unstep)
                    (*unstep)(lval);
            break;
        }
    }
}

/*
 * generate code to postincrement by n
 * no need to change for long pointers since we're going to have
 * memory pools..
 */
void nstep(
    LVALUE* lval,
    int n,
    void (*unstep)(LVALUE *lval))
{
    zadd_const(lval, n);
    store(lval);
    if (unstep)
        zadd_const(lval, -n);
}

void store(LVALUE* lval)
{
    if ( lval->symbol && lval->symbol->isconst ) {
        if ( lval->symbol->isassigned )
            errorfmt("Attempt to modify const lvalue \'%s\'",0,lval->symbol->name);
    }
    if ( lval->symbol ) 
        lval->symbol->isassigned = YES;
    if (lval->symbol && (lval->symbol->type == KIND_PORT8 || lval->symbol->type == KIND_PORT16) ) {
        intrinsic_out(lval->symbol);
    } else if (lval->indirect_kind == KIND_NONE)
        putmem(lval->symbol);
    else
        putstk(lval);
}

/*
 * push address only if it's not that of a two byte quantity at TOS
 * or second TOS.  In either of those cases, forget address calculation
 * This should be followed by a smartstore()
 */
void smartpush(LVALUE* lval, char* before)
{
   // outfmt(";%s Indirect kind %d kind %d flags %d\n",lval->ltype->name,lval->ltype->kind, lval->indirect_kind,lval->flags);
    if ( lval->ltype->size != 2 || lval->symbol == NULL || lval->symbol->storage != STKLOC   )  {
        addstk(lval);
        if ((lval->flags & FARACC) ) {
            lpush();
        } else {
            zpush();
        }
    } else {
        switch ((lval->symbol->offset.i) - Zsp) {
        case 0:
        case 2:
            if (before)
                clearstage(before, 0);
            break;
        default:
            addstk(lval);
            if ((lval->flags & FARACC) ) {
                lpush();
            } else {
                zpush();
            }
        }
    }
}

/*
 * store thing in primary register at address taking account
 * of previous preparation to store at TOS or second TOS
 */
void smartstore(LVALUE* lval)
{
    if (lval->ltype->size != 2 || lval->symbol == NULL || lval->symbol->storage != STKLOC ) {
        store(lval);
    } else {
        switch ((lval->symbol->offset.i) - Zsp) {
        case 0:
            if ( lval->symbol->isconst && lval->symbol->isassigned ) {
                errorfmt("Attempt to modify const lvalue \'%s\'",0,lval->symbol->name);
            } else {
                lval->symbol->isassigned = YES;
            }
            puttos();
            break;
        case 2:
            if ( lval->symbol->isconst && lval->symbol->isassigned ) {
                errorfmt("Attempt to modify const lvalue \'%s\'",0,lval->symbol->name);
            } else {
                lval->symbol->isassigned = YES;
            }
            put2tos();
            break;
        default:
            store(lval);
        }
    }
}

void rvaluest(LVALUE* lval)
{
    if ( lval->symbol && lval->symbol->isassigned == NO && buffer_fps_num == 0 ) {
        warningfmt("maybe-uninitialized", "unknown","Variable '%s' may be used before initialisation", lval->symbol->name);
    }

    if (lval->symbol && (lval->symbol->type == KIND_PORT8  || lval->symbol->type == KIND_PORT16) ) {
        intrinsic_in(lval->symbol);
    } else if (lval->symbol && lval->indirect_kind == KIND_NONE) {
       
        getmem(lval->symbol);
    } else {
        indirect(lval);
    }
    if (lval->cast_type ) docast(lval, lval);
}

void rvalue(LVALUE* lval)
{
    if ( lval->symbol && lval->symbol->isassigned == NO && buffer_fps_num == 0 ) {
        warningfmt("maybe-uninitialized","Variable '%s' may be used before initialisation", lval->symbol->name);
    }
    if (lval->symbol && (lval->symbol->type == KIND_PORT8  || lval->symbol->type == KIND_PORT16) ) {
        intrinsic_in(lval->symbol);
    } else if (lval->symbol && lval->indirect_kind == KIND_NONE) {
        getmem(lval->symbol);
    } else {           
        indirect(lval);
    }
    if (lval->cast_type ) docast(lval, lval);
#if DEBUG_SIGN
    if (lval->ltype->isunsigned ) 
        ol("; unsigned");
    else
        ol("; signed");
#endif
}

/* Check the comparison range, try to determine always true/false conditions */
int check_range(LVALUE *lval, int32_t min_value, int32_t max_value) 
{
    int always = -1;
    void (*oper)(LVALUE *lva) = lval->binop;

    if ( ( oper == zlt && lval->const_val > max_value) ||
        (oper == zle && lval->const_val > max_value ) ||
        ( oper == zgt && lval->const_val < min_value) ||
        ( oper == zgt && lval->const_val < min_value) ||
        ( oper == zge && lval->const_val <= min_value) ||
        ( oper == zne && (lval->const_val < min_value || lval->const_val > max_value)) ) {
        always = 1;
    } else if ( (oper == zlt && lval->const_val < min_value) ||
                (oper == zle && lval->const_val < min_value ) ||
                (oper == zgt && lval->const_val > max_value) ||
                (oper == zge && lval->const_val >= max_value) ||
                ( oper == zeq && (lval->const_val < min_value || lval->const_val > max_value)) ) {
        always = 0;
    }
    return always;
}

#define CHECK(v, min, max) do { \
        if ( v < min || v > max ) warningfmt("limited-range","Value is out of range for assignment"); \
    } while (0)

void check_assign_range(Type *type, double const_value)
{
    Kind lhs_val_type = type->kind;
    int  factor = type->bit_size ? ((1 << type->bit_size) - 1) : 0xffff;

    if ( lhs_val_type == KIND_INT && !isutype(type) ) {
        CHECK(const_value, -(32767 & factor), (65535 & factor));
    } else if ( lhs_val_type == KIND_INT && isutype(type) ) {
        CHECK(const_value, 0, (65535 & factor));
    } else if ( lhs_val_type == KIND_CHAR && !isutype(type) ) {
        CHECK(const_value, -(127 & factor), (255 & factor));
    } else if ( lhs_val_type == KIND_CHAR && isutype(type) ) {
        CHECK(const_value, 0, (255 & factor));
    }
}
#undef CHECK

/** 
 * \retval 1 - If constant true
 * \retval 0 - If constant false
 * \retval -1 - Not constant
 */
int test(int label, int parens)
{
    char *before, *start;
    LVALUE lval={0};
    
    if (parens)
        needchar('(');
    while (1) {
        setstage(&before, &start);
        if (heir1(&lval)) {
            rvalue(&lval);
        }
        if (cmatch(','))
            clearstage(before, start);
        else
            break;
    }
    if (parens)
        needchar(')');
    if (lval.is_const) { /* constant expression */
        clearstage(before, 0);
        lval.binop = NULL;
        if (lval.const_val) {
            /* true constant, perform body */
            return lval.const_val;
        }
        /* false constant, jump round body */
      //  jump(label);
        return 0;
    }
    
    if (lval.binop == dummy || check_lastop_was_testjump(&lval)) {
        if (lval.binop == dummy) {
            lval.val_type = KIND_INT; /* logical always int */
            lval.ltype = type_int;
        }
        testjump(&lval, label);
    } else {
        jumpnc(label);
    }
    clearstage(before, start);
    return -1;
}

/*
 * evaluate constant expression
 * return TRUE if it is a constant expression
 */
int constexpr(double *val, Kind *type, int flag)
{
    char *before, *start;
    double valtemp;
    int con;
    int savesp = Zsp;
    int valtype;
    Type   *type_ptr;
    
    setstage(&before, &start);
    valtype = expression(&con, &valtemp, &type_ptr);
    *val = valtemp;
    clearstage(before, 0); /* scratch generated code */
    if ( valtype == KIND_DOUBLE && con ) {
        decrement_double_ref_direct(valtemp);
    }
    *type = valtype;
    Zsp = savesp;
    if (flag && con == 0)
        errorfmt("Expecting constant expression", 0 );
    return con;
}

/*
 * scale constant value according to type
 */
void cscale(Type *type, int* val)
{
    if ( type->size == -1 || ispointer(type)) { 
        // It's an array of unknown length
        *val *= type->ptr->size / type->ptr->len;
        return;
    }
    *val *= type->size / type->len;
}


/**
 * \param lval - The lval that holds the cast informatino
 * \param dest_lval - The lvalue that will be changed
 */
int docast(LVALUE* lval, LVALUE *dest_lval)
{
    Kind   t1 = lval->cast_type->kind, t2 = dest_lval->ltype->kind;
    
    if ( t1 == KIND_ARRAY || t1 == KIND_PTR ) {
        t1 = KIND_INT;
    } else if ( t1 == KIND_CPTR ) {
        t1 = KIND_LONG;
    }
    if ( t2 == KIND_ARRAY || t2 == KIND_PTR ) {
        t2 = KIND_INT;
    } else if ( t2 == KIND_CPTR ) {
        t2 = KIND_LONG;
    }


    force(t1, t2, lval->cast_type->isunsigned, dest_lval->ltype->isunsigned, 0); // TODO lconst

    dest_lval->ltype = lval->cast_type;
    dest_lval->val_type = dest_lval->ltype->kind;
    lval->cast_type = NULL;
    dest_lval->ptr_type = KIND_NONE;
    if ( ispointer(dest_lval->ltype) ) {
        dest_lval->ptr_type = dest_lval->ltype->ptr->kind;
        /* djm long pointers */
        dest_lval->indirect_kind = dest_lval->val_type = dest_lval->ltype->kind;
    }
    return (1);
}

/*
 * Check whether a type is unsigned..
 */

int ulvalue(LVALUE* lval)
{
    return isutype(lval->ltype);
}


/*
 * Check to see whether an operation should be testjumped or not
 * i.e. can we trust the carry flag to be an accurate indicator
 * of the actual function
 *
 * Returns 1 if we should testjump i.e. ld a,h or l jp z, or 0 for carry conds
 */

int check_lastop_was_testjump(LVALUE* lval)
{
    void (*fn)(LVALUE *lval);
    fn = lval->binop;

    if (fn == zeq || fn == zne || fn == zge || fn == zle || fn == zgt || fn == zlt || fn == zle || fn == lneg || fn == dummy)
        return (0);
    return (1);
}

/*
 * Check whether previous operation was comparison (used for testjump!)
 * At the same time set the result to be of type KIND_INT
 */

int check_lastop_was_comparison(LVALUE* lval)
{
    void (*fn)(LVALUE *lval);
    fn = lval->binop;

    if (fn == zeq || fn == zne || fn == zge || fn == zle || fn == zgt || fn == zlt || fn == zle) {
        lval->val_type = KIND_INT;
        lval->ltype = type_int;
        return (0);
    }
    return (1);
}

