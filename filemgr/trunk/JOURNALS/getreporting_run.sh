#!/usr/bin/ksh


CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

export ORACLE_SID=$ATH_DB
export TWO_TASK=$ATH_DB
echo $ORACLE_HOME
echo $TWO_TASK


locpth=/clearing/filemgr/JOURNALS/INST_106/

cd $locpth

print "Beginning 106 GetReporting RUN at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log

if getReport-data-106.tcl >> $locpth/LOG/reports.log; then
   echo "getReport-data-106.tcl successful\n" | tee -a $locpth/LOG/reports.log
else
   print "getReport-data-106.tcl run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
   tail -40 $locpth/LOG/reports.log  | mailx -r $MAIL_FROM -s "$SYS_BOX getReport-data-106.tcl run failed. Location: $locpth" $MAIL_TO
fi
print "Ending 106 GetReporting RUN at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
