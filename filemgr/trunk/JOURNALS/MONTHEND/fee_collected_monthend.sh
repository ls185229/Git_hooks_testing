#!/usr/bin/bash

###########################################
# Fees Collected Month End Report
# No parameters passed - start & end date 
# are calculated in the script
###########################################

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

locpth=/clearing/filemgr/JOURNALS/MONTHEND

cd $locpth

cmd="fee_collected_monthend.tcl $1"

echo "`date +%Y%m%d%H%M%S` - Beginning $cmd" | tee -a /clearing/filemgr/JOURNALS/MONTHEND/LOG/fee_collected_monthend.log

if tclsh $cmd | tee -a /clearing/filemgr/JOURNALS/MONTHEND/LOG/fee_collected__monthend.log; then
    echo "`date +%Y%m%d%H%M%S` - $cmd successful\n" | tee -a /clearing/filemgr/JOURNALS/MONTHEND/LOG/fee_collected_monthend.log
else
    echo "`date +%Y%m%d%H%M%S` - $cmd run FAILED" | tee -a /clearing/filemgr/JOURNALS/MONTHEND/LOG/fee_collected_monthend.log
    #tail -20 /clearing/filemgr/JOURNALS/MONTHEND/LOG/fee_collected_monthend.log | mutt -s "$SYS_BOX $cmd report run failed. Location: $locpth" "clearing@jetpay.com"
    tail -20 /clearing/filemgr/JOURNALS/MONTHEND/LOG/fee_collected_monthend.log | mutt -s "$SYS_BOX $cmd report run failed. Location: $locpth" "fcaron@jetpay.com"
fi
