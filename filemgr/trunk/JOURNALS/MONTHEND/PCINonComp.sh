#!/usr/bin/bash

################################################################################
# $Id: PCINonComp.sh 4157 2017-04-20 16:39:52Z fcaron $
# $Rev: 4157 $
################################################################################
# PCINonComp.sh
# parameters passed - None or optional date for the report
################################################################################

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

locpth=/clearing/filemgr/JOURNALS/MONTHEND/

cd $locpth

cmd="PCINonComp.tcl $1"

echo "`date +%Y%m%d%H%M%S` - Beginning $cmd" | tee /clearing/filemgr/JOURNALS/MONTHEND/LOG/PCINonComp.log

if tclsh $cmd | tee /clearing/filemgr/JOURNALS/MONTHEND/LOG/PCINonComp.log; then
    echo "`date +%Y%m%d%H%M%S` - $cmd successful\n" | tee /clearing/filemgr/JOURNALS/MONTHEND/LOG/PCINonComp.log
else
    echo "`date +%Y%m%d%H%M%S` - $cmd run FAILED" | tee /clearing/filemgr/JOURNALS/MONTHEND/LOG/PCINonComp.log
    tail -20 /clearing/filemgr/JOURNALS/MONTHEND/LOG/PCINonComp.log | mutt -s "$SYS_BOX $cmd report run failed. Location: $locpth" "clearing@jetpay.com"
fi
