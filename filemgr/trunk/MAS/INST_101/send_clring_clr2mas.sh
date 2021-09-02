#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

export ORACLE_SID=$CLR_DB
export TWO_TASK=$CLR_DB
echo $ORACLE_HOME
echo $TWO_TASK

locpth=/clearing/filemgr/MAS/INST_101

cd $locpth 

print "Beginning  CLEARING FILE TRANSFER at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/xferclr.log

if send_clring_clr2mas.tcl 101 >> $locpth/LOG/xferclr.log; then
	print "Script send_clring_clr2mas.tcl completed" | tee -a $locpth/LOG/xferclr.log
else
	echo "Script $locpth/send_clring_clr2mas.tcl failed" | mailx -r $MAIL_FROM -s "$SYS_BOX : MAS: send_clring_clr2mas.tcl Failed" $MAIL_TO
        exit 1
fi

print "Ending CLEARING FILE TRANSFER at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/xferclr.log

