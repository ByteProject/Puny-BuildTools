include(__link__.m4)

#if __Z180

#ifndef __Z180_H__
#define __Z180_H__

#include <arch.h>
#include <stdint.h>

// Runtime IM 2

#include <im2.h>

// Exact T State Delay Busy Loop

__DPROTO(,,void,,z180_delay_ms,uint16_t ms)
__DPROTO(`d,e',`d,e',void,,z180_delay_tstate,uint16_t tstates)
__OPROTO(`b,c,d,e',`b,c,d,e',uint8_t,,z180_get_int_state,void)
__DPROTO(`a,b,c,d,e,h,l',`b,c,d,e',void,,z180_set_int_state,uint8_t state)

// IO By Function

__DPROTO(`d,e',`d,e',uint8_t,,z180_inp,uint16_t port)
__DPROTO(`d,e',`d,e',void,*,z180_inir,void *dst,uint8_t port,uint8_t num)
__DPROTO(`d,e',`d,e',void,*,z180_indr,void *dst,uint8_t port,uint8_t num)
__DPROTO(`d,e',`d,e',void,,z180_outp,uint16_t port,uint8_t data)
__DPROTO(`d,e',`d,e',void,*,z180_otir,void *src,uint8_t port,uint8_t num)
__DPROTO(`d,e',`d,e',void,*,z180_otdr,void *src,uint8_t port,uint8_t num)

__DPROTO(`d,e',`d,e',void,*,z180_otimr,void *dst,uint8_t port,uint8_t num)
__DPROTO(`d,e',`d,e',void,*,z180_otdmr,void *src,uint8_t port,uint8_t num)

// Memory by Address

#define z180_bpoke(a,b)  (*(unsigned char *)(a) = b)
#define z180_wpoke(a,b)  (*(unsigned int *)(a) = b)
#define z180_lpoke(a,b)  (*(unsigned long *)(a) = b)

#define z180_bpeek(a)    (*(unsigned char *)(a))
#define z180_wpeek(a)    (*(unsigned int *)(a))
#define z180_lpeek(a)    (*(unsigned long *)(a))

#ifdef __CLANG

#define z180_llpoke(a,b) (*(unsigned long long *)(a) = b)
#define z180_llpeek(a)   (*(unsigned long long *)(a))

#endif

#ifdef __SDCC

#define z180_llpoke(a,b) (*(unsigned long long *)(a) = b)
#define z180_llpeek(a)   (*(unsigned long long *)(a))

#endif

// INTERNAL INTERRUPT VECTORS

#if (__Z180 & __Z180_Z80180)

   // Z80180 CLASS

#else

   // Z8S180 / Z8L180 CLASS

#endif

// IO MAPPED INTERNAL REGISTERS

#if (__Z180 & __Z180_Z80180)

   // Z80180 CLASS

   #ifdef __CLANG

   extern unsigned char CNTLA0;
   extern unsigned char CNTLA1;
   extern unsigned char CNTLB0;
   extern unsigned char CNTLB1;
   extern unsigned char STAT0;
   extern unsigned char STAT1;
   extern unsigned char TDR0;
   extern unsigned char TDR1;
   extern unsigned char RDR0;
   extern unsigned char RDR1;

   extern unsigned char CNTR;
   extern unsigned char TRDR;

   extern unsigned char TMDR0L;
   extern unsigned char TMDR0H;
   extern unsigned char RLDR0L;
   extern unsigned char RLDR0H;
   extern unsigned char TCR;
   extern unsigned char TMDR1L;
   extern unsigned char TMDR1H;
   extern unsigned char RLDR1L;
   extern unsigned char RLDR1H;

   extern unsigned char FRC;

   extern unsigned char SAR0L;
   extern unsigned char SAR0H;
   extern unsigned char SAR0B;
   extern unsigned char DAR0L;
   extern unsigned char DAR0H;
   extern unsigned char DAR0B;
   extern unsigned char BCR0L;
   extern unsigned char BCR0H;
   extern unsigned char MAR1L;
   extern unsigned char MAR1H;
   extern unsigned char MAR1B;
   extern unsigned char IAR1L;
   extern unsigned char IAR1H;
   extern unsigned char BCR1L;
   extern unsigned char BCR1H;
   extern unsigned char DSTAT;
   extern unsigned char DMODE;
   extern unsigned char DCNTL;

   extern unsigned char IL;
   extern unsigned char ITC;

   extern unsigned char RCR;

   extern unsigned char CBR;
   extern unsigned char BBR;
   extern unsigned char CBAR;

   extern unsigned char OMCR;
   extern unsigned char ICR;

   #else

   __sfr __at __IO_CNTLA0 CNTLA0;
   __sfr __at __IO_CNTLA1 CNTLA1;
   __sfr __at __IO_CNTLB0 CNTLB0;
   __sfr __at __IO_CNTLB1 CNTLB1;
   __sfr __at __IO_STAT0 STAT0;
   __sfr __at __IO_STAT1 STAT1;
   __sfr __at __IO_TDR0 TDR0;
   __sfr __at __IO_TDR1 TDR1;
   __sfr __at __IO_RDR0 RDR0;
   __sfr __at __IO_RDR1 RDR1;

   __sfr __at __IO_CNTR CNTR;
   __sfr __at __IO_TRDR TRDR;

   __sfr __at __IO_TMDR0L TMDR0L;
   __sfr __at __IO_TMDR0H TMDR0H;
   __sfr __at __IO_RLDR0L RLDR0L;
   __sfr __at __IO_RLDR0H RLDR0H;
   __sfr __at __IO_TCR TCR;
   __sfr __at __IO_TMDR1L TMDR1L;
   __sfr __at __IO_TMDR1H TMDR1H;
   __sfr __at __IO_RLDR1L RLDR1L;
   __sfr __at __IO_RLDR1H RLDR1H;

   __sfr __at __IO_FRC FRC;

   __sfr __at __IO_SAR0L SAR0L;
   __sfr __at __IO_SAR0H SAR0H;
   __sfr __at __IO_SAR0B SAR0B;
   __sfr __at __IO_DAR0L DAR0L;
   __sfr __at __IO_DAR0H DAR0H;
   __sfr __at __IO_DAR0B DAR0B;
   __sfr __at __IO_BCR0L BCR0L;
   __sfr __at __IO_BCR0H BCR0H;
   __sfr __at __IO_MAR1L MAR1L;
   __sfr __at __IO_MAR1H MAR1H;
   __sfr __at __IO_MAR1B MAR1B;
   __sfr __at __IO_IAR1L IAR1L;
   __sfr __at __IO_IAR1H IAR1H;
   __sfr __at __IO_BCR1L BCR1L;
   __sfr __at __IO_BCR1H BCR1H;
   __sfr __at __IO_DSTAT DSTAT;
   __sfr __at __IO_DMODE DMODE;
   __sfr __at __IO_DCNTL DCNTL;

   __sfr __at __IO_IL IL;
   __sfr __at __IO_ITC ITC;

   __sfr __at __IO_RCR RCR;

   __sfr __at __IO_CBR CBR;
   __sfr __at __IO_BBR BBR;
   __sfr __at __IO_CBAR CBAR;

   __sfr __at __IO_OMCR OMCR;
   __sfr __at __IO_ICR ICR;

   #endif

#else
	
   // Z8S180 / Z8L180 CLASS

   #ifdef __CLANG

   extern unsigned char CNTLA0;
   extern unsigned char CNTLA1;
   extern unsigned char CNTLB0;
   extern unsigned char CNTLB1;
   extern unsigned char STAT0;
   extern unsigned char STAT1;
   extern unsigned char TDR0;
   extern unsigned char TDR1;
   extern unsigned char RDR0;
   extern unsigned char RDR1;
   extern unsigned char ASEXT0;
   extern unsigned char ASEXT1;
   extern unsigned char ASTC0L;
   extern unsigned char ASTC0H;
   extern unsigned char ASTC1L;
   extern unsigned char ASTC1H;

   extern unsigned char CNTR;
   extern unsigned char TRDR;

   extern unsigned char TMDR0L;
   extern unsigned char TMDR0H;
   extern unsigned char RLDR0L;
   extern unsigned char RLDR0H;
   extern unsigned char TCR;
   extern unsigned char TMDR1L;
   extern unsigned char TMDR1H;
   extern unsigned char RLDR1L;
   extern unsigned char RLDR1H;

   extern unsigned char FRC;
   extern unsigned char CMR;
   extern unsigned char CCR;

   extern unsigned char SAR0L;
   extern unsigned char SAR0H;
   extern unsigned char SAR0B;
   extern unsigned char DAR0L;
   extern unsigned char DAR0H;
   extern unsigned char DAR0B;
   extern unsigned char BCR0L;
   extern unsigned char BCR0H;
   extern unsigned char MAR1L;
   extern unsigned char MAR1H;
   extern unsigned char MAR1B;
   extern unsigned char IAR1L;
   extern unsigned char IAR1H;
   extern unsigned char IAR1B;
   extern unsigned char BCR1L;
   extern unsigned char BCR1H;
   extern unsigned char DSTAT;
   extern unsigned char DMODE;
   extern unsigned char DCNTL;

   extern unsigned char IL;
   extern unsigned char ITC;

   extern unsigned char RCR;

   extern unsigned char CBR;
   extern unsigned char BBR;
   extern unsigned char CBAR;

   extern unsigned char OMCR;
   extern unsigned char ICR;

   #else

   __sfr __at __IO_CNTLA0 CNTLA0;
   __sfr __at __IO_CNTLA1 CNTLA1;
   __sfr __at __IO_CNTLB0 CNTLB0;
   __sfr __at __IO_CNTLB1 CNTLB1;
   __sfr __at __IO_STAT0 STAT0;
   __sfr __at __IO_STAT1 STAT1;
   __sfr __at __IO_TDR0 TDR0;
   __sfr __at __IO_TDR1 TDR1;
   __sfr __at __IO_RDR0 RDR0;
   __sfr __at __IO_RDR1 RDR1;
   __sfr __at __IO_ASEXT0 ASEXT0;
   __sfr __at __IO_ASEXT1 ASEXT1;
   __sfr __at __IO_ASTC0L ASTC0L;
   __sfr __at __IO_ASTC0H ASTC0H;
   __sfr __at __IO_ASTC1L ASTC1L;
   __sfr __at __IO_ASTC1H ASTC1H;

   __sfr __at __IO_CNTR CNTR;
   __sfr __at __IO_TRDR TRDR;

   __sfr __at __IO_TMDR0L TMDR0L;
   __sfr __at __IO_TMDR0H TMDR0H;
   __sfr __at __IO_RLDR0L RLDR0L;
   __sfr __at __IO_RLDR0H RLDR0H;
   __sfr __at __IO_TCR TCR;
   __sfr __at __IO_TMDR1L TMDR1L;
   __sfr __at __IO_TMDR1H TMDR1H;
   __sfr __at __IO_RLDR1L RLDR1L;
   __sfr __at __IO_RLDR1H RLDR1H;

   __sfr __at __IO_FRC FRC;
   __sfr __at __IO_CMR CMR;
   __sfr __at __IO_CCR CCR;

   __sfr __at __IO_SAR0L SAR0L;
   __sfr __at __IO_SAR0H SAR0H;
   __sfr __at __IO_SAR0B SAR0B;
   __sfr __at __IO_DAR0L DAR0L;
   __sfr __at __IO_DAR0H DAR0H;
   __sfr __at __IO_DAR0B DAR0B;
   __sfr __at __IO_BCR0L BCR0L;
   __sfr __at __IO_BCR0H BCR0H;
   __sfr __at __IO_MAR1L MAR1L;
   __sfr __at __IO_MAR1H MAR1H;
   __sfr __at __IO_MAR1B MAR1B;
   __sfr __at __IO_IAR1L IAR1L;
   __sfr __at __IO_IAR1H IAR1H;
   __sfr __at __IO_IAR1B IAR1B;
   __sfr __at __IO_BCR1L BCR1L;
   __sfr __at __IO_BCR1H BCR1H;
   __sfr __at __IO_DSTAT DSTAT;
   __sfr __at __IO_DMODE DMODE;
   __sfr __at __IO_DCNTL DCNTL;

   __sfr __at __IO_IL IL;
   __sfr __at __IO_ITC ITC;

   __sfr __at __IO_RCR RCR;

   __sfr __at __IO_CBR CBR;
   __sfr __at __IO_BBR BBR;
   __sfr __at __IO_CBAR CBAR;

   __sfr __at __IO_OMCR OMCR;
   __sfr __at __IO_ICR ICR;

   #endif

#endif

#endif

#endif
