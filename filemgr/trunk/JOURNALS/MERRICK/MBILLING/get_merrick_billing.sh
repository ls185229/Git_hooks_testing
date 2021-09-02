#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile


print "Beginning  MOVE TXN at `date +%Y%m%d%H%M%S`"

export ORACLE_SID=trnclr1
export TWO_TASK=trnclr1
echo $ORACLE_HOME
echo $TWO_TASK

cnt=0
HOST_NAME=`hostname`
#EMAIL_LIST="rkhan@jetpay.com"
EMAIL_LIST="clearing@jetpay.com assist@jetpay.com"
mail_list="clearing@jetpay.com"
#mail_list="rkhan@jetpay.com"
print "\nPTI runpti.sh started on" `date +'%m/%d/%y @ %H:%M:%S'`

TIME_STAMP=`date +%Y%m%d%H%M%S`
HOST_NAME=`hostname`

notify_someone()
{
   echo $1 | mailx -r clearing@jetpay.com -s "$SYS_BOX: $code_name File Processing Error ***" $EMAIL_LIST
}



if get_merrick_billing.exp >> ./LOG/merrick_billing.log
then
	print "get_merrick_billing.exp successful" 
else 
	print "get_merrick_billing.exp failed"
	notify_someone "get_merrick_billing.exp run failed"
fi

