#!/usr/bin/bash

# Version 1.0
# Developed by Shannon Simpson
# Template for launching a tcl script
# checks for, creates and removes a process.stop file

# $Id: reset_task.sh 3819 2016-07-05 16:54:54Z skumar $

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

if [ $SYS_BOX == "DEV" ]
then
    MAIL_TO_VAR="clearing@jetpay.com"
else
    MAIL_TO_VAR="clearing@jetpay.com assist@jetpay.com"
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
secondary_process_stop_file="/clearing/filemgr/process.stop"



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
script_subj=$msubj_c
script_body=$mbody_c


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
            echo `date "+%m/%d/%y %H:%M:%S"` "$2 $1 does not exist or is not executable and cannot be set by chmod. Exiting." | mailx -r $MAIL_FROM -s "$script_subj $0 FAILED" $MAIL_TO_VAR
            echo `date "+%m/%d/%y %H:%M:%S"` "$2 $1 does not exist or is not executable and cannot be set by chmod. Exiting."
            exit_with_code 1
        else
            echo `date "+%m/%d/%y %H:%M:%S"` "$1 was not executable.  chmod successfully set this to 775" | mailx -r $MAIL_FROM -s "$SYS_BOX NOTIFICATION $0 running with non-fatal error." $MAIL_TO_VAR
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
            echo `date "+%m/%d/%y %H:%M:%S"` "Found existing MAS $process_stop_file."
            echo `date "+%m/%d/%y %H:%M:%S"` "PREVIOUS PROCESS NOT COMPLETED ALL OTHER PROCESSES STOPPED : \nMsg sent from $pwd $0" | mailx -r $MAIL_FROM -s
 "$script_subj $script_name stop file already exists and could not start." $MAIL_TO_VAR
        exit_with_code 1
        fi
        if [ -a $secondary_process_stop_file ]
        then
            echo `date "+%m/%d/%y %H:%M:%S"` "Found existing clearing $process_stop_file."
            echo `date "+%m/%d/%y %H:%M:%S"` "FOUND CLEARING PROCESS STOP FILE. ALL OTHER PROCESSES STOPPED : \nMsg sent from $pwd $0"  | mailx -r $MAIL_FROM -s "$script_subj $script_name stop file already exists and could not start." $MAIL_TO_VAR
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
##################################################

##################################################
# set script name and parameters
# script-specific
##################################################
script_to_run="./reset_task.tcl"
script_name="Reset tasks ($0 $*)"

##################################################
# read parameters
# script-specific
# This is performed before log file is set
# because the log file depends on the instituion ID
# RUN_TYPE = $2
# INST_ID = $1
##################################################
if [ "$#" -lt 1 ]
then
    echo "                   $0 INST_ID ?RUN_TYPE? ?TASK_NBRS?" 
    echo "                   INST_ID = institution_id or ALL"
    echo "                   RUN_TYPE = option run type (CRON, MANUAL, etc)" 
    echo "                   TASK_NBRS = list of tasks to reset.  All tasks reset if nothing supplied"
    echo `date "+%m/%d/%y %H:%M:%S"` "Ending $script_name with ERRORS"
    printf "$script_name $script_to_run $script_body\n\n Incorrect number of parameters: $0 $*"  | mailx -r $MAIL_FROM -s "$script_subj $script_name FAILED. Location: $0" $MAIL_TO_VAR
    exit_with_code 1
fi

if [ $3 ]
then
    task_nbrs_var=" --task_nbrs $3"
else 
    task_nbrs_var=""
fi
if [ $2 ]
then 
    run_type_var=" --run_type $2"
else
    run_type_var=" --run_type CRON"
fi
if [ $1 ]
then
    inst_var=" --inst $1"
    inst_id_var="$1"
else
    inst_var=""
fi

script_arguments="$inst_var$run_type_var$task_nbrs_var"

##################################################
# set the log file
# script-specific
##################################################
if [ $1 ]
then
    if [ $inst_id_var == "ALL" ]
    then 
        log_file=MULTI/LOG/MAS.MULTI.RESET_TASK.log
    else 
        log_file=INST_$inst_id_var/LOG/MAS.$inst_id_var.RESET_TASK.log
    fi
else
    log_file=MULTI/LOG/MAS.MULTI.RESET_TASK.log
fi

##################################################
# Make sure log file exists and is writeable
# all output from this shell script goes here
##################################################
check_log_file $log_file
if [ $? -eq -1 ]
then
    echo `date "+%m/%d/%y %H:%M:%S"` "Setting log file to the bit bucket"
    log_file="/dev/null"
fi


##################################################
# Make sure we can set path to working directory
##################################################
locpth=$PWD
success=0
cd $PWD || success=1
if [ $success -eq 1 ]
then
    echo `date "+%m/%d/%y %H:%M:%S"` "Could not cd to $PWD.  Exiting." | mailx -r $MAIL_FROM -s "$script_subj $script_name $0 FAILED." $MAIL_TO_VAR
    exit_with_code 1
fi

check_process_stop


##################################################
# PHASE 1
# script-specific
# Call the tcl script to reset the tasks
##################################################


##################################################
# make sure tcl file is executable
##################################################
check_script_file $script_to_run $script_name


##################################################
# run the script 
# script-specific
##################################################
echo `date "+%m/%d/%y %H:%M:%S"` "Beginning $script_name $0 $*" >> $log_file

if $script_to_run $script_arguments  >> $log_file
then
    echo `date "+%m/%d/%y %H:%M:%S"` "Ending $script_name $0 $*" >> $log_file
else
    echo `date "+%m/%d/%y %H:%M:%S"` "Ending $script_name with ERRORS" >> $log_file
    printf "$script_name $script_to_run $script_body\n\n `tail -11 $log_file`"  | mailx -r $MAIL_FROM -s "$script_subj $script_name FAILED. Location: $0" $MAIL_TO_VAR
    exit_with_code 1
fi

##################################################
# cleanup
##################################################
exit_with_code 0

##################################################################################

