#!/usr/bin/bash

###########################################
# auth_settle_counts_monthend.sh
# No parameters passed - start & end date
# are calculated in the script
###########################################

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

locpth=/clearing/filemgr/JOURNALS/DAILY/

cd $locpth

cmd="scp_conf_files.tcl $1"

echo "`date +%Y%m%d%H%M%S` - Beginning $cmd" >> /clearing/filemgr/JOURNALS/DAILY/LOG/scp_conf_files.log

if tclsh $cmd >> /clearing/filemgr/JOURNALS/DAILY/LOG/scp_conf_files.log; then
    echo "`date +%Y%m%d%H%M%S` - $cmd successful\n" >> /clearing/filemgr/JOURNALS/DAILY/LOG/scp_conf_files.log
else
    echo "`date +%Y%m%d%H%M%S` - $cmd run FAILED" >> /clearing/filemgr/JOURNALS/DAILY/LOG/scp_conf_files.log
    tail -20 /clearing/filemgr/JOURNALS/MONTHEND/LOG/fee_collected_monthend.log | mutt -s "$SYS_BOX $cmd report run failed. Location: $locpth" "clearing@jetpay.com"
fi
