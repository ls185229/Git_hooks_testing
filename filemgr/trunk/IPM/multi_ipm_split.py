#!/usr/bin/python

################################################################################
# $Id: multi_ipm_split.py 4208 2017-06-26 13:50:35Z bjones $
# $Rev: 4208 $
################################################################################

"""Split association MasterCard or Visa report into institution level reports.
"""

################################################################################

from __future__ import print_function
import re
import glob
import ConfigParser
# import argparse

import test_luhn

# def first_line(line):
#     """
#     This determines if the current line is the first one in a section.
#     """
#     return found_in_line(first_line_string, line)

# def identity_line(line):
#     """
#     This determines if the current line is an identifying line in a section.
#     """
#     for identify_string in identify_list:
#         if found_in_line(identify_string, line):
#             return true
#     return false

# def add_to_buffer(line):
#     buffer.append(line)
#     return

# def set_file(identity_string, line):
#     file_name = file_list(identify_string)
#     file_handle = open(file_name, append)
#     return file_handle

# def empty_buffer(output):
#     for item in buffer:
#         writeln(line)
#     buffer = None
#     return



# identify_dict = {   '00000004013' : '101-MCDailyReports' , \
#                     '00000010279' : '107-MCDailyReports' , \
#                     '00000012539' : '117-MCDailyReports' , \
#                     '00000014755' : '121-MCDailyReports' , \
#                     '00000015547' : '127-MCDailyReports' , \
#                     '00000017195' : '122-MCDailyReports' , \
#                     '00000017165' : '130-MCDailyReports' , \
#                     '00000017117' : '129-MCDailyReports' , \
#                     '00000017105' : '134-MCDailyReports'   \
#                 }

#
#
# If you want to remove leading and ending spaces, use str.strip():
#
# sentence = ' hello  apple'
# sentence.strip()
# >>> 'hello  apple'
# If you want to remove all spaces, use str.replace():
#
# sentence = ' hello  apple'
# sentence.replace(" ", "")
# >>> 'helloapple'
# If you want to remove duplicated spaces, use str.split():
#
# sentence = ' hello  apple'
# " ".join(sentence.split())
# >>> 'hello apple'
#

def split_file():
    """Read in configuration file, set configuration dictionary, then
    read the association report file once.
    """
    config = ConfigParser.ConfigParser()
    config.read('sre_list_plain.txt')
    assoc = 'mastercard'


    first_line_str = 'MASTERCARD WORLDWIDE'
    first_line_str = config.get(assoc, 'first_line_str')

    identify_str = '(' + 'MEMBER ID:' + ') *(\d{11})'
    identify_str = config.get(assoc, 'identify_str')

    # filelist = glob.glob('TT140T0.*')
    filemask = config.get(assoc, 'file_mask')
    filelist = glob.glob(filemask)

    output_file = None
    my_buffer = []
    re.I
    curr_outfile_label = ''

    for report_name in filelist:

        print(report_name)
        report_file = open(report_name)

        lines_seen = 0
        for line in report_file:
            #if lines_seen > 200:
                #break
            lines_seen += 1

            match = re.search(first_line_str, line)
            if match:
                # print( match.group(0), " line ", lines_seen )
                if output_file:
                    output_file.close
                output_file = None

            match = re.search(identify_str, line)
            if match:

                if config.has_option(assoc, match.group(2)):
                    outfile_label = config.get(assoc, match.group(2))
                else:
                    outfile_label = '000.' + match.group(2)
                if curr_outfile_label != outfile_label:
                    curr_outfile_label = outfile_label

                    print("match.group(0):", match.group(0),
                          "match.group(1):", match.group(1),
                          "match.group(2):", match.group(2),
                          outfile_label, " line ", lines_seen)

                    # print( match.group(2)[-6:], match.group(2)[-6:] + "."
                    #         + report_name)

                output_file = open(outfile_label + "." + report_name, "a")

            if output_file is None:
                my_buffer.append(test_luhn.mask_card(line))
            else:
                for my_buff_line in my_buffer:
                    print(my_buff_line, file=output_file, end="")
                my_buffer = []
                print(line, file=output_file, end="")

        if output_file:
            output_file.close
        output_file = None

if __name__ == "__main__":
    split_file()
