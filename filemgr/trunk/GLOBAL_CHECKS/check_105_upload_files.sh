#!/usr/bin/env bash

# reset input separate to just space, tab, newline
IFS=$' \t\n'

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

log_file="LOG/105.FILEUPLOADCHECK.log"

success=0
locpath=$PWD
cd $PWD || success=1
if [ $success -eq 1 ]
then 
    echo `date "+%m/%d/%y %H:%M:%S"` "Could not cd to $PWD.  Exiting." | mailx -r $MAIL_FROM -s "$SYS_BOX 105 upload files check FAILED." $MAIL_TO 
fi


echo "" | tee -a $log_file
echo `date "+%m/%d/%y %H:%M:%S"` "Beginning check of the upload files for 105" | tee -a $log_file
if ./check_105_upload_files.tcl 
then
    echo `date "+%m/%d/%y %H:%M:%S"` "Ending check of the upload files for 105" | tee -a $log_file
else 
    echo `date "+%m/%d/%y %H:%M:%S"` "Beginning check of the upload files for 105 FAILED" | tee -a $log_file
    tail -11 $log_file | mailx -r $MAIL_FROM -s "$SYS_BOX 105 upload files check FAILED.  Location: $loc_path" $MAIL_TO
    exit 1
fi



