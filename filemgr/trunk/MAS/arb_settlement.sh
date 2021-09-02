#!/bin/bash

. /clearing/filemgr/.profile

# $Id: arb_settlement.sh 3195 2015-07-17 18:23:18Z fcaron $



source $MASCLR_LIB/mas_env.sh

export SCRIPT_DESCRIPTION="Arbitration/fee collection MAS file shell"



export MAIL_PRIORITY_FAILURE="$MAIL_MEDIUM"
export MAIL_BODY_FAILURE="$MAIL_MEDIUM_BODY"

export MAIL_PRIORITY_NOTIFY=$MAIL_LOW
export MAIL_BODY_NOTIFY=$MAIL_LOW_BODY

uses_process_stop_file=0 

setup_environment

# optional while testing
#MAIL_TO_FAILURE="ssimpson@jetpay.com"
#MAIL_TO_NOTIFY="ssimpson@jetpay.com"



##################################################
# read parameters
# script-specific
# This is performed before log file is set
# because the log file depends on the instituion ID
# INST_ID = $1
# SHORTNAME = 2
# FILE_DATE = 3
# ACT_DATE = 4
##################################################
if [ $# -lt 1 ]
then
    echo `date "+%m/%d/%y %H:%M:%S"` "Incorrect number of parameters: $0 $*" 
    echo "                   $0 INST_ID ?ACT_DATE? ?FILE_DATE? " 
    echo "                   INST_ID = institution_id"
    echo "                   ?TRANS_DATE? = (optional) transaction activity date (Defaults to current date)"
    echo "                   ?FILE_DATE? = (optional) file date (Defaults to current date)"
    echo `date "+%m/%d/%y %H:%M:%S"` "Ending $script_name with ERRORS" 
    message="Script failed: $SCRIPT_DESCRIPTION\n\t\t$additional_message_details\n\t\tIncorrect number of parameters: $0 $*"
    send_failure_by_mail "$MAIL_SUBJECT_FAILURE" "$message"
#    printf "$script_name $script_to_run $script_body\n\n Incorrect number of parameters: $0 $*"  | mailx -r "$MAIL_FROM" -s "$script_subj $script_name FAILED. Location: $0" "$MAIL_TO_FAILURE"
    exit_with_code 1
fi
inst_id_var="$1"
#shortname_var="$2"
trans_date_var=${2:-`date +"%Y%m%d"`}
file_date_var=${3:-"SKIP"}

if [ "$file_date_var" = "SKIP" ]
then
SCRIPT_ARGUMENTS="--inst_id $inst_id_var --trans_date $trans_date_var"
else
SCRIPT_ARGUMENTS="--inst_id $inst_id_var --file_date $file_date_var --trans_date $trans_date_var"
fi



# set these variables
SCRIPT_TO_RUN="./arb_settlement.tcl $SCRIPT_ARGUMENTS"
SCRIPT_TO_RUN_DESCRIPTION="Arbitration/fee collection MAS file ($0 $*)"
SCRIPT_LOG_FILE="LOG/MAS.ARB_SETTLEMENT.log"





check_log_file $SCRIPT_LOG_FILE
check_script_file $SCRIPT_TO_RUN $SCRIPT_TO_RUN_DESCRIPTION

success=0
script_success=0
additional_message_details=""


run_script "$SCRIPT_TO_RUN" "$SCRIPT_LOG_FILE" || success=1
if [ $success -eq 0 ]
then 
    script_success="$script_success"
else
    #message="*****Some brief message*****"
    #additional_message_details="\n$additional_message_details\n$message"
    script_success=1
fi

###DOC if something marked the script as a failure, send alert email
if [ $script_success -ne 0 ]
then
    message="Script failed: $SCRIPT_DESCRIPTION\n\t\t$additional_message_details\n\t\tEngineer, see log file\n\t\t\t$SCRIPT_LOG_FILE"
    log_message "$message"
    send_failure_by_mail "$MAIL_SUBJECT_FAILURE" "$message"
fi


exit_with_code $script_success




