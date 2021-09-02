#!/usr/bin/ksh


CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile


export ORACLE_SID=$IST_DB
export TWO_TASK=$IST_DB

locpth="/clearing/filemgr/"

cd $locpth

print "RESET TASKS BEGIN `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/resettask.log


./reset_task.tcl ALL | tee -a $locpth/LOG/resettask.log


print "<> END OF ALL TASK FOR <> `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/resettask.log
