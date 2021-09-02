#!/usr/bin/ksh

#$Id: ach_report_run-105-w-time.sh 2332 2013-06-13 21:22:51Z bjones $

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

# Used instead of including mas_env.sh
# this is a trick to see if the script is being run interactively or by cron
# if interactive, set the script user to the person running it
# so alerts will not go to clearing
fd=0
if [[ -t "$fd" || -S /dev/stdin ]]
then
    echo "Script appears to be running interactively"
    SCRIPT_USER=`who am i | cut -d" " -f 1`
    echo "$SCRIPT_USER running as `whoami`"
else
    echo "Script appears to be running from cron"
    SCRIPT_USER="clearing"
    echo "Setting SCRIPT_USER to clearing and running as `whoami`"
fi

export SCRIPT_USER
export ORACLE_SID=$ATH_DB
export TWO_TASK=$ATH_DB
echo $ORACLE_HOME
echo $TWO_TASK


locpth=/clearing/filemgr/JOURNALS

cd $locpth

print "Beginning `basename $0` RUN  at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log

if 105-ach-statement-w-time.tcl  >> $locpth/LOG/reports.log; then
   echo "105-ach-statement-w-time.tcl successfully\n" | tee -a $locpth/LOG/reports.log
else
   print "Ending 105-ach-statement-w-time.tcl  report run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
   tail -40 $locpth/LOG/reports.log  | mailx -r $MAIL_FROM -s "$SYS_BOX 105-ach-statement-w-time.tcl  report run Failed. Location: $locpth" $MAIL_TO
   exit 1
fi

print "Ending `basename $0` RUN at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log

