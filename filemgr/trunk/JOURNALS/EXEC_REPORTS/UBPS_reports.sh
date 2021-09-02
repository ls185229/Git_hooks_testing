#!/usr/bin/bash

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

locpth=/clearing/filemgr/JOURNALS/EXEC_REPORTS

cd $locpth

echo "Beginning UBPS reports at `date +%Y%m%d-%H:%M:%S`"

script_output=`UBPS_auth_report.tcl` script_exit_status=$?

if [ $script_exit_status ]; then
   echo "UBPS_auth_report.tcl successful" | tee -a $locpth/UBPS_auth_report.tcl.log
else
   #echo "UBPS_auth_report.tcl failed contact oncall engineer" | mailx -r clearing@jetpay.com -s "Priority : High - Clearing and Settlement - $SYS_BOX Script UBPS_auth_report.tcl Failed" assist@jetpay.com clearing@jetpay.com
   echo "UBPS_auth_report.tcl failed contact oncall engineer" | mailx -r clearing@jetpay.com -s "Priority : High - Clearing and Settlement - $SYS_BOX Script UBPS_auth_report.tcl Failed" dwright@jetpay.com
   echo "UBPS_auth_report.tcl failed " | tee -a $locpth/UBPS_auth_report.tcl.log
fi

script_output=`UBPS_clearing_report.tcl` script_exit_status=$?

if [ $script_exit_status ]; then
   echo "UBPS_clearing_report.tcl successful" | tee -a $locpth/UBPS_clearing_report.tcl.log
else
   #echo "UBPS_clearing_report.tcl failed contact oncall engineer" | mailx -r clearing@jetpay.com -s "Priority : High - Clearing and Settlement - $SYS_BOX Script "UBPS_clearing_report.tcl Failed" assist@jetpay.com clearing@jetpay.com
   echo "UBPS_clearing_report.tcl failed contact oncall engineer" | mailx -r clearing@jetpay.com -s "Priority : High - Clearing and Settlement - $SYS_BOX Script "UBPS_clearing_report.tcl Failed" dwright@jetpay.com
   echo "UBPS_clearing_report.tcl failed " | tee -a $locpth/"UBPS_clearing_report.tcl.log
fi

echo "Ending UBPS reports at `date +%Y%m%d-%H:%M:%S`"

