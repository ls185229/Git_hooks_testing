#!/usr/bin/bash

##############################################
# Visa Fees Collected Month End Report
# Inst Id parameter passed - start & end date
# are calculated in the script
##############################################

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

locpth=/clearing/filemgr/JOURNALS/MONTHEND

cd $locpth

cmd="visa_fees_collect_monthend_sbj.tcl $1"

echo "`date +%Y%m%d%H%M%S` - Beginning $cmd" >> /clearing/filemgr/JOURNALS/MONTHEND/LOG/visa_fees_collected_monthend.log

if tclsh $cmd >> /clearing/filemgr/JOURNALS/MONTHEND/LOG/visa_fees_collected_monthend_sbj.log; then
    echo "`date +%Y%m%d%H%M%S` - $cmd successful\n" >> /clearing/filemgr/JOURNALS/MONTHEND/LOG/visa_fees_collected_monthend_sbj.log
else
    echo "`date +%Y%m%d%H%M%S` - $cmd run FAILED" >> /clearing/filemgr/JOURNALS/MONTHEND/LOG/visa_fees_collected_monthend_sbj.log
    #tail -20 /clearing/filemgr/JOURNALS/MONTHEND/LOG/visa_fees_collected_monthend_sbj.log | mutt -s "$SYS_BOX $cmd report run failed. Location: $locpth" "clearing@jetpay.com"
    tail -20 /clearing/filemgr/JOURNALS/MONTHEND/LOG/visa_fees_collected_monthend_sbj.log | mutt -s "$SYS_BOX $cmd report run failed. Location: $locpth" "bjones@internal.jetpay.com"
fi
