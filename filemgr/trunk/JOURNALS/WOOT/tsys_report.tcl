#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

#Execution: woot_chargeback_report.tcl

################################################################################
#
#    File Name -woot_chargeback_report.tcl
#
#    Description -This s a custom report for woot to help them match chargebacks to their transactions.
#
#    Arguments - $1 Date to run the report.  If no argument, then defaults to today's date.  EX. 20130204
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
   global Shortname_list

   
   set cfg_file_name WOOT.cfg

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

puts "woot_chargeback_report.tcl.tcl Started"
  set Query_sql "select substr(shipdatetime,0,6) as settle_date,m.mid,long_name,sum(amount) as amount,count(1) as count from transaction t, merchant m where t.mid = m.mid and authorization_authority like 'TSYS%' and request_type <> '0100' and mmid in (select mmid from master_merchant where shortname like 'JETPAY%') group by substr(shipdatetime,0,6),m.mid,long_name order by substr(shipdatetime,0,6),m.mid,long_name"
puts $Query_sql
set fileName "tsys.csv"

readCfgFile
connect_to_db
set auth_sql [oraopen $auth_logon_handle]
set mas_sql [oraopen $mas_logon_handle]

set header "Date,Mid,Name,Amount,Count"
orasql $auth_sql $Query_sql
set body " "
while {[orafetch $auth_sql -dataarray mas_query -indexbyname] != 1403 } {
  append body "$mas_query(SETTLE_DATE),$mas_query(MID),$mas_query(LONG_NAME),$mas_query(AMOUNT),$mas_query(COUNT)\r\n"
  puts "$mas_query(SETTLE_DATE),$mas_query(MID),$mas_query(LONG_NAME),$mas_query(AMOUNT),$mas_query(COUNT)\r\n"
}

exec echo $header >> $fileName
exec echo $body >> $fileName

exec mutt -a /clearing/filemgr/JOURNALS/WOOT/$fileName -s "TSYS Report for $today_date" -- clearing-reports@jetpay.com < $fileName
exec mv $fileName ARCHIVE

exit 0 
