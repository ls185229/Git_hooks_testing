#!/usr/bin/env tclsh

################################################################################
# $Id: test_build_filename.tcl 3649 2016-01-22 21:01:04Z bjones $
# $Rev: 3649 $
################################################################################

# test tcl script for build_filename.py

if { "[lindex $argv 0]" != "" } {
    set jday [lindex $argv 0]
} else {
    set jday 5299
}

set dbt_filename [exec build_filename.py -i 107 -f DEBITRAN -j $jday]
set clr_filename [exec build_filename.py -i 107 -f CLEARING -j $jday]
set cnv_filename [exec build_filename.py -i 107 -f CONVCHRG -j $jday]

puts "dbt_filename = $dbt_filename"
puts "clr_filename = $clr_filename"
puts "cnv_filename = $cnv_filename"
