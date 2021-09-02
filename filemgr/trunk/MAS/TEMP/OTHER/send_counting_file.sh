#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile


cd /clearing/filemgr/MAS 
print "Beginning  COUNTING FILE xfer for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/MAS/LOG/xfercnt.log



if send_counting_file.tcl >> /clearing/filemgr/MAS/LOG/xfercnt.log; then
	print "Script send_counting_file.tcl completed." | tee -a /clearing/filemgr/MAS/LOG/xfercnt.log
else
	echo "Script send_counting_file.tcl failed" | mailx -r clearing@jetpay.com -s "Prod: MAS: send_counting_file.tcl Failed" clearing@jetpay.com assist@jetpay.com
                        exit 1
fi




print "Ending COUNTING FILE xfer for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/MAS/LOG/xfercnt.log

print "-----------------------------------------------------------------------------------------------" | tee -a /clearing/filemgr/MAS/LOG/xfercnt.log
