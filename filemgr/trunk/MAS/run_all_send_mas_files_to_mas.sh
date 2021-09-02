#!/usr/bin/bash

. /clearing/filemgr/.profile

################################################################################
# $Id: run_all_send_mas_files_to_mas.sh 4583 2018-05-25 15:57:32Z bjones $
# $Rev: 4583 $
################################################################################
#
# File Name:  run_all_send_mas_files_to_mas.sh
#
# Description:  This script initiates movement of individual MAS files to MAS
#               for processing.
#
# Shell Arguments:  None.
#
# Script Arguments:  inst_id = Institution ID (e.g., ALL, 101, 105, 107, 802).
#                              Required.
#
# Output:  None.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
################################################################################

source $MASCLR_LIB/mas_env.sh

export SCRIPT_DESCRIPTION="Run send file to MAS for all institutions"

uses_process_stop_file=0

export MAIL_PRIORITY_FAILURE=$MAIL_HIGH
export MAIL_BODY_FAILURE=$MAIL_HIGH_BODY

export MAIL_PRIORITY_NOTIFY=$MAIL_LOW
export MAIL_BODY_NOTIFY=$MAIL_LOW_BODY

setup_environment

##################################################
# read parameters
# script-specific
##################################################

# MANDATORY
# set these variables
SCRIPT_TO_RUN="./send_mas_files_to_mas.sh"
SCRIPT_TO_RUN_DESCRIPTION="Send MAS files to MAS"
SCRIPT_LOG_FILE="LOG/MAS.send_mas_files_run.log"


check_log_file $SCRIPT_LOG_FILE
check_script_file $SCRIPT_TO_RUN $SCRIPT_TO_RUN_DESCRIPTION

success=0
script_success=0

for inst_id in 101 105 107 121 122 129 130 131 132 133 134 811
do
    SCRIPT_ARGUMENTS="$inst_id"
    run_script "$SCRIPT_TO_RUN $SCRIPT_ARGUMENTS" "$SCRIPT_LOG_FILE" || success=1
    if [ $success -eq 0 ]
    then
        log_message "Completed $SCRIPT_TO_RUN $SCRIPT_ARGUMENTS"
    else
        log_message "Could not run $SCRIPT_TO_RUN $SCRIPT_ARGUMENTS"
        exit_with_code 0
    fi
done

exit_with_code $script_success
