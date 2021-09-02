#!/usr/bin/bash

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

##################################################
# set variables
# make things sane
##################################################

# reset input separator to just space, tab, newline
IFS=$' \t\n'

# variable assignments to command line arguments should be surrounded by quotes
# such as test="$1" instead of test=$1

# clear aliases -- no surprises
\unalias -a

# should set a safe path
# then clear the command hash
hash -r

# should set umask
# should also consider restricting permissions to just the user, not group, not world
# should consider preventing core dumps (to prevent dumping password or other information) of the shell script with ulimit -c 0

box=$SYS_BOX
if [ $SYS_BOX == "DEV" ]
then
    MAIL_TO="clearing@jetpay.com"
else
    MAIL_TO="clearing@jetpay.com assist@jetpay.com"
fi
MAIL_FROM="clearing@jetpay.com"

success=0

remote_directory="Reports"
upload_directory="UPLOAD"
file_pattern="MERRICK.DDA.*.CSV"
log_file="LOG/MERRICK.DDA.REPORT.RUN.log"
upload_log_file="LOG/MERRICK.DDA.REPORT.UPLOAD.log"
script_name="Merrick DDA Report"
date_offset=0

#Email Subjects variables Priority wise

msubj_c="$box :: Priority : Critical - Clearing and Settlement"
msubj_u="$box :: Priority : Urgent - Clearing and Settlement"
msubj_h="$box :: Priority : High - Clearing and Settlement"
msubj_m="$box :: Priority : Medium - Clearing and Settlement"
msubj_l="$box :: Priority : Low - Clearing and Settlement"

#Email Subjects variables Priority wise

mbody_c="ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
mbody_u="ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
mbody_h="ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
mbody_m="ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
mbody_l="ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

script_subj=$msubj_m
script_body=$mbody_m


##################################################
# Functions
##################################################
function check_script_file () {
    if [ -x $1 ] 
    then
        echo `date "+%m/%d/%y %H:%M:%S"` "$1 is ready to run" >> $log_file
    else
        echo `date "+%m/%d/%y %H:%M:%S"` "$1 was not executable.  attempting chmod." >> $log_file
        chmod 775 $script_to_run || success=1
        if [ $success -eq 1 ]
        then
            echo `date "+%m/%d/%y %H:%M:%S"` "$2 $1 does not exist or is not executable and cannot be set by chmod. Exiting." | mailx -r $MAIL_FROM -s "$SYS_BOX $script_subj $0 FAILED" $MAIL_TO
            echo `date "+%m/%d/%y %H:%M:%S"` "$2 $1 does not exist or is not executable and cannot be set by chmod. Exiting." >> $log_file
        else
            echo `date "+%m/%d/%y %H:%M:%S"` "$1 was not executable.  chmod successfully set this to 775" | mailx -r $MAIL_FROM -s "$SYS_BOX NOTIFICATION $0 running with non-fatal error." $MAIL_TO
            echo `date "+%m/%d/%y %H:%M:%S"` "$1 was not executable.  chmod successfully set this to 775" >> $log_file
        fi
    fi

}

function check_log_file () {
    if [ -w $1 ]
    then
        echo ""  >> $1
        echo `date "+%m/%d/%y %H:%M:%S"` "Beginning $script_name $0" >> $1
    else
        touch $1 || success=1
        echo `date "+%m/%d/%y %H:%M:%S"` "Beginning $script_name $0" >> $1
    
    fi
    if [ $success -eq 1 ]
    then
        echo `date "+%m/%d/%y %H:%M:%S"` "Log file $1 does not exist or cannot be written.  Script logging will be output to screen." | mailx -r $MAIL_FROM -s "$SYS_BOX $script_subj $script_name $0 running with non-fatal error." $MAIL_TO
        return -1
    fi
}


##################################################
# Make sure we can set path to working directory
##################################################
locpth=$PWD

cd $PWD || success=1
if [ $success -eq 1 ]
then
    echo `date "+%m/%d/%y %H:%M:%S"` "Could not cd to $PWD.  Exiting." | mailx -r $MAIL_FROM -s "$SYS_BOX $script_subj $script_name $0 FAILED." $MAIL_TO
fi

##################################################
# Make sure log file exists and is writeable
# all output from this shell script goes here
##################################################
check_log_file $log_file
if [ $? -eq -1 ]
then
    echo `date "+%m/%d/%y %H:%M:%S"` "Setting log file to the bit bucket"
    log_file="/dev/null"
fi

check_log_file $upload_log_file
if [ $? -eq -1 ]
then
    echo `date "+%m/%d/%y %H:%M:%S"` "Setting upload log file to the main script log file." >> $log_file
    upload_log_file=$log_file
fi


##################################################
# read parameters 
##################################################
if [ $# -gt 0 ]
then
    date_offset="$1"
fi 




##################################################
# PHASE 1
# create file
##################################################

##################################################
# set script name
##################################################
script_to_run="./merrick_dda_report.tcl"
script_name="Merrick DDA Change Report file creation"


##################################################
# make sure tcl file is executable
##################################################
check_script_file $script_to_run $script_name




echo `date "+%m/%d/%y %H:%M:%S"` "Beginning $script_name" >> $log_file

if $script_to_run --date_offset $date_offset
then
    echo `date "+%m/%d/%y %H:%M:%S"` "Ending $script_name" >> $log_file
else
    echo `date "+%m/%d/%y %H:%M:%S"` "Ending $script_name with ERRORS" >> $log_file
    printf "$script_name $script_to_run $script_body\n\n `tail -11 $log_file`"  | mailx -r $MAIL_FROM -s "$script_subj $script_name FAILED. Location: $0" $MAIL_TO
    exit 1
fi



##################################################
# PHASE 2
# send file
##################################################

##################################################
# set script name
##################################################
script_to_run="./upload.exp"
script_name="Merrick DDA Change Report file transfer"


##################################################
# make sure tcl file is executable
##################################################
check_script_file $script_to_run $script_name



echo `date "+%m/%d/%y %H:%M:%S"` "Beginning $script_name" >> $log_file
ls $upload_directory/$file_pattern 2> /dev/null
if [ $? -eq 0 ]
then
    for file in `ls $upload_directory/$file_pattern`
    do
        echo `date "+%m/%d/%y %H:%M:%S"` "Calling $script_to_run $remote_directory $file" 
        if $script_to_run $remote_directory $file >> $upload_log_file
        then
            echo `date "+%m/%d/%y %H:%M:%S"` "$script_name completed successfully\n" >> $log_file
        else
            echo `date "+%m/%d/%y %H:%M:%S"` "Ending $script_name with ERRORS"
            printf "$script_body\n\n `tail -11 $upload_log_file`"  | mailx -r $MAIL_FROM -s "$script_subj $script_name FAILED. Location: $locpth" $MAIL_TO
            exit 1
        fi
        echo `date "+%m/%d/%y %H:%M:%S"` "Ending $script_to_run $remote_directory $file"

        echo `date "+%m/%d/%y %H:%M:%S"` "Moving $file to ARCHIVE"
        mv $upload_directory/$file_pattern ARCHIVE >> $log_file
    done
else
    echo `date "+%m/%d/%y %H:%M:%S"` "No files to upload"
fi

echo `date "+%m/%d/%y %H:%M:%S"` "Ending $script_name" >> $log_file
echo "" >> $log_file 

