#!/usr/bin/python

################################################################################
# $Id: multi_visa_split.py 4690 2018-09-06 18:47:08Z fcaron $
# $Rev: 4690 $
################################################################################

"""Split association Visa EP747 report into institution level reports.
"""

################################################################################

from __future__ import print_function
import re
import glob
import ConfigParser
import time
from datetime import datetime
import sys
import os
import zipfile

def split_file():
    if len(sys.argv) == 1: 
        today = datetime.today()
        str_filedate = today.strftime('%Y%m%d')
    else:
        try:
            str_filedate = str(sys.argv[1])
            
            if str_filedate != datetime.strptime(str_filedate, "%Y%m%d").strftime('%Y%m%d'):
                raise ValueError
        except ValueError:
            print(str_filedate)
            print("Incorrect data format, it should be YYYYMMDD")
            sys.exit()
    
    """Read in configuration file, set configuration dictionary, then
    read the association report file once.
    """
    config = ConfigParser.ConfigParser()
    config.read('sre_list_plain.txt')
    assoc = 'visa'

    first_line_str = 'VISANET SETTLEMENT SERVICE'
    first_line_str = config.get(assoc, 'first_line_str')

    identify_str = '(' + 'REPORTING FOR:' + ') *(\d{10})'
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
            lines_seen += 1

            match = re.search(first_line_str, line)
            if match:
                if output_file:
                    output_file.close
                output_file = None

            match = re.search(identify_str, line)
            if match:

                if config.has_option(assoc, match.group(2)):
                    outfile_label = config.get(assoc, match.group(2))
                else:
                    outfile_label = "VSDailyReports-000-" + match.group(2)

                    print("match.group(0):", match.group(0),
                          "match.group(1):", match.group(1),
                          "match.group(2):", match.group(2),
                          outfile_label, " line ", lines_seen)

                output_file = open(outfile_label+ "-" + str_filedate + ".epd", "a")

            if output_file is None:
                #my_buffer.append(test_luhn.mask_card(line))
                my_buffer.append(line)
            else:
                for my_buff_line in my_buffer:
                    print(my_buff_line, file=output_file, end="")
                my_buffer = []
                print(line, file=output_file, end="")

        if output_file:
            output_file.close
        output_file = None

    outfilename = 'VSDailyReports-000-' + str_filedate + ".epd"
    filenames = glob.glob('VSDailyReports-000-*.epd')
    with open(outfilename, 'w') as outfile:
        for fname in filenames:
            with open(fname, 'r') as readfile:
                infile = readfile.read()
                for line in infile:
                    outfile.write(line)
                outfile.write("\n\n")
            os.remove(fname)
            
def zip_files():
    #folder = 'C:\\Users\\fcaron\\Documents\\Development\\clearing\\filemgr_mas_dfw-prd-mas-01\\trunk\BASE2'
    folder = os.getcwd() 
    print("current directory is : " + folder)
    for file_path in glob.glob(folder+'/*.epd'):

        filename = os.path.basename(file_path)
        print(filename)

        name_without_extension = filename[:-4]    # .epd conains 4 characters

        epd_path = os.path.join(folder, filename)
        zip_path =  os.path.join(folder, name_without_extension + '.zip')

        zip_file = zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED)

        #
        # use `filename` without the folder name and it will not create folders inside archive
        #
        zip_file.write(epd_path, filename)
        zip_file.close()
 
    print('All files zipped successfully!')   
            

if __name__ == "__main__":
    split_file()
    zip_files()
    
    #folder = 'C:\\Users\\fcaron\\Documents\\Development\\clearing\\filemgr_mas_dfw-prd-mas-01\\trunk\BASE2'

    #for file_path in glob.glob(folder+'\\*.epd'):

    #    filename = os.path.basename(file_path)
    #    print(filename)

    #    name_without_extension = filename[:-4]

    #    epd_path = os.path.join(folder, filename)
    #    zip_path =  os.path.join(folder, name_without_extension + '.zip')

    #    zip_file = zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED)

    #    #
    #    # use `filename` (without folder name) as name inside archive
    #    # and it will not create folders inside archive
    #    #
    #    zip_file.write(epd_path, filename)
    #    zip_file.close()
 
    #print('All files zipped successfully!')   
        
