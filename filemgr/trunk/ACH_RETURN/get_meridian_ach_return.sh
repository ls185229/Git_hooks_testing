#!/usr/bin/ksh

################################################################################
#
#    File Name - get_meridian_ach_return.sh
#
#    Description - This is a startup script for the get_meridian_ach_return.exp
#                  process.It does the following
#                  1- Intializes the program parameters.
#                  2- Intilaizes log file and result file.
#                  3- Invokes the get_meridian_ach_return.exp process
#                  4- Handles the return codes and sends out email accordingly
#
#    Arguments - $1 = run date (YYYYMMDD), Optional. Defaults to currrent.
#                     Uses this date add date stamp to filename
#
#    Return - 0 = Success
#             1 = Fail
#
################################################################################
# $Id: get_meridian_ach_return.sh 4745 2018-10-12 21:09:48Z bjones $
# $Rev: 4745 $
# $Author: bjones $


CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

#System variables
box=$SYS_BOX
sysinfo="System: $SYS_BOX\n Location: $PWD \n\n"


#######################################################
## Email Attributes
#######################################################
msubj_c="$SYS_BOX :: Priority : Critical - Clearing and Settlement"
msubj_u="$SYS_BOX :: Priority : Urgent - Clearing and Settlement"
msubj_h="$SYS_BOX :: Priority : High - Clearing and Settlement"
msubj_m="$SYS_BOX :: Priority : Medium - Clearing and Settlement"
msubj_l="$SYS_BOX :: Priority : Low - Clearing and Settlement"
m_reason="ACH Return files from Meridian"

mbody_c="ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
mbody_u="ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
mbody_h="ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
mbody_m="ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
mbody_l="ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

NON_PRIORITY_EMAIL_LIST="notifications-clearing@jetpay.com"
PRIORITY_EMAIL_LIST="clearing@jetpay.com assist@jetpay.com"
subject=$msubj_u
EMAIL_LIST=$PRIORITY_EMAIL_LIST

## Global variable

run_date=$1
num_args=$#
base_name=get_meridian_ach_return

### Files and Directories
loc_path=/clearing/filemgr/ACH_RETURN
log_file=$loc_path/LOG/$base_name.log
result_file=$loc_path/achReturnDnld.result

##################################################
# Function - usage()
# Description - Print the syntax for this script
##################################################
usage()
{
   print "Usage:  $base_name.sh <run_date>"
   print "        run_date = Optional (YYYYMMDD), Defaults to current."
   print "                   This date is used by the process to rename "
   print "                   the downloaded file with this date-stamp."
   print "                   For Eg - <fileName>-<run_date>"
}

##################################################
# Function - init()
# Description - Initialize the startup parameters
##################################################
init()
{
    print "===============================================" >> $log_file
    print "Executing $base_name.sh on `date +%Y%m%d%H%M%S`" >> $log_file
    print "===============================================" >> $log_file

    if [ ! $run_date ]
    then
       run_date=`date +%Y%m%d`
    fi
}

##################################################
# Function - mail_someone
# Description - Send transaction information
##################################################
mail_someone()
{
   echo $1 | mailx -s "$subject - $m_reason" $EMAIL_LIST
   print $1 | tee -a $log_file
}

##########
## MAIN ##
##########
init
$loc_path/get_meridian_ach_return.exp $run_date >> $log_file
rc=$?
if [ $rc != 0 ]
then
   if [ $rc == 3 ]
   then
      m_reason="No ACH Return files from Meridian"
      subject=$msubj_l
      EMAIL_LIST=$NON_PRIORITY_EMAIL_LIST
      mail_someone "$m_reason on $run_date"
   else
      m_reason="ACH return file download error"
      subject=$msubj_u
      EMAIL_LIST=$PRIORITY_EMAIL_LIST
      mail_someone "Error occured while downloading ACH return files from Meridian, RC= $rc, check the log file $log_file"
   fi
fi

exit 0
