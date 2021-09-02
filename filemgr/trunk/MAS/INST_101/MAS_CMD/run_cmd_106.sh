#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile
export ORACLE_SID=$IST_DB
export TWO_TASK=$IST_DB

cmdno="106"
inst_id="101"
locpth="/clearing/filemgr/MAS/INST_101"

cd $locpth/MAS_CMD

print "Beginning  MAS CMD $cmdno for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/cj_log.txt

if $locpth/MAS_CMD/sch_cmd.tcl $inst_id $cmdno >> $locpth/LOG/cmd.log; then 
	print "Script sch_cmd.tcl for cmd $cmdno  inst $inst_id completed" | tee -a $locpth/LOG/cmd.log
else
	echo "sch_cmd.tcl failed" | mailx -r $MAIL_FROM -s "$SYS_BOX: Script sch_cmd.tcl for cmd $cmdno inst_id $inst_id Failed" $MAIL_TO
fi


print "Ending MAS CMD for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/cj_log.txt

