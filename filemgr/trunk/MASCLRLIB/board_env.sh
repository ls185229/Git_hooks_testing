#!/bin/bash

# $Id: board_env.sh 3567 2015-10-27 21:08:57Z bjones $

################################################################################
# best use of this "library"
#
# 1) override variables setting the script urgency level
# 2) override the description variable
#
# SCRIPT_TO_RUN="./masclr_template.tcl 1 2 3 4"
# SCRIPT_TO_RUN_DESCRIPTION="Template (tester) $0 $*"
# SCRIPT_LOG_FILE="LOG/test.log"
# check_log_file $SCRIPT_LOG_FILE
# check_script_file $SCRIPT_TO_RUN $SCRIPT_TO_RUN_DESCRIPTION
# run_script "$SCRIPT_TO_RUN" "$SCRIPT_LOG_FILE"
# exit_with_code $some_return_code
################################################################################

# reset input separator to just space, tab, newline
IFS=$' \t\n'

# clear aliases -- no surprises
\unalias -a

# should set a safe path
# then clear the command hash
hash -r

# prevent core dumps
# this should not be used when launching a binary file like MAS or clearing
ulimit -c 0

################################################################################
# log_message message
# calls printf for the message given as a parameter, but prepending a date/time
################################################################################
function log_message () {
    printf "`date "+%m/%d/%y %H:%M:%S"` $1\n"
}

################################################################################
# Before anything else, identify the shell script that is running
################################################################################
printf "\n"
log_message "======================================================================="
log_message "Beginning $0 $*"
log_message "======================================================================="


# set up the mail to
# use two different mailto lists - one for notify, one for failure
# set up the HOST_DB and the test mode as well
HOST=`hostname`
success=0
EFFECTIVE_USER=`whoami` || success=1

# this is a trick to see if the script is being run interactively or by cron
# if interactive, set the script user to the person running it
# so alerts will not go to clearing
fd=0
if [[ -t "$fd" || -S /dev/stdin ]]
then
    log_message "Script appears to be running interactively"
    SCRIPT_USER=`who am i | cut -d" " -f 1`
    log_message "$SCRIPT_USER running as `whoami`"
else
    log_message "Script appears to be running from cron"
    SCRIPT_USER="clearing"
    log_message "Setting SCRIPT_USER to clearing and running as `whoami`"
fi

if [[ "$SYS_BOX" == *QA ]]
then
        HOST_DB_MASCLR_REPORTER="$CLR4_DB"
    HOST_DB_MASCLR_UPDATER="$IST_DB"
    HOST_DB_AUTH_REPORTER="$RPT_DB"
    HOST_DB_AUTH_UPDATER="$ATH_DB"
    TEST_MODE=QA
    MAIL_TO_FAILURE="$SCRIPT_USER@jetpay.com"
    MAIL_TO_NOTIFY="$SCRIPT_USER@jetpay.com"
    echo `date "+%m/%d/%y %H:%M:%S"` "Setting TWO_TASK to TRANSQA"
    echo `date "+%m/%d/%y %H:%M:%S"` "Setting TEST_MODE to QA"
elif [[ "$SYS_BOX" = "PD" ]]
then
    HOST_DB_MASCLR_REPORTER="$CLR4_DB"
    HOST_DB_MASCLR_UPDATER="$IST_DB"
    HOST_DB_AUTH_REPORTER="$RPT_DB"
    HOST_DB_AUTH_UPDATER="$ATH_DB"
    TEST_MODE=PROD
    MAIL_TO_FAILURE="$MAIL_TO"
    MAIL_TO_NOTIFY="clearing@jetpay.com"
    echo `date "+%m/%d/%y %H:%M:%S"` "Setting TWO_TASK to $IST_DB"
    echo `date "+%m/%d/%y %H:%M:%S"` "Setting TEST_MODE to PROD"
