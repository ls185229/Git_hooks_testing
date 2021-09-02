#!/usr/bin/env tclsh
for {set x 0} {$x<10} {incr x} {
    catch { exec echo "Testing mutt" | mutt -a "134.Ach_Report.20161207.csv" -s "IGNORE Testing mutt $argv $x" -- "bjones@internal.jetpay.com" } result
}
puts $result
