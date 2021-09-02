#!/usr/bin/ksh

#added new section for code qual_daily_sumry.tcl 20070330
#add qual_daily_by_inst.tcl syang 20081008
# stop qual_pdf.tcl daily run

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

locpth="/clearing/filemgr/QUALIFICATION/INST_107"

cd $locpth


print "Beginning  qual_daily_sumry.tcl at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/qual.log

if $locpth/qual_daily_sumry.tcl >> $locpth/LOG/qual.log; then
        print "Script qual_daily_sumry.tcl completed" | tee -a $locpth/LOG/qual.log
else
        print "$locpth/qual_daily_sumry.tcl Script failed" | tee -a $locpth/LOG/qual.log
        echo "$locpth/qual_daily_sumry.tcl Script failed" | mailx -r $MAIL_FROM -s "$SYS_BOX: $locpth/qual_daily_sumry.tcl Script failed" $MAIL_TO
fi

print "Ending qual_daily_sumry.tcl at `date +%Y%m%d%H%M%S`" | tee -a $locpth/LOG/qual.log

# set path for this global version script

locpth="/clearing/filemgr/QUALIFICATION"
cd $locpth

print "Beginning  qual_daily_by_inst.tcl for 107 at `date +%Y%m%d%H%M%S`" | tee -a $locpth/INST_107/LOG/qual.log

if $locpth/qual_daily_by_inst.tcl 107 >> $locpth/INST_107/LOG/qual.log; then 
	print "Script qual_daily_by_inst.tcl for 107 completed" | tee -a $locpth/INST_107/LOG/qual.log
else
	print "$locpth/qual_daily_by_inst.tcl for 107 failed" | tee -a $locpth/INST_107/LOG/qual.log
	echo "$locpth/qual_daily_by_inst.tcl for 107 failed" | mailx -r $MAIL_FROM -s "$SYS_BOX: $locpth/qual_daily_by_inst.tcl for 107 failed" $MAIL_TO
fi

print "Ending qual_daily_by_inst.tcl for 107 at `date +%Y%m%d%H%M%S`" | tee -a $locpth/INST_107/LOG/qual.log