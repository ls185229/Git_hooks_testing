#!/bin/bash

. /clearing/filemgr/.profile

# $Id: run_all_send_mas_files_to_mas.sh 3016 2015-06-25 19:27:17Z jkruse $

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
# or, for a clearing script:
#source $MASCLR_LIB/clr_env.sh

# optionally override this.  The default is the script name and its options
# this is what appears in subject lines and bodies of emails
# SCRIPT_DESCRIPTION="`basename $0` $*"
# example of an override
export SCRIPT_DESCRIPTION="Run send file to MAS for all institutions"


uses_process_stop_file=0

# optionally override this (default is a critical message on failure)
# example of an override to set this to urgent instead of critical
# the list of options can be found in masclrenv
export MAIL_PRIORITY_FAILURE=$MAIL_HIGH
export MAIL_BODY_FAILURE=$MAIL_HIGH_BODY

# another optional override (default is urgent message for notifications)
# the list of options can be found in masclrenv
# example of an override to set this to LOW for notifications:
export MAIL_PRIORITY_NOTIFY=$MAIL_LOW
export MAIL_BODY_NOTIFY=$MAIL_LOW_BODY



# then call this
setup_environment

#MAIL_TO_FAILURE="ssimpson@jetpay.com"
#MAIL_TO_NOTIFY="ssimpson@jetpay.com"


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

for inst_id in 101 105 106 107 112 113 114 115 116 117 811 820 821 802
do
    SCRIPT_ARGUMENTS="$inst_id"
    run_script "$SCRIPT_TO_RUN $SCRIPT_ARGUMENTS" "$SCRIPT_LOG_FILE" || success=1
    if [ $success -eq 0 ]
    then
        log_message "Completed $SCRIPT_TO_RUN $SCRIPT_ARGUMENTS"
    else
        log_message "Could not run $SCRIPT_TO_RUN $SCRIPT_ARGUMENTS"
        ### break out of the loop because everything after this will fail
	### However, break with a success 0 to prevent overloading the mail system with alert emails
	### The script that was called in the loop will send an error on its own
        exit_with_code 0
    fi
done




exit_with_code $script_success

