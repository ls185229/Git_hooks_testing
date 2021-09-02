#!/usr/bin/bash

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

locpth=/clearing/filemgr/RETURN_FILES

cd $locpth

echo "Beginning chargeback_fix at `date +%Y%m%d-%H:%M:%S`"

script_output=`chargeback_fix.tcl` script_exit_status=$?

if [ $script_exit_status ]; then
   echo "chargeback_fix.tcl successful" | tee -a $locpth/chargeback_fix.tcl.log
else
   echo "chargeback_fix.tcl failed contact oncall engineer" | mailx -r clearing@jetpay.com -s "Priority : High - Clearing and Settlement - $SYS_BOX Script chargeback_fix.tcl Failed" assist@jetpay.com clearing@jetpay.com
   echo "chargeback_fix.tcl failed " | tee -a $locpth/chargeback_fix.tcl.log
fi
