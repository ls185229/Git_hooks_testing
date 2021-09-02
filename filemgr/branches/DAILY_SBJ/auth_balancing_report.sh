#!/usr/bin/ksh
. /clearing/filemgr/.profile

################################################################################
# $Id: auth_balancing_report.sh 4649 2018-07-20 21:10:32Z bjones $
# $Rev: 4649 $
################################################################################
#
#    File Name   -  auth_balancing_report.sh
#
#    Description -  This is a custom report used by accounting for
#                   daily balancing of Auth by institution and card type.
#
#                   The window used for this report is from: 04 AM yesterday
#                   to 04 AM today.
#
#                   For the list of request types please see:
#                   sysnet.jetpay.com/wiki/Message_Types
#
#    Arguments   -i institution id
#                -f config file
#                -d Date to run the report, optional  e.g. 20140521
#                   This scripts can run with or without a date. If no date
#                   provided it will use sysdate to run the report.
#                   With a date argument, the script will run the report for a
#                   given date.
#
################################################################################

CRON_JOB=1
export CRON_JOB

mail_err="clearing@jetpay.com"

### PROGRAM ARGUMENT
programName=`basename $0 .sh`
numArgs=$#
today=$(date +"%Y%m%d")

locpth=$PWD
logFile=$locpth/LOG/$programName.log

##################################################
# Function - usage()
# Description - Print the syntax for this script
##################################################
usage()
{
   print "Usage: $programName.sh [-i institution] [-d Date optional] [-f Config file]"
   print "      -i = institution ID"
   print "      -d = Date (YYYYMMDD). Optional. Defaults to current date"
   print "      -f = Config File"

   print "Example - "
   print "$programName.sh -i 107 -d 20140601 -f auth_balancing.cfg"
}

##################################################
# Function - init()
# Description - Initialize the startup parameters
##################################################
init()
{
   while getopts i:d:f: option
   do
     case $option in
       i) instId="$OPTARG" ;;
       d) runDate="$OPTARG" ;;
       f) cfgFile="$OPTARG" ;;
       ?) usage
          tail -40 $logFile | mutt -s "AUTH Balancing Report failed" -- "$mail_err"
          exit 1;;
     esac
   done

   if [ ! $instId ]
   then
      print "ERROR: Missing institution ID"
      usage
      tail -40 $logFile | mutt -s "AUTH Balancing Report failed - Missing Institution ID" -- "$mail_err"
      exit 1
   fi

   progArgs="-i $instId "

   if [ -n "$cfgFile" ]
   then
      progArgs="$progArgs -f $cfgFile"
   fi

   if [ $runDate ]
   then
      progArgs="$progArgs -d $runDate"
   fi


   ### initialize log file

   print "\n************************************" >> $logFile
   print " Executing $programName.sh on `date +%m/%d/%Y@%H:%M:%S`" >> $logFile
   print " Arguments passed $progArgs" >> $logFile

}


##########
## MAIN ##
##########

init $*

$programName.tcl $progArgs >> $logFile

if [ $? -eq 0 ]; then
   echo " $instId AUTH Balancing Report ran successfuly on `date +%Y/%m/%d@%H:%M:%S`" >> $logFile
   echo "*************************************" >> $logFile
else
   echo "\n $instId AUTH Balancing Report run FAILED on `date +%Y/%m/%d@%H:%M:%S`" >> $logFile
   echo "*************************************" >> $logFile
   tail -40 $logFile | mutt -s "$instId AUTH Balancing Report failed" "$mail_err"
   exit 1
fi

exit 0


