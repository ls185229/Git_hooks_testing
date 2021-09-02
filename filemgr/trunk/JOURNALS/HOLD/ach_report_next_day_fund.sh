#!/usr/bin/bash

# $Id: ach_report_next_day_fund.sh 2379 2013-08-01 01:06:23Z bjones $

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

source $MASCLR_LIB/mas_env.sh

export ORACLE_SID=$ATH_DB
export TWO_TASK=$ATH_DB
echo $ORACLE_HOME
echo $TWO_TASK


locpth=/clearing/filemgr/JOURNALS

cd $locpth

echo "Beginning REPORTS RUN  at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log

if ach_report.tcl -i 107 -c 5 >> $locpth/LOG/reports.log; then
   echo "ach_report.tcl -i 107 -c 5 successfully\n" | tee -a $locpth/LOG/reports.log
else
   echo "Ending ach_report.tcl -i 107 -c 5 report run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
   tail -40 $locpth/LOG/reports.log  | mailx -r $MAIL_FROM -s "$SYS_BOX ach_report.tcl -i 107 -c 5 report run Failed. Location: $locpth" $MAIL_TO
   exit 1
fi

echo "Ending REPORTS RUN at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log

