#!/usr/bin/bash

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

locpth=/clearing/filemgr/REJECTS

inst_id=$1

cd $locpth

echo "Beginning Transaction check at `date +%Y%m%d-%H:%M:%S`"

export ORACLE_SID=$ATH_DB
export TWO_TASK=$ATH_DB
echo $ORACLE_HOME
echo $TWO_TASK

script_output=`reject-email-loader.tcl` script_exit_status=$?

if [ $script_exit_status ]; then
   echo "Reject-Email-Loader.tcl successful" | tee -a $locpth/Reject-Email-Loader.tcl.log
else
   echo "Reject-Email-Loader.tcl failed contact oncall engineer" | mailx -r clearing@jetpay.com -s "$SYS_BOX Script Check-For-Missed-Transactions.tcl Failed" assist@jetpay.com clearing@jetpay.com
   echo "Reject-Email-Loader.tcl failed " | tee -a $locpth/Reject-Email-Loader.tcl.log
fi
