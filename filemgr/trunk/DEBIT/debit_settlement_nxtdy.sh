#!/usr/bin/ksh

# $Id: debit_settlement_nxtdy.sh 3512 2015-09-22 21:33:12Z bjones $

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

export ORACLE_SID=$ATH_DB
export TWO_TASK=$ATH_DB
echo $ORACLE_HOME
echo $TWO_TASK

cd $PWD

 clrpath=$CLR_OSITE_ROOT
 maspath=$MAS_OSITE_ROOT
 mailtolist=$MAIL_TO
 mailfromlist=$MAIL_FROM
 clrdb=$IST_DB
 authdb=$ATH_DB
 box=$SYS_BOX

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

#System information variables....

sysinfo="System: $SYS_BOX\n Location: $PWD \n\n"

#####################################################################################################

locpth=$PWD
cd $locpth

######## MAIN ####################################

inst_id="107"
sname="NEXTDAY107"
logfile="debit_mas_file.log"

print "Beginning at `date +%Y%m%d%H%M%S`" >> $locpth/LOG/$logfile

if ./mas_debit_settlement_file.tcl $sname $inst_id >> $locpth/LOG/$logfile; then
        print "Script mas_debit_settlement_file.tcl $sname $inst_id completed successfully" | tee -a $locpth/LOG/$logfile
else
        mbody="$SYS_BOX Script mas_debit_settlement_file.tcl $sname $inst_id Failed"
        print "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
fi

print "Ending at `date +%Y%m%d%H%M%S`" >> $locpth/LOG/$logfile
