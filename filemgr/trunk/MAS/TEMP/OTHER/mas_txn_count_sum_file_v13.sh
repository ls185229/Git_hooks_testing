#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

export ORACLE_SID=$ATH_DB
export TWO_TASK=$ATH_DB
echo $ORACLE_HOME
echo $TWO_TASK

cd /clearing/filemgr/MAS 
print "Beginning  MAS FILE for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/MAS/LOG/maslog.txt



if mas_txn_count_sum_file_v13.tcl teihost quikdraw masclr masclr 447474 jetpay `date +%Y%m%d` >> /clearing/filemgr/MAS/LOG/maslog.txt; then
	print "Script mas_txn_count_sum_file_v13.tcl completed" | tee -a /clearing/filemgr/MAS/LOG/maslog.txt
else
	echo "Script mas_txn_count_sum_file_v13.tcl failed" | mailx -r clearing@jetpay.com -s "Prod: MAS: Script mas_txn_count_sum_file_v13.tcl Failed" clearing@jetpay.com assist@jetpay.com
                        exit 1
fi




print "Ending MAS FILE for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/MAS/LOG/maslog.txt

