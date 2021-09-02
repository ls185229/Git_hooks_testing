#!/usr/bin/ksh


CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile


locpth=/clearing/filemgr/GLOBAL_CHECKS/


cd $locpth

print "Beginning CHK LOG at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/TC57/LOG/log_chk.log

if recv_log_file_ftp.exp | tee -a $locpth/LOG/log_chk.log; then
	print "Script recv_log_file_ftp.exp completed successfully" | tee -a $locpth/LOG/log_chk.log
	if check_log_for_error.tcl INST_105 | tee -a $locpth/LOG/log_chk.log; then
       		 print "Script check_log_for_error.tcl completed successfully" | tee -a $locpth/LOG/log_chk.log

	else
       		 echo "$locpth/check_log_for_error.tcl failed" | mailx -r clearing@jetpay.com -s "$SYS_BOX \n$locpth \nScript check_log_for_error.tcl Failed" $MAIL_TO
	fi
else
	echo "$locpth/recv_log_file_ftp.exp failed" | mailx -r clearing@jetpay.com -s "$SYS_BOX \n$locpth \nScript recv_log_file_ftp.exp Failed" $MAIL_TO
fi

print "Ending chk LOG at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/log_chk.log
