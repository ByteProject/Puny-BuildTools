#include <stdio.h>
#include <stdlib.h>

void showScreen() __naked;
void clearScreen() __naked;

int main(){
  showScreen(); /* copy screen from TPA into display buffer */

  getchar(); /* wait for keypress */

  clearScreen(); /* Clear screen to white on blue. Note that using the
     terminal escape sequence Esc-E does not work, as leaves artefacts
     in last column */

  return 0;
}

void showScreen() __naked {
  __asm
    di
    /* Copy loader and screen to RAM3, so not lost when we 
       switch to different memory configuration */
    ld hl, scrLoader
    ld de, 0xCE00 /* Space in RAM3 between 0xCE00 and 0xE900 is enough
		     to hold data */
    ld bc, scrLoader_End - scrLoader
    ldir

    /* Jump to new copy of code in RAM3 */
    jp 0xCe00
scrLoader:
    /* Switch to RAM4-RAM5-RAM6-RAM3 */
    ld a, %00000101
    ld bc, 0x1FFD
    out (c), a     

    /* Copy screen from RAM3 to RAM5 */
    ld hl, 0xCE00 + scrLoader_data - scrLoader
    ld de, 0x4000
    ld bc, 0x1B00
    ldir

    /* Switch back to RAM0-RAM1-RAM2-RAM3 */
    ld a, %00000001 
    ld bc, 0x1FFD
    out (c), a                           
    jp scrLoader_End /* Return to original code in TPA */

    scrLoader_data: /* Copy of loading screen held in COM file */
    BINARY "screen.bin"

scrLoader_End:            
    ei

    ret
    
  __endasm;            
}

void clearScreen() __naked
{
  __asm
    di

    /* Copy screen-clear routine to RAM3, so not lost when we 
       switch to different memory configuration */
    ld hl, scrClear
    ld de, 0xCE00 /* Space in RAM3 between 0xCE00 and 0xE900 is enough
		     to hold data */
    ld bc, scrClear_End - scrClear
    ldir

    /* Jump to new copy of code in RAM3 */
    jp 0xCE00

scrClear:
    /* Switch to RAM4-RAM5-RAM6-RAM3 */
    ld a, %00000101
    ld bc, 0x1FFD
    out (c), a     

    /* Clear screen */
    ld hl, 0x4000 /* Start of pixel data */
    ld (hl), 0x00 /* Blank line */
    ld de, 0x4001
    ld bc, 0x17ff /* One fewer than length of pixel data */
    ldir

    ld hl, 0x5800 /* Start of attribute data */
    ld (hl), 0x0F /* PAPER blue, INK white */
    ld de, 0x5801
    ld bc, 0x02ff /* One fewer than length of attribute data */
    ldir

    /* Switch back to RAM0-RAM1-RAM2-RAM3 */
    ld a, %00000001 
    ld bc, 0x1FFD
    out (c), a 

    /* Return to main code in TPA */
    jp scrClear_End

scrClear_End:
    ei

    ret
    
  __endasm;            
}
