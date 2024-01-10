/*
 *      dstar.c
 *
 *      dstarz88 is a conversion of a TI86 game I found with 
 *      source on www.ticalc.org.
 *
 *      The original program was written by Andrew Von Dollen who
 *      in turn based it on a HP game by Joe W.
 *
 *      The aim of the game is to collect all the clear bubbles by
 *      running over them. You control either the dark bubble or
 *      the solid box. The dark bubble is used to collect the clear
 *      bubbles, and the solid box is used as a sort of movable wall.
 *
 *      Both objects carry on moving until they hit something else
 *      (except for the dark bubble in the case of clear bubbles).
 *
 *      The keys are defined in #define statements, and default thus:
 *
 *      Up:     Q
 *      Down:   A
 *      Left:   O
 *      Right:  P
 *      Quit:   G
 *      Retry:  H
 *      Switch: [SPACE]
 *
 *      Switch changes between the dark bubble and the solid box.
 *
 *      This is the first game ever produced with the Small C compiler -
 *      it was written as a statement saying that it is possible to
 *      write something easily, quickly and efficiently using the
 *      compiler. Hopefully it will be an encouragement for others to
 *      do likewise!
 *
 *      For your interest I've also included the original Z88 converted
 *      assembler from which I worked - it's quite crude but it just
 *      about functions, the C is much more refined!
 *
 *      Enough twaddle, enjoy the game and study the source!
 *
 *      d. <djm@jb.man.ac.uk> 1/12/98
 *
 *      This is the application version of the program, compile with:
 *
 *      This example demonstrates the dstar_redrawscreen function which allows
 *      you to supply a routine to redraw the screen and take the load
 *      off of OZ. This is a bad app out of necessity really, you can
 *      write good ones! - Have a look at the file doc/apps.html for
 *      more details.
 */

/*
 * Compiler options, need expanded z88 (cos we use the map), need 5
 * bad pages and we should write the .asm file in app format
 */
#pragma -expandz88
#pragma redirect redrawscreen = _dstar_redrawscreen
#pragma redirect handlecmds =  _dstar_handlecmds


/* Call up the required header files */

#include <stdio.h>
#include <stdlib.h>
#include <graphics.h>

/* dstar.h contains the levels and "sprite" data */

#include "dstar.h"



#define NO 0
#define MAXLEVEL 25
#define STARTLEV  0     /* Start level -1 */

/* Block numbers.. */

#define WALL 1  
#define BUBB 2
#define BALL 3
#define BOX 4

/* Key definitions, change these to define your keys! */

#define K_UP 'Q'
#define K_DOWN 'A'
#define K_LEFT 'O'
#define K_RIGHT 'P'
#define K_SWITCH 32
#define K_EXIT  'G'
#define K_CLEAR 'H'


/* Declare some variables to start off with! */


unsigned char balloffset;        /* Ball position */
unsigned char boxoffset;         /* Box position */
unsigned char ballorbox;         /* 1 if box, 0 if ball */
unsigned char level;             /* Take a guess! */
unsigned char gameon;            /* Flag for dstar_redrawscreen */

unsigned char board[144];        /* Level internal map thing */
unsigned char tiscr[1024];       /* Our very own TI86 screen! */


/* Some character arrays to handle window functions */

unsigned char windtitle[]= {
            1,'7','#','3',32+7,32+1,32+34,32+7,131,   
            1,'2','C','3',1,'4','+','T','U','R',1,'2','J','C',
            1,'3','@',32,32, /*reset to (0,0)*/
            'D','S','t','a','r',' ','z','8','8',
            1,'3','@',32,32 ,1,'2','A',32+34,0   
        };

unsigned char baswindres[]= {
               1,'7','#','3',32,32,32+94,32+8,128,1,'2','C','3',0
               };

unsigned char windclr[]= {
                1,'2','C','3',
                1,'3','@',32,32,1,'2','+','B',0
                };

/* Used for the map, keep it global so we can close it easily! */

struct window graphics;

/* prototype to stop barfing */
void myexit();
void playgame();
void setupgame();
void gamekeys();
void left(unsigned char *ptr);
void right(unsigned char *ptr);
void down(unsigned char *ptr);
void up(unsigned char *ptr);
int standardmiddle(unsigned char nextpos);
void setuplevel();
void dstar_redrawscreen(void);
void puttiblock(unsigned char spr,int x, int y);
void drawboard();
void doozcopyasm();
int checkfinish();



int main()
{
        gameon=0;
        dstar_redrawscreen();         /* Define the windows */
        playgame();     /* Play the game */
        myexit();       /* Clean up after ourselves */
	return 0;
}

void myexit()
{
        closegfx(&graphics);     /* Close the Map window */
        exit(0);                /* Get outta here! */
}


void playgame()
{
        setupgame();            /* Set level to 1, get level etc */
/* Loop while checkfinish() says we haven't finished! */

        while ( checkfinish() ) {
                gamekeys();     /* Scan keys */
        }
}


/* Set some variables up at the start.. */

