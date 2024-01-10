/*
 *      Small C+ Compiler
 *
 *      Routines for symbol hashing etc
 *
 *      $Id: sym.c,v 1.3 2004-03-26 22:06:09 denniz Exp $
 */

#include "ccdefs.h"

static void initialise_sym(SYMBOL *ptr, char *sname, enum ident_type id, Kind kind, enum storage_type storage);



/* djm
 * Find a local static variable - uses findglb after first kludging the
 * name to a hopefully unique identifier!
 */

SYMBOL *findstc(char* sname)
{
    char sname2[3 * NAMESIZE]; /* Should be enuff! */
    strcpy(sname2, "st_");
    if (currfn)
        strcat(sname2, currfn->name);
    strcat(sname2, "_");
    strcat(sname2, sname);
    return (findglb(sname2));
}


SYMBOL* findglb(const char* sname)
{
    SYMBOL *ptr;

    HASH_FIND_STR(symtab, sname, ptr);

    return ptr;
}

SYMBOL* findloc(char* sname)
{
    SYMBOL* ptr;

    ptr = locptr - 1;
    while (ptr >= STARTLOC) {
        if (strcmp(sname, ptr->name) == 0)
            return ptr;
        --ptr;
    }
    return 0;
}



SYMBOL* addglb(
    char* sname, Type *type, enum ident_type id, Kind kind,
    int value, enum storage_type storage)
{
    SYMBOL* ptr;
    if ((ptr = findglb(sname))) {
        /*
         * djm, this is not to be abused!!!!
         *
         * This bit of code allows us to overturn extern declaration of stuff,
         * Useful for those programs which extern everything in header files
         * 
         */
        if ((ptr->storage == EXTERNAL && storage != EXTERNAL) ) {
            ptr->storage = storage;
            ptr->ctype = type;
            return (ptr);
        }
        if ((ptr->storage == EXTERNAL && storage == EXTERNAL) ) {
            ptr->ctype = type;            
            return (ptr);
        }

        if ( type_matches(type, ptr->ctype) ) {
            return ptr;
        }

        multidef(sname);
        return (ptr);
    }
    ptr = CALLOC(1, sizeof(*ptr));
    initialise_sym(ptr, sname, id, kind, storage);
    ptr->offset.i = value;
    ptr->ctype = type;
    HASH_ADD_STR(symtab, name, ptr);   
    ++glbcnt;
    return (ptr);
}

SYMBOL* addloc(
    char* sname,
    enum ident_type id,
    Kind kind)
{
    SYMBOL* cptr;

    if ((cptr = findloc(sname)) && cptr->level == ncmp ) {
        multidef(sname);
        return cptr;
    }
    if (locptr >= ENDLOC) {
        errorfmt("Local symbol table overflow", 1);
        return 0;
    }
    cptr = locptr++;
    initialise_sym(cptr, sname, id, kind, STKLOC);
    cptr->level = ncmp;
    return cptr;
}



/*
 * insert values into symbol table
 */

static void initialise_sym(
    SYMBOL* ptr,
    char* sname,
    enum ident_type id,
    Kind kind,
    enum storage_type storage)
{
    strcpy(ptr->name, sname);
    ptr->ident = id;
    ptr->type = kind;
    ptr->storage = storage;
    ptr->flags = FLAGS_NONE;
    snprintf(ptr->declared_location, sizeof(ptr->declared_location),"%s:%d", Filename, lineno);
}
