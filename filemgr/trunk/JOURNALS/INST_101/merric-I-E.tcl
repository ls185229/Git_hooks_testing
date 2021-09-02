#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# takes the row returned from an orafetch and loads it into an arry
# based opon the column names in the result

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

package require Oratcl
if {[catch {set handler [oralogon masclr/masclr@$env(IST_DB)]} result]} {
  exec echo "merchant statement failed to run" | mailx -r $mailfromlist -s "Merchant statement" $mailtolist
  exit
}

proc last_day {month year} {
    set a 0
    switch -- $month {
       JAN {set a 31}
       FEB {
            if {[expr $year / 4] == 0} {
              set a 29
            } else {
              set a 28
            }
          }
       MAR {set a 31}
       APR {set a 30}
       MAY {set a 31}
       JUN {set a 30}
       JUL {set a 31}
       AUG {set a 31}
       SEP {set a 30}
       OCT {set a 31}
       NOV {set a 30}
       DEC {set a 31}
     }
     return $a
}

set cursor [oraopen $handler]
set failed 0
set fetch_cursor [oraopen $handler]
set fetch_cursor1 [oraopen $handler]
set fetch_cursor2 [oraopen $handler]
set ach_cursor [oraopen $handler]
set test_cursor1 [oraopen $handler]
set settle_cursor [oraopen $handler]
set update_cursor [oraopen $handler]
set days_back 13
set today_date [clock format [clock scan "-[expr $days_back * 1] day"] -format %b-%y]
set upper_date [clock format [clock scan "-[expr $days_back - 1] day"] -format %d-%b-%y]
set filedate [clock format [clock scan "-[expr $days_back * 1] day"] -format %Y%m%d]
set name_date_year [clock format [clock scan "-[expr $days_back * 1] day"] -format %Y]
set name_date_month [clock format [clock scan "-[expr $days_back * 1] day"] -format %b]
set name_date_month [string toupper $name_date_month]

puts "$name_date_month $name_date_year"
set j [last_day $name_date_month $name_date_year]
set today_date [string toupper $today_date]
set upper_date [string toupper $upper_date]
# and DATE_TO_SETTLE <= '$upper_date'
set year_date [clock format [clock scan "-[expr $days_back * 1] day"] -format %y]
set name_date_month [clock format [clock scan "-[expr $days_back * 1] day"] -format %B]
set name_date_year [clock format [clock scan "-[expr $days_back * 1] day"] -format %y]
set month_date [clock format [clock scan "-[expr $days_back * 1] day"] -format %m]
set name_date "$name_date_month $name_date_year"
set collist1 [oracols $test_cursor1]
set rightnow [clock format [ clock scan "-[expr $days_back * 1] day" ] -format %Y%m]
set cur_local_time [clock seconds ]
set CUR_SET_TIME $cur_local_time
set CUR_JULIAN_DATEX [string range [clock format $CUR_SET_TIME -format "%y%j"] 1 4]
set cur_file_name "./101.REPORT.IE.$CUR_JULIAN_DATEX.$filedate.001.csv"
set file_name "101.REPORT.IE.$CUR_JULIAN_DATEX.$filedate.001.csv"
set cur_file [open "$cur_file_name" w]

set Month_Discount_Count 0
set Quarter_Discount_Count 0
set Year_Discount_Count 0

proc find_quarter {return value} {
  upvar $return a
  global days_back
  switch -- $value {
    01 { set value 1}
    02 { set value 1}
    03 { set value 1}
    04 { set value 2}
    05 { set value 2}
    06 { set value 2}
    07 { set value 3}
    08 { set value 3}
    09 { set value 3}
    10 { set value 4}
    11 { set value 4}
    12 { set value 4} 
  }
set upper_date [clock format [clock scan "-[expr $days_back - 1] day"] -format %d-%b-%y]
set upper_date [string toupper $upper_date]
  set year_date [clock format [clock scan "-[expr $days_back * 1] day"] -format %y]
  switch -- $value {
    1 { set a "(date_to_settle like '%JAN-$year_date' or date_to_settle like '%FEB-$year_date' or date_to_settle like '%MAR-$year_date') and date_to_settle <= '$upper_date'"}
    2 { set a "(date_to_settle like '%APR-$year_date' or date_to_settle like '%MAY-$year_date' or date_to_settle like '%JUN-$year_date')  and date_to_settle <= '$upper_date'"}
    3 { set a "(date_to_settle like '%JUL-$year_date' or date_to_settle like '%AUG-$year_date' or date_to_settle like '%SEP-$year_date') and date_to_settle <= '$upper_date'"}
    4 { set a "(date_to_settle like '%OCT-$year_date' or date_to_settle like '%NOV-$year_date' or date_to_settle like '%DEC-$year_date') and date_to_settle <= '$upper_date'"}
  }

}

proc find_quarter1 {return value} {
  upvar $return a
  global days_back
  switch -- $value {
    01 { set value 1}
    02 { set value 1}
    03 { set value 1}
    04 { set value 2}
    05 { set value 2}
    06 { set value 2}
    07 { set value 3}
    08 { set value 3}
    09 { set value 3}
    10 { set value 4}
    11 { set value 4}
    12 { set value 4}
  }
set upper_date [clock format [clock scan "-[expr $days_back - 1] day"] -format %d-%b-%y]
set upper_date [string toupper $upper_date]
  set year_date [clock format [clock scan "-[expr $days_back * 1] day"] -format %y]
  switch -- $value {
    1 { set a "(termination_date like '%JAN-$year_date' or termination_date like '%FEB-$year_date' or termination_date like '%MAR-$year_date') and termination_date <= '$upper_date'"}
    2 { set a "(termination_date like '%APR-$year_date' or termination_date like '%MAY-$year_date' or termination_date like '%JUN-$year_date')  and termination_date <= '$upper_date'"}
    3 { set a "(termination_date like '%JUL-$year_date' or termination_date like '%AUG-$year_date' or termination_date like '%SEP-$year_date') and termination_date <= '$upper_date'"}
    4 { set a "(termination_date like '%OCT-$year_date' or termination_date like '%NOV-$year_date' or termination_date like '%DEC-$year_date') and termination_date <= '$upper_date'"}
  }

}


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

