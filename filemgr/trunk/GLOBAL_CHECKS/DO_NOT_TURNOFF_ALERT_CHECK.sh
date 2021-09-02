#!/usr/bin/ksh
. /clearing/filemgr/.profile

# $Id: DO_NOT_TURNOFF_ALERT_CHECK.sh 3420 2015-09-11 20:05:17Z bjones $
# modified to do daily log for log size. rk

locpth=/clearing/filemgr/GLOBAL_CHECKS
cd $locpth

print "`date +%Y%m%d%H%M%S` Beginning alert check" | tee -a $locpth/LOG/`date +%Y%m%d`-alert.log

if ./recv_alert_file.exp >> $locpth/LOG/`date +%Y%m%d`-alert.log
then
	msg=""
	#print "Script recv_alert_file.exp completed successfully" | tee -a $locpth/LOG/`date +%Y%m%d`-alert.log
else
	echo "$locpth/recv_alert_file.exp failed" | mailx -r clearing@jetpay.com -s "$SYS_BOX \n$locpth \nScript recv_alert_file.exp Failed" $MAIL_TO
fi
