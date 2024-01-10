# FZX Proportional Fonts

FZX v1.0 - a bitmap font format  
Copyright (c) 2013 Andrew Owen  

FZX is a royalty-free compact font file format designed primarily for storing
bitmap fonts for 8 bit computers, primarily the Sinclair ZX Spectrum, although
also adopting it for other platforms is welcome and encouraged!

FZX has the following features:

* proportional spacing
* characters can be up to 16 pixels in width
* characters can be up to 192 pixels in height
* up to 224 characters per font (code 32 to 255)

The formal format specification is provided below. For a practical example look
at the sample source file "Sinclair.fzx.asm".

## Specification

The format consists of a three byte header followed by a variable-length table
and a variable-length set of character definitions.

The header format is:
```
height   - vertical gap between baselines in pixels
           This is the number of pixels to move down after a carriage return.

tracking - horizontal gap between characters in pixels
           Character definitions should not include any white space and this
           value should normally be a positive number. It may be zero for
           script style fonts where characters run together.

lastchar - the ASCII code of the last definition in the font
           All characters up to and including this character must have an
           entry in the list of definitions although the entry can be blank.
```
The table consists of a three byte entry for each character from ASCII 32 to the
last character defined (lastchar), followed by a final word containing the
offset to the byte after the last byte of the last definition).

![FZX Font Definition](https://github.com/z88dk/z88dk/blob/master/libsrc/_DEVELOPMENT/font/fzx/FZX.png)

The table entry format is:
```
offset   - word containing the offset to the character definition
           This is calculated from the start of the table and stored as an
           offset rather than an absolute address to make the font relocatable.

kern     - a small value (0-3) stored in the highest 2 bits of the offset, that
           indicates a certain character must be always moved left by the
           specified number of pixels, thus reducing its distance from the
           preceding character. In practice this works as a simplified but very
           efficient "kerning".

shift    - nibble containing the amount of leading for the character (0-15)
           This is the number of vertical pixels to skip before drawing the
           character. When more than 15 pixels of white space are required the
           additional white space must be added to the character definition.

width    - nibble containing the width of the character (1-16)
           The width of the character definition in pixels. The value stores is
           one less than the required value.
```
The word (2 bytes) containing the offset and shift can be calculated as follows:

`   offset+16384*kern`

The byte containing the leading and width can be calculated as follows:

`   16*shift+width-1`

The character definitions consist of a byte or pair of bytes for each row of the
character, depending on whether the character is 1 to 8 pixels wide (byte), or
9 to 16 pixels wide (pair of bytes).

## Example

The first few bytes of Sinclair.fzx are as follows:
```
ADDRESS CONTENT COMMENT
0000    09      ; this font has height = 9
0001    02      ; this font has tracking = 2
0002    7f      ; last char defined for this font is $7f = 127
0003    22 01   ; char 32 image starts at $0003+$0122=$0125
0005    05      ; char 32 has shift = 0, width = 5+1=6
0006    1f 01   ; char 33 image starts at $0006+$011f=$0125
0008    10      ; char 33 has shift = 1, width = 0+1=1
0009    22 01   ; char 34 image starts at $0009+$0122=$012b
000b    13      ; char 34 has shift = 1, width = 3+1=4
000c    21 01   ; char 35 image starts at $000c+$0121=$012d
...
00e7    e8 01   ; char 108 image starts at $00e7+$01e8=$02cf
00e9    02      ; char 108 has shift = 0, width = 2+1=3
00ea    ec 01   ; char 109 image starts at $00ea+$01ec=$02d6
00ec    28      ; char 109 has shift = 2, width = 8+1=9
00ed    f3 01   ; char 110 image starts at $00ed+$01f3=$02e0
...
0125    80      ; char 33 images starts here...
0126    80
0127    80
0128    80
0129    00
012a    80
012b    90      ; char 34 image starts here...
012c    90
012d    48      ; char 35 image starts here...
...
02cf    80      ; char 108 image starts here...
02d0    80
02d1    80
02d2    80
02d3    80
02d4    80
02d5    60
02d6    F7 00   ; char 109 image starts here (double size since width > 8)
02d8    88 80
02da    88 80
02dc    88 80
02de    88 80
02e0    F0      ; char 110 image starts here...
```
Notice that offsets are not relative to the beginning of the FZX, but relative
to the current position. These offsets determine both image location and size
for each char.

In example above, pixel image for char 32 is located from $0125 (inclusive) to
$0125 (exclusive), so it has $0125-$0125= 0 bytes. Since char 32 is SPACE,
there was no need to define any pixels for it.

The pixel image for char 33 (exclamation) is located from $0125 (inclusive) to 
$012b (exclusive), so it has $012b-$0125= 6 bytes. There was no need to define 
the remaining bytes since they are all blank anyway.

And so on...

## Legal

The FZX font format is an open standard. You can freely use it to design and
distribute new fonts, or use it inside any programs (even commercial releases).
The only requirement is that this standard should be strictly followed, without
making irregular changes that could potentially cause incompatibilities between
fonts and programs on different platforms.
