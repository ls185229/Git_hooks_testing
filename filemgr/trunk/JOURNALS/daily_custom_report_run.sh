#!/usr/bin/ksh

CRON_JOB=1
export CRON_JOB

. /clearing/filemgr/.profile

export ORACLE_SID=$ATH_DB
export TWO_TASK=$ATH_DB
echo $ORACLE_HOME
echo $TWO_TASK

locpth=/clearing/filemgr/JOURNALS/
cd $locpth
codenm="drv_america_daily_report.tcl"
lognm="drv_america_daily_report.log"


print "Beginning DAILY RUN $codenm at `date +%Y%m%d%H%M%S`" >> $locpth/LOG/$lognm

	if $codenm `date +%Y%m%d` >> $locpth/LOG/$lognm; then
   		echo "$codenm successful\n" >> $locpth/LOG/$lognm
	else
   		print "$codenm report run FAILED at `date +%Y%m%d%H%M%S`" >> $locpth/LOG/$lognm
   		tail -20 $locpth/LOG/$lognm  | mailx -r $MAIL_FROM -s "$SYS_BOX $codenm report run failed. Location: $locpth" $ml2_alerts
	fi

print "Ending DAILY RUN $codenm at `date +%Y%m%d%H%M%S`" >> $locpth/LOG/$lognm

locpth=/clearing/filemgr/JOURNALS/
cd $locpth
codenm="drv_america_daily_cb_rp_report.tcl"
lognm="drv_america_daily_cb_rp_report.log"


print "Beginning DAILY RUN $codenm at `date +%Y%m%d%H%M%S`" >> $locpth/LOG/$lognm

        if $codenm >> $locpth/LOG/$lognm; then
                echo "$codenm successful\n" >> $locpth/LOG/$lognm
        else
                print "$codenm report run FAILED at `date +%Y%m%d%H%M%S`" >> $locpth/LOG/$lognm
                tail -20 $locpth/LOG/$lognm  | mailx -r $MAIL_FROM -s "$SYS_BOX $codenm report run failed. Location: $locpth" $ml2_alerts
        fi

print "Ending DAILY RUN $codenm at `date +%Y%m%d%H%M%S`" >> $locpth/LOG/$lognm
