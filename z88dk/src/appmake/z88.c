/*
 *      Wonderful routine to create a Z88 application
 *
 *      z88app [binary file] [startup file] [-nt]
 *
 *      djm 2/4/99 - A very, very quick knock up!
 *
 *      Application ID number is generated from time()
 *      - if you have a better automatic algorithm let me know!
 *
 *      djm 12/4/99
 *      Thanks Dennis! The ROM header was being generated two bytes
 *      lower than it should've been..ooops, and oops again!
 *
 *      djm 26/4/99
 *      Implemented some other changes suggested by Dennis, we now
 *      change the suffix for output files, hence default output
 *      will be a.63, a.62 etc
 *      Also added some condition Win/Dos stuff
 *
 *      djm 28/4/99
 *      If zorg != page boundary then we save only from zorg upwards  
 *      (request from DG)
 * 
 *      dg 17/5/99
 *      Changes to make more MSDOS friendly
 *
 *        djm 12/1/2000
 *        Add option to disallow page truncation
 *      
 *      $Id: z88.c,v 1.13 2016-10-09 18:44:47 pauloscustodio Exp $
 */


#include "appmake.h"


#define MAX_ADDR        65472


struct romheader {

/* Front DOR */
    char parent[3];
    char brother[3];
    char son[3];
    char dortype;
    char dorlen;
    char key;
    char namelen;
    char name[5];
    char termin;

    char spacer[37];

/* Card header */
    char cardid[4];
    char cardsize;
    char subtype;
    char header[2];
};

/*
 * Default stuff at the top of the DOR, this is 10 bytes long
 */

static unsigned char appldef[]={ 19, 8 , 'N', 5 , 'A','P','P','L',0,255 };


static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char              help         = 0;

static unsigned char    *memory;      /* Pointer to Z80 memory */
static long              zorg;        /* Origin of compiler program */

/* Options that are available for this module */
option_t z88_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};



/* Prototypes for our functions */
static void SaveBank(unsigned offset, char *base, char *ext);
static void SaveBlock(unsigned offset, size_t length, char* base, char* ext);

#define get_dor_parameter(variable, name) do { \
	variable = parameter_search(crtfile,".map",name); \
	if ( variable == -1 ) { \
		exit_log(1,"Could not find parameter %s - no app dor present\n"); \
	} \
	} while(0)

/*
 * Execution starts here
 */

int z88_exec(char* target)
{
    int pages; /* size of card in banks */
    long indor; /* address of app dor */
    long in_dor_seg_setup; /* address of seg bindings */
    long in_dor_reqpag;
    long in_dor_safedata;
    long in_dor_app_type;
    long crt0_reqpag_check;
    long crt0_reqpag_check1;
    long application_dor_entrypoint;
    FILE* binfile; /* Read in bin file */
    long filesize;
    struct romheader* hdr; /* Pointer to ROM DOR */
    int appdorpg; /* Page where app DOR is */
    int appdoroff; /* Offset of where the app DOR is */
    int readlen; /* Amount read in */
    time_t cardidno; /* Card ID number - construct randomly */
    int reqpag = 0;
    int safedata = 0;

    if (help)
        return -1;

    if (binname == NULL || crtfile == NULL) {
        return -1;
    }


    if (outfile == NULL)
        outfile = binname;

    zorg = get_org_addr(crtfile);
    if (zorg == -1)
        exit_log(1, "Could not find parameter ZORG (compiled as BASIC?)\n");

    get_dor_parameter(indor, "in_dor");
    get_dor_parameter(in_dor_seg_setup, "in_dor_seg_setup");
    get_dor_parameter(application_dor_entrypoint, "application_dor_entrypoint");
    get_dor_parameter(in_dor_reqpag, "in_dor_reqpag");
    get_dor_parameter(in_dor_safedata, "in_dor_safedata");
    get_dor_parameter(in_dor_app_type, "in_dor_app_type");

    crt0_reqpag_check = parameter_search(crtfile, ".map", "crt0_reqpag_check");
    if (crt0_reqpag_check == -1)
        exit_log(1, "Could not find parameter crt0_reqpag_check - no app crt present\n");
    crt0_reqpag_check1 = parameter_search(crtfile, ".map", "crt0_reqpag_check1");

    safedata = parameter_search(crtfile, ".map", "__crt_z88_safedata");
    if (safedata == -1)
        exit_log(1, "Could not find parameter __crt_z88_safedata - no app crt present\n");
    reqpag = parameter_search(crtfile, ".map", "CRT_Z88_BADPAGES");
    if (reqpag == -1) {
        int asmtail = parameter_search(crtfile, ".map", "__BSS_END_tail");
        if (asmtail == -1) {
            exit_log(1, "reqpag isn't defined and can't find the end of the BSS segment\n");
        }
        reqpag = 0;
        /* If we've only got one byte then we don't need to set reqpag */
        if (asmtail > 0x2001) {
            reqpag = ((asmtail - 0x2000) / 256) + 1;
        }

    }

    pages = ((65536L - (long)(zorg + 1)) / 16384L);
    pages++;
    if (pages == 4) {
        fputs("Four segments needed for this program - you may have some problems\n", stderr);
        fputs("running this beast - try and cut it down a little bit!!\n", stderr);
    }

    /*
 * Allocate some memory
 */


    memory = calloc(1, 65536L);
    if (memory == NULL)
        exit_log(1, "Can't allocate memory\n");

    if ((binfile = fopen_bin(binname, crtfile)) == NULL) {
        exit_log(1, "Can't open binary file\n");
    }

    if (fseek(binfile, 0, SEEK_END)) {
        fclose(binfile);
        exit_log(1, "Couldn't determine the size of the file\n");
    }

    filesize = ftell(binfile);
    if (filesize > 65536L) {
        fclose(binfile);
        exit_log(1, "The source binary is over 65,536 bytes in length.\n");
    }

    fseek(binfile, 0, SEEK_SET);

    /* Check to see if we will infringe on the ROM header, if not then load it in */
    if (zorg + filesize <= MAX_ADDR) {

        readlen = fread(memory + zorg, 1, filesize, binfile);

        if (filesize != readlen) {
            fclose(binfile);
            exit_log(1, "Couldn't read in binary file\n");
        }
    } else {
        fclose(binfile);
        exit_log(1, "Binary file too large! Change the org!\n");
    }
    fclose(binfile);

    if ( reqpag && ((memory[in_dor_app_type] & 31) == 1 || (memory[in_dor_app_type]&31) == 8 )) {
        printf("App needs %d of bad memory, but is %s - app won't start correctly\n",reqpag, (memory[in_dor_app_type]&31) == 1 ? "AT_GOOD" : "AT_POPD");
    } else {
        printf("App will use %d pages of bad memory\n", reqpag);
    }

    /*  We've read it in, so now construct the ROM header */
    hdr = (struct romheader*)(memory + MAX_ADDR);

    /*
     * Try to create some sort of unique card id number so we don't clash
     * violently with other apps, we'll use time() which returns the time
     * since a base - different for different OS, but hopefully consistent
     * with different flavours of the OS
     */

    cardidno = time(NULL);

    hdr->cardid[0] = (cardidno % 256) & 127;
    hdr->cardid[1] = (cardidno / 256) & 127;
    hdr->cardid[2] = (cardidno % 65536) & 127;
    hdr->cardid[3] = (cardidno / 65336) | 128;

    hdr->cardsize = (char)pages;
    hdr->subtype = 0;
    hdr->header[0] = 'O';
    hdr->header[1] = 'Z';
    memcpy(&hdr->dortype, appldef, 10);
    /* Now, deal with the dor address */
    appdorpg = 63 - ((65536L - (long)(indor + 1)) / 16384L);
    appdoroff = indor & 16383;
    hdr->son[0] = appdoroff % 256;
    hdr->son[1] = appdoroff / 256;
    hdr->son[2] = appdorpg;

    /* Now, set up the needed pages in the app DOR */
    switch (pages) {
    case 4:
        *(memory + in_dor_seg_setup ) = (char)60;
    case 3:
        *(memory + in_dor_seg_setup  + 1) = (char)61;
    case 2:
        *(memory + in_dor_seg_setup  + 2) = (char)62;
    case 1:
        *(memory + in_dor_seg_setup  + 3) = (char)63;
    }

    *(memory + in_dor_reqpag ) = reqpag ? (reqpag < 32 ? 32 : reqpag) : 0;
    *(memory + crt0_reqpag_check  + 1) = reqpag;
    if (crt0_reqpag_check1 != -1) {
        *(memory + crt0_reqpag_check1  + 2) = reqpag + 0x20;
    }
    printf("Safe data is %d\n", safedata);
    *(memory + in_dor_safedata ) = safedata % 256;
    *(memory + in_dor_safedata  + 1) = safedata / 256;

    /* Application enquire entry point.
     * If we need no bad memory or we have more than 32 pages or we have amalloc
     * enabled then we can't return anything
     */
    if (reqpag == 0 || reqpag > 32 || crt0_reqpag_check1 != -1) {
        *(memory + application_dor_entrypoint  + 3) = 0x37; /* scf */
        *(memory + application_dor_entrypoint  + 4) = 0xc9; /* ret */
    } else {
        // TODO: We should correct the application type
        /* ld bc, start, ld bc, end, and a, ret */
        *(memory + application_dor_entrypoint  + 3) = 0x01; /* ld bc,nnnn */
        *(memory + application_dor_entrypoint  + 4) = (8192 + reqpag) % 256;
        *(memory + application_dor_entrypoint  + 5) = (8192 + reqpag) / 256;
        *(memory + application_dor_entrypoint  + 6) = 0x11; /* ld de,nnnn nnnn=16384*/
        *(memory + application_dor_entrypoint  + 7) = 0x00;
        *(memory + application_dor_entrypoint  + 8) = 0x40;
        *(memory + application_dor_entrypoint  + 9) = 0xa7; /* and a */
        *(memory + application_dor_entrypoint  + 10) = 0xc9; /* ret */
    }

    /* Okay, now thats done, we have to save the image as banks.. */
    if (pages == 4)
        SaveBank(0, outfile, ".60");
    if (pages >= 3)
        SaveBank(16384, outfile, ".61");
    if (pages >= 2)
        SaveBank(32768, outfile, ".62");
    SaveBank(49152, outfile, ".63");
   // Save a .epr version as well
    if ( pages == 1 ) pages = 2;
    SaveBlock( 65536 - (pages * 16384), pages * 16384, outfile, ".epr");


    return 0;
}


static void SaveBank(unsigned offset, char *base, char *ext)
{
    SaveBlock(offset, 16394, base, ext);
}

static void SaveBlock(unsigned offset, size_t length, char* base, char* ext)
{
    char name[FILENAME_MAX + 1];
    FILE* fp;

    strcpy(name, base);
    suffix_change(name, ext);

    if ((fp = fopen(name, "wb")) == NULL) {
        exit_log(1, "Can't open output file %s\n", name);
    }

    if (fwrite(memory + offset, 1, length, fp) != length) {
        exit_log(1, "Can't write to  output file %s\n", name);
    }
    fclose(fp);
}
