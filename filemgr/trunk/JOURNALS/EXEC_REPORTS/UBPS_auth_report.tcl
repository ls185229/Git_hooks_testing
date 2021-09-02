#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

#Execution: upbs_auth_report.tcl

################################################################################
#
#    File Name - ubps_auth_report.tcl
#
#    Description - This report generates a summary of approved and declined transactions,in the auth system over the report period. The report
#                  period covers 7 days unless start and end date parameters are passed to it.
#
#    Arguments - $1 Report start date. If no argument, then defaults to today's date.       EX. 20130204
#                $2 Report end date. If no argument, then defaults to today's date plus 7.  EX. 20130211
#
################################################################################
# $Id: $
# $Rev: $
# $Author: $
################################################################################

#######################################################################################################################

#Input Parameters

set start_date [lindex $argv 0]
set end_date   [lindex $argv 1]

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

#Sum Variables
set auth_count_total 0
set auth_amount_total 0
set capture_count_total  0
set capture_amount_total 0
set refund_count_total 0
set refund_amount_total 0

set modified_auth_amount 0
set modified_capture_amount 0
set modified_refund_amount 0

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
   global port_db_logon
   global port_db
   
   set cfg_file_name UBPS_AUTH.cfg

   set port_db_logon ""
   set port_db ""

   if {[catch {open $cfg_file_name r} file_ptr]} {
      puts "File Open Err:Cannot open config file $cfg_file_name"
      exit 1
   }

   while { [set line [gets $file_ptr]] != {}} {
      set line_parms [split $line ,]
      switch -exact -- [lindex  $line_parms 0] {
         "PORT_DB_LOGON" {
            set port_db_logon [lindex $line_parms 1]
         }
         "PORT_DB" {
            set port_db [lindex $line_parms 1]
         }
         default {
            puts "Unknown config parameter [lindex $line_parms 0]"
         }
      }
   }

   close $file_ptr

   if {$port_db_logon == ""} {
      puts "Unable to find PORT_DB_LOGON params in $cfg_file_name, exiting..."
      exit 2
   }

}

################################################################################
#
#    Procedure Name - validate_date
#
#    Description - Validates that a date paramter is in the format YYYYMMDD and
#                  is a valid date value.
#
#    Arguments - $date_type  - "start date" or "end date"
#                $input_date - Date value to be tested. Pass $start_date or $end date to it
#
#    Return - Return 1 if the date is valid. Exit script if the date is invalid.
#
###############################################################################
proc validate_date {date_type input_date} {
    set tmp_len [string length $input_date]
    if {$tmp_len < 8 || $tmp_len > 8} {
        # Validate date is 8 characters long
        puts "Invalid $date_type parameter '$input_date' entered. Date must be in format YYYYMMDD."
        exit 1
    }
    # NOTE: only validate until 20371231
    # Anything beyond that goes foobar
    if { [catch {clock scan $input_date} result] } {
        # we have a bad date
        puts "Invalid $date_type parameter '$input_date' entered. Must be a valid date and in the format YYYYMMDD."
        exit 1
    }

    return 1
}

#################################
# connect_to_db
#  handles connections to the database
#################################

proc connect_to_db {} {
   global port_logon_handle port_db_logon port_db

                if {[catch {set port_logon_handle [oralogon $port_db_logon@$port_db]} result] } {
                        puts "Encountered error $result while trying to connect to DB"
                                exit 1
                } else {
                        puts "Connected"
                }
};# end connect_to_db

################################################################################
#
#    Procedure Name - convert_currency
#
#    Description - Converts a currency code to a currency conversion rate. 
#                  Note that these currency rates are hard coded because we
#                  do not have a good method for updating them daily.
#
#    Arguments - $curr_code  - Three letter currency code. 
#
#    Return - Floating point currency rate for the selected currency code.
#
###############################################################################

proc convert_currency {curr_code} {

switch $curr_code {
    "ARS" {return 0.19}
    "BRL" {return 0.50}
    "CAD" {return 0.99}
    "EUR" {return 1.29}
    "GBR" {return 1.52}
    "MXN" {return [expr 1/12.32]}
    "USD" {return 1}
    "VND" {return 4.77897e-05}
    default {return 1}
    }
}


#################################
# Main
#################################

puts "ubps_auth_report.tcl Started"


if {$start_date == ""} {
    # If no input parameters then set the start and end date
    set start_date [clock format [clock seconds] -format "%Y%m%d"]
    set end_date   [clock format [clock scan "$start_date 6 day"] -format "%Y%m%d"]
} else {
    # Start date parameter was entered; validate it.
    if  {[validate_date "start date" $start_date]} {
        if {$end_date == ""} {
	    # No end date parameter entered; set it based on the start date.
            set end_date   [clock format [clock scan "$start_date 6 day"] -format "%Y%m%d"]
        } else {
	    #  Start date paramter was entered; validate it.
            set result [validate_date "end date" $end_date]
        }
    }
}

