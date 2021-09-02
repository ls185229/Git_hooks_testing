#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile


cd /clearing/filemgr/MAS/MAS_CMD 
print "Beginning  MAS FILE for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/MAS/LOG/cj_log.txt

if sch_cmd.tcl 447474 138 >> /clearing/filemgr/MAS/MAS_CMD/GL.log; then 
	print "Script sch_cmd.tcl for cmd 138 completed" | tee -a /clearing/filemgr/MAS/LOG/cmd.log
else
	echo "/clearing/filemgr/MAS/MAS_CMD/sch_cmd.tcl failed" | mailx -r clearing@jetpay.com -s "Prod: Script sch_cmd.tcl for cmd 138 Failed" clearing@jetpay.com assist@jetpay.com
                        exit 1
fi


print "Ending MAS FILE for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/MAS/LOG/cj_log.txt

