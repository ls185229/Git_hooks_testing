#!/usr/bin/ksh
. /clearing/filemgr/.profile

################################################################################
# $Id: daily_detail_report.sh 4054 2017-02-06 23:16:14Z millig $
# $Rev: 4054 $
################################################################################
#
#    File Name   -  daily_detail_report.sh
#
#    Description -  This is a custom report used by accounting for
#                   balancing the daily transactions processed on
#                   clearing side.
#
#    Arguments   -i institution id
#                -f config file
#                -c cycle
#                -d Date to run the report, optional  e.g. 20140521
#                   This scripts can run with or without a date. If no date
#                   provided it will use sysdate to run the report.
#                   With a date argument, the script will run the report for a
#                   given date.
#
#    Usage       -  daily_detail_report.tcl -I nnn ... \[-D yyyymmdd\]...
#
#                   e.g.   daily_detail_report.tcl -i 101
#                          daily_detail_report.tcl -i 101 -d 20120421
#                          daily_detail_report.tcl -i 101 -c 2 -d 20120421
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
   print "      -i = Institution ID"
   print "      -c = Cycle"
   print "      -d = Date (YYYYMMDD). Optional. Defaults to current date"
   print "      -f = Config File"

   print "Example - "
   print "$programName.sh -i 107 -c 5 -d 20140601 -f daily_detail.cfg"
}

##################################################
# Function - init()
# Description - Initialize the startup parameters
##################################################
init()
{
   while getopts i:c:d:f: option
   do
     case $option in
       i) instId="$OPTARG" ;;
       c) cycle="$OPTARG" ;;
       d) runDate="$OPTARG" ;;
       f) cfgFile="$OPTARG" ;;
       ?) usage
          tail -40 $logFile | mutt -s "Daily Detail Report failed" "$mail_err"
          exit 1;;
     esac
   done

   if [ ! $instId ]
   then
      print "ERROR: Missing Institution ID"
      usage
      tail -40 $logFile | mutt -s "Daily Detail Report failed - Missing Institution ID" "$mail_err"
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

   if [ $cycle ]
   then
      progArgs="$progArgs -c $cycle"
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
   echo " $instId Daily Detail Report ran successfuly on `date +%Y/%m/%d@%H:%M:%S`" >> $logFile
   echo "*************************************" >> $logFile
else
   echo "\n $instId Daily Detail Report run FAILED on `date +%Y/%m/%d@%H:%M:%S`" >> $logFile
   echo "*************************************" >> $logFile
   tail -40 $logFile | mutt -s "$instId Daily Detail Report failed" "$mail_err"
   exit 1
fi

exit 0


