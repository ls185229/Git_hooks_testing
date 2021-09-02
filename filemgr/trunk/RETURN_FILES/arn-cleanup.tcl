#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

#Execution: chargeback_fix.tcl

################################################################################
#
#    File Name -chargeback_fix.tcl
#
#    Description - Fixes Chargebacks that have incorrect Merch_ids
#
#    Arguments - 
#
################################################################################
# $Id: $
# $Rev: $
# $Author: $
################################################################################

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

package require Oratcl


################################################################################
#
#    Procedure Name - readCfgFile
#
#    Description - Get the DB variables
#
#    Arguments - 
#
#    Return -
#
###############################################################################
proc readCfgFile {} {
   global clr_db_logon
   global auth_db_logon
   global clr_db
   global auth_db

   
   set cfg_file_name chargeback_fix.cfg

   set clr_db_logon ""
   set clr_db ""
   set auth_db_logon ""
   set auth_db ""

   if {[catch {open $cfg_file_name r} file_ptr]} {
      puts "File Open Err:Cannot open config file $cfg_file_name"
      exit 1
   }

   while { [set line [gets $file_ptr]] != {}} {
      set line_parms [split $line ,]
      switch -exact -- [lindex  $line_parms 0] {
         "CLR_DB_LOGON" {
            set clr_db_logon [lindex $line_parms 1]
         }
         "CLR_DB" {
            set clr_db [lindex $line_parms 1]
         }
         "AUTH_DB_LOGON" {
            set auth_db_logon [lindex $line_parms 1]
         }
         "AUTH_DB" {
            set auth_db [lindex $line_parms 1]
         }
         default {
            puts "Unknown config parameter [lindex $line_parms 0]"
         }
      }
   }

   close $file_ptr

   if {$clr_db_logon == ""} {
      puts "Unable to find CLR_DB_LOGON params in $cfg_file_name, exiting..."
      exit 2
   }

}

#################################
# connect_to_db
#  handles connections to the database
#################################

proc connect_to_db {} {
    global auth_logon_handle mas_logon_handle
   global clr_db_logon
   global auth_db_logon
   global clr_db
   global auth_db


                if {[catch {set auth_logon_handle [oralogon $auth_db_logon@$auth_db]} result] } {
                        puts "Encountered error $result while trying to connect to DB"
                                exit 1
                } else {
                        puts "COnnected"
                }
                if {[catch {set mas_logon_handle [oralogon $clr_db_logon@$clr_db]} result] } {
                        puts "Encountered error $result while trying to connect to DB"
                                exit 1
                } else {
                        puts "COnnected"
                }

};# end connect_to_db
if { [lindex $argv 0] == "" } {
  set today_date [clock format [clock seconds] -format "%d-%b-%Y"]
} else {
  set today_date [lindex $argv 0]
  set today_date [clock format [clock scan $today_date -format "%Y%m%d"] -format "%d-%b-%Y"]
}
  set Query_sql "select *
                from tranhistory
                where card_type = 'AX' and status in ('101','107') and arn not like '51%'"

readCfgFile
connect_to_db
set mas_sql [oraopen $mas_logon_handle]
set mas_sql1 [oraopen $mas_logon_handle]

set auth_sql [oraopen $auth_logon_handle]
set auth_sql1 [oraopen $auth_logon_handle]

orasql $auth_sql $Query_sql
#set body ""
while {[orafetch $auth_sql -dataarray auth_query -indexbyname] != 1403 } {
  set auth_query(AMOUNT) [expr {round ($auth_query(AMOUNT) * 100)}]
  set Query_sql "select *
		from masclr.in_draft_main where arn = '$auth_query(ARN)'"
  orasql $mas_sql $Query_sql
  if {[orafetch $mas_sql -dataarray merch_id_query -indexbyname] != 1403 } {
  } else {
    set Query_sql "select * from masclr.in_draft_main 
	where pan = '$auth_query(CARDNUM)' and
          amt_trans = '$auth_query(AMOUNT)' and
          auth_cd = '$auth_query(AUTH_CODE)' and
          trans_clr_status is null"
    orasql $mas_sql1 $Query_sql
    if {[orafetch $mas_sql1 -dataarray merch_query -indexbyname] != 1403 } {
      set Query_sql "update tranhistory set arn = '$merch_query(ARN)' where arn = '$auth_query(ARN)'"
      puts $Query_sql
      orasql $auth_sql1 $Query_sql
    } else {
      puts $Query_sql
      puts "missed one $auth_query(ARN)"
    }
  }
}
oracommit $mas_logon_handle

exit 0 
