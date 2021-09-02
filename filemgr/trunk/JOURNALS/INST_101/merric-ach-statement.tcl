#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

##################################################################################
# Version 0.01 Sunny Yang 12-12-2007
# Modified script to reflect all payments associate with each merchant
# Adjusted net deposit to match with payment amount, need further instruction
# on purpose of net deposit.

# Version 0.00 Myke Sanders

#################################################################################

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
if {[catch {set handler [oralogon masclr/masclr@trnclr4]} result]} {
  exec echo "merchant statement failed to run" | mailx -r $mailfromlist -s "Merchant statement" $mailtolist
  exit
}

set cursor [oraopen $handler]
set failed 0
set fetch_cursor        [oraopen $handler]
set fetch_cursor1       [oraopen $handler]
set ach_cursor          [oraopen $handler]
set test_cursor1        [oraopen $handler]
set test_cursor2        [oraopen $handler]
set settle_cursor       [oraopen $handler]
set update_cursor       [oraopen $handler]
set fdate               [string toupper [clock format [clock scan "-0 day"] -format %b-%y]]
set date                [string toupper [clock format [clock scan "-0 day"] -format %d-%b-%y]]
set filedate            [clock format [clock scan "-0 day"] -format %Y%m%d]
set name_date_month     [clock format [clock scan "-0 day"] -format %B]
set name_date_year      [clock format [clock scan "-0 day"] -format %Y]
set name_date           "$name_date_month $name_date_year"
## set fdate [string toupper $fdate]
## set date [string toupper $date]

set offdate             "01-$fdate"
set ondate              "01-$date"

# set test on 11/14

#set fdate NOV-07
#set date  14-NOV-07
#set filedate 20071114
#set name_date_month November
#set name_date_year 2007
#set name_date "$name_date_month $name_date_year"

puts "(DATE_TO_SETTLE like '%$fdate' or DATE_TO_SETTLE = '$ondate') and DATE_TO_SETTLE != '$offdate'"

#############################
## commented out by SYANG-----12-10-2007
##########################################################################################################
#      set query_string "select unique PAYMENT_SEQ_NBR,entity_id, POSTING_ENTITY_ID
#                        from mas_trans_log
#                        where institution_id = '101'
#                          and PAYMENT_SEQ_NBR in (select PAYMENT_SEQ_NBR
#                                                  from ACCT_ACCUM_DET
#                                                  where PAYMENT_PROC_DT like '%$date%'
#                                                    and institution_id = '101'
#                                                    and entity_acct_id not in (select entity_acct_id
#                                                                               from entity_acct
#                                                                               where institution_id = '101'
#                                                                                 and stop_pay_flag = 'Y'))
#                        order by entity_id"
############################################################################################################

