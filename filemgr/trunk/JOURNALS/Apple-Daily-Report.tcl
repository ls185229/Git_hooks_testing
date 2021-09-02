#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

###################       MODIFICATION HISTORY        ##########################
#
# Version 0.00 Sunny Yang 09-11-2008
# ------------ Report Apple's daily funding information
#
#################################################################################

#Environment veriables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(SEC_DB)
set authdb $env(RPT_DB)
set clruser $env(IST_DB_USERNAME)
set clrpwd $env(IST_DB_PASSWORD)

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

#set mode "TEST"
set mode "PROD"
####################################################################################################################

package require Oratcl
if {[catch {set handler [oralogon $clruser/$clrpwd@$clrdb]} result]} {
  exec echo "apple-daily-report.tcl failed to run" | mailx -r $mailfromlist -s "apple-daily-report.tcl failed to run" $mailtolist
  exit
} else {
  puts "COnnected"
}

set  cursor1          [oraopen $handler]
set  cursor2          [oraopen $handler]
set  cursor3          [oraopen $handler]

#****************************************************************************************************************
#*************************************       time settings and arguments         ********************************
#****************************************************************************************************************

if { $argc == 0 } {
      set title_date          [clock format [clock scan "-0 day"] -format %Y%m%d]
      set report_date         [string toupper [clock format [clock scan "-0 day"] -format %d-%b-%y]]  ;# 20-MAR-08
      set report_month        [string toupper [clock format [clock scan "-0 day"] -format %B]]        ;# MARCH
      set report_year         [clock format [clock scan "-0 day"] -format %Y]                         ;# 2008
      set short_report_month  [string toupper  [clock format [clock scan "-0 day"] -format %b]]       ;# MAR
      set short_report_year   [clock format [clock scan "-0 day"] -format %y ]                        ;# 08
      set CUR_SET_TIME        [clock seconds ]
      set CUR_JULIAN_DATEX    [string range [clock format $CUR_SET_TIME -format "%y%j"] 1 4]
      set name_date           [clock format [clock scan "-0 day"] -format %Y%m%d]                     ;# 20080609
      set header_dt           [string toupper [clock format [clock scan "-0 day"] -format %d-%b-%Y]]
      puts "*** Running today's reports: $report_date ***"

} elseif { $argc == 1 } {
      set input [string trim [lindex $argv 0]]
      if { [string length $input ] == 8 } {
           set report_date     $input
      } elseif { [string length $input ] != 8  } {
         puts "REPORT DATE SHOULD BE 8 DIGITS! "
         puts "PLEASE START OVER! "
         exit
      }
      set name_date $report_date
      set report_month        [ string toupper [clock format [clock scan " $report_date -0 day " ] -format %B]]
      set report_year         [clock format [clock scan " $report_date -0 day " ] -format %Y]
      set short_report_month  [ string toupper [clock format [clock scan " $report_date -0 day " ] -format %b]]
      set short_report_year   [clock format [clock scan " $report_date -0 day " ] -format %y]
      set title_date          [clock format [clock scan "$report_date -0 day"] -format %Y%m%d]
      set report_date         [ string toupper [clock format [ clock scan " $report_date -0 day " ] -format %d-%b-%y ]]
      set header_dt           [string toupper [clock format [clock scan "$report_date -0 day"] -format %d-%b-%Y]]
      set CUR_JULIAN_DATEX    [ clock scan "$report_date"  -base [clock seconds] ]
      set CUR_JULIAN_DATEX    [clock format $CUR_JULIAN_DATEX -format "%y%j"]
      set CUR_JULIAN_DATEX    [string range $CUR_JULIAN_DATEX 1 4 ]

}
###**************************************************************************************************************###
###**************************************************************************************************************###

