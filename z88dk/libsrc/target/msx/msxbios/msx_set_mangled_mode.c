/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	extern void msx_set_mangled_mode();
	
	Set screen to mangled mode (screen 1 + 2)
	
	$Id: msx_set_mangled_mode.c $
*/

#include <msx.h>

#ifdef __SVI__
char blank_char[8]={0,0,0,0,0,0,0,0};
#endif

void msx_set_mangled_mode() {

	msx_set_mode(mode_1);

#ifdef __SVI__
	msx_set_mode(0x3629);
#else
	msx_set_mode(0x7E);   //_SETGRP
#endif

	msx_vwrite((void*)0x1BBF, 0x0800, 0x800);	
	msx_vwrite((void*)0x1BBF, 0x1000, 0x800);	
	msx_vfill(MODE2_ATTR, 0xF0, 0x17FF);
	msx_vfill(0xFF8, 0xFF, 8);
	msx_vfill(0x17F8, 0xFF, 8);
	
#ifdef __SVI__
	msx_set_char(0, blank_char, blank_char, 0, place_all);
	//msx_vfill(0x1800, 0, 32*24);
#endif
	//_init_sprites();
}

