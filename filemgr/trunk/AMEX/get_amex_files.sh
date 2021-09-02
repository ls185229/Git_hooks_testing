#!/usr/bin/ksh

##################################################################################
#   # $Id: get_amex_files.sh 4908 2019-10-16 04:25:20Z bjones $  #
#                                                                                #
#   Author:      Debra Evans                                                     #
#   File Name:   get_amex_files.sh                                               #
#   Description: Startup script for get_amex_files.exp                           #
#                This script does the following:                                 #
#                1. Invoke the process get_amex_files.exp                        #
#                2. Get AMEX Settlement files                                    #
#                3. Handle return codes and email accordingly                    #
#                                                                                #
#   Arguments:   none                                                            #
#                                                                                #
#   Return code: 0 = Success                                                     #
#                1 = Failure                                                     #
#                                                                                #
##################################################################################
##


CRON_JOB=1
export CRON_JOB

. /clearing/filemgr/.profile

##################################################################################
#System information variables....
##################################################################################

prog_name="get_amex_files"
sysinfo="System: $SYS_BOX\n Location: $PWD\n"

mailtolist=$MAIL_TO
mailfromlist=$MAIL_FROM

###################################################################################
#Email Subjects variables Priority for Clearing
###################################################################################

msubj_c="$box :: Priority : Critical - Clearing and Settlement"
msubj_u="$box :: Priority : Urgent - Clearing and Settlement"
msubj_h="$box :: Priority : High - Clearing and Settlement"
msubj_m="$box :: Priority : Medium - Clearing and Settlement"
msubj_l="$box :: Priority : Low - Clearing and Settlement"

####################################################################################
#Email Subjects variables Priority for Assist
####################################################################################

mbody_c="ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
mbody_u="ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
mbody_h="ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
mbody_m="ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
mbody_l="ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"


###################################################################################
#Files and Directories
###################################################################################

locpth=/clearing/filemgr/AMEX
log_file=/clearing/filemgr/AMEX/LOG/amex_dnload.log

###################################################################################
# Function - init ()
###################################################################################
init ()
{
   print "===============================================" >> $log_file
   print "Executing $prog_name.sh on `date +%Y%m%d%H%M%S`" >> $log_file
   print $sysinfo                                          >> $log_file
   print "===============================================" >> $log_file
}


###################################################################################
# Function - mail_someone
###################################################################################
mail_someone()
{
  echo $mbody_c $sysinfo $1 | mailx -r $mailfromlist -s "$subject - $m_reason" $mailtolist
  print $m_reason | tee -a $log_file
}


############
#   MAIN   #
############

init

cd $locpth

$locpth/get_amex_files.exp $log_file >> $log_file
rc=$?
if [ $rc != 0 ]
then
   print "return code is $rc"
   m_reason="get_amex_files.exp Download of AMEX files failed with $rc at `date +%Y%m%d%H%M%S` -- check log $log_file \n"
   subject=$msubj_c
   mail_someone "$m_reason"
   print "Ending get_amex_files.exp Download of AMEX files failed at `date +%Y%m%d%H%M%S` \n" | tee -a $log_file
fi
