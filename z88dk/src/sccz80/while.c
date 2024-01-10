/*
 *      Small C+ Compiler
 *
 *      Couple of routines for while statements
 *
 *      $Id: while.c,v 1.2 2004-03-26 22:06:09 denniz Exp $
 */

#include "ccdefs.h"

void addwhile(WHILE_TAB* ptr)
{
    wqptr->sp = ptr->sp = Zsp; /* record stk ptr */
    wqptr->loop = ptr->loop = getlabel(); /* and looping label */
    wqptr->exit = ptr->exit = getlabel(); /* and exit label */
    if (wqptr >= WQMAX) {
        errorfmt("Too many active whiles", 1 );
        return;
    }
    ++wqptr;
}

void delwhile()
{
    if (wqptr > wqueue)
        --wqptr;
}


WHILE_TAB *readwhile(WHILE_TAB *ptr)
{
    if (ptr <= wqueue) {
        errorfmt("Out of context", 0);
        return 0;
    } else
        return (ptr - 1);
}
