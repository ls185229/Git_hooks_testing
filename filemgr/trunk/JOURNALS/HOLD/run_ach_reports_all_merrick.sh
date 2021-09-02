#!/usr/bin/bash
. /clearing/filemgr/.profile

#$Id: run_ach_reports_all_merrick.sh 2376 2013-07-30 13:12:30Z bjones $

source $MASCLR_LIB/mas_env.sh

if [ $# == 0 ]
then

    ach_report.tcl -i 101 &

    ach_report.tcl -i 107 &

else

    ach_report.tcl -i 101 -d $1 &

    ach_report.tcl -i 107 -d $1 &

fi