proc section_header {value} {
 global cursor fetch_cursor ach_cursor test_cursor1 settle_cursor update_cursor today_date cur_file_name CUR_JULIAN_DATEX
 global upper_date year_date name_date_month name_date_year month_date name_date collist1 rightnow cur_local_time CUR_SET_TIME cur_file LOW_DATE UPPER_DATE LOW_DELAY_DATE UPP_DELAY_DATE days_back j

set Month_Count 1
set Quarter_Count 1
set Year_Count 1

set Month_Chargeback_Volume 0
set Month_Chargeback_Count 0
set Quarter_Chargeback_Volume 0
set Quarter_Chargeback_Count 0
set Year_Chargeback_Volume 0
set Year_Chargeback_Count 0
set Month_Representment_Volume 0
set Month_Representment_Count 0
set Quarter_Representment_Volume 0
set Quarter_Representment_Count 0
set Year_Representment_Volume 0
set Year_Representment_Count 0
set Month_Discount_Volume 0
set Year_Discount_Volume 0
set Month_Expense_Volume 0
set Quarter_Expense_Volume 0
set Year_Expense_Volume 0
set Month_Volume 0
set Quarter_Volume 0
set Year_Volume 0
set Quarter_Discount_Volume 0
set Month_Volume 0
set Month_Count 0
set Quarter_Volume 0
set Quarter_Count 0
set Year_Volume 0
set Year_Count 0
set Month_Refund_Volume 0
set Month_Refund_Count 0
set Quarter_Refund_Volume 0
set Quarter_Refund_Count 0
set Year_Refund_Volume 0
set Year_Refund_Count 0
set Month_Discount_Volume 0
set Month_Discount_Count 0
set Quarter_Discount_Volume 0
set Quarter_Discount_Count 0
set Year_Discount_Volume 0
set Year_Discount_Count 0
set Month_Minimum_Volume 0
set Month_Minimum_Count 0
set Quarter_Minimum_Volume 0
set Quarter_Minimum_Count 0
set Year_Minimum_Volume 0
set Year_Minimum_Count 0
set Month_Interchange_Volume 0
set Month_Interchange_Count 0
set Month_Income_Volume 0
set Month_Income_Count 0
set Month_Expense_Volume 0
set Month_Sales_Adj_Volume 0
set Month_Sales_Adj_Count 0
set Month_Credit_Adj_Volume 0
set Month_Credit_Adj_Count 0
set Quarter_Interchange_Volume 0
set Quarter_Interchange_Count 0
set Quarter_Income_Volume 0
set Quarter_Income_Count 0
set Quarter_Expense_Volume 0
set Quarter_Sales_Adj_Volume 0
set Quarter_Sales_Adj_Count 0
set Quarter_Credit_Adj_Volume 0
set Quarter_Credit_Adj_Count 0
set Year_Interchange_Volume 0
set Year_Interchange_Count 0
set Year_Income_Volume 0
set Year_Income_Count 0
set Year_Expense_Volume 0
set Year_Sales_Adj_Volume 0
set Year_Sales_Adj_Count 0
set Year_Credit_Adj_Volume 0
set Year_Credit_Adj_Count 0
set Merchant_Count 0

#MYKE

set Month_Discount_Count 1
set Quarter_Discount_Count 1
set Year_Discount_Count 1

puts "VOLUME"
set query_string "select unique entity_id from mas_trans_log where institution_id = '101' and date_to_settle like '%JAN-08'"
puts $query_string
orasql $fetch_cursor $query_string
while {[orafetch $fetch_cursor -dataarray s -indexbyname] != 1403} {

  set PLAN_TYPE G
  set DELAY_FACTOR 0
  set query_string "select settl_plan_type,settl_plan_id from settl_plan where plan_desc = '$s(ENTITY_ID)'"
  puts $query_string
  orasql $update_cursor $query_string
  while {[orafetch $update_cursor -dataarray a -indexbyname] != 1403} {
    set PLAN_TYPE $a(SETTL_PLAN_TYPE)
    set PLAN_ID $a(SETTL_PLAN_ID)
    set query_string "select Delay_factor0 from settl_plan_tid where settl_plan_id = '$PLAN_ID' and tid = '010003005101'"
    orasql $update_cursor $query_string
    puts $query_string
    while {[orafetch $update_cursor -dataarray a -indexbyname] != 1403} {
      set DELAY_FACTOR $a(DELAY_FACTOR0)
    }
  }

puts "-$days_back + 1 + $DELAY_FACTOR"
puts "-$days_back - $j + 1 + $DELAY_FACTOR"
set UPPER_DATE [clock format [clock scan "[expr -$days_back + 1 + $DELAY_FACTOR] day"] -format %d-%b-%y]
set LOW_DATE [clock format [clock scan "[expr -$days_back - $j + 1 + $DELAY_FACTOR] day"] -format %d-%b-%y]
set LOW_DATE [string toupper $LOW_DATE]
set UPPER_DATE [string toupper $UPPER_DATE]
set UPPER_DELAY_DATE [clock format [clock scan "[expr -$days_back + 1 + $DELAY_FACTOR] day"] -format %d-%b-%y]
set LOW_DELAY_DATE [clock format [clock scan "[expr -$days_back - $j + 1 + $DELAY_FACTOR] day"] -format %d-%b-%y]
set LOW_DELAY_DATE [string toupper $LOW_DELAY_DATE]
set UPPER_DELAY_DATE [string toupper $UPPER_DELAY_DATE]
puts "date_to_settle > '$LOW_DATE' and date_to_settle < '$UPPER_DATE'"
puts "date_to_settle > '$LOW_DELAY_DATE and date_to_settle < '$UPPER_DELAY_DATE'"


set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where date_to_settle > '$LOW_DELAY_DATE' and date_to_settle < '$UPPER_DELAY_DATE' and TID_SETTL_METHOD = 'C' and $value and tid like '0100030051%' and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
puts $query_string
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Month_Volume [expr $Month_Volume + $t(AMOUNT)]
  set Month_Count [expr $Month_Count + $t(COUNT)]
}

set date_query ""
set date_query "[find_quarter $date_query $month_date]"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where $date_query and TID_SETTL_METHOD = 'C' and $value and tid like '0100030051%' and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Quarter_Volume [expr $Quarter_Volume + $t(AMOUNT)]
  set Quarter_Count [expr $Quarter_Count + $t(COUNT)]
}

