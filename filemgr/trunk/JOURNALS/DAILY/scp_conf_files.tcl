#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

package require Oratcl

####################### UPDATE BELOW FOR NEW INST ###############################

set box $env(SYS_BOX)
global argv
global inst_dir
global inst_id

set inst_id [string trim [lindex $argv 0]]
set inst_dir "INST_$inst_id"

set reports_dir "/clearing/filemgr/ACH/$inst_dir/reports"
set dnload_dir  "/clearing/filemgr/ACH/$inst_dir/DOWNLOAD"
set mailtolist "reports-clearing@jetpay.com"
set mailfromlist "reports-clearing@jetpay.com"

##################################################################################

#Email Subjects variables Priority wise

set msubj_c "$box :: Priority : Critical - Clearing and Settlement"
set msubj_u "$box :: Priority : Urgent - Clearing and Settlement"
set msubj_h "$box :: Priority : High - Clearing and Settlement"
set msubj_m "$box :: Priority : Medium - Clearing and Settlement"
set msubj_l "$box :: Priority : Low - Clearing and Settlement"


#Email Body Headers variables for assist

set mbody_c "ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
set mbody_u "ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
set mbody_h "ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
set mbody_m "ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
set mbody_l "ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

####################################################################################

set logdate [clock seconds]
set curdate [clock format $logdate -format "%Y%m%d"]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]
puts " "
puts "NEW LOG B2B Confirmation Files - $logdate "

global scpresult
global newname
global filedate
global mailfile

set newname ""

catch {exec scp -p sftp.jetpay.com:/secure/b2payments/reports/01*.txt $dnload_dir} scpresult
if {$scpresult != ""} {
   puts $scpresult
   set mbody "File download from B2B sftp failed.\n\n $scpresult"
   exec echo "$mbody_h $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_h" $mailtolist
   exit 1 }
  
   catch {set filelist [exec find $dnload_dir -mtime 0 -name 01*.txt]} result
   if {$filelist == ""} {
       exec echo "No B2B Confirmation Files Found" | mailx -r $mailfromlist -s "No B2B Confirmation Files Found" $mailtolist
       exit 1
       } else {
        foreach file $filelist { 
          set filedate [clock format [clock seconds] -format "%Y%m%d%H%M"]
          set fname [file tail $file]
          set newname [file rootname $fname]
          append newname "_$filedate.txt"
          set fname $newname
          exec cp $file $dnload_dir/$newname
          exec sleep 2
          exec rm $file
		  mutt_send_mail $mailtolist "B2B Confirmation File $newname Attached"  "Please see attached." "$dnload_dir/$newname"
          exec sleep 2 
          exec mv $dnload_dir/$newname $reports_dir/$newname
        }
     }

set logdate [clock seconds]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]
puts "END LOG of B2B Confirmation Files - $logdate"
puts " "
