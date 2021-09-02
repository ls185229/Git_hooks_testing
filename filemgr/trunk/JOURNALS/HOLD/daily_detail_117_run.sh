#!/usr/bin/ksh
. /clearing/filemgr/.profile

################################################################################
# $Id: daily_detail_117_run.sh 2492 2014-01-07 19:04:45Z mitra $
# $Rev: 2492 $
################################################################################

CRON_JOB=1
export CRON_JOB

#export ORACLE_SID=$ATH_DB
#export TWO_TASK=$ATH_DB
#echo $ORACLE_HOME
#echo $TWO_TASK


locpth=/clearing/filemgr/JOURNALS/

cd $locpth

print "Beginning 117 DAILY DETAIL RUN at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log


if ./117-daily-detail.tcl >> $locpth/LOG/reports.log; then
   echo "117-daily-detail.tcl successful\n" | tee -a $locpth/LOG/reports.log
else
   print "117-daily-detail.tcl report run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
   tail -40 $locpth/LOG/reports.log  | mutt -s "$SYS_BOX 117-daily-detail.tcl report run failed. Location: $locpth" $MAIL_TO
fi

print "Ending 117 DAILY Detail RUN at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log

