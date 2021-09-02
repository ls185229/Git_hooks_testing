#!/usr/bin/ksh

#$Id: run_discover_ari.sh 1849 2012-10-05 22:06:53Z ajohn $

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

export ORACLE_SID=$ATH_DB
export TWO_TASK=$ATH_DB
echo $ORACLE_HOME
echo $TWO_TASK


locpth=/clearing/filemgr/JOURNALS/DISCOVER_ARI

cd $locpth

print "Beginning discover_ari.tcl at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/discover_ari.log


if tclsh discover_ari.tcl >> $locpth/LOG/discover_ari.log; then
   echo "discover_ari.tcl successful\n" | tee -a $locpth/LOG/discover_ari.log
else
   print "discover_ari.tcl run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/discover_ari.log
   tail -40 $locpth/LOG/discover_ari.log  | mutt -s "$SYS_BOX discover_ari.tcl report run failed. Location: $locpth" -- "clearing@jetpay.com"
   exit 1
fi

