#!/usr/bin/bash

# $Id: grep_mas_start.sh 4912 2019-10-30 12:03:03Z bjones $

cd /clearing/masadmin/
. /clearing/masadmin/.profile
CRON_JOB=1
export CRON_JOB

##################################################################################

clrpath=$CLR_OSITE_ROOT
maspath=$MAS_OSITE_ROOT
mailtolist=$MAIL_TO
mailfromlist=$MAIL_FROM
clrdb=$IST_DB
authdb=$ATH_DB
box=$SYS_BOX

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

#System information variables....

sysinfo="System: $SYS_BOX\n Location: $PWD \n\n"

#####################################################################################################

################################################################################
# log_message message
# calls printf for the message given as a parameter, but prepending a date/time
################################################################################
function log_message () {
    printf "`date "+%m/%d/%y %H:%M:%S"` $1\n"
}

log_message ""
log_message "================================================================================"
log_message "Starting MAS"
log_message "================================================================================"
log_message ""
log_message "masadmin processes running before start:"
# ps -ef | grep masadmin >> /clearing/masadmin/tcl_codes/cj_startmas.log
ps -ef | egrep 'UID|masadmin'

log_message ""
log_message "istapmcmd list before stop:"
# istapmcmd list >> /clearing/masadmin/tcl_codes/cj_startmas.log
istapmcmd list

cd /clearing/masadmin/tcl_codes

if mbinit; then
    log_message "mbinit successful"
    #   mbody="$box Restart of MAS successful"
    #   print "$mbody_l $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_l" $mailtolist
else
    mbody="mbinit could not run.  Please log in to the system and stop and restart MAS with command <mbkill -a -e> then <mbinit>."
    log_message "$mbody_l $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_l" $mailtolist
fi
#sleep 60

echo ""
log_message ""
log_message "masadmin processes running after start:"
#ps -ef | grep masadmin >> /clearing/masadmin/tcl_codes/cj_startmas.log
ps -ef | egrep 'UID|masadmin'
istapmcmd list

mblook -t -s -z
ipcs -a

log_message "================================================================================"
log_message "MAS restart finished"
log_message "================================================================================"
