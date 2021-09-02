#!/usr/bin/ksh
#
# Script to retrieve the Discover anr files

# Invocation is: discover_dispute_dnload.sh

# Following notifies .profile that this is a cron script so do not invoke
# STTY command, otherwise script generates a "stty: : No such device or address"
# email every day.

CRON_JOB=1
export CRON_JOB

. /clearing/filemgr/.profile

run_num=$1

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

cnt=0
HOST_NAME=`hostname`
EMAIL_LIST="clearing@jetpay.com assist@jetpay.com"
mail_list="clearing@jetpay.com"


print "\nDiscover discover_dispute_dnload.sh started on" `date +'%m/%d/%y @ %H:%M:%S'`

TIME_STAMP=`date +%Y%m%d%H%M%S`
HOST_NAME=`hostname`

if [[ $1 -eq "" ]]
then
echo "No argument provided for discover_return_dnload.sh" | mailx -r clearing@jetpay.com -s "*** Discover $code_name File Processing Error ***" $EMAIL_LIST
exit 0
fi

#**********
notify_someone()
{
   echo $1 | mailx -r clearing@jetpay.com -s "*** Discover $code_name File Processing Error ***" $EMAIL_LIST
}


#############
# Main module
#############

code_name="discover_DISPIMGE_file_dnload.exp"

while [[ $cnt -ne $run_num ]] ; do

TIME_STAMP=`date +%Y%m%d%H%M%S`

if $code_name 
then
	print "Discover $code_name file retrieval Successful"
else
    print "Discover $code_name file retrieval failed"
    notify_someone "Unable to retrieve Discover DISPIMGE file. \n $code_name failed."
fi

print "Discover $code_name complete on" `date +'%m/%d/%y @ %H:%M:%S'`

sleep 5

code_name="discover_DISPNTCE_file_dnload.exp"

TIME_STAMP=`date +%Y%m%d%H%M%S`

if $code_name
then
        print "Discover $code_name file retrieval Successful"
else
    print "Discover $code_name file retrieval failed"
    notify_someone "Unable to retrieve Discover DISPNTCE file. \n $code_name failed."
fi

print "Discover $code_name complete on" `date +'%m/%d/%y @ %H:%M:%S'`

sleep 5


code_name="discover_NERSPRI8_file_dnload.exp"

TIME_STAMP=`date +%Y%m%d%H%M%S`

if $code_name
then
        print "Discover $code_name file retrieval Successful"
else
    print "Discover $code_name file retrieval failed"
    notify_someone "Unable to retrieve Discover NERSPRI8 file. \n $code_name failed."
fi

print "Discover $code_name complete on" `date +'%m/%d/%y @ %H:%M:%S'`

sleep 5


code_name="discover_NERSARI8_file_dnload.exp"


TIME_STAMP=`date +%Y%m%d%H%M%S`

if $code_name
then
        print "Discover $code_name file retrieval Successful"
else
    print "Discover $code_name file retrieval failed"
    notify_someone "Unable to retrieve Discover NERSARI8 file. \n $code_name failed."
fi

print "Discover $code_name complete on" `date +'%m/%d/%y @ %H:%M:%S'`

cnt=`expr $cnt + 1`
print $cnt
sleep 5

locpth=/clearing/filemgr/JOURNALS/
if /clearing/filemgr/JOURNALS/acquirer_report_ari.tcl >> $locpth/LOG/reports.log; then
   echo "acquirer_report_ari.tcl successful\n" | tee -a $locpth/LOG/reports.log
else
   print "Ending acquirer_report_ari.tcl report run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/reports.log
   tail -40 $locpth/LOG/reports.log  | mailx -r $MAIL_FROM -s "$SYS_BOX acquirer_report_ari.tcl report run failed. Location: $locpth" $MAIL_TO
fi

done