### SYANG ---12-12-2007
     set query_string " select unique entity_id, PAYMENT_SEQ_NBR,
                               sum(case when(tid_settl_method = 'C' ) then amt_original else 0 end) as SETTLED_C_BC,
                               sum(case when(tid_settl_method = 'D' ) then amt_original else 0 end) as SETTLED_D_BC
                        from mas_trans_log
                        where institution_id = '101'
                            and SETTL_FLAG = 'Y'
                            and PAYMENT_SEQ_NBR in (select PAYMENT_SEQ_NBR
                                                    from ACCT_ACCUM_DET
                                                    where PAYMENT_PROC_DT like '%$date%'
                                                     and institution_id = '101'
                                                      and entity_acct_id not in (select entity_acct_id
                                                                                 from entity_acct
                                                                                  where institution_id = '101'
                                                                                  and stop_pay_flag = 'Y')) 
                        group by entity_id, payment_seq_nbr    
                        order by entity_id"

      #puts $query_string
      orasql $test_cursor1 $query_string
      set collist1 [oracols $test_cursor1]
      set rightnow         [clock format [ clock scan "-0 day" ] -format %Y%m%d]
      set cur_local_time   [clock seconds ]
      set CUR_SET_TIME     $cur_local_time
      set CUR_JULIAN_DATEX [string range [clock format $CUR_SET_TIME -format "%y%j"] 1 4]
      set cur_file_name    "./UPLOAD/101.REPORT.ACH.$CUR_JULIAN_DATEX.$filedate.001.csv"
      #set cur_file_name    "../../../../../clearing/filemgr/JOURNALS/INST_101/UPLOAD/101.REPORT.ACH.$CUR_JULIAN_DATEX.$filedate.001.csv"
      #set cur_file_name    "./LOGS/101.REPORT.ACH.$CUR_JULIAN_DATEX.$filedate.001.csv"
      set file_name        "101.REPORT.ACH.$CUR_JULIAN_DATEX.$filedate.001.csv"
      set cur_file         [open "$cur_file_name" w]
      
      puts $cur_file "ACH REPORT"
      puts $cur_file "Date:,$date\n"
      puts $cur_file "ISO#,Merchant ID, Merchant Name,Settle Bankcards, Settle NonBankcards,Chargeback Amount, Representment, Refunds,Misc Adj., ACH Resub., Reserves, Fees, Net Deposit\r\n"
      
      set GRAND_SETTLED_BC 0
      set GRAND_SETTLED_NONBC 0
      set GRAND_CHARGEBACK_AMOUNT 0
      set GRAND_REPRESENTMENT_AMOUNT 0
      set GRAND_REFUNDS 0
      set GRAND_MISC_ADJUSTMENTS 0
      set GRAND_ACH_RESUB 0
      set GRAND_RESERVES 0
      set GRAND_DISCOUNT 0
      set GRAND_NETDEPOSIT 0


      while {[orafetch $test_cursor1 -dataarray t -indexbyname] != 1403} {
        set SETTLED_BC 0
        set SETTLED_NONBC 0
        set CHARGEBACK_AMOUNT 0
        set REPRESENTMENT_AMOUNT 0
        set REFUNDS 0
        set MISC_ADJUSTMENTS 0
        set ACH_RESUB 0
        set RESERVES 0
        set DISCOUNT 0
        set NETDEPOSIT 0
        #puts $t(PAYMENT_SEQ_NBR)
        #set t(ENTITY_ID) $t(POSTING_ENTITY_ID)
        set t(ENTITY_ID) $t(ENTITY_ID)
        
        #set SETTLED_BC [expr $t(SETTLED_C_BC) - $t(SETTLED_D_BC)]
      
        set SETTLED_BC $t(SETTLED_C_BC)
       # puts "SETTLE_BC is.... $SETTLED_BC "
        
        set NETDEPOSIT [expr $t(SETTLED_C_BC) - $t(SETTLED_D_BC)]
#####################
## Commented out by SYANG 12-10-2007
       # set query_string "select unique POSTING_ENTITY_ID
       #                   from mas_trans_log
       #                   where PAYMENT_SEQ_NBR = '$t(PAYMENT_SEQ_NBR)'
       #                     and institution_id = '101'"
       # orasql $test_cursor2 $query_string
       # # while {[orafetch $test_cursor2 -dataarray a -indexbyname] != 1403} {
              #set t(ENTITY_ID) $a(POSTING_ENTITY_ID)
              #puts $t(POSTING_ENTITY_ID)
#####################      
              set query_string4 "select parent_entity_id,entity_dba_name,actual_start_date
                                from acq_entity
                                where entity_id = '$t(ENTITY_ID)'
                                  and institution_id = '101'"
              #puts $query_string4
              orasql $fetch_cursor1 $query_string4
              while {[orafetch $fetch_cursor1 -dataarray s1 -indexbyname] != 1403} {
                set ISO $s1(PARENT_ENTITY_ID)
                set NAME $s1(ENTITY_DBA_NAME)
                set CONTRACT_DATE $s1(ACTUAL_START_DATE)
              }
###########################
## commented out by SYANG

#              set query_string "select *
#                                from entity_acct
#                                where OWNER_ENTITY_ID = '$t(ENTITY_ID)'
#                                  and institution_id = '101'"
#              orasql $fetch_cursor $query_string
#              while {[orafetch $fetch_cursor -dataarray s -indexbyname] != 1403} {
#                set acount $s(ACCT_NBR)
#                set routing $s(TRANS_ROUTING_NBR)
#              }
##########################            
              set query_string5 "select *
                                from mas_trans_log
                                where PAYMENT_SEQ_NBR = '$t(PAYMENT_SEQ_NBR)'
                                  and POSTING_ENTITY_ID = '$t(ENTITY_ID)'
                                  and institution_id = '101'
                                  and settl_flag = 'Y'"
              #puts " q5 is $query_string5"
              #puts " got to the point"
              orasql $fetch_cursor $query_string5
              while {[orafetch $fetch_cursor -dataarray s -indexbyname] != 1403} {
                    if {$s(TID) == 010005050000} {       ;# 010005050000 D Deposit Reserve, 010005050001 C Deposit Reserve reversal
                          if {$s(TID_SETTL_METHOD) == "C"} {
                            #SYANG set NETDEPOSIT [expr $NETDEPOSIT +  $s(AMT_ORIGINAL)]
                            set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT +  $s(AMT_ORIGINAL)]
                            set RESERVES [expr $RESERVES + $s(AMT_ORIGINAL)]
                            set GRAND_RESERVES [expr $GRAND_RESERVES + $s(AMT_ORIGINAL)]
                          } else {
                            set RESERVES [expr $RESERVES - $s(AMT_ORIGINAL)]
                            set GRAND_RESERVES [expr $GRAND_RESERVES - $s(AMT_ORIGINAL)]
                            #SYANG set NETDEPOSIT [expr $NETDEPOSIT -  $s(AMT_ORIGINAL)]
                            set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT - $s(AMT_ORIGINAL)]
                          }
                    }
                    
                    if {$s(TID) == "010005090000"} {       ;# D split funding, 010005090001 C split funding reversal
                          set SETTLED_BC [expr $SETTLED_BC - $s(AMT_ORIGINAL) ]
                    } else {
                      set SETTLED_BC $SETTLED_BC
                    }
                    
                  if {$s(TID) == 010003015201 } {          
                      if {$s(TID_SETTL_METHOD) == "C"} {
                        set CHARGEBACK_AMOUNT [expr $CHARGEBACK_AMOUNT + $s(AMT_ORIGINAL)]
                        set SETTLED_BC [expr $SETTLED_BC - $s(AMT_ORIGINAL)]
#SYANG                  set NETDEPOSIT [expr $NETDEPOSIT +  $s(AMT_ORIGINAL)]                           ;# #SYANG 
                        set GRAND_CHARGEBACK_AMOUNT [expr $GRAND_CHARGEBACK_AMOUNT + $s(AMT_ORIGINAL)]
                        set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT +  $s(AMT_ORIGINAL)]
                      } else {
                        set CHARGEBACK_AMOUNT [expr $CHARGEBACK_AMOUNT - $s(AMT_ORIGINAL)]
#SYANG                  set NETDEPOSIT [expr $NETDEPOSIT -  $s(AMT_ORIGINAL)]                            ;# #SYANG 
                        set GRAND_CHARGEBACK_AMOUNT [expr $GRAND_CHARGEBACK_AMOUNT - $s(AMT_ORIGINAL)]
                        set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT - $s(AMT_ORIGINAL)]
                      }
                  }
                  if {$s(TID) == 010003015101  } {
                    if {$s(TID_SETTL_METHOD) == "C"} {
                      set CHARGEBACK_AMOUNT [expr $CHARGEBACK_AMOUNT + $s(AMT_ORIGINAL)]
#SYANG                set NETDEPOSIT [expr $NETDEPOSIT +  $s(AMT_ORIGINAL)]                             ;# #SYANG 
                      set GRAND_CHARGEBACK_AMOUNT [expr $GRAND_CHARGEBACK_AMOUNT + $s(AMT_ORIGINAL)]
                      set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT +  $s(AMT_ORIGINAL)]
                    } else {
                      set CHARGEBACK_AMOUNT [expr $CHARGEBACK_AMOUNT - $s(AMT_ORIGINAL)]
#SYANG                set NETDEPOSIT [expr $NETDEPOSIT -  $s(AMT_ORIGINAL)]
                      set GRAND_CHARGEBACK_AMOUNT [expr $GRAND_CHARGEBACK_AMOUNT - $s(AMT_ORIGINAL)]
                      set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT - $s(AMT_ORIGINAL)]
                    }
                  }
                  if {$s(TID) == 010003005301 || $s(TID) == "010003005401" } {
                    if {$s(TID_SETTL_METHOD) == "C"} {
                      set REPRESENTMENT_AMOUNT [expr $REPRESENTMENT_AMOUNT + $s(AMT_ORIGINAL)]
#SYANG                      set SETTLED_BC [expr $SETTLED_BC - $REPRESENTMENT_AMOUNT]  ;# SYANG: representment is credit
                      set SETTLED_BC [expr $SETTLED_BC - $s(AMT_ORIGINAL)]             ;# SYANG: representment is credit
                      #puts " TID ....SETTLE_BC is.... $SETTLED_BC "
#SYANG                set NETDEPOSIT [expr $NETDEPOSIT +  $s(AMT_ORIGINAL)]
                      set GRAND_REPRESENTMENT_AMOUNT [expr $GRAND_REPRESENTMENT_AMOUNT + $s(AMT_ORIGINAL)]
                      set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT +  $s(AMT_ORIGINAL)]
                    } else {
                      set REPRESENTMENT_AMOUNT [expr $REPRESENTMENT_AMOUNT - $s(AMT_ORIGINAL)]
#SYANG                set NETDEPOSIT [expr $NETDEPOSIT -  $s(AMT_ORIGINAL)]
                      set GRAND_REPRESENTMENT_AMOUNT [expr $GRAND_REPRESENTMENT_AMOUNT - $s(AMT_ORIGINAL)]
                      set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT - $s(AMT_ORIGINAL)]
                    }
                  }
                  if {$s(TID) == 010003005102} {
                    set REFUNDS [expr $REFUNDS - $s(AMT_ORIGINAL)]
#SYANG              set NETDEPOSIT [expr $NETDEPOSIT -  $s(AMT_ORIGINAL)]
                    set GRAND_REFUNDS [expr $GRAND_REFUNDS - $s(AMT_ORIGINAL)]
                    set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT -  $s(AMT_ORIGINAL)]
                  }
                  if {$s(TID) == 010003005101 } {                                    ;#SYANG 01-29-2008 
                    if {$s(CARD_SCHEME) == 04 || $s(CARD_SCHEME) == 05} {
                      if {$s(TID_SETTL_METHOD) == "C"} {
#SYANG                  set SETTLED_BC [expr $SETTLED_BC + $s(AMT_ORIGINAL)]
#SYANG                  set NETDEPOSIT [expr $NETDEPOSIT + $s(AMT_ORIGINAL)]
                        set GRAND_SETTLED_BC [expr $GRAND_SETTLED_BC + $s(AMT_ORIGINAL)]
                        set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT +  $s(AMT_ORIGINAL)]
                      } else {
#SYANG                  set SETTLED_BC [expr $SETTLED_BC - $s(AMT_ORIGINAL)]
#SYANG                  set NETDEPOSIT [expr $NETDEPOSIT - $s(AMT_ORIGINAL)]
                        set GRAND_SETTLED_BC [expr $GRAND_SETTLED_BC - $s(AMT_ORIGINAL)]
                        set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT -  $s(AMT_ORIGINAL)]
                      }
                    } else {
                      set SETTLED_NONBC [expr $SETTLED_NONBC + $s(AMT_ORIGINAL)]
#SYANG                set NETDEPOSIT [expr $NETDEPOSIT +  $s(AMT_ORIGINAL)]
                      set GRAND_SETTLED_NONBC [expr $GRAND_SETTLED_NONBC + $s(AMT_ORIGINAL)]
                      set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT +  $s(AMT_ORIGINAL)]
                    }
                  }               
                  if {$s(TID) == 010123005101} {                                           ;#SYANG 01-29-2008 
                    if {$s(CARD_SCHEME) == 04 || $s(CARD_SCHEME) == 05} {
                      if {$s(TID_SETTL_METHOD) == "C"} {                                   ;# tid 010123005101 is Debit
                        set SETTLED_BC [expr $SETTLED_BC + $s(AMT_ORIGINAL)]
#SYANG                  set NETDEPOSIT [expr $NETDEPOSIT + $s(AMT_ORIGINAL)]
                        set GRAND_SETTLED_BC [expr $GRAND_SETTLED_BC + $s(AMT_ORIGINAL)]
                        set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT +  $s(AMT_ORIGINAL)]
                      } else {
                        set SETTLED_BC [expr $SETTLED_BC - $s(AMT_ORIGINAL)]
#SYANG                  set NETDEPOSIT [expr $NETDEPOSIT - $s(AMT_ORIGINAL)]
                        set GRAND_SETTLED_BC [expr $GRAND_SETTLED_BC - $s(AMT_ORIGINAL)]
                        set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT -  $s(AMT_ORIGINAL)]
                      }
                    } else {
                      set SETTLED_NONBC [expr $SETTLED_NONBC + $s(AMT_ORIGINAL)]
#SYANG                set NETDEPOSIT [expr $NETDEPOSIT +  $s(AMT_ORIGINAL)]
                      set GRAND_SETTLED_NONBC [expr $GRAND_SETTLED_NONBC + $s(AMT_ORIGINAL)]
                      set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT +  $s(AMT_ORIGINAL)]
                    }
                  }
                  
                  if {[string range $s(TID) 0 5] == "010008" || [string range $s(TID) 0 5] == 010042 || [string range $s(TID) 0 5] == 010051} {
                    if {$s(TID_SETTL_METHOD) == "C"} {
                      set MISC_ADJUSTMENTS [expr $MISC_ADJUSTMENTS + $s(AMT_ORIGINAL)]
                      set GRAND_MISC_ADJUSTMENTS [expr $GRAND_MISC_ADJUSTMENTS + $s(AMT_ORIGINAL)]
#SYANG                set NETDEPOSIT [expr $NETDEPOSIT + $s(AMT_ORIGINAL)]
                      set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT + $s(AMT_ORIGINAL)]
                    } else {
                      set MISC_ADJUSTMENTS [expr $MISC_ADJUSTMENTS - $s(AMT_ORIGINAL)]
                      set GRAND_MISC_ADJUSTMENTS [expr $GRAND_MISC_ADJUSTMENTS - $s(AMT_ORIGINAL)]
#SYANG                set NETDEPOSIT [expr $NETDEPOSIT - $s(AMT_ORIGINAL)]
                      set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT - $s(AMT_ORIGINAL)]
                    }
                  }
                  if {[string range $s(TID) 0 7] == "01000507"} {
                    if {$s(TID_SETTL_METHOD) == "C"} {
                      set DISCOUNT [expr $DISCOUNT + $s(AMT_ORIGINAL)]
                      set GRAND_DISCOUNT [expr $GRAND_DISCOUNT + $s(AMT_ORIGINAL)]
                      set SETTLED_BC [expr $SETTLED_BC - $s(AMT_ORIGINAL)]     ;#SYANG: 010005070000 C adjustment
#SYANG                set NETDEPOSIT [expr $NETDEPOSIT +  $s(AMT_ORIGINAL)]
                      set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT +  $s(AMT_ORIGINAL)]
                    } else {
                      set DISCOUNT [expr $DISCOUNT - $s(AMT_ORIGINAL)]
                      set GRAND_DISCOUNT [expr $GRAND_DISCOUNT - $s(AMT_ORIGINAL)]
#SYANG                set NETDEPOSIT [expr $NETDEPOSIT - $s(AMT_ORIGINAL)]
                      set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT -  $s(AMT_ORIGINAL)]
                    }
                  }
                  if {$s(TID) == "010005090000"} {
                    if {$s(TID_SETTL_METHOD) == "C"} {
#RKAN                 set DISCOUNT [expr $DISCOUNT + $s(AMT_ORIGINAL)]
#SYANG                set GRAND_DISCOUNT [expr $GRAND_DISCOUNT + $s(AMT_ORIGINAL)]
#SYANG                set NETDEPOSIT [expr $NETDEPOSIT +  $s(AMT_ORIGINAL)]
                      set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT +  $s(AMT_ORIGINAL)]
                    } else {
#RKAN                 set DISCOUNT [expr $DISCOUNT - $s(AMT_ORIGINAL)]
#SYANG                set GRAND_DISCOUNT [expr $GRAND_DISCOUNT - $s(AMT_ORIGINAL)]
#SYANG                set NETDEPOSIT [expr $NETDEPOSIT - $s(AMT_ORIGINAL)]
                      set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT -  $s(AMT_ORIGINAL)]
                    }
                  }
                  if {$s(TID) == "010007090000"} {
                    if {$s(TID_SETTL_METHOD) == "C"} {
#RKAN                 set DISCOUNT [expr $DISCOUNT + $s(AMT_ORIGINAL)]
#RKAN                 set GRAND_DISCOUNT [expr $GRAND_DISCOUNT + $s(AMT_ORIGINAL)]
#SYANG                set NETDEPOSIT [expr $NETDEPOSIT +  $s(AMT_ORIGINAL)]
                      set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT +  $s(AMT_ORIGINAL)]
                    } else {
#RKAN                 set DISCOUNT [expr $DISCOUNT - $s(AMT_ORIGINAL)]
#RKAN                 set GRAND_DISCOUNT [expr $GRAND_DISCOUNT - $s(AMT_ORIGINAL)]
#SYANG                set NETDEPOSIT [expr $NETDEPOSIT - $s(AMT_ORIGINAL)]
                      set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT -  $s(AMT_ORIGINAL)]
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
#puts " OUT discount is $DISCOUNT......grand is $GRAND_DISCOUNT"        
                  if {([string range $s(TID) 0 5] == 010004 || [string range $s(TID) 0 5] == 010040 || [string range $s(TID) 0 5] == 010050 || [string range $s(TID) 0 5] == "010080") && $s(SETTL_FLAG) == "Y"} {                    
                    if {$s(TID_SETTL_METHOD) == "C"} {                     
                      set SETTLED_BC [expr $SETTLED_BC - $s(AMT_ORIGINAL)] ;# 010004020005 interchange fee refund
                      set DISCOUNT [expr $DISCOUNT + $s(AMT_ORIGINAL)]
                      set GRAND_DISCOUNT [expr $GRAND_DISCOUNT + $s(AMT_ORIGINAL)]
#SYANG                set NETDEPOSIT [expr $NETDEPOSIT +  $s(AMT_ORIGINAL)]
                      set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT +  $s(AMT_ORIGINAL)]                   
                    } else {                     
                      set DISCOUNT [expr $DISCOUNT - $s(AMT_ORIGINAL)]
                      set GRAND_DISCOUNT [expr $GRAND_DISCOUNT - $s(AMT_ORIGINAL)]                     
#SYANG               set NETDEPOSIT [expr $NETDEPOSIT - $s(AMT_ORIGINAL)]
                      set GRAND_NETDEPOSIT [expr $GRAND_NETDEPOSIT - $s(AMT_ORIGINAL)]
                    }
                  }
             }
