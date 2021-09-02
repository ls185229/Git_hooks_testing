#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

package require Oratcl
#package require Oratcl
package provide random 1.0

file delete /clearing/filemgr/IPM/DT*

set logdate [clock seconds]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]