# Validate the start date is before the end date
if {$start_date > $end_date} {
    puts "Start date $start_date must be before end date $end_date."
    exit 1
} else {
    puts "Running report for date range $start_date - $end_date"
}

set report_start_date [clock format [clock scan "$start_date"] -format "%m/%d/%Y"]
set report_end_date [clock format [clock scan "$end_date"] -format "%m/%d/%Y"]
set fileName "UBPS-Auth-$start_date.csv"

# Append hour, minutes, and seconds to the start and end date
append start_date  "000000"
append end_date    "235959"

# Terminal query counts the number of active terminals at the start of the report period
set terminal_sql "SELECT 'Active Terminal Count,' || COUNT(DISTINCT tid) AS tid_count
                  FROM   transaction t
                  WHERE  t.authdatetime BETWEEN '$start_date' AND '$end_date'
                    AND  t.request_type IN ('0100', '0104', '0200', '0220', '0250', '0260', '0262', '0420', '0460', '1200', '1260', '1262')"

# Approved query generates a summary of approved transactions, grouped by currency
set approved_sql "SELECT c.curr_code_alpha3 AS currency_code,
                         SUM(CASE WHEN t.request_type IN ('0100', '0104', '0200', '0260', '1200', '1260') THEN 1         ELSE 0 END) AS auth_count,
                         SUM(CASE WHEN t.request_type IN ('0100', '0104', '0200', '0260', '1200', '1260') THEN t.amount  ELSE 0 END) AS auth_amount,
                         SUM(CASE WHEN t.request_type IN ('0200', '0220', '0250', '0262', '1200', '1260') THEN 1         ELSE 0 END) AS capture_count,
                         SUM(CASE WHEN t.request_type IN ('0200', '0220', '0250', '0262', '1200', '1260') THEN t.amount  ELSE 0 END) AS capture_amount,
                         SUM(CASE WHEN t.request_type IN ('0420', '0460', '0262', '1262', '1420')         THEN 1         ELSE 0 END) AS refund_count,
                         SUM(CASE WHEN t.request_type IN ('0420', '0460', '0262', '1262', '1420')         THEN -t.amount ELSE 0 END) AS refund_amount
                  FROM   transaction t,
                         masclr.currency_code c
                  WHERE  t.shipdatetime BETWEEN '$start_date' AND '$end_date'
                    AND  c.curr_code = t.currency_code
                    AND  t.action_code  = '000'
                    AND  t.request_type IN ('0100', '0104', '0200', '0220', '0250', '0260', '0262', '0420', '0460', '1200', '1260', '1262')
                  GROUP BY c.curr_code_alpha3
                  ORDER BY c.curr_code_alpha3"

# Declined query generates a summary of declined transactions, grouped by currency
set declined_sql "SELECT c.curr_code_alpha3 AS currency_code,
                         SUM(CASE WHEN t.request_type IN ('0100', '0104', '0200', '0260', '1200', '1260') THEN 1         ELSE 0 END) AS auth_count,
                         SUM(CASE WHEN t.request_type IN ('0100', '0104', '0200', '0260', '1200', '1260') THEN t.amount  ELSE 0 END) AS auth_amount,
                         SUM(CASE WHEN t.request_type IN ('0200', '0220', '0250', '0262', '1200', '1260') THEN 1         ELSE 0 END) AS capture_count,
                         SUM(CASE WHEN t.request_type IN ('0200', '0220', '0250', '0262', '1200', '1260') THEN t.amount  ELSE 0 END) AS capture_amount,
                         SUM(CASE WHEN t.request_type IN ('0420', '0460', '0262', '1262', '1420')         THEN 1         ELSE 0 END) AS refund_count,
                         SUM(CASE WHEN t.request_type IN ('0420', '0460', '0262', '1262', '1420')         THEN -t.amount ELSE 0 END) AS refund_amount
                  FROM   transaction t,
                         masclr.currency_code c
                  WHERE  t.shipdatetime BETWEEN '$start_date' AND '$end_date'
                    AND  c.curr_code = t.currency_code
                    AND  t.action_code  != '000'
                    AND  t.request_type IN ('0100', '0104', '0200', '0220', '0250', '0260', '0262', '0420', '0460', '1200', '1260', '1262')
                  GROUP BY c.curr_code_alpha3
                  ORDER BY c.curr_code_alpha3"

readCfgFile
connect_to_db
set port_sql [oraopen $port_logon_handle]


# Generate active terminal count
orasql $port_sql $terminal_sql
while {[orafetch $port_sql -dataarray terminal_query -indexbyname] != 1403 } {
  set info "$terminal_query(TID_COUNT)\r\n"
  append body $info
}

#exec rm $fileName
exec echo "Start Date,$report_start_date" > $fileName
exec echo "End Date,$report_end_date" >> $fileName
exec echo $body >> $fileName

# Generate approved transaction summary
set info ""
set body ""

