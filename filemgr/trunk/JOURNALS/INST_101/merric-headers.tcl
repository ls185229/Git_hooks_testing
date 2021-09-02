#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

#New version 20070330
#Code updated. Added new output columns listed below
#Chargeback Count, Chargeback Volume, Representment Count, Representment Volume, Merch Reserve Bai
#Code update by Janette at 20070330  
# 

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
set fdate [clock format [clock scan "-2 day"] -format %b-%y]
set date [clock format [clock scan "-2 day"] -format %d-%b-%y]
set filedate [clock format [clock scan "-2 day"] -format %Y%m%d]
set name_date_month [clock format [clock scan "-2 day"] -format %B]
set name_date_year [clock format [clock scan "-2 day"] -format %Y]
set name_date "$name_date_month $name_date_year"
set fdate [string toupper $fdate]
set date [string toupper $date]
set offdate "01-$fdate"


set query_string "select unique entity_id from mas_trans_log where DATE_TO_SETTLE like '%$fdate' and institution_id = '101' and ENTITY_LEVEL = '70' order by entity_id"
puts $query_string
orasql $test_cursor1 $query_string
set collist1 [oracols $test_cursor1]
set rightnow [clock format [ clock scan "-8 day" ] -format %Y%m]
set cur_local_time [clock seconds ]
set CUR_SET_TIME $cur_local_time
set CUR_JULIAN_DATEX [string range [clock format $CUR_SET_TIME -format "%y%j"] 1 4]
set cur_file_name "./101.REPORT.HEADER.$CUR_JULIAN_DATEX.$filedate.001.csv"
set file_name "101.REPORT.HEADER.$CUR_JULIAN_DATEX.$filedate.001.csv"
set cur_file [open "$cur_file_name" w]
puts $cur_file "HEADER"
puts $cur_file "Date:,$date\n"
puts $cur_file "Merchant ID, Merchant Name,YYYYMM,Visa Count, Visa Gross Amount, Visa Credit Amount, Visa Net Amount, MC Count, MC Gross Amount, MC Credit Amount, MC Net Amount, EBT Count, EBT Net Amount, Debit Gross Count, Debit Gross Amount, Debit Count, Debit Net Amount, SIC Code, ECI,Status,Start Date, Chargeback Count, Chargeback Volume, Representment Count, Representment Volume, Merch Reserve Bai\r\n"
set VISA_COUNT 0
set VISA_AMOUNT 0
set VISA_NET_AMOUNT 0
set VISA_CREDIT_AMOUNT 0
set MC_COUNT 0
set MC_AMOUNT 0
set MC_NET_AMOUNT 0
set MC_CREDIT_AMOUNT 0
set RESERVE 0

set TVISA_COUNT 0
set TVISA_AMOUNT 0
set TVISA_NET_AMOUNT 0
set TVISA_CREDIT_AMOUNT 0
set TMC_COUNT 0
set TMC_AMOUNT 0
set TMC_NET_AMOUNT 0
set TMC_CREDIT_AMOUNT 0
set TMC_CHARGEBACK_COUNT 0
set TMC_CHARGEBACK_VOLUME 0
set TMC_REPRESENT_COUNT 0
set TMC_REPRESENT_VOLUME 0
set TRESERVE 0




