#!/usr/bin/bash

###########################################
# convenience merchants residuals file
# No parameters passed - start & end date 
# are calculated in the script
###########################################

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

locpth=/clearing/filemgr/JOURNALS/MONTHEND

cd $locpth

cmd="create_conv_residuals.tcl $1" 

echo "`date +%Y%m%d%H%M%S` - Beginning $cmd" | tee -a /clearing/filemgr/JOURNALS/MONTHEND/LOG/create_conv_residuals.log

if tclsh $cmd | tee -a /clearing/filemgr/JOURNALS/MONTHEND/LOG/create_conv_residuals.log; then
    echo "`date +%Y%m%d%H%M%S` - $cmd successful\n" | tee -a /clearing/filemgr/JOURNALS/MONTHEND/LOG/create_conv_residuals.log
else
    echo "`date +%Y%m%d%H%M%S` - $cmd run FAILED" | tee -a /clearing/filemgr/JOURNALS/MONTHEND/LOG/create_conv_residuals.log
    tail -20 /clearing/filemgr/JOURNALS/MONTHEND/LOG/create_conv_residuals.log | mutt -s "$SYS_BOX $cmd report run failed. Location: $locpth" "clearing@jetpay.com"
    
fi
