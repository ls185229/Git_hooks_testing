#!/usr/bin/ksh


CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile


locpth=/clearing/filemgr/GLOBAL_CHECKS/


cd $locpth

print "Beginning CHK TXN at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/txn_chk.log

export ORACLE_SID=$ATH_DB
export TWO_TASK=$ATH_DB
echo $ORACLE_HOME
echo $TWO_TASK

sname=$1

if ./chk_txn.tcl $sname >> $locpth/LOG/txn_chk.log; then
	print "Script chk_txn.tcl $1 completed successfully" | tee -a $locpth/LOG/txn_chk.log
else
	echo "$locpth/chk_txn.tcl $1 failed" | mailx -r clearing@jetpay.com -s "$SYS_BOX \n$locpth \nScript chk_txn.tcl $1 Failed" $MAIL_TO
fi

print "Ending chk TXN at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/txn_chk.log
