#!/usr/bin/env bash

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

# cd /clearing/filemgr/MAS

echo "`date +%Y%m%d_%H%M%S` Beginning Check started" >> LOG/clr_sus_err_chk.log


if /clearing/filemgr/MAS/trans_sus_err_chk.tcl >> LOG/clr_sus_err_chk.log; then

    echo "`date +%Y%m%d_%H%M%S` successful." >> LOG/clr_sus_err_chk.log

else
    echo "`date +%Y%m%d_%H%M%S` Script trans_sus_err_chk.sh Failed." >> LOG/clr_sus_err_chk.log
    echo "Script trans_sus_err_chk.sh Failed." | mailx -r $MAIL_FROM -s "$SYS_BOX : trans_sus_err_chk.sh Failed : Priority : High - Clearing and Settlement" $MAIL_TO
fi
echo "`date +%Y%m%d_%H%M%S` End Check Ended" >> LOG/clr_sus_err_chk.log

