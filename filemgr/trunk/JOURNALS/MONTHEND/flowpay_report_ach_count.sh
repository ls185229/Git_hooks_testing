#!/usr/bin/ksh
. /clearing/filemgr/.profile

# $Id: flowpay_report_ach_count.sh 2491 2014-01-06 21:13:30Z mitra $

############################
# Flowpay ACH Count Report
# This scripts can run with or without a date. If no date provided it will use start and end of the last month.
# With one date argument, the script will calculatethe month start and end based on the given date.
############################

CRON_JOB=1
export CRON_JOB

err_mailto="clearing@jetpay.com"

locpth=$PWD
logfile=$locpth/LOG/reports.log

print "\n************************************" >> $logfile
print " Generating FlowPay Report on `date +%Y/%m/%d@%H:%M:%S`" >> $logfile

if [ $# == 0 ]; then
     tclsh flowpay_report_ach_count.tcl >> $logfile 
else
     tclsh flowpay_report_ach_count.tcl -d $1 >> $logfile 
fi


if [ $? -eq 0 ]; then
   echo " FlowPay ACH Count Report ran successfuly on `date +%Y/%m/%d@%H:%M:%S`" >> $logfile
   echo "*************************************" >> $logfile
else
   echo " FlowPay ACH Count Report run FAILED on `date +%Y/%m/%d@%H:%M:%S`" >> $logfile
   echo "*************************************" >> $logfile
   tail -20 $logfile | mutt -s "FlowPay ACH Count script failed" -- "$err_mailto"
fi



