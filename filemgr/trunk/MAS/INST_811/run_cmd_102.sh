#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

export ORACLE_SID=$IST_DB
export TWO_TASK=$IST_DB
echo $ORACLE_HOME
echo $TWO_TASK

cd $PWD

############################################################################################

inst_id=`awk '{FS=","; {print $1}}' inst_profile.cfg`
vbin=`awk '{FS=","; {print $2}}' inst_profile.cfg`
mbin=`awk '{FS=","; {print $3}}' inst_profile.cfg`
ica=`awk '{FS=","; {print $4}}' inst_profile.cfg`
cib=`awk '{FS=","; {print $5}}' inst_profile.cfg`
edpt=`awk '{FS=","; {print $6}}' inst_profile.cfg`
prdsn=`awk '{FS=","; {print $7}}' inst_profile.cfg`
tstsn=`awk '{FS=","; {print $8}}' inst_profile.cfg`
psrun=`awk '{FS=","; {print $9}}' inst_profile.cfg`


##################################################################################

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

if [[ $psrun = "P" ]] ; then
	sht_name=$prdsn
	print "Production run for $sht_name"
else
	sht_name=$tstsn
	print "TEST run for $sht_name"
fi

cmdno="102"
cycl="$1"

if [ $1 ]; then

print "Beginning  MAS FILE for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/cj_log.txt

if $locpth/sch_cmd.tcl $inst_id $cmdno $cycl >> $locpth/LOG/cmd.log; then 
	print "Script sch_cmd.tcl for cmd $cmdno inst $inst_id cycl $cycl completed" | tee -a $locpth/LOG/cmd.log
else
	echo "sch_cmd.tcl failed" | mailx -r $MAIL_FROM -s "$SYS_BOX: Script sch_cmd.tcl for cmd $cmdno inst_id $inst_id Failed" $MAIL_TO
fi

print "Ending MAS FILE for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/cj_log.txt

else

print "Incorrect number of arguments.\nUsage: run_cmd_XXX.sh <CYCLE> eg. 001"
    echo "`date +%Y%m%d%H%M%S` $inst_id $cmdno $1 FAILED \n$sysinfo\nIncorrect number of arguments.\nUsage: CYCLE eg. 001" | mailx -r $MAIL_FROM -s "$msubj_c: Script $0 FAILED  " $MAIL_TO
    
fi
