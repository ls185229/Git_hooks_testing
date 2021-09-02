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
  exec echo "daily detail failed to run" | mailx -r $mailfromlist -s "daily detail" $mailtolist
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
set filedate [clock format [clock scan "-0 day"] -format %Y%m%d]
set tomorrow [clock format [clock scan "+1 day"] -format %d-%b-%y]
set yesterday [clock format [clock scan "-1 day"] -format %d-%b-%y]
set report_ddate [clock format [clock scan "-0 day"] -format %m/%d/%y]
set report_mdate [clock format [clock scan "-0 day"] -format %m/%y]
set report_mddate [clock format [clock scan "-0 day"] -format %m/%d]
set report_yesterday_mddate [clock format [clock scan "-1 day"] -format %m/%d]
set name_date_month [clock format [clock scan "-0 day"] -format %B]
set name_date_year [clock format [clock scan "-0 day"] -format %Y]
set name_date "$name_date_month $name_date_year"
set fdate [string toupper $fdate]
set date [string toupper $date]
set offdate "01-$fdate"
set ondate "01-$date"


set query_string "select unique entity_id from mas_trans_log where DATE_TO_SETTLE like '%$fdate' and institution_id = '101'"
#puts $query_string
orasql $test_cursor1 $query_string
set collist1 [oracols $test_cursor1]
set cur_local_time [clock seconds]
set CUR_SET_TIME $cur_local_time
set CUR_JULIAN_DATEX [string range [clock format $CUR_SET_TIME -format "%y%j"] 1 4]
set cur_file_name "./UPLOAD/101.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.001.csv"
set file_name "101.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.001.csv"
set cur_file [open "$cur_file_name" w]
puts $cur_file "DAILY DETAIL REPORT"
puts $cur_file "TRN,---, FOR: $report_ddate,---,---,---, FOR PERIOD TO DATE :$report_mdate,---,---"
puts $cur_file "CD,COUNT, AMOUNT,FEES,ACCOUNT EFFECT,COUNT, AMOUNT,FEES,ACCOUNT EFFECT\r\n"
set DISCOUNT 0
set GRAND_DISCOUNT 0
set GRAND_DISCOUNT_M_COUNT 0
set GRAND_DISCOUNT_V_COUNT 0
set GRAND_DISCOUNT_M 0
set GRAND_DISCOUNT_V 0
set DISCOUNT 0
set DISCOUNT_M_COUNT 0
set DISCOUNT_V_COUNT 0
set DISCOUNT_M 0
set DISCOUNT_V 0
set VISA_COUNT 0
set VISA_AMOUNT 0
set VISA_FEE 0
set MC_COUNT 0
set MC_AMOUNT 0
set MC_FEE 0
set AMEX_COUNT 0
set AMEX_AMOUNT 0
set AMEX_FEE 0
set DISC_COUNT 0
set DISC_AMOUNT 0
set DISC_FEE 0
set TE_COUNT 0
set TE_AMOUNT 0
set JCB_COUNT 0
set JCB_AMOUNT 0
set JCB_FEE 0
set DBT_COUNT 0
set DBT_AMOUNT 0
set EBT_COUNT 0
set EBT_AMOUNT 0
set OTHER_COUNT 0
set OTHER_FEE 0
set CHR_COUNT 0
set CHR_AMOUNT 0
set CHR_FEE 0
set MCHR_COUNT 0
set MCHR_AMOUNT 0
set MCHR_FEE 0
set REP_COUNT 0
set REP_AMOUNT 0
set REP_FEE 0
set MREP_COUNT 0
set MREP_AMOUNT 0
set MREP_FEE 0
set MOTHER_COUNT 0
set MOTHER_FEE 0
set MVISA_COUNT 0
set MVISA_AMOUNT 0
#puts "MVISA_AMOUNT $MVISA_AMOUNT"
set MVISA_FEE 0
set MMC_COUNT 0
set MMC_AMOUNT 0
set MMC_FEE 0
set MAMEX_COUNT 0
set MAMEX_AMOUNT 0
set MAMEX_FEE 0
set MDISC_COUNT 0
set MDISC_AMOUNT 0
set MDISC_FEE 0
set MTE_COUNT 0
set MTE_AMOUNT 0
set MJCB_COUNT 0
set MJCB_AMOUNT 0
set MJCB_FEE 0
set MDBT_COUNT 0
set MDBT_AMOUNT 0
set MEBT_COUNT 0
set MEBT_AMOUNT 0
set MISC_ADJUSTMENTS 0
set GRAND_MISC_ADJUSTMENTS 0
set RESERVE 0




