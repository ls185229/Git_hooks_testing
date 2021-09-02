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

print "Beginning DAILY REPORTS RUN  at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log


if all-daily-detail.tcl >> $locpth/LOG/reports.log; then
   echo "all-daily-detail.tcl successful\n" | tee -a $locpth/LOG/reports.log
else
   print "all-daily-detail.tcl report run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
   tail -40 $locpth/LOG/reports.log  | mailx -r $MAIL_FROM -s "$SYS_BOX all-daily-detail.tcl report run failed. Location: $locpth" $MAIL_TO
fi

if all-reserve.tcl >> $locpth/LOG/reports.log; then
   echo "all-reserve.tcl 105 successful\n" | tee -a $locpth/LOG/reports.log
else
   print "Ending all-reserve.tcl 105 report run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
   tail -40 $locpth/LOG/reports.log  | mailx -r $MAIL_FROM -s "$SYS_BOX all-reserve.tcl report run failed. Location: $locpth" $MAIL_TO
fi

if JETPAY_ISO_REJECT_RETURN.tcl >> $locpth/LOG/reports.log; then
   echo "JETPAY_ISO_REJECT_RETURN.tcl 105 successful\n" | tee -a $locpth/LOG/reports.log
else
   print "Ending JETPAY_ISO_REJECT_RETURN.tcl 105 report run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
   tail -40 $locpth/LOG/reports.log  | mailx -r $MAIL_FROM -s "$SYS_BOX JETPAY_ISO_REJECT_RETURN.tcl report run failed. Location: $locpth" $MAIL_TO
fi

if all-delay-statement.tcl  >> $locpth/LOG/reports.log; then
   echo "all-delay-statement.tcl 105 successful\n" | tee -a $locpth/LOG/reports.log
else
   print "Ending all-delay-statement.tcl 105 report run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
   tail -40 $locpth/LOG/reports.log  | mailx -r $MAIL_FROM -s "$SYS_BOX all-delay-statement.tcl report run failed. Location: $locpth" $MAIL_TO
fi


print "Ending DAILY REPORTS RUN at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
