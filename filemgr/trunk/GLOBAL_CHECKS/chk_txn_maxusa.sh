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

if ./chk_txn.tcl MAX_BANK | tee -a $locpth/LOG/txn_chk.log; then
	print "Script chk_txn.tcl completed successfully" | tee -a $locpth/LOG/txn_chk.log
else
	echo "$locpth/chk_txn.tcl failed" | mailx -r clearing@jetpay.com -s "$SYS_BOX \n$locpth \nScript chk_txn.tcl Failed" $MAIL_TO
fi

print "Ending chk TXN at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/txn_chk.log
