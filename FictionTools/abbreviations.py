#!/usr/bin/python
#
#   abbreviations.py
#      by Hugo Labrande
#   Version: 15-Apr-2021

# This script finds very good abbreviations for your Inform game, which helps when space is tight.
# It finds up to 20% more savings than Inform's "-u" switch ; this is about 4k on a 128k story file.
# As a bonus, it's just as fast as that switch when you look at abbreviations of length between 2 and 9.

# Other programs doing this exist: https://intfiction.org/t/highly-optimized-abbreviations-computed-efficiently/48753
# Thank you to Henrik Asman and Matthew Russotto for the discussion. Their programs (for ZIL) find even better abbreviations than this script!
# You'll find them at https://github.com/heasm66/ZAbbrevMaker and https://gitlab.com/russotto/zilabbrs

# Abbreviation strings still aren't an exact science!
#   Due to the fact that the number of 5-bit units has to be a multiple of 3 (and as such gets padded), we can only give estimates


# Input: gametext.txt file containing all the text in your game
#    If the flag -f is specified, the input should be the one of Inform 6.35's -r flag with $TRANSCRIPT_FORMAT=1
#    If no flag is specified, it should just be a game text, for instance Inform with -r (default format, $TRANSCRIPT_FORMAT=0), or
#                cat *.zap | grep -o '".*"' | sed 's/"\(.*\)"/\1/g' >gametext.txt
#         (don't forget to exclude the dictionary words though)
#         You then have to tweak how many lines at the beginning and the end you want to skip        

# Output: If no flag is specified, the abbreviations in Inform's format (use Inform 6.35 with MAX_ABBREVS = 96 and MAX_DYNAMIC_STRINGS = 0)
#         If you specify the -z flag, a file "mygame_freq.zap" will be created in the correct format, ready to use with ZILF/ZILCH.


ZAP_OUTPUT = 0
NEW_GAMETEXT_FORMAT = 0
import sys, getopt

# Deal with command-line arguments
# TODO allow the specification of the name of the file, the lines, etc - I'm being lazy for now
argv = sys.argv[1:]
try:
    opts, args = getopt.getopt(argv,"zf")
except getopt.GetoptError:
    print ('Usage: python3 abbreviations.py [-z] [-f]')
    sys.exit(2)
for opt, arg in opts:
    if opt == '-z':
        ZAP_OUTPUT = 1
    if opt == '-f':
        NEW_GAMETEXT_FORMAT = 1
        


FIRST_FEW_LINES = 0
LAST_FEW_LINES = 0
if (NEW_GAMETEXT_FORMAT == 0):
    # With I6, skip "6+n" lines, where n is the number of abbreviations you declare
    FIRST_FEW_LINES = 70  
    LAST_FEW_LINES = 259



# disregard abbreviations that don't save enough units
MIN_SCORE = 15

# How many do you want?
NUMBER_ABBR = 96   # anything bigger than 64 but smaller than 96 is possible with Inform 6.35, using "MAX_ABBREVS=96; MAX_DYNAMIC_STRINGS=0;"

# One-char strings can be 4 unit longs (for instance ";"), so you could save 2 units per occurence; however at the date of writing, Inform refuses to abbreviate strings of length 0 or 1...
# So starting at 2 is a good idea for now
MIN_LEN = 2
MAX_LEN = 60


# Helper function (weight of a zchar)
def zchar_weight(c):
    if (ord(c) == 32):
        return 1 ## space = char 0
    elif (ord(c) >= 97 and ord(c) <= 122):
        return 1 ## A0 alphabet
    elif (ord(c) >= 65 and ord(c) <= 90):
        return 2 ## A1 alphabet
    elif (c in "^0123456789.,!?_#'~/\-:()"):
        return 2 ## A2 alphabet
    else:
        return 4


## Processing starts here

f = open("gametext.txt", "r")
lines = f.readlines()
# filter out some stuff
if (NEW_GAMETEXT_FORMAT == 1):
    lines2 = []
    for i in range(0, len(lines)):
        cha = lines[i][0]
        # take only if not a comment, an abbreviation, a dictionary word, an attribute name, or a trace message
        if (cha not in "IADSX"):
            # remove the first three characters, the "tag"
            lines2 = lines2 + [lines[i][3:len(lines[i])]]
    lines = lines2
else:
    lines = lines[FIRST_FEW_LINES:len(lines)-LAST_FEW_LINES]

