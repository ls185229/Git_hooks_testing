#!/usr/bin/env python

"""
 $Id: upload_monthend_ippay.py 4723 2018-10-02 18:06:42Z fcaron $
 $Rev: 4723 $
 Upload miscellaneous reports to the sftp server for select clients.
 IsoBilling.YYYYMM*
 IPP*YYYY_MM*
"""

import ConfigParser
import os
import datetime
import glob
import sys
from subprocess import call

#
# open and read configuration file
#
config = ConfigParser.ConfigParser()
config.read("upload_monthend_ippay.cfg")

now = datetime.datetime.now()

today = datetime.date.today()
first = today.replace(day=1)
lastMonth = first - datetime.timedelta(days=1)

start_time = now.strftime("%m-%d-%Y %H:%M")

print('=======================================================================================')
print("Upload Monthend Reports started at " + start_time + "\n")

for section in config.sections():
    try:
        #
        # set variables from configuratin file
        #
        ftp_dest = config.get(section, 'ftp_dest')
        print(ftp_dest)
        rpt_date = config.get(section, 'dte_fmt')
        rpt_date_str = lastMonth.strftime(rpt_date)
        print(rpt_date_str)
       
        ftp_src = config.get(section, 'ftp_src') + rpt_date_str + '*.*'
        upload_cmd = config.get(section, 'upload_cmd')
        filelist = glob.glob(ftp_src)
        #
        # if report is found run the scp command(s)
        #
        if filelist:
            for ele in filelist:
                if os.path.exists(ele):
                    upload_line = upload_cmd.split(",")
                    print(os.path.basename(ele) + " uploaded to " + upload_line[1])
                    call([upload_line[0], ele, upload_line[1]])
                    if config.has_option(section, 'upload_cmd2'):
                        upload_cmd2 = config.get(section, 'upload_cmd2')
                        upload_line = upload_cmd2.split(",")
                        call([upload_line[0], ele, upload_line[1]])
                        print(os.path.basename(ele) + " uploaded to " + upload_line[1])
        else:
            print('Report ' + ftp_src + ' not found today!')
            exit(1)
    except IOError as err:
        print("An exception was thrown!")
        print(str(err))
        exit(1)

now = datetime.datetime.now()

end_time = now.strftime("%m-%d-%Y %H:%M")
print("Upload Monthend Reports ended at " + end_time + "\n")
sys.exit(0)