void setupgame()
{
        ballorbox=NO;
        level=STARTLEV;
        setuplevel();
}


void gamekeys()
{
        unsigned char *charptr;

/* Set up a pointer to the variable we want to change (either for
 * box or for ball
 */
        if (ballorbox) charptr=&boxoffset;
        else charptr=&balloffset;

        switch( getk() ) {      /* Use OZ to get the key */
                case K_DOWN:
                        down(charptr);
                        break;
                case K_UP:
                        up(charptr);
                        break;
                case K_RIGHT:
                        right(charptr);
                        break;
                case K_LEFT:
                        left(charptr);
                        break;
                case K_SWITCH:
                        ballorbox^=1;   /* Toggle ball/box */
                        break;
                case K_EXIT:
                        myexit();
                case K_CLEAR:
                        setuplevel();
        }
}


/* Movement functions - all of these are pretty well similar so I
 * will only comment the first one - it's fairly obvious what is
 * happening though
 */

void left(unsigned char *ptr)
{
        unsigned char *locn;

        while(1) {
                locn=*(ptr)+board;
                if (standardmiddle(*(locn-1)) ) return;
                *(locn-1)=*locn;
                *locn=0;
                (*ptr)--;       /* ptr is the location of blob */
                drawboard();    /* Draw screen */
        }
}


void right(unsigned char *ptr)
{
        unsigned char *locn;

        while(1) {
                locn=*(ptr)+board;
                if (standardmiddle(*(locn+1)) ) return;
                *(locn+1)=*locn;
                *locn=0;
                (*ptr)++;
                drawboard();
        }
}

void down(unsigned char *ptr)
{
        unsigned char *locn;

        while(1) {
                locn=*(ptr)+board;
                if (standardmiddle(*(locn+16)) ) return;
                *(locn+16)=*locn;
                *locn=0;
                (*ptr)+=16;
                drawboard();
        }
}

void up(unsigned char *ptr)
{
        unsigned char *locn;

        while(1) {
                locn=*(ptr)+board;
                if ( standardmiddle(*(locn-16)) ) return;
                *(locn-16)=*locn;
                *locn=0;
                (*ptr)-=16;
                drawboard();
        }
}


/* Check to see if we're running into anything, if box is set then
 * if we hit anything we want to stop, if we're ball then if we
 * hit anything except for bubble we wanna stop
 */

int standardmiddle(unsigned char nextpos)
{
        if (ballorbox)
                return (nextpos);       /* For box */
        else
                if (nextpos==BUBB || nextpos==NO) return(0);
        return(1);
}



/* Check to see if a level is finished
 * There are 144 squares in each level, note the use of != instead of
 * </<= - this is quicker to execute on the Z80!
 */

int checkfinish()
{
        unsigned char *ptr;
        int i;
        ptr=board;
        for (i=1; i!=144; i++) {
                if (*ptr++ == BUBB) return(1);
        }
        if ( ++level==MAXLEVEL ) return(0);     /* Done all the levels!! */
        setuplevel();
        return(1);
}

/* Setup a level..the level is stored compressed, taking up 38 bytes a
 * time.
 *      byte 0 - position of ball
 *      byte 1 - position of box
 *      2-37   - level data
 *
 * Level data is stored as two bits per square, so we have to shift our
 * picked up byte round to get it
 */

void setuplevel()
{
        int y,x;
        unsigned char *ptr,*ptr2;
        ptr2=board;
        ptr=levels+(level*38);
/* ptr points to start of level now */
/* First two bytes are the ball and the boxes position */
        balloffset=*ptr++;
        boxoffset=*ptr++;

/* Now, decompress level into board */
        for (y=0; y!=9; y++) {
                for (x=0; x !=4; x++) {
                        *ptr2++=((*ptr)>>6)&3;
                        *ptr2++=((*ptr)>>4)&3;
                        *ptr2++=((*ptr)>>2)&3;
                        *ptr2++=(*ptr)&3;
                        ptr++;
                }
        }
/* Now, plot the ball and box into the internal map */
        ptr2=board;
        *(ptr2+balloffset)=BALL;
        *(ptr2+boxoffset)=BOX;
        gameon=1;
        drawboard();
}



/* Define the text window and the graphics window
 * If can't open graphics window then exit gracefully
 */

void dstar_redrawscreen(void)
{
        struct window text;
/*
 * Clear the whole screen
 */
        puts(baswindres);
/* Define and open a text window with title and other embellishments
 * strings are at top for clearing, position etc
 */
        text.number='3';
        text.x=32+7;
        text.y=32+1;
        text.width=32+34;
        text.depth=32+7;
        text.type=131;
        text.graph=0;
        window(&text);
        fputs(windtitle,stdout);
        text.x=32+8;
        text.y=32+3;
        text.width=32+32;
        text.depth=32+5;
        text.type=128;
        window(&text);
        fputs(windclr,stdout);
        /* Now, try to open a map window.. */
        graphics.graph=1;
        graphics.width=128;
        graphics.number='4';
        if (window(&graphics)) {
                puts("Sorry, Can't Open Map");
                sleep(5);
                exit(0);
        }
/* Sucessfully opened, now dump some info in the text window! */
        puts("       DStar Z88 - C Demo");
        fputs("Original TI game By A Von Dollen",stdout);
        puts("  Converted to Z88 By D Morris");
        puts("    Keys: Q,A,O,P,SPACE,H,G");
        if (gameon) drawboard();
}

