#!/usr/bin/ksh

################################################################################
# $Id: mas_conv_charge_file.sh 4421 2017-11-10 22:46:30Z bjones $
# $Rev: 4421 $
# $Author: bjones $
################################################################################
#
#    File Name - mas_conv_charge_file.sh
#
#    Description - Wrapper script for the tcl code that creates a MAS file to
#                  for Convenience Charge
#
#
#    Arguments - -c = config file, optional
#                -i - institution id
#                -s = shortname
#                -f = input file name that has merchant info
#                -d = settle date, optional
#    Example - mas_conv_charge_file.sh -i 107 -s OKDMV -c mas_conv_charge_file.cfg
#
#
#    Output - MAS file 107.CONVCHRG.01.<jdate>.<seq>
#
#
#    Return - 0 = Success
#             1 = Fail
#
################################################################################

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

#System variables
box=$SYS_BOX
sysinfo="System: $SYS_BOX\n Location: $PWD \n\n"

## Email Attributes

msubj_c="$SYS_BOX :: Priority : Critical - Clearing and Settlement"
msubj_u="$SYS_BOX :: Priority : Urgent - Clearing and Settlement"
msubj_h="$SYS_BOX :: Priority : High - Clearing and Settlement"
msubj_m="$SYS_BOX :: Priority : Medium - Clearing and Settlement"
msubj_l="$SYS_BOX :: Priority : Low - Clearing and Settlement"

mbody_c="ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
mbody_u="ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
mbody_h="ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
mbody_m="ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
mbody_l="ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"


### PROGRAM ARGUMENT
programName=`basename $0 .sh`
numArgs=$#


PRIORITY_EMAIL_LIST="clearing@jetpay.com assist@jetpay.com"
NON_PRIORITY_EMAIL_LIST="clearing@jetpay.com"
EMAIL_LIST=$PRIORITY_EMAIL_LIST
subject=$msubj_u
body=$mbody_u
reason="Check $programName process"

###Files and Directory
locPath=/clearing/filemgr/MAS/CONV_CHARGE
mailFile=$locPath/$programName.mail
logFile=$locPath/LOG/$programName.log

### GLOBAL VARIABLES

##################################################
# Function - usage()
# Description - Print the syntax for this script
##################################################
usage()
{
   print "Usage: $programName.sh [-i institution] [-s shortname] [-c Config file] "
   print "      [-f input file Name] [-d Date optional]"
   print "      "
   print "      -i = institution ID"
   print "      -s = shortname"
   print "      -c = Config File"
   print "           Reserved for future use"
   print "      -f = <path>/<filename> File that has the merchant information"
   print "      -d = Date (YYYYMMDD). Optional. Defaults to current date"
   print "      -v   Optional. Increases debug level. -v -v -v means debug level 3."

   print "Example - "
   print "$programName.sh -i 107 -s OKDMV -c mas_conv_charge_file.cfg"
}

##################################################
# Function - init()
# Description - Initialize the startup parameters
##################################################
init()
{
   debug_level=0
   while getopts i:c:f:d:s:v option
   do
     case $option in
       i) instId="$OPTARG" ;;
       c) cfgFile="$OPTARG" ;;
       f) inputFile="$OPTARG" ;;
       d) runDate="$OPTARG" ;;
       s) shortname="$OPTARG" ;;
       v) debug_level=`expr $debug_level + 1` ;;
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
   
   # Input file is no longer used. 
   # if [ ! $inputFile ]
   # then
   #    print "ERROR:Missing Argument : Need a input file, Eg- MMID_LIST_107.txt "
   #    usage
   #    exit 1
   # fi

   # Shortname is optional argument.   
   #if [ ! $shortname ]
   #then
   #   print "ERROR:Missing Argument : Need a shortname like JETPAY,OKDMV"
   #   usage
   #   exit 1
   #fi

   progArgs="-i $instId -s $shortname -v $debug_level"

   if [ -n "$inputFile " ]
   then
      progArgs="$progArgs -f $inputFile "
   fi

   if [ -n "$cfgFile" ]
   then
      progArgs="$progArgs -c $cfgFile"
   fi

   if [ $runDate ]
   then
      progArgs="$progArgs -d $runDate"
   fi


   ### initialize log file

   print "Executing $programName.sh on `date +%m/%d/%Y`" >> $logFile
   print "Arguments passed $progArgs" >> $logFile
   print "Executing $programName.sh on `date +%m/%d/%Y`" > $mailFile

}

##################################################
# Function - mail_someone
# Description - Send transaction information
##################################################
mail_someone()
{
   echo $1 | mailx -s "$subject - $reason" $EMAIL_LIST < $mailFile
   print $1 | tee -a $logFile
}

##########
## MAIN ##
##########
init $*

$locPath/mas_conv_charge_file.tcl $progArgs >> $logFile
rc=$?
if [ $rc != 0 ]
then
   subject=$msubj_u
   reason="MAS FILE ERROR - CONVENIENCE CHARGE - $rc"
   print "\n Error occured within $programName.tcl " >> $mailFile
   print "\n Check the log file  - $logFile" >> $mailFile
   print "\n$mbody_u" >> $mailFile
   EMAIL_LIST=$PRIORITY_EMAIL_LIST
   mail_someone "$reason"
fi

exit 0
