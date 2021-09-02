#!/usr/bin/ksh

################################################################################
# $Id: send_ptcca_auth_reports.sh 4054 2017-02-06 23:16:14Z millig $
# $Rev: 4054 $
################################################################################
#
# File Name:  send_b2bca_daily_detail_reports.sh
#
# Description:  This script transmits Auth Balancing reports to B2B and PTC.
#              
# Script Arguments:  None.  
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

## System variables ##
sysinfo="System: $SYS_BOX\n Location: $PWD \n\n"

## Directory locations ##
locpth=$PWD

## Command line shell arguments ##
shell_script_name=$0
num_shell_args=$#
max_num_shell_args=2
min_num_shell_args=0

## Email attributes ##
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

# PRIORITY_EMAIL_LIST=$EMAIL_ALERT
PRIORITY_EMAIL_LIST="reports-clearing@jetpay.com"
# NON_PRIORITY_EMAIL_LIST=$EMAIL_NOTIFICATION
NON_PRIORITY_EMAIL_LIST="assist@jetpay.com, clearing@jetpay.com"

################################################################################
# Function Name:  print_script_usage
# Description:    Prints the usage syntax for this script 
################################################################################
print_script_usage()
{
   print "Script Usage:  $shell_script_name <arg1> <arg2>"
   print ""
   print "       Where:  <arg1> -e = Positive email confirmation flag [optional]"
   print "               <arg2> -v = Verbose logging flag"
   exit 1 
}


################################################################################
# Function Name:  init_script
# Description:    Initializes the script startup parameters 
################################################################################
init_script()
{

   #
   # Set script defaults
   #
   julian_day=`date +%y%j`
   julian_yddd=`echo ${julian_day:1:4}`
   run_date=`date +%Y%m%d`
   run_time=`date +%H%M%S`

   email_confirm=NO
   verbose_log=OFF

   ftp_ach_src_dir=/clearing/filemgr/JOURNALS/DAILY/ARCHIVE
   log_file=$locpth/LOG/send_ptcca_auth_reports.log
   auth_report_mask=129.Auth_Balancing_Report.$run_date*

   print "===================================================================================================="
   print "`date +%Y-%m-%d` `date +%H:%M:%S` Running $shell_script_name"

   #
   # Obtain provided shell script arguments
   #
   if [ $num_shell_args -ge $min_num_shell_args ]
   then
      if [ $num_shell_args -le $max_num_shell_args ]
      then
         while getopts "evh" shell_arg
         do
            case $shell_arg in
               e)     email_confirm=YES;;
               v)     verbose_log=VERBOSE;;
               h|*)   print_script_usage
                      exit 0;;
            esac
         done
      else
         print "Too many arguments provided for $shell_script_name"
         print_script_usage
      fi
   else
      print "Too few arguments provided for $shell_script_name"
      print_script_usage
   fi

   print "$shell_script_name to be run for $run_date"
}


################################################################################
# Function Name:  print_script_args
# Description:    Print script argument settings 
################################################################################
print_script_args()
{
   print "                    Archive Directory:           $archive_dir"   
   print "                    Email Confirmation:          $email_confirm" 
   print "                    Log File:                    $log_file"      
   print "                    Run Date:                    $run_date"      
   print "                    Verbose Logging:             $verbose_log"   
}


################################################################################
# Function Name:  alert_someone
# Description:    Send an alert email to interested parties 
################################################################################
alert_someone()
{
   echo "$1" | mutt -s "$msubj_h $1" -- $PRIORITY_EMAIL_LIST
   print "`date +%Y-%m-%d` `date +%H:%M:%S` $1"
}


################################################################################
# Function Name:  notify_someone
# Description:    Send an alert email to interested parties 
################################################################################
notify_someone()
{
   echo "$1" | mutt -s "$msubj_l $1" -- $NON_PRIORITY_EMAIL_LIST
}

##########
## MAIN ##
##########
init_script "${@}"

   print_script_args

#
# Run the script
#
print "$locpth"

#--
#-- Upload to B2Billig
#-- 
echo "Attempting to upload Auth Balancing report to B2Billing at `date +%H`:`date +%M`:`date +%S`"
/usr/bin/sftp b2payments@sftp.jetpay.com << EOF
cd reports
put $ftp_ach_src_dir/$auth_report_mask
quit
EOF
transfer_result=$?

if [ $transfer_result -ne 0 ]
then
    alert_someone "Auth Balancing report file transfer to B2Billig $0 processing for run date $file_run_date failed."
fi

#--
#-- Upload to Peoples Trust
#-- 
echo "Attempting to upload Auth Balancing report to Peoples Trust at `date +%H`:`date +%M`:`date +%S`"
/usr/bin/sftp ptrust@sftp.jetpay.com << EOF
cd reports/ptcca
put $ftp_ach_src_dir/$auth_report_mask
quit
EOF
transfer_result=$?

if [ $transfer_result -ne 0 ]
then
    alert_someone "Auth Balancing report file transfer to Peoples Trust $0 processing for run date $file_run_date failed."
fi
print "___________________________________________________________________________\n" | tee -a $log_file

mv $log_file $log_file-$run_date$run_time

exit 0
