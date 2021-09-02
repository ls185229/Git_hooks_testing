#!/usr/bin/bash
. /clearing/filemgr/.profile

################################################################################
# $Id: run-all-daily-detail.sh 4054 2017-02-06 23:16:14Z millig $
# $Rev: 4054 $
################################################################################
#
# File Name:  run_all_daily_detail.sh
#
# Description:  This script initiates the generation of daily detail reports
#               by institution.
#              
# Shell Arguments:   Run date (e.g., YYYYMMDD).  Optional.  
#                    Defaults to current date.
#
# Script Arguments:  -d = Run date (e.g., YYYYMMDD).  Optional.  
#                    -i = Institution ID (e.g., ALL, 101, 105, 107, 802).  
#                         Optional.  No default.
#
# Output:  ACH report for Esquire Bank by institution.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
################################################################################

if [ $# == 0 ]
then
	nohup  all-daily-detail.tcl -i 101 &

	nohup  all-daily-detail.tcl -i 107 &

	nohup  all-daily-detail.tcl -i 101 -i 107 &

else
	nohup  all-daily-detail.tcl -i 101 -d $1 &

	nohup  all-daily-detail.tcl -i 107 -d $1 &

	nohup  all-daily-detail.tcl -i 101 -i 107 -d $1 &
fi


