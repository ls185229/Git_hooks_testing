#!/usr/bin/env python

"""
Run Luhn check on input, then mask the numbers.

# $Id: test_luhn.py 4907 2019-10-15 14:15:38Z bjones $

"""

import re
import sys
import select
from builtins import str


def luhn(nbr, debug_level=0):
    """
    Perform Luhn check on input, return true if passes.
    """
    parser = re.compile(r'[^0-9]+')

    temp_str = parser.sub('', nbr)
    if debug_level > 0:
        print("len(temp_str): ", len(temp_str), " len(nbr): ",
              len(nbr), (len(temp_str)*2 <= len(nbr)), temp_str)
    if len(temp_str)*2 <= len(nbr):
        return False
    # print(nbr, temp_str)
    r = [int(ch) for ch in str(temp_str)][::-1]
    return (sum(r[0::2]) +  sum(sum(divmod(d*2, 10)) for d in r[1::2])) % 10 == 0

def mask_card(testlist, filler="*", debug_level=0):
    """
    Mask each of the card numbers found in testlist, replacing the card number
    with the first six, asterix "*" (asterices "**...") and last four.
    """

    # once the luhn function can handle not digits, this is a better pattern.
    # pattern = r'\b(?:\d[ -]*?){13,19}\b'

    pattern = r'\b(?:\d[\ \-\,\_\t]*?){11,25}\b'
    # pattern = r'\b(?:\d[\d \.\-\,\_\t]*?)\b'
    # pattern = r'(?:(?:^|[^.,=])\b(([0-9]?:[ \.\-\,\_\t]*[0-9]){13,19})\b)'
    # pattern = r'(?:(?:^|[^.,=])\b(([0-9]?:[ \.\-\,\_\t]*[0-9]))\b)'
    pattern = r'(?:(?:^|[^.,=])\b([1-9](?:[ \.\-\,\_\t]*\d){12,18})\b)'
    pattern = r'(?:(?:^|[^.,=])\b([1-9](?:[ \.\-\,\_\t]*\d){12,18})(0*)\b)'

    if debug_level > 0:
        print("testlist ", testlist)
    newlist = testlist
    parser = re.compile(pattern)
    if isinstance(testlist, str):

        newstring = ""
        for m in parser.finditer(testlist):
            mtch = m.group()
            print(m.start(), m.span(), m.group(),)
            print(luhn(mtch),)
            if luhn(mtch, debug_level):
                newstring = mtch[0:6] + "*"*(len(mtch)-10) + mtch[-4:]
                print("\t", newstring,)
                newlist = newlist[:m.span()[0]] + newstring + newlist[m.span()[1]:]
            print()
    else:
        raise TypeError
    return newlist

if __name__ == "__main__":
    # print len(sys.argv), sys.argv
    if select.select([sys.stdin,], [], [], 0.0)[0]:
        for line in sys.stdin:
            newlist = mask_card(line)
            sys.stdout.write(newlist)

    elif len(sys.argv) > 1:
        for arg in sys.argv[1:]:
            newlist = mask_card(arg)
            print(newlist)
    else:

        testlist = """
            49927398716         .  49927398717        .
            1234 5678- 1234_5670 .  "alke23451234"     .
            1234567812345678    .  " 461084   7628190017 "   .
            43922683150768110000000 .
            4392268315076811000000  .
            439226831507681100000   .
            43922683150768110000    .
            4392268315076811000     .
            439226831507681100      .
            43922683150768110 
            """
            # test for when luhn check can handle separators
            # 1234 5678 1234 5670
            # 1234-5678-1234-5670

        newlist = mask_card(testlist)
        print("newlist ", newlist)

# testlist
#                 49927398716       .  49927398717        .
#                 1234567812345670  .  "alke23451234"     .
#                 1234567812345678  .  "alke2345123da4"   .
#
# newlist
#                 499273*8716       .  49927398717        .
#                 123456******5670  .  "alke23451234"     .
#                 1234567812345678  .  "alke2345123da4"   .
