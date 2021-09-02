#!/usr/bin/env tclsh
source $env(MASCLR_LIB)/masclr_tcl_lib
for {set x 0} {$x<10} {incr x} {
	MASCLR::mutt_send_mail "sm251115@ncr.com" "IGNORE Testing mutt $argv $x" "Testing mutt" "134.Ach_Report.20161207.csv"
}
