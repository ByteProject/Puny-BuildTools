/*
 *      Part of the library for fcntlt
 *
 *      int open(char *name,int access, mode_t mode)
 *
 *      djm 27/4/99
 *
 *      Flags are either:
 *
 *      O_RDONLY = 0
 *      O_WRONLY = 1   
 *      O_RDWR   = 2    
 *
 *      | with:
 *      O_APPEND = 256
 *      O_TRUNC = 512
 *
 * -----
 * $Id: open.c,v 1.2 2016-06-13 19:55:47 dom Exp $
 */

#include <cpm.h>
#include <stdio.h>
#include <fcntl.h>      /* Or is it unistd.h, who knows! */

int open(char *name, int flags, mode_t mode)
{
    struct fcb *fc;
    unsigned char uid,pad;
    int   fd;

    if ( ( fc = getfcb() ) == NULL ) {
        return -1;
    }
	
    if ( setfcb(fc,name) == 0 ) {  /* We had a real file, not a device */
        if ( (flags & O_RDONLY) && bdos(CPM_VERS,0) >= 0x30 )
            fc->name[5] |= 0x80;    /* read only mode */
        uid = getuid();
        setuid(fc->uid);
        if ( (flags & O_TRUNC) == O_TRUNC)
            remove(name);
		
        if ( bdos(CPM_OPN,fc) == -1 ) {
            clearfcb(fc);
            setuid(uid);
            if ( (flags & 0xff))  { /* If returned error and writer then create */
                fd = creat(name,0);
                if ( fd == -1 )
                    return -1;
                fc = &_fcb[fd];
                fc->use = (flags + 1 ) & 0xff;
                return fd;
            }
            return -1;   /* An error */
        }

        setuid(uid);
        fc->use = (flags + 1 ) & 0xff;
    }
	
	/* we keep an extra byte in the FCB struct to support random access,
	   but at the moment we use only a "TEXT/BINARY" discrimintation flag */
	fc->mode = mode & _IOTEXT;

    fd =  (fc - &_fcb[0]);
    if (flags & O_APPEND)
        lseek(fd,0L,SEEK_END);
    return fd;
}
