#!/usr/bin/ksh


CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

export ORACLE_SID=$ATH_DB
export TWO_TASK=$ATH_DB
echo $ORACLE_HOME
echo $TWO_TASK


locpth=/clearing/filemgr/JOURNALS/ROLLUP

cd $locpth

print "Beginning REPORTS RUN  at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log

if merric-ach-statement.tcl  >> $locpth/LOG/reports.log; then
   echo "merric-ach-statement.tcl successfully\n" | tee -a $locpth/LOG/reports.log
else
   print "Ending merric-ach-statement.tcl report run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
   tail -40 $locpth/LOG/reports.log  | mailx -r $MAIL_FROM -s "$SYS_BOX merric-ach-statement.tcl report run Failed. Location: $locpth" $MAIL_TO
   exit 1
fi

print "Ending REPORTS RUN at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log

