#!/usr/bin/ksh

#$Id: run_amex_tilr.sh 4060 2017-02-10 21:06:53Z millig $

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

export ORACLE_SID=$ATH_DB
export TWO_TASK=$ATH_DB
echo $ORACLE_HOME
echo $TWO_TASK


locpth=/clearing/filemgr/JOURNALS/AMEX_TILR

cd $locpth

print "Beginning amex_tilr.tcl at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/amex_tilr.log


if tclsh amex_tilr.tcl >> $locpth/LOG/amex_tilr.log; then
   echo "amex_tilr.tcl successful\n" | tee -a $locpth/LOG/amex_tilr.log
else
   print "amex_tilr.tcl run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/amex_tilr.log
   tail -40 $locpth/LOG/amex_tilr.log  | mutt -s "$SYS_BOX amex_tilr.tcl report run failed. Location: $locpth" "devans@jetpay.com"
   exit 1
fi

