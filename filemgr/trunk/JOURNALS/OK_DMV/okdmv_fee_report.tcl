#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

#Execution: okdmv_fee_report.tcl

################################################################################
# $Id: $
################################################################################
#
#    File Name  okdmv_fee_report.tcl
#
#    Description  This s a fee report for Jetpay to balance OKDMV
#
#    Arguments  $1 Date to run the report.
#               If no argument, then defaults to today's date.  EX. 20130204
#
################################################################################

################################################################################

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
   global Shortname_list


   set cfg_file_name OK_DMV.cfg

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

puts "okdmv_fee_report.tcl Started"
if { [lindex $argv 0] == "" } {
  set today_date [clock format [clock seconds] -format "%d-%b-%Y"]
  set Query_sql "SELECT gl_date, entity_id, POSTING_ENTITY_ID ,
    tid_settl_method as DbCr, COUNT(*) as count, SUM(amt_billing) as amt_billing
FROM mas_trans_log
WHERE posting_entity_id = '454045411000080'
    AND gl_date            >= '$today_date'
    AND tid LIKE '010004%'
    and tid_settl_method = 'D'
GROUP BY gl_date, entity_id, POSTING_ENTITY_ID , tid_settl_method
ORDER BY gl_date, entity_id"

} else {
  set today_date [clock format [clock scan [lindex $argv 0] -format "%Y%m%d"] -format "%d-%b-%Y"]
  set tomorrow_date [clock format [clock scan [expr [lindex $argv 0] + 1] -format "%Y%m%d"] -format "%d-%b-%Y"]
  set Query_sql "SELECT gl_date, entity_id, POSTING_ENTITY_ID ,
    tid_settl_method as DbCr, COUNT(*) as count, SUM(amt_billing) as amt_billing
FROM mas_trans_log
WHERE posting_entity_id = '454045411000080'
    AND gl_date            >= '$today_date'
    and gl_date        < '$tomorrow_date'
    AND tid LIKE '010004%'
    and tid_settl_method = 'D'
GROUP BY gl_date, entity_id, POSTING_ENTITY_ID , tid_settl_method
ORDER BY gl_date, entity_id"

}
#puts $Query_sql
set today_date [string range $today_date 0 7]
set fileName "OKDMV-Fee-$today_date.csv"

readCfgFile
connect_to_db
set auth_sql [oraopen $auth_logon_handle]
set mas_sql [oraopen $mas_logon_handle]

set header "GL_DATE,Entity ID,Posting Entity ID,DbCr,Count,Billing Amount"
set body ""
puts $Query_sql
orasql $mas_sql $Query_sql
while {[orafetch $mas_sql -dataarray mas_query -indexbyname] != 1403 } {
  set info "$mas_query(GL_DATE),$mas_query(ENTITY_ID),$mas_query(POSTING_ENTITY_ID),$mas_query(DBCR),$mas_query(COUNT),$mas_query(AMT_BILLING)\r\n"
  append body $info
}

exec echo $header >> $fileName
exec echo $body >> $fileName

exec mutt -a /clearing/filemgr/JOURNALS/OK_DMV/$fileName -s "OKDMV fee Report for $today_date" -- accounting@jetpay.com reports-clearing@jetpay.com  < $fileName
exec mv $fileName ARCHIVE

exit 0
