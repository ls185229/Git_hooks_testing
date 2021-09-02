#!/usr/bin/bash

################################################################################
# $Id: scp_all_conf_files.sh 4127 2017-04-04 14:44:19Z skumar $
# $Rev: 4127 $
################################################################################
# scp_all_conf_files.sh
# parameters passed - Institution ID 
###########################################

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

locpth=/clearing/filemgr/JOURNALS/DAILY/

cd $locpth

cmd="scp_all_conf_files.tcl $1"

echo "`date +%Y%m%d%H%M%S` - Beginning $cmd" | tee -a /clearing/filemgr/JOURNALS/DAILY/LOG/scp_all_conf_files.log

if tclsh $cmd | tee /clearing/filemgr/JOURNALS/DAILY/LOG/scp_all_conf_files.log; then
    echo "`date +%Y%m%d%H%M%S` - $cmd successful\n" | tee -a /clearing/filemgr/JOURNALS/DAILY/LOG/scp_all_conf_files.log
else
    echo "`date +%Y%m%d%H%M%S` - $cmd run FAILED" | tee -a /clearing/filemgr/JOURNALS/DAILY/LOG/scp_all_conf_files.log
    tail -20 /clearing/filemgr/JOURNALS/DAILY/LOG/scp_all_conf_files.log | mutt -s "$SYS_BOX $cmd report run failed. Location: $locpth" "clearing@jetpay.com"
fi
