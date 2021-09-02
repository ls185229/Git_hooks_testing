#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: delete_files_fmgr.tcl 3724 2016-04-05 22:27:58Z millig $
# $Rev: 3724 $
################################################################################
#
# File Name:  delete_files_fmgr.tcl
#
# Description:  This program deletes incoming institution MasterCard report 
#               files after they have been processed for the day.
#              
# Script Arguments:  None.
#
# Output:  None.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

package require Oratcl
package provide random 1.0

file delete /clearing/filemgr/IPM/DT*

set logdate [clock seconds]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]

