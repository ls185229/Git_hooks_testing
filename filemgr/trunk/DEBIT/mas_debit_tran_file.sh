#!/usr/bin/ksh

################################################################################
#
#    File Name - mas_debit_tran_file.sh 
#
#    Description - This is a startup script for tcl process that generats 
#                  file for MAS-DEBIT import.
#
#    Arguments - $1 = Institution ID
#                $2 = Run file date (YYYYMMDD), optional.
#                     Defaults to current date.
#
#    Return - 0 = Success
#             1 = Fail
#
################################################################################
# $Id: mas_debit_tran_file.sh 3512 2015-09-22 21:33:12Z bjones $
# $Rev: 3512 $
# $Author: bjones $
################################################################################

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

#add svn variables

#System variables
box=$SYS_BOX
sysinfo="System: $SYS_BOX\n Location: $PWD \n\n"

#Directory locations
locpth=/clearing/filemgr/DEBIT


## Email Attributes 

PRIORITY_EMAIL_LIST="clearing@jetpay.com assist@jetpay.com"
NON_PRIORITY_EMAIL_LIST="notifications-clearing@jetpay.com"

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

#File variables
file_name=mas_debit_tran_file.sh
file_date=`date +%Y%m%d`
file_time=`date +%H%M%S`
log_file=$locpth/LOG/mas_debit_tran_file.log
cfg_file=$locpth/mas_debit_tran_file.cfg
mail_file=$locpth/mas_debit_tran_file.mail

## Global variable

inst_id=$1
run_date=$2
num_args=$#

##################################################
# Function - usage()
# Description - Print the syntax for this script
##################################################
usage()
{
   print "Usage: $file_name <Institution ID> <run file date> "
   print "       Institution ID = The institution id to be processed"
   print "       run file date = Processed date (YYYYMMDD), optional"
   print "                       Default - current date\n"
}

##################################################
# Function - init()
# Description - Initialize the startup parameters
##################################################
init()
{
   print "Starting $file_name on `date +%m/%d/%Y`" >> $log_file

   if [[ $num_args -lt 1  || $num_args -gt 2 ]]
   then
      usage
      print "Usage Err: Incorrect number of arguments passed" | tee -a $log_file
      exit 1
   else
      if [ ! $run_date ]
      then
         run_date=`date +%Y%m%d`
         #yesterday=`perl -e '@T=localtime(time-86400);printf("%04d%02d%02d",($T[5]+ 1900),$T[4]+1,$T[3])'`
         #run_date=$yesterday
      fi 
   fi

   if [ ! -e $cfg_file ]
   then
      print "Err: Config file not present" | tee -a $log_file
      exit 1
   fi

   ## Determine the shortname ##
  
   case "$inst_id"
   in
      "101")
          shortname="JETPAY" 
          break ;;
      "105")
          shortname="JETPAYSQ" 
          break ;;
      "107")
          shortname="JETPAYIS" 
          break ;;
      "121")
          shortname="JETPAYESQ" 
          break ;;
      "802")
          shortname="JETPAYAQ"
          break ;;
      "808")
          shortname="IPCLEARING" 
          break ;;
      *)
          print "Err: Shortname not found for institution ID=$inst_id" |tee -a $log_file
          exit 1 ;;
   esac

   print "Institution ID = $inst_id \nshortname = $shortname \nrun date = $run_date \nconfig file = $cfg_file " >> $log_file
   print "Executing mas_debit_tran_file.tcl" > $mail_file
}

##################################################
# Function - alert_someone()
# Description - Send an alert email
##################################################
alert_someone()
{
   echo $1 | mailx -r clearing@jetpay.com -s "$msubj_h" $PRIORITY_EMAIL_LIST
   print $1 | tee -a $log_file
}


##################################################
# Function - notify_someone
# Description - Send a notification of processing status
##################################################
notify_someone()
{
   echo "$1" | mailx -r clearing@jetpay.com -s "$msubj_c $1" $PRIORITY_EMAIL_LIST < $mail_file
   print $1 | tee -a $log_file
}

##################################################
# Function - mail_someone
# Description - Send transaction information
##################################################
mail_someone()
{
   echo $1 | mailx -s "$msubj_l - Acculynk MAS file created for $run_date" $NON_PRIORITY_EMAIL_LIST < $mail_file
   print $1 | tee -a $log_file
}

##########
## MAIN ##
##########

init

./mas_debit_tran_file.tcl $inst_id $shortname $run_date $cfg_file $log_file $mail_file >> $log_file
rc=$?
if [ $rc -ne 0 ]
then
   print "Error occured while executing mas_debit_tran_file.tcl" >> $mail_file
   print "\n$mbody_c" >> $mail_file
   notify_someone "Acculynk MAS file build error"
fi

exit 0
