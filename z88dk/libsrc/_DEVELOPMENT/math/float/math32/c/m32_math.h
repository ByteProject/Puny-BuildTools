/*-------------------------------------------------------------------------
   math.h: Floating point math function declarations

   Copyright (C) 2001, Jesus Calvino-Fraga, jesusc@ieee.org

   This library is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by the
   Free Software Foundation; either version 2, or (at your option) any
   later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this library; see the file COPYING. If not, write to the
   Free Software Foundation, 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.

   As a special exception, if you link this library with other files,
   some of which are compiled with SDCC, to produce an executable,
   this library does not by itself cause the resulting executable to
   be covered by the GNU General Public License. This exception does
   not however invalidate any other reasons why the executable file
   might be covered by the GNU General Public License.
-------------------------------------------------------------------------*/

/* Version 1.0 - Initial release */

#ifndef _INC_MATH
#define _INC_MATH

#include <stdint.h>
#include <limits.h>

#define HUGE_POSF   (float)+3.4028234664E+38
#define TINY_POSF   (float)+1.1754943508E−38
#define HUGE_NEGF   (float)-1.7014118346E+38
#define TINY_NEGF   (float)-1.1754943508E-38
#define INFINITY_POSF   ((unsigned long)0x7F800000)
#define INFINITY_NEGF   ((unsigned long)0xFF800000)

#define PI          (float)3.1415926536
#define TWO_PI      (float)6.2831853071
#define HALF_PI     (float)1.5707963268
#define QUART_PI    (float)0.7853981634
#define iPI         (float)0.3183098862
#define iTWO_PI     (float)0.1591549431
#define TWO_O_PI    (float)0.6366197724

// Non-ANSI macros
#define BADTAN          (float)1.560796327
#define EXPLARGE        (float)89.80081863
#define INF             (float)3.00e38
#define IPIby180        (float)57.29577951
#define LNof10          (float)2.302585093
#define LOG2            (float)0.30102999567
#define LOGE            (float)0.43429448190
#define PIby180         (float)0.0174532925
#define POW10INF        (float)38.0
#define SQR10           (float)3.162277660168

#define MAXL2F          ((float)+127.999999914)
#define MINL2F          ((float)-126.0)
#define MAXLOGF         ((float)+88.722839052)
#define MINLOGF         ((float)−87.336544751)
#define MAXL10F         ((float)+38.230809449)
#define MINL10F         ((float)−37.929779454)

union float_long
{
    float f;
    int32_t l;
};

    /****************************************
     * Prototypes for ANSI C math functions *
     ****************************************/

/* Trigonometric functions */
float m32_sinf (float x) __z88dk_fastcall;
float m32_cosf (float x) __z88dk_fastcall;
float m32_tanf (float x) __z88dk_fastcall;
float m32_asinf (float x) __z88dk_fastcall;
float m32_acosf (float x) __z88dk_fastcall;
float m32_atanf (float x) __z88dk_fastcall;
float m32_atan2f (float x, float y);

/* Hyperbolic functions */
float m32_sinhf (float x) __z88dk_fastcall;
float m32_coshf (float x) __z88dk_fastcall;
float m32_tanhf (float x) __z88dk_fastcall;
float m32_asinhf (float x) __z88dk_fastcall;
float m32_acoshf (float x) __z88dk_fastcall;
float m32_atanhf (float x) __z88dk_fastcall;

/* Exponential, logarithmic and power functions */
float m32_expf (float x) __z88dk_fastcall;
float m32_exp2f (float x) __z88dk_fastcall;
float m32_exp10f (float x) __z88dk_fastcall;
float m32_logf (float x) __z88dk_fastcall;
float m32_log2f (float x) __z88dk_fastcall;
float m32_log10f (float x) __z88dk_fastcall;
float m32_powf (float x, float y);

/* Nearest integer, absolute value, and remainder functions */
float m32_ceilf (float x) __z88dk_fastcall;
float m32_fabsf (float x) __z88dk_fastcall;
float m32_floorf (float x) __z88dk_fastcall;
float m32_roundf (float x) __z88dk_fastcall;
float m32_fmodf (float x, float y);
float m32_modff (float x, float *y);

/* Intrinsic functions */
float m32_mul2f (float a) __z88dk_fastcall;
float m32_div2f (float a) __z88dk_fastcall;
float m32_sqrf (float a) __z88dk_fastcall;
float m32_invf (float a) __z88dk_fastcall;
float m32_sqrtf (float a) __z88dk_fastcall;
float m32_invsqrtf (float a) __z88dk_fastcall;
float m32_frexpf (float x, int16_t *pw2) __z88dk_callee;
float m32_ldexpf (float x, int16_t pw2) __z88dk_callee;
float m32_hypotf (float x, float y) __z88dk_callee;
float m32_polyf (const float x, const float d[], uint16_t n) __z88dk_callee;

#endif  /* _INC_MATH */
