#!/usr/bin/bash

# Version 1.0
# Developed by Shannon Simpson
# Template for launching a tcl script
# checks for, creates and removes a process.stop file

# $Id: global_merchant_auth_counts.sh 1480 2011-07-02 14:59:31Z millig $

##################################################
# set variables
# make things sane
##################################################


# reset input separator to just space, tab, newline
IFS=$' \t\n'

# variable assignments to command line arguments should be surrounded by quotes
# such as test="$1" instead of test=$1

# clear aliases -- no surprises
\unalias -a

# should set a safe path
# then clear the command hash
hash -r

# should set umask
# should also consider restricting permissions to just the user, not group, not world
# should consider preventing core dumps (to prevent dumping password or other information) of the shell script with ulimit -c 0

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile
export ORACLE_SID=$IST_DB
export TWO_TASK=$IST_DB

box=$SYS_BOX
auth_rpt_db=$RPT_DB

if [ $SYS_BOX == "DEV" ]
then
    MAIL_TO_VAR="clearing@jetpay.com"
else
    MAIL_TO_VAR="clearing@jetpay.com accounting@jetpay.com"
fi
MAIL_FROM="clearing@jetpay.com"

success=0



##################################################
# script-specific
# each script needs to indicate use of a stop file
# and what that stop file name is
##################################################
uses_process_stop_file=0
process_stop_file="mas_process.stop"



#Email Subjects 

msubj_c="$box :: Priority : Critical - Clearing and Settlement"
msubj_u="$box :: Priority : Urgent - Clearing and Settlement"
msubj_h="$box :: Priority : High - Clearing and Settlement"
msubj_m="$box :: Priority : Medium - Clearing and Settlement"
msubj_l="$box :: Priority : Low - Clearing and Settlement"

#Email Subjects

mbody_c="ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
mbody_u="ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
mbody_h="ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
mbody_m="ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
mbody_l="ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"



##################################################
# script-specific
# each script should have it's priority level set here
##################################################
script_subj=$msubj_l
script_body=$mbody_l


##################################################
# Functions
##################################################
function check_script_file () {
    if [ -x $1 ]
    then
        echo `date "+%m/%d/%y %H:%M:%S"` "$1 is ready to run"
    else
        echo `date "+%m/%d/%y %H:%M:%S"` "$1 was not executable.  attempting chmod."
        success=0
        chmod 775 $script_to_run || success=1
        if [ $success -eq 1 ]
        then
            echo `date "+%m/%d/%y %H:%M:%S"` "$2 $1 does not exist or is not executable and cannot be set by chmod. Exiting." | mailx -r $MAIL_FROM -s "$scri
pt_subj $0 FAILED" $MAIL_TO_VAR
            echo `date "+%m/%d/%y %H:%M:%S"` "$2 $1 does not exist or is not executable and cannot be set by chmod. Exiting."
            exit_with_code 1
        else
            echo `date "+%m/%d/%y %H:%M:%S"` "$1 was not executable.  chmod successfully set this to 775" | mailx -r $MAIL_FROM -s "$SYS_BOX NOTIFICATION $0
running with non-fatal error." $MAIL_TO_VAR
            echo `date "+%m/%d/%y %H:%M:%S"` "$1 was not executable.  chmod successfully set this to 775" >> $log_file
        fi
    fi

}

function check_log_file () {
    success=0

    if [ -w $1 ]
    then
        echo ""  >> $1
        echo ""
        echo `date "+%m/%d/%y %H:%M:%S"` "Beginning $script_name" >> $1
        echo `date "+%m/%d/%y %H:%M:%S"` "Beginning $script_name"
    else
        touch $1 || success=1
        echo ""  >> $1
        echo ""
        echo `date "+%m/%d/%y %H:%M:%S"` "Beginning $script_name" >> $1
        echo `date "+%m/%d/%y %H:%M:%S"` "Beginning $script_name"

    fi
    if [ $success -eq 1 ]
    then
        echo `date "+%m/%d/%y %H:%M:%S"` "Log file $1 does not exist or cannot be written.  Script logging will be output to screen." | mailx -r $MAIL_FROM -s "$script_subj $script_name running with non-fatal error." $MAIL_TO_VAR
        return -1
    fi
}


function create_process_stop () {
# output is written to stdout
    if [ "$uses_process_stop_file" == "1" ] && [ ! -a $process_stop_file ]
    then
        echo `date "+%m/%d/%y %H:%M:%S"` "$script_name" >> $process_stop_file
    fi
}

# no longer used
function delete_process_stop () {
# output is written to stdout
    if [ "$uses_process_stop_file" == "1" ]
    then
        echo `date "+%m/%d/%y %H:%M:%S"` "Removing $process_stop_file."
        success=0
        rm $process_stop_file || success=1
        if [ $success -eq 1 ]
        then
            echo `date "+%m/%d/%y %H:%M:%S"` "Could not remove $process_stop_file.  Script $0 was successful.   Try removing the $process_stop_file manually." | mailx -r $MAIL_FROM -s "$script_subj $script_name succeeded but could not remove the stop file" $MAIL_TO_VAR
            return -1
        fi
    fi
}

function check_process_stop () {
# output is written to stdout

    if [ "$uses_process_stop_file" == "1" ]
    then
        echo `date "+%m/%d/%y %H:%M:%S"` "Checking for $process_stop_file."
        if [ -a $process_stop_file ]
        then
            echo `date "+%m/%d/%y %H:%M:%S"` "Found existing $process_stop_file."
            echo `date "+%m/%d/%y %H:%M:%S"` "PREVIOUS PROCESS NOT COMPLETED ALL OTHER PROCESSES STOPPED : \nMsg sent from $pwd $0"  | mailx -r $MAIL_FROM -s "$script_subj $script_name stop file already exists and could not start." $MAIL_TO_VAR
        exit_with_code 1
        fi
        echo `date "+%m/%d/%y %H:%M:%S"` "No previous $process_stop_file exists."
     fi
}
 
function exit_with_code () {
# output is written to stdout on failure condition
# $1, etc are local variables passed to the function
    if [ $1 -eq 0 ]
    then
        echo `date "+%m/%d/%y %H:%M:%S"` "Ending $script_name"
        echo ""
        exit $1
    else
        # any process stop file is kept in place
	create_process_stop
        echo `date "+%m/%d/%y %H:%M:%S"` "Ending $script_name with $1"
        echo ""
        exit $1
    fi
}

##################################################
# main
# NOTE: no log file
##################################################
yesterday=`perl -e '@T=localtime(time-86400);printf("%02d/%02d/%02d",$T[4]+1,$T[3],($T[5]+1900)%100)'`
subject_var="$yesterday Global Merchant Solutions auth counts"
sqlplus -S teihost/quikdraw@$auth_rpt_db @global_merchant_auth_counts.sql | mailx -r $MAIL_FROM -s "$subject_var" $MAIL_TO_VAR 


##################################################
# cleanup
##################################################
exit_with_code 0

##################################################################################

