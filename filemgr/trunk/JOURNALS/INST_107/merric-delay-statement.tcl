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
set fdate [clock format [clock scan "-0 day"] -format %b-%y]
set date [clock format [clock scan "-0 day"] -format %d-%b-%y]
set tomorrow [clock format [clock scan "+1 day"] -format %d-%b-%y]
set filedate [clock format [clock scan "-0 day"] -format %Y%m%d]
set name_date_month [clock format [clock scan "-0 day"] -format %B]
set name_date_year [clock format [clock scan "-0 day"] -format %Y]
set name_date "$name_date_month $name_date_year"
set fdate [string toupper $fdate]
set date [string toupper $date]
set offdate "01-$fdate"
set ondate "01-$date"


#set query_string "select unique entity_id from mas_trans_log where ACTIVITY_DATE_TIME = '$date' and (institution_id,settl_plan_id) in (select institution_id,SETTL_PLAN_ID from settl_plan_tid where delay_factor0 <> '0' and delay_factor1 <> '0' and institution_id = '107')  and institution_id = '107'"
set query_string "select unique entity_id from mas_trans_log where (institution_id,settl_plan_id) in (select institution_id,SETTL_PLAN_ID from settl_plan_tid where delay_factor0 <> '0' and delay_factor1 <> '0' and institution_id = '107')  and institution_id = '107'"
puts $query_string
orasql $test_cursor1 $query_string
set collist1 [oracols $test_cursor1]
set rightnow [clock format [ clock scan "-0 day" ] -format %Y%m%d]
set cur_local_time [clock seconds ]
set CUR_SET_TIME $cur_local_time
set CUR_JULIAN_DATEX [string range [clock format $CUR_SET_TIME -format "%y%j"] 1 4]
set cur_file_name "./UPLOAD/107.REPORT.PAYABLES.$CUR_JULIAN_DATEX.$filedate.001.csv"
set file_name "107.REPORT.PAYABLES.$CUR_JULIAN_DATEX.$filedate.001.csv"
set cur_file [open "$cur_file_name" w]
puts $cur_file "PAYABLES REPORT"
puts $cur_file "Date:,$date\n"
puts $cur_file "ISO#,Merchant ID, Merchant Name,Settle Bankcards, Settle NonBankcards,Chargeback Amount, Rejects,Refunds,Misc Adj., ACH Resub., Reserves, Discount( Misc. Fees), Net Deposit\r\n"
set GRAND_SETTLED_BC 0
set GRAND_SETTLED_NONBC 0
set GRAND_CHARGEBACK_AMOUNT 0
set GRAND_REJECTS 0
set GRAND_REFUNDS 0
set GRAND_MISC_ADJUSTMENTS 0
set GRAND_ACH_RESUB 0
set GRAND_RESERVES 0
set GRAND_DISCOUNT 0
set GRAND_NETDEPOSIT 0


