#ifndef __STDIO_H__
#define __STDIO_H__

#include <sys/compiler.h>
#include <stdint.h>

/* $Id: stdio.h */

#undef __STDIO_BINARY      /* By default don't consider binary/text file differences */
#undef __STDIO_CRLF        /* By default don't insert automatic linefeed in text mode */

#ifdef __SPECTRUM__
#include <spectrum.h>
#endif

#ifdef __LAMBDA__
#include <zx81.h>
#endif

#ifdef __ZX81__
#include <zx81.h>
#endif

#ifdef __ZX80__
#include <zx81.h>
#endif

#ifdef __CPM__
/* This will define __STDIO_BINARY, __STDIO_EOFMARKER and __STDIO_CRLF  */
#include <cpm.h>
#endif

#ifdef __MSX__
/* This will define __STDIO_BINARY, __STDIO_EOFMARKER and __STDIO_CRLF  */
#include <cpm.h>
#include <msx.h>
#endif

#ifdef __OSCA__
/* This will define __STDIO_BINARY, __STDIO_EOFMARKER and __STDIO_CRLF  */
#include <flos.h>
#endif

#ifdef __SOS__
#include <sos.h>
#endif

#ifdef ZXVGS
#include <zxvgs.h>
#endif


#ifdef AMALLOC
#include <malloc.h>
#endif
#ifdef AMALLOC1
#include <malloc.h>
#endif
#ifdef AMALLOC2
#include <malloc.h>
#endif
#ifdef AMALLOC3
#include <malloc.h>
#endif


/*
 * This is the new stdio library - everything is pretty much
 * generic - just a few machine specific routines are needed
 * and these are clearly marked
 */

#include <sys/types.h>
#include <fcntl.h>

#ifndef NULL
#define NULL ((void *)0)
#endif

#ifndef EOF
#define EOF (-1)
#endif

#define FILENAME_MAX    128


struct filestr {
        union f0xx {
                int         fd;
                uint8_t    *ptr;
        } desc;
        uint8_t  flags;
        uint8_t   ungetc;
        intptr_t  extra;
        uint8_t   flags2;
        uint8_t   reserved;
        uint8_t   reserved1;
        uint8_t   reserved2;
};

/* extra may point to an asm label that can be used to add extra stdio functionality
 * Entry: ix = fp for all 
 */

/* Exit: hl = byte read, c = error, nc = success */
#define __STDIO_MSG_GETC		1
/* Entry: bc = byte to write, Exit: hl = byte written (or EOF) */
#define __STDIO_MSG_PUTC		2
/* Entry: de = buf, bc = len, Exit: hl = bytes read */
#define __STDIO_MSG_READ		3
/* Entry: de = buf, bc = len, Exit: hl = bytes written */
#define __STDIO_MSG_WRITE		4
/* Entry: debc = offset, a' = whence */
#define __STDIO_MSG_SEEK		5
#define __STDIO_MSG_FLUSH		6
#define __STDIO_MSG_CLOSE		7
#define __STDIO_MSG_IOCTL		8


/* For asm routines kinda handy to have a nice DEFVARS of the structure*/
#ifdef STDIO_ASM
#asm
DEFVARS 0 {
	fp_desc		ds.w	1
	fp_flags	ds.b	1
	fp_ungetc	ds.b	1
	fp_extra        ds.w	1
        fp_flags2       ds.b    1
        reserved        ds.b    1
        reserved2       ds.b    1
        reserved3       ds.b    1
}
#endasm
#endif

typedef struct filestr FILE;

/* System is used for initial std* streams 
 * Network streams do not set IOREAD/IOWRITE, it is assumed that
 * they are read/write always
 */

#define _IOUSE          1
#define _IOREAD         2
#define _IOWRITE        4
#define _IOEOF          8
#define _IOSYSTEM      16
#define _IOEXTRA       32
#define _IOTEXT        64
#define _IOSTRING     128