proc apple_report { ent_name } {

      global  cursor1 cursor2 cursor3
      global  title_date report_date report_month report_year short_report_month short_report_year name_date
      global  CUR_JULIAN_DATEX header_dt mode
    if {$mode == "PROD"} {
      set cur_file_name    "./ROLLUP/ARCHIVE/[ string toupper $ent_name].DAILY.REPORT.$CUR_JULIAN_DATEX.$name_date.001.csv"
      set file_name        "[ string toupper $ent_name].DAILY.REPORT.$CUR_JULIAN_DATEX.$name_date.001.csv"
    } elseif {$mode == "TEST"} {
      set cur_file_name    "./[string toupper $ent_name].DAILY.REPORT.$CUR_JULIAN_DATEX.$name_date.001.csv"
      set file_name        "[string toupper $ent_name].DAILY.REPORT.$CUR_JULIAN_DATEX.$name_date.001.csv"
    }
      set cur_file         [open "$cur_file_name" w]
      puts $cur_file "DAILY FUNDING REPORT"
      puts $cur_file "DATE:,$header_dt\n"
      puts $cur_file "Merchant ID, Merchant Name,Settle Bankcards, Activity Date, Settle NonBankcards,Chargeback Amount, Representment, Activity Date, Refunds, Fees, Net Deposit\r\n"

      set SETTLED_BC 0
      set SETTLED_NONBC 0
      set CHARGEBACK_AMOUNT 0
      set REPRESENTMENT_AMOUNT 0
      set REFUNDS 0
      set ACH_RESUB 0
      set RESERVES 0
      set DISCOUNT 0
      set NETDEPOSIT 0

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
      set days 0
                #********************************** TID REFRENCE  ***************************##
                # 010005050000 D Deposit Reserve, 010005050001 C Deposit Reserve reversal     #
                # 010003015201 C Chargeback, 010003015101 D                                   #
                # 010005090000 C 010005090001 D splik fund                                    #
                # 010003005301 C 010003005401 D REpresentment                                 #
                # 010123005102 C 010123005101 D                                               #
                # 010005070000 C adjustment                                                   #
                # 010007090000 not in use                                                     #
                # 010005090000 not in use                                                     #
                #****************************************************************************##

      if {$ent_name == "apple"} {
          set ent_query "select unique entity_id from acq_entity where ENTITY_DBA_NAME like '%APPLE VACATIONS%'"
      } elseif {$ent_name == "usa"} {
          set ent_query "select unique entity_id from acq_entity where ENTITY_DBA_NAME like '%USA3000%'"
      }
          set delay_query "select unique sp.PLAN_DESC as EID,   spt.delay_factor0 as DELAY0, spt.delay_factor1 as DELAY1
                          from settl_plan sp, settl_plan_tid spt
                          where sp.PLAN_DESC  in (select entity_id
                                                  from acq_entity
                                                  where ENTITY_DBA_NAME like '%APPLE VACATIONS%' or
                                                        ENTITY_DBA_NAME like '%USA3000%') and
                                spt.settl_plan_id = sp.settl_plan_id and
                                (spt.delay_factor0  <> 0 or spt.delay_factor1 <> 0)
                          order by sp.plan_desc "

           orasql $cursor2 $delay_query
           while {[orafetch $cursor2 -dataarray dt -indexbyname] != 1403} {
                 set delay($dt(EID))  $dt(DELAY0)
           }
      set query_string " select unique mtl.entity_id as ENTITY_ID, acq.parent_entity_id as PARENT_ENTITY_ID, acq.entity_dba_name as ENTITY_DBA_NAME, acq.actual_start_date as ACTUAL_START_DATE, mtl.PAYMENT_SEQ_NBR,
                           sum(case when(mtl.tid_settl_method = 'C' ) then mtl.amt_original else 0 end) as TOTAL_C_BC,
                           sum(case when(mtl.tid_settl_method = 'D' ) then mtl.amt_original else 0 end) as TOTAL_D_BC,
                          (sum(case when( (mtl.tid_settl_method = 'C' AND \
                                           mtl.CARD_SCHEME in ('04', '05') AND \
                                           mtl.tid not in ('010003015102', '010005050001', '010003015201', '010003015210', '010003005301', '010123005102', '010005070000', '010003010102')) AND \
                                           ( substr(mtl.tid, 1,6) <> '010004' AND substr(mtl.tid, 1,6) <> '010040' AND substr(mtl.tid, 1,6) <> '010050' AND substr(mtl.tid, 1,6) <> '010080' ))  then mtl.amt_original else 0 end) - sum(case when (tid = '010123005101' ) then mtl.amt_original else 0 end )) as SETTLED_C_BC ,
                           sum(case when(mtl.tid_settl_method = 'C' AND mtl.tid  in ('010005090000', '010005090001')) then mtl.amt_original else 0 end) as SPLIT_D,
                           sum(case when(mtl.tid_settl_method <> 'C' AND mtl.tid  in ('010005090000', '010005090001')) then mtl.amt_original else 0 end) as SPLIT_C,
                           sum(case when(mtl.tid_settl_method = 'C' AND mtl.tid  in ('010003015101', '010003015102', '010003015201', '010003015210')) then mtl.amt_original else 0 end) as CHARGEBACK_C,
                           sum(case when(mtl.tid_settl_method <> 'C' AND mtl.tid  in ('010003015101', '010003015102', '010003015201', '010003015210')) then mtl.amt_original else 0 end) as CHARGEBACK_D,
                           sum(case when(mtl.tid_settl_method = 'C' AND mtl.tid  in ('010003005301', '010003005401', '010003010102', '010003010101')) then mtl.amt_original else 0 end) as REPRESENTMENT_C,
                           sum(case when(mtl.tid_settl_method <> 'C' AND mtl.tid  in ('010003005301', '010003005401', '010003010102', '010003010101')) then mtl.amt_original else 0 end) as REPRESENTMENT_D,
                           sum(case when(mtl.tid_settl_method = 'C' AND mtl.tid  in ('010003005102')) then mtl.amt_original else 0 end) as REFUNDS_C,
                           sum(case when(mtl.tid_settl_method <> 'C' AND mtl.tid  in ('010003005102')) then mtl.amt_original else 0 end) as REFUNDS_D,
                           sum(case when(mtl.tid_settl_method = 'C' AND mtl.tid  in ('010003005101', '010003005102', '010123005101', '010123005102' ) AND mtl.CARD_SCHEME not in ('04', '05')) then mtl.amt_original else 0 end) as SETTLED_NONBC_C,
                           sum(case when(mtl.tid_settl_method <> 'C' AND mtl.tid  in ('010003005101', '010003005102', '010123005101', '010123005102'  ) AND mtl.CARD_SCHEME not in ('04', '05')) then mtl.amt_original else 0 end) as SETTLED_NONBC_D,
                           sum(case when(mtl.tid_settl_method = 'C' AND ( substr(mtl.tid, 1,8) = '01000507' OR substr(mtl.tid, 1,6) = '010004' OR substr(mtl.tid, 1,6) = '010040' OR substr(mtl.tid, 1,6) = '010050' OR substr(mtl.tid, 1,6) = '010080')) then mtl.amt_original else 0 end) as DISCOUNT_C,
                           sum(case when(mtl.tid_settl_method <> 'C' AND ( substr(mtl.tid, 1,8) = '01000507' OR substr(mtl.tid, 1,6) = '010004' OR substr(mtl.tid, 1,6) = '010040' OR substr(mtl.tid, 1,6) = '010050' OR substr(mtl.tid, 1,6) = '010080')) then mtl.amt_original else 0 end) as DISCOUNT_D
                        from mas_trans_log mtl, acq_entity acq
                        where mtl.entity_id = acq.entity_id
                            and acq.entity_id in ($ent_query)
                            and mtl.SETTL_FLAG = 'Y'
                            and mtl.PAYMENT_SEQ_NBR in (select PAYMENT_SEQ_NBR
                                                    from ACCT_ACCUM_DET
                                                    where PAYMENT_PROC_DT like '%$report_date%'
                                                     and institution_id = '101'
                                                      and entity_acct_id not in (select entity_acct_id
                                                                                 from entity_acct
                                                                                  where institution_id = '101'
                                                                                  and stop_pay_flag = 'Y'))
                        group by mtl.entity_id, acq.parent_entity_id, acq.entity_dba_name, acq.actual_start_date, mtl.PAYMENT_SEQ_NBR
                        order by mtl.entity_id  "
if {$mode == "TEST"} {
      puts $query_string
}
      orasql $cursor1 $query_string
      while {[orafetch $cursor1 -dataarray t -indexbyname] != 1403} {

              set ISO $t(PARENT_ENTITY_ID)
              set NAME $t(ENTITY_DBA_NAME)
              set CONTRACT_DATE $t(ACTUAL_START_DATE)
              set ENTITY_ID $t(ENTITY_ID)

              set SETTLED_BC           [ expr $t(SETTLED_C_BC) - $t(SPLIT_C) ]  ;# split fund
              set NETDEPOSIT           [ expr $t(TOTAL_C_BC) - $t(TOTAL_D_BC)]
              set CHARGEBACK_AMOUNT    [ expr $t(CHARGEBACK_C) - $t(CHARGEBACK_D) ]
              set REPRESENTMENT_AMOUNT [ expr $t(REPRESENTMENT_C) - $t(REPRESENTMENT_D)]
              set REFUNDS              [ expr $t(REFUNDS_C) - $t(REFUNDS_D) ]
              set SETTLED_NONBC        [ expr $t(SETTLED_NONBC_C) - $t(SETTLED_NONBC_D) ]
              set DISCOUNT             [ expr $t(DISCOUNT_C) - $t(DISCOUNT_D) ]

              set GRAND_SETTLED_BC           [ expr $GRAND_SETTLED_BC + $SETTLED_BC ]
              set GRAND_NETDEPOSIT           [ expr $GRAND_NETDEPOSIT +  $NETDEPOSIT ]
              set GRAND_CHARGEBACK_AMOUNT    [ expr $GRAND_CHARGEBACK_AMOUNT + $CHARGEBACK_AMOUNT ]
              set GRAND_REPRESENTMENT_AMOUNT [ expr $GRAND_REPRESENTMENT_AMOUNT + $REPRESENTMENT_AMOUNT ]
              set GRAND_REFUNDS              [ expr $GRAND_REFUNDS + $REFUNDS ]
              set GRAND_SETTLED_NONBC        [ expr $GRAND_SETTLED_NONBC + $SETTLED_NONBC ]
              set GRAND_DISCOUNT             [ expr $GRAND_DISCOUNT + $DISCOUNT ]

          catch {set syang $delay($t(ENTITY_ID)) } result1
         if {[string range $result1 0 9] == "can't read"} {
           set  days 0
         } else {
           set  days $delay($t(ENTITY_ID))
         }
         set activity_date         [ string toupper [clock format [ clock scan " $report_date -$days day " ] -format %d-%b-%y ]]

        if {$CHARGEBACK_AMOUNT == 0 && $SETTLED_BC == 0 && $SETTLED_NONBC == 0 && $REFUNDS == 0 && $DISCOUNT == 0 && $NETDEPOSIT == 0 } {
              puts "skipping merchant, $t(ENTITY_ID)"
        } else {
              if {$SETTLED_BC != 0 && $REPRESENTMENT_AMOUNT != 0} {
                puts $cur_file "$t(ENTITY_ID),$NAME,[format "%0.2f" $SETTLED_BC], $activity_date ,[format "%0.2f" $SETTLED_NONBC],[format "%0.2f" $CHARGEBACK_AMOUNT],[format "%0.2f" $REPRESENTMENT_AMOUNT],$activity_date, [format "%0.2f" $REFUNDS],[format "%0.2f" $DISCOUNT],[format "%0.2f" $NETDEPOSIT]\r"
                set days 0
              } elseif {$REPRESENTMENT_AMOUNT == 0 && $SETTLED_BC != 0 } {
                puts $cur_file "$t(ENTITY_ID),$NAME,[format "%0.2f" $SETTLED_BC], $activity_date ,[format "%0.2f" $SETTLED_NONBC],[format "%0.2f" $CHARGEBACK_AMOUNT],[format "%0.2f" $REPRESENTMENT_AMOUNT],, [format "%0.2f" $REFUNDS],[format "%0.2f" $DISCOUNT],[format "%0.2f" $NETDEPOSIT]\r"
                set days 0
              } else {
                puts $cur_file "$t(ENTITY_ID),$NAME,[format "%0.2f" $SETTLED_BC],  ,[format "%0.2f" $SETTLED_NONBC],[format "%0.2f" $CHARGEBACK_AMOUNT],[format "%0.2f" $REPRESENTMENT_AMOUNT],, [format "%0.2f" $REFUNDS],[format "%0.2f" $DISCOUNT],[format "%0.2f" $NETDEPOSIT]\r"
                set days 0
              }
        }
      }
          puts $cur_file " ,TOTAL:,[format "%0.2f" $GRAND_SETTLED_BC],,[format "%0.2f" $GRAND_SETTLED_NONBC],[format "%0.2f" $GRAND_CHARGEBACK_AMOUNT],[format "%0.2f" $GRAND_REPRESENTMENT_AMOUNT],,[format "%0.2f" $GRAND_REFUNDS],[format "%0.2f" $GRAND_DISCOUNT],[format "%0.2f" $GRAND_NETDEPOSIT]\r"
          close $cur_file
          #exec uuencode $cur_file_name $file_name | mailx -r clearing@jetpay.com -s $file_name clearing@jetpay.com
      if {$mode == "TEST"} {
        exec uuencode $cur_file_name $file_name | mailx -r clearing@jetpay.com -s $file_name clearing@jetpay.com
      } elseif {$mode == "PROD"} {
          exec uuencode $cur_file_name $file_name | mailx -r clearing@jetpay.com -s $file_name clearing@jetpay.com
      }
}

if { $argc == 0 } {

    #puts "Apple "
    #apple_report apple

    puts "USA3000 "
    apple_report usa

} elseif { $argc == 1 } {

#    puts "Apple "
#    apple_report apple

    puts "USA3000 "
    apple_report usa

}

oraclose $cursor1
oraclose $cursor2
oraclose $cursor3
