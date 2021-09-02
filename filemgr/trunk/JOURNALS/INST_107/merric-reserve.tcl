#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

##################################################################################



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

####################################################################################################################

# takes the row returned from an orafetch and loads it into an arry
# based opon the column names in the result

proc not_null {return value} {
  upvar $return a
  if {$value == ""} {
  set a " "
  } else {
  set a $value
  }
};

proc format_count {value} {
  set count 0
  set a [string range $value [expr [string length $value] -3] [string length $value]]
  set value [string range $value 0 [expr [string length $value] -4]]
  while {$count <= [expr [string length $value] - 0]} {
    if {[expr $count % 3] == 0} {
      set a "*[string range $value [expr [string length $value] - $count ] [expr [string length $value] - $count + 2]]$a"
    }
    set count [expr $count + 1]
  }
  set a "[string range $value 0 [expr [string length $value] % 3 - 1]]$a"
  if {[string range $a 0 0] == "*"} {
    set a "[string range $a 1 [string length $a]]"
  }

  return $a
};

package require Oratcl
if {[catch {set handler [oralogon masclr/masclr@$env(IST_DB)]} result]} {
  exec echo "merchant statement failed to run" | mailx -r mailfromlist -s "Merchant statement" $mailtolist
  exit
}

set cursor [oraopen $handler]
set failed 0
set fetch_cursor [oraopen $handler]
set ach_cursor [oraopen $handler]
set test_cursor1 [oraopen $handler]
set settle_cursor [oraopen $handler]
set update_cursor [oraopen $handler]
set fdate [clock format [clock scan "-0 month"] -format %b-%y]
set date [clock format [clock scan "-0 day"] -format %d-%b-%y]
set filedate [clock format [clock scan "-0 day"] -format %Y%m%d]
set name_date_month [clock format [clock scan "-0 month"] -format %B]
set name_date_year [clock format [clock scan "-0 month"] -format %Y]

set name_date "$name_date_month $name_date_year"
set fdate [string toupper $fdate]
set date [string toupper $date]
set offdate "01-$fdate"
set ondate "01-$date"


#set query_string "select unique entity_id from mas_trans_log where DATE_TO_SETTLE like '%$date' and institution_id = '107'"
set query_string "select unique entity_id from mas_trans_log where institution_id = '107'"
puts $query_string
orasql $test_cursor1 $query_string
set collist1 [oracols $test_cursor1]
set rightnow [clock format [ clock scan "-0 day" ] -format %Y%m%d]
set cur_local_time [clock seconds ]
set CUR_SET_TIME $cur_local_time
set CUR_JULIAN_DATEX [string range [clock format $CUR_SET_TIME -format "%y%j"] 1 4]
set cur_file_name "./UPLOAD/107.REPORT.RESERVE.$CUR_JULIAN_DATEX.$filedate.001.csv"
set file_name "107.REPORT.RESERVE.$CUR_JULIAN_DATEX.$filedate.001.csv"
set cur_file [open "$cur_file_name" w]
puts $cur_file "RESERVE REPORT"
puts $cur_file "Date:,$date\n"
puts $cur_file "ISO#,Merchant ID, Merchant Name,Status Code, Contract Date,Pay Status,Reserve,CBR Rate\r\n"
set GRAND_SETTLED_BC 0
set GRAND_SETTLED_NONBC 0
set GRAND_CHARGEBACK_AMOUNT 0
set GRAND_REJECTS 0
set GRAND_REFUNDS 0
set GRAND_ADVANCE_FUNDING 0
set GRAND_MISC_ADJUSTMENTS 0
set GRAND_ACH_RESUB 0
set GRAND_RESERVES 0
set GRAND_DISCOUNT 0
set GRAND_NETDEPOSIT 0


while {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  puts $t(ENTITY_ID)
  set STATUS_CODE 0
  set CONTRACT_DATE 0
  set PAY_STATUS 0
  set RESERVE 0
  set CBR_RATE 0


  set query_string "select rsrv_percentage,parent_entity_id,entity_dba_name,creation_date,rsrv_fund_status,entity_status from acq_entity where entity_id = '$t(ENTITY_ID)' and institution_id = '107'"
  orasql $fetch_cursor $query_string
  while {[orafetch $fetch_cursor -dataarray s -indexbyname] != 1403} {
    set NAME $s(ENTITY_DBA_NAME)
    set CONTRACT_DATE $s(CREATION_DATE)
    set STATUS_CODE $s(RSRV_FUND_STATUS)
    set CBR_RATE $s(RSRV_PERCENTAGE)
    set PARENT $s(PARENT_ENTITY_ID)
    if {$s(ENTITY_STATUS) == "A"} {
      set PAY_STATUS ACTIVE
    } else {
      set PAY_STATUS INACTIVE
    }
  }
  if {$STATUS_CODE != "F"} {
    set query_string "select sum(amt_original) as total from mas_trans_log where tid like '01000705%' and ENTITY_ID = '$t(ENTITY_ID)' and institution_id = '107'"
    orasql $fetch_cursor $query_string
    while {[orafetch $fetch_cursor -dataarray s -indexbyname] != 1403} {
      set RESERVE $s(TOTAL)
    }
    if {$RESERVE != 0} {
      puts $cur_file "$PARENT,$t(ENTITY_ID),$NAME,$STATUS_CODE,$CONTRACT_DATE,$PAY_STATUS,$RESERVE,$CBR_RATE\r"
    }
  }
}
  close $cur_file
  exec uuencode $cur_file_name ./$cur_file_name | mailx -r teipord@jetpay.com -s $file_name accounting@jetpay.com clearing@jetpay.com

oraclose $fetch_cursor