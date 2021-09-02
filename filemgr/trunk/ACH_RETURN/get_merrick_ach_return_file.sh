#!/usr/bin/ksh

# $Id: get_merrick_ach_return_file.sh 4745 2018-10-12 21:09:48Z bjones $

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

#export ORACLE_SID=$ATH_DB
#export TWO_TASK=$ATH_DB
#echo $ORACLE_HOME
#echo $TWO_TASK

locpth=/clearing/filemgr/ACH_RETURN/

cd $locpth/


print "Beginning Merrick ACH Return file download at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/merrick_dnload.log

if merrick_ach_return_file_dnload.exp >> $locpth/LOG/merrick_dnload.log; then
	echo "Merrick ACH Return file download completed successfully." | tee -a $locpth/LOG/merrick_dnload.log
else
	print "Merrick ACH Return file download FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/merrick_dnload.log
	tail -11 $locpth/LOG/merrick_dnload.log | mailx -s "$SYS_BOX Merrick ACH Return file download FAILED.  Location: $locpth/merrick_ach_return_file_dnload.exp" clearing@jetpay.com
fi

