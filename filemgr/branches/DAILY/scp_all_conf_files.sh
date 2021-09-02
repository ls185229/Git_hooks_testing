#!/usr/bin/bash

################################################################################
# $Id: scp_all_conf_files.sh 4054 2017-02-06 23:16:14Z millig $
# $Rev: 4054 $
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

echo "`date +%Y%m%d%H%M%S` - Beginning $cmd" | tee /clearing/filemgr/JOURNALS/DAILY/LOG/scp_all_conf_files.log

if tclsh $cmd | tee /clearing/filemgr/JOURNALS/DAILY/LOG/scp_all_conf_files.log; then
    echo "`date +%Y%m%d%H%M%S` - $cmd successful\n" | tee /clearing/filemgr/JOURNALS/DAILY/LOG/scp_all_conf_files.log
else
    echo "`date +%Y%m%d%H%M%S` - $cmd run FAILED" | tee /clearing/filemgr/JOURNALS/DAILY/LOG/scp_all_conf_files.log
    tail -20 /clearing/filemgr/JOURNALS/DAILY/LOG/scp_all_conf_files.log | mutt -s "$SYS_BOX $cmd report run failed. Location: $locpth" "clearing@jetpay.com"
fi