# keep an updated version of the abbreviated text
wholetext = ""
for i in range(0,len(lines)):
    wholetext += lines[i] + "\n"
L = len(wholetext)
wholetext_weight = 0
for i in range(0, len(wholetext)):
    wholetext_weight += zchar_weight(wholetext[i])

l = []
        

for n in range(MIN_LEN,MAX_LEN+1):
    dic = {}
    # each step takes around 1 second on my computer
    print("   Counting frequencies... ("+str(n)+"/"+str(MAX_LEN)+")")
    for li in lines:
        for i in range(0, len(li)-n):
            s = li[i:i+n]
            if (s in dic.keys()):
                dic[s] = dic[s] + 1
            else:
                dic[s] = 1
    
    # First score: naive savings
    
    ## If you want to use the same formula as inform :
    ##     2*((abbrev_freqs[i]-1)*abbrev_quality[i])/3 with abbrev_quality = len -2
    ## A better one is actually counting the units.

    for p in dic.items():
        i = 0
        units = 0
        wd = p[0]
        while (i < len(wd)):
            letter = wd[i]
            if (ord(letter) == 32):
                units += 1 ## space = char 0
            elif (ord(letter) >= 97 and ord(letter) <= 122):
                units += 1 ## A0 alphabet
            elif (ord(letter) >= 65 and ord(letter) <= 90):
                units += 2 ## A1 alphabet
            elif (letter in "^0123456789.,!?_#'~/\-:()"):
                units += 2 ## A2 alphabet
            else:
                if (letter == '@'):
                    ## most likely an accented character like @:e : skip the next 2 letters
                    i+=2
                units += 4 
            i += 1
        ## number of occurences (-1 since you have to write the abbr somewhere) * units saved (units/2) = total units saved
        ## we compute the number of units saved
        ## score = int ((p[1]-1)* (units-2)/3 * 2)
        score = (p[1]-1)* (units-2)
        ## Only add things that save enough units (to speed up the search)
        ## Add something to say when we last updated the score
        if (score > MIN_SCORE):
            l += [[p[0], score, units, 0 ]]

# find the first abbreviation

abbr = []
print("Determining abbreviation "+str(len(abbr)+1)+"...")
l = sorted(l, key=lambda x: x[1])

if ZAP_OUTPUT == 1:
    g = open("mygame_freq.zap", "w")




# given the abbreviation table, what is the optimal way to apply abbreviations for the text?
# this is given in R.A. Wagner , “Common phrases and minimum-space text storage”, Commun. ACM, 16 (3) (1973), pp. 148-152
# this gives us better estimates than just replacing in a text and seeing, because of overlap
def wagner_optimal_parse(text, abblist):
    # dynamic programming algorithm
    # f(n) = "least space needed to store the abbreviated form of the characters n...len(text)"
    N = len(text)
    f = [0 for i in range(0, N+1)]
    # you can compute f(n) from all the f(n+k); your goal is f(1)
    f[N] = 0
    I=N-1
    while(I >= 0):
        # compute f(I) = min( f(I+len(ab))+2, f(I+1)+1) for any matching ab
        val = f[I+1]+zchar_weight(text[I])
        for j in range(0, len(abblist)):
            myabb = abblist[j]
            if (I+len(myabb) <= len(text) and text[I:I+len(myabb)] == myabb):
                # the abbreviation j could be used here, but is it a good idea
                val2 = f[I+len(myabb)]+2
                if (val2 < val):
                    val = val2
        f[I] = val
        I = I-1
    #return the minimal text size with optimal parsing
    return f[0]
    

steps = 0
old_savings = 0
old_textsize = wholetext_weight

