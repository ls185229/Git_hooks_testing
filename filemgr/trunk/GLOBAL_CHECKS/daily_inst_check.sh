#!/usr/bin/bash

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

locpth=/clearing/filemgr/GLOBAL_CHECKS/

cd $locpth

echo "Beginning Insitution check at `date +%Y%m%d-%H:%M:%S`"

     if daily_inst_check.tcl; then
       echo "daily_inst_check.tcl Succesful"
     else
       echo "daily_inst_check.tcl Failed." | mailx -r clearing@jetpay.com -s "$SYS_BOX Script weekly_inst_check.tcl Failed" clearing@jetpay.com
     fi
