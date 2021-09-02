#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

package require Oratcl
#package require Oratcl
package provide random 1.0

set clrpath "/clearing/clradmin/pdir20051024/ositeroot/data"
set maspath "/clearing/masadmin/pdir20060105/ositeroot/data"

puts "SENDING EMAIL TO BANCORP++++++++++++++++++++++"
set logdate [clock seconds]
set curdate [clock format $logdate -format "%Y%m%d"]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]


set x ""
set zipflder [lindex $argv 0] 

exec mutt -a $zipflder -s "Daily MC Reports $zipflder" clearing@jetpay.com < body.txt

exec mv $zipflder ARCHIVE/$env(SYS_BOX)-$zipflder

set logdate [clock seconds]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]

puts "------EMIAL SENT -------$logdate-------------"
puts "                                                          "