set header "Approved Transactions\r\nCurrency,Auth Count,Auth Amount,Capture Count,Capture Amount,Refund Count,Refund Amount"
orasql $port_sql $approved_sql
while {[orafetch $port_sql -dataarray approved_query -indexbyname] != 1403 } {
   
    set curr_rate [convert_currency $approved_query(CURRENCY_CODE)] 
    set modified_auth_amount     [format "%.2f" [expr $approved_query(AUTH_AMOUNT)    * $curr_rate]]
    set modified_capture_amount  [format "%.2f" [expr $approved_query(CAPTURE_AMOUNT) * $curr_rate]]
    set modified_refund_amount   [format "%.2f" [expr $approved_query(REFUND_AMOUNT)  * $curr_rate]]
    #set modified_auth_amount     [format "%.2f" [expr int($approved_query(AUTH_AMOUNT)    + (0.5/$curr_rate)) * $curr_rate]]
    #set modified_capture_amount  [format "%.2f" [expr int($approved_query(CAPTURE_AMOUNT) + (0.5/$curr_rate)) * $curr_rate]]
    #set modified_refund_amount   [format "%.2f" [expr int($approved_query(REFUND_AMOUNT)  + (0.5/$curr_rate)) * $curr_rate]]
    set auth_count_total     [expr $auth_count_total + $approved_query(AUTH_COUNT)]
    set auth_amount_total    [expr $auth_amount_total + $modified_auth_amount] 
    set capture_count_total  [expr $capture_count_total + $approved_query(CAPTURE_COUNT)] 
    set capture_amount_total [expr $capture_amount_total + $modified_capture_amount]
    set refund_count_total   [expr $refund_count_total + $approved_query(REFUND_COUNT)]
    set refund_amount_total  [expr $refund_amount_total + $modified_refund_amount]

    set info "$approved_query(CURRENCY_CODE),$approved_query(AUTH_COUNT),$modified_auth_amount,$approved_query(CAPTURE_COUNT),$modified_capture_amount,$approved_query(REFUND_COUNT),$modified_refund_amount\r\n"
  append body $info
}

append body "TOTAL,$auth_count_total,$auth_amount_total,$capture_count_total,$capture_amount_total,$refund_count_total,$refund_amount_total\r\n"

exec echo $header >> $fileName
exec echo $body >> $fileName

# Generate declined transaction summary
set info ""
set body ""

set auth_count_total 0
set auth_amount_total 0
set capture_count_total  0
set capture_amount_total 0
set refund_count_total 0
set refund_amount_total 0

set header "Declined Transactions\r\nCurrency,Auth Count,Auth Amount,Capture Count,Capture Amount,Refund Count,Refund Amount"
orasql $port_sql $declined_sql
while {[orafetch $port_sql -dataarray declined_query -indexbyname] != 1403 } {

    set curr_rate [convert_currency $declined_query(CURRENCY_CODE)]
    set modified_auth_amount     [format "%.2f" [expr $declined_query(AUTH_AMOUNT)    * $curr_rate]]
    set modified_capture_amount  [format "%.2f" [expr $declined_query(CAPTURE_AMOUNT) * $curr_rate]]
    set modified_refund_amount   [format "%.2f" [expr $declined_query(REFUND_AMOUNT)  * $curr_rate]]
    #set modified_auth_amount     [format "%.2f" [expr int($declined_query(AUTH_AMOUNT)    + (0.5/$curr_rate)) * $curr_rate]]
    #set modified_capture_amount  [format "%.2f" [expr int($declined_query(CAPTURE_AMOUNT) + (0.5/$curr_rate)) * $curr_rate]]
    #set modified_refund_amount   [format "%.2f" [expr int($declined_query(REFUND_AMOUNT)  + (0.5/$curr_rate)) * $curr_rate]]
    set auth_count_total     [expr $auth_count_total + $declined_query(AUTH_COUNT)]
    set auth_amount_total    [expr $auth_amount_total + $modified_auth_amount]
    set capture_count_total  [expr $capture_count_total + $declined_query(CAPTURE_COUNT)]
    set capture_amount_total [expr $capture_amount_total + $modified_capture_amount]
    set refund_count_total   [expr $refund_count_total + $declined_query(REFUND_COUNT)]
    set refund_amount_total  [expr $refund_amount_total + $modified_refund_amount]

    set info "$declined_query(CURRENCY_CODE),$declined_query(AUTH_COUNT),$modified_auth_amount,$declined_query(CAPTURE_COUNT),$modified_capture_amount,$declined_query(REFUND_COUNT),$modified_refund_amount\r\n"

    append body $info
}

append body "TOTAL,$auth_count_total,$auth_amount_total,$capture_count_total,$capture_amount_total,$refund_count_total,$refund_amount_total\r\n"

exec echo $header >> $fileName
exec echo $body >> $fileName

exec mutt -a /clearing/filemgr/JOURNALS/EXEC_REPORTS/$fileName -s "UBPS Auth Report for $report_start_date - $report_end_date" -- dwright@jetpay.com < $fileName
exec mv $fileName ARCHIVE

exit 0 
