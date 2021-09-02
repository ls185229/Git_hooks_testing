#!/usr/bin/ksh
. /clearing/filemgr/.profile
 
#########################################################################################
# $Id: wells_liability_report.sh 4605 2018-06-06 17:25:20Z bjones $
# $Rev: 4605 $
#########################################################################################
#
#    File Name     wells_liability_report.sh
#
#    Description   This is a custom report for wells fargo to display
#                  transactions that fall outside of normal liability.
#                  Default date is sysdate. 
#
#    Arguments     $1 Date to run the report. e.g. 201405
#                  This scripts can run with or without a date. If no date
#                  provided it will use start and end of the last month. With
#                  one date argument, the script will calculatethe month start
#                  and end based on the given date.
#
#    Example       With date argument:  wells_liability_report.sh -d 20140501       
# 
#    Return        0 = Success
#                  1 = Fail
#  
#########################################################################################

CRON_JOB=1
export CRON_JOB

## Directory locations ##
locpth=$PWD

## GLOBAL VARIABLES ##
programName=`basename $0 .sh`
today=$(date +"%Y%m%d")

logFile=$locpth/LOG/$programName.log

mail_err="clearing@jetpay.com"

##################################################
# Function - usage()
# Description - Print the syntax for this script
##################################################

usage()
{
   print "Usage:    $programName.sh "
   print "          Default date is sysdate. "
   print "Example - "
   print "$programName.sh "
}

##################################################
# Function - init()
# Description - Initialize the startup parameters
##################################################

init()
{
   while getopts d:h: option
   do
     case $option in
       d) runDate="$OPTARG" ;;
       h) usage
          exit 1;;
     esac
   done

   if [ $runDate ]
   then
      progArgs="$progArgs -d $runDate"
   fi

   ### initialize log file

   print "\n************************************" >> $logFile
   print "Executing $programName.sh on `date +%m/%d/%Y@%H:%M:%S`" >> $logFile
   print "Arguments passed $progArgs" >> $logFile
}

##########
## MAIN ##
##########

init $*

$programName.tcl $progArgs >> $logFile

if [ $? -eq 0 ]; then
   echo "\nWells Fargo Liability Report ran successfuly on `date +%Y/%m/%d@%H:%M:%S`" >> $logFile
   echo "*************************************" >> $logFile
else
   echo "\nWells Fargo Liability Report run FAILED on `date +%Y/%m/%d@%H:%M:%S`" >> $logFile
   echo "*************************************" >> $logFile
   tail -40 $logFile | mutt -s "Wells Fargo Liability Report failed" "$mail_err"
   exit 1
fi

exit 0

