#!/usr/bin/ksh
. /clearing/filemgr/.profile

################################################################################
# $Id: multi_inst_base2_report-132.sh 4406 2017-10-27 16:30:44Z bjones $
# $Rev: 4406 $
################################################################################
#
# File Name:  multi_inst_base2_report-132.sh
#
# Description:  This program initiates the parsing of the incoming Visa reports.
#
# Script Arguments:  $1 = Report date (e.g., YYYYMMDD).  Optional.
#                    Default = Today's date
#
# Output:  None.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

CRON_JOB=1
export CRON_JOB

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

run_date=`date +%Y%m%d`

locpth=$PWD
cd $locpth

######## MAIN ####################################

logfile="base2.epd.rpt.log"


print "Beginning at `date +%Y%m%d%H%M%S`" >> $locpth/LOG/$logfile

if ./multi_inst_base2_report-132.tcl $1 >> $locpth/LOG/$logfile; then
    print "\nScript multi_inst_base2_report-132.tcl completed successfully" | tee -a $locpth/LOG/$logfile
    gzip ./EP747.txt
    mv ./EP747.txt.gz ./ARCHIVE/EP747-132.txt-$run_date.gz
else
    mbody="$SYS_BOX Script multi_inst_base2_report-132.tcl Failed"
    print "$mbody_c $sysinfo $mbody" | mutt -s "$msubj_c" -- $mailtolist
fi

print "Ending at `date +%Y%m%d%H%M%S`" >> $locpth/LOG/$logfile
