#!/usr/bin/ksh
. /clearing/filemgr/.profile
 
######################################################################################################################
# $Id: amex_sales_performance.sh 3696 2016-02-25 18:16:05Z fcaron $
# $Rev: 3696 $
######################################################################################################################
#
#    File Name:    amex_sales_performance.sh
#
#    Description:  American Express Sales Performance Report
#                  Reports every merchant in 101, 105, 107, 117, 121 that is active and 
#                  boraded in the previous month and has a value in CORE.ENTITY_ADDON.AMEX_OPT_BLUE_SALES_DISPOSITION 
#                  of Y or N
#                  Default date is sysdate. You can not run this report for older dates.
# 
#    Return:       0 = Success
#                  1 = Fail
#
#######################################################################################################################

CRON_JOB=1
export CRON_JOB

## Directory locations ##
locpth=$PWD

## GLOBAL VARIABLES ##
file_date=`date +%Y%m%d`
arch_date=`date +%Y%m%d.%H%M%S`
programName=`basename $0 .sh`
today=$(date +"%Y%m%d")

logFile=$locpth/LOG/amex_sales_performance.log

mail_to="Reports-clearing@jetpay.com,boarding@jetpay.com,trent@jetpay.com,accounting@jetpay.com"
mail_err=$EMAIL_ALERT

##################################################
# Function - usage()
# Description - Print the syntax for this script
##################################################

usage()
{
   print "Usage:    $programName.sh "
   print "          Default date is sysdate. "
   print "EXAMPLE = amex_sales_performance.sh "
}

##################################################
# Function - init()
# Description - Initialize the startup parameters
##################################################

init()
{
   while getopts d:h: option
   do
     case $option in
       h) usage
          exit 1;;
     esac
   done


   ### initialize log file

   print "Executing $programName.sh on `date +%Y/%m/%d@%H:%M:%S`" >> $logFile
   print "\nArguments passed $progArgs" >> $logFile

}


##########
## MAIN ##
##########

init $*

amex_sales_performance.tcl $progArgs >> $logFile

if [ $? != 0 ]; then
   echo "\nAMEX Sales Performance Report run FAILED on `date +%Y/%m/%d@%H:%M:%S`" >> $logFile
   echo "***********************************************************************" >> $logFile
   tail -20 $logFile | mutt -s "AMEX Sales Performance Report failed" $mail_err
else
   echo "\nAMEX Sales Performance Report ran successfully on `date +%Y/%m/%d@%H:%M:%S`" >> $logFile
   echo "***********************************************************************" >> $logFile

   cp ./UPLOAD/JETPAYPRD.SALES ./ARCHIVE/JETPAYPRD.SALES.$arch_date
   sleep 2
   cd ./UPLOAD 
   upload.exp JETPAYPRD.SALES
   sleep 2
   cd ..
   email_file="amex_sales_performance_report_$today.txt"
   cp ./UPLOAD/JETPAYPRD.SALES $email_file 
   sleep 2

   echo "Please see attached." | mutt -a "$email_file" -s "AMEX Opt Blue Sales Performance Report $today" -- "$mail_to"
   rm $email_file
   rm ./UPLOAD/JETPAYPRD.SALES
fi

mv $log_file $log_file-$file_date

exit 0

