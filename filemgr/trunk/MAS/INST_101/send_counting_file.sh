#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile


locpth="/clearing/filemgr/MAS/INST_101"

cd $locpth

print "Beginning  COUNTING FILE xfer for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/xfercnt.log



if send_counting_file.tcl >> $locpth/LOG/xfercnt.log; then
	print "Script send_counting_file.tcl completed." | tee -a $locpth/LOG/xfercnt.log
else
	echo "Script send_counting_file.tcl failed" | mailx -r $MAIL_FROM -s "$SYS_BOX: MAS: send_counting_file.tcl Failed" $MAIL_TO
fi


print "Ending COUNTING FILE xfer for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/xfercnt.log

