#!/usr/bin/ksh

################################################################################
# $Id: turn_Off_cron.sh 4420 2017-11-08 20:22:31Z skumar $
# $Rev: 4420 $
################################################################################
#
# File Name:  turn_Off_cron.sh
#
# Description:  This script turns off CRON.
#              
# Shell Arguments:   -e = Positive email confirmation flag.  Optional.
#                    -h = Help with script usage flag.  Optional.
#                    -v = Verbose logging flag.  Optional.  Default to OFF.
#
# Script Arguments:  -l = Log file name.  Required.
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

## Email recipients ##
PRIORITY_EMAIL_LIST=$EMAIL_ALERT
NON_PRIORITY_EMAIL_LIST=$EMAIL_NOTIFICATION


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
   run_date=`date +%Y%m%d`
   run_time=`date +%H%M%S`

   email_confirm=NO
   verbose_log=OFF

   archive_file_name=$locpth/ARCHIVE/turn_Off_crontab_backup-$run_date$run_time.txt
   cron_txt_file_name=turnOff_cron.txt
   log_file=$locpth/LOG/turn_Off_cron.log

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

if [ $verbose_log == "VERBOSE" ]
then
   print_script_args
fi

#
# Run the script
#
crontab -l > $archive_file_name

if crontab $cron_txt_file_name >> $log_file 
then
   print "`date +%Y-%m-%d` `date +%H:%M:%S` $shell_script_name completed"
else
   print "`date +%Y-%m-%d` `date +%H:%M:%S` $shell_script_name failed"
   alert_someone "Run of $shell_script_name failed; CRON was not turned OFF."
fi

mv $log_file $log_file-$run_date

exit 0