set date_query ""
set date_query "date_to_settle like '%$name_date_year' and date_to_settle <= '$upper_date'"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where $date_query and TID_SETTL_METHOD = 'C' and $value and tid like '0100030051%' and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Year_Volume [expr $Year_Volume + $t(AMOUNT)]
  set Year_Count [expr $Year_Count + $t(COUNT)]
}

puts "REFUND"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where date_to_settle > '$LOW_DATE' and date_to_settle < '$UPPER_DATE' and TID_SETTL_METHOD = 'D' and $value and tid like '0100030051%' and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Month_Refund_Volume [expr $Month_Refund_Volume + $t(AMOUNT)]
  set Month_Refund_Count [expr $Month_Refund_Count + $t(COUNT)]
}
 
set date_query ""
set date_query "[find_quarter $date_query $month_date]"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where $date_query and TID_SETTL_METHOD = 'D' and $value and tid like '0100030051%' and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Quarter_Refund_Volume [expr $Quarter_Refund_Volume + $t(AMOUNT)]
  set Quarter_Refund_Count [expr $Quarter_Refund_Count + $t(COUNT)]
}

set date_query ""
set date_query "date_to_settle like '%$name_date_year' and date_to_settle <= '$upper_date'"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where $date_query and TID_SETTL_METHOD = 'D' and $value and tid like '0100030051%' and institution_id = '101'  and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Year_Refund_Volume [expr $Year_Refund_Volume + $t(AMOUNT)]
  set Year_Refund_Count [expr $Year_Refund_Count + $t(COUNT)]
}

puts "DISCOUNT"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where date_to_settle > '$LOW_DATE' and date_to_settle < '$UPPER_DATE' and TID_SETTL_METHOD = 'C' and $value and (tid like '010004%' or tid like '01000507%')  and institution_id = '101' and settl_flag = 'Y' and entity_id = '$s(ENTITY_ID)'"
puts $query_string
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Month_Discount_Volume [expr $Month_Discount_Volume + $t(AMOUNT)]
  set Month_Discount_Count [expr $Month_Discount_Count + $t(COUNT)]
}
 
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where date_to_settle > '$LOW_DATE' and date_to_settle < '$UPPER_DATE' and TID_SETTL_METHOD = 'D' and $value and (tid like '010004%' or tid like '01000507%') and institution_id = '101' and settl_flag = 'Y' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Month_Discount_Volume [expr $Month_Discount_Volume - $t(AMOUNT)]
  set Month_Discount_Count [expr $Month_Discount_Count + $t(COUNT)]
}

set date_query ""
set date_query "[find_quarter $date_query $month_date]"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where $date_query and TID_SETTL_METHOD = 'C' and $value and (tid like '010004%' or tid like '01000507%') and institution_id = '101' and settl_flag = 'Y' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Quarter_Discount_Volume [expr $Quarter_Discount_Volume + $t(AMOUNT)]
  set Quarter_Discount_Count [expr $Quarter_Discount_Count + $t(COUNT)]
}

set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where $date_query and TID_SETTL_METHOD = 'D' and $value and (tid like '010004%' or tid like '01000507%') and institution_id = '101' and settl_flag = 'Y' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Quarter_Discount_Volume [expr $Quarter_Discount_Volume - $t(AMOUNT)]
  set Quarter_Discount_Count [expr $Quarter_Discount_Count + $t(COUNT)]
}


set date_query ""
set date_query "date_to_settle like '%$name_date_year' and date_to_settle <= '$upper_date'"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where $date_query and TID_SETTL_METHOD = 'C' and $value and (tid like '010004%' or tid like '01000507%') and institution_id = '101' and settl_flag = 'Y' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Year_Discount_Volume [expr $Year_Discount_Volume + $t(AMOUNT)]
  set Year_Discount_Count [expr  $Year_Discount_Count + $t(COUNT)]
}

set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where $date_query and TID_SETTL_METHOD = 'D' and $value and (tid like '010004%' or tid like '01000507%') and settl_flag = 'Y' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Year_Discount_Volume [expr $Year_Discount_Volume - $t(AMOUNT)]
  set Year_Discount_Count [expr  $Year_Discount_Count + $t(COUNT)]
}


puts "MINIMUM"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where date_to_settle > '$LOW_DATE' and date_to_settle < '$UPPER_DATE' and TID_SETTL_METHOD = 'C' and $value and tid like '01000419%' and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Month_Minimum_Volume [expr $Month_Minimum_Volume + $t(AMOUNT)]
  set Month_Minimum_Count [expr  $Month_Minimum_Count + $t(COUNT)]
}

set date_query ""
set date_query "[find_quarter $date_query $month_date]"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where $date_query and TID_SETTL_METHOD = 'C' and $value and tid like '01000419%' and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Quarter_Minimum_Volume [expr $Quarter_Minimum_Volume + $t(AMOUNT)]
  set Quarter_Minimum_Count [expr $Quarter_Minimum_Count + $t(COUNT)]
}

