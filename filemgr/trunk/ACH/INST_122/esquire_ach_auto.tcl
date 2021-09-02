#!/usr/bin/env tclsh

################################################################################
# $Id: esquire_ach_auto.tcl 4569 2018-05-17 15:28:32Z bjones $
# $Rev: 4569 $
################################################################################
#
# File Name:  esquire_ach_auto.tcl
#
# Description:  This program moves the ACH file from the MAS system to the
#               Esquire Bank ACH upload folder.
#
# Script Arguments:  inst_id = Institution ID.  Required.
#
# Output:  None.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

set inst_id [string trim [lindex $argv 0]]
set inst_dir "INST_$inst_id"
set subroot "ACH"
set locpth /clearing/filemgr/$subroot/$inst_dir


#Environment variables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(IST_DB)
set authdb $env(ATH_DB)

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

#System information variables....

set sysinfo "System: $box\n Location: $env(PWD) \n\n"

#######################################################################################################################


set cd_path "cd out_ach"
set curdate [clock seconds]
set fdate [clock format $curdate -format "%Y%m%d"]
set curdate [clock format $curdate -format "%d%m%y"]
set cdate [clock seconds]
set cdate [clock format $cdate -format "%Y%m%d%H%M%S"]
set bank_ach_email "Clearing.JetPayTX@ncr.com"

#Checking if a process stop file exist. If process stop file exists stoping process and notifying process issue exists. If the the stop file do not exist
#create the stop file while running this script, so that other process do not start if this scripts completes successfully and removes the stop file at
#the end of the scripts.

if {[file exists /clearing/filemgr/process.stop]} {
	set mbody "PREVIOUS PROCESS NOT COMPLETED ALL OTHER PROCESSES STOPED : esquire_ach_auto.tcl"
	exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
	exit 1
} else {
	catch {open /clearing/filemgr/process.stop {WRONLY CREAT}} fileid
}

#grabbing ACH file for upload

catch {set x [exec find . -name $inst_id-ACH_2_ESQUIRE-$fdate* -mtime 0 ]} result
puts $result

if {$result != ""} {
  puts $result
}

if {$x == ""} {
	set mbody "ACH file not found in MAS ACH folder"
	exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
}
set i 0

set fname [string range [lindex $x $i] 2 end]
puts $fname

if {[llength $x] >=  2} {
	set mbody "Multiple ACH file found in MAS ACH folder\n\n $x"
	exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
	exit 1
}

puts $curdate

set dummy 0

#passing file to upload script

set dummy [catch {exec $locpth/upload.exp $fname ACH >> $locpth/LOG/upload.log} result]

#If upload successfull emailing fax form to bank else stoping process.

if {$dummy == 0} {
	exec cat out.txt | mailx -r $mailfromlist -s "$box: ACH File Transmittal 900005004" $mailtolist $bank_ach_email

	file delete /clearing/filemgr/process.stop
	exec mv $fname ARCHIVE/sent-$fname

} else {
	set mbody "Assist Please contact clearing group or On call Engr. immediately. Clearing ACH failed to upload to bank ftp site.\nFor more detail Please look in to the log file at $env(PWD)/LOG/upload.log"
	exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
}
