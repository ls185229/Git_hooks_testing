#!/usr/bin/env python

################################################################################
# $Id: build_file_name.py 4698 2018-09-11 22:39:25Z bjones $
# $Rev: 4698 $
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
#                -f, --file_type  file type (e.g., REVERSAL, CONVCHRG, DEBITRAN)
#                -j, --julian_date Julian date for the file.
#
################################################################################

from __future__ import print_function
import fnmatch
import os
import re

class BuildFileNameClass():
    def __init__(self):
        self.matches = []

    def get_mas_file_name(self, inst, file_type, julian_date):
        '''
            Name        : get_mas_file_name
            Arguments   : Institution id, file type and julian date
            Description : Create the MAS file name
            Returns     : MAS file name
        '''
        julian_date_str = str(julian_date)
        base_filename = str(inst) + "." + file_type + ".01." + julian_date_str[1:]

        matches = []

        for curr_dir in (os.getcwd(), os.path.expanduser('~') + '/MAS'):
            for root, dirnames, filenames in os.walk(curr_dir):
                for filename in fnmatch.filter(filenames, base_filename + '*'):
                    matches.append(os.path.join(root, filename))
        if len(matches) > 0:
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
                match_file_name = re.search(search_filename, filename)
                if match_file_name:
                    found = True
                    break

        return search_filename
