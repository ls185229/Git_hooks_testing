#!/usr/bin/env python3

# coding=utf8
# the above tag defines encoding for this document and is for Python 2.x compatibility

import re

regex = r"(?:(?:^|[^.,=])\b([1-9](?:[ \.\-\,\_\t]*\d){12,18})0*\b)"

test_str = ("43922683150768110000000  \n"
    "4392268315076811000000 \n"
    "439226831507681100000 \n"
    "43922683150768110000 \n"
    "4392268315076811000 \n"
    "439226831507681100 \n"
    "43922683150768110  \n"
    "4392268315076811  ")

matches = re.finditer(regex, test_str, re.MULTILINE)

for matchNum, match in enumerate(matches, start=1):

    print ("Match {matchNum} was found at {start}-{end}: {match}".format(matchNum = matchNum, start = match.start(), end = match.end(), match = match.group()))

    for groupNum in range(0, len(match.groups())):
        groupNum = groupNum + 1

        print ("Group {groupNum} found at {start}-{end}: {group}".format(groupNum = groupNum, start = match.start(groupNum), end = match.end(groupNum), group = match.group(groupNum)))

# Note: for Python 2.7 compatibility, use ur"" to prefix the regex and u"" to prefix the test string and substitution.
