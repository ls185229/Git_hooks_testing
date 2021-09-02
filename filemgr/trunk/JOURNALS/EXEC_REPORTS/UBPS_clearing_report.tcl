#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

#Execution: okdmv_funding_report.tcl

################################################################################
#
#    File Name -okdmv_funding_report.tcl
#
#    Description -This s a funding report for Jetpay to balance OKDMV  
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

puts "okdmv_funding_report.tcl Started"
if { [lindex $argv 0] == "" } {
  set today_date [clock format [clock seconds] -format "%Y%m%d"]
  set today_date "[clock format [clock scan [expr $today_date -1]] -format "%Y%m%d"]060000"
  set debit_sql "select 
	  count(1) as count,
	  sum(amt_original) as amount
	from masclr.mas_trans_log
	where 
	  institution_id in ('101','105','107') and 
	  mas_code like '0102%' and 
	  card_scheme = '02' and 
	  trans_sub_seq = '0' and 
	  activity_date_time >= '01-JAN-12' and activity_date_time < '01-JAN-13'"
  set Query_sql "select 
	t.tid,
	description,
	count(1) as count,
        sum(amt_trans)/100 as amount
	 from masclr.in_draft_main idm,masclr.tid t 
	where 
	  t.tid = idm.tid
	  and activity_dt > '01-JAN-13'
 	  and activity_dt < '01-FEB-13'
	  and t.tid in ('010103005101','010103005102','010103015101') 
	group by t.tid,description order by t.tid"

} else {
  set today_date "[clock scan [lindex $argv 0] -format "%Y%m%d"]060000"
  set tomorrow_date "[clock scan [expr [lindex $argv 0] + 1] -format "%Y%m%d"]060000"
}
#puts $Query_sql
set today_date [string range $today_date 0 7]
set fileName "OKDMV-Funding-$today_date.csv"

readCfgFile
connect_to_db
set auth_sql [oraopen $auth_logon_handle]
set mas_sql [oraopen $mas_logon_handle]

orasql $mas_sql $debit_sql
orafetch $mas_sql -dataarray debit_query -indexbyname

set header "Transaction_type,Count Amount"
orasql $mas_sql $Query_sql
while {[orafetch $mas_sql -dataarray mas_query -indexbyname] != 1403 } {
  if {$mas_query(TID) == "010103005101"} {
    set info "$mas_query(DESCRIPTION),[expr $mas_query(COUNT) + $debit_query(COUNT)],[expr $mas_query(AMOUNT) + $debit_query(AMOUNT)]\r\n"
  } else {
    set info "$mas_query(DESCRIPTION),$mas_query(COUNT),$mas_query(AMOUNT)\r\n"
  }
  append body $info
}

set Query_sql "select count(1) as count from 
	(select 
		merch_id 
	from in_draft_main 
	where 
	  merch_id in (select entity_id from entity_to_auth where institution_id in ('101','105','107'))
          and activity_dt > '01-JAN-12'
          and activity_dt < '01-JAN-13'
          and tid in ('010103005101','010103005102','010103015101'))"
orasql $mas_sql $Query_sql
set info "Active merchants $mas_query(COUNT)"
append body " "
append body $info
append body " "

if { [lindex $argv 0] == "" } {
  set today_date [clock format [clock seconds] -format "%Y%m%d"]
  set today_date "[clock format [clock scan [expr $today_date -1]] -format "%Y%m%d"]060000"
  set debit_sql "select
          count(1) as count,
          sum(amt_original) as amount
        from masclr.mas_trans_log
        where
          mas_code like '0102%' and
          card_scheme = '02' and
          trans_sub_seq = '0' and
          activity_date_time >= '01-JAN-12' and activity_date_time < '01-JAN-13'"
  set Query_sql "select
        t.tid,
        description,
        count(1) as count,
        sum(amt_trans)/100 as amount
         from masclr.in_draft_main idm,masclr.tid t
        where
          t.tid = idm.tid
          and activity_dt > '01-JAN-13'
          and activity_dt < '01-FEB-13'
          and t.tid in ('010103005101','010103005102','010103015101')
        group by t.tid,description order by t.tid"

} else {
  set today_date "[clock scan [lindex $argv 0] -format "%Y%m%d"]060000"
  set tomorrow_date "[clock scan [expr [lindex $argv 0] + 1] -format "%Y%m%d"]060000"
}
#puts $Query_sql
set today_date [string range $today_date 0 7]
set fileName "OKDMV-Funding-$today_date.csv"

readCfgFile
connect_to_db
set auth_sql [oraopen $auth_logon_handle]
set mas_sql [oraopen $mas_logon_handle]

orasql $mas_sql $debit_sql
orafetch $mas_sql -dataarray debit_query -indexbyname

set header "Transaction_type,Count Amount"
orasql $mas_sql $Query_sql
while {[orafetch $mas_sql -dataarray mas_query -indexbyname] != 1403 } {
  if {$mas_query(TID) == "010103005101"} {
    set info "$mas_query(DESCRIPTION),[expr $mas_query(COUNT) + $debit_query(COUNT)],[expr $mas_query(AMOUNT) + $debit_query(AMOUNT)
]\r\n"
  } else {
    set info "$mas_query(DESCRIPTION),$mas_query(COUNT),$mas_query(AMOUNT)\r\n"
  }
  append body $info
}

set Query_sql "select count(1) as count from
        (select
                merch_id
        from in_draft_main
        where
          activity_dt > '01-JAN-12'
          and activity_dt < '01-JAN-13'
          and tid in ('010103005101','010103005102','010103015101'))"
orasql $mas_sql $Query_sql
set info "Active merchants $mas_query(COUNT)"
append body " "
append body $info
append body " "




exec echo $header >> $fileName
exec echo $body >> $fileName

exec mutt -a /clearing/filemgr/JOURNALS/EXEC_REPORTS/$fileName -s "OKDMV funding Report for $today_date" -- reports-clearing@jetpay.com  < $fileName
exec mv $fileName ARCHIVE


exit 0 
