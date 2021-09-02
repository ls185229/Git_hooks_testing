#!/usr/bin/ksh
. /clearing/filemgr/.profile

################################################################################
# $Id: amex_prefunding_report.sh 4054 2017-02-06 23:16:14Z millig $
# $Rev: 4054 $
################################################################################
#
#    File Name   - amex_prefunding_report.sh
#
#    Description - This is a custom report for counting AMEX transactions that 
#                  were generated between 1:00 AM and 6:00 AM
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

err_mailto="clearing@jetpay.com"

locpth=$PWD
logFile=$locpth/LOG/amex_prefunding.log

### PROGRAM ARGUMENT
programName=`basename $0 .sh`
numArgs=$#

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
   print "$programName.sh -i 107 -d 20140601 -f amex_prefunding.cfg"
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
          exit 1;;
     esac
   done

   if [ ! $instId ]
   then
      print "ERROR:Missing Argument : Need institution ID"
      usage
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

amex_prefunding_report.tcl $progArgs >> $logFile

if [ $? -eq 0 ]; then
   echo "\n Amex PreFunding Report ran successfuly on `date +%Y/%m/%d@%H:%M:%S`" >> $logFile
   echo "*************************************" >> $logFile
else
   echo "\n Amex PreFunding Report run FAILED on `date +%Y/%m/%d@%H:%M:%S`" >> $logFile
   echo "*************************************" >> $logFile
   tail -20 $logFile | mutt -s "AMEX PreFunding Report failed" -- "$err_mailto"

fi

exit 0

