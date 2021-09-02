#!/usr/bin/env python

################################################################################
# $Id: build_filename.py 3652 2016-01-25 20:18:55Z bjones $
# $Rev: 3652 $
################################################################################
#
#    File Name   -  build_filename.py
#
#    Description -  This is a function returning a unique file name based on
#                   institution, file type, and julian date.
#
#                   The current directory, ~/MAS, and MAS_OSITE_DATA are searched.
#                   The result of
#                       build_filename.py -i101 -j6025 -fCONVCHRG
#                   would be 101.CONVCHRG.01.6025.001, for the first file that day.
#                   For the 5th file built, it would be 101.CONVCHRG.01.6025.005.
#
#    Arguments   -i, --inst institution id
#                -f, --filetype  file type (e.g., REVERSAL, CONVCHRG, DEBITRAN)
#                -j, --julian_date Julian date for the file.
#                -v, --verbose will output more debugging information
#
################################################################################

#
#
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

#>>> matches = []

#for root, dirnames, filenames in os.walk('~'):
    #for filename in fnmatch.filter(filenames, '107.CLEARING.01.6015*'):
        #matches.append(os.path.join(root, filename))

#matches

#>>> matches
#['107.CLEARING.01.6015.001', '107.CLEARING.01.6015.001-20160115040302',
 #'107.CLEARING.01.6015.002', '107.CLEARING.01.6015.002-20160115070700',
 #'107.CLEARING.01.6015.003', '107.CLEARING.01.6015.003-20160115095130',
 #'107.CLEARING.01.6015.004', '107.CLEARING.01.6015.004-20160115095000',
 #'107.CLEARING.01.6015.005', '107.CLEARING.01.6015.005-20160115112101']

#>>>
#m = re.search("107.CLEARING.01.6015.001",

#>>> for filename in matches:
#...     m = re.search("107.CLEARING.01.6015.002", filename)
#...     if m:
#...             print m.group()
#...
#107.CLEARING.01.6015.002
#107.CLEARING.01.6015.002

def usage(msg=""):
    if msg != "":
        print(msg)
    print( sys.argv[0], ' -i <institution> -f <filetype> -j <julian_date> ')

def main(argv):

    inst = ""
    filetype = ""
    jul_date = ""
    verbose = 0
    try:
        opts, args = getopt.getopt(argv, "hi:f:j:v", ["help", "inst=", "filetype=", "julian_date=", "verbose"])
    except getopt.GetoptError as e:
        usage("Error: {0}".format(e.msg))
        sys.exit(2)

    for opt, arg in opts:
        # print("opt = ", opt, " arg = ", arg)
        if opt in ("-h", "--help"):
            usage()
            sys.exit()
        elif opt in ("-i", "--inst"):
            inst = arg
        elif opt in ("-f", "--filetype"):
            filetype = arg
        elif opt in ("-j", "--julian_date"):
            jul_date = arg
        elif opt in ("-v", "--verbose"):
            verbose = verbose + 1

    if (inst == "" or filetype == "" or jul_date == ""):
        usage("inst, filetype or jul_date is empty")
        sys.exit(2)

    base_filename = str(inst) + "." + filetype + ".01." + str(jul_date)
    if (verbose > 0):
        print("base_filename:", base_filename)

    # home directory
    #   os.path.expanduser('~')
    # environment variables
    #   name = os.environ.get('DATABASE_NAME')

    matches = []

    for curr_dir in (os.getcwd(),
                     os.environ.get('MAS_OSITE_DATA'),
                     os.path.expanduser('~') + '/MAS'):
        for root, dirnames, filenames in os.walk(curr_dir):
            for filename in fnmatch.filter(filenames, base_filename + '*'):
                matches.append(os.path.join(root, filename))

    if (verbose > 0):
        print("length matches:", len(matches))
    seq = 0

    #if len(matches) > 0 :
    found = True
    #else:
    #    found = False

    search_filename = base_filename + "." + '{0:03d}'.format(seq)
    while found and seq < len(matches) + 1:
        seq = seq + 1
        found = False

        search_filename = base_filename + "." + '{0:03d}'.format(seq)
        if (verbose > 0):
            print("    search_filename:", search_filename, "seq:", seq)
        for filename in matches:
            m = re.search(search_filename, filename)
            if m:
                found = True
                break

    print(search_filename)





if __name__ == "__main__":

    main(sys.argv[1:])
