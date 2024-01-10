include(__link__.m4)

#ifndef __ASSERT_H__
#define __ASSERT_H__

#include <stdio.h>
#include <stdlib.h>

#ifdef NDEBUG

   #define assert(exp)         ((void)0)

#else

   #define __assert_s(s)       #s
   #define __assert_i(s)       __assert_s(s)
   #define assert(exp)         if (!(exp))  { fputs(__FILE__ " line " __assert_i(__LINE__) ": assert(" __assert_s(exp) ") failed\n", stderr); abort(); }

#endif

#endif