/* Number of open files, this can be overridden by the crt0, but the 10 is the default for classic */
#ifndef FOPEN_MAX
extern void *_FOPEN_MAX;
#define FOPEN_MAX &_FOPEN_MAX
#endif


extern struct filestr _sgoioblk[10]; 
extern struct filestr _sgoioblk_end; 


#define stdin  &_sgoioblk[0]
#define stdout &_sgoioblk[1]
#define stderr &_sgoioblk[2]


#define clearerr(f)
extern FILE __LIB__ *fopen_zsock(char *name);

/* Our new and improved functions!! */

extern FILE __LIB__ *fopen(const char *name, const char *mode) __smallc;
extern FILE __LIB__ *freopen(const char *name, const char *mode, FILE *fp) __smallc;
extern FILE __LIB__ *fdopen(const int fildes, const char *mode) __smallc;
extern FILE __LIB__ *_freopen1(const char *name, int fd, const char *mode, FILE *fp) __smallc;
extern FILE __LIB__ *fmemopen(void *buf, size_t size, const char *mode) __smallc;
extern FILE __LIB__ *funopen(const void     *cookie, int (*readfn)(void *, char *, int),
			int (*writefn)(void *, const char *, int),
			fpos_t (*seekfn)(void *, fpos_t, int), int (*closefn)(void *)) __smallc;

extern int __LIB__ fclose(FILE *fp);
extern int __LIB__ fflush(FILE *);

extern void __LIB__ closeall();


#ifdef SIMPLIFIED_STDIO

/* --------------------------------------------------------------*/
/* The "8080" stdio lib is at the moment used only by the        */
/* Rabbit Control Module, which is not fully z80 compatible      */

extern char __LIB__ *fgets( char *s, int, FILE *fp) __smallc;
extern int __LIB__ fputs( char *s,  FILE *fp) __smallc;
extern int __LIB__ fputc(int c, FILE *fp) __smallc;
extern int __LIB__ fgetc(FILE *fp);
#define getc(f) fgetc(f)
extern int __LIB__ ungetc(int c, FILE *) __smallc;
extern int __LIB__ feof(FILE *fp) __z88dk_fastcall;
extern int __LIB__ ferror(FILE *fp) __z88dk_fastcall;
extern int __LIB__ puts(char *s);

/* Some standard macros */
#define putc(bp,fp) fputc(bp,fp)
#define putchar(bp) fputc(bp,stdout)
#define getchar()  fgetc(stdin)

/* --------------------------------------------------------------*/

#else

/* --------------------------------------------------------------*/
/* Optimized stdio uses the 'CALLEE' convention here and there   */

extern char __LIB__ *fgets(char *s, int, FILE *fp) __smallc;

extern int __LIB__ fputs(const char *s,  FILE *fp) __smallc;
extern int __LIB__ fputc(int c, FILE *fp) __smallc;

extern int __LIB__  fputs_callee(const char *s,  FILE *fp) __smallc __z88dk_callee;
extern int __LIB__  fputc_callee(int c, FILE *fp) __smallc __z88dk_callee;
extern int __LIB__ fgetc(FILE *fp);

#define getc(f) fgetc(f)
extern int __LIB__ ungetc(int c, FILE *) __smallc;
extern int __LIB__ feof(FILE *fp) __z88dk_fastcall;
extern int __LIB__ ferror(FILE *fp) __z88dk_fastcall;
extern int __LIB__ puts(const char *);

#define fputs(a,b)   fputs_callee(a,b)
#define fputc(a,b)   fputc_callee(a,b)

/* Some standard macros */
#define putc(bp,fp) fputc_callee(bp,fp)
#define putchar(bp) fputc_callee(bp,stdout)
#define getchar()  fgetc(stdin)

/* --------------------------------------------------------------*/

#endif

/* Routines for file positioning */
extern fpos_t __LIB__ ftell(FILE *fp);
extern int __LIB__ fgetpos(FILE *fp, fpos_t *pos) __smallc;
#define fsetpos(fp,pos) fseek(fp,pos,SEEK_SET)
#define rewind(fp) fseek(fp,0L,SEEK_SET)
extern int __LIB__ __SAVEFRAME__ fseek(FILE *fp, fpos_t offset, int whence) __smallc;

