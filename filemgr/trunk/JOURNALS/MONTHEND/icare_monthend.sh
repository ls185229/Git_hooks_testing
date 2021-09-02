#!/usr/bin/bash

###########################################
# iCare Month End Report
# No parameters passed - start & end date 
# are calculated in the script
###########################################

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

locpth=/clearing/filemgr/JOURNALS/MONTHEND

cd $locpth

cmd="icare_monthend.tcl" 

echo "`date +%Y%m%d%H%M%S` - Beginning $cmd" | tee -a /clearing/filemgr/JOURNALS/MONTHEND/LOG/icare_monthend.log

if tclsh $cmd | tee -a /clearing/filemgr/JOURNALS/MONTHEND/LOG/icare_monthend.log; then
    echo "`date +%Y%m%d%H%M%S` - $cmd successful\n" | tee -a /clearing/filemgr/JOURNALS/MONTHEND/LOG/icare_monthend.log
else
    echo "`date +%Y%m%d%H%M%S` - $cmd run FAILED" | tee -a /clearing/filemgr/JOURNALS/MONTHEND/LOG/icare_monthend.log
    #tail -20 /clearing/filemgr/JOURNALS/MONTHEND/LOG/icare.log | mutt -s "$SYS_BOX $cmd report run failed. Location: $locpth" "clearing@jetpay.com"
    tail -20 /clearing/filemgr/JOURNALS/MONTHEND/LOG/icare.log | mutt -s "$SYS_BOX $cmd report run failed. Location: $locpth" "fcaron@jetpay.com"
fi
