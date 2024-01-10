#!/usr/bin/env python3

# Extract the version, release, and serial numbers from a Z-code game file.
# Also show if the file's real length is greater than the length encoded
# in the header.

import sys
import os

def parse(filename):
    fl = open(filename, 'rb')
    dat = fl.read(28)
    if len(dat) < 28:
        print('short data: ' + filename)
        return
    reallen = os.stat(filename).st_size
    zversion = int(dat[0])
    release = int(0x100 * dat[2] + dat[3])
    serial = dat[18:24].decode('latin-1')
    length = int(0x100 * dat[26] + dat[27])
    if zversion <= 3:
        length *= 2
    elif zversion <= 5:
        length *= 4
    else:
        length *= 8
    lengthmsg = ''
    if length == 0:
        lengthmsg = ' (no encoded length)'
    elif reallen < length:
        lengthmsg = ' (short by %d bytes)' % (length-reallen,)
    elif reallen > length:
        lengthmsg = ' (padded by %d bytes)' % (reallen-length,)
    print('z%d release %s serial %s%s: %s' % (zversion, release, serial, lengthmsg, filename))

if not sys.argv[1:]:
    print('Usage: python3 zcanalyze.py files...')
    sys.exit(-1)
    
for filename in sys.argv[1:]:
    try:
        parse(filename)
    except Exception as ex:
        print(filename+':', ex)

    