/* Draw the board, mostly written in C, even though we did take a bit
 * of a performance hit when it was converted over from asm
 */

void drawboard()
{
        int x,y;
        unsigned char *ptr;

/* We let OZ in here, because we only go back to the loop once our
 * thing has hit something
 */
        getk();

        ptr=board;

        for (y=0;y!=9;y++) {
                for (x=0;x!=16;x++) {
                        puttiblock((*ptr++),x,y);
                }
        }
        doozcopyasm();
}


/* Dump a sprite onto the TI screen we've built
 * The TI screen is 16 characters wide by 8 deep i.e. half the size
 * of the Z88's map screen. It's stored line by line (sensible!)
 *
 * We enter with y being y/7 and x being x/8 (if we think in pixels)
 * So for each y we have to step down by 112.
 * The increment between rows is 16.
 */
void puttiblock(unsigned char spr,int x, int y)
{
        unsigned char *ptr2,*ptr;
        int i;

/* We use this method instead of y*=112 because the compiler has special
 * cases for multiplying by ints less than 16 (except for 11 and 13 
 * (Hmmm, I wonder why?!?!)
 */
        y=(y*14)*8;
/* So, get where we want to dump our sprite into ptr */
        ptr=tiscr+y+x;
/* Calculate where the sprite is */
        spr*=8;
        ptr2=sprites+spr;
/* And dump it in there */
        for (i=0; i!=7;i++) {
                *ptr=*(ptr2++);
                ptr+=16;
        }
}

/* Ooops, forgive me this one bit of assembler in the entire program!
 * This just copies the TI screen onto the OZ map.
 *
 * It really is easier to keep this routine in here, change it into
 * C if you like..
 */


void doozcopyasm()
{
#pragma asm

        EXTERN	swapgfxbk

        call    swapgfxbk
        call    ozscrcpy
        jp      swapgfxbk

	EXTERN	base_graphics

.ozscrcpy
        ld      de,(base_graphics)
        ld      hl,_tiscr
        ld      c,8
.ozscrcpy1
        push    hl
        ld      b,16
.ozscrcpy3
        push    bc
        push    hl
        ld      bc,16
        ld      a,8
.ozscrcpy2
        ex      af,af
        ld      a,(hl)
        ld      (de),a
        inc     de
        add     hl,bc
        ex      af,af
        dec     a
        jr      nz,ozscrcpy2
        pop     hl
        inc     hl
        pop     bc
        djnz    ozscrcpy3
        pop     hl
        push    bc
        ld      bc,16*8
        add     hl,bc
        pop     bc
        dec     c
        jr      nz,ozscrcpy1
/* Every function always has a ret at the end! So don't need one of
 * our own!!
 */
#pragma endasm
}

/*
 * Now, some application info, have a look at doc/apps.html to see
 * what is going on!
 */

/*
 *      This function handles menu codes
 */

void  dstar_handlecmds(int cmd)
{
        switch(cmd) {
                case 0x82:
                        myexit();
                case 0x81:
                        setuplevel();
                        break;
        }
}

#include <dor.h>

#define HELP1   "A demo application made with z88dk - Small C+ Compiler"
#define HELP2   "Converted from a TI86 game found with source on"
#define HELP3   "www.ticalc.org. Converted to C and Z88 by"
#define HELP4   "Dominic Morris <djm@jb.man.ac.uk>"
#define HELP5   ""
#define HELP6   "v3.0 - 5.4.99 (djm)"

#define APP_INFO "Made by z88dk"
#define APP_KEY  'D'
#define APP_NAME "Dstarz88"
#define APP_TYPE AT_Bad

#define TOPIC1   "Commands"
#define TOPIC1ATTR      TP_Help
#define TOPIC1HELP1     "The only menu we have!"
#define TOPIC1HELP2     "This contains actions that affect the game"

#define TOPIC1_1         "Restart"
#define TOPIC1_1KEY      "CR"
#define TOPIC1_1CODE     $81
#define TOPIC1_1ATTR     MN_Help
#define TOPIC1_1HELP1    "Use this to restart the level"
#define TOPIC1_1HELP2    "For example when you get terrible stuck!"

#define TOPIC1_2         "Quit"
#define TOPIC1_2KEY      "CQ"
#define TOPIC1_2CODE     $82
#define TOPIC1_2ATTR     MN_Help

#define TOPIC1_2HELP1    "Use this to quit the game"
#define TOPIC1_2HELP2    "Not that you'll ever get bored of the game!"

#include <application.h>



/* THE END! */
