#!/bin/bash

. /clearing/filemgr/.profile

# $Id: gl_date_check.sh 3420 2015-09-11 20:05:17Z bjones $

################################################################################
# GL Date check.
# Developed by Shannon Simpson
# Version 1.0
# July 15 2009
################################################################################


################################################################################
# mas_env.sh sets TEST_MODE and TWO_TASK based on the hostname
# 	sets MAIL_TO_NOTIFY, MAIL_TO_FAILURE, MAIL_SUBJECT_FAILURE, MAIL_SUBJECT_NOTIFY
# 	defines functions
# sanitizes the run environment
source $MASCLR_LIB/mas_env.sh

# Should override these (defaults from the env are listed here):
# SCRIPT_DESCRIPTION="`basename $0` $*"
# keeping these options 
# uses_process_stop_file=1

export MAIL_PRIORITY_FAILURE=$MAIL_URGENT
export MAIL_BODY_FAILURE=$MAIL_URGENT_BODY

# export MAIL_PRIORITY_NOTIFY=$MAIL_URGENT
# export MAIL_BODY_NOTIFY=$MAIL_URGENT_BODY

# then call this
setup_environment

SCRIPT_TO_RUN="./gl_date_check.tcl"
SCRIPT_DESCRIPTION="GL Date check"
SCRIPT_LOG_FILE="LOG/MAS.gldatecheck.log"
check_log_file $SCRIPT_LOG_FILE
check_script_file $SCRIPT_TO_RUN $SCRIPT_DESCRIPTION
success=0
run_script "$SCRIPT_TO_RUN" "$SCRIPT_LOG_FILE" || success=1
if [ $success -eq 0 ]
then 
    exit_with_code 0
else
    exit_with_code 1
fi


