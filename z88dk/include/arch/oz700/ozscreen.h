/* 
	HTC Compatibility Library and OZ extras 
	3. BACKLIGHT AND SCREEN CONTROL

	$Id: ozscreen.h,v 1.2 2003-10-21 17:15:19 stefano Exp $
*/

#ifndef _OZSCREEN_H
#define _OZSCREEN_H

extern void __LIB__ oztogglelight(void);
extern void __LIB__ ozsetlight(int l);
//int ozgetlight(void);
extern void __LIB__ ozblankscreen(void);
extern void __LIB__ ozunblankscreen(void);
extern void __LIB__ ozsetcontrast(int c);
extern int __LIB__ ozgetcontrast(void);
#define MAX_CONTRAST 0x3F

#endif
