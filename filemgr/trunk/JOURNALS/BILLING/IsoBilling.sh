#!/usr/bin/bash

################################################################################
# $Id: $
# $Rev: $
################################################################################
#
# File Name:  template.tcl
#
# Description:  This program generates the ISO Billing reports by institution.
#              
# Script Arguments:  -d = Run date (e.g., YYYYMMDD).  Set to the first day.  
#                         of the month.  Required.
#                    -I = Institution ID (e.g., ALL, 101, 105, 107, 802).  
#                         Optional.  No default.
#
# Output:  ISO billing reports by institution.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

nohup iso_billing.tcl -I 101 -d $1
nohup iso_billing.tcl -I 105 -d $1
nohup iso_billing.tcl -I 107 -d $1
nohup iso_billing.tcl -I 111 -d $1
nohup iso_billing.tcl -I 117 -d $1
nohup iso_billing.tcl -I 121 -d $1
