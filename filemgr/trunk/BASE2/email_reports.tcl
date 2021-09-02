#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: email_reports.tcl 3723 2016-04-05 22:26:28Z millig $
# $Rev: 3723 $
################################################################################
#
# File Name:  email_reports.tcl
#
# Description:  This program emails the daily incoming Visa reports by
#               institution.
#              
# Script Arguments:  inst_id = Institution ID.  Required.
#                    zipflder = Folder containing the incoming reports file
#                               from Visa.  Required.
#					 network = Name of the PIN debit network referenced in
#                              the reports.  Required.
#					 logdate = Report date.  Required.
#
# Output:  Reports distributed by email.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

package require Oratcl
package provide random 1.0

set inst_id [string trim [lindex $argv 1]]
set customer "TEST-clearing@jetpay.com"
set inst_dir "INST_$inst_id"
set locpth "/clearing/filemgr/BASE2/$inst_dir"


#Environment veriables.......

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
set bankname ""

switch $inst_id {
	"101"	{set bankname "101"}
	"105"	{set bankname "105"}
	"107"	{set bankname "107"}
	"111"   {set bankname "111"}
	"117"	{set bankname "117"}
	"121"	{set bankname "121"}
	   default {puts "NO MATCHING BANK FOUND"; exit 1}
}
	
set logdate [clock seconds]
set cdate [clock format $logdate -format "%Y-%m-%d"]
set curdate [clock format $logdate -format "%Y%m%d"]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]

puts "                                                            "
set x ""
set zipflder [lindex $argv 0] 
set network [lindex $argv 2]
set logdate [lindex $argv 3]

set cdate [clock format [clock scan $logdate] -format "%Y-%m-%d"]

exec mutt -a $zipflder -s "$bankname VSDaily Reports $network for $cdate" reports-clearing@jetpay.com < body.txt

puts "------EMIAL SENT for $inst_id: $zipflder ------- $logdate"
