#!/usr/bin/ksh
. /clearing/filemgr/.profile

# $Id: check_acct_accum_det.sh 3223 2015-07-27 15:13:30Z fcaron $

################################################################################
#
#    File Name - check_acct_accum_det.sh
#
#    Description - This is the shell wrapper script for check_acct_accum_det.tcl 
#                 
#    Arguments - -i = institution_id
#                -s = short name
#                -d = run date YYYYMMDD optional, defaults to sysdate
#                -c = payment cycle,optional. Defaults to cycle = 1
#
#    Return - 0 = Success
#             1 = Fail
#
################################################################################

CRON_JOB=1
export CRON_JOB

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
   print "Usage:   $programName.sh <-i institution> <-s shortname> <-d date> <-c cycle>"
   print "     where -d = Run date YYYYMMDD,optional. Defaults to sysdate"
   print "           -i = institution"
   print "           -s = shortname"
   print "           -c = Payment cycle, optional. Defaults to 1"
   print "EXAMPLE = check_acct_accum_det.sh -i 107 -s OKDMV -d 20130910 -c 5"
}

##################################################
# Function - init()
# Description - Initialize the startup parameters
##################################################

init()
{

   while getopts i:c:f:d:s: option
   do
     case $option in
       i) instId="$OPTARG" ;;
       d) runDate="$OPTARG" ;;
       s) shortname="$OPTARG" ;;
       c) cycle="$OPTARG" ;;
       ?) usage
          exit 1;;
     esac
   done

   print "T-1 inst-$instId $shortname"
   if [ ! $instId ]
   then
      print "ERROR:Missing Argument : Need institution ID"
      usage
      exit 1
   fi

   if [ ! $shortname ]
   then
      print "ERROR:Missing Argument : Need a shortname like JETPAY,OKDMV"
      usage
      exit 1
   fi


   progArgs="-i $instId -s $shortname"

   if [ $runDate ]
   then
      progArgs="$progArgs -d $runDate"
   fi

   if [ $cycle ]
   then
      progArgs="$progArgs -c $cycle"
   fi


   ### initialize log file

   print "Executing $programName.sh on `date +%m/%d/%Y`" >> $logFile
   print "Arguments passed $progArgs" >> $logFile
   print "Executing $programName.sh on `date +%m/%d/%Y`" > $mailFile

}

##################################################
# Function - mail_someone
# Description - Send transaction information
##################################################

mail_someone()
{
   echo $1 | mutt -s "$subject - $reason" $EMAIL_LIST < $mailFile
   print $1 | tee -a $logFile
}

##########
## MAIN ##
##########
init $*

check_acct_accum_det.tcl $progArgs >> $logFile
rc=$?

if [ $rc != 0 ]
then
   subject=$msubj_u
   reason="ACCT_ACCUM_DET check failed for $shortname $instId"
   print "\n Error occured while executing $programName.tcl" >> $mailFile
   print "\n Check the log file  - $logFile" >> $mailFile
   print "\n$mbody_u" >> $mailFile
   EMAIL_LIST=$PRIORITY_EMAIL_LIST
   mail_someone "$reason"
 
fi

exit 0


