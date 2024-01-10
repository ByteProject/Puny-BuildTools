/*
	Z88DK example for MSX style VDP support

	Example on:
	- how to convert a program from MSX C to Z88dk
	- MSX screen "mode 1" support on Spectravideo SVI
	- vpoke command for direct VDP access
	- differences between sdcc and z88dk (speed, parameter passing equivalences)
	
	$Id: vpoke.c $
	
	-- examples listed in increasing speed order --
	zcc +svi -lndos -create-app -O0 vpoke.c
	zcc +svi -lndos -create-app -O3 vpoke.c
	zcc +svi -lndos -create-app -compiler=sdcc vpoke.c
	
	zcc +msx -lndos -create-app vpoke.c
	zcc +msx -lndos -create-app -compiler=sdcc vpoke.c
*/

#include <stdio.h>
#include <msx.h>
//#include <msxalib.h>
//#include <msxclib.h>

//#define T32NAM *((int *)0xf3bd)
#define T32NAM 0x1800

void fill(char ch)
{
	int i, j, k;
	int ad = T32NAM - 1;
	int x = 32;
	int y = 23;

	for (i = 0; i <= 11; ++i) {
		for (j = 0; j < x; ++j) {
			vpoke(++ad, ch);
			for (k = 0; k < 1000; ++k);
		}
	    --x;
		for (j = 0; j < y; ++j) {
			vpoke(ad += 32, ch);
			for (k = 0; k < 1000; ++k);
		}
	    --y;
		for (j = 0; j < x; ++j) {
			vpoke(--ad, ch);
			for (k = 0; k < 1000; ++k);
		}
	    --x;
		for (j = 0; j < y; ++j) {
			vpoke(ad -= 32, ch);
			for (k = 0; k < 1000; ++k);
		}
	    --y;
	}
}

void main()
{
	int i;
	//ginit();
	msx_color(15, 0, 0);
	//screen(1);
	msx_set_mode(mode_1);
	fill('?');
	fill(' ');
	//screen(0);
	msx_set_mode(mode_0);
}

