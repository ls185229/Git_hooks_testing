#!/usr/bin/env ksh
# secure method of finding/invoking bash

# $Id: check_for_extra_exported_files.sh 3515 2015-09-24 02:08:16Z bjones $

VERSION="1.0"
DATE="08-JUN-18"

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

mailtolist=$MAIL_TO
mailfromlist=$MAIL_FROM
box=$SYS_BOX
sysinfo="System: $SYS_BOX\n Location: $PWD \n\n"
LOG_FILE="./LOG/GLOBAL.cron.log"
TCL_LOG_FILE="./LOG/GLOBAL.extra_files.log"
run_script="./check_for_extra_exported_files.tcl"

#Email Subjects variables Priority wise

msubj_c="$box :: Priority : Critical - Clearing and Settlement"
msubj_u="$box :: Priority : Urgent - Clearing and Settlement"
msubj_h="$box :: Priority : High - Clearing and Settlement"
msubj_m="$box :: Priority : Medium - Clearing and Settlement"
msubj_l="$box :: Priority : Low - Clearing and Settlement"

#Email Subjects variables Priority wise

mbody_c="ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
mbody_u="ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
mbody_h="ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
mbody_m="ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
mbody_l="ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"



cd $PWD

#Usage: ./check_for_extra_exported_files.tcl
# no options used.

print "`date +%Y%m%d%H%M%S` $0 STARTED" >> $LOG_FILE

if  $run_script >> $TCL_LOG_FILE; then
    print "`date +%Y%m%d%H%M%S` $0 SUCCESSFULLY COMPLETED  " >> $LOG_FILE
else
    print "`date +%Y%m%d%H%M%S` $0 FAILED " >> $LOG_FILE
    echo "`date +%Y%m%d%H%M%S` $0 FAILED \n$sysinfo" | mailx -r $MAIL_FROM -s "$msubj_c: Script $0 FAILED  " $MAIL_TO
fi
