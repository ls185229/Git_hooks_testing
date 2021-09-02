#!/usr/bin/env bash

# $Id: visa_dwngrd_chk.sh 4451 2017-12-19 17:19:07Z bjones $

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile


locpth=/clearing/filemgr/GLOBAL_CHECKS/
locpth=.


cd $locpth

export ORACLE_SID=$ATH_DB
export TWO_TASK=$ATH_DB
echo $ORACLE_HOME
echo $TWO_TASK

# export MAIL_TO="bjones@jetpay.com"

fname="visa_dwngrd_chk.tcl"
arg0=""
arg1=""
arg2=""
lgname="vsd_chk.log"

echo "Beginning $fname at `date +%Y%m%d%H%M%S`" >> $locpth/LOG/$lgname

if ./$fname $arg0 $arg1 $arg2 >> $locpth/LOG/$lgname; then
    echo "Script ./$fname $arg0 $arg1 $arg2 completed successfully" >> $locpth/LOG/$lgname
else
    echo "$locpth/$fname $arg0 $arg1 $arg2 failed" | mailx -r clearing@jetpay.com -s "$SYS_BOX \n$locpth \nScript $fname $arg0 $arg1 $arg2 Failed" $MAIL_TO
fi

echo "Ending $fname at `date +%Y%m%d%H%M%S`" >> $locpth/LOG/$lgname
