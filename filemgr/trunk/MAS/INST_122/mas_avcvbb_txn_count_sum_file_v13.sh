#!/usr/bin/ksh

################################################################################
# $Id: $
# $Rev: $
################################################################################
#
# File Name:  mas_avcvbb_txn_count_sum_file_v13.sh
#
# Description:  This program initiations the generation of a MAS AVS/CVV and
#               BIN blocking transaction count summary file for the institution.
#              
# Shell Arguments: None.
#
# Script Arguments:  date = Run date of the file.  Required.
#                    inst_id = Institution ID.  Required.
#					 sht_name = ISO shortname associated with the institution.
#                               Required.
#
# Output:  MAS AVS/CVV/BIN blocking transaction count summary file for the 
#          institution.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

export ORACLE_SID=$ATH_DB
export TWO_TASK=$ATH_DB
echo $ORACLE_HOME
echo $TWO_TASK

cd $PWD

inst_id=`awk '{FS=","; {print $1}}' inst_profile.cfg`
vbin=`awk '{FS=","; {print $2}}' inst_profile.cfg`
mbin=`awk '{FS=","; {print $3}}' inst_profile.cfg`
ica=`awk '{FS=","; {print $4}}' inst_profile.cfg`
cib=`awk '{FS=","; {print $5}}' inst_profile.cfg`
edpt=`awk '{FS=","; {print $6}}' inst_profile.cfg`
prdsn=`awk '{FS=","; {print $7}}' inst_profile.cfg`
tstsn=`awk '{FS=","; {print $8}}' inst_profile.cfg`
psrun=`awk '{FS=","; {print $9}}' inst_profile.cfg`

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

#System information variables
sysinfo="System: $SYS_BOX\n Location: $PWD \n\n"

#####################################################################################################

locpth=/clearing/filemgr/MAS/INST_$inst_id
cd $locpth

######## MAIN ####################################

if [[ $psrun = "P" ]] ; then
	sht_name=$prdsn
	print "Production run for $sht_name"
else
	sht_name=$tstsn
	print "TEST run for $sht_name"
fi


codename="mas_avcvbb_txn_count_sum_file_v13.tcl"
lgfname="avcvbb.log"


print "Beginning  $codename for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/$lgfname

if $codename $sht_name $inst_id `date +%Y%m%d` >> $locpth/LOG/$lgfname; then
	print "Script $codename completed" | tee -a $locpth/LOG/$lgfname
else
	echo "Script $codename failed" | mailx -r $mailfromlist -s "$box :: MAS :: Priority Critical- Call On-Call Engr. immidiaetly" $mailtolist 
fi

print "Ending $codename for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/$lgfname

