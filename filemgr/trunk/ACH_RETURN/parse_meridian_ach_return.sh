#!/usr/bin/ksh

################################################################################
#
#    File Name - parse_meridian_ach_return.sh
#
#    Description - This is a startup script for parse_meridian_ach_return.tcl.
#                  It does the following
#                  1- Intializes the program parameters
#                  2- Invokes the parse_meridian_ach_return.tcl process
#                  3- Handles the return codes and emails accordingly
#                 
#                 
#    Arguments - $1 = Config File - This file should have the login details
#                     for the database
#                $2 = Run Date - The date the files was downloaded.
#                     (YYYYMMDD) optional, defaults to current
#
#    Return - 0 = Success
#             1 = Fail
#
################################################################################
# $Id: parse_meridian_ach_return.sh 4745 2018-10-12 21:09:48Z bjones $
# $Rev: 4745 $
# $Author: bjones $


CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

#System variables
box=$SYS_BOX
sysinfo="System: $SYS_BOX\n Location: $PWD \n\n"

base_name=parse_meridian_ach_return


#######################################################
## Email Attributes 
#######################################################
msubj_c="$SYS_BOX :: Priority : Critical - Clearing and Settlement"
msubj_u="$SYS_BOX :: Priority : Urgent - Clearing and Settlement"
msubj_h="$SYS_BOX :: Priority : High - Clearing and Settlement"
msubj_m="$SYS_BOX :: Priority : Medium - Clearing and Settlement"
msubj_l="$SYS_BOX :: Priority : Low - Clearing and Settlement"

mbody_c="ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
mbody_u="ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
mbody_h="ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
mbody_m="ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
mbody_l="ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

#PRIORITY_EMAIL_LIST="jaymalag@jetpay.com"
#NON_PRIORITY_EMAIL_LIST="jaymalag@jetpay.com"
PRIORITY_EMAIL_LIST="clearing@jetpay.com assist@jetpay.com"
NON_PRIORITY_EMAIL_LIST="notifications-clearing@jetpay.com"
EMAIL_LIST=$PRIORITY_EMAIL_LIST
subject=$msubj_u
body=$mbody_u
reason="Check $base_name process"


## Program Arguments
cfg_file=$1
run_date=$2
num_args=$#

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
   print "Usage:  $base_name.sh <cfg file> <run_date>"
   print "        cfg_file = file containing DB login details"
   print "        run_date = Optional (YYYYMMDD),suffix on filename to parse"
   print "                   Defaults to current date"
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

   if [ ! $cfg_file ]
   then
      print "Missing Argument : Need a Config File"
      usage
      exit 1
   fi

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
   echo $1 | mailx -s "$subject - $reason" $EMAIL_LIST 
   print $1 | tee -a $log_file
}

##########
## MAIN ##
##########
init
$loc_path/parse_meridian_ach_return.tcl $cfg_file $run_date >> $log_file
rc=$?
if [ $rc != 0 ]
then
   if [ $rc == 2 ]
   then
       subject=$msubj_l
       reason="Parse ACH Return:No ACH Return File from Meridian"
       body="$reason on $run_date RC=$rc $result_file $log_file"
       EMAIL_LIST=$NON_PRIORITY_EMAIL_LIST
###    mail_someone "$body"
   elif [ $rc == 3 ]
   then
       subject=$msubj_u
       reason="Parse ACH Return: DataBase Error RC=$rc"
       body="$reason $run_date $result_file $log_file $mbody_u"
       EMAIL_LIST=$PRIORITY_EMAIL_LIST
       mail_someone "$body"
   elif [ $rc == 4 ]
   then
       subject=$msubj_u
       reason="Parse ACH Return:Count of ACH Return files downloaded and parsed do not match RC=$rc"
       body="$reason $run_date $result_file $log_file $mbody_u"
       EMAIL_LIST=$PRIORITY_EMAIL_LIST
       mail_someone "$body"
   elif [ $rc == 5 ]
   then
       subject=$msubj_u
       reason="Parse ACH Return:Could not find the downloaded Meridian ACH-Return file in DNLOAD for parsing RC=$rc"
       body="$reason $run_date $result_file $log_file $mbody_u"
       EMAIL_LIST=$PRIORITY_EMAIL_LIST
       mail_someone "$body"
   else
       subject=$msubj_u
       reason="Parse ACH Return: File Error RC=$rc"
       body="$reason $run_date $result_file $log_file $mbody_u"
       EMAIL_LIST=$PRIORITY_EMAIL_LIST
       mail_someone "$body"
   fi
fi

exit 
