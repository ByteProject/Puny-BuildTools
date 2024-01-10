/* ----------------------------------------------------------------
 * BIFROST*L ENGINE DEMO - converted to z88dk C Compiler
 *
 * Original version and further information is available at
 * http://www.worldofspectrum.org/infoseekid.cgi?id=0027405
 * ----------------------------------------------------------------
 */
#include <stdio.h>
#include <stdlib.h>
#include <input.h>
#include <arch/zx.h>
#include <arch/zx/bifrost_l.h>

#pragma printf = "%c"

#pragma output CLIB_MALLOC_HEAP_SIZE = 0            // do not create a heap
#pragma output REGISTER_SP           = -1           // do not change sp

#define printInk(k)          printf("\x10%c", '0'+(k))
#define printPaper(k)        printf("\x11%c", '0'+(k))
#define printAt(row, col)    printf("\x16%c%c", (col)+1, (row)+1)

extern unsigned char ctiles[];

void pressAnyKey() {
    in_wait_nokey();

    printInk(7);
    printAt(22, 1);
    printf("PRESS ANY KEY");

    in_wait_key();

    printAt(22, 1);
    printf("             ");
}

void pressSpeedKey() {
    int f, key;

    for (f = 0; f < 51; ++f) {
        BIFROSTL_setTile(rand()%9, rand()%9, rand()%8);
    }
    in_wait_nokey();

    printInk(7);
    printAt(22, 1);
    printf("CHOOSE SPEED 2-4 OR 0 TO EXIT");

    while ((key = in_inkey()) != '0') {
        switch (key) {
            case '2':
                BIFROSTL_resetAnimSlow();
                printInk(5);
                printAt(20, 25);
                printf(" slow)");
                break;
            case '4':
                BIFROSTL_resetAnimFast();
                printInk(5);
                printAt(20, 25);
                printf(" fast)");
                break;
        }
    }

    printAt(22, 1);
    printf("                             ");
}

main()
{
    int f, g, a, b, c;

    zx_border(0);
    zx_cls(0);
    printPaper(0);
    printInk(6);
    printAt(4, 22);
    printf("BIFROST*");
    printAt(5, 23);
    printf("ENGINE");
    printAt(6, 24);
    printf("DEMO");
    printInk(4);
    printAt(10, 24);
    printf("with");
    printAt(11, 23);
    printf("z88dk!");

	 BIFROSTL_resetTileImages(_ctiles);
	 
    for (f = 0; f < 81; ++f) {
        BIFROSTL_tilemap[f] = BIFROSTL_STATIC + f;
    }

	 BIFROSTL_start();
	 
    while (1) {
        pressAnyKey();

        printInk(5);
        printAt(20, 1);
        printf("Demonstrating static tiles");

        for (f = 0; f < 81; ++f) {
            BIFROSTL_tilemap[f] = BIFROSTL_STATIC + (rand()%26)+8;
        }
        pressAnyKey();

        printInk(5);
        printAt(20, 1);
        printf("Animated tiles (4 frames) ");

        pressSpeedKey();

        printInk(5);
        printAt(20, 17);
        printf("2");

        BIFROSTL_resetAnim2Frames();
        pressSpeedKey();
        BIFROSTL_resetAnim4Frames();

        printInk(5);
        printAt(20, 1);
        printf("Directly modifying areas      ");

        M_BIFROSTL_SETTILE(4, 4, BIFROSTL_DISABLED);
        M_BIFROSTL_SETTILE(4, 5, BIFROSTL_DISABLED);

        printAt(9, 9);
        printf("BIFR");
        printAt(10, 9);
        printf("OST*");

        for (c = 0; c < 8; ++c) {
            a = rand()%8;
            for (b = 0; b < 2; ++b) {
                for (f = 8+72+0; f < 8+72+16; ++f) {
                    for (g = 9; g < 13; ++g) {
                        *BIFROSTL_findAttrH(f, g) = (b == 0 ? a*8 : a);
                        a = (a == 7 ? 3 : a+1);
                    }
                }
            }
        }
    }
}

