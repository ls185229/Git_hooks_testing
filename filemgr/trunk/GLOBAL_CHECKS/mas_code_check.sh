#!/usr/bin/ksh


CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile


locpth=/clearing/filemgr/GLOBAL_CHECKS/


cd $locpth

print "Beginning CHK TXN at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/mcd_chk.log

export ORACLE_SID=$ATH_DB
export TWO_TASK=$ATH_DB
echo $ORACLE_HOME
echo $TWO_TASK

if ./mas_code_check.tcl $1 | tee -a $locpth/LOG/mcd_chk.log; then
	print "Script mas_code_check.tcl $1 completed successfully" | tee -a $locpth/LOG/mcd_chk.log
else
	echo "$locpth/mas_code_check.tcl $1 failed" | mailx -r clearing@jetpay.com -s "$SYS_BOX \n$locpth \nScript mas_code_check.tcl Failed" $MAIL_TO
fi

print "Ending chk TXN at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/mcd_chk.log