set date_query ""
set date_query "date_to_settle like '%$name_date_year' and date_to_settle <= '$upper_date'"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where $date_query and TID_SETTL_METHOD = 'C' and $value and tid like '01000419%'  and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Year_Minimum_Volume [expr $Year_Minimum_Volume + $t(AMOUNT)]
  set Year_Minimum_Count [expr $Year_Minimum_Count + $t(COUNT)]
}

puts "INTERCHANGE"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where date_to_settle > '$LOW_DATE' and date_to_settle < '$UPPER_DATE' and TID_SETTL_METHOD = 'C' and $value and (tid like '%4020000' or tid like '%4020005') and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Month_Interchange_Volume [expr $Month_Interchange_Volume + $t(AMOUNT)]
  set Month_Interchange_Count [expr $Month_Interchange_Count + $t(COUNT)]
}

set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where date_to_settle > '$LOW_DATE' and date_to_settle < '$UPPER_DATE' and TID_SETTL_METHOD = 'D' and $value and (tid like '%4020000' or tid like '%4020005') and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Month_Interchange_Volume [expr $Month_Interchange_Volume - $t(AMOUNT)]
  set Month_Interchange_Count [expr $Month_Interchange_Count + $t(COUNT)]
}


set date_query ""
set date_query "[find_quarter $date_query $month_date]"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where $date_query and TID_SETTL_METHOD = 'C' and $value and (tid like '%4020000' or tid like '%4020005') and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Quarter_Interchange_Volume [expr $Quarter_Interchange_Volume + $t(AMOUNT)]
  set Quarter_Interchange_Count [expr $Quarter_Interchange_Count + $t(COUNT)]
}
set date_query ""
set date_query "[find_quarter $date_query $month_date]"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where $date_query and TID_SETTL_METHOD = 'D' and $value and (tid like '%4020000' or tid like '%4020005') and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Quarter_Interchange_Volume [expr $Quarter_Interchange_Volume - $t(AMOUNT)]
  set Quarter_Interchange_Count [expr $Quarter_Interchange_Count + $t(COUNT)]
}

set date_query ""
set date_query "date_to_settle like '%$name_date_year' and date_to_settle <= '$upper_date'"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where $date_query and TID_SETTL_METHOD = 'C' and $value and (tid like '%4020000' or tid like '%4020005') and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Year_Interchange_Volume [expr $Year_Interchange_Volume + $t(AMOUNT)]
  set Year_Interchange_Count [expr $Year_Interchange_Count + $t(COUNT)]
}
set date_query ""
set date_query "date_to_settle like '%$name_date_year' and date_to_settle <= '$upper_date'"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where $date_query and TID_SETTL_METHOD = 'D' and $value and (tid like '%4020000' or tid like '%4020005') and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Year_Interchange_Volume [expr $Year_Interchange_Volume - $t(AMOUNT)]
  set Year_Interchange_Count [expr $Year_Interchange_Count + $t(COUNT)]
}

puts "INCOME"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where date_to_settle > '$LOW_DATE' and date_to_settle < '$UPPER_DATE' and TID_SETTL_METHOD = 'C' and $value and tid like '010040%' and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Month_Income_Volume [expr $Month_Income_Volume + $t(AMOUNT)]
  set Month_Income_Count [expr $Month_Income_Count + $t(COUNT)]
}

set date_query ""
set date_query "[find_quarter $date_query $month_date]"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where $date_query and TID_SETTL_METHOD = 'C' and $value and tid like '010040%' and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Quarter_Income_Volume [expr $Quarter_Income_Volume + $t(AMOUNT)]
  set Quarter_Income_Count [expr $Quarter_Income_Count + $t(COUNT)]
}

set date_query ""
set date_query "date_to_settle like '%$name_date_year' and date_to_settle <= '$upper_date'"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where $date_query and TID_SETTL_METHOD = 'C' and $value and tid like '010040%' and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Year_Income_Volume [expr $Year_Income_Volume + $t(AMOUNT)]
  set Year_Income_Count [expr $Year_Income_Count + $t(COUNT)]
}

puts "EXPENSE"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where date_to_settle > '$LOW_DATE' and date_to_settle < '$UPPER_DATE' and TID_SETTL_METHOD = 'C' and $value and tid like '010041%' and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Month_Expense_Volume [expr $Month_Expense_Volume + $t(AMOUNT)]
}

set date_query ""
set date_query "[find_quarter $date_query $month_date]"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where $date_query and TID_SETTL_METHOD = 'C' and $value and tid like '010041%' and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Quarter_Expense_Volume [expr $Quarter_Expense_Volume + $t(AMOUNT)]
}

set date_query ""
set date_query "date_to_settle like '%$name_date_year' and date_to_settle <= '$upper_date'"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where $date_query and TID_SETTL_METHOD = 'C' and $value and tid like '010041%' and institution_id = '101'  and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Year_Expense_Volume [expr $Year_Expense_Volume + $t(AMOUNT)]
}

set query_string "select count(1) as count from acq_entity where entity_level = '70' and parent_entity_id = '447474000000000' and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Merchant_Count [expr $Merchant_Count + $t(COUNT)]
}

puts "ADJ"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where date_to_settle > '$LOW_DATE' and date_to_settle < '$UPPER_DATE' and TID_SETTL_METHOD = 'C' and $value and tid like '01000801' and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Month_Sales_Adj_Volume [expr $Month_Sales_Adj_Volume + $t(AMOUNT)]
  set Month_Sales_Adj_Count [expr $Month_Sales_Adj_Count + $t(COUNT)]
}

set date_query ""
set date_query "[find_quarter $date_query $month_date]"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where $date_query and TID_SETTL_METHOD = 'C' and $value and tid like '01000801' and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Quarter_Sales_Adj_Volume [expr $Quarter_Sales_Adj_Volume + $t(AMOUNT)]
  set Quarter_Sales_Adj_Count [expr $Quarter_Sales_Adj_Count + $t(COUNT)]
}

