#!/usr/bin/bash
. /clearing/filemgr/.profile

################################################################################
# $Id: run_ach_reports_all_esquire.sh 2373 2013-07-29 16:34:01Z bjones $
# $Rev: 2373 $
################################################################################
#
# File Name:  run_ach_reports_all_esquire.sh
#
# Description:  This script initiates the generation of ACH reports for
#               Esquire Bamk.
#
# Shell Arguments:  -d = Run date (e.g., YYYYMMDD).  Optional.
#                        Defaults to current date.
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

source $MASCLR_LIB/mas_env.sh

if [ $# == 0 ]
then
    ach_report.tcl -i 121 &
else
    ach_report.tcl -i 121 -d $1 &
fi

