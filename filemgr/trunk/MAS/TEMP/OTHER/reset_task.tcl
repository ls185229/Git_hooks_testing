#!/usr/bin/env tclsh
#/clearing/filemgr/.profile
package require Oratcl


set logdate [clock seconds]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]


proc connect_to_db {} {
    global db_logon_handle db_connect_handle
    if {[catch {set db_logon_handle [oralogon masclr/masclr@masclr]} result] } {
        puts "Encountered error $result while trying to connect to DB"
        exit 1
    }
};# end connect_to_db


connect_to_db

set tblnm_ifl "IN_FILE_LOG"

set get [oraopen $db_logon_handle]
set l_update [oraopen $db_logon_handle]

set sql2 "update tasks set run_hour = '', run_min = '' where institution_id = '447474'"
orasql $l_update $sql2
puts "Tasks set to run_hour = '', run_min = ''" 
oracommit $db_logon_handle

puts "----- END OF RESET TASKS -------------- $logdate ----------------------"

oralogoff $db_logon_handle
