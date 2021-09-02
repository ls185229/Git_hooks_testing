#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

package require Oratcl
package provide random 1.0

set clrpath "/clearing/clradmin/pdir20060407/ositeroot/data"
set maspath "/clearing/masadmin/pdir20060105/ositeroot/data"

set logdate [clock seconds]
set curdate [clock format $logdate -format "%Y%m%d"]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]
puts "                                                            "
puts "----- NEW LOG -------------- $logdate ----------------------"
set pth "/clearing/filemgr/IPM"
set x ""
set y ""
set xfile ""
set yfile ""
set xfsize ""
set yfsize ""
set zerobyte 0
set flder "" 
catch {set x [exec find . -name TT*]} result

if {$x == ""} {
    exec echo "NO T140 FILES FOUND" | mailx -r reports-clearing@jetpay.com -s "No T140 files found in IPM folder" clearing@jetpay.com assist@jetpay.com
    exit 1
}

set i 0
set dummy ""
set dummy1 ""
set flder "MCDailyReports-$curdate"
exec mkdir $flder

foreach file $x {
    set ipm [string range [lindex $x $i] 2 end]
    exec cp $ipm /clearing/filemgr/REJECTS/.
    after 200
    set rename "DT$curdate.$ipm"
    exec cp $ipm $rename
    exec cp $rename $flder
    puts $ipm 
    puts $rename
    file delete $ipm
    set i [expr $i + 1]
}

exec zip -r $flder $flder
set zipflder $flder.zip
puts $zipflder
catch [exec email_reports.tcl $zipflder >> LOG/xfermfe.log] result1

exec rm -r $flder

set logdate [clock seconds]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]

puts "------END OF IPM REPORT FILES-------$logdate-------------"
puts "                                                          "
