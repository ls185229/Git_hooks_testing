#!/usr/bin/ksh

#added new section for code qual_daily_sumry.tcl-105 20070330
#added qual_daily_by_inst.tcl 20081008

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

locpth=$PWD

cd $locpth


print "Beginning  QUALLIFICATION REPORT at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/qual.log

if $locpth/qual_daily_sumry.tcl-105 >> $locpth/LOG/qual.log; then
        print "Script qual_daily_sumry.tcl-105 completed" | tee -a $locpth/LOG/qual.log
else
        print "$locpth/qual_daily_sumry.tcl-105 Script failed" | tee -a $locpth/LOG/qual.log
        echo "$locpth/qual_daily_sumry.tcl-105 Script failed" | mailx -r $MAIL_FROM -s "$SYS_BOX: $locpth/qual_daily_sumry.tcl-105 Script failed" $MAIL_TO
fi

print "Ending QUALIFICATION REPORT at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/qual.log


print "Beginning  qual_daily_by_inst.tcl at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/qual.log

if $locpth/qual_daily_by_inst.tcl 105 >> $locpth/LOG/qual.log; then
        print "Script qual_daily_by_inst.tcl for 105 completed" | tee -a $locpth/LOG/qual.log
else
        print "$locpth/qual_daily_by_inst.tcl for 105  failed" | tee -a $locpth/LOG/qual.log
        echo "$locpth/qual_daily_by_inst.tcl for 105  failed" | mailx -r $MAIL_FROM -s "$SYS_BOX: $locpth/qual_daily_by_inst.tcl for 105 failed" $MAIL_TO
fi