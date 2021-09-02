#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: delete_files_fmgr.tcl 4573 2018-05-18 20:43:39Z bjones $
# $Rev: 4573 $
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

