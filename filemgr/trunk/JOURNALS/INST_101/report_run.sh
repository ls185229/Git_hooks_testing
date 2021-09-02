#!/usr/bin/ksh


CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

export ORACLE_SID=$ATH_DB
export TWO_TASK=$ATH_DB
echo $ORACLE_HOME
echo $TWO_TASK


locpth=/clearing/filemgr/JOURNALS/INST_101

cd $locpth

print "Beginning REPORTS RUN  at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log

if merric-I-E.tcl >> $locpth/LOG/reports.log; then
   echo "merric-I-E.tcl successfully\n" | tee -a $locpth/LOG/reports.log
else
   print "Ending merric-I-E.tcl report run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
   tail -40 $locpth/LOG/reports.log  | mailx -r $MAIL_FROM -s "$SYS_BOX merric-I-E.tcl report run Failed. Location: $locpth" $MAIL_TO
   exit 1
fi

if merric-ach-statement.tcl  >> $locpth/LOG/reports.log; then
   echo "merric-ach-statement.tcl successfully\n" | tee -a $locpth/LOG/reports.log
else
   print "Ending merric-ach-statement.tcl report run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
   tail -40 $locpth/LOG/reports.log  | mailx -r $MAIL_FROM -s "$SYS_BOX merric-ach-statement.tcl report run Failed. Location: $locpth" $MAIL_TO
   exit 1
fi

if merric-daily-detail.tcl  >> $locpth/LOG/reports.log; then
   echo "merric-daily-detail.tcl successfully\n" | tee -a $locpth/LOG/reports.log
else
   print "Ending merric-daily-detail.tcl report run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
   tail -40 $locpth/LOG/reports.log  | mailx -r $MAIL_FROM -s "$SYS_BOX merric-daily-detail.tcl report run Failed. Location: $locpth" $MAIL_TO
   exit 1
fi

if merric-delay-statement.tcl >> $locpth/LOG/reports.log; then
   echo "merric-delay-statement.tcl successfully\n" | tee -a $locpth/LOG/reports.log
else
   print "Ending merric-delay-statement.tcl report run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
   tail -40 $locpth/LOG/reports.log  | mailx -r $MAIL_FROM -s "$SYS_BOX merric-delay-statement.tcl report run Failed. Location: $locpth" $MAIL_TO
   exit 1
fi

if merric-headers.tcl >> $locpth/LOG/reports.log; then
   echo "merric-headers.tcl successfully\n" | tee -a $locpth/LOG/reports.log
else
   print "Ending merric-headers.tcl report run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
   tail -40 $locpth/LOG/reports.log  | mailx -r $MAIL_FROM -s "$SYS_BOX merric-headers.tcl report run Failed. Location: $locpth" $MAIL_TO
   exit 1
fi

if merric-portfolio.tcl >> $locpth/LOG/reports.log; then
   echo "merric-portfolio.tcl successfully\n" | tee -a $locpth/LOG/reports.log
else
   print "Ending merric-portfolio.tcl report run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
   tail -40 $locpth/LOG/reports.log  | mailx -r $MAIL_FROM -s "$SYS_BOX merric-portfolio.tcl report run Failed. Location: $locpth" $MAIL_TO
   exit 1
fi

if merric-reserve.tcl >> $locpth/LOG/reports.log; then
   echo "merric-reserve.tcl successfully\n" | tee -a $locpth/LOG/reports.log
else
   print "Ending merric-reserve.tcl report run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
   tail -40 $locpth/LOG/reports.log  | mailx -r $MAIL_FROM -s "$SYS_BOX merric-reserve.tcl report run Failed. Location: $locpth" $MAIL_TO
   exit 1
fi


print "Ending REPORTS RUN at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log

