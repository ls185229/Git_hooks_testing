#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile


cd /clearing/filemgr/REJECTS
print "Beginning BASE2 FILE reject Check started at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/REJECTS/LOG/rejchk.log



if /clearing/filemgr/REJECTS/chk_for_visa_rejects.tcl >> /clearing/filemgr/REJECTS/LOG/rejchk.log; then

    print "successful." | tee -a /clearing/filemgr/REJECTS/LOG/rejchk.log

else
    print "Script chk_for_visa_rejects.tcl Failed." | tee -a /clearing/filemgr/REJECTS/LOG/rejchk.log 
    echo "Script chk_for_visa_rejects.tcl Failed." | mailx -r $MAIL_FROM -s "$SYS_BOX :: Priority : High - Clearing and Settlement" $MAIL_TO
fi
print "End of BASE2 FILE reject Check Ended at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/REJECTS/LOG/rejchk.log