/* Block read/writing */
extern int __LIB__  fread(void *ptr, size_t size, size_t num, FILE *) __smallc;
extern int __LIB__  fwrite(const void *ptr, size_t size, size_t num, FILE *) __smallc;


/* You shouldn't use gets. z88 gets() is limited to 255 characters */
//#ifdef __STDIO_CRLF
//#define gets(x) fgets_cons(x,255)
//#else
extern char __LIB__ *gets(char *s);
//#endif

extern int __LIB__ printf(const char *fmt,...) __vasmallc;
extern int __LIB__ fprintf(FILE *f,const char *fmt,...) __vasmallc;
extern int __LIB__ sprintf(char *s,const char *fmt,...) __vasmallc;
extern int __LIB__ snprintf(char *s,size_t n,const char *fmt,...) __vasmallc;
extern int __LIB__ vfprintf(FILE *f,const char *fmt,void *ap);
extern int __LIB__ vsnprintf(char *str, size_t n,const char *fmt,void *ap);

#define vprintf(ctl,arg) vfprintf(stdout,ctl,arg)
#define vsprintf(buf,ctl,arg) vsnprintf(buf,65535,ctl,arg)

/* Routines used by the old printf - will be removed soon */
extern void __LIB__ printn(int number, int radix,FILE *file) __smallc;


/*
 * Scanf family 
 */

extern int __LIB__ scanf(const char *fmt,...) __vasmallc;
extern int __LIB__ fscanf(FILE *,const char *fmt,...) __vasmallc;
extern int __LIB__ sscanf(char *,const char *fmt,...) __vasmallc;
extern int __LIB__ vfscanf(FILE *, const char *fmt, void *ap); 
extern int __LIB__ vsscanf(char *str, const char *fmt, void *ap);
#define vscanf(ctl,arg) vfscanf(stdin,ctl,arg)


/*
 * Used in variable argument lists
 */

#ifndef DEF_GETARG
#define DEF_GETARG
extern int __LIB__ getarg(void);
#endif


/* Check whether a file is for the console */
extern int __LIB__ fchkstd(FILE *);

/* All functions below here are machine specific */

/* Get a key press using the default keyboard driver */
extern int __LIB__ fgetc_cons();

/* Get a key press using the "inkey" keyboard driver */
extern int __LIB__ fgetc_cons_inkey();

/* Output a character to the console using the default driver */
extern int __LIB__ fputc_cons(char c);

/* Read a string using the default keyboard driver */
extern char __LIB__ *fgets_cons(char *s, size_t n) __smallc;

extern int __LIB__ puts_cons(char *s);

/* Abandon file - can be the generic version */
extern void __LIB__ fabandon(FILE *);
/* Get file position for file handle fd */
extern long __LIB__ fdtell(int fd);
extern int __LIB__ fdgetpos(int fd, fpos_t *posn) __smallc;
/* Rename a file */
extern int __LIB__ rename(const char *s, const char *d) __smallc;
/* Remove a file */
extern int __LIB__ remove(const char *name);


/* Scan for a keypress using the default keyboard driver */
extern int __LIB__ getk();
/* Scan for a keypress using the "inkey" keyboard driver */
extern int __LIB__ getk_inkey();
#define getkey() fgetc_cons()

/* Print a formatted string directly to the console using the default driver */
extern int __LIB__ printk(const char *fmt,...) __vasmallc;

/* Error handler (mostly an empty fn) */
extern void __LIB__ perror(char *msg) __z88dk_fastcall;


/*
 *  MICRO C compatibility:  keep at bottom of this file
 *  Some of Dunfield's Micro C code can be ported with the '-DMICROC' parameter
 */

#ifdef MICROC
#include <microc.h>
#endif

#endif /* _STDIO_H */
