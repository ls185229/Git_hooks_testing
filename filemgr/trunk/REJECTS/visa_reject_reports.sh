#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

export TMOUT=9999999999999
cd /clearing/filemgr/REJECTS
print "Beginning BASE2 FILE  Check started at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/REJECTS/LOG/epdfiles.log



if /clearing/filemgr/REJECTS/multi_bin_base2_rej_report.tcl EP20 `date +%Y%m%d` >> /clearing/filemgr/REJECTS/LOG/epdfiles.log; then
	print "Script /clearing/filemgr/REJECTS/multi_bin_base2_rej_report.tcl EP20 `date +%Y%m%d` successful"
else
    print "Script /clearing/filemgr/REJECTS/multi_bin_base2_rej_report.tcl `date +%Y%m%d` Failed." | tee -a /clearing/filemgr/REJECTS/LOG/epdfiles.log 
    echo "Script /clearing/filemgr/REJECTS/multi_bin_base2_rej_report.tcl `date +%Y%m%d` Failed." | mailx -r $MAIL_FROM -s "$SYS_BOX :: Priority : High - Clearing and Settlement" $MAIL_TO
fi
print "End of BASE2 FILE  Check Ended at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/REJECTS/LOG/epdfiles.log

