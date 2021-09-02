#!/usr/bin/bash

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

locpth=/clearing/filemgr/JOURNALS/OK_DMV

cd $locpth

echo "Beginning OKDMV report at `date +%Y%m%d-%H:%M:%S`"

script_output=`okdmv_funding_report.tcl $1` script_exit_status=$?

if [ $script_exit_status ]; then
   echo "okdmv_funding_report.tcl $1 successful" | tee -a $locpth/okdmv_funding_report.tcl.log
else
   echo "okdmv_funding_report.tcl $1 failed contact oncall engineer" | mailx -r clearing@jetpay.com -s "Priority : High - Clearing and Settlement - $SYS_BOX Script okdmv_funding_report.tcl Failed" assist@jetpay.com clearing@jetpay.com
   echo "okdmv_funding_report.tcl $1 failed " | tee -a $locpth/okdmv_funding_report.tcl.log
fi
