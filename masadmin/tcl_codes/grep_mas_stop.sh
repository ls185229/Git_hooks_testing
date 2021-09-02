#!/usr/bin/bash

# $Id: grep_mas_stop.sh 4912 2019-10-30 12:03:03Z bjones $

cd /clearing/masadmin
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

cd /clearing/masadmin/tcl_codes
################################################################################
# log_message message
# calls printf for the message given as a parameter, but prepending a date/time
################################################################################
function log_message () {
    printf "`date "+%m/%d/%y %H:%M:%S"` $1\n"
}

log_message ""
log_message "================================================================================"
log_message "Stopping MAS"
log_message "================================================================================"
log_message ""
log_message "masadmin process running before stop:"
# ps -ef | grep masadmin >> /clearing/masadmin/tcl_codes/LOG/cj_stopmas.log
ps -ef | egrep 'UID|masadmin'

log_message ""
log_message "istapmcmd list before stop:"
# istapmcmd list >> /clearing/masadmin/tcl_codes/LOG/cj_stopmas.log
istapmcmd list

if mbkill -a -e; then
    echo
    log_message "stop mas successfull"
    echo
    mbody="MAS system stopped successfully."
    # print "$mbody_l $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_l" $mailtolist

    cleanipc.sh

    log_message ""
    log_message "masadmin process running after stop:"
    # ps -ef | grep masadmin >> /clearing/masadmin/tcl_codes/LOG/cj_stopmas.log
    ps -ef | egrep 'UID|masadmin'

    ipcs -a

    mblook -t -s -z

else

    mbody="$box WARNING !!! Could not stop run the command to stop MAS.  Manually stop MAS and restart with the scripts from cron for masadmin"
    log_message "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist

fi

log_message "================================================================================"
log_message "End stop MAS script"
log_message "================================================================================"
