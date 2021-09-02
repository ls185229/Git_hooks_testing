#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

locpth="/clearing/filemgr/MAS/INST_101"

cd $locpth

print "Beginning  MAS FILE for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/cj_log.txt

if $locpth/mas_chgbck_file.tcl `date +%Y%m%d` >> $locpth/LOG/ch_back.log; then 
	print "Script $locpth/mas_chgbck_file.tcl  completed" | tee -a $locpth/LOG/ch_back.log
else
        echo "Assist Please call oncall immediately.\n Script $locpth/mas_chgbck_file.tcl failed" | mailx -r $MAIL_FROM -s "$SYS_BOX: MAS: Critical Script $locpth/mas_chgbck_file.tcl Failed" $MAIL_TO
fi

print "Ending MAS FILE for JETPAY at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/cj_log.txt

