/* /////////////////////////////////////////////////////////////////////////
 * File:    unixem/sys/uio.h
 *
 * Purpose: Vector file read/write.
 *
 * Created: 19th September 2005
 * Updated: 13th August 2010
 *
 * Home:    http://synesis.com.au/software/
 *
 * Copyright (c) 2005-2010, Matthew Wilson and Synesis Software
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 * - Neither the name(s) of Matthew Wilson and Synesis Software nor the
 *   names of any contributors may be used to endorse or promote products
 *   derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 * IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ////////////////////////////////////////////////////////////////////// */


/** \file unixem/sys/uio.h
 *
 * Vector file read/write.
 */

#ifndef SYNSOFT_UNIXEM_INCL_UNIXEM_SYS_H_UIO
#define SYNSOFT_UNIXEM_INCL_UNIXEM_SYS_H_UIO

#ifndef UNIXEM_DOCUMENTATION_SKIP_SECTION
# define SYNSOFT_UNIXEM_VER_UNIXEM_SYS_H_UIO_MAJOR      2
# define SYNSOFT_UNIXEM_VER_UNIXEM_SYS_H_UIO_MINOR      0
# define SYNSOFT_UNIXEM_VER_UNIXEM_SYS_H_UIO_REVISION   1
# define SYNSOFT_UNIXEM_VER_UNIXEM_SYS_H_UIO_EDIT       12
#endif /* !UNIXEM_DOCUMENTATION_SKIP_SECTION */

/* /////////////////////////////////////////////////////////////////////////
 * Includes
 */

#include <stddef.h>

/* ////////////////////////////////////////////////////////////////////// */

/** \weakgroup unixem Synesis Software UNIX Emulation for Win32
 * \brief The UNIX emulation library
 */

/** \weakgroup unixem_uio uio() API
 * \ingroup UNIXem unixem
 * \brief UIO functions and types
 * @{
 */

/* ////////////////////////////////////////////////////////////////////// */

#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

/* /////////////////////////////////////////////////////////////////////////
 * Typedefs
 */

/** Signed size type */
typedef signed long     unixem_ssize_t;

/** Defines a memory vector */
struct unixem_iovec
{
    void*   iov_base;  /*!< Base address */
    size_t  iov_len;    /*!< Number of bytes referenced */
};

/* /////////////////////////////////////////////////////////////////////////
 * Functions
 */

/** Reads from a file into a set of memory blocks
 *
 * \param fd The file from which to read
 * \param vector pointer to the first element in the vector
 * \param count the number of elements in the vector
 */
unixem_ssize_t unixem_readv(
    int                         fd
,   struct unixem_iovec const*  vector
,   int                         count
);

/** Writes to a file from a set of memory blocks
 *
 * \param fd The file to which to write
 * \param vector pointer to the first element in the vector
 * \param count the number of elements in the vector
 */
unixem_ssize_t unixem_writev(
    int                         fd
,   struct unixem_iovec const*  vector
,   int                         count
);

#ifdef __cplusplus
} /* extern "C" */
#endif /* __cplusplus */

/* ////////////////////////////////////////////////////////////////////// */

/** @} // end of group unixem_time */

/* ////////////////////////////////////////////////////////////////////// */

#endif /* SYNSOFT_UNIXEM_INCL_UNIXEM_SYS_H_UIO */

/* ///////////////////////////// end of file //////////////////////////// */
