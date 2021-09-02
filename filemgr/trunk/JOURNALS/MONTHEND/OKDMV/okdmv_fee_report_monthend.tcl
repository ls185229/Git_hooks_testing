#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: okdmv_fee_report_monthend.tcl 2533 2014-01-29 18:41:55Z msanders $
# $Rev: 2533 $
################################################################################
#
#    File Name   - okdmv_fee_report_monthend.tcl
#
#    Description - This is a custom report for accounting for OKDMV fees.
#
################################################################################


#Environment veriables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(IST_DB)

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
set locpath "/clearing/filemgr/JOURNALS/MONTHEND/OKDMV"
set mailtolist "Reports-clearing@jetpay.com,accounting@jetpay.com"

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
  global clr_db
  global Shortname_list
   
  set cfg_file_name okdmv.cfg

  set clr_db_logon ""
  set clr_db ""

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
       "SHORTNAME_LIST" {
          set Shortname_list [lindex $line_parms 1]
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

#######################################
# connect_to_db
# handles connections to the database
#######################################

proc connect_to_db {} {
  global mas_logon_handle
  global clr_db_logon
  global clr_db


  if {[catch {set mas_logon_handle [oralogon $clr_db_logon@$clr_db]} result] } {
     puts "Encountered error $result while trying to connect to clr DB"
     exit 1
  } else {
     puts "Connected to clr DB"
  }

};# end connect_to_db


######################
# MAIN
######################

puts "okdmv_fee_report_monthend.tcl Started"

if { $argc == 0 } {
  set base [clock format [clock seconds] -format "%Y%m%d"]
} else {
  set base [clock format [clock scan [lindex $argv 0] -format "%Y%m%d"] -format "%Y%m%d"]
}

puts "Report date: $base"
set end_date [clock format [clock scan $base -format "%Y%m%d"] -format "%d-%b-%Y"]
set begin_date [clock format [clock add [clock scan $base -format "%Y%m%d"] -4 day] -format "%d-%b-%Y"]
#set begin_date [clock add [clock scan $base -format "%Y%m%d"] -4 day]

puts "Begin Date: $begin_date"
puts "End Date: $end_date"

set Query_sql "SELECT gl_date, 
  entity_id, 
  POSTING_ENTITY_ID ,     
  tid_settl_method as DbCr, 
  COUNT(*) as count, 
  SUM(amt_billing) as amt_billing     
  FROM masclr.mas_trans_log     
WHERE posting_entity_id = '454045411000080'     
  and tid LIKE '010004%'     
  and tid_settl_method = 'D'     
  and file_id in (select file_id 
from masclr.mas_file_log 
where institution_id = '107' and     
  trunc(receive_date_time) > '$begin_date' and     
  trunc(receive_date_time) <= '$end_date' and     
  file_name not like '107.CLEARING%' and     
  file_name not like '107.DEBITRAN%' and     
  file_name not like '107.CHARGEBK%' and     
  file_name not like '107.AMEXTRAN%' and     
  file_name not like '107.ARBCREDT%' and
  file_name not like '107.CONVCHRG%')    
GROUP BY gl_date,
  entity_id, 
  POSTING_ENTITY_ID, 
  tid_settl_method     
ORDER BY gl_date, 
  entity_id"

set fileName "okdmv-monthend-$end_date.xls"

readCfgFile
connect_to_db
set mas_sql [oraopen $mas_logon_handle]

set body "GL_DATE\tENTITY_ID\tPOSTING_ENTITY_ID\tDBCR\tCOUNT\tAMT_BILLING\r\n"
orasql $mas_sql $Query_sql

while {[orafetch $mas_sql -dataarray mas_query -indexbyname] != 1403 } {
  append body "$mas_query(GL_DATE)\t$mas_query(ENTITY_ID)\t$mas_query(POSTING_ENTITY_ID)\t$mas_query(DBCR)\t$mas_query(COUNT)"
  append body "\t$mas_query(AMT_BILLING)\r\n"
}

exec echo $body > $fileName

exec echo "Please see attached." | mutt -a $fileName -s "OKDMV Monthend Fee Report for $end_date" -- $mailtolist 

exec mv $fileName ../ARCHIVE

exit 0 
