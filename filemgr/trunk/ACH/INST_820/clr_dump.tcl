#!/usr/bin/env tclsh
# ~/.profile

################################################################################
# $Id: clr_dump.tcl 4242 2017-07-25 14:08:04Z lmendis $
# $Rev: 4242 $
################################################################################
#
# File Name:  clr_dump.tcl
#
# Description:  This program displays the contents of a specified ACH file.
#               It invokes net_zero_file.tcl, as well.
#
# Script Arguments:  file_name = Name of file to display.
#                    seq       (optional sequence number for muliple files)
#
# Output:  None.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

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
set locPath $env(PWD)

#################################################################################

proc chkresult {result} {
if {$result != ""} {
puts "exiting here $result"
#exit 1
}

}



set file_name [lindex $argv 0]
puts $file_name
set orig_line $file_name
set varlist [split $orig_line .]
puts $varlist

set inst_id [lindex $varlist 0]
set file_cat [lindex $varlist 1]
set file_type [lindex $varlist 2]
set fbank [lindex $varlist 3]
set fjdate [lindex $varlist 4]
set fseq [lindex $varlist 5]

set cd_path "cd out_ach"
set curdate [clock seconds]
set curdate [clock format $curdate -format "%d%m%y"]
set cdate [clock seconds]
set cdate [clock format $cdate -format "%Y%m%d%H%M%S"]
puts $curdate
exec cd $env(PWD)
#print "Beginning file transfer from MAS System $file_name"


set fname "$inst_id-ACH_2_$fbank-$file_type-$cdate.ach"
puts $fname

catch {exec $env(PWD)/net_zero_file.tcl $file_name $fname} result
puts $result
chkresult $result

set achfax "$inst_id.achfax.$file_type.txt"

if {[file exists $achfax]} {
catch {exec rm $env(PWD)/$achfax} result
}

chkresult $result
puts $achfax
catch {exec $env(PWD)/fax_form.tcl $fname $inst_id $file_type >> $achfax} result
puts $result
chkresult $result

set achdump "$inst_id.dump.$file_type.txt"

if {[file exists $achdump]} {
file delete $achdump
}

catch {exec $env(PWD)/dump_ach.tcl $fname >> $achdump} result

chkresult $result

exec cat $achfax $achdump | mailx -r Clearing.JetPayTX@ncr.com -s "$inst_id $fbank Clearing Fax $curdate" Clearing.JetPayTX@ncr.com

exec mv $file_name ARCHIVE
file delete $achdump