while {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  #puts $t(ENTITY_ID)
  set query_string "select * from mas_trans_log where PRICED_DATE_TIME like '$date'  and ENTITY_ID = '$t(ENTITY_ID)' and institution_id = '101' and settl_flag = 'Y'"
  orasql $fetch_cursor $query_string
   while {[orafetch $fetch_cursor -dataarray s -indexbyname] != 1403} {
      switch -- $s(TID) {
        010003015101 {
                       if {$s(TID_SETTL_METHOD) == "C"} {
        #                 set CHR_AMOUNT [expr $CHR_AMOUNT + $s(AMT_ORIGINAL)]
        #                 set CHR_COUNT [expr $CHR_COUNT + 1]
                       } else {
        #                 set CHR_AMOUNT [expr $CHR_AMOUNT - $s(AMT_ORIGINAL)]
        #                 set CHR_COUNT [expr $CHR_COUNT + 1]
                       }
                     }
        010003005301 {
                       if {$s(TID_SETTL_METHOD) == "C"} {
                         set REP_AMOUNT [expr $REP_AMOUNT + $s(AMT_ORIGINAL)]
                         set REP_COUNT [expr $REP_COUNT + 1]
                       } else {
                         set REP_AMOUNT [expr $REP_AMOUNT - $s(AMT_ORIGINAL)]
                         set REP_COUNT [expr $REP_COUNT + 1]
                       }
                     }
         010003005401 {
                       if {$s(TID_SETTL_METHOD) == "C"} {
                         set REP_AMOUNT [expr $REP_AMOUNT + $s(AMT_ORIGINAL)]
                         set REP_COUNT [expr $REP_COUNT + 1]
                       } else {
                         set REP_AMOUNT [expr $REP_AMOUNT - $s(AMT_ORIGINAL)]
                         set REP_COUNT [expr $REP_COUNT + 1]
                       }
                     }


      }
   }
#(DATE_TO_SETTLE = '23-MAY-07' or activity_date_time = '23-MAY-07') and date_to_settle <> '31-MAY-07' 
 #set query_string "select * from mas_trans_log where (DATE_TO_SETTLE like '$date' or (ACTIVITY_DATE_TIME like '$date' and ENTITY_ID = '$t(ENTITY_ID)' and institution_id = '101' and settl_flag = 'Y'"
 set query_string "select * from mas_trans_log where DATE_TO_SETTLE like '$date' and ENTITY_ID = '$t(ENTITY_ID)' and institution_id = '101' and settl_flag = 'Y'"
  orasql $fetch_cursor $query_string
  while {[orafetch $fetch_cursor -dataarray s -indexbyname] != 1403} {
      switch -- $s(TID) {
        010003015101 {
                       if {$s(TID_SETTL_METHOD) == "C"} {
                         set CHR_AMOUNT [expr $CHR_AMOUNT + $s(AMT_ORIGINAL)]
                         set CHR_COUNT [expr $CHR_COUNT + 1]
                       } else {
                         set CHR_AMOUNT [expr $CHR_AMOUNT - $s(AMT_ORIGINAL)]
                         set CHR_COUNT [expr $CHR_COUNT + 1] 
                       }
                     }
        010003005301 {
                       if {$s(TID_SETTL_METHOD) == "C"} {
                         set REP_AMOUNT [expr $REP_AMOUNT + $s(AMT_ORIGINAL)]
                         set REP_COUNT [expr $REP_COUNT + 1]
                       } else {
                         set REP_AMOUNT [expr $REP_AMOUNT - $s(AMT_ORIGINAL)]
                         set REP_COUNT [expr $REP_COUNT + 1]
                       }
                     }
        010004160000 {
                       if {$s(TID_SETTL_METHOD) == "C"} {
                         set CHR_FEE [expr $CHR_FEE + $s(AMT_ORIGINAL)]
                       } else {
                         set CHR_FEE [expr $CHR_FEE - $s(AMT_ORIGINAL)]
                       }
                     }
        010003005102 {
                      switch -exact -- $s(CARD_SCHEME) {
                                  04 {
          				set VISA_COUNT [expr $VISA_COUNT + 1]
                                        set VISA_AMOUNT [expr $VISA_AMOUNT - $s(AMT_ORIGINAL)]
                                     }
                                  05 {
                                        set MC_COUNT [expr $MC_COUNT + 1]
                                        set MC_AMOUNT [expr $MC_AMOUNT - $s(AMT_ORIGINAL)]
                                     }
                                  03 {
                                        set AMEX_COUNT [expr $AMEX_COUNT + 1]
                                        set AMEX_AMOUNT [expr $AMEX_AMOUNT - $s(AMT_ORIGINAL)]
                                     }
                                  08 {
                                        set DISC_COUNT [expr $DISC_COUNT + 1]
                                        set DISC_AMOUNT [expr $DISC_AMOUNT - $s(AMT_ORIGINAL)]
                                     }
                                  09 {
                                        set JCB_COUNT [expr $JCB_COUNT + 1]
                                        set JCB_AMOUNT [expr $JCB_AMOUNT - $s(AMT_ORIGINAL)]
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
                                  03 {
                                        set AMEX_COUNT [expr $AMEX_COUNT + 1]
                                        set AMEX_AMOUNT [expr $AMEX_AMOUNT + $s(AMT_ORIGINAL)]
                                     }
                                  08 {
                                        set DISC_COUNT [expr $DISC_COUNT + 1]
                                        set DISC_AMOUNT [expr $DISC_AMOUNT + $s(AMT_ORIGINAL)]
                                     }
                                  09 {
                                        set JCB_COUNT [expr $JCB_COUNT + 1]
                                        set JCB_AMOUNT [expr $JCB_AMOUNT - $s(AMT_ORIGINAL)]
                                     }
						       }
                     }
                        }
      if {[string range $s(TID) 0 5] == 010004} {
        switch -exact -- $s(CARD_SCHEME) {
            04 {
               #set VISA_COUNT [expr $VISA_COUNT + 1]
               if {$s(TID_SETTL_METHOD) == "C"} {
                 set VISA_FEE [expr $VISA_FEE + $s(AMT_ORIGINAL)]
               } else {
                 set VISA_FEE [expr $VISA_FEE - $s(AMT_ORIGINAL)]
               }
               }
            05 {
               #set MC_COUNT [expr $MC_COUNT + 1]
               if {$s(TID_SETTL_METHOD) == "C"} {
                 set MC_FEE [expr $MC_FEE + $s(AMT_ORIGINAL)]
               } else {
                 set MC_FEE [expr $MC_FEE - $s(AMT_ORIGINAL)]
               }
               }
            default {
              #set OTHER_COUNT [expr $OTHER_COUNT + 1]
               if {$s(TID_SETTL_METHOD) == "C"} {
                 set OTHER_FEE [expr $OTHER_FEE + $s(AMT_ORIGINAL)]
               } else {
                 set OTHER_FEE [expr $OTHER_FEE - $s(AMT_ORIGINAL)]
               }
               }
            }

        if {$s(TID_SETTL_METHOD) == "C"} {
          set MISC_ADJUSTMENTS [expr $MISC_ADJUSTMENTS + $s(AMT_ORIGINAL)]
          set GRAND_MISC_ADJUSTMENTS [expr $GRAND_MISC_ADJUSTMENTS + $s(AMT_ORIGINAL)]
        } else {
          set MISC_ADJUSTMENTS [expr $MISC_ADJUSTMENTS - $s(AMT_ORIGINAL)]
          set GRAND_MISC_ADJUSTMENTS [expr $GRAND_MISC_ADJUSTMENTS - $s(AMT_ORIGINAL)]
        }
      }
      if {$s(TID) == "010005070000" } {
        if {$s(TID_SETTL_METHOD) == "C"} {
          set OTHER_FEE [expr $OTHER_FEE + $s(AMT_ORIGINAL)]
        } else {
          set OTHER_FEE [expr $OTHER_FEE - $s(AMT_ORIGINAL)]
        }
      }
  }


  #puts $t(ENTITY_ID)
  set query_string "select * from mas_trans_log where DATE_TO_SETTLE < '$tomorrow' and DATE_TO_SETTLE >= '01-$fdate' and ENTITY_ID = '$t(ENTITY_ID)' and institution_id = '101'  and settl_flag = 'Y'"
  #puts $query_string
  orasql $fetch_cursor $query_string
  while {[orafetch $fetch_cursor -dataarray s -indexbyname] != 1403} {
      switch -- $s(TID) {
        010003015101 {
                       if {$s(TID_SETTL_METHOD) == "C"} {
                         set MCHR_AMOUNT [expr $MCHR_AMOUNT + $s(AMT_ORIGINAL)]
                         set MCHR_COUNT [expr $MCHR_COUNT + 1]
                       } else {
                         set MCHR_AMOUNT [expr $MCHR_AMOUNT - $s(AMT_ORIGINAL)]
                         set MCHR_COUNT [expr $MCHR_COUNT + 1]
                       }
                     }
        010003005301 {
                       if {$s(TID_SETTL_METHOD) == "C"} {
                         set MREP_AMOUNT [expr $MREP_AMOUNT + $s(AMT_ORIGINAL)]
                         set MREP_COUNT [expr $MREP_COUNT + 1]
                       } else {
                         set MREP_AMOUNT [expr $MREP_AMOUNT - $s(AMT_ORIGINAL)]
                         set MREP_COUNT [expr $MREP_COUNT + 1]
                       }
                     }
        010004160000 {
                       if {$s(TID_SETTL_METHOD) == "C"} {
                         set MCHR_FEE [expr $MCHR_FEE + $s(AMT_ORIGINAL)]
                       } else {
                         set MCHR_FEE [expr $MCHR_FEE - $s(AMT_ORIGINAL)]
                       }
                     }

        010003005102 {
                      switch -exact -- $s(CARD_SCHEME) {
                                  04 {
                                        set MVISA_COUNT [expr $MVISA_COUNT + 1]
                                        set MVISA_AMOUNT [expr $MVISA_AMOUNT - $s(AMT_ORIGINAL)]
                                     }
                                  05 {
                                        set MMC_COUNT [expr $MMC_COUNT + 1]
                                        set MMC_AMOUNT [expr $MMC_AMOUNT - $s(AMT_ORIGINAL)]
                                     }
                                  03 {
                                        set MAMEX_COUNT [expr $MAMEX_COUNT + 1]
                                        set MAMEX_AMOUNT [expr $MAMEX_AMOUNT - $s(AMT_ORIGINAL)]
                                     }
                                  08 {
                                        set MDISC_COUNT [expr $MDISC_COUNT + 1]
                                        set MDISC_AMOUNT [expr $MDISC_AMOUNT - $s(AMT_ORIGINAL)]
                                     }
                                  09 {
                                        set MJCB_COUNT [expr $MJCB_COUNT + 1]
                                        set MJCB_AMOUNT [expr $MJCB_AMOUNT - $s(AMT_ORIGINAL)]
                                     }

                                                       }

                     }
        010003005101 {
                      switch -exact -- $s(CARD_SCHEME) {
                                  04 {
                                        set MVISA_COUNT [expr $MVISA_COUNT + 1]
                                        set MVISA_AMOUNT [expr $MVISA_AMOUNT + $s(AMT_ORIGINAL)]
                                     }
                                  05 {
                                        set MMC_COUNT [expr $MMC_COUNT + 1]
                                        set MMC_AMOUNT [expr $MMC_AMOUNT + $s(AMT_ORIGINAL)]
                                     }
                                  03 {
                                        set MAMEX_COUNT [expr $MAMEX_COUNT + 1]
                                        set MAMEX_AMOUNT [expr $MAMEX_AMOUNT + $s(AMT_ORIGINAL)]
                                     }
                                  08 {
                                        set MDISC_COUNT [expr $MDISC_COUNT + 1]
                                        set MDISC_AMOUNT [expr $MDISC_AMOUNT + $s(AMT_ORIGINAL)]
                                     }
                                  09 {
                                        set MJCB_COUNT [expr $MJCB_COUNT + 1]
                                        set MJCB_AMOUNT [expr $MJCB_AMOUNT - $s(AMT_ORIGINAL)]
                                     }


                                                       }
                     }
      }
      if {[string range $s(TID) 0 5] == 010004} {
        #puts "$s(TID) $s(ENTITY_ID)"
        switch -exact -- $s(CARD_SCHEME) {
            04 {
               #set MVISA_COUNT [expr $MVISA_COUNT + 1]
               if {$s(TID_SETTL_METHOD) == "C"} {
                 set MVISA_FEE [expr $MVISA_FEE + $s(AMT_ORIGINAL)]
               } else {
                 set MVISA_FEE [expr $MVISA_FEE - $s(AMT_ORIGINAL)]
               }
               }
            05 {
               #set MMC_COUNT [expr $MMC_COUNT + 1]
               if {$s(TID_SETTL_METHOD) == "C"} {
                 set MMC_FEE [expr $MMC_FEE + $s(AMT_ORIGINAL)]
               } else {
                 set MMC_FEE [expr $MMC_FEE - $s(AMT_ORIGINAL)]
               }
               }
            default {
              #set MOTHER_COUNT [expr $MOTHER_COUNT + 1]
               if {$s(TID_SETTL_METHOD) == "C"} {
                 set MOTHER_FEE [expr $MOTHER_FEE + $s(AMT_ORIGINAL)]
               } else {
                 set MOTHER_FEE [expr $MOTHER_FEE - $s(AMT_ORIGINAL)]
               }
               }
            }
      }
      if {$s(TID) == "010005070000" } {
        if {$s(TID_SETTL_METHOD) == "C"} {
          set MOTHER_FEE [expr $MOTHER_FEE + $s(AMT_ORIGINAL)]
        } else {
          set MOTHER_FEE [expr $MOTHER_FEE - $s(AMT_ORIGINAL)]
        }
      }

  }
}
set query_string "select * from ACCT_ACCUM_DET where PAYMENT_PROC_DT like '%$date' and institution_id = '101'"
orasql $test_cursor1 $query_string
set collist1 [oracols $test_cursor1]
set ACH_AMOUNT 0
set ACH_COUNT 0
set MACH_AMOUNT 0
set MACH_COUNT 0

while {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set ACH_AMOUNT [expr $ACH_AMOUNT - $t(AMT_PAY) + $t(AMT_FEE)]
  set ACH_COUNT [expr $ACH_COUNT + 1]
}

set query_string "select * from ACCT_ACCUM_DET where PAYMENT_PROC_DT like '%$fdate' and PAYMENT_PROC_DT <= '$tomorrow' and institution_id = '101'"
orasql $test_cursor1 $query_string
set collist1 [oracols $test_cursor1]

while {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
  set MACH_AMOUNT [expr $MACH_AMOUNT - $t(AMT_PAY) + $t(AMT_FEE)]
  set MACH_COUNT [expr $MACH_COUNT + 1]
}
  set TODAY_RESERVE 0
  set query_string "select sum(amt_original) as total from mas_trans_log where date_to_settle like '$date' and tid like '01000705%' and institution_id = '101'"
  orasql $fetch_cursor $query_string
  while {[orafetch $fetch_cursor -dataarray s -indexbyname] != 1403} {
    set TODAY_RESERVE $s(TOTAL)
  }


  set query_string "select sum(amt_original) as total from mas_trans_log where tid like '01000705%' and institution_id = '101' and activity_date_time < '$tomorrow'"
  orasql $fetch_cursor $query_string
  while {[orafetch $fetch_cursor -dataarray s -indexbyname] != 1403} {
    set TOTAL_RESERVE $s(TOTAL)
  }
  set query_string "select sum(amt_original) as total from mas_trans_log where date_to_settle < '$date' and activity_date_time < '$tomorrow' and tid like '01000705%' and institution_id = '101'"
  orasql $fetch_cursor $query_string
  while {[orafetch $fetch_cursor -dataarray s -indexbyname] != 1403} {
    set RESERVE $s(TOTAL)
  }


  set DISCOUNT 0
  set VDISCOUNT 0
  set MDISCOUNT 0

  set query_string "select tid_settl_method,card_scheme,sum(amt_original) as amt_original, count(1) as count from mas_trans_log where DATE_TO_SETTLE > '$yesterday' and activity_date_time < '$date' and tid = '010003005101' group by tid_settl_method,card_scheme"
  puts "PAYABLES:$query_string"
  orasql $fetch_cursor $query_string
  while {[orafetch $fetch_cursor -dataarray w -indexbyname] != 1403} {
    if {$w(TID_SETTL_METHOD) == "C"} {
      if {$w(CARD_SCHEME) == "04"} {
        set DISCOUNT_V_COUNT [expr $DISCOUNT_V_COUNT + 1]
        set DISCOUNT_V [expr $DISCOUNT_V + $w(AMT_ORIGINAL)]
      } else {
        set DISCOUNT_M_COUNT [expr $DISCOUNT_M_COUNT + 1]
        set DISCOUNT_M [expr $DISCOUNT_M + $w(AMT_ORIGINAL)]
      }
      set DISCOUNT [expr $DISCOUNT + $w(AMT_ORIGINAL)]
    } else {
      if {$w(CARD_SCHEME) == "04"} {
        set DISCOUNT_V_COUNT [expr $DISCOUNT_V_COUNT + 1]
        set DISCOUNT_V [expr $DISCOUNT_V - $w(AMT_ORIGINAL)]
      } else {
        set DISCOUNT_M_COUNT [expr $DISCOUNT_M_COUNT + 1]
        set DISCOUNT_M [expr $DISCOUNT_M - $w(AMT_ORIGINAL)]
      }
      set DISCOUNT [expr $DISCOUNT - $w(AMT_ORIGINAL)]
    }
  }
  set GRAND_DISCOUNT 0
  set query_string "select tid_settl_method,card_scheme,sum(amt_original) as amt_original, count(1) as count from mas_trans_log where DATE_TO_SETTLE > '$date'  and activity_date_time < '$tomorrow' and tid = '010003005101' group by tid_settl_method,card_scheme"
  puts $query_string
  orasql $fetch_cursor $query_string
  while {[orafetch $fetch_cursor -dataarray w -indexbyname] != 1403} {
    if {$w(TID_SETTL_METHOD) == "C"} {
      if {$w(CARD_SCHEME) == "04"} {
        set GRAND_DISCOUNT_V_COUNT [expr $GRAND_DISCOUNT_V_COUNT + 1]
        set GRAND_DISCOUNT_V [expr $GRAND_DISCOUNT_V + $w(AMT_ORIGINAL)]
      } else {
        set GRAND_DISCOUNT_M_COUNT [expr $GRAND_DISCOUNT_M_COUNT + 1]
        set GRAND_DISCOUNT_M [expr $GRAND_DISCOUNT_M + $w(AMT_ORIGINAL)]
      }
      set GRAND_DISCOUNT [expr $GRAND_DISCOUNT + $w(AMT_ORIGINAL)]
    } else {
      if {$w(CARD_SCHEME) == "04"} {
        set GRAND_DISCOUNT_V_COUNT [expr $GRAND_DISCOUNT_V_COUNT + 1]
        set GRAND_DISCOUNT_V [expr $GRAND_DISCOUNT_V - $w(AMT_ORIGINAL)]
      } else {
        set GRAND_DISCOUNT_M_COUNT [expr $GRAND_DISCOUNT_M_COUNT + 1]
        set GRAND_DISCOUNT_M [expr $GRAND_DISCOUNT_M - $w(AMT_ORIGINAL)]
      }
      set GRAND_DISCOUNT [expr $GRAND_DISCOUNT - $w(AMT_ORIGINAL)]
    }
  }
  set GRAND_DISCOUNT [expr $GRAND_DISCOUNT * -1]
  set DISCOUNT [expr $DISCOUNT * -1]

  set INCOMING_REJECT 0
  set REJECT_COUNT 0
  set query_string "select * from ep_event_log where EMS_ITEM_TYPE = 'CR1' and EVENT_STATUS = 'NEW' and EVENT_LOG_DATE = '$date'"
  puts "REJECTS:$query_string"
  orasql $fetch_cursor $query_string
  while {[orafetch $fetch_cursor -dataarray w -indexbyname] != 1403} {
    set REJECT_COUNT [expr $REJECT_COUNT + 1]
    set INCOMING_REJECT [expr $INCOMING_REJECT + $w(AMT_TRANS)]
  }


  if {$INCOMING_REJECT != 0 } {
    set INCOMING_REJECT "[string range $INCOMING_REJECT 0 [expr [string length $INCOMING_REJECT] -3]].[string range $INCOMING_REJECT [expr [string length $INCOMING_REJECT] -2] [expr [string length $INCOMING_REJECT] -1]]"
  }

  set VISA_AMOUNT [expr $VISA_AMOUNT + $GRAND_DISCOUNT_V - $DISCOUNT_V]
  set MC_AMOUNT [expr $MC_AMOUNT + $GRAND_DISCOUNT_M - $DISCOUNT_M]
  set VISA_TOTAL [expr $VISA_AMOUNT + $VISA_FEE]
  set MC_TOTAL [expr $MC_AMOUNT + $MC_FEE]
  set AMEX_TOTAL [expr $AMEX_AMOUNT + $AMEX_FEE]
  set DISC_TOTAL [expr $DISC_AMOUNT + $DISC_FEE]
  set JCB_TOTAL [expr $JCB_AMOUNT + $JCB_FEE]
  #puts $MVISA_AMOUNT
  set MVISA_AMOUNT [expr $MVISA_AMOUNT + $GRAND_DISCOUNT_V - $DISCOUNT_V]
  set MMC_AMOUNT [expr $MMC_AMOUNT + $GRAND_DISCOUNT_M - $DISCOUNT_M]
  set MVISA_TOTAL $MVISA_AMOUNT
  set MMC_TOTAL $MMC_AMOUNT
  set MAMEX_TOTAL [expr $MAMEX_AMOUNT + $MAMEX_FEE]
  set MDISC_TOTAL [expr $MDISC_AMOUNT + $MDISC_FEE]
  set MJCB_TOTAL [expr $MJCB_AMOUNT + $MJCB_FEE]

  puts $cur_file "VISA,[expr $VISA_COUNT + $GRAND_DISCOUNT_V_COUNT - $DISCOUNT_V_COUNT],$$VISA_AMOUNT,$$VISA_FEE,$$VISA_TOTAL,$MVISA_COUNT,$$MVISA_AMOUNT,$$MVISA_FEE,$$MVISA_TOTAL"
  puts $cur_file "MC,[expr $MC_COUNT + $GRAND_DISCOUNT_M_COUNT - $DISCOUNT_M_COUNT],$$MC_AMOUNT,$$MC_FEE,$$MC_TOTAL,$MMC_COUNT,$$MMC_AMOUNT,$$MMC_FEE,$$MMC_TOTAL"
  puts $cur_file "AMEX,$AMEX_COUNT,$$AMEX_AMOUNT,$$AMEX_FEE,$$AMEX_TOTAL,$MAMEX_COUNT,$$MAMEX_AMOUNT,$$MAMEX_FEE,$$MAMEX_TOTAL"
  puts $cur_file "DISC,$DISC_COUNT,$$DISC_AMOUNT,$$DISC_FEE,$$DISC_TOTAL,$MDISC_COUNT,$$MDISC_AMOUNT,$$MDISC_FEE,$$MDISC_TOTAL"
  #puts $cur_file "TE,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00"
  puts $cur_file "JCB,$JCB_COUNT,$$JCB_AMOUNT,$$JCB_FEE,$$JCB_TOTAL,$MJCB_COUNT,$$MJCB_AMOUNT,$$MJCB_FEE,$$MJCB_TOTAL"
  puts $cur_file "DBT,0.00,\$0,\$0,\$0,0.00,\$0,\$0,\$0"
  puts $cur_file "EBT,0.00,\$0,\$0,\$0,0.00,\$0,\$0,\$0"
  puts $cur_file "MISC ADJ ,0.00,\$0,\$0,\$0,0.00,\$0,\$0,\$0"
  puts $cur_file "OTHER,$OTHER_COUNT, ,$$OTHER_FEE,$$OTHER_FEE,$MOTHER_COUNT, ,$$MOTHER_FEE,$$MOTHER_FEE"
  puts $cur_file "SUBTOTAL,[expr $VISA_COUNT + $MC_COUNT + $AMEX_COUNT + $DISC_COUNT + $JCB_COUNT + $GRAND_DISCOUNT_V_COUNT - $DISCOUNT_V_COUNT + $GRAND_DISCOUNT_M_COUNT - $DISCOUNT_M_COUNT],$[expr $VISA_AMOUNT + $MC_AMOUNT + $AMEX_AMOUNT + $DISC_AMOUNT + $JCB_AMOUNT],$[expr $OTHER_FEE + $VISA_FEE + $MC_FEE + $AMEX_FEE + $DISC_FEE + $JCB_FEE],$[expr $VISA_TOTAL + $MC_TOTAL + $AMEX_TOTAL + $DISC_TOTAL + $JCB_TOTAL + $OTHER_FEE],[expr $MVISA_COUNT + $MMC_COUNT + $MAMEX_COUNT + $MDISC_COUNT + $MJCB_COUNT],$[expr $MVISA_AMOUNT + $MMC_AMOUNT + $MAMEX_AMOUNT + $MDISC_AMOUNT + $MJCB_AMOUNT],$[expr $MVISA_FEE + $MOTHER_FEE + $MMC_FEE + $MAMEX_FEE + $MDISC_FEE + $MJCB_FEE],$[expr $MVISA_TOTAL + $MMC_TOTAL + $MAMEX_TOTAL + $MDISC_TOTAL + $MJCB_TOTAL + $MOTHER_FEE]"
  puts $cur_file " "
  puts $cur_file "REJECTS:"
  puts $cur_file "SUBTOTAL,$REJECT_COUNT,$$INCOMING_REJECT,0.00,$$INCOMING_REJECT,0,0.00,0.00,0.00"
  puts $cur_file " "
  puts $cur_file "MISC ADJ: "
  puts $cur_file "SUBTOTAL,0,0.00,0.00,0.00,0,0.00,0.00,0.00"
  puts $cur_file " "
  puts $cur_file "CHARGEBACKS:"
  puts $cur_file "CGB,$CHR_COUNT,$CHR_AMOUNT,$CHR_FEE,$CHR_AMOUNT,$MCHR_COUNT,$MCHR_AMOUNT,$MCHR_FEE,$MCHR_AMOUNT"
  puts $cur_file "REP,$REP_COUNT,$REP_AMOUNT,$REP_FEE,$REP_AMOUNT,$MREP_COUNT,$MREP_AMOUNT,$MREP_FEE,$MREP_AMOUNT"
  puts $cur_file "SUBTOTAL:,[expr $CHR_COUNT + $REP_COUNT],[expr $CHR_AMOUNT + $REP_AMOUNT],[expr $CHR_FEE + $REP_FEE],[expr $CHR_AMOUNT + $REP_AMOUNT],[expr $MCHR_COUNT + $MREP_COUNT],[expr $MCHR_AMOUNT + $MREP_AMOUNT],[expr $MCHR_FEE + $MREP_FEE],[expr $MCHR_AMOUNT + $MREP_AMOUNT]"
  puts $cur_file " "
  puts $cur_file "RESERVES:"
  puts $cur_file "Res Addition,,,,$-$TODAY_RESERVE"
  puts $cur_file "Res Release,,,,0"
  puts $cur_file "SUBTOTAL:,,,,$-$TODAY_RESERVE"
  puts $cur_file " "
  puts $cur_file "DEPOSITS:"
  puts $cur_file "ACH:,$ACH_COUNT, , ,$$ACH_AMOUNT,$MACH_COUNT, , ,$$MACH_AMOUNT"
  puts $cur_file "ARJ:,0, , , 0.00,0, , ,0.00"
  puts $cur_file "SUBTOTAL:,$ACH_COUNT, , ,$$ACH_AMOUNT,$MACH_COUNT, , ,$$MACH_AMOUNT"
  puts $cur_file " "
  puts $cur_file "Begining Payable Balance,$report_yesterday_mddate,,,$$DISCOUNT"
  puts $cur_file "Account Effect:,,,,$[expr $GRAND_DISCOUNT - $DISCOUNT]"
  puts $cur_file "Ending Payable Balance,$report_mddate,,,$$GRAND_DISCOUNT"
  puts $cur_file " "
  puts $cur_file "Begining Reserve Balance,$report_yesterday_mddate,,,$$RESERVE"
  puts $cur_file "Account Effect:,,,,$$TODAY_RESERVE"
  puts $cur_file "Ending Reserve Balance,$report_mddate,,,$$TOTAL_RESERVE"


  close $cur_file
  exec uuencode $cur_file_name $file_name | mailx -r teipord@jetpay.com -s $file_name clearing@jetpay.com accounting@jetpay.com
oraclose $fetch_cursor
