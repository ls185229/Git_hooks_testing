#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile


cd /clearing/filemgr/REJECTS
print "Beginning BASE2 FILE reject Check started at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/REJECTS/LOG/rejchk.log



if /clearing/filemgr/REJECTS/recv_file_ftp.exp >> /clearing/filemgr/REJECTS/LOG/rejchk.log; then

    print "Transfer successful." | tee -a /clearing/filemgr/REJECTS/LOG/rejchk.log

else
    print "Script /clearing/filemgr/REJECTS/recv_file_ftp.exp Failed." | tee -a /clearing/filemgr/REJECTS/LOG/rejchk.log 
    echo "Script /clearing/filemgr/REJECTS/recv_file_ftp.exp Failed." | mailx -r $MAIL_FROM -s "$SYS_BOX :: Priority : High - Clearing and Settlement" $MAIL_TO
fi
print "End of BASE2 FILE reject Check Ended at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/REJECTS/LOG/rejchk.log

