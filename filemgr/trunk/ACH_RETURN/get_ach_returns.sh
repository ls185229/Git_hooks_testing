#!/usr/bin/ksh

################################################################################
# $Id: get_ach_returns.sh 4745 2018-10-12 21:09:48Z bjones $

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

export ORACLE_SID=$ATH_DB
export TWO_TASK=$ATH_DB
echo $ORACLE_HOME
echo $TWO_TASK

##################################################################################

 clrpath=$CLR_OSITE_ROOT
 maspath=$MAS_OSITE_ROOT
# mailtolist=$MAIL_TO
 mailtolist=clearing@jetpay.com
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

####################################################################################################

locpth="/clearing/filemgr/ACH_RETURN"
#locpth=/clearing/filemgr/NEW_CODES

cd $locpth

print "BEGIN `date +%Y%m%d%H%M%S`"

if $locpth/get_returns.exp >> $locpth/LOG/achret.log
  then
     print "$locpth/get_returns.exp completed"

     if $locpth/reject_dump_ach.tcl >> $locpth/LOG/achret.log
	then
		print "$locpth/reject_dump_ach.tcl completed"
	else
		echo "$mbody_m \n Script $locpth/reject_dump_ach.tcl failed" | mailx -r $MAIL_FROM -s "$msubj_m" $mailtolist
     fi

  else

	echo "$mbody_m \n Script $locpth/get_returns.exp failed" | mailx -r $MAIL_FROM -s "$msubj_m" $mailtolist

fi

print "END `date +%Y%m%d%H%M%S`"
