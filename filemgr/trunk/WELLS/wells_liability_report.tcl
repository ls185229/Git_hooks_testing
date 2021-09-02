#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: wells_liability_report.tcl 4670 2018-08-23 13:46:15Z bjones $
# $Rev: 4670 $
################################################################################

################################################################################
#
#    File Name    wells_liability_report.tcl
#
#    Description  This is a custom report for wells fargo to display
#                 transactions that fall outside of normal liability.
#
#    Arguments    $1 Date to run the report. e.g. 20140501
#                 This scripts can run with or without a date. If no date
#                 provided it will use start and end of the last month. With
#                 one date argument, the script will calculatethe month start
#                 and end based on the given date.
#
#    Example:    With date argument:  wells_liability_report.sh -d 20140501
#
################################################################################

################################################################################

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
   global merchant_list

   set cfg_file_name wells_liability.cfg

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
         "SHORTNAME_LIST" {
            set Shortname_list [lindex $line_parms 1]
         }
         "MERCHANT_LIST" {
            set merchant_list [lindex $line_parms 1]
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

   if {[catch {set auth_logon_handle [oralogon port_ro/port_ro@$clr_db]} result] } {
        puts "Encountered error $result while trying to connect to DB"
        exit 1
   } else {
        puts "\nConnected to PORT"
   }

   if {[catch {set mas_logon_handle [oralogon $clr_db_logon@$clr_db]} result] } {
        puts "Encountered error $result while trying to connect to DB"
        exit 1
   } else {
        puts "Connected to CLR"
   }

};# end connect_to_db


proc remove_blanks s {regsub -all " +" $s " "}

##################
#####  MAIN  #####
##################

readCfgFile

connect_to_db

set auth_sql  [oraopen $auth_logon_handle]
set auth_sql1 [oraopen $auth_logon_handle]
set mas_sql   [oraopen $mas_logon_handle]
set mas_sql1  [oraopen $mas_logon_handle]

puts "wells_liability_report.tcl Started at: [clock format [clock seconds] -format "%Y%m%dT%H:%M:%S"]"

##Setting up the date range

#scan for Date
if { [regexp -- {(-[dD])[ ]+([0-9]{8,8})} $argv dummy1 dummy2 date_arg] } {
      puts "Date argument: $date_arg"
      set given_date $date_arg
}

if {![info exists given_date]} {
  set given_date         [clock format [clock seconds] -format "%Y%m"]
  set report_date        [clock format [clock add [clock scan $given_date -format "%Y%m"] -1 months] -format "%Y%m"]
  set end_date $given_date
  append end_date "01160000"
  set start_date         [clock format [clock add [clock scan $given_date -format "%Y%m"] -1 months] -format "%Y%m01160000"]
  set avg_3mo_start_date [clock format [clock add [clock scan $given_date -format "%Y%m"] -4 months] -format "%Y%m01160000"]
} else {
  set start_date         [clock format [clock scan $given_date -format "%Y%m%d"] -format "%Y%m01"]
  set report_date        [clock format [clock scan $given_date -format "%Y%m%d"] -format "%Y%m"]
  set end_date           [clock format [clock scan "$start_date +1 month"] -format "%Y%m01160000"]
  set avg_3mo_start_date [clock format [clock add [clock scan $start_date -format "%Y%m%d"] -3 months] -format "%Y%m01160000"]
  append start_date "160000"
}

puts "Report Date: $report_date"
puts "Start Date:  $start_date"
puts "End Date:    $end_date"
puts "3 Months AVG Start Date: $avg_3mo_start_date"

set mail_to "Reports-clearing@jetpay.com"

set fileName "wells_liability_report_$report_date.csv"

set header    "Merchant ID,Merchant Name,Sales Count,Sales Amount,Chargeback Count,Chargeback Amount,Refund Count,"
append header "Refund Amount,3 month average Sales Count,3 month average Sales Amount,3 month average Chargeback Count,"
append header "3 month average Chargeback Amount,3 month average Refund Count,3 month average Refund Amount"

exec echo $header >> $fileName

##Getting Mid list

set Query_sql "select entity_id
               from master_entity_hierarchy
               where entity_type = 'ME'
                 and root_entity_type = 'IS'
                 and root_entity_code = 'CONVERGENCE-TECH'"

orasql $auth_sql $Query_sql

set body ""

