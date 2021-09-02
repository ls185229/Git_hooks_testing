#!/usr/bin/env python
"""
$Id:

Build a MAS file from the Womply PAR file.
"""


class WomplyFile():
    """

    A class to manage interactions with the Womply PAR file
    """

    def __init__(self, filename):
        """ initialize class with PAR file"""
        self.file = open(filename)

    def nchars(self):
        """ How many characters are in the file?"""
        return len(self.file.read())

    def nwords(self):
        """ How many words are in the file?"""
        content = self.file.read()
        words = content.split()
        return len(words)

    def nlines(self):
        """ How many lines are in the file?"""
        content = self.file.read()
        return content.count('\n')
