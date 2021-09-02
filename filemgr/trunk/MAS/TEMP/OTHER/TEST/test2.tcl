#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

#package require Oratcl
package require Oratcl
package provide random 1.0
set clrfile ""
set x ""
set y ""
set i 0
set clearing ""
catch {set x [exec find /clearing/clradmin/pdir20051024/ositeroot/data/out/ipm -mtime 2 | grep ipm.exp.mc*]} result
if {[llength $x] >=  1} {
foreach clrfile $x {
	set fsize [file size $clrfile]
	set ftime [file mtime $clrfile]
	set fmtime [clock format $ftime -format "%Y%m%d%H%M%S"]
	set hmtime [clock format [clock seconds]]
	set hmtime [clock format $hmtime -format "%H:%M:%S"]
	puts $hmtime
	set htime [clock format $ftime -format "%H"]
	set tim [clock format [clock scan "$hmtime -2 hour"] -format "%H"]
	puts $tim
	if {$fsize != 0} {
		puts "[lindex $x $i] SIZE = $fsize last modified time = $fmtime "
		set i [expr $i + 1]
		set clearing [string range [lindex $x 0] 55 end]
	} else { 
	puts "NOT xfered : $clrfile size $fsize last modified time = $fmtime " 
	}	
}
}