while {[orafetch $auth_sql -dataarray mas_query1 -indexbyname] != 1403 } {
#       puts "working on $mas_query1(ENTITY_ID)"

  set Query_sql "
      SELECT idm.merch_id,
             ae.entity_name ENTITY_NAME,
             SUM(CASE WHEN tid = '010103005101' THEN 1 ELSE 0 END)             AS SALES_COUNT1,
             SUM(CASE WHEN tid = '010103005101' THEN amt_trans ELSE 0 END)/100 AS SALES_AMOUNT1,
             SUM(CASE WHEN tid = '010103015101' THEN 1 ELSE 0 END)             AS CB_COUNT1,
             SUM(CASE WHEN tid = '010103015101' THEN amt_trans ELSE 0 END)/100 AS CB_AMOUNT1,
             SUM(CASE WHEN tid = '010103005102' THEN 1 ELSE 0 END)             AS REFUND_COUNT1,
             SUM(CASE WHEN tid = '010103005102' THEN amt_trans ELSE 0 END)/100 AS REFUND_AMOUNT1
      FROM
             masclr.in_draft_main idm

      RIGHT JOIN masclr.acq_entity ae
            on idm.merch_id = ae.entity_id
      WHERE
            to_char(idm.activity_dt,'YYYYMMDDHH24MISS') >= '$start_date'
            and to_char(idm.activity_dt,'YYYYMMDDHH24MISS') < '$end_date'
            and idm.merch_id in ('$mas_query1(ENTITY_ID)')
            and ae.entity_status = 'A'
      GROUP BY
            idm.merch_id,
            ae.entity_name
      ORDER BY idm.merch_id"

#     puts "Main Query: $Query_sql"

  orasql $auth_sql1 $Query_sql

  if {[orafetch $auth_sql1 -dataarray mas_query -indexbyname] != 1403 } {

       set ENT_NAME1 [string map {, " "} $mas_query(ENTITY_NAME)]
       set ENT_NAME2 [remove_blanks $ENT_NAME1]

       append body "$mas_query(MERCH_ID),$ENT_NAME2,$mas_query(SALES_COUNT1),"
       append body "[format "%0.2f" $mas_query(SALES_AMOUNT1)],$mas_query(CB_COUNT1),"
       append body "[format "%0.2f" $mas_query(CB_AMOUNT1)],$mas_query(REFUND_COUNT1),"
       append body "[format "%0.2f" $mas_query(REFUND_AMOUNT1)],"

#      puts "doing 3 month average"

       set Query_sql "
           SELECT idm.merch_id,
                  ae.entity_name,

                  SUM(CASE WHEN tid = '010103005101' THEN 1 ELSE 0 END)/3           AS SALES_COUNT3,
                  SUM(CASE WHEN tid = '010103005101' THEN amt_trans ELSE 0 END)/300 AS SALES_AMOUNT3,
                  SUM(CASE WHEN tid = '010103015101' THEN 1 ELSE 0 END)/3           AS CB_COUNT3,
                  SUM(CASE WHEN tid = '010103015101' THEN amt_trans ELSE 0 END)/300 AS CB_AMOUNT3,
                  SUM(CASE WHEN tid = '010103005102' THEN 1 ELSE 0 END)/3           AS REFUND_COUNT3,
                  SUM(CASE WHEN tid = '010103005102' THEN amt_trans ELSE 0 END)/300 AS REFUND_AMOUNT3
           FROM
                  masclr.in_draft_main idm

           RIGHT JOIN masclr.acq_entity ae
                 on idm.merch_id = ae.entity_id
           WHERE
                 to_char(idm.activity_dt,'YYYYMMDDHH24MISS') >= '$avg_3mo_start_date'
                 and to_char(idm.activity_dt,'YYYYMMDDHH24MISS') < '$start_date'
                 and idm.merch_id in ('$mas_query1(ENTITY_ID)')
           GROUP BY idm.merch_id,
                 ae.entity_name
           ORDER BY idm.merch_id"

#      puts "AVG Query: $Query_sql"

  orasql $auth_sql1 $Query_sql

  if {[orafetch $auth_sql1 -dataarray mas_query -indexbyname] != 1403 } {
       append body "[expr round($mas_query(SALES_COUNT3))],[format "%0.2f" $mas_query(SALES_AMOUNT3)],"
       append body "[expr round($mas_query(CB_COUNT3))],[format "%0.2f" $mas_query(CB_AMOUNT3)],"
       append body "[expr round($mas_query(REFUND_COUNT3))],[format "%0.2f" $mas_query(REFUND_AMOUNT3)]\r\n"
  } else {
    append body "\r\n"
  }

  }
}

exec echo $body >> $fileName

exec echo "Please see attached."  | mutt -a $fileName -s "Wells Fargo Liability Report for $report_date" -- $mail_to

exec mv $fileName ARCHIVE

puts "wells_liability_report.tcl Ended at: [clock format [clock seconds] -format "%Y%m%dT%H:%M:%S"]"

exit 0
