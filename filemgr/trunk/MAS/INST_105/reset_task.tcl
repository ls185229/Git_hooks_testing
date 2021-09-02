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



set logdate [clock seconds]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]
set inst_id [lindex $argv 0]
set tsk_nbr [lindex $argv 1]

proc connect_to_db {} {
    global db_logon_handle db_connect_handle msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l box clrpath maspath mailtolist mailfromlist clrdb authdb

    if {[catch {set db_logon_handle [oralogon masclr/masclr@$clrdb]} result] } {
        puts "Encountered error $result while trying to connect to DB"
        set mbody "ALL PROCESSES STOPED SINCE reset_task.tcl could not logon to DB : Msg sent from reset_task.tcl\n $result"
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        exit 1
    }
};# end connect_to_db


connect_to_db


set get [oraopen $db_logon_handle]
set l_update [oraopen $db_logon_handle]

if {[lindex $argv 0] == "ALL"} {

	set sql0 "update tasks set run_hour = '', run_min = ''"
	orasql $l_update $sql0
	puts "Tasks Reset to run_hour = '', run_min = '' for all INSTITUTIONS" 
	oracommit $db_logon_handle

}

if {$argc == 1} {

        set sql1 "update tasks set run_hour = '', run_min = '' where institution_id = '$inst_id'"
        orasql $l_update $sql1
        puts "Tasks Reset to run_hour = '', run_min = '' for INSTITUTION : $inst_id"
        oracommit $db_logon_handle

}

if {$argc >= 2} {

set i 0

   foreach tsk_id $argv {
	set inst_id [lindex $argv 0]
    if {$i != 0} {
        set sql2 "update tasks set run_hour = '', run_min = '' where institution_id = '$inst_id' and task_nbr = '$tsk_id'"
        orasql $l_update $sql2
        puts "Tasks Reset to run_hour = '', run_min = '' for INSTITUTION : $inst_id and TASK NUMBER : $tsk_id"
        oracommit $db_logon_handle
    }
	set i [expr $i + 1]
   }

}


puts "----- END OF RESET TASKS -------------- $logdate ----------------------"

oralogoff $db_logon_handle
