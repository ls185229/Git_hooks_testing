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
      set line_parms [split $line ~]
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
set Query_sql "select * from 
		masclr.in_draft_main 
		where in_file_nbr in 
			(select in_file_nbr from masclr.in_file_log where external_file_name like 'IN%' and end_dt >= '$today_date')
			 and tid not in ('010101002102','010103010101','010133005101','010103020102','010103050102')"

readCfgFile
connect_to_db
set mas_sql [oraopen $mas_logon_handle]
set mas_sql1 [oraopen $mas_logon_handle]

orasql $mas_sql $Query_sql
#set body ""
while {[orafetch $mas_sql -dataarray mas_query -indexbyname] != 1403 } {
  set Query_sql "select 
			merch_id,
			merch_name,
			amt_trans,
			trans_dt 
		from in_draft_main 
		where arn = '$mas_query(ARN)'
			 and trans_seq_nbr < '$mas_query(TRANS_SEQ_NBR)'
		order by trans_seq_nbr"
  orasql $mas_sql1 $Query_sql
  orafetch $mas_sql1 -dataarray merch_id_query -indexbyname
 
  if {($mas_query(MERCH_ID) != $merch_id_query(MERCH_ID)) || ($mas_query(TRANS_DT) != $merch_id_query(TRANS_DT)) || ($mas_query(AMT_TRANS) != $merch_id_query(AMT_TRANS)) || ($mas_query(MERCH_NAME) != $merch_id_query(MERCH_NAME))} { 

    set Query_sql "update in_draft_main 
		set merch_id = '$merch_id_query(MERCH_ID)',
		trans_dt = '$merch_id_query(TRANS_DT)',
		amt_trans = '$merch_id_query(AMT_TRANS)',
		merch_name = '$merch_id_query(MERCH_NAME)' 
	where arn = '$mas_query(ARN)' and 
	trans_seq_nbr = '$mas_query(TRANS_SEQ_NBR)'"
    puts $Query_sql
    if {[catch {orasql $mas_sql1 $Query_sql}] } {
      puts "failed to Update $mas_query(ARN) to $merch_id_query(MERCH_ID)"
      puts $result
      oraroll $auth_logon_handle
      exit 1
    }
  }
}
oracommit $mas_logon_handle

exit 0 
