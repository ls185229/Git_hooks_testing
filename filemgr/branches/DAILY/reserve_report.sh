#!/usr/bin/ksh
. /clearing/filemgr/.profile

################################################################################
# $Id: reserve_report.sh 3681 2016-02-19 22:17:42Z bjones $
# $Rev: 3681 $
################################################################################
#
#    File Name   -  reserve_report.sh
#
#    Description -  This script generates reserve reports by institution.
#
#    Arguments   -f config file
#                -d Date to run the report, optional  e.g. 20140521
#                   This scripts can run with or without a date. If no date
#                   provided it will use sysdate to run the report.
#                   With a date argument, the script will run the report for a
#                   given date.
#
#    Usage       -  reserve_report.sh -D yyyymmdd -F config_file.cfg
#
#                   e.g.   reserve_report.sh -d 2015032 -f test.cfg
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
   print "Usage: $programName.sh [-d Date optional] [-f Config file]"
   print "      -d = Date (YYYYMMDD). Optional. Defaults to current date"
   print "      -f = Config File. Optional"

   print "Example - "
   print "$programName.sh -d 20150601 -f $programName.cfg"
}

##################################################
# Function - init()
# Description - Initialize the startup parameters
##################################################
init()
{
   while getopts d:f: option
   do
     case $option in
       d) runDate="$OPTARG" ;;
       f) cfgFile="$OPTARG" ;;
       ?) usage
          tail -40 $logFile | mutt -s "Reserve Report failed" "$mail_err"
          exit 1;;
     esac
   done


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
   echo " Reserve Report ran successfuly on `date +%Y/%m/%d@%H:%M:%S`" >> $logFile
   echo "*************************************" >> $logFile
else
   echo "\n Reserve Report run FAILED on `date +%Y/%m/%d@%H:%M:%S`" >> $logFile
   echo "*************************************" >> $logFile
   tail -40 $logFile | mutt -s "Reserve Report failed" "$mail_err"
   exit 1
fi

exit 0

