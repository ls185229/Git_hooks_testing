#!/usr/bin/ksh

# $Id: dfw_amex_daily_count_sum_file.sh 3819 2016-07-05 16:54:54Z skumar $

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile


export ORACLE_SID=$ATH_DB
export TWO_TASK=$ATH_DB
echo $ORACLE_HOME
echo $TWO_TASK

cd $PWD

##################################################################################

 clrpath=$CLR_OSITE_ROOT
 maspath=$MAS_OSITE_ROOT
 mailtolist="clearing@jetpay.com"
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

print "envoked at `date +%Y%m%d%H%M%S`"

inst_id="101"
codename="dfw_amex_daily_count_sum_file.tcl"


  for cnt_type in DFW_AMEX
    do 
	logname="$inst_id.$cnt_type.log"
	print "Script $locpth/$codename -i$inst_id -c$cnt_type started."
	if $locpth/$codename -i$inst_id -c$cnt_type >> $locpth/LOG/$logname; then
		print "Script $locpth/$codename -i$inst_id -c$cnt_type completed." >> $locpth/LOG/$logname
		print "$cnt_type Count File Completed Successfully"
	else
		mbody="Script failed:\n $locpth/$codename -i$inst_id -c$cnt_type"
		#echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
		echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" ssimpson@jetpay.com
	fi
    done





