#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: return_file_status_chk.tcl 3420 2015-09-11 20:05:17Z bjones $

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

set stat "C"

set sql1 "select * from in_file_log where incoming_dt like '$e_date%' and file_type in ('41','55')"
puts $sql1
orasql $get $sql1

set sms "[format %-50s "EXTERNAL_FILE_NAME"] [format %-5s "IN_FILE_STATUS"]\n"
append sms "__________________________________________________ ______________\n"

while {[set x [orafetch $get -dataarray msgs -indexbyname]] == 0} {

puts ">$msgs(IN_FILE_STATUS)<"

append sms "[format %-50s $msgs(EXTERNAL_FILE_NAME)] [format %-5s $msgs(IN_FILE_STATUS)]\n"

if {[string range $msgs(IN_FILE_STATUS) 0 0] != "C"} {
set stat "P"
}


}

if {$stat == "P"} {

set mbody "Incoming Visa and Mastercard Return File Import Status is not C"

exec echo "$mbody_c $sysinfo $mbody\n\n$sms" | mailx -r $mailfromlist -s "$msubj_c" clearing@jetpay.com

} else {

set mbody "Incoming Visa and Mastercard Return File Import Status is C"

exec echo "$mbody_l $sysinfo $mbody\n\n$sms" | mailx -r $mailfromlist -s "$msubj_l" clearing@jetpay.com

}