set date_query ""
set date_query "date_to_settle like '%$name_date_year' and date_to_settle <= '$upper_date'"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where $date_query and TID_SETTL_METHOD = 'C' and $value and tid like '01000801' and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Year_Sales_Adj_Volume [expr $Year_Sales_Adj_Volume + $t(AMOUNT)]
  set Year_Sales_Adj_Count [expr $Year_Sales_Adj_Count + $t(COUNT)]
}

puts "CREDIT"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where date_to_settle > '$LOW_DATE' and date_to_settle < '$UPPER_DATE' and TID_SETTL_METHOD = 'C' and $value and tid like '01000802' and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Month_Credit_Adj_Volume [expr $Month_Credit_Adj_Volume + $t(AMOUNT)]
  set Month_Credit_Adj_Count [expr $Month_Credit_Adj_Count + $t(COUNT)]
}

set date_query ""
set date_query "[find_quarter $date_query $month_date]"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where $date_query and TID_SETTL_METHOD = 'C' and $value and tid like '01000802' and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Quarter_Credit_Adj_Volume [expr $Quarter_Credit_Adj_Volume + $t(AMOUNT)]
  set Quarter_Credit_Adj_Count [expr $Quarter_Credit_Adj_Count + $t(COUNT)]
}

set date_query ""
set date_query "date_to_settle like '%$name_date_year' and date_to_settle <= '$upper_date'"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count from mas_trans_log where $date_query and TID_SETTL_METHOD = 'C' and $value and tid like '01000802' and institution_id = '101' and entity_id = '$s(ENTITY_ID)'"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set Year_Credit_Adj_Volume [expr $Quarter_Credit_Adj_Volume + $t(AMOUNT)]
  set Year_Credit_Adj_Count [expr $Quarter_Credit_Adj_Count + $t(COUNT)]
}

puts "CHARGEBACK"

set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count,TID_SETTL_METHOD from mas_trans_log where date_to_settle > '$LOW_DATE' and date_to_settle < '$UPPER_DATE' and $value and tid in ('010003015101','010003005202') and institution_id = '101' and entity_id = '$s(ENTITY_ID)' group by TID_SETTL_METHOD"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  if {$t(TID_SETTL_METHOD) == "D"} {
    set Month_Chargeback_Volume [expr $Month_Chargeback_Volume + $t(AMOUNT)]
    set Month_Chargeback_Count [expr $Month_Chargeback_Count + $t(COUNT)]
  } else {
    set Month_Chargeback_Volume [expr $Month_Chargeback_Volume - $t(AMOUNT)]
    set Month_Chargeback_Count [expr $Month_Chargeback_Count + $t(COUNT)]
  }
}

set date_query ""
set date_query "[find_quarter $date_query $month_date]"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count ,TID_SETTL_METHOD from mas_trans_log where $date_query and $value and tid in ('010003015101','010003005202') and institution_id = '101'  and entity_id = '$s(ENTITY_ID)' group by TID_SETTL_METHOD"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  if {$t(TID_SETTL_METHOD) == "D"} {
    set Quarter_Chargeback_Volume [expr $Quarter_Chargeback_Volume + $t(AMOUNT)]
    set Quarter_Chargeback_Count [expr $Quarter_Chargeback_Count + $t(COUNT)]
  } else {
    set Quarter_Chargeback_Volume [expr $Quarter_Chargeback_Volume - $t(AMOUNT)]
    set Quarter_Chargeback_Count [expr $Quarter_Chargeback_Count + $t(COUNT)]
  }
}

set date_query ""
set date_query "date_to_settle like '%$name_date_year' and date_to_settle <= '$upper_date'"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count,TID_SETTL_METHOD from mas_trans_log where $date_query and $value and tid in ('010003015101','010003005202') and institution_id = '101' and entity_id = '$s(ENTITY_ID)' group by TID_SETTL_METHOD"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  if {$t(TID_SETTL_METHOD) == "D"} {
    set Year_Chargeback_Volume [expr $Year_Chargeback_Volume + $t(AMOUNT)]
    set Year_Chargeback_Count [expr $Year_Chargeback_Count + $t(COUNT)]
  } else {
    set Year_Chargeback_Volume [expr $Year_Chargeback_Volume - $t(AMOUNT)]
    set Year_Chargeback_Count [expr $Year_Chargeback_Count + $t(COUNT)]
  }
}

set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count,TID_SETTL_METHOD from mas_trans_log where date_to_settle > '$LOW_DELAY_DATE' and date_to_settle < '$UPPER_DELAY_DATE' and $value and tid like '010003005301' and institution_id = '101'  and entity_id = '$s(ENTITY_ID)' group by TID_SETTL_METHOD"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  if {$t(TID_SETTL_METHOD) == "D"} {
    set Month_Representment_Volume [expr $Month_Representment_Volume + $t(AMOUNT)]
    set Month_Representment_Count [expr $Month_Representment_Count + $t(COUNT)]
  } else {
    set Month_Representment_Volume [expr $Month_Representment_Volume - $t(AMOUNT)]
    set Month_Representment_Count [expr $Month_Representment_Count + $t(COUNT)]
  }
}

set date_query ""
set date_query "[find_quarter $date_query $month_date]"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count,TID_SETTL_METHOD from mas_trans_log where $date_query and $value and tid like '010003005301' and institution_id = '101'  and entity_id = '$s(ENTITY_ID)' group by TID_SETTL_METHOD"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  if {$t(TID_SETTL_METHOD) == "D"} {
    set Quarter_Representment_Volume [expr $Quarter_Representment_Volume + $t(AMOUNT)]
    set Quarter_Representment_Count [expr $Quarter_Representment_Count + $t(COUNT)]
  } else {
    set Quarter_Representment_Volume [expr $Quarter_Representment_Volume - $t(AMOUNT)]
    set Quarter_Representment_Count [expr $Quarter_Representment_Count + $t(COUNT)]
  }
}