while {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
set VISA_COUNT 0
set VISA_AMOUNT 0
set VISA_NET_AMOUNT 0
set VISA_CREDIT_AMOUNT 0
set CHARGEBACK_COUNT 0
set CHARGEBACK_VOLUME 0
set MC_COUNT 0
set MC_AMOUNT 0
set MC_NET_AMOUNT 0
set MC_CREDIT_AMOUNT 0
set REPRESENT_VOLUME 0
set REPRESENT_COUNT 0 
set RESERVE 0



  puts $t(ENTITY_ID)

  set query_string "select entity_dba_name,default_mcc,actual_start_date,entity_status,PROCESSING_TYPE from acq_entity where entity_id = '$t(ENTITY_ID)' and institution_id = '101'"
  orasql $fetch_cursor $query_string
  while {[orafetch $fetch_cursor -dataarray s -indexbyname] != 1403} {
    set NAME $s(ENTITY_DBA_NAME)
    set CONTRACT_DATE $s(ACTUAL_START_DATE)
    set PROCESSING_TYPE $s(PROCESSING_TYPE)
    if {$s(ENTITY_STATUS) == "A"} {
      set PAY_STATUS ACTIVE
    } else {
      set PAY_STATUS INACTIVE
    }
    set SICCODE $s(DEFAULT_MCC)
  }

  set query_string "select * from entity_acct where OWNER_ENTITY_ID = '$t(ENTITY_ID)' and institution_id = '101'"
  orasql $fetch_cursor $query_string
  while {[orafetch $fetch_cursor -dataarray s -indexbyname] != 1403} {
    set acount $s(ACCT_NBR)
    set routing $s(TRANS_ROUTING_NBR)
  }

  set query_string "select * from mas_trans_log where DATE_TO_SETTLE like '%$fdate' and ENTITY_ID = '$t(ENTITY_ID)' and institution_id = '101'"
  orasql $fetch_cursor $query_string
  puts $query_string
  while {[orafetch $fetch_cursor -dataarray s -indexbyname] != 1403} {
      switch -- $s(TID) {
         010007050000 {
                       if {$s(TID_SETTL_METHOD) == "C"} {
                         set RESERVE [expr $RESERVE + $s(AMT_ORIGINAL)]
                       } else {
                         set RESERVE [expr $RESERVE - $s(AMT_ORIGINAL)]
                       }
                      }

         010003015101 {
                       if {$s(TID_SETTL_METHOD) == "C"} {
                         set CHARGEBACK_VOLUME [expr $CHARGEBACK_VOLUME + $s(AMT_ORIGINAL)]
                         set CHARGEBACK_COUNT [expr $CHARGEBACK_COUNT + 1]

                       } else {
                         set CHARGEBACK_VOLUME [expr $CHARGEBACK_VOLUME - $s(AMT_ORIGINAL)]
                         set CHARGEBACK_COUNT [expr $CHARGEBACK_COUNT + 1]
                       }
                     }
        010003005301 {
                       if {$s(TID_SETTL_METHOD) == "C"} {
                         set REPRESENT_VOLUME [expr $REPRESENT_VOLUME + $s(AMT_ORIGINAL)]
                         set REPRESENT_COUNT [expr $REPRESENT_COUNT + 1]
                       } else {
                         set REPRESENT_VOLUME [expr $REPRESENT_VOLUME - $s(AMT_ORIGINAL)]
                         set REPRESENT_COUNT [expr $REPRESENT_COUNT + 1]
                       }
                     }
        010003005102 {
                      switch -exact -- $s(CARD_SCHEME) {
                                  04 {
                                        set VISA_COUNT [expr $VISA_COUNT + 1]
                                        set VISA_CREDIT_AMOUNT [expr $VISA_CREDIT_AMOUNT - $s(AMT_ORIGINAL)]
                                        set VISA_NET_AMOUNT [expr $VISA_NET_AMOUNT - $s(AMT_ORIGINAL)]
                                     }
                                  05 {
                                        set MC_COUNT [expr $MC_COUNT + 1]
                                        set MC_CREDIT_AMOUNT [expr $MC_CREDIT_AMOUNT - $s(AMT_ORIGINAL)]
                                        set MC_NET_AMOUNT [expr $MC_NET_AMOUNT - $s(AMT_ORIGINAL)]
                                     }
                                                       }

                     }
        010003005101 {
                      switch -exact -- $s(CARD_SCHEME) {
                                  04 {
                                        set VISA_COUNT [expr $VISA_COUNT + 1]
                                        set VISA_AMOUNT [expr $VISA_AMOUNT + $s(AMT_ORIGINAL)]
                                        set VISA_NET_AMOUNT [expr $VISA_NET_AMOUNT + $s(AMT_ORIGINAL)]
                                     }
                                  05 {
                                        set MC_COUNT [expr $MC_COUNT + 1]
                                        set MC_AMOUNT [expr $MC_AMOUNT + $s(AMT_ORIGINAL)]
                                        set MC_NET_AMOUNT [expr $MC_NET_AMOUNT + $s(AMT_ORIGINAL)]
                                     }
                                                       }
                     }
        010004020000 {
                      switch -exact -- $s(CARD_SCHEME) {
                                  04 {  if { $s(TID_SETTL_METHOD) == "C"} {
                                          #set VISA_NET_AMOUNT [expr $VISA_NET_AMOUNT + $s(AMT_ORIGINAL)]
                                        } else {
                                          #set VISA_NET_AMOUNT [expr $VISA_NET_AMOUNT - $s(AMT_ORIGINAL)]
                                        }
                                     }
                                  05 {  if { $s(TID_SETTL_METHOD) == "C"} {
                                          #set MC_NET_AMOUNT [expr $MC_NET_AMOUNT + $s(AMT_ORIGINAL)]
                                        } else {
                                          #set MC_NET_AMOUNT [expr $MC_NET_AMOUNT - $s(AMT_ORIGINAL)]
                                        }
                                     }
                                                       }

                     }
        010003005401 {
                      switch -exact -- $s(CARD_SCHEME) {
                                  04 {  if { $s(TID_SETTL_METHOD) == "C"} {
                                          set VISA_CREDIT_AMOUNT [expr $VISA_CREDIT_AMOUNT - $s(AMT_ORIGINAL)]
                                          set VISA_NET_AMOUNT [expr $VISA_NET_AMOUNT - $s(AMT_ORIGINAL)]
                                        } else {
                                          set VISA_CREDIT_AMOUNT [expr $VISA_CREDIT_AMOUNT + $s(AMT_ORIGINAL)]
                                          set VISA_NET_AMOUNT [expr $VISA_NET_AMOUNT + $s(AMT_ORIGINAL)]
                                        }
                                     }
                                  05 {  if { $s(TID_SETTL_METHOD) == "C"} {
                                          set MC_CREDIT_AMOUNT [expr $MC_CREDIT_AMOUNT - $s(AMT_ORIGINAL)]
                                          set MC_NET_AMOUNT [expr $MC_NET_AMOUNT - $s(AMT_ORIGINAL)]
                                        } else {
                                          set MC_CREDIT_AMOUNT [expr $MC_CREDIT_AMOUNT + $s(AMT_ORIGINAL)]
                                          set MC_NET_AMOUNT [expr $MC_NET_AMOUNT + $s(AMT_ORIGINAL)]
                                        }
                                     }
                                                       }

                     }
        010004020005 {
                      switch -exact -- $s(CARD_SCHEME) {
                                  04 {
                                        if { $s(TID_SETTL_METHOD) == "C"} {
                                          #set VISA_NET_AMOUNT [expr $VISA_NET_AMOUNT + $s(AMT_ORIGINAL)]
                                        } else {
                                          #set VISA_NET_AMOUNT [expr $VISA_NET_AMOUNT - $s(AMT_ORIGINAL)]
                                        }
                                     }
                                  05 {
                                        if { $s(TID_SETTL_METHOD) == "C"} {
                                          #set MC_NET_AMOUNT [expr $MC_NET_AMOUNT + $s(AMT_ORIGINAL)]
                                        } else {
                                          #set MC_NET_AMOUNT [expr $MC_NET_AMOUNT - $s(AMT_ORIGINAL)]
                                        }
                                     }
                                                       }
                     }
    }
  }
  puts $MC_NET_AMOUNT
  if {$VISA_COUNT != 0 || $MC_COUNT != 0} {
                                                                                                                                                                                    
    puts $cur_file " $t(ENTITY_ID),$NAME,$rightnow ,$VISA_COUNT,$VISA_AMOUNT,$VISA_CREDIT_AMOUNT,$VISA_NET_AMOUNT,$MC_COUNT,$MC_AMOUNT,$MC_CREDIT_AMOUNT,$MC_NET_AMOUNT, , , , , , ,$SICCODE,$PROCESSING_TYPE,$PAY_STATUS, $CONTRACT_DATE, $CHARGEBACK_COUNT, $CHARGEBACK_VOLUME, $REPRESENT_COUNT, $REPRESENT_VOLUME,$RESERVE ,\r"
  }
  set TVISA_COUNT [expr $TVISA_COUNT + $VISA_COUNT]
  set TVISA_AMOUNT [expr $TVISA_AMOUNT + $VISA_AMOUNT]
  set TVISA_NET_AMOUNT [expr $TVISA_NET_AMOUNT + $VISA_NET_AMOUNT]
  set TVISA_CREDIT_AMOUNT [expr $TVISA_CREDIT_AMOUNT + $VISA_CREDIT_AMOUNT]
  set TMC_COUNT [expr $TMC_COUNT + $MC_COUNT]
  set TMC_AMOUNT [expr $TMC_AMOUNT + $MC_AMOUNT]
  set TMC_NET_AMOUNT [expr $TMC_NET_AMOUNT + $MC_NET_AMOUNT]
  set TMC_CREDIT_AMOUNT [expr $TMC_CREDIT_AMOUNT + $MC_CREDIT_AMOUNT]
  set TMC_CHARGEBACK_COUNT [expr $TMC_CHARGEBACK_COUNT + $CHARGEBACK_COUNT]
  set TMC_CHARGEBACK_VOLUME [expr $TMC_CHARGEBACK_VOLUME + $CHARGEBACK_VOLUME]
  set TMC_REPRESENT_COUNT [expr $TMC_REPRESENT_COUNT + $REPRESENT_COUNT]
  set TMC_REPRESENT_VOLUME [expr $TMC_REPRESENT_VOLUME + $REPRESENT_VOLUME]
  set TRESERVE [expr $TRESERVE + $RESERVE]


}
             
#  puts $cur_file ",,,$TVISA_COUNT,$TVISA_AMOUNT,$TVISA_CREDIT_AMOUNT,$TVISA_NET_AMOUNT,$TMC_COUNT,$TMC_AMOUNT,$TMC_CREDIT_AMOUNT,$TMC_NET_AMOUNT,,,,,,,,,$TMC_CHARGEBACK_COUNT,$TMC_CHARGEBACK_VOLUME,$TMC_REPRESENT_COUNT,$TMC_REPRESENT_VOLUME,,\r"
  puts $cur_file ",,,$TVISA_COUNT,$TVISA_AMOUNT,$TVISA_CREDIT_AMOUNT,$TVISA_NET_AMOUNT,$TMC_COUNT,$TMC_AMOUNT,$TMC_CREDIT_AMOUNT,$TMC_NET_AMOUNT,,,,,,,,,,,$TMC_CHARGEBACK_COUNT,$TMC_CHARGEBACK_VOLUME,$TMC_REPRESENT_COUNT,$TMC_REPRESENT_VOLUME,$TRESERVE,\r" 
 
  close $cur_file
  exec uuencode $cur_file_name $file_name | mailx -r teipord@jetpay.com -s $file_name clearing@jetpay.com

oraclose $fetch_cursor

