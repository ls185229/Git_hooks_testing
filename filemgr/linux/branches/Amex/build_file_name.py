#!/usr/bin/env python

################################################################################
# $Id: build_filename.py 3648 2016-01-22 19:55:12Z bjones $
# $Rev: 3648 $
################################################################################
#
#    File Name   -  build_file_name.py
#
#    Description -  This class returns a unique file name based on
#                   institution, file type, and Julian date.
#
#                   The current directory and ~/MAS are searched.
#                   The result of
#                       build_filename.py -i101 -j6025 -fCONVCHRG
#                   would be 101.CONVCHRG.01.6025.001, for the first file that day.
#                   For the 5th file built, it would be 101.CONVCHRG.01.6025.005.
#
#    Arguments   -i, --inst institution id
#                -f, --filetype  file type (e.g., REVERSAL, CONVCHRG, DEBITRAN)
#                -j, --julian_date Julian date for the file.
#
################################################################################

#
#   build unique mas file name using
#       filetype
#       institution
#       julian date
#

from __future__ import print_function

import fnmatch
import os
import getopt
import sys
import re

class BuildFileNameClass():
    def __init__(self):
        tmp = ''
          
    def getFileName(self, inst, fileType, julianDate):
        julianDateStr = str(julianDate)
        base_filename = str(inst) + "." + fileType + ".01." + julianDateStr[1:]
  
        matches = []
    
        for curr_dir in (os.getcwd(), os.path.expanduser('~') + '/MAS'):
            for root, dirnames, filenames in os.walk(curr_dir):
                for filename in fnmatch.filter(filenames, base_filename + '*'):
                    matches.append(os.path.join(root, filename))
        if len(matches) > 0 :
            found = True
        else:
            found = False
 
        seq = 1
        search_filename = base_filename + "." + '{0:03d}'.format(seq)
        while found and seq <= len(matches):
            seq = seq + 1
            found = False  
            search_filename = base_filename + "." + '{0:03d}'.format(seq)

            for filename in matches:
                m = re.search(search_filename, filename)
                if m:
                    found = True
                    break
    
        return search_filename

