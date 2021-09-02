#!/usr/bin/bash
. /clearing/filemgr/.profile

################################################################################
# $Id: ach_report.sh 4219 2017-06-27 12:31:24Z bjones $
# $Rev: 4219 $
################################################################################
#
#    File Name   -  ach_report.sh
#
#    Description -  This script initiates the generation of ACH reports for
#                   the sponsored banks.
#
#    Arguments   -i institution id
#                -f config file
#                -c cycle
#                -d Date to run the report, optional, e.g. 20140521
#                   This scripts can run with or without a date. If no date
#                   provided it will use sysdate to run the report.
#                   With a date argument, the script will run the report for a
#                   given date.
#                -a All times mode.  Optional.
#                -s Toggle summmary mode. Default on. Optional.
#                -t Test mode.  Optional.
#                -v Verbose mode. Increases debug level each usage.
#                -g Generate transaction based on the settl_date. Optional
#
#    Usage       -  ach_report.tcl -I nnn ... \[-D yyyymmdd\]...
#
#                   e.g.   ach_report.tcl -i 101
#                          ach_report.tcl -i 105 -d 20120421
#                          ach_report.tcl -i 107 -d 20120421 -c 5
#                          ach_report.tcl -i 107 -d 20191203 -c 5 -g 20191130
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
   echo "      -g  Generate transaction based on the settl_date."
   echo "      -m  Generates eom report based on last day of previous month."
   echo "Example - "
   echo "$programName.sh -i 107 -c 5 -d 20140601 -f ach_report.cfg"
}

##################################################
# Function - init()
# Description - Initialize the startup parameters
##################################################
init()
{
   progArgs=""
   while getopts i:c:d:f:g:amstv option
   do
     case $option in
       i) instId="$OPTARG" ;;
       c) cycle="$OPTARG" ;;
       d) runDate="$OPTARG" ;;
       f) cfgFile="$OPTARG" ;;
       g) glDate="$OPTARG" ;;
       a) progArgs="$progArgs -a" ;;
       m) progArgs="$progArgs -m" ;;
       s) progArgs="$progArgs -s" ;;
       t) progArgs="$progArgs -t" ;;
       v) progArgs="$progArgs -v" ;;

       ?) usage
          tail -40 $logFile | mutt -s "ACH Report failed" "$mail_err"
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

   if [ $cycle ]
   then
      progArgs="$progArgs -c $cycle"
   fi

   if [ $glDate ]
   then
      progArgs="$progArgs -g $glDate"
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
   echo " $instId ACH Report ran successfuly on `date +%Y/%m/%d@%H:%M:%S`" >> $logFile
   echo "*************************************" >> $logFile
else
   echo " $instId ACH Report run FAILED on `date +%Y/%m/%d@%H:%M:%S`" >> $logFile
   echo "*************************************" >> $logFile
   tail -40 $logFile | mutt -s "$instId ACH Report failed" "$mail_err"
   exit 1
fi

exit 0
