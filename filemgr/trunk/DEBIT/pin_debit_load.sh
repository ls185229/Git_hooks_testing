#!/usr/bin/ksh

################################################################################
# $Id: pin_debit_load.sh 3646 2016-01-22 19:48:20Z bjones $
# $Rev: 3646 $
################################################################################
#
# File Name:  pin_debit_load.sh
#
# Description:  This script initiates the daily move of PIN debit transactions 
#               from the authorization settlement to the tranhistory table.
#              
# Shell Arguments:   -d = Run date (e.g., YYYYMMDD).  Optional.  
#                         Defaults to current date.
#                    -e = Positive email confirmation flag.  Optional.
#                    -h = Help with script usage flag.  Optional.
#                    -v = Verbose logging flag.  Optional.  Default to OFF.
#
# Script Arguments:  -c = Configuration file name.  Optional.  No default.
#                    -d = Run date (e.g., YYYYMMDD).  Optional.  
#                         Defaults to current date.
#                    -l = Log file name.  Required.
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
max_num_shell_args=4
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
PRIORITY_EMAIL_LIST=$ALERT_EMAIL
NON_PRIORITY_EMAIL_LIST=$ALERT_NOTIFICATION


################################################################################
# Function Name:  print_script_usage
# Description:    Prints the usage syntax for this script 
################################################################################
print_script_usage()
{
   print "Script Usage:  $shell_script_name <arg1> <arg2> <arg3> <arg4>"
   print ""
   print "       Where:  <arg1> -d = Use with run date as YYYYMMDD [optional]"
   print "               <arg2> -e = Positive email confirmation flag [optional]"
   print "               <arg3> -h = Help with script usage [optional]"
   print "               <arg4> -v = Verbose logging flag"
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
   file_date=`date +%Y%m%d`
   file_time=`date +%H%M%S`
   run_date=$file_date
   run_time=$file_time

   email_confirm=NO
   run_mode=PROD
   verbose_log=OFF

   log_file=$locpth/LOG/pin_debit_load.log

   print "===================================================================================================="
   print "`date +%Y-%m-%d` `date +%H:%M:%S` Running $shell_script_name"

   #
   # Obtain provided shell script arguments
   #
   if [ $num_shell_args -ge $min_num_shell_args ]
   then
      if [ $num_shell_args -le $max_num_shell_args ]
      then
         while getopts "d:evh" shell_arg
         do
            case $shell_arg in
               d)     run_date=$OPTARG;;
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
   print "Settlement file:  $output_file"
}


################################################################################
# Function Name:  print_script_args
# Description:    Print script argument settings 
################################################################################
print_script_args()
{
   print "                    Configuration File:          $cfg_file"      
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
script_args=3
total_args=`expr $script_args + 1`
cfg_file=$locpth/pin_debit_load.cfg
exec_file=$locpth/pin_debit_load.tcl

if $exec_file $total_args -c$cfg_file -d$run_date -l$log_file >> $log_file
then
   if [ $email_confirm == "YES" ]
   then
      notify_someone "Run of $exec_file successful."
   fi
else
   print "`date +%Y-%m-%d` `date +%H:%M:%S` Ending $exec_file run failed with return code $return_code"
   alert_someone "Run of $exec_file failed."
   exit 1
fi

print "`date +%Y-%m-%d` `date +%H:%M:%S` $exec_file run is complete."

mv $log_file $log_file-$file_date

exit 0
