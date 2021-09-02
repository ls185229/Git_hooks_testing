#!/usr/bin/ksh
. /clearing/filemgr/.profile

################################################################################
# $Id: multi_visa_split.sh 4690 2018-09-06 18:47:08Z fcaron $
# $Rev: 4690 $
################################################################################
#
# File Name:  multi_inst_base2_report.sh
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
email_lst="reports-clearing@jetpay.com"
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

export rpt_run_dt=`date +%Y%m%d`
export rpt_dash_dt=`date +%Y-%m-%d`

recv_file_ftp.exp >> $locpth/LOG/$logfile 

if ./multi_visa_split.py $1 >> $locpth/LOG/$logfile; then
	print "\nScript multi_visa_split.py completed successfully" | tee -a $locpth/LOG/$logfile
	gzip $locpth/EP747.txt
	mv ./EP747.txt.gz $locpth/ARCHIVE/EP747.txt-$run_date.gz
else
	mbody="$SYS_BOX Script multi_visa_split.py Failed"
	print "$mbody_c $sysinfo $mbody" | mutt -s "$msubj_c" -- $mailtolist
fi

for f in 101 107 117 121 122 127 129 130 132 133 134 ;
    do echo $f;
    echo ls -l $locpth/VSDailyReports-$f*$rpt_run_dt*zip;
    ls -l $locpth/VSDailyReports-$f*$rpt_run_dt*zip
    mutt -s "$f Visa Daily Reports $rpt_dash_dt" -a $locpth/VSDailyReports-$f*$rpt_run_dt*zip  -- $email_lst < /dev/null 
done

#
# No Archive logic for Extract File, yet
# once 132 & 133 are turned on, add them here
for i in 130 134;
    do echo send b2payments file to peoples
    cp $locpth/VSDailyReports-$i*$rpt_run_dt*zip $locpth/INST_129/UPLOAD/ ;
    cd $locpth/INST_129/UPLOAD/
    upload.exp VSDailyReports-$i*$rpt_run_dt*zip 
    cd ../..
done

for i in 121 122 ;
    do echo send das file to esquire
    cp $locpth/VSDailyReports-$i*$rpt_run_dt*zip $locpth/INST_121/UPLOAD/ ;
    cd $locpth/INST_121/UPLOAD/
    upload.exp VSDailyReports-$i*$rpt_run_dt*zip 
    cd ../..
done

for i in 117 122;
    do echo $locpth/VSDailyReports-$i*$rpt_run_dt*zip ;
    echo mv $locpth/VSDailyReports-$i*$rpt_run_dt*zip $locpth/INST_$i/UPLOAD/ ;
    mv $locpth/VSDailyReports-$i*$rpt_run_dt*zip $locpth/INST_$i/UPLOAD/ ;

    echo cd $locpth/INST_$i/UPLOAD/
    cd $locpth/INST_$i/UPLOAD/
    echo upload.exp VSDailyReports-$i*$rpt_run_dt*zip \>\> ftp.log

    if ls VSDailyReports-$i*Credit-$rpt_run_dt*zip 1> /dev/null 2>&1; then
       upload.exp VSDailyReports-$i*Credit-$rpt_run_dt*zip \>\> ftp.log
    fi

    if ls VSDailyReports-$i*Debit-$rpt_run_dt*zip 1> /dev/null 2>&1; then
       upload.exp VSDailyReports-$i*Debit-$rpt_run_dt*zip \>\> ftp.log
    fi
    
    echo cd ../..
    cd ../..
done

mv $locpth/VSDailyReports-999*$rpt_run_dt* $locpth/INST_000/ARCHIVE/ ;

for i in 000 101 107 117 121 122 127 129 130 132 133 134 ;
    do echo $locpth/$i*.zip ;
    echo mv $locpth/VSDailyReports-$i*$rpt_run_dt*zip $locpth/INST_$i/ARCHIVE/ ;
    mv $locpth/VSDailyReports-$i*$rpt_run_dt*zip $locpth/INST_$i/ARCHIVE/ ;
    echo mv $locpth/VSDailyReports-$i*$rpt_run_dt*epd $locpth/INST_$i/ARCHIVE/ ;
    mv $locpth/VSDailyReports-$i*$rpt_run_dt*epd $locpth/INST_$i/ARCHIVE/ ;
done

mv $locpth/VSDailyReports-999*$rpt_run_dt*epd $locpth/INST_000/ARCHIVE/ ;

print "Ending at `date +%Y%m%d%H%M%S`" >> $locpth/LOG/$logfile
