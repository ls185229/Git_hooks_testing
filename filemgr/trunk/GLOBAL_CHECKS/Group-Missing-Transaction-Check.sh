#!/usr/bin/bash

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

locpth=/clearing/filemgr/GLOBAL_CHECKS

cd $locpth

print "Beginning Transaction check at `date +%Y%m%d-%H:%M:%S`"

export ORACLE_SID=$ATH_DB
export TWO_TASK=$ATH_DB
echo $ORACLE_HOME
echo $TWO_TASK

script_output=`Check-For-Missed-Transactions.tcl` script_exit_status=$?

if Cutoff-Batch-Check.tcl >>  $locpth/Check-For-Missed-Transactions.tcl.log ; then
   echo "Cutoff-Batch-Check.tcl successful" >> $locpth/Check-For-Missed-Transactions.tcl.log
else
   echo "Cutoff-Batch-Check.tcl failed " | mailx -r clearing@jetpay.com -s "$SYS_BOX Script Check-For-Missed-Transactions.tcl Failed" clearing@jetpay.com
fi
