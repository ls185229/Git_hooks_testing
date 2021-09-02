#!/usr/bin/bash

. /clearing/filemgr/.profile

# $Id: one_time_fee.sh 1966 2013-01-18 21:54:21Z bjones $

################################################################################
# masclrenv sets TEST_MODE and TWO_TASK based on the hostname
#   sets MAIL_TO_NOTIFY, MAIL_TO_FAILURE, MAIL_SUBJECT_FAILURE, MAIL_SUBJECT_NOTIFY
#   defines functions
# sanitizes the run environment
source $MASCLR_LIB/mas_env.sh

# optionally override this.  The default is the script name and its options
# this is what appears in subject lines and bodies of emails
# SCRIPT_DESCRIPTION="`basename $0` $*"
# example of an override
export SCRIPT_DESCRIPTION="One-time Fees"

# specify use of the stop file (default is 1, use stop file)
# so if you leave these commented, the script will assume a stop file should
# be used
uses_process_stop_file=0
# uses_process_stop_file=1

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

MAIL_TO_FAILURE="clearing@jetpay.com"
MAIL_TO_NOTIFY="clearing@jetpay.com"

# MANDATORY
# set these variables
SCRIPT_TO_RUN="./one_time_fee_105.tcl"
SCRIPT_TO_RUN_DESCRIPTION="One-time fee creation"
SCRIPT_LOG_FILE="LOGS/MAS.one_time_fee.log"

check_log_file $SCRIPT_LOG_FILE
check_script_file $SCRIPT_TO_RUN $SCRIPT_TO_RUN_DESCRIPTION
success=0

run_script "$SCRIPT_TO_RUN" "$SCRIPT_LOG_FILE" || success=1
if [ $success -eq 0 ]
then
    exit_with_code 0
else
    exit_with_code 1
fi
