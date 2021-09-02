#!/usr/bin/bash
. /clearing/filemgr/.profile

################################################################################
# $Id: financial_position.sh 4776 2018-11-29 16:34:21Z bjones $
# $Rev: 4776 $
################################################################################
#
#    File Name   -  payables_report_pl.sh
#
#    Description -  This script generates payables or delayed funding reports
#                   by institution.
#
#    Arguments   -i institution id
#                -f config file
#                -d Date to run the report, optional  e.g. 20140521
#                   This scripts can run with or without a date. If no date
#                   provided it will use sysdate to run the report.
#                   With a date argument, the script will run the report for a
#                   given date.
#                -a All times mode.  Optional.
#                -s Toggle summmary mode. Default on. Optional.
#                -t Test mode.  Optional.
#                -v Verbose mode. Increases debug level each usage.
#
#    Usage       -  payables_report.sh -D yyyymmdd -F config_file.cfg
#
#                   e.g.  payables_report.sh -d 20150315 -f test.cfg
#
################################################################################

CRON_JOB=1
export CRON_JOB

source $MASCLR_LIB/mas_env.sh
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
   echo "Usage: $programName.sh [-i institution] [-d Date optional] [-f Config file]"
   echo "      -i = Institution ID"
   echo "      -c = Cycle"
   echo "      -d = Date (YYYYMMDD). Optional. Defaults to current date"
   echo "      -f = Config File"
   echo ""
   echo "      -a  All times mode.  Optional."
   echo "      -s  Toggle summmary mode. Default on. Optional."
   echo "      -t  Test mode.  Optional."
   echo "      -v  Verbose mode. Increases debug level each usage."

   print "Example - "
   print "$programName.sh -d 20150601 -f $programName.cfg"
}

##################################################
# Function - init()
# Description - Initialize the startup parameters
##################################################
init()
{
   progArgs=""
   while getopts i:c:d:f:astv option
   do
     case $option in
       i) instId="$OPTARG" ;;
       c) cycle="$OPTARG" ;;
       d) runDate="$OPTARG" ;;
       f) cfgFile="$OPTARG" ;;
       a) progArgs="$progArgs -a" ;;
       s) progArgs="$progArgs -s" ;;
       t) progArgs="$progArgs -t" ;;
       v) progArgs="$progArgs -v" ;;
       ?) usage
          tail -40 $logFile | mutt -s "Payables Report failed" "$mail_err"
          exit 1;;
     esac
   done

   if [ ! $instId ]
   then
      echo "ERROR: Missing Institution ID"
      usage
      tail -40 $logFile | mutt -s "ACH Report failed - Missing Institution ID" "$mail_err"
      exit 1
   fi

   progArgs="$progArgs -i $instId "

   if [ -n "$cfgFile" ]
   then
      progArgs="$progArgs -f $cfgFile"
   fi

   if [ $runDate ]
   then
      progArgs="$progArgs -d $runDate"
   fi

   ### initialize log file

   echo " ************************************" >> $logFile
   echo " Executing $programName.sh on `date +%m/%d/%Y@%H:%M:%S`" >> $logFile
   echo " Arguments passed $progArgs" >> $logFile

}


##########
## MAIN ##
##########

init $*

$programName.tcl $progArgs >> $logFile

if [ $? -eq 0 ]; then
   echo " $instId Payables Report ran successfuly on `date +%Y/%m/%d@%H:%M:%S`" >> $logFile
   echo "*************************************" >> $logFile
else
   echo "\n $instId Payables Report run FAILED on `date +%Y/%m/%d@%H:%M:%S`" >> $logFile
   echo "*************************************" >> $logFile
   tail -40 $logFile | mutt -s "$instId Payables Report failed" "$mail_err"
   exit 1
fi

exit 0
