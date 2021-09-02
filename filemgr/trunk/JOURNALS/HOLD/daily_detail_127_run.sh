#!/usr/bin/ksh
. /clearing/filemgr/.profile

################################################################################
# $Id: daily_detail_127_run.sh 2712 2014-10-16 20:16:43Z mitra $
# $Rev: 2712 $
################################################################################

CRON_JOB=1
export CRON_JOB

locpth=$PWD
logfile=$locpth/LOG/reports.log
mail_err="clearing@jetpay.com"

print "\nBeginning 127 DAILY DETAIL RUN at `date +%Y%m%d%H%M%S`" | tee -a $logfile

if 127-daily-detail.tcl >> $logfile; then
   echo "127-daily-detail.tcl successful" | tee -a $logfile
else
   print "127-daily-detail.tcl report run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $logfile
   tail -40 $logfile | mutt -s "127-daily-detail.tcl report run failed." $mail_err
fi

print "Ending 127 DAILY Detail RUN at `date +%Y%m%d%H%M%S`" | tee -a $logfile

