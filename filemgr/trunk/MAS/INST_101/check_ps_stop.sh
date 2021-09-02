#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

locpth="/clearing/filemgr/MAS/INST_101"

cd $locpth

print "Beginning  MAS FILE for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/cj_log.txt

$locpth/check_ps_stop.tcl >> $locpth/LOG/cj_log.txt

print "Ending MAS FILE for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/cj_log.txt

