#!/usr/bin/env tclsh
#/home/rkhan/.profile





#package require Oratcl
package require Oratcl

set logdate [clock seconds]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]
puts " "
puts "----- NEW LOG -------------- $logdate ----------------------"
puts "----- Updating MAS task 100 --------------------------------------"
set curdate [clock seconds]
set curdate [clock format $curdate -format "%Y%m%d"]
set cdate [clock seconds]
set cdate [clock format $cdate -format "%Y%m%d%H%M%S"]
set r_hr [clock format [clock scan "08:01:06 AM"] -format "%H"]
#set r_hr [clock format $r_hr -format "%H"]

puts $r_hr
set r_min [clock seconds]
set r_min [clock format $r_min -format "%M"]
puts $r_min
#Temp variable for total sum (tot) and total count (totitm)
set fname "COUNTING"
set f_seq 1
set fileno $f_seq
set fileno [format %03s $f_seq]
set one "01"
set pth ""
set dot "."
set fname "COUNTING"
set ins_id "100"
set jdate [clock seconds] 
set jdate [clock format $jdate -format "%y%j"]

puts "before"
after 3  
puts "after"
