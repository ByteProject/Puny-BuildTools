include(__link__.m4)

#ifndef __STDDEF_H__
#define __STDDEF_H__

#ifndef NULL
#define NULL          ((void *)0)
#endif

typedef int           ptrdiff_t;

#ifndef _SIZE_T_DEFINED
#define _SIZE_T_DEFINED
typedef unsigned int  size_t;
#endif

typedef unsigned char max_align_t;

#ifndef _WCHAR_T_DEFINED
#define _WCHAR_T_DEFINED
typedef unsigned char wchar_t;
#endif

#ifdef __SDCC

#define offsetof(t,m) __builtin_offsetof(t,m)

#endif

#ifdef __SCCZ80

#define offsetof(t,m) __builtin_offsetof(t,m)

#endif

#endif
