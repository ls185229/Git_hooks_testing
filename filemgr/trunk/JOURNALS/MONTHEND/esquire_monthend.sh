#!/usr/bin/ksh

#$Id: esquire_monthend.sh 4760 2018-10-26 20:27:15Z fcaron $

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

locpth=/clearing/filemgr/JOURNALS/MONTHEND

cd $locpth

cmd="esquire_monthend.tcl $1"
logfile="esquire_monthend.log"

print "`date +%Y%m%d%H%M%S` - Beginning $cmd" | tee -a /clearing/filemgr/JOURNALS/MONTHEND/LOG/$logfile
if tclsh $cmd | tee -a /clearing/filemgr/JOURNALS/MONTHEND/LOG/$logfile; then
    echo "`date +%Y%m%d%H%M%S` - $cmd successful\n" | tee -a /clearing/filemgr/JOURNALS/MONTHEND/LOG/$logfile
else
    echo "`date +%Y%m%d%H%M%S` - $cmd run FAILED" | tee -a /clearing/filemgr/JOURNALS/MONTHEND/LOG/$logfile
    tail -20 /clearing/filemgr/JOURNALS/MONTHEND/LOG/$logfile | mutt -s "$SYS_BOX $cmd report run failed. Location: $locpth" "clearing@jetpay.com"
    #tail -20 /clearing/filemgr/JOURNALS/MONTHEND/LOG/$logfile | mutt -s "$SYS_BOX $cmd report run failed. Location: $locpth" "fcaron@jetpay.com"
fi



