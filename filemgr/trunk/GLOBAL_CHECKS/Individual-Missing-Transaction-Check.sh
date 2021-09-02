#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

locpth=/clearing/filemgr/GLOBAL_CHECKS

cd $locpth

print "Beginning check FILE at `date +%Y%m%d%H%M%S`"

export ORACLE_SID=$ATH_DB
export TWO_TASK=$ATH_DB
echo $ORACLE_HOME
echo $TWO_TASK


if Arn-Tranhistory-Check.tcl >>  $locpth/Arn-Tranhistory-Check.tcl.log ; then
   echo "Tranhistory successful" >> $locpth/Arn-Tranhistory-Check.tcl.log
else
   echo "Arn-Tranhistory-Check.tcl for debit failed" | mailx -r clearing@jetpay.com -s "$SYS_BOX Script Arn-Tranhistory-Check.tcl Failed" clearing@jetpay.com
fi
