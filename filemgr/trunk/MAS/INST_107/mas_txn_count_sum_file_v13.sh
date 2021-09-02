#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile


export ORACLE_SID=$CLR_DB
export TWO_TASK=$CLR_DB
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

print "Beginning  MAS FILE for $sht_name at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/maslog.txt

print "mas_txn_count_sum_file_v13.tcl $sht_name $inst_id `date +%Y%m%d`"

if mas_txn_count_sum_file_v13.tcl $sht_name $inst_id `date +%Y%m%d` >> $locpth/LOG/maslog.txt; then

	print "Script mas_txn_count_sum_file_v13.tcl completed" | tee -a $locpth/LOG/maslog.txt
else
	echo "Script mas_txn_count_sum_file_v13.tcl failed" | mailx -r $MAIL_FROM -s "$SYS_BOX: MAS: Script mas_txn_count_sum_file_v13.tcl Failed" $MAIL_TO
fi

if mas_recyl_txn_count_sum_file_v13.tcl $sht_name $inst_id `date +%Y%m%d` >> $locpth/LOG/rcyllog.txt; then
        print "Script mas_recyl_txn_count_sum_file_v13.tcl completed" | tee -a $locpth/LOG/rcyllog.txt
else
        echo "mas_recyl_txn_count_sum_file_v13.tcl failed" | mailx -r $MAIL_FROM -s "$SYS_BOX: MAS: mas_recyl_txn_count_sum_file_v13.tcl Failed" $MAIL_TO
fi

if mas_avcvbb_txn_count_sum_file_v13.tcl $sht_name $inst_id `date +%Y%m%d` >> $locpth/LOG/avscvvbb.log; then
        print "mas_avcvbb_txn_count_sum_file_v13.tcl completed" | tee -a $locpth/LOG/avscvvbb.log
else
        echo "mas_avcvbb_txn_count_sum_file_v13.tcl failed" | mailx -r $MAIL_FROM -s "$SYS_BOX: MAS: mas_avcvbb_txn_count_sum_file_v13.tcl Failed" $MAIL_TO
fi


filename="mas_batchheader_txn_count_sum_file_v13.tcl"
vlog="btchhdr.log"

if $filename $sht_name $inst_id `date +%Y%m%d` >> $locpth/LOG/$vlog; then
        print "$filename  $sht_name $inst_id `date +%Y%m%d` completed" | tee -a $locpth/LOG/$vlog
else
        echo "$filename  $sht_name $inst_id `date +%Y%m%d`failed" | mailx -r $MAIL_FROM -s "$SYS_BOX: MAS: $sht_name Failed" $MAIL_TO
fi


print "Ending MAS FILE for $sht_name at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/maslog.txt
