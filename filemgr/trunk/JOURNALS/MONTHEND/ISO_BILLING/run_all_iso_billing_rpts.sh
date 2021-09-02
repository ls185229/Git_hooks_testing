#!/usr/bin/bash
. /clearing/filemgr/.profile

################################################################################
# $Id: run_all_iso_billing_rpts.sh 3666 2016-01-28 21:31:54Z bjones $
# $Rev: 3666 $
################################################################################
#
# File Name:  run_all_iso_billing_rpts.sh
#
# Description:  This script initiates the generation of monthly ISO billing
#               reports by institution.
#              
# Shell Arguments:   Run date (e.g., YYYYMMDD).  Optional.  
#                    Defaults to current date.
#
# Script Arguments:  -d = Run date (e.g., YYYYMMDD).  Optional.  
#                    -i = Institution ID (e.g. 101, 105, 107, 121).  
#                         No default.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
################################################################################

if [ $# == 0 ]
then
        iso_billing.tcl -i 101 &

	iso_billing.tcl -i 107 &

	iso_billing.tcl -i 105 &

	iso_billing.tcl -i 121 &

else
	iso_billing.tcl -i 101 -d $1 &

	iso_billing.tcl -i 107 -d $1 &

	iso_billing.tcl -i 105 -d $1 &

	iso_billing.tcl -i 121 -d $1 &
fi


