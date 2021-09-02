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
  exec echo "merchant statement failed to run" | mailx -r $mailfromlist -s "Merchant statement" $mailtolist
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
set report_ddate [clock format [clock scan "-0 month"] -format %m/%d/%y]
set report_mdate [clock format [clock scan "-0 month"] -format %m/%y]
set name_date_month [clock format [clock scan "-0 month"] -format %B]
set name_date_year [clock format [clock scan "-0 month"] -format %Y]
set name_date "$name_date_month $name_date_year"
set fdate [string toupper $fdate]
set date [string toupper $date]
set offdate "01-$fdate"
set ondate "01-$date"

set query_string "select count(1) num from acq_entity where entity_status = 'A' and institution_id = '101'"
orasql $test_cursor1 $query_string
while {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  puts $t(NUM)
  set ACTIVE_MERCHANT $t(NUM)
}

set query_string "select count(1) num from acq_entity where entity_status <> 'A' and institution_id = '101'"
orasql $test_cursor1 $query_string
while {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set INACTIVE_MERCHANT $t(NUM)
}

set query_string "select unique entity_id from mas_trans_log where DATE_TO_SETTLE like '%$date' and institution_id = '101'"
puts $query_string
orasql $test_cursor1 $query_string
set collist1 [oracols $test_cursor1]
set rightnow [clock format [ clock scan "-0 day" ] -format %Y%m%d]
set cur_local_time [clock seconds ]
set CUR_SET_TIME $cur_local_time
set CUR_JULIAN_DATEX [string range [clock format $CUR_SET_TIME -format "%y%j"] 1 4]
set cur_file_name "./101.REPORT.PORTFOLIO.$CUR_JULIAN_DATEX.$filedate.001.csv"
set file_name "101.REPORT.PORTFOLIO.$CUR_JULIAN_DATEX.$filedate.001.csv"
set cur_file [open "$cur_file_name" w]
puts $cur_file "Portfolio Report"
puts $cur_file "VISA COUNT,VISA VOLUME, MC COUNT, MC VOLUME, VISA REFUND COUNT,VISA REFUND AMOUNT, MC REFUND COUNT,MC REFUND AMOUNT, VISA CHARGEBACK COUNT,VISA CHARGEBACK AMOUNT, MC CHARGEBACK COUNT,MC CHARGEBACK AMOUNT,VISA CHARGEBACK REVERSAL, MC CHARGEBACK REVERSAL, ACTIVE MERCHANTS,INACTIVE MERCHANTS, TERMINAL COUNT,VISA RISK COUNT,VISA RISK AMOUNT, MC RISK COUNT ,MC RISK AMOUNT,CARD NOT PRESENT COUNT,CARD NOT PRESENT AMOUNT, EBT COUNT, EBT AMOUNT, DEBIT COUNT,DEBIT AMOUNT, INTERLINK MERCHANT COUNT,PIN ENABLE MERCHANT COUNT, INTERLINK TERMINAL COUNT,PIN ENABLE TERMINAL COUNT\r\n"
set VISA_COUNT 0
set VISA_AMOUNT 0
set VISA_COUNT_REFUND 0
set VISA_AMOUNT_REFUND 0
set MC_COUNT 0
set MC_AMOUNT 0
set MC_COUNT_REFUND 0
set MC_AMOUNT_REFUND 0
set TE_COUNT 0
set TE_AMOUNT 0
set JCB_COUNT 0
set JCB_AMOUNT 0
set DBT_COUNT 0
set DBT_AMOUNT 0
set EBT_COUNT 0
set EBT_AMOUNT 0
set CARD_NP_COUNT 0
set CARD_NP_AMOUNT 0

while {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  puts $t(ENTITY_ID)
  set query_string "select * from mas_trans_log where DATE_TO_SETTLE like '%$fdate' and ENTITY_ID = '$t(ENTITY_ID)' and institution_id = '101'"
  orasql $fetch_cursor $query_string
  while {[orafetch $fetch_cursor -dataarray s -indexbyname] != 1403} {
      switch -- $s(TID) {
        010003005102 {
                      switch -exact -- $s(CARD_SCHEME) {
                                  04 {
          				set VISA_COUNT_REFUND [expr $VISA_COUNT_REFUND + 1]
                                        set VISA_AMOUNT_REFUND [expr $VISA_AMOUNT_REFUND + $s(AMT_ORIGINAL)]
                                     }
                                  05 {
                                        set MC_COUNT_REFUND [expr $MC_COUNT_REFUND + 1]
                                        set MC_AMOUNT_REFUND [expr $MC_AMOUNT_REFUND + $s(AMT_ORIGINAL)]
                                     }



                                                       }

                     }
        010003005101 {
                      switch -exact -- $s(CARD_SCHEME) {
                                  04 {
                                        set VISA_COUNT [expr $VISA_COUNT + 1]
                                        set VISA_AMOUNT [expr $VISA_AMOUNT + $s(AMT_ORIGINAL)]
                                     }
                                  05 {
                                        set MC_COUNT [expr $MC_COUNT + 1]
                                        set MC_AMOUNT [expr $MC_AMOUNT + $s(AMT_ORIGINAL)]
                                     }
						       }
                     }
        010070040000 {
                        set CARD_NP_COUNT [expr $CARD_NP_COUNT + 1]
                        set CARD_NP_AMOUNT [expr $CARD_NP_AMOUNT + $s(AMT_ORIGINAL)]
                     }

      }
  }
}

  puts $cur_file "$VISA_COUNT,$VISA_AMOUNT,$MC_COUNT,$MC_AMOUNT,$VISA_COUNT_REFUND,$VISA_AMOUNT_REFUND,$MC_COUNT_REFUND,$MC_AMOUNT_REFUND, , , , , , ,$ACTIVE_MERCHANT,$INACTIVE_MERCHANT,$ACTIVE_MERCHANT, , , , ,$CARD_NP_COUNT,$CARD_NP_AMOUNT"

  close $cur_file
  exec uuencode $cur_file_name $file_name | mailx -r teipord@jetpay.com -s $file_name reports-clearing@jetpay.com

oraclose $fetch_cursor
