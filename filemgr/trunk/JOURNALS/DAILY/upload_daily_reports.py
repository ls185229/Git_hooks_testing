#!/usr/bin/env python

################################################################################
# $Id: upload_daily_reports.py 4427 2017-11-14 19:26:30Z fcaron $
# $Rev: 4427 $
# Upload miscellaneous reports to the sftp server for select clients.
################################################################################

import ConfigParser
import os
import datetime
import glob
from subprocess import call

#
# open and read configuration file
#
config = ConfigParser.ConfigParser()
config.read("upload_daily_reports.cfg")

now = datetime.datetime.now()

rpt_date = now.strftime("%Y%m%d")
start_time = now.strftime("%m-%d-%Y %H:%M")

print('=======================================================================================')
print("Upload Daily Reports started at " + start_time + "\n")

for section in config.sections():
    try:
        #
        # set variables from configuratin file
        #
        ftp_dest = config.get(section, 'ftp_dest')
        ftp_src = config.get(section, 'ftp_src') + rpt_date + '*.*'
        upload_cmd = config.get(section, 'upload_cmd')
        if config.has_option(section, 'upload_cmd2'):
            upload_cmd2 = config.get(section, 'upload_cmd2')
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
        print(' ')
    except Exception as e:
        print("An exception was thrown!")
        print(str(e))
        exit(1)

now = datetime.datetime.now()

end_time = now.strftime("%m-%d-%Y %H:%M")
print("Upload Daily Reports ended at " + end_time + "\n")
exit(0)
