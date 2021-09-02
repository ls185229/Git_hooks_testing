#!/usr/bin/ksh

################################################################################
# $Id: mas_split_fund_file.sh 4503 2018-03-23 16:02:00Z bjones $
################################################################################
#
#    File Name - mas_split_fund_file.sh
#
#    Description - Wrapper script for the tcl code that creates a MAS file to
#                  split funds based on a fixed amount
#
#
#    Arguments - -c = config file, optional
#                -i - institution id
#                -f = input file name that has merchant info
#                -d = settle date, optional
#                -t = test mode, optional
#                -v = increase verbosity/debug level, optional
#    Example - mas_split_fund_file.sh -i 101 -f 101MerchList.txt
#
#
#    Output - MAS file 101.SPLITFND.01.<jdate>.<seq>
#
#
#    Return - 0 = Success
#             1 = Fail
#
################################################################################

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile > /dev/null

#System variables
box=$SYS_BOX
sysinfo="System: $SYS_BOX\n Location: $PWD \n\n"

## Email Attributes

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

#T-1 change the email list to clearing

##PRIORITY_EMAIL_LIST="jaymalag@jetpay.com"
##NON_PRIORITY_EMAIL_LIST="jaymalag@jetpay.com"
PRIORITY_EMAIL_LIST="clearing@jetpay.com assist@jetpay.com"
NON_PRIORITY_EMAIL_LIST="clearing@jetpay.com"
EMAIL_LIST=$PRIORITY_EMAIL_LIST
subject=$msubj_u
body=$mbody_u
reason="Check $programName process"

### PROGRAM ARGUMENT
programName=`basename $0 .sh`
numArgs=$#

###Files and Directory
locPath=/clearing/filemgr/MAS/SPLIT_FUNDS
mailFile=$locPath/$programName.mail
logFile=$locPath/LOG/$programName.log

### GLOBAL VARIABLES

##################################################
# Function - usage()
# Description - Print the syntax for this script
##################################################
usage()
{
   print "Usage: $programName.sh [-i institution] [-c Config file] [-f input file Name] [-d Date optional]"
   print "      -i = institution ID"
   print "      -c = Config File"
   print "           Reserved for future use"
   print "      -f = <path>/<filename> File that has the merchant information"
   print "      -d = Date (YYYYMMDD). Optional. Defaults to current date"
   print "    options -v (verbosity) & -t (test mode)"

   print "Example - "
   print "$programName.sh -i 101 -f 101MerchList.txt"
}

##################################################
# Function - init()
# Description - Initialize the startup parameters
##################################################
init()
{
   verbosity=""
   while getopts i:c:f:d:tv option
   do
     case $option in
       i) instId="$OPTARG" ;;
       c) cfgFile="$OPTARG" ;;
       f) inputFile="$OPTARG" ;;
       d) runDate="$OPTARG" ;;
       t) runMode="TEST" ;;
       v) verbosity="$verbosity -v" ;;
       ?) usage
          exit 1;;
     esac
   done

   if [ ! $instId ]
   then
      print "ERROR:Missing Argument : Need institution ID"
      usage
      exit 1
   fi

   if [ ! $inputFile ]
   then
      print "ERROR:Missing Argument : Need a input file, Eg- 101MerchList.txt"
      usage
      exit 1
   fi

   progArgs="-i $instId -f $inputFile"

   if [ -n "$cfgFile" ]
   then
      progArgs="$progArgs -c $cfgFile"
   fi

   if [ $runDate ]
   then
      progArgs="$progArgs -d $runDate"
   fi

   if [ "$verbosity" != "" ]
   then
      progArgs="$progArgs $verbosity"
   fi

   if [ runMode == "TEST" ]
   then
      progArgs="$progArgs -t"
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
   echo $1 | mailx -s "$subject - $reason" $EMAIL_LIST < $mailFile
   print $1 | tee -a $logFile
}

##########
## MAIN ##
##########
init $*

$locPath/mas_split_fund_file.tcl $progArgs >> $logFile
rc=$?
if [ $rc != 0 ]
then
   if [ $rc == 1 ]
   then
      subject=$msubj_u
      reason="SPLIT FUNDING MAS FILE ERROR"
      print "\n Error occured within mas_split_fund_file.tcl " >> $mailFile
      print "\n Check the log file  - $logFile" >> $mailFile
      print "\n$mbody_u" >> $mailFile
      EMAIL_LIST=$PRIORITY_EMAIL_LIST
      mail_someone "$reason"
   fi
fi

exit 0
