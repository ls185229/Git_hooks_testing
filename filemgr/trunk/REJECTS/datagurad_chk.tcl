#!/usr/bin/env tclsh
#/clearing/filemgr/.profile


package require Oratcl


#######################################################################################################################

#Environment veriables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(IST_DB)
set authdb $env(TSP4_DB)
set clr4db $env(CLR4_DB)
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

exec echo "export ORACLE_SID $env(CLR4_DB)"
exec echo "export TWO_TASK $env(CLR4_DB)"

set logdate [clock seconds]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]
set inst_id [lindex $argv 0]
set tsk_nbr [lindex $argv 1]

proc connect_to_db {} {
    global db_logon_handle db_connect_handle msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l box clrpath maspath mailtolist mailfromlist clrdb authdb handle clr4db

    if {[catch {set db_logon_handle [oralogon masclr/masclr@$clrdb]} result] } {
        puts "Encountered error $result while trying to connect to DB"
        set mbody "ALL PROCESSES STOPED SINCE reset_task.tcl could not logon to DB : Msg sent from reset_task.tcl\n $result"
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        exit 1
    }

if {[catch {set handle [oralogon masclr/masclr@$clr4db]} result] } {
        puts "Encountered error $result while trying to connect to DB"
        set mbody "ALL PROCESSES STOPED SINCE reset_task.tcl could not logon to DB : Msg sent from reset_task.tcl\n $result"
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        exit 1
    } else {
    puts $result
    }
};# end connect_to_db




connect_to_db

set logdate [clock seconds]
set e_date [string toupper [clock format $logdate -format "%d-%b-%y"]]
set curdate [clock format $logdate -format "%Y%m%d"]


set get [oraopen $db_logon_handle]
set get1 [oraopen $handle]
set l_update [oraopen $db_logon_handle]

set sql1 "select count(1) as CNT from mas_trans_log"
puts $sql1
orasql $get $sql1

orafetch $get -dataarray cnttrnclr1 -indexbyname

set sql2 "select count(1) as CNT from mas_trans_log"
puts $sql2
orasql $get1 $sql2

orafetch $get1 -dataarray cnttrnclr4 -indexbyname

if {$cnttrnclr1(CNT) != $cnttrnclr4(CNT)} {
set mbody "Dataguard issue. $cnttrnclr1(CNT) != $cnttrnclr4(CNT) checked at $logdate"
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" clearing@jetpay.com
    puts "counts $cnttrnclr1(CNT) != $cnttrnclr4(CNT)"
} else {
puts "counts $cnttrnclr1(CNT) == $cnttrnclr4(CNT)"
}

oralogoff $db_logon_handle
oralogoff $handle
