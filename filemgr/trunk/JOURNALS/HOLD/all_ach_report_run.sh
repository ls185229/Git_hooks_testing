#!/usr/bin/ksh

# $Id: all_ach_report_run.sh 2375 2013-07-30 13:09:46Z bjones $

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

print "Beginning ACH REPORTS RUN  at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log

if ach_report.tcl -i 101 -i 107 >> $locpth/LOG/reports.log; then
   echo "ach_report.tcl successfully\n" | tee -a $locpth/LOG/reports.log
else
   print "ach_report.tcl run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
   tail -40 $locpth/LOG/reports.log  | mailx -r $MAIL_FROM -s "$SYS_BOX ach_report.tcl run Failed. Location: $locpth" $MAIL_TO
   exit 1
fi

print "Ending REPORTS RUN at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log

