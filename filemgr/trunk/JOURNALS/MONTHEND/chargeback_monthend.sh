#!/usr/bin/bash
#
# parameters are report type and inst_id
#
CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

locpth=/clearing/filemgr/JOURNALS/MONTHEND

cd $locpth

cmd="chargeback_monthend.tcl $1 $2"

echo "`date +%Y%m%d%H%M%S` - Beginning $cmd" >> /clearing/filemgr/JOURNALS/MONTHEND/LOG/chargeback_monthend.log

if tclsh $cmd >> /clearing/filemgr/JOURNALS/MONTHEND/LOG/chargeback_monthend.log; then
    echo "`date +%Y%m%d%H%M%S` - $cmd successful\n" >> /clearing/filemgr/JOURNALS/MONTHEND/LOG/chargeback_monthend.log
else
    echo "`date +%Y%m%d%H%M%S` - $cmd run FAILED" >> /clearing/filemgr/JOURNALS/MONTHEND/LOG/chargeback_monthend.log
    #tail -20 /clearing/filemgr/JOURNALS/MONTHEND/LOG/chargeback_monthend.log | mutt -s "$SYS_BOX $cmd report run failed. Location: $locpth" "clearing@jetpay.com"
    tail -20 /clearing/filemgr/JOURNALS/MONTHEND/LOG/chargeback_monthend.log | mutt -s "$SYS_BOX $cmd report run failed. Location: $locpth" "fcaron@jetpay.com"
fi
