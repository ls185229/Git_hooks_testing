#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

#package require Oratcl
package require Oratcl
package provide random 1.0

set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)

if {[file exists /clearing/filemgr/process.stop]} {
exec echo "PREVIOUS PROCESS NOT COMPLETED ALL OTHER PROCESSES STOPED : Msg sent from Counting Script send_counting_file.tcl" | mailx -r clearing@jetpay.com -s "PROD: MAS: URGENT!!! CALL SOMEONE :: PREVIOUS PROCESS NOT COMPLETED" clearing@jetpay.com assist@jetpay.com
exit 1
} else {
catch {open /clearing/filemgr/process.stop {WRONLY CREAT}} fileid
}


set x ""
set y ""


catch {set y [exec find /clearing/filemgr/MAS/MAS_FILES -mtime 0 | grep 447474.COUNTING*]} result 

if {$y == ""} {
exec echo "NO FILE FOUND" | mailx -r clearing@jetpay.com -s "PROD: MAS: COUNTING file not found in MAS folder" clearing@jetpay.com assist@jetpay.com
catch {file delete /clearing/filemgr/process.stop} result
exit 1
}
set i 0
if {[llength $y] >=  2} {
exec echo $x | mailx -r clearing@jetpay.com -s "PROD: MAS: Multiple COUNTING file found in MAS folder" clearing@jetpay.com assist@jetpay.com
exit 1
}

if {[llength $y] ==  1} {
exec cp -p [lindex $y 0] .
}

set counting [string range [lindex $y 0] 32 end]
puts $counting

exec chmod 775 /clearing/filemgr/MAS/$counting 
set dummy ""
set dummy [exec cp -p /clearing/filemgr/MAS/$counting $maspath/data/in]
puts $dummy
if {$dummy != ""} {
exec echo $y | mailx -r clearing@jetpay.com -s "PROD: MAS: Files not transfered to MASADMIN" clearing@jetpay.com assist@jetpay.com
} else {
#exec echo $y | mailx -r clearing@jetpay.com -s "PROD: MAS: Files transfered to MASADMIN" clearing@jetpay.com assist@jetpay.com
}


set err [exec mv MAS_FILES/$counting ARCHIVE]
if {$err == ""} {
exec rm $counting
}
catch {file delete /clearing/filemgr/process.stop} result

exec /clearing/filemgr/MAS/updt_mas_task.tcl 100 counting_xfer >> task.log
