#!/usr/bin/env bash
# . ~/.profile

#######################################################################
# upload_monthend_reports.sh
# No parameters passed - run is for current date
# upload miscellanesous reports to the sftp file server
#######################################################################

export rpt_run_dt=`date +%Y%m%d`

CRON_JOB=1
export CRON_JOB

locpth=.
cd $locpth

cmd="upload_monthend_ippay.py"
echo "`date +%Y%m%d%H%M%S` - Beginning $cmd"

echo upload_monthend_ippay.sh \>\> LOG/upload_monthend_ippay_$rpt_run_dt.log
python upload_monthend_ippay.py >> LOG/upload_monthend_ippay_$rpt_run_dt.log 2>&1

if [ $? -eq 0 ]; then
    echo "`date +%Y%m%d%H%M%S` - $cmd successful\n"
else
    echo "`date +%Y%m%d%H%M%S`  - $cmd run FAILED with code $? "
    mutt -s "$SYS_BOX $cmd run failed with code $? - Location: $locpth" -- "clearing@jetpay.com, assist.payments@ncr.com"
fi
