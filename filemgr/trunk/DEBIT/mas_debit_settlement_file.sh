#!/usr/bin/ksh

################################################################################
# $Id: mas_debit_settlement_file.sh 3512 2015-09-22 21:33:12Z bjones $
# $Rev: 3512 $
################################################################################
#
# File Name:  mas_debit_settlement_file.sh
#
# Description:  This script initiates the creation of a MAS transaction
#               settlement file for PIN debit activity.
#
# Shell Arguments:  Date (optional).
#
# Script Arguments:  inst_id = Institution ID.  Required.
#                    sname = Shortname associated with the institution.
#                            Required.
#
# Output:  Confirmation emails to configured parties.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
################################################################################

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

export ORACLE_SID=$ATH_DB
export TWO_TASK=$ATH_DB
echo $ORACLE_HOME
echo $TWO_TASK

cd $PWD

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

locpth=$PWD
cd $locpth

######## MAIN ####################################

inst_id="101"
sname="JETPAY"
logfile="debit_mas_file.log"

print "Beginning at `date +%Y%m%d%H%M%S`" >> $locpth/LOG/$logfile

if ./mas_debit_settlement_file.tcl $sname $inst_id $1 >> $locpth/LOG/$logfile; then
	print "Script mas_debit_settlement_file.tcl $sname $inst_id  $1 completed successfully" | tee -a $locpth/LOG/$logfile
else
	mbody="$SYS_BOX Script mas_debit_settlement_file.tcl $sname $inst_id  $1 Failed"
        print "$mbody_c $sysinfo $mbody" | mutt -s "$msubj_c" -- $mailtolist
fi

print "Ending at `date +%Y%m%d%H%M%S`" >> $locpth/LOG/$logfile


inst_id="107"
sname="JETPAYIS"
logfile="debit_mas_file.log"

print "Beginning at `date +%Y%m%d%H%M%S`" >> $locpth/LOG/$logfile

if ./mas_debit_settlement_file.tcl $sname $inst_id  $1 >> $locpth/LOG/$logfile; then
        print "Script mas_debit_settlement_file.tcl $sname $inst_id  $1 completed successfully" | tee -a $locpth/LOG/$logfile
else
        mbody="$SYS_BOX Script mas_debit_settlement_file.tcl $sname $inst_id  $1 Failed"
        print "$mbody_c $sysinfo $mbody" | mutt -s "$msubj_c" -- $mailtolist
fi

print "Ending at `date +%Y%m%d%H%M%S`" >> $locpth/LOG/$logfile


inst_id="121"
sname="JETPAYESQ"
logfile="debit_mas_file.log"

print "Beginning at `date +%Y%m%d%H%M%S`" >> $locpth/LOG/$logfile

if ./mas_debit_settlement_file.tcl $sname $inst_id  $1 >> $locpth/LOG/$logfile; then
        print "Script mas_debit_settlement_file.tcl $sname $inst_id  $1 completed successfully" | tee -a $locpth/LOG/$logfile
else
        mbody="$SYS_BOX Script mas_debit_settlement_file.tcl $sname $inst_id  $1 Failed"
        print "$mbody_c $sysinfo $mbody" | mutt -s "$msubj_c" -- $mailtolist
fi

inst_id="105"
sname="JETPAYSQ"
logfile="debit_mas_file.log"

print "Beginning at `date +%Y%m%d%H%M%S`" >> $locpth/LOG/$logfile

if ./mas_debit_settlement_file.tcl $sname $inst_id  $1 >> $locpth/LOG/$logfile; then
        print "Script mas_debit_settlement_file.tcl $sname $inst_id $1 completed successfully" | tee -a $locpth/LOG/$logfile
else
        mbody="$SYS_BOX Script mas_debit_settlement_file.tcl $sname $inst_id  $1 Failed"
        print "$mbody_c $sysinfo $mbody" | mutt -s "$msubj_c" -- $mailtolist
fi

print "Ending at `date +%Y%m%d%H%M%S`" >> $locpth/LOG/$logfile
