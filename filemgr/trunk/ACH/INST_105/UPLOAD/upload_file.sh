#!/usr/bin/ksh


CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

#export ORACLE_SID=$ATH_DB
#export TWO_TASK=$ATH_DB
#echo $ORACLE_HOME
#echo $TWO_TASK


locpth=/clearing/filemgr/ACH/INST_105/

cd $locpth/UPLOAD

print "Beginning  FILE UPLOAD at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/upload.log

if upload.exp ach >> $locpth/LOG/upload.log; then
   echo "upload.exp successfully\n" | tee -a $locpth/LOG/upload.log
   mv *.ach ../ARCHIVE
else
   print "Ending FILE UPLOAD FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/upload.log
   tail -11 $locpth/LOG/upload.log  | mailx -r $MAIL_FROM -s "$SYS_BOX File upload to client Failed. Location: $locpth" $MAIL_TO
   exit 1
fi

print "Ending FILE UPLOAD at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/upload.log

