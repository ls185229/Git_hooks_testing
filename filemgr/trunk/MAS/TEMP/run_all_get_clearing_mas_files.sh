#!/bin/bash

. /clearing/filemgr/.profile

# $Id: run_all_get_clearing_mas_files.sh 3016 2015-06-25 19:27:17Z jkruse $

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

export SCRIPT_DESCRIPTION="Run get clearing MAS files for all institutions."


uses_process_stop_file=1

export MAIL_PRIORITY_FAILURE=$MAIL_HIGH
export MAIL_BODY_FAILURE=$MAIL_HIGH_BODY

export MAIL_PRIORITY_NOTIFY=$MAIL_LOW
export MAIL_BODY_NOTIFY=$MAIL_LOW_BODY



setup_environment

# these were used for testing
#MAIL_TO_FAILURE="ssimpson@jetpay.com"
#MAIL_TO_NOTIFY="ssimpson@jetpay.com"


##################################################
# read parameters
# script-specific
##################################################



# MANDATORY
# set these variables
SCRIPT_TO_RUN="./get_clearing_mas_files.sh"
SCRIPT_TO_RUN_DESCRIPTION="Get clearing MAS files."
SCRIPT_LOG_FILE="LOG/MAS.get_clearing_mas_files_run.log"


check_log_file $SCRIPT_LOG_FILE
check_script_file $SCRIPT_TO_RUN $SCRIPT_TO_RUN_DESCRIPTION

success=0
script_success=0

for inst_id in 105 101 106 107
do
    SCRIPT_ARGUMENTS="$inst_id"
    run_script "$SCRIPT_TO_RUN $SCRIPT_ARGUMENTS" "$SCRIPT_LOG_FILE" || success=1
    if [ $success -eq 0 ]
    then
        log_message "Completed $SCRIPT_TO_RUN $SCRIPT_ARGUMENTS"
    else
        log_message "Could not run $SCRIPT_TO_RUN $SCRIPT_ARGUMENTS"
        ### break out of the loop because everything after this will fail
        exit_with_code $success
    fi
done




exit_with_code $script_success