set date_query ""
set date_query "date_to_settle like '%$name_date_year' and date_to_settle <= '$upper_date'"
set query_string "select sum(AMT_ORIGINAL) as amount, count(1) as count,TID_SETTL_METHOD from mas_trans_log where $date_query and $value and tid like '010003005301' and institution_id = '101' and entity_id = '$s(ENTITY_ID)' group by TID_SETTL_METHOD"
orasql $test_cursor1 $query_string
if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  if {$t(TID_SETTL_METHOD) == "D"} {
    set Year_Representment_Volume [expr $Year_Representment_Volume + $t(AMOUNT)]
    set Year_Representment_Count [expr $Year_Representment_Count + $t(COUNT)]
  } else {
    set Year_Representment_Volume [expr $Year_Representment_Volume - $t(AMOUNT)]
    set Year_Representment_Count [expr $Year_Representment_Count + $t(COUNT)]
  }
}
}

if { $Month_Discount_Count == 0 } {
  set Month_Discount_Count 1
  set Quarter_Discount_Count 1
  set Year_Discount_Count 1 
}

if { $Month_Count == 0 } {
  set Month_Count 1
  set Quarter_Count 1
  set Year_Count 1
}

set Month_Discount_Average_Volume [expr $Month_Discount_Volume / $Month_Discount_Count]
set Quarter_Discount_Average_Volume [expr $Quarter_Discount_Volume / $Quarter_Discount_Count]
set Year_Discount_Average_Volume [expr $Year_Discount_Volume / $Year_Discount_Count]
set Month_Net_Sale_Volume [expr $Month_Volume - $Month_Refund_Volume]
set Month_Net_Sale_Count [expr $Month_Count + $Month_Refund_Count]
set Quarter_Net_Sale_Volume [expr $Quarter_Volume - $Quarter_Refund_Volume]
set Quarter_Net_Sale_Count [expr $Quarter_Count + $Quarter_Refund_Count]
set Year_Net_Sale_Volume [expr $Year_Volume - $Year_Refund_Volume]
set Year_Net_Sale_Count [expr $Year_Count + $Year_Refund_Count]

if { $Month_Net_Sale_Count == 0 } {
  set Month_Net_Sale_Count 1
  set Quarter_Net_Sale_Count 1
  set Year_Net_Sale_Count 1
}

  set Month_Income_Average_Volume 0
  set Quarter_Income_Average_Volume 0
  set Year_Income_Average_Volume 0
  set Month_Expense_Average_Volume 0
  set Quarter_Expense_Average_Volume 0
  set Year_Expense_Average_Volume 0
  set Month_Average_Volume 0
  set Quarter_Average_Volume 0
  set Year_Average_Volume 0

if {$Merchant_Count != 0 } {
  set Month_Income_Average_Volume [expr $Month_Net_Sale_Volume / $Month_Net_Sale_Count]
  set Quarter_Income_Average_Volume [expr $Quarter_Net_Sale_Volume / $Quarter_Net_Sale_Count]
  set Year_Income_Average_Volume [expr $Year_Net_Sale_Volume / $Year_Net_Sale_Count]
  set Month_Expense_Average_Volume [expr $Month_Expense_Volume / $Merchant_Count]
  set Quarter_Expense_Average_Volume [expr $Quarter_Expense_Volume / $Merchant_Count]
  set Year_Expense_Average_Volume [expr $Year_Expense_Volume / $Merchant_Count]
  puts "$Month_Volume / $Month_Net_Sale_Count"
  set Month_Average_Volume [expr $Month_Volume / $Month_Count]
  set Quarter_Average_Volume [expr $Quarter_Volume / $Quarter_Count]
  set Year_Average_Volume [expr $Year_Volume / $Year_Count]
}

  puts $cur_file " TOTAL SALES VOLUME, $Month_Count,$Month_Volume,$Quarter_Count,$Quarter_Volume,$Year_Count,$Year_Volume\r"
  puts $cur_file " TOTAL CREDIT VOLUME, $Month_Refund_Count,$Month_Refund_Volume,$Quarter_Refund_Count,$Quarter_Refund_Volume,$Year_Refund_Count,$Year_Refund_Volume\r"
  puts $cur_file " NET SALES, $Month_Net_Sale_Count,$Month_Net_Sale_Volume,$Quarter_Net_Sale_Count,$Quarter_Net_Sale_Volume,$Year_Net_Sale_Count,$Year_Net_Sale_Volume\r"
  puts $cur_file "\r"
  puts $cur_file " FEES\r"
  puts $cur_file "DISCOUNT, , $Month_Discount_Volume, , $Quarter_Discount_Volume,,$Year_Discount_Volume\r"
  puts $cur_file "MINIMUM DISCOUNT,,$Month_Minimum_Volume,,$Quarter_Minimum_Count,,$Year_Minimum_Count\r"
  puts $cur_file "DUE MERCHANT \r"
  #puts $cur_file "DUE BANK, , $Month_Discount_Volume, , $Quarter_Discount_Volume,,$Year_Discount_Volume\r"
  puts $cur_file "NET, , $Month_Discount_Volume, , $Quarter_Discount_Volume,,$Year_Discount_Volume\r"
  puts $cur_file "\r"
  puts $cur_file "TOTAL INTERCHANGE,,$Month_Interchange_Volume,,$Quarter_Interchange_Volume,,$Year_Interchange_Volume\r"
  puts $cur_file "\r"
