#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile


cd /clearing/filemgr/REJECTS
print "Beginning Check started at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/REJECTS/LOG/clr_sus_err_chk.log



if /clearing/filemgr/REJECTS/trans_sus_err_chk.tcl >> /clearing/filemgr/REJECTS/LOG/clr_sus_err_chk.log; then

    print "successful." | tee -a /clearing/filemgr/REJECTS/LOG/clr_sus_err_chk.log

else
    print "Script trans_sus_err_chk.sh Failed." | tee -a /clearing/filemgr/REJECTS/LOG/clr_sus_err_chk.log 
    echo "Script trans_sus_err_chk.sh Failed." | mailx -r $MAIL_FROM -s "$SYS_BOX :: Priority : High - Clearing and Settlement" $MAIL_TO
fi
print "End Check Ended at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/REJECTS/LOG/clr_sus_err_chk.log

