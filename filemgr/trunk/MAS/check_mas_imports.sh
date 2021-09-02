#!/usr/bin/bash

# $Id: check_mas_imports.sh 3585 2015-11-22 21:52:47Z bjones $

################################################################################
#
#    File Name - check_mas_imports.sh
#
#    Description - This is the shell wrapper script for check_mas_imports.tcl
#
#    Arguments - -i = institution_id
#                -g = Group of merchants.Optional,currently supports OKDMV only.
#                -d = run date YYYYMMDD optional, defaults to sysdate
#
#    Return - 0 = Success
#             1 = Fail
#
################################################################################

CRON_JOB=1
export CRON_JOB

source ~/.profile

## System variables ##
box=$SYS_BOX
sysinfo="System: $SYS_BOX\n Location: $PWD \n\n"

## Directory locations ##
locpth=$PWD

## GLOBAL VARIABLES ##
programName=`basename $0 .sh`
##num_args=$#
logFile=$locpth/LOG/$programName.log
mailFile=$locpth/$programName.mail


## Email Attributes ##

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

PRIORITY_EMAIL_LIST="clearing@jetpay.com assist@jetpay.com"
NON_PRIORITY_EMAIL_LIST="clearing@jetpay.com"
EMAIL_LIST=$PRIORITY_EMAIL_LIST

##################################################
# Function - usage()
# Description - Print the syntax for this script
##################################################

usage()
{
   echo "Usage:   $programName.sh <-i institution> <-g group> <-d run date>"
   echo "     where -d = Run date YYYYMMDD,optional. Defaults to sysdate"
   echo "           -i = institution"
   echo "           -g = group, user defined.Optional. Currently supports OKDMV only"
   echo "EXAMPLE = check_mas_imports.sh -i 107 -s OKDMV -d 20130910 -c 5"
}

##################################################
# Function - init()
# Description - Initialize the startup parameters
##################################################

init()
{

   while getopts i:d:g: option
   do
     case $option in
       i) instId="$OPTARG" ;;
       d) runDate="$OPTARG" ;;
       g) group="$OPTARG" ;;
       ?) usage
          exit 1;;
     esac
   done

   if [ ! $instId ]
   then
      echo "ERROR:Missing Argument : Need institution ID"
      usage
      exit 1
   fi


   progArgs="-i $instId"

   if [ $runDate ]
   then
      progArgs="$progArgs -d $runDate"
   fi

   if [ $group ]
   then
      progArgs="$progArgs -g $group"
   fi


   ### initialize log file

   echo "Executing $programName.sh on `date +%m/%d/%Y`" >> $logFile
   echo "Arguments passed $progArgs" >> $logFile
   echo "Executing $programName.sh on `date +%m/%d/%Y`" > $mailFile

}

##################################################
# Function - mail_someone
# Description - Send transaction information
##################################################

mail_someone()
{
   echo $1 | mutt -s "$subject - $reason" -- $EMAIL_LIST < $mailFile
   echo $1 | tee -a $logFile
}

##########
## MAIN ##
##########
init $*

check_mas_imports.tcl $progArgs >> $logFile
rc=$?

if [ $rc != 0 ]
then
   if [ $rc == 2 ]
   then
      subject=$msubj_u
      reason="ERROR $rc - MISSING MAS FILE $group"
      echo "\n Error occured while executing $programName.tcl" >> $mailFile
      echo "\n Check the log file  - $logFile" >> $mailFile
      echo "\n$mbody_u" >> $mailFile
      EMAIL_LIST=$PRIORITY_EMAIL_LIST
      mail_someone "$reason"
   elif [ $rc == 4 ]
   then
      subject=$msubj_l
      reason="WARNING $rc - Discrepency in the file count $group"
      echo "\n The actual file count is greater than expected. Check the log file" >> $mailFile
      EMAIL_LIST=$NON_PRIORITY_EMAIL_LIST
      mail_someone "$reason"
   else
      subject=$msubj_u
      reason="MAS FILE IMPORT CHECK - ERROR $rc "
      echo "\n Error occured while executing $programName.tcl" >> $mailFile
      echo "\n Check the log file  - $logFile" >> $mailFile
      echo "\n$mbody_u" >> $mailFile
      EMAIL_LIST=$PRIORITY_EMAIL_LIST
      mail_someone "$reason"
   fi
fi

exit 0
