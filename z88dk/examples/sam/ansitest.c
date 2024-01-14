/*
 *	Test the ANSI terminal
 *
 *	15/4/2000 Stefano Bodrato
 *
 *	Compile with zcc +zxansi ansitest.c
 */


#include <stdio.h>

void main()
{
int x;

/*
        A stupid CSI escape code test
        (normally no use uses CSI)
*/
  printf ("If you can read this, CSI is not working.\n");
  /*  printf ("%c2J",155); */
  printf ("If this the first thing you can read, CSI is OK.\n");


/*
        Set Graphic Rendition test
*/
  printf ("%c[1mBold Text\n",27);
  printf ("%c[2mDim text\n",27);
  printf ("%c[4mUnderlined Text\n",27);
  printf ("%c[24mUn-underlined text\n",27);
  printf ("%c[5mBlink Text\n",27);
  printf ("A new line\n",27);
  printf ("%c[25mUn-blink text\n",27);
  printf ("%c[7mReverse Text\n",27);
  printf ("%c[27mUn-reverse text\n",27);
  printf ("%c[8mConcealed Text\n",27);
  printf ("%c[m",27);


  for (x=37; x>29; x--)
  {
    printf ("%c[%umFore text color %u.\n",27,x,x);
  }


  for (x=40; x<48; x++)
  {
    printf ("%c[%umBack text color %u.\n",27,x,x);
  }


/*
        Restore default text attributes
*/
    printf ("%c[m",27);

/*
        Cursor Position test
        "Draw" an X
*/

  for (x=0; x<11; x++)
  {
    printf ("%c[%u;%uH*\n",27,8+x,22+x);
    printf ("%c[%u;%uH*\n",27,18-x,22+x);
  }

}
