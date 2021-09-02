#!/usr/bin/bash
. /clearing/filemgr/.profile

###############################################################################
# $Id: ach_report_run-105.sh 2492 2014-01-07 19:04:45Z mitra $
# $Rev: 2492 $
################################################################################
#
# File Name:  ach_report_run-105.sh
#
# Description:  This script initiates the generation of ACH reports for
#               Synovuos/Meridian Banks.
#
# Shell Arguments:  -d = Run date (e.g., YYYYMMDD).  Optional.
#                        Defaults to current date.
#
# Script Arguments:  -d = Run date (e.g., YYYYMMDD).  Optional.
#                    -i = Institution ID (e.g., ALL, 101, 105, 107, 802).
#                         Optional.  No default.
#
# Output:  ACH report for Synovuos/Meridian Banks by institution.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
################################################################################

source $MASCLR_LIB/mas_env.sh

if [ $# == 0 ]
then
    ach_report.tcl -i 105 &
else
    ach_report.tcl -i 105 -d $1 &
fi

