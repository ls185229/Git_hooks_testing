#!/usr/bin/ksh
. /clearing/filemgr/.profile

################################################################################
# $Id: okdmv_fee_report_monthend.sh 2531 2014-01-28 21:23:32Z msanders $
# $Rev: 2531 $
################################################################################
#
# This script is used for running the fee report for OKDMV instittuion 107
#
# Arg1 = date (YYYYMMDD) optional
#        Default today's date
#        Example of running the report for other dates: 
#                okdmv_fee_report_monthend.tcl 20131231
# 
################################################################################

CRON_JOB=1
export CRON_JOB

locpth=$PWD
cd $locpth

logfile="$locpth/LOG/okdmv_fee_report.log"

email_err="clearing@jetpay.com"

script_name="okdmv_fee_report_monthend.tcl" 

print "Beginning OKDMV Fee Report at" `date "+%m/%d/%y %H:%M:%S"` " from $locpth"

if $script_name >> $logfile; then
        print "\nOKDMV Monthly Fee Report ran successfully." | tee -a $logfile
else
        echo "Please see log file: $logfile" | mutt -s "OKDMV Monthly Fee Report Failed" -- $email_err
        print "\nScript $script_name failed." | tee -a $logfile
fi

print "Ending OKDMV Fee Report at" `date "+%m/%d/%y %H:%M:%S"`