while (len(abbr) < NUMBER_ABBR and len(l) > 0):
    steps += 1
    # determine the leaders
    leading_score = l[len(l)-1][1]
    n=1
    while( l[len(l)-1-n][1] == leading_score ):
        n += 1
    print("Found "+str(n)+" leaders with score "+str(leading_score))
    # see if they all have updated score
    flag = 1
    for i in range(1, n+1):
        if (l[len(l)-i][3] != len(abbr)):
            l[len(l)-i][3] = len(abbr)
            # compute how small the text representation would be with that abbreviation added to the set
            # store the difference "without this abbreviation minus with this abbreviation", both computed with optimal parse
            l[len(l)-i][1] = old_textsize-wagner_optimal_parse(wholetext, abbr+[l[len(l)-i][0]])
            flag = 0
    if ( flag == 0 ):
        l = sorted(l, key=lambda x: x[1])
        print("The leaders weren't what we thought; let's sort again...")
    else:
        # at this point, we have a few candidates with equal actual score
        # Matthew Russotto's idea for a tiebreaker: take the high frequency
        #    one (meaning the one with the most weight)
        max = 1
        for i in range(2, n+1):
            if (l[len(l)-max][2] < l[len(l)-i][2]):
                max = i
        # we found our abbreviation
        winner = l[len(l)-max]
        print("Found string : '"+str(winner[0])+"' (units saved: "+str(winner[1])+" units)")
        # the abbreviated text size is decreased by the savings
        old_textsize = old_textsize - winner[1]
        if ZAP_OUTPUT == 1:
            #g.write("        .FSTR FSTR?"+str(len(abbr)+1)+",\""+str(winner[0])+"\"        ; "+str(actual_freq)+"x, saved "+str((actual_freq-1)*(winner[2]-2))+"\n")
            g.write("        .FSTR FSTR?"+str(len(abbr)+1)+",\""+str(winner[0])+"\"        ; "+"\n")
        # the revised score is still better than the next in line's
        abbr = abbr + [str(winner[0])]
        print("Determining abbreviation "+str(len(abbr)+1)+"...")
        # update the array
        lcopy = []
        for i in range(0, len(l)):
            # only add to the copy the strings not containing the abbreviated string
            if (str(winner[0]) not in str(l[i][0])):
                lcopy += [l[i]]
        l = lcopy
        print ("Array updated; now has"+str(len(l))+" entries")
        # no need to sort; the order of the score hasn't changed
        
        
if ZAP_OUTPUT == 1:
    endoffile="WORDS::\n        FSTR?1\n        FSTR?2\n        FSTR?3\n        FSTR?4\n        FSTR?5\n        FSTR?6\n        FSTR?7\n        FSTR?8\n        FSTR?9\n        FSTR?10\n        FSTR?11\n        FSTR?12\n        FSTR?13\n        FSTR?14\n        FSTR?15\n        FSTR?16\n        FSTR?17\n        FSTR?18\n        FSTR?19\n        FSTR?20\n        FSTR?21\n        FSTR?22\n        FSTR?23\n        FSTR?24\n        FSTR?25\n        FSTR?26\n        FSTR?27\n        FSTR?28\n        FSTR?29\n        FSTR?30\n        FSTR?31\n        FSTR?32\n        FSTR?33\n        FSTR?34\n        FSTR?35\n        FSTR?36\n        FSTR?37\n        FSTR?38\n        FSTR?39\n        FSTR?40\n        FSTR?41\n        FSTR?42\n        FSTR?43\n        FSTR?44\n        FSTR?45\n        FSTR?46\n        FSTR?47\n        FSTR?48\n        FSTR?49\n        FSTR?50\n        FSTR?51\n        FSTR?52\n        FSTR?53\n        FSTR?54\n        FSTR?55\n        FSTR?56\n        FSTR?57\n        FSTR?58\n        FSTR?59\n        FSTR?60\n        FSTR?61\n        FSTR?62\n        FSTR?63\n        FSTR?64\n        FSTR?65\n        FSTR?66\n        FSTR?67\n        FSTR?68\n        FSTR?69\n        FSTR?70\n        FSTR?71\n        FSTR?72\n        FSTR?73\n        FSTR?74\n        FSTR?75\n        FSTR?76\n        FSTR?77\n        FSTR?78\n        FSTR?79\n        FSTR?80\n        FSTR?81\n        FSTR?82\n        FSTR?83\n        FSTR?84\n        FSTR?85\n        FSTR?86\n        FSTR?87\n        FSTR?88\n        FSTR?89\n        FSTR?90\n        FSTR?91\n        FSTR?92\n        FSTR?93\n        FSTR?94\n        FSTR?95\n        FSTR?96\n\n        .ENDI"
    g.write(endoffile)
    g.close()

final_savings = wholetext_weight - old_textsize
print("Found "+str(NUMBER_ABBR)+" abbreviations in "+str(steps)+" steps; they saved "+str(final_savings)+" units (~"+str(2*int(final_savings/3))+" bytes)")

s = "Abbreviate "
for i in range(0,NUMBER_ABBR):
    s = s + '"' + abbr[i] +'" '
s += ";"
print(s)

f.close()
