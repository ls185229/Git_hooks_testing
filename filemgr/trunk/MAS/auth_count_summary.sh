#!/bin/bash

. /clearing/filemgr/.profile

# $Id: auth_count_summary.sh 3195 2015-07-17 18:23:18Z fcaron $

################################################################################
# MASCLR shell script template 
# Developed by Shannon Simpson
# Version 0.5
# July 6 2009
################################################################################


################################################################################
# masclrenv sets TEST_MODE and TWO_TASK based on the hostname
# 	sets MAIL_TO_NOTIFY, MAIL_TO_FAILURE, MAIL_SUBJECT_FAILURE, MAIL_SUBJECT_NOTIFY
# 	defines functions
# sanitizes the run environment
source $MASCLR_LIB/mas_env.sh

# optionally override this.  The default is the script name and its options
# this is what appears in subject lines and bodies of emails
# SCRIPT_DESCRIPTION="`basename $0` $*"
# example of an override
export SCRIPT_DESCRIPTION="Auth count summary shell script"

uses_process_stop_file=0 


# optionally override this (default is a critical message on failure)
# example of an override to set this to urgent instead of critical
# the list of options can be found in masclrenv
export MAIL_PRIORITY_FAILURE=$MAIL_LOW
export MAIL_BODY_FAILURE=$MAIL_LOW_BODY

# another optional override (default is urgent message for notifications)
# the list of options can be found in masclrenv
# example of an override to set this to LOW for notifications:
export MAIL_PRIORITY_NOTIFY=$MAIL_LOW
export MAIL_BODY_NOTIFY=$MAIL_LOW_BODY



# then call this
setup_environment

# optional while testing
MAIL_TO_FAILURE="clearing-np@jetpay.com"
MAIL_TO_NOTIFY="clearing-np@jetpay.com"

if [ $# -eq 0 ]
then
SCRIPT_ARGUMENTS=""
else
SCRIPT_ARGUMENTS="--date $1"
fi

log_message "Running with $SCRIPT_ARGUMENTS"

# MANDATORY
# set these variables
SCRIPT_TO_RUN="./auth_count_summary.tcl $SCRIPT_ARGUMENTS"
SCRIPT_TO_RUN_DESCRIPTION="Auth count summary"
SCRIPT_LOG_FILE="LOG/MAS.auth_count_summary.log"


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