else
    HOST_DB_MASCLR_REPORTER=TRANSD
    HOST_DB_MASCLR_UPDATER=TRANSD
    HOST_DB_AUTH_REPORTER=TRANSD
    HOST_DB_AUTH_UPDATER=TRANSD
    TEST_MODE=DEV
    MAIL_TO_FAILURE="$SCRIPT_USER@jetpay.com"
    MAIL_TO_NOTIFY="$SCRIPT_USER@jetpay.com"
    echo `date "+%m/%d/%y %H:%M:%S"` "Setting TWO_TASK to TRANSD"
    echo `date "+%m/%d/%y %H:%M:%S"` "Setting TEST_MODE to DEV"
    ###
fi  # end check for hostname
    ###

# override Oracle variables
# and export the above
export TWO_TASK="$HOST_DB_MASCLR_UPDATER"
export ORACLE_SID="$HOST_DB_MASCLR_UPDATER"
export HOST_DB_MASCLR_REPORTER
export HOST_DB_MASCLR_UPDATER
export HOST_DB_AUTH_REPORTER
export HOST_DB_AUTH_UPDATER
export TEST_MODE
export MAIL_TO_FAILURE
export MAIL_TO_NOTIFY
export MAIL_FROM="clearing@$HOST"
export SCRIPT_USER
export EFFECTIVE_USER

# mail/notification/logging variables
export MAIL_CRITICAL="CRITICAL"
export MAIL_URGENT="URGENT"
export MAIL_HIGH="HIGH"
export MAIL_MEDIUM="MEDIUM"
export MAIL_LOW="LOW"
export MAIL_NONE="NONE"
export MAIL_CRITICAL_BODY="\n$EFFECTIVE_USER@$HOST `pwd`\n\nASSIST:\nContact Clearing On-Call Engr. [15 minutes or Escalate] - Open Ticket \n\n\n"
export MAIL_URGENT_BODY="\n$EFFECTIVE_USER@$HOST `pwd`\n\nASSIST:\nContact Clearing On-Call Engr. [60 minutes or Escalate] - Open Ticket \n\n\n"
export MAIL_HIGH_BODY="\n$EFFECTIVE_USER@$HOST `pwd`\n\nASSIST:\nInform Clearing On-Call/Available Engr. [Day Time 7 days of the week] - Open Ticket \n\n\n"
export MAIL_MEDIUM_BODY="\n$EFFECTIVE_USER@$HOST `pwd`\n\nASSIST:\nInform Available Clearing Engr. [Day Time 5 working days of week] - Open Ticket \n\n\n"
export MAIL_LOW_BODY="\n$EFFECTIVE_USER@$HOST `pwd`\n\nASSIST:\nAssign Ticket to the appropriate Clearing Engr. [24/7 - 365 days] - Open Ticket \n\n\n"
export MAIL_NONE_BODY="\n$EFFECTIVE_USER@$HOST `pwd`\n\n"


################################################################################
# OVERRIDE THESE
# set the priority for this particular script
################################################################################
export MAIL_PRIORITY_FAILURE="$MAIL_CRITICAL"
export MAIL_BODY_FAILURE="$MAIL_CRITICAL_BODY"

export MAIL_PRIORITY_NOTIFY="$MAIL_URGENT"
export MAIL_BODY_NOTIFY="$MAIL_URGENT_BODY"


################################################################################
# OVERRIDE this in the shell script with a more meaningful value if you wish
# this is the shell script description
################################################################################
SCRIPT_DESCRIPTION="`basename $0` $*"



################################################################################
# script-specific
# each script needs to override these if necessary
# specifically the uses_process_stop_file
#   where 1 means yes
#   and 0 means no stop file will be checked or created
# for MAS scripts, only generate mas_proces.stop
# but look for any clearing process.stop that may have
# occurred.
# so stop on either stop file, but only generate a
# mas_process.stop file
################################################################################
uses_process_stop_file=1
process_stop_file="/clearing/filemgr/mas_process.stop"
secondary_process_stop_file="/clearing/filemgr/process.stop"



