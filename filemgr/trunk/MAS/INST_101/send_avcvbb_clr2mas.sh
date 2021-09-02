#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

box=$SYS_BOX
mailtolist=$MAIL_TO
mailfromlist=$MAIL_FROM

locpth="/clearing/filemgr/MAS/INST_101"

cd $locpth 


codename="send_avcvbb_clr2mas.tcl"
lgfname="avscvvbin.log"


print "Beginning  $codename for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/$lgfname

if $codename jetpay 101 `date +%Y%m%d` >> $locpth/LOG/$lgfname; then
	print "Script $codename completed" | tee -a $locpth/LOG/$lgfname
else
	echo "Script $codename failed" | mailx -r $mailfromlist -s "$box :: MAS :: Priority Critical- Call On-Call Engr. immidiately" $mailtolist 
fi

print "Ending $codename for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/$lgfname

