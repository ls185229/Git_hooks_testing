#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: chk_txn.tcl 3420 2015-09-11 20:05:17Z bjones $

package require Oratcl

#######################################################################################################################

#Environment veriables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)

set clrdb $env(CLR4_DB)
set authuser $env(ATH_DB_USERNAME)
set authpwd $env(ATH_DB_PASSWORD)
set authdb $env(TSP4_DB)

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

proc connect_to_db {} {
    global db_logon_handle db_connect_handle
    global authdb authuser authpwd
    if {[catch {set db_logon_handle [oralogon $authuser/$authpwd@$authdb]} result] } {
        puts "Encountered error $result while trying to connect to DB"
	exec echo "$result DB connection failed on script TC57/move_txn.tcl" | mailx -r clearing@jetpay.com -s "URGENT!!! CALL SOMEONE- Check transaction failed" clearing@jetpay.com assist@jetpay.com
        exit 1
    } else {
        puts "COnnected"
    }
};# end connect_to_db

connect_to_db

set curdate [clock seconds]
set curdate [clock format $curdate -format "%Y%m%d%H%M%S"]
puts "-----------NEW LOG------------------- $curdate ---------"

set tblnm_cap "CAPTURE"
set tblnm_set "SETTLEMENT"
set tblnm_mer "MERCHANT"
set tblnm_mm "MASTER_MERCHANT"
set linsert [oraopen $db_logon_handle]
set lupdate [oraopen $db_logon_handle]
set ldelete [oraopen $db_logon_handle]

set sname [lindex $argv 0]
set sname1 "MAX_BANK"
set sname2 "MAX_BNK_PS"
set sname3 "JDB_PROD"
set sname4 "JETPAYIS"


set chk "SELECT count(amount) CNT
           FROM $tblnm_set
	   WHERE mid in (SELECT mid
	                  FROM $tblnm_mer
			  WHERE mmid in (SELECT mmid
			                   FROM $tblnm_mm
					  WHERE shortname = '$sname'))
					    AND card_type in('VS','MC')
              AND other_data4 not in (select other_data4 from fraud_history)"

puts $chk
orasql $lupdate $chk
orafetch $lupdate -dataarray x -indexbyname
puts $x(CNT)

if {$x(CNT) == 0} {
exec echo "No transaction in settlement for $sname" | mailx -r clearing@jetpay.com -s "Transaction move is OK for $sname at $curdate" clearing@jetpay.com
} else {
exec echo "Partial or full transaction move to tranhistory from settlement table failed. There is still transaction in settlement table.\n Count = $x(CNT) for $sname" | mailx -r clearing@jetpay.com -s "URGENT!!! CALL SOMEONE: Transaction move failed" clearing@jetpay.com assist@jetpay.com
#assist@jetpay.com
#exec echo "Transaction move failed" >> /clearing/filemgr/process.stop
exec echo "$curdate, $x(CNT), $sname" >> chk_daily_txn_cnt.txt
}

oracommit $db_logon_handle
oraclose $lupdate
oralogoff $db_logon_handle
