#!/usr/bin/ksh

#$Id: esquire_monthend.sh 4213 2017-06-26 14:36:17Z bjones $

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

locpth=/clearing/filemgr/JOURNALS/MONTHEND

cd $locpth

cmd="esquire_monthend.tcl" $1

print "`date +%Y%m%d%H%M%S` - Beginning $cmd" | tee -a /clearing/filemgr/JOURNALS/MONTHEND/LOG/esquire_monthend.log

if tclsh $cmd | tee -a /clearing/filemgr/JOURNALS/MONTHEND/LOG/esquire_monthend.log; then
    echo "`date +%Y%m%d%H%M%S` - $cmd successful\n" | tee -a /clearing/filemgr/JOURNALS/MONTHEND/LOG/esquire_monthend.log
else
    print "`date +%Y%m%d%H%M%S` - $cmd run FAILED" | tee -a /clearing/filemgr/JOURNALS/MONTHEND/LOG/esquire_monthend.log
    #tail -20 /clearing/filemgr/JOURNALS/MONTHEND/LOG/esquire_monthend.log | mutt -s "$SYS_BOX $cmd report run failed. Location: $locpth" "clearing@jetpay.com"
    tail -20 /clearing/filemgr/JOURNALS/MONTHEND/LOG/esquire_monthend.log | mutt -s "$SYS_BOX $cmd report run failed. Location: $locpth" "fcaron@jetpay.com"
fi



