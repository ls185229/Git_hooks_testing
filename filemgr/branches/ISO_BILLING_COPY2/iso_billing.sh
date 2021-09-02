#!/usr/bin/bash
. /clearing/filemgr/.profile

################################################################################
# $Id: iso_billing.sh 3757 2016-05-02 17:31:05Z bjones $
# $Rev: 3757 $
################################################################################
#
#    File Name    - iso_billing.sh
#
#    Description  - This is a custom monthly report for generating ISO Billing
#                   by card type.
#    Arguments   -i institution id
#                -f config file
#                -v increase the verbosity (debug level)
#                -t test mode
#                -d Date to run the report, optional  e.g. 20140501
#                   This scripts can run with or without a date. If no date
#                   provided it will run the report for the previous month.
#                   With a date argument, the script will run the report for
#                   a given month.
#
################################################################################

CRON_JOB=1
export CRON_JOB

err_mailto="clearing@jetpay.com"

locpth=$PWD
logFile=$locpth/LOG/iso_billing.log

### PROGRAM ARGUMENT
programName=`basename $0 .sh`
numArgs=$#

source $MASCLR_LIB/mas_env.sh

##################################################
# Function - usage()
# Description - Print the syntax for this script
##################################################
usage()
{
   echo "Usage: $programName.sh [-i institution] [-d Date optional] [-f Config file]"
   echo "      -i = institution ID"
   echo "      -d = Date (YYYYMMDD). Optional. Defaults to current date"
   echo "      -f = Config File"
   echo "      -t   turn on TEST mode"
   echo "      -v   increase verbosity (debug level)"

   echo "Example - "
   echo "$programName.sh -i 107 -d 20140601 -f iso_billing.cfg"
}

##################################################
# Function - init()
# Description - Initialize the startup parameters
##################################################
init()
{
   verboseArg=""
   testmodeArg=""
   while getopts "i:d:f:tv" option
   do
     case $option in
       i) instId="$OPTARG" ;;
       d) runDate="$OPTARG" ;;
       f) cfgFile="$OPTARG" ;;
       t)
          testmodeArg="-t "
          err_mailto=$MAIL_TO_FAILURE
            ;;
       v) verboseArg="$verboseArg -v " ;;
       ?) usage
          tail -40 $logFile | mutt -s "ISO Billing Report failed" -- "$err_mailto"
          exit 1;;
     esac
   done

   if [ ! $instId ]
   then
      echo "ERROR:Missing Argument : Need institution ID"
      usage
      tail -40 $logFile | mutt -s "ISO Billing Report failed" -- "$err_mailto"
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

   progArgs="$progArgs $verboseArg $testmodeArg"

   ### initialize log file

   echo "\n************************************" >> $logFile
   echo " Executing $programName.sh on `date +%m/%d/%Y@%H:%M:%S`" >> $logFile
   echo " Arguments passed $progArgs" >> $logFile

}


##########
## MAIN ##
##########

init $*

iso_billing.tcl $progArgs >> $logFile

if [ $? -eq 0 ]; then
   echo "\n ISO Billing Report ran successfuly on `date +%Y/%m/%d@%H:%M:%S`" >> $logFile
   echo "*************************************" >> $logFile
else
   echo "\n ISO Billing Report run FAILED on `date +%Y/%m/%d@%H:%M:%S`" >> $logFile
   echo "*************************************" >> $logFile
   tail -40 $logFile | mutt -s "ISO Billing Report failed" -- "$err_mailto"
   exit 1
fi

exit 0
