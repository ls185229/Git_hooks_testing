#!/usr/bin/env bash

################################################################################
# $Id: check_esquire_upload_files.sh 3420 2015-09-11 20:05:17Z bjones $
# $Rev: 3420 $
################################################################################
#
# File Name:  check_esquire_upload_files.sh
#
# Description:  This script initiates a check for successful file uploads to 
#               Esquire Bank.
#              
# Shell Arguments:  None.
#
# Script Arguments:  None.
#
# Output:  Confirmation emails to configured parties.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
################################################################################

IFS=$' \t\n'

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

log_file="LOG/ESQUIRE.FILEUPLOADCHECK.log"

success=0
locpath=$PWD
cd $PWD || success=1
if [ $success -eq 1 ]
then 
    echo `date "+%m/%d/%y %H:%M:%S"` "Could not cd to $PWD.  Exiting." | mailx -r $MAIL_FROM -s "$SYS_BOX Esquire upload files check FAILED." $MAIL_TO 
fi


echo "" | tee -a $log_file
echo `date "+%m/%d/%y %H:%M:%S"` "Beginning check of the upload files for Merrick" | tee -a $log_file
if ./check_merrick_upload_files.tcl 
then
    echo `date "+%m/%d/%y %H:%M:%S"` "Ending check of the upload files for Merrick" | tee -a $log_file
else 
    echo `date "+%m/%d/%y %H:%M:%S"` "Beginning check of the upload files for Merrick FAILED" | tee -a $log_file
    tail -11 $log_file | mailx -r $MAIL_FROM -s "$SYS_BOX Merrick upload files check FAILED.  Location: $loc_path" $MAIL_TO
    exit 1
fi



