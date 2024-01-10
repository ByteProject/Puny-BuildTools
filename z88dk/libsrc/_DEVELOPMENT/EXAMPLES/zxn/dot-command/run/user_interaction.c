#include <stdio.h>
#include <stdlib.h>
#include <input.h>

#include "error.h"
#include "user_interaction.h"

static unsigned char cpos;
static unsigned char cursor[] = "-\\|/";

static void user_interaction_cursor(void)
{
   printf("%c" "\x08", cursor[cpos]);
   if (++cpos >= (sizeof(cursor) - 1)) cpos = 0;
}

void user_interaction(void)
{
   if (in_key_pressed(IN_KEY_SCANCODE_SPACE | 0x8000))
   {
      puts("<break>");

      in_wait_nokey();
      exit((int)err_break_into_program);
   }
}

void user_interaction_spin(void)
{
   user_interaction_cursor();
   user_interaction();
}