################################################################################
# Functions
################################################################################


################################################################################
# generate the mail subject for failure
#   this has to come from a function since the script sourcing this
#   needs to set their own priority levels
################################################################################
function set_mail_subject_failure () {
    export MAIL_SUBJECT_FAILURE="$EFFECTIVE_USER@$SYS_BOX :: Priority : $MAIL_PRIORITY_FAILURE Clearing and Settlement $SCRIPT_DESCRIPTION FAILED."
}

function set_mail_subject_notify () {
    export MAIL_SUBJECT_NOTIFY="$EFFECTIVE_USER@$SYS_BOX :: Priority : $MAIL_PRIORITY_NOTIFY Clearing and Settlement $SCRIPT_DESCRIPTION NOTIFICATION.  Running with non-fatal error."
}

################################################################################
# create the primary process stop file
#   if a script has uses_process_stop_file=0, then this function will do nothing
################################################################################
function create_process_stop () {
# output is written to stdout
# no process stop for boarding
#    if [ "$uses_process_stop_file" == "1" ] && [ ! -a "$process_stop_file" ]
#    then
#        log_message "Creating $process_stop_file"
#        log_message "$SCRIPT_TO_RUN" >> "$process_stop_file"
#    fi
    log_message "no process stop for boarding"
    ###
}   # create_process_stop
    ###

################################################################################
# send_failure_by_mail subject body
# parameters:
#   $1 -- subject of the email
#   $2 -- body of the email
#
#   adds additional header for the failure notification to $body
#   script for sending email notifications
#   uses mailx for simplicity
################################################################################
function send_failure_by_mail () {
    mail_subject="$1"
    mail_body="$2"

    log_message "$MAIL_BODY_FAILURE$mail_body" | mailx -s "$mail_subject" "$MAIL_TO_FAILURE"

}

################################################################################
# send_notify_by_mail subject body
# parameters:
#   $1 -- subject of the email
#   $2 -- body of the email
#
#   adds additional header information to $body
#   script for sending email notifications
#   uses mailx for simplicity
################################################################################
function send_notify_by_mail () {
    mail_subject="$1"
    mail_body="$2"

    log_message "$MAIL_BODY_NOTIFY$mail_body" | mailx -s "$mail_subject" "$MAIL_TO_NOTIFY"

}

################################################################################
# exit_with_code exit_code
# parameters:
#   $1 -- numeric exit code
#
#   provides single point of exit for normal program flow.
#   Creates the primary process stop file if exiting with anything other than 0
#   Logs an Ending message
#   if any additional cleanup needed, place it here
################################################################################
function exit_with_code () {
    if [ "$1" -eq 0 ]
    then
        log_message "======================================================================="
        log_message "Ending $0 with $1"
        log_message "======================================================================="
        echo ""
        exit "$1"
    else
        create_process_stop
        log_message "======================================================================="
        log_message "Ending $0 with $1"
        log_message "======================================================================="
        echo ""
        exit "$1"
    fi
    ###
}   # exit_with_code
    ###


################################################################################
# check_process_stop
#
#   if a script has uses_process_stop_file=0, then this function will do nothing
#   if a script uses process stop, checks for the existence of the primary and
#   then the secondary stop files.  Exits with 1 after sending an email
#   if either stop file is found
################################################################################
function check_process_stop () {
# output is written to stdout
    log_message "no process stop for boarding"
#    if [ "$uses_process_stop_file" == "1" ]
#    then
#        log_message "Checking for $process_stop_file."
#        if [ -a "$process_stop_file" ]
#        then
#            log_message "Found existing MAS $process_stop_file."
#            temp_body="PREVIOUS PROCESS NOT COMPLETED ALL OTHER PROCESSES STOPPED\n\n"
#            temp_subject="$MAIL_SUBJECT_FAILURE $SCRIPT_DESCRIPTION stop file already exists and could not start."
#            send_failure_by_mail "$temp_subject" "$temp_body"
#            exit_with_code 1
#        fi
#        if [ -a "$secondary_process_stop_file" ]
#        then
#            log_message "Found existing clearing $process_stop_file."
#            temp_body="FOUND CLEARING PROCESS STOP FILE. ALL OTHER PROCESSES STOPPED"
#            temp_subject="$MAIL_SUBJECT_FAILURE $SCRIPT_DESCRIPTION stop file already exists and could not start."
#            send_failure_by_mail "$temp_subject" "$temp_body"
#            exit_with_code 1
#        fi
#        log_message "No previous $process_stop_file exists."
#    fi
    ###
}   # check_process_stop
    ###



