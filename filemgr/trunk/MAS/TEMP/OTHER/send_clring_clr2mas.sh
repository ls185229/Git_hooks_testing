#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile



cd /clearing/filemgr/MAS 
print "Beginning  CLEARING FILE xfer for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/MAS/LOG/xferclr.log



if send_clring_clr2mas.tcl >> /clearing/filemgr/MAS/LOG/xferclr.log; then
	print "Script send_clring_clr2mas.tcl completed" | tee -a /clearing/filemgr/MAS/LOG/xferclr.log
else
	echo "Script send_clring_clr2mas.tcl failed" | mailx -r clearing@jetpay.com -s "Prod: CLR: send_clring_clr2mas.tcl Failed" clearing@jetpay.com assist@jetpay.com
                        exit 1
fi




print "Ending CLEARING FILE xfer for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/MAS/LOG/xferclr.log

print ">>>>>>>>>>" | tee -a /clearing/filemgr/MAS/LOG/xferclr.log
