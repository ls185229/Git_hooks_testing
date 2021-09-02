#!/usr/bin/bash

#$Id: daily_dfw_report.sh 4213 2017-06-26 14:36:17Z bjones $

CRON_JOB=1
export CRON_JOB
. /clearing/filemgr/.profile

if [ $# == 0 ]
then

	dfw_report_4_acct.tcl &

else

	dfw_report_4_acct.tcl $1 &

fi

