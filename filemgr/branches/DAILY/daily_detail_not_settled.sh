#!/usr/bin/ksh
. /clearing/filemgr/.profile

################################################################################
# $Id: daily_detail_not_settled.sh 3681 2016-02-19 22:17:42Z bjones $
# $Rev: 3681 $
################################################################################
#
#    File Name   -  daily_detail_not_settled.sh
#
#    Description -  This is a custom report to aid balancing the daily 
#                   transactions processed. These transactions will be
#                   cleared by JetPay but not settled by them. The 
#                   settlement will be done by another entity such as SBC.
#                   The last table modified by these transactions will
#                   in_draft_main.
#
#    Arguments   -i institution id
#                -f config file
#                -d Date to run the report, optional  e.g. 20140521
#                   This scripts can run with or without a date. If no date
#                   provided it will use sysdate to run the report.
#                   With a date argument, the script will run the report for a
#                   given date.
#
#    Usage       -  daily_detail_not_settled.sh -I nnn ... \[-D yyyymmdd\]...
#
#                   e.g.   daily_detail_not_settled.sh -i 117
#                          daily_detail_not_settled.sh -i 117 -d 20120421
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
   print "      -d = Date (YYYYMMDD). Optional. Defaults to current date"
   print "      -f = Config File"

   print "Example - "
   print "$programName.sh -i 117 -d 20140601 -f $programName.cfg"
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
          tail -40 $logFile | mutt -s "Daily Detail Report (not settled) failed" "$mail_err"
          exit 1;;
     esac
   done

   if [ ! $instId ]
   then
      print "ERROR: Missing Institution ID"
      usage
      tail -40 $logFile | mutt -s "Daily Detail Report (not settled) failed - Missing Institution ID" "$mail_err"
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
   echo " $instId Daily Detail Report (not settled) ran successfuly on `date +%Y/%m/%d@%H:%M:%S`" >> $logFile
   echo "*************************************" >> $logFile
else
   echo "\n $instId Daily Detail Report (not settled) run FAILED on `date +%Y/%m/%d@%H:%M:%S`" >> $logFile
   echo "*************************************" >> $logFile
   tail -40 $logFile | mutt -s "$instId Daily Detail Report failed" "$mail_err"
   exit 1
fi

exit 0