if {$Month_Count != 0 } {
  puts $cur_file "AVERAGE TICKET,,[format "%0.2f" $Month_Income_Average_Volume],,[format "%0.2f" $Quarter_Income_Average_Volume],,[format "%0.2f" $Year_Income_Average_Volume]\r"
  puts $cur_file "AVERAGE DISCOUNT,,$Month_Discount_Average_Volume,,$Quarter_Discount_Average_Volume,,$Year_Discount_Average_Volume\r"
} else {
  puts $cur_file "AVERAGE TICKET,,,,,,\r"
  puts $cur_file "AVERAGE DISCOUNT\r"
}

  puts $cur_file "AVERAGE EXPENSE,,$Month_Expense_Average_Volume,,$Quarter_Expense_Average_Volume,,$Year_Expense_Average_Volume \r"
  puts $cur_file "AVERAGE INCOME,,$Month_Income_Average_Volume,,$Quarter_Income_Average_Volume,,$Year_Income_Average_Volume\r"
  puts $cur_file "CHARGEBACKS,$Month_Chargeback_Count,$Month_Chargeback_Volume,$Quarter_Chargeback_Count,$Quarter_Chargeback_Volume,$Year_Chargeback_Count,$Year_Chargeback_Volume \r"
  puts $cur_file "CHARGEBACKS CREDITS,$Month_Representment_Count,$Month_Representment_Volume,$Quarter_Representment_Count,$Quarter_Representment_Volume,$Year_Representment_Count,$Year_Representment_Volume,\r"
  puts $cur_file "CHARGEBACKS REVERSALS\r"
  puts $cur_file "SALES ADJ\r"
  puts $cur_file "CREDIT ADJ\r"
}


proc Interchange {value} {

 global cursor fetch_cursor ach_cursor test_cursor1 settle_cursor update_cursor today_date cur_file_name CUR_JULIAN_DATEX
 global fetch_cursor1 fetch_cursor2 upper_date
 global year_date name_date_month name_date_year month_date name_date collist1 rightnow cur_local_time CUR_SET_TIME cur_file

  set query_string "select MTL.TID_SETTL_METHOD, MTL.mas_code, sum(percent_amt) as percent,MTL.tid,MTL.percent_rate,MTL.per_item_amt,MTL.card_scheme, sum(MTL.amt_original) as amount, count(1) as count, MC.mas_desc from mas_trans_log MTL,mas_code MC where MTL.date_to_settle like '%$name_date_year' and mtl.date_to_settle <= '$upper_date' and MC.mas_code = MTL.mas_code and (MTL.tid = '010004020000' or MTL.tid = '010004020005') and $value and institution_id = '101' group by MTL.tid,MTL.card_scheme,MTL.percent_rate,MTL.per_item_amt,MC.mas_desc,MTL.mas_code,MTL.TID_SETTL_METHOD order by MTL.card_scheme,MTL.MAS_CODE"

  orasql $fetch_cursor $query_string
  while {[orafetch $fetch_cursor -dataarray v -indexbyname] != 1403} {
    set date_query ""
    set date_query "[find_quarter $date_query $month_date]"
    set query_string "select MTL.TID_SETTL_METHOD, MTL.mas_code, sum(percent_amt) as percent,MTL.tid,MTL.percent_rate,MTL.per_item_amt,MTL.card_scheme, sum(MTL.amt_original) as amount, count(1) as count, MC.mas_desc from mas_trans_log MTL,mas_code MC where $date_query and MC.mas_code = '$v(MAS_CODE)' and MC.mas_code = MTL.mas_code and (MTL.tid = '010004020000' or MTL.tid = '010004020005') and $value  and institution_id = '101' group by MTL.tid,MTL.card_scheme,MTL.percent_rate,MTL.per_item_amt,MC.mas_desc,MTL.mas_code,MTL.TID_SETTL_METHOD order by MTL.card_scheme,MTL.MAS_CODE"
    orasql $fetch_cursor2 $query_string
    if {[orafetch $fetch_cursor2 -dataarray u -indexbyname] == 1403} {
      set QUARTER_COUNT 0
      set QUARTER_AMOUNT 0
    } else {
      set QUARTER_COUNT $u(COUNT)
      set QUARTER_AMOUNT $u(AMOUNT)
    }

    set query_string "select MTL.TID_SETTL_METHOD, MTL.mas_code, sum(percent_amt) as percent,MTL.tid,MTL.percent_rate,MTL.per_item_amt,MTL.card_scheme, sum(MTL.amt_original) as amount, count(1) as count, MC.mas_desc from mas_trans_log MTL,mas_code MC where MTL.date_to_settle like '%$today_date' and date_to_settle <= '$upper_date' and MC.mas_code = '$v(MAS_CODE)' and MC.mas_code = MTL.mas_code and (MTL.tid = '010004020000' or MTL.tid = '010004020005') and $value  and institution_id = '101' group by MTL.tid,MTL.card_scheme,MTL.percent_rate,MTL.per_item_amt,MC.mas_desc,MTL.mas_code,MTL.TID_SETTL_METHOD order by MTL.card_scheme,MTL.MAS_CODE"
    orasql $fetch_cursor1 $query_string
    if {[orafetch $fetch_cursor1 -dataarray w -indexbyname] == 1403} {
      set MONTH_COUNT 0
      set MONTH_AMOUNT 0
    } else {
      set MONTH_COUNT $w(COUNT)
      set MONTH_AMOUNT $w(AMOUNT)
    }
    #if {$v(TID) == "010004020005"} {
    #  set MONTH_AMOUNT [expr -1 * $w(AMOUNT)]
    #} else {
    #  set MONTH_AMOUNT [expr 1 * $w(AMOUNT)]
    #}
    puts $cur_file "$v(MAS_DESC), $MONTH_COUNT,$MONTH_AMOUNT,$QUARTER_COUNT,$QUARTER_AMOUNT,$v(COUNT),$v(AMOUNT)"
  }
}

set query_string "select count(1) as count from acq_entity where ENTITY_STATUS <> 'A' and (entity_id not in (select entity_id from mas_trans_log where tid like '010003%' and date_to_settle like '%$today_date' and date_to_settle <= '$upper_date')) and institution_id = '101'"
#orasql $test_cursor1 $query_string
puts $query_string
#if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
#  set Month_Dead_Count $t(COUNT)
#}

