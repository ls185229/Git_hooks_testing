#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: wells_fargo_send_thinfile.tcl 4605 2018-06-06 17:25:20Z bjones $
# $Rev: 4605 $
################################################################################

################################################################################
#
#    File Name     wells_fargo_send_thinfile.tcl
#
#    Description   This script will upload the monthly Wells Fargo thin file
#                  to Wells Fargo.
#
#    Arguments     $1 Date to run the report. e.g. YYYYMMDD
#                  This script can run with or without a date. If no date
#                  provided it will use start and end of the last month. With
#                  one date argument, the script will calculate the month start
#                  and end based on the given date.
#
#    Example       With date argument:  wells_fargo_thinfile.tcl -d 20140501
#
#    Return        0 = Success
#                  1 = Fail
#
################################################################################

package require Oratcl

# Setting up the date range
global mail_to 

set mail_to "Reports-clearing@jetpay.com; jbeene@jetpay.com"

if { [regexp -- {(-[dD])[ ]+([0-9]{8,8})} $argv dummy1 dummy2 date_arg] } {
      puts "Date argument: $date_arg"
      set given_date $date_arg
}

if {![info exists given_date]} {
      set report_date [clock format [clock seconds] -format "%Y%m"]
      set file_date $report_date
      append file_date "01"
      set end_date $report_date
      append end_date "01160000"
      set start_date  [clock format [clock add [clock scan $report_date -format "%Y%m"] -1 months] -format "%Y%m"]
      append start_date "01160000"
} else {
      set report_date [clock format [clock scan $given_date -format %Y%m%d ] -format %Y%m]
      set file_date $report_date
      append file_date "01"
      set start_date $report_date
      append start_date "01160000"
      set end_date    [clock format [clock add [clock scan $given_date -format "%Y%m%d"] +1 months] -format "%Y%m"] 
      append end_date "01160000"
}
set lastdayprevmonth [clock format [clock add [clock scan $file_date] -1 day] -format "%Y%m%d"]

puts "Wells Fargo upload Started at: [clock format [clock seconds] -format "%Y%m%d@%H:%M:%S"]"

puts "Report Date: $report_date"
puts "Start Date:  $start_date"
puts "End Date:    $end_date"
puts "File Date:   $file_date"
puts "Last Date Prev Month: $lastdayprevmonth"

set fileName "1245_AltE_$lastdayprevmonth"
append fileName "_Jetpay_ThinFile.tsv"

puts "Report Name to upload: $fileName"

##################
#####  MAIN  #####
##################

exec echo "Wells Fargo thin file upload was completed at [clock format [clock seconds] -format "%Y%m%d@%H:%M:%S"]" | mutt -s "WF Thin File Upload" $mail_to 
exec upload.exp $fileName
exec mv $fileName ARCHIVE

exit 0 
