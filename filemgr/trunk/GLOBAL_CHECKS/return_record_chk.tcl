#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: return_record_chk.tcl 3420 2015-09-11 20:05:17Z bjones $

package require Oratcl


#######################################################################################################################

#Environment veriables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)

set clrdb $env(CLR4_DB)
set clruser $env(IST_DB_USERNAME)
set clrpwd $env(IST_DB_PASSWORD)
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



set logdate [clock seconds]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]
set inst_id [lindex $argv 0]
set tsk_nbr [lindex $argv 1]

proc connect_to_db {} {
    global db_logon_handle db_connect_handle msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l box clrpath maspath mailtolist mailfromlist clrdb authdb
    global clruser clrpwd 

    if {[catch {set db_logon_handle [oralogon $clruser/$clrpwd@$clrdb]} result] } {
        puts "Encountered error $result while trying to connect to DB"
        set mbody "ALL PROCESSES STOPED SINCE reset_task.tcl could not logon to DB : Msg sent from reset_task.tcl\n $result"
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        exit 1
    } else {
        puts "COnnected"
    }
};# end connect_to_db


connect_to_db

set logdate [clock seconds]
set e_date [string toupper [clock format $logdate -format "%d-%b-%y"]]
set curdate [clock format $logdate -format "%Y%m%d"]


set get [oraopen $db_logon_handle]
set l_update [oraopen $db_logon_handle]

set sql1 "select src_inst_id, pri_dest_inst_id, count(1) as TXN_COUNT, (sum(amt_original) / 100) as amt_original, (sum(amt_trans) / 100) as amt_trans, tid, card_scheme,
(select tid_settl_method from tid where tid = i.tid) as tid_settl_method,
(select description from tid where tid = i.tid) as description
from in_draft_main i where tid not like ('0101030051%') and tid not in ('010101002102')
and activity_dt like sysdate
group by src_inst_id, pri_dest_inst_id, tid, card_scheme order by pri_dest_inst_id, src_inst_id,tid, card_scheme"
puts $sql1
orasql $get $sql1

set sms "[format %-12s "SRC_INST_ID"] [format %-12s "PRI_DEST_ID"] [format %-10s "TXN_COUNT"] [format %-13s "AMT_ORIGINAL"] [format %-12s "AMT_TRANS"] [format %-14s "TID"] [format %-14s "CARD_SCHEME"] [format %-13s "SETTLE_TYPE"] DESCRIPTION\n"

while {[set x [orafetch $get -datavariable msgs]] == 0} {


append sms "[format %-12s [lindex $msgs 0]] [format %-12s [lindex $msgs 1]] [format %-10s [lindex $msgs 2]] [format %-13s [lindex $msgs 3]] [format %-12s [lindex $msgs 4]] [format %-14s [lindex $msgs 5]] [format %-14s [lindex $msgs 6]] [format %-13s [lindex $msgs 7]] [lindex $msgs 8]\n"


}

#exec echo $sms > emsdlysum.txt

set mbody "Incoming Visa and Mastercard messages"

exec echo "$mbody_h $sysinfo $mbody\n\n$sms" | mailx -r $mailfromlist -s "$msubj_h SUMMARY EMS ALERT" clearing@jetpay.com
