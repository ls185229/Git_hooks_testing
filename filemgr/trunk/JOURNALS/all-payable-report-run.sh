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

print "Beginning PAYABLE REPORTS RUN FOR ALL INSTITUTIONS at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log

if all-delay-statement.tcl  >> $locpth/LOG/reports.log; then
   echo "all-delay-statement.tcl successful\n" | tee -a $locpth/LOG/reports.log
else
   print "Ending all-delay-statement.tcl report run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
   tail -40 $locpth/LOG/reports.log  | mailx -r $MAIL_FROM -s "$SYS_BOX all-delay-statement.tcl report run failed. Location: $locpth" $MAIL_TO
fi


print "Ending PAYABLE REPORTS RUN at  FOR ALL INSTITUTIONS `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
