#!/usr/bin/ksh
. /clearing/filemgr/.profile

################################################################################
# $Id: payables_report_pl.sh 4425 2017-11-14 16:17:35Z bjones $
# $Rev: 4425 $
################################################################################
#
#    File Name   -  payables_report_pl.sh
#
#    Description -  This script generates payables or delayed funding reports
#                   by institution.
#
#    Arguments   -f config file
#                -d Date to run the report, optional  e.g. 20140521
#                   This scripts can run with or without a date. If no date
#                   provided it will use sysdate to run the report.
#                   With a date argument, the script will run the report for a
#                   given date.
#
#    Usage       -  payables_report.sh -D yyyymmdd -F config_file.cfg
#
#                   e.g.  payables_report.sh -d 20150315 -f test.cfg
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
          tail -40 $logFile | mutt -s "Payables Report failed" "$mail_err"
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
   echo " Payables Report ran successfuly on `date +%Y/%m/%d@%H:%M:%S`" >> $logFile
   echo "*************************************" >> $logFile
else
   echo "\n Payables Report run FAILED on `date +%Y/%m/%d@%H:%M:%S`" >> $logFile
   echo "*************************************" >> $logFile
   tail -40 $logFile | mutt -s "Payables Report failed" "$mail_err"
   exit 1
fi

exit 0
