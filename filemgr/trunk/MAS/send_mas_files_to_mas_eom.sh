#!/usr/bin/bash

. /clearing/filemgr/.profile

# $Id: send_mas_files_to_mas_eom.sh 3594 2015-12-01 21:19:30Z bjones $

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
export SCRIPT_DESCRIPTION="Send MAS files to MAS shell"

# specify use of the stop file (default is 1, use stop file)
# so if you leave these commented, the script will assume a stop file should
# be used
# uses_process_stop_file=0 
# uses_process_stop_file=1

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

# optional while testing
#MAIL_TO_FAILURE="ssimpson@jetpay.com"
#MAIL_TO_NOTIFY="ssimpson@jetpay.com"


##################################################
# read parameters
# script-specific
# This is performed before log file is set
# because the log file may depend on the instituion ID
# INST_ID = $1
# etc
##################################################
if [ $# -lt 1 ]
then
    echo `date "+%m/%d/%y %H:%M:%S"` "Incorrect number of parameters: $0 $*"
    echo "                   $0 INST_ID "
    exit_with_code 1
fi
inst_id_var="$1"

SCRIPT_ARGUMENTS="--inst_id $inst_id_var"



# MANDATORY
# set these variables
SCRIPT_TO_RUN="./send_mas_files_to_mas_eom.tcl $SCRIPT_ARGUMENTS"
SCRIPT_TO_RUN_DESCRIPTION="Send MAS files to MAS"
SCRIPT_LOG_FILE="LOG/MAS.send_files_to_mas.log"


check_log_file $SCRIPT_LOG_FILE
check_script_file $SCRIPT_TO_RUN $SCRIPT_TO_RUN_DESCRIPTION

success=0
script_success=0
additional_message_details=""

####  Stop sending a duplicate email out
###run_script "$SCRIPT_TO_RUN" "$SCRIPT_LOG_FILE" || success=1
###if [ $success -eq 0 ]
###then 
###    script_success="$script_success"
###else
###    #message="*****Some brief message*****"
###    #additional_message_details="\n$additional_message_details\n$message"
###    script_success=1
###fi

run_script "$SCRIPT_TO_RUN" "$SCRIPT_LOG_FILE" false
script_success=$?

###DOC if something marked the script as a failure, send alert email
###if [ $script_success -ne 0 ]
###then
### message="Script failed: $SCRIPT_DESCRIPTION\n\t\t$additional_message_details\n\t\tEngineer, see log file\n\t\t\t$SCRIPT_LOG_FILE"
###    log_message "$message"
###    send_failure_by_mail "$MAIL_SUBJECT_FAILURE" "$message"
###fi

exit_with_code $script_success

