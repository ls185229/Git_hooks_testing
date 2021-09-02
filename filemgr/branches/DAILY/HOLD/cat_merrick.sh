#!/usr/bin/ksh
. /clearing/filemgr/.profile

# $Id: cat_merrick.sh 4054 2017-02-06 23:16:14Z millig $

err_mailto="clearing@jetpay.com"

locpth=/clearing/filemgr/JOURNALS/DD/
logfile=$locpth/LOG/reports.log

print "cating Merrick Rollup Report at `date +%Y%m%d%H%M%S`" | tee -a $logfile

if tclsh cat_merrick.tcl >> $logfile; then
   echo "cat_merrick.tcl successful\n" | tee -a $logfile
else
   print "cat_merrick.tcl run FAILED at `date +%Y%m%d%H%M%S`" | tee -a $logfile    
   echo "tail -30 $logfile" | mutt -s "cat_merrick script failed" "$err_mailto"
fi
