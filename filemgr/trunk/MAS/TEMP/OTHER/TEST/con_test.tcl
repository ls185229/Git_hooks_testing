#!/usr/bin/env tclsh
#/home/rkhan/.profile






#package require Oratcl
package require Oratcl

proc load_array {aname str lst} {
    upvar $aname a

    for {set i 0} {$i < [llength $str]} { incr i} {
        set a([string touppe [lindex $lst $i]]) [lindex $str $i]
    }
};# end load_array


if {[catch {set db_logon_handle [oralogon masclr/masclr@masclr]} result]} {
        puts "Merchant boarding failed to run"

puts $result
exit

}

set cdate [clock seconds]
set cdate [clock format $cdate -format "%d-%b-%y"]
puts $cdate 
  set rightnow [clock seconds]
  set rightnow [clock format $rightnow -format "%Y%m%d"]
set a ""
set x 0
set y {} 
set z {}
if {[catch {set pull_mer_from_merchant [oraopen $db_logon_handle]} result]} {
puts "did not open"
}
while { $x < 3} {
set chk_sum [oraopen $db_logon_handle]
set sql "select to_char(GL_DATE, 'YYYYMMDD') from gl_chart_of_acct where institution_id='447474'"
#puts $sql
orasql $pull_mer_from_merchant $sql
set t [orafetch $pull_mer_from_merchant -datavariable z] 
set err [oramsg $pull_mer_from_merchant rc]
puts $err
set z "20060211"
puts $z

if { $z == $rightnow} {
puts "good to go"
} elseif {$z < $rightnow} {
puts "gl command ran"
after 300000
orafetch $pull_mer_from_merchant -datavariable z
set dif [expr $z - $rightnow]
if {$dif < 0} {
puts "running gl_export"
} else {
puts "date is in future"
}

} elseif {$z > $rightnow} {
set sdate [clock format [ clock scan "+1 day" ] -format %Y%m%d]
puts $sdate
}

set x [expr $x + 1]
}
