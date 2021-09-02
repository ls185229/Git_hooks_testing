#!/usr/bin/ksh

################################################################################
# $Id: pin_debit_create_mas_file.sh 3669 2016-01-31 04:08:24Z bjones $
# $Rev: 3669 $
################################################################################
#
# File Name:  pin_debit_create_mas_file.sh
#
# Description:  This script initiates the creation of an institution PIN debit
#               MAS import file.
#
# Shell Arguments:   -d = Run date (e.g., YYYYMMDD).  Optional.
#                         Defaults to current date.
#                    -e = Positive email confirmation flag.  Optional.
#                    -h = Help with script usage flag.  Optional.
#                    -i = Institution ID (e.g., ALL, 101, 105, 107, 117, 121).
#                         Required.  No default.
#                    -v = Verbose logging flag.  Optional.  Default to OFF.
#
# Script Arguments:  -c = Configuration file name.  Optional.  No default.
#                    -d = Run date (e.g., YYYYMMDD).  Optional.
#                         Defaults to current date.
#                    -i = Institution ID (e.g., ALL, 101, 105, 107, 802).
#                         Required.  No default.
#                    -l = Log file name.  Required.
#                    -o = Output file name.  Required.  No default.
#                    -v = Verbose logging flag.  Optional.  Default to OFF.
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
# max_num_shell_args=5
min_num_shell_args=1

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
   print "Script Usage:  $shell_script_name [options]"
   print ""
   print "    Where:  -d = Use with run date as YYYYMMDD [optional]"
   print "            -e = Positive email confirmation flag [optional]"
   print "            -h = Help with script usage [optional]"
   print "            -i = Institution ID (e.g., 101, 105, 107) [required]"
   print "            -v = Verbose logging flag"
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
   julian_day=`date +%y%j`
   julian_yddd=`echo ${julian_day:1:4}`
   run_date=$file_date

   email_confirm=NO
   run_mode=PROD
   verbose=""

   log_file=$locpth/LOG/pin_debit_create_mas_file.log

   print "===================================================================================================="
   print "`date +%Y-%m-%d` `date +%H:%M:%S` Running $shell_script_name"

   #
   # Obtain provided shell script arguments
   #
   # # if [ $num_shell_args -ge $min_num_shell_args ]
   # # then
   # #    if [ $num_shell_args -le $max_num_shell_args ]
   # #    then
         while getopts "d:ei:vh" shell_arg
         do
            case $shell_arg in
               d)     run_date=$OPTARG
                      julian_day=`printf "%(%y%j)T" "$run_date"`
                      julian_yddd=`echo ${julian_day:1:4}`;;
               e)     email_confirm=YES;;
               i)     inst_id=$OPTARG
                      if [ "$inst_id" == "" ]
                      then
                         print "Provide inst ID with -i option with $shell_script_name"
                         print_script_usage
                      fi;;
               v)     verbose="$verbose -v";;
               h|*)   print_script_usage
                      exit 0;;
            esac
         done
   # #    else
   # #       print "Too many arguments provided for $shell_script_name"
   # #       print_script_usage
   # #    fi
   # # else
   # #    print "Too few arguments provided for $shell_script_name"
   # #    print_script_usage
   # # fi

    if [ "$inst_id" == "" ]
    then
        print "Provide inst ID with -i option with $shell_script_name"
        print_script_usage
    fi

   output_file=`build_filename.py -i $inst_id -f DEBITRAN -j $julian_yddd`

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
   print "                    Institution ID:              $inst_id"
   print "                    Log File:                    $log_file"
   print "                    Output File:                 $output_file"
   print "                    Run Date:                    $run_date"
   print "                    Verbose Logging:             $verbose"

   print "                    Number of script args:       $script_args"
   print "                    Total number of args:        $total_args"
   print "                    Executable file:             $exec_file"

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

#
# Run the script
#
script_args=6
total_args=`expr $script_args + 1`
cfg_file=$locpth/pin_debit_create_mas_file.cfg
exec_file=$locpth/pin_debit_create_mas_file.tcl

if [ "$verbose" != "" ]
then
   print_script_args
   echo "Command line: " $exec_file $total_args -c$cfg_file -d$run_date -i$inst_id -l$log_file -o$output_file $verbose
fi

if $exec_file $total_args -c$cfg_file -d$run_date -i$inst_id -l$log_file -o$output_file $verbose >> $log_file
then
   if [ $email_confirm == "YES" ]
   then
      notify_someone "Run of $exec_file successful."
   fi
else
   print "`date +%Y-%m-%d` `date +%H:%M:%S` Ending $exec_file run failed with return code $?"
   alert_someone "Run of $exec_file failed."
   exit 1
fi

print "`date +%Y-%m-%d` `date +%H:%M:%S` Pin Debit code assignment for institution $inst_id is complete."

mv $log_file $log_file-$inst_id-$file_date

cp $output_file ../MAS/MAS_FILES
mv $output_file ARCHIVE

exit 0
