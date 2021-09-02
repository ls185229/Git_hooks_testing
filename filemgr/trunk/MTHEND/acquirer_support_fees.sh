#!/usr/bin/ksh
# $Id: acquirer_support_fees.sh 1686 2012-03-19 18:09:41Z kmyatt $

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
 mailtolist=$MAIL_TO
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

file_date=`date +%Y%m%d`

print "invoked at `date +%Y%m%d%H%M%S`"
clearing_fee_list="ZZACQSUPPORTFEE"
codename="acquirer_support_fees.tcl"

#if /clearing/filemgr/lastday.sh; then
for f in *-acq_support_fee_file.csv
  do
# get everything to the left of the dash in the file name.
    inst_id=${f%%-*}
    for clearing_fee in $clearing_fee_list
    do
      logname="$inst_id.$clearing_fee.log"
      print "Script $locpth/$codename -i$inst_id -c$clearing_fee started."
      if $locpth/$codename -i$inst_id -c$clearing_fee >> $locpth/LOG/$logname; then
         mv $inst_id-acq_support_fee_file.csv ARCHIVE/$inst_id-acq_support_fee_file_$file_date.csv
         gzip ARCHIVE/$inst_id-acq_support_fee_file_$file_date.csv
         print "Script $locpth/$codename -i$inst_id -c$clearing_fee completed." >> $locpth/LOG/$logname
         print "$clearing_fee Count File Completed Successfully"
      else
         mbody="Script failed:\n $locpth/$codename -i$inst_id -c$clearing_fee"
         echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
      fi
    done
  done

#else
#       print "Not yet end of the month. This code should be run only at end of month."
#fi