################################################################################
# calls both set_mail_subject functions
#   This should always be called after setting the script urgency level
################################################################################
function setup_environment () {
    set_mail_subject_failure
    set_mail_subject_notify
    check_process_stop
}



################################################################################
# check_script_file script_to_run description
# parameters:
#   $1 -- script file to validate
#   $2 -- descriptive name for the script
#
#   catch any permission errors after a deployment
#   attempts a 755 if script is not runnable
#   if successful, sends a notification email and keeps going
#   if not successful, exits with 1 and sends a failure email
################################################################################
function check_script_file () {
    if [ -x "$1" ]
    then
        log_message "$1 is ready to run"
    else
        log_message "$1 was not executable.  attempting chmod."
        success=0
        chmod 775 "$1" || success=1
        if [ "$success" -eq 1 ]
        then
            temp_body="$2 $1 does not exist or is not executable and cannot be set by chmod. Exiting."
            send_failure_by_mail "$MAIL_SUBJECT_FAILURE" "$temp_body"
            log_message "$message"
            exit_with_code 1
        else
            temp_body="$1 was not executable.  chmod successfully set this to 775"
            send_notify_by_mail "$MAIL_SUBJECT_NOTIFY" "$temp_body"
            log_message "$message"
        fi
    fi
    ###
}   # check_script_file
    ###

################################################################################
# check_log_file log_file
# parameters:
#   $1 -- the log file name to validate
#
#   verify log file exists and is writeable
#   create if it doesn't exist
#   if cannot create, continues but logs output to standard out and sends a notify
#
################################################################################
function check_log_file () {
    success=0

    if [ -w "$1" ]
    then
        touch "$1" || success=1
    fi

    # create a space to make individual runs easy to identify
    echo " "  >> "$1"

    # send message to standard out
    log_message "Setting up $SCRIPT_TO_RUN_DESCRIPTION"

    if [ "$success" -eq 1 ]
    then
        message="Log file $1 does not exist or cannot be written.  Script logging will be output to screen. "
        send_notify_by_mail "$MAIL_SUBJECT_NOTIFY" "$message"
        return -1
    fi
    ###
}   # check_log_file
    ###


################################################################################
# run_script "script_name arguments" log_file
# parameters:
#   $1 -- "script name arguments" as a single quoted string
#   $2 -- log file to redirect that script's output to
#
#   takes script name + arguments as $1
#   takes log file as $2
#   example:
#       SCRIPT_TO_RUN="./masclr_template.tcl 1 2 3 4"
#       SCRIPT_LOG_FILE="LOG/test.log"
#       run_script "$SCRIPT_TO_RUN" "$SCRIPT_LOG_FILE"
#   returns magic number 13 on failure, else 0
################################################################################
function run_script () {
    log_message "Launching $1"
    if eval "$1" >> "$2" 2>&1
    then
        return_code=0
    else
        message="Script failed: $1\n\t\tEngineer, see log file `pwd`/$2"
        log_message "$message"
        send_failure_by_mail "$MAIL_SUBJECT_FAILURE" "$message"
        return_code=13
    fi

    log_message "Ending \"$1\""
    return "$return_code"
    ###
}   # run_script
    ###
