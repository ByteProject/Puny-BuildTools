/*
 *	ZSock C Library
 *
 *	Part of the getxxbyXX series of functions
 *
 *	(C) 6/10/2001 Dominic Morris
 */

#include <net/resolv.h>

int getnetbyname(char *name)
{
        return_nc (getxxbyname(get_networks(),name));
}
