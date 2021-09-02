#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile


cd /clearing/filemgr/REJECTS
print "Beginning IPM FILE reject Check started at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/REJECTS/LOG/rejchk.log


if /clearing/filemgr/REJECTS/recv_file_frm_mfe.exp >> /clearing/filemgr/REJECTS/LOG/rejchk.log; then

    print "successful." | tee -a /clearing/filemgr/REJECTS/LOG/rejchk.log

else
    print "Script recv_file_frm_mfe.exp Failed." | tee -a /clearing/filemgr/REJECTS/LOG/rejchk.log
    echo "Script recv_file_frm_mfe.exp Failed." | mailx -r $MAIL_FROM -s "$SYS_BOX :: Priority : High - Clearing and Settlement" $MAIL_TO
fi


err=`grep "FILE LEVEL REJECT" TT140*`

if [[ $err == "" ]]
then
	print "No File Level error found"
else 
	echo "File level Rejects found: \n $err" | mailx -r $MAIL_FROM -s "$SYS_BOX :: Priority : Critical - Clearing and Settlement" $MAIL_TO
fi

print "End of IPM FILE reject Check Ended at `date +%Y%m%d%H%M%S`" | tee -a /clearing/filemgr/REJECTS/LOG/rejchk.log

