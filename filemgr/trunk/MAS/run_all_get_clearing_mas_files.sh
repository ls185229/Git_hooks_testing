#!/usr/bin/bash

. /clearing/filemgr/.profile

################################################################################
# $Id: run_all_get_clearing_mas_files.sh 3186 2015-07-17 15:45:20Z fcaron $
# $Rev: 3186 $
################################################################################
#
# File Name:  run_all_get_clearing_mas_files.sh
#
# Description:  This script initiates movement of MAS files from Clearing to
#               the MAS_FILES directory for future processing.
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

export SCRIPT_DESCRIPTION="Run get clearing MAS files for all institutions."

uses_process_stop_file=1

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
SCRIPT_TO_RUN="./get_clearing_mas_files.sh"
SCRIPT_TO_RUN_DESCRIPTION="Get clearing MAS files."
SCRIPT_LOG_FILE="LOG/MAS.get_clearing_mas_files_run.log"


check_log_file $SCRIPT_LOG_FILE
check_script_file $SCRIPT_TO_RUN $SCRIPT_TO_RUN_DESCRIPTION

success=0
script_success=0

for inst_id in 101 105 107 121
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

