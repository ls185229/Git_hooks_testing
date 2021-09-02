#!/usr/bin/ksh


CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile


locpth=/clearing/filemgr/GLOBAL_CHECKS/


cd $locpth

print "Beginning CHK LOG at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/TC57/LOG/mc_log_chk.log

	if recv_mc_log_file_ftp.exp $1 $2 >> $locpth/LOG/mc_log_chk.log; then
       		 print "Script recv_mc_log_file_ftp.exp $1 $2 completed successfully" | tee -a $locpth/LOG/mc_log_chk.log

	else
       		 echo "$locpth recv_mc_log_file_ftp.exp $1 $2 failed" | mailx -r clearing@jetpay.com -s "$SYS_BOX \n$locpth \nrecv_mc_log_file_ftp.exp Failed" $MAIL_TO
	fi

print "Ending chk LOG at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/mc_log_chk.log