set date_query ""
set date_query "[find_quarter $date_query $month_date]"
set query_string "select count(1) as count from acq_entity where ENTITY_STATUS <> 'A' and (entity_id not in (select entity_id from mas_trans_log where tid like '010003%' and $date_query and date_to_settle <= '$upper_date')) and institution_id = '101'"
#orasql $test_cursor1 $query_string
#if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
#  set Quarter_Dead_Count $t(COUNT)
#}

set date_query ""
set date_query "date_to_settle like '%$name_date_year' and date_to_settle <= '$upper_date'"
set query_string "select count(1) as count from acq_entity where ENTITY_STATUS <> 'A' and (entity_id not in (select entity_id from mas_trans_log where tid like '010003%' and $date_query)) and institution_id = '101'"
puts "$query_string 1"
#orasql $test_cursor1 $query_string
#if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
#  set Year_Dead_Count $t(COUNT)
#}

set query_string "select count(1) as count from acq_entity where ENTITY_STATUS = 'A' and entity_id in (select entity_id from mas_trans_log where tid like '010003%' and date_to_settle like '%$today_date' and date_to_settle <= '$upper_date') and institution_id = '101'"
#orasql $test_cursor1 $query_string
#if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
#  set Month_Live_Count $t(COUNT)
#}

set date_query ""
set date_query "[find_quarter $date_query $month_date]"
set query_string "select count(1) as count from acq_entity where ENTITY_STATUS = 'A' and entity_id in (select entity_id from mas_trans_log where tid like '010003%' and $date_query and date_to_settle <= '$upper_date') and institution_id = '101'"
#orasql $test_cursor1 $query_string
#if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
#  set Quarter_Live_Count $t(COUNT)
#}

set date_query ""
set date_query "date_to_settle like '%$name_date_year' and date_to_settle <= '$upper_date'"
set query_string "select count(1) as count from acq_entity where ENTITY_STATUS = 'A' and entity_id in (select entity_id from mas_trans_log where $date_query and tid like '010003%' and date_to_settle <= '$upper_date') and institution_id = '101'"
puts "$query_string 1"
#orasql $test_cursor1 $query_string
#if {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
#  set Year_Live_Count $t(COUNT)
#}



 puts $cur_file "Monthly Processor Income & Expense Report\r"
 puts $cur_file "$name_date\r"
 puts $cur_file "ALL PLAN TYPES,MTD,,QTD,,YTD"
 #puts $cur_file "ACTIVE MERCHANTS, $Month_Live_Count,,$Quarter_Live_Count,,$Year_Live_Count"
 #puts $cur_file "INACTIVE MERCHANTS, $Month_Dead_Count,,$Quarter_Dead_Count,,$Year_Dead_Count"
 #puts $cur_file "TOTAL MERCHANTS, [expr $Month_Live_Count + $Month_Dead_Count],,[expr $Quarter_Live_Count + $Quarter_Dead_Count],,[expr $Year_Live_Count + $Year_Dead_Count]"
 puts "ALL PLAN TYPES"
 section_header "CARD_SCHEME in ('04','05','00','03','08')"
 puts $cur_file "\r"

 puts $cur_file "TOTAL VISA"
 puts "TOTAL VISA"
 section_header "CARD_SCHEME in ('04')"
 Interchange "MTL.card_scheme in ('04')"
 puts $cur_file "\r"

 puts $cur_file "CONSUMER VISA"
 puts "CONSUMER VISA"
 section_header "CARD_SCHEME in ('04') and mas_code in (select mas_code from mas_code where IRF_PROG_IND_DESC = 'CONSUMER')"
 puts $cur_file "\r"

 puts $cur_file "VISA DEBIT"
 puts "VISA DEBIT"
 section_header "CARD_SCHEME in ('04') and mas_code in (select mas_code from mas_code where IRF_PROG_IND_DESC = 'DEBIT')"
 puts $cur_file "\r"

 puts $cur_file "VISA BUSINESS"
 puts "VISA BUSINESS"
 section_header "CARD_SCHEME in ('04') and mas_code in (select mas_code from mas_code where IRF_PROG_IND_DESC = 'BUSINESS')"
 puts $cur_file "\r"

 puts $cur_file "TOTAL MASTERCARD"
 puts "TOTAL MASTERCARD"
 section_header "CARD_SCHEME in ('05')"
 Interchange "MTL.card_scheme in ('05')"
 puts $cur_file "\r"

 puts $cur_file "CONSUMER MASTERCARD"
 puts "CONSUMER MASTERCARD"
 section_header "CARD_SCHEME in ('05') and mas_code in (select mas_code from mas_code where IRF_PROG_IND_DESC = 'CONSUMER')"
 puts $cur_file "\r"

 puts $cur_file "MASTERCARD DEBIT"
 puts "MASTERCARD DEBIT"
 section_header "CARD_SCHEME in ('05') and mas_code in (select mas_code from mas_code where IRF_PROG_IND_DESC = 'DEBIT')"
 puts $cur_file "\r"

 puts $cur_file "MASTERCARD BUSINESS"
 puts "MASTERCARD BUSINESS"
 section_header "CARD_SCHEME in ('05') and mas_code in (select mas_code from mas_code where IRF_PROG_IND_DESC = 'BUSINESS')"
 puts $cur_file "\r"

 puts $cur_file "AMEX"
 puts "AMEX"
 #section_header "CARD_SCHEME in ('03')"
 puts $cur_file "\r"

 puts $cur_file "DISC"
 puts "DISC"
 #section_header "CARD_SCHEME in ('06')"
 puts $cur_file "\r"

 puts $cur_file "DEBIT"
 puts "DEBIT"
 puts $cur_file "\r"

 puts $cur_file "JCB"
 puts "JCB"
 puts $cur_file "\r"

 puts $cur_file "EBT"
 puts "EBT"
 puts $cur_file "\r"



  close $cur_file
exec uuencode $cur_file_name $file_name | mailx -r teipord@jetpay.com -s $file_name clearing@jetpay.com

