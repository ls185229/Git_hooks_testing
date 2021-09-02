#!/usr/bin/ksh


CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

export ORACLE_SID=$ATH_DB
export TWO_TASK=$ATH_DB
echo $ORACLE_HOME
echo $TWO_TASK


locpth=/clearing/filemgr/JOURNALS/

cd $locpth

print "Beginning 106 DAILY DETAIL RUN at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log


if 106_daily-detail.tcl >> $locpth/LOG/reports.log; then
   echo "106_daily-detail.tcl successful\n" | tee -a $locpth/LOG/reports.log
else
   print "106_daily-detail.tcl report run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
   tail -40 $locpth/LOG/reports.log  | mailx -r $MAIL_FROM -s "$SYS_BOX 106_daily-detail.tcl report run failed. Location: $locpth" $MAIL_TO
fi

print "Ending 106 DAILY Detail RUN at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log

locpth=/clearing/filemgr/JOURNALS/INST_106/

cd $locpth

print "Beginning 106 DELAY REPORT RUN at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log

if delay-statement-106.tcl >> $locpth/LOG/reports.log; then
   echo "delay-statement-106.tcl successful\n" | tee -a $locpth/LOG/reports.log
else
   print "delay-statement-106.tcl run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
   tail -40 $locpth/LOG/reports.log  | mailx -r $MAIL_FROM -s "$SYS_BOX delay-statement-106.tcl run failed. Location: $locpth" $MAIL_TO
fi
print "Ending 106 DELAY REPORT RUN at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