#SYANG         ##}
        if {$CHARGEBACK_AMOUNT == 0 && $SETTLED_BC == 0 && $SETTLED_NONBC == 0 && $REFUNDS == 0 && $MISC_ADJUSTMENTS == 0 && $DISCOUNT == 0 && $NETDEPOSIT == 0 } {
          puts "skipping merchant"
        } else {
          puts $cur_file "$ISO,$t(ENTITY_ID),$NAME,[format "%0.2f" $SETTLED_BC],[format "%0.2f" $SETTLED_NONBC],[format "%0.2f" $CHARGEBACK_AMOUNT],[format "%0.2f" $REPRESENTMENT_AMOUNT],[format "%0.2f" $REFUNDS],[format "%0.2f" $MISC_ADJUSTMENTS],[format "%0.2f" $ACH_RESUB],[format "%0.2f" $RESERVES],[format "%0.2f" $DISCOUNT],[format "%0.2f" $NETDEPOSIT]\r"
        }
##SYANG        puts $cur_file "$ISO,$t(ENTITY_ID),$NAME,[format "%0.2f" $SETTLED_BC],[format "%0.2f" $SETTLED_NONBC],[format "%0.2f" $CHARGEBACK_AMOUNT],[format "%0.2f" $REPRESENTMENT_AMOUNT],[format "%0.2f" $REFUNDS],[format "%0.2f" $MISC_ADJUSTMENTS],[format "%0.2f" $ACH_RESUB],[format "%0.2f" $RESERVES],[format "%0.2f" $DISCOUNT],[format "%0.2f" $NETDEPOSIT]\r"
      }
          puts $cur_file " ,,TOTAL:,[format "%0.2f" $GRAND_SETTLED_BC],[format "%0.2f" $GRAND_SETTLED_NONBC],[format "%0.2f" $GRAND_CHARGEBACK_AMOUNT],[format "%0.2f" $GRAND_REPRESENTMENT_AMOUNT],[format "%0.2f" $GRAND_REFUNDS],[format "%0.2f" $GRAND_MISC_ADJUSTMENTS],[format "%0.2f" $GRAND_ACH_RESUB],[format "%0.2f" $GRAND_RESERVES],[format "%0.2f" $GRAND_DISCOUNT],[format "%0.2f" $GRAND_NETDEPOSIT]\r"
          close $cur_file
          exec uuencode $cur_file_name $file_name | mailx -r clearing@jetpay.com -s $file_name clearing@jetpay.com 
 oraclose $fetch_cursor
