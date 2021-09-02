#!/usr/bin/ksh

################################################################################
# $Id: run_mas_cmd_138.sh 3829 2016-07-27 11:50:26Z bjones $
# $Rev: 3829 $
################################################################################
#
# File Name:  run_mas_cmd_138.sh
#
# Description:  This script initiates running the FIS 138 command 
#
# Shell Arguments:  None.
#
#
# Output:  Confirmation emails to configured parties.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
################################################################################

CRON_JOB=1
export CRON_JOB
 . /clearing/filemgr/.profile

export ORACLE_SID=$IST_DB
export TWO_TASK=$IST_DB
echo ORACLE_HOME = $ORACLE_HOME
echo IST_DB = $TWO_TASK

# FC 
 cd $PWD

##################################################################################

##################################################################################

clrpath=$CLR_OSITE_ROOT
maspath=$MAS_OSITE_ROOT
mailtolist=$MAIL_TO
mailfromlist=$MAIL_FROM
clrdb=$IST_DB
authdb=$ATH_DB
box=$SYS_BOX
today=`date +"%y%j"`

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

##################################################################################


locpth=$PWD
cd $locpth

######## MAIN ####################################


code_nm="cmd_138_v2.tcl"

print code to run: $code_nm

print "JetPay 138 BEGIN `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/ach.log

if $locpth/$code_nm | tee -a $locpth/LOG/ach.log; then
    print "$locpth/$code_nm successful" | tee -a $locpth/LOG/ach.log

else
    echo "$locpth/$code_nm failed" | mailx -r $MAIL_FROM -s "$SYS_BOX Script $code_nm Failed" $MAIL_TO
fi

print "<> END <> `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/ach.log