while {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  puts $t(ENTITY_ID)
  set ENTITY_ID $t(ENTITY_ID)
  set SETTLED_BC 0
  set SETTLED_NONBC 0
  set CHARGEBACK_AMOUNT 0
  set REJECTS 0
  set REFUNDS 0
  set MISC_ADJUSTMENTS 0
  set ACH_RESUB 0
  set RESERVES 0
  set DISCOUNT 0
  set NETDEPOSIT 0


  set query_string "select parent_entity_id,entity_dba_name,actual_start_date from acq_entity where entity_id = '$t(ENTITY_ID)' and institution_id = '107'"
  orasql $fetch_cursor $query_string
  while {[orafetch $fetch_cursor -dataarray s -indexbyname] != 1403} {
    set ISO $s(PARENT_ENTITY_ID)
    set NAME $s(ENTITY_DBA_NAME)
    set CONTRACT_DATE $s(ACTUAL_START_DATE)
  }

  set query_string "select * from entity_acct where OWNER_ENTITY_ID = '$t(ENTITY_ID)' and institution_id = '107'"
  orasql $fetch_cursor $query_string
  while {[orafetch $fetch_cursor -dataarray s -indexbyname] != 1403} {
    set acount $s(ACCT_NBR)
    set routing $s(TRANS_ROUTING_NBR)
  }
set query_string "select unique tid from mas_trans_log where date_to_settle > '$date' and (institution_id,settl_plan_id,tid) in (select institution_id,SETTL_PLAN_ID,tid from settl_plan_tid where delay_factor0 <> '0' and delay_factor1 <> '0' and institution_id = '107')  and institution_id = '107' and entity_id = $ENTITY_ID and activity_date_time < '$tomorrow'"
  orasql $fetch_cursor $query_string
  while {[orafetch $fetch_cursor -dataarray w -indexbyname] != 1403} {

  set query_string "select * from mas_trans_log where date_to_settle >  '$date' and ENTITY_ID = '$t(ENTITY_ID)' and institution_id = '107' and tid like '$w(TID)' and activity_date_time < '$tomorrow'"
  puts $query_string
  orasql $fetch_cursor $query_string
  while {[orafetch $fetch_cursor -dataarray s -indexbyname] != 1403} {
      puts $s(TID)
      if {$s(TID) == 010003005102} {
        set REFUNDS [expr $REFUNDS - $s(AMT_ORIGINAL)]
        set NETDEPOSIT [expr $NETDEPOSIT -  $s(AMT_ORIGINAL)]
        set GRAND_REFUNDS [expr $GRAND_REFUNDS - $s(AMT_ORIGINAL)]
        set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT -  $s(AMT_ORIGINAL)]
      }
      if {$s(TID) == 010003005101} {
        if {$s(CARD_SCHEME) == 04 || $s(CARD_SCHEME) == 05} {
          set SETTLED_BC [expr $SETTLED_BC + $s(AMT_ORIGINAL)]
          set NETDEPOSIT [expr $NETDEPOSIT +  $s(AMT_ORIGINAL)]
          set GRAND_SETTLED_BC [expr $GRAND_SETTLED_BC + $s(AMT_ORIGINAL)]
          set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT +  $s(AMT_ORIGINAL)]
        } else {
          set SETTLED_NONBC [expr $SETTLED_NONBC + $s(AMT_ORIGINAL)]
          set NETDEPOSIT [expr $NETDEPOSIT +  $s(AMT_ORIGINAL)]
          set GRAND_SETTLED_NONBC [expr $GRAND_SETTLED_NONBC + $s(AMT_ORIGINAL)]
          set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT +  $s(AMT_ORIGINAL)]
        }
      }

      if {[string range $s(TID) 0 5] == "010008" || [string range $s(TID) 0 5] == 010042 || [string range $s(TID) 0 5] == 010051} {
        if {$s(TID_SETTL_METHOD) == "C"} {
          set MISC_ADJUSTMENTS [expr $MISC_ADJUSTMENTS + $s(AMT_ORIGINAL)]
          set GRAND_MISC_ADJUSTMENTS [expr $GRAND_MISC_ADJUSTMENTS + $s(AMT_ORIGINAL)]
        } else {
          set DISCOUNT [expr $DISCOUNT - $s(AMT_ORIGINAL)]
          set GRAND_DISCOUNT [expr $GRAND_DISCOUNT - $s(AMT_ORIGINAL)]
        }
      }

      if {$s(TID) == 010007150000 || $s(TID) == 010007150001} {
        if {$s(TID_SETTL_METHOD) == "C"} {
          set ACH_RESUB [expr $ACH_RESUB + $s(AMT_ORIGINAL)]
          set GRAND_ACH_RESUB [expr $GRAND_ACH_RESUB + $s(AMT_ORIGINAL)]
        } else {
          set ACH_RESUB [expr $ACH_RESUB - $s(AMT_ORIGINAL)]
          set GRAND_ACH_RESUB [expr $GRAND_ACH_RESUB - $s(AMT_ORIGINAL)]
        }
      }

      if {$s(TID) == 010007150000 || $s(TID) == 010007150001} {
        if {$s(TID_SETTL_METHOD) == "C"} {
          set RESERVES [expr $RESERVES + $s(AMT_ORIGINAL)]
          set GRAND_RESERVES [expr $GRAND_RESERVES + $s(AMT_ORIGINAL)]
        } else {
          set RESERVES [expr $RESERVES - $s(AMT_ORIGINAL)]
          set GRAND_RESERVES [expr $GRAND_RESERVES - $s(AMT_ORIGINAL)]
        }
      }

      if {[string range $s(TID) 0 5] == 010004 || [string range $s(TID) 0 5] == 010040 || [string range $s(TID) 0 5] == 010050 || [string range $s(TID) 0 5] == "010080" && $s(TID) != 010004020000 && $s(TID) != 010004020005 && $s(TID) != 010004030000 && $s(TID) != 010004330000 } {
        if {$s(TID_SETTL_METHOD) == "C"} {
          set DISCOUNT [expr $DISCOUNT + $s(AMT_ORIGINAL)]
          set GRAND_DISCOUNT [expr $GRAND_DISCOUNT + $s(AMT_ORIGINAL)]
        } else {
          set DISCOUNT [expr $DISCOUNT - $s(AMT_ORIGINAL)]
          set GRAND_DISCOUNT [expr $GRAND_DISCOUNT - $s(AMT_ORIGINAL)]
        }
      }
  }
  }
  if {$NETDEPOSIT != 0} {
    puts $cur_file "$ISO,$t(ENTITY_ID),$NAME,[format "%0.2f" $SETTLED_BC],[format "%0.2f" $SETTLED_NONBC],[format "%0.2f" $CHARGEBACK_AMOUNT],[format "%0.2f" $REJECTS],[format "%0.2f" $REFUNDS],[format "%0.2f" $MISC_ADJUSTMENTS],[format "%0.2f" $ACH_RESUB],[format "%0.2f" $RESERVES],[format "%0.2f" $DISCOUNT],[format "%0.2f" $NETDEPOSIT]\r"
  }
}
 puts $cur_file ",,,[format "%0.2f" $GRAND_SETTLED_BC],[format "%0.2f" $GRAND_SETTLED_NONBC],[format "%0.2f" $GRAND_CHARGEBACK_AMOUNT],[format "%0.2f" $GRAND_REJECTS],[format "%0.2f" $GRAND_REFUNDS],[format "%0.2f" $GRAND_MISC_ADJUSTMENTS],[format "%0.2f" $GRAND_ACH_RESUB],[format "%0.2f" $GRAND_RESERVES],[format "%0.2f" $GRAND_DISCOUNT],[format "%0.2f" $GRAND_NETDEPOSIT]\r"
  close $cur_file
  exec uuencode $cur_file_name $file_name | mailx -r teipord@jetpay.com -s $file_name accounting@jetpay.com clearing@jetpay.com

oraclose $fetch_cursor
