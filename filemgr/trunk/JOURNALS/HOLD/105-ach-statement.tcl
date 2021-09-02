#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: 105-ach-statement.tcl 1927 2012-12-13 15:18:13Z mitra $

#=====================      MODIFICATION HISTORY        ========================
# Version g1.01 Sunny Yang 04-12-2010
# ----- Handling comma in Merchant Name in this script instead of database level.
#
# Version g1.00 Sunny Yang 07-22-2009
# ----- Start to use global version for all institution now
#
# Version 1.05 Sunny Yang 07-22-2009
# ----- Add in Discover 
#
# Version 1.04 Sunny Yang 06-18-2009
# ----- update for Rolling Reserve paying out
#
# Version 1.03 Sunny Yang 04-16-2009
# ----- Add in Arbitration TIDs
#
# Version 1.03 Sunny Yang 12-26-2008
# ----- add in new tid: 010003005201
#
# Version 1.02 Sunny Yang 08-21-2008
# ----- Modify this script to match with Daily Detail report and Payable report
# ----- on Arbitrations
#
# Version 1.01 Sunny Yang 05-08-2008
# ----- Get file ready to put under "ROOT" directory but only run for 105
# ----- Get file ready for Debit transaction: fill settle_nonBC column
# ----- Settled_BC is only for MC and VS
# 
# Version 1.00 Sunny Yang 03-19-2008
# ----- Rewrite the whole file to roll all institutions into one script
# ----- and start to take arguements from configure file or prompts to avoid
# ----- updating production version when certain dates need to be re-run.
#
# Version 0.02 Sunny Yang 03-18-2008
#    add new tid for chargeback
#
# Version 0.01 Sunny Yang 12-12-2007
# Modified script to reflect all payments associate with each merchant
# Adjusted net deposit to match with payment amount, need further instruction
# on purpose of net deposit.

# Version 0.00 Myke Sanders

#===============================================================================
#===============================================================================
#Environment veriables.......

#set box $env(SYS_BOX)
#set clrpath $env(CLR_OSITE_ROOT)
#set maspath $env(MAS_OSITE_ROOT)

set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)

set clrdb trnclr1
#set authdb $env(TSP4_DB)

#Email Subjects variables Priority wise

#set msubj_c "$box :: Priority : Critical - Clearing and Settlement"
#set msubj_u "$box :: Priority : Urgent - Clearing and Settlement"
#set msubj_h "$box :: Priority : High - Clearing and Settlement"
#set msubj_m "$box :: Priority : Medium - Clearing and Settlement"
#set msubj_l "$box :: Priority : Low - Clearing and Settlement"


#Email Body Headers variables for assist

#set mbody_c "ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
#set mbody_u "ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
#set mbody_h "ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
#set mbody_m "ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
#set mbody_l "ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

#System information variables....

#set sysinfo "System: $box\n Location: $env(PWD) \n\n"

#Fail message....
set fail_msg "merric-ach-statement.tcl failed to run"

#Mode....
#set mode "TEST"
set mode "PROD"
#===============================================================================
#                                    USAGE        
#===============================================================================

## 1) no argument: run on current and generate individual report for each inst
## 2) with date argument: run on specified date for all institutions
## 3) with inst argument: run for specified inst on current date
## 4) with both date and inst argument: run for specified date and inst.
#===============================================================================

package require Oratcl
if {[catch {set handler [oralogon masclr/masclr@$clrdb]} result]} {
  exec echo $fail_msg | mailx -r $mailfromlist -s $fail_msg $mailtolist
  exit
}

set ach_cursor1          [oraopen $handler]
set ach_cursor2          [oraopen $handler]

#===============================================================================
#                       time settings and arguments         
#===============================================================================



  if { $argc == 0 } {
      set report_date         [string toupper [clock format [clock scan "-0 day"] -format %d-%b-%y]]  ;# 20-MAR-08
      set CUR_SET_TIME        [clock seconds ]
      set CUR_JULIAN_DATEX    [string range [clock format $CUR_SET_TIME -format "%y%j"] 1 4]
      set name_date           [string toupper [clock format [clock scan "-0 day"] -format %d-%b-%y]]  ;# 20-MAR-08     
  } elseif { $argc == 1 } {
      set input [string trim [lindex $argv 0]]
      if {[string length $input ] == 3 } {
           set institution_id      $input
           set report_date         [string toupper [clock format [clock scan "-0 day"] -format %d-%b-%y]]
      } elseif {[string length $input ] == 8 } {
           set report_date     $input
           set institution_id   "ALL"
      } elseif {[string length $input ] != 8 || [string length $input] != 3 } {
         puts "INSTITUTION ID SHOULD BE 3 DIGITS! like 101"
         puts "REPORT DATE SHOULD BE 8 DIGITS! like 20080720"
         puts "PLEASE START OVER! "
         exit 
      }
      set name_date $report_date
      set report_date         [string toupper [clock format [ clock scan " $report_date -0 day "] -format %d-%b-%y ]]
      set CUR_JULIAN_DATEX    [clock scan "$report_date"  -base [clock seconds]]
      set CUR_JULIAN_DATEX    [string range [clock format $CUR_JULIAN_DATEX -format "%y%j"] 1 4]  
      
  } elseif { $argc == 2 } {
        set institution_id      [string trim [lindex $argv 0]]
        if { [string length $institution_id ] != 3 } {
          puts "INSTITUTION ID SHOULD BE 3 DIGITS: "
          set institution_id [gets stdin]
        }
        set report_date         [lindex $argv 1]
        if { [string length $report_date ] != 8 } {
          puts "REPORT DATE SHOULD BE 8 DIGITS: "
          set report_date [gets stdin]
        }
        set name_date           [string toupper [clock format [ clock scan " $report_date -0 day " ] -format %d-%b-%y ]]
        set report_date         [string toupper [clock format [ clock scan " $report_date -0 day " ] -format %d-%b-%y ]]
        set CUR_JULIAN_DATEX    [clock scan "$report_date"  -base [clock seconds]]
        set CUR_JULIAN_DATEX    [string range[clock format $CUR_JULIAN_DATEX -format "%y%j"]1 4]  
  } elseif { $argc != 0 && $argc != 2 } {
        puts " Need both INSTITUTION_ID and DATE to run this file "
        puts "ENTER INSTITUTION ID PLEASE:(FORMAT XXX: example 101 "
        set institution_id [gets stdin]
        if { [string length $institution_id ] != 3 } {
          puts "INSTITUTION ID SHOULD BE 3 DIGITS: "
          set institution_id [gets stdin]
        }
        set report_date ""
        puts "ENTER THE REPORT DATE PLEASE: ( FORMAT YYYYMONDD: example 20080320 )"
        set report_date         [gets stdin]
        if { [string length $report_date ] != 8 } {
          puts "REPORT DATE SHOULD BE 8 DIGITS: "
          set report_date [gets stdin]
        }
        set name_date           [string toupper [clock format [clock scan " $report_date -0 day "] -format %d-%b-%y ]]
        set report_date         [string toupper [clock format [clock scan " $report_date -0 day "] -format %d-%b-%y ]]
        set CUR_JULIAN_DATEX    [clock scan "$report_date"  -base [clock seconds]]
        set CUR_JULIAN_DATEX    [string range[clock format $CUR_JULIAN_DATEX -format "%y%j"]1 4]  
  }
  

#===============================================================================
puts "*** Running report(s) for: $report_date ***"
#===============================================================================

puts "mode: $mode"
proc ach_report { institution_num } {
     global  ach_cursor1 ach_cursor2 report_date name_date CUR_JULIAN_DATEX mode

      if {$mode == "TEST"} {
        set cur_file_name    "$institution_num.REPORT.ACH.$CUR_JULIAN_DATEX.$name_date.TEST.csv"
        set file_name        "$institution_num.REPORT.ACH.$CUR_JULIAN_DATEX.$name_date.TEST.csv"
      } elseif {$mode == "PROD"} {
      set cur_file_name    "./INST_$institution_num/UPLOAD/$institution_num.REPORT.ACH.$CUR_JULIAN_DATEX.$name_date.001.csv"
      set file_name        "$institution_num.REPORT.ACH.$CUR_JULIAN_DATEX.$name_date.001.csv"
      }
      set cur_file         [open "$cur_file_name" w]
      
      puts $cur_file "ACH REPORT"
      puts $cur_file "DATE:,$report_date\n"
      set columns "ISO#,Merchant ID, Merchant Name,Settle Bankcards, Settle NonBankcards,Chargeback Amount"
      puts $cur_file "$columns, Representment, Refunds,Misc Adj., ACH Resub., Reserves, Fees, Net Deposit\r\n"
      
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
      set query_string " select unique mtl.entity_id as ENTITY_ID,
                                       acq.parent_entity_id as PARENT_ENTITY_ID,
                                       replace(acq.entity_dba_name, ',', '') as ENTITY_DBA_NAME,
                                       acq.actual_start_date as ACTUAL_START_DATE,
                                       mtl.PAYMENT_SEQ_NBR,  
        sum(case when(mtl.tid_settl_method = 'C' and mtl.CARD_SCHEME <> '12') then mtl.amt_original else 0 end) as TOTAL_C_BC,
        sum(case when(mtl.tid_settl_method = 'D' and mtl.CARD_SCHEME <> '12') then mtl.amt_original else 0 end) as TOTAL_D_BC,
        (sum(case when((mtl.tid_settl_method = 'C' AND \
        				/*exclude MISC tids*/ (substr(mtl.tid, 1,6) not in ('010042','010051') AND tid not in ('010005090001','010007090001','010007090000')) AND 
                        mtl.CARD_SCHEME in ('04','05','08') AND \
                        mtl.tid not in ('010003015102','010005050001','010003015201','010003015210','010003005301','010005070000','010003010102','010003010101')) AND \
                        (substr(mtl.tid, 1,6) not in('010040','010080','010004') AND substr(mtl.tid, 1,8) not in ('01000505','01000705'))) then mtl.amt_original else 0 end) \
        - sum(case when (tid = '010123005101' ) then mtl.amt_original else 0 end )) as SETTLED_C_BC , 
         sum(case when(mtl.tid_settl_method = 'C'  AND (substr(mtl.tid,1,8) in ('01000505','01000705'))) then mtl.amt_original else 0 end) as RESERVES_C,
        sum(case when(mtl.tid_settl_method <> 'C' AND (substr(mtl.tid,1,8) in ('01000505','01000705'))) then mtl.amt_original * -1 else 0 end) as RESERVES_D,
        sum(case when(mtl.tid_settl_method = 'C'  AND mtl.tid in ('010003015101','010003015102','010003015201','010003015210')) then mtl.amt_original else 0 end) as CHARGEBACK_C,
        sum(case when(mtl.tid_settl_method <> 'C' AND mtl.tid in ('010003015101','010003015102','010003015201','010003015210')) then mtl.amt_original else 0 end) as CHARGEBACK_D,
        sum(case when(mtl.tid_settl_method = 'C'  AND mtl.tid in ('010003005301','010003005401','010003010102','010003010101')) then mtl.amt_original else 0 end) as REPRESENTMENT_C,
        sum(case when(mtl.tid_settl_method <> 'C' AND mtl.tid in ('010003005301', '010003005401', '010003010102','010003010101')) then mtl.amt_original else 0 end) as REPRESENTMENT_D,
        sum(case when(mtl.tid_settl_method = 'C'  AND mtl.tid in ('010003005102')) then mtl.amt_original else 0 end) as REFUNDS_C,
        sum(case when(mtl.tid_settl_method <> 'C' AND mtl.tid in ('010003005102')) then mtl.amt_original else 0 end) as REFUNDS_D,
        sum(case when(mtl.tid_settl_method = 'C'  AND mtl.tid in ('010003005202')) then mtl.amt_original else 0 end) as SALES_REVERSAL_C,
        sum(case when(mtl.tid_settl_method <> 'C' AND mtl.tid in ('010003005201')) then mtl.amt_original else 0 end) as SALES_REVERSAL_D,
        sum(case when(mtl.tid_settl_method = 'C'  AND mtl.tid in ('010003005101','010003005102','010123005101','010123005102','010003005201','010003005202') AND mtl.CARD_SCHEME not in ('04','05','08','12')) then mtl.amt_original else 0 end) as SETTLED_NONBC_C,
        sum(case when(mtl.tid_settl_method <> 'C' AND mtl.tid in ('010003005101','010003005102','010123005101','010123005102','010003005201','010003005202') AND mtl.CARD_SCHEME not in ('04','05','08','12')) then mtl.amt_original else 0 end) as SETTLED_NONBC_D,
        sum(case when(mtl.tid_settl_method = 'C'  AND ((substr(mtl.tid, 1,6) in ('010042','010051')) or tid in ('010005090001','010007090001','010007090000'))) then mtl.amt_original else 0 end) as MISC_ADJUSTMENTS_C,
        sum(case when(mtl.tid_settl_method <> 'C' AND ((substr(mtl.tid, 1,6) in ('010042','010051')) or tid in ('010005090000','010007090000','010007090001'))) then mtl.amt_original else 0 end) as MISC_ADJUSTMENTS_D,
        sum(case when(mtl.tid_settl_method = 'C'  AND (substr(mtl.tid, 1,8) = '01000507' OR substr(mtl.tid, 1,6) in ('010004','010040','010050','010080'))) then mtl.amt_original else 0 end) as DISCOUNT_C,
        sum(case when(mtl.tid_settl_method <> 'C' AND (substr(mtl.tid, 1,8) = '01000507' OR substr(mtl.tid, 1,6) in ('010004','010040','010050','010080'))) then mtl.amt_original else 0 end) as DISCOUNT_D,
        sum(case when(mtl.tid_settl_method = 'C'  AND mtl.tid in ('010007150000','010007150001')) then mtl.amt_original else 0 end) as ACH_RESUB_C,
        sum(case when(mtl.tid_settl_method <> 'C' AND mtl.tid in ('010007150000','010007150001')) then mtl.amt_original else 0 end) as ACH_RESUB_D   
     from mas_trans_log mtl, acq_entity acq 
     where mtl.entity_id = acq.entity_id       
         and mtl.institution_id = '$institution_num'
         and mtl.SETTL_FLAG = 'Y'
         and mtl.PAYMENT_SEQ_NBR in (select PAYMENT_SEQ_NBR
                                 from ACCT_ACCUM_DET
                                 where PAYMENT_PROC_DT like '%$report_date%'
                                  and institution_id = '$institution_num'
                                  and payment_cycle = '1'
                                  and payment_status = 'P'
                                 and entity_acct_id not in (select entity_acct_id
                                                              from entity_acct
                                                               where institution_id = '$institution_num'
                                                               and stop_pay_flag = 'Y')) 
     group by mtl.entity_id, acq.parent_entity_id, acq.entity_dba_name, acq.actual_start_date, mtl.PAYMENT_SEQ_NBR    
     order by mtl.entity_id  "

      #puts $query_string
      orasql $ach_cursor1 $query_string 
      while {[orafetch $ach_cursor1 -dataarray t -indexbyname] != 1403} {                    
              set ISO $t(PARENT_ENTITY_ID)
              set NAME $t(ENTITY_DBA_NAME)
              set CONTRACT_DATE $t(ACTUAL_START_DATE)
              set ENTITY_ID $t(ENTITY_ID)              
              set SETTLED_BC           [ expr $t(SETTLED_C_BC) - $t(SALES_REVERSAL_D)]  ;
              set NETDEPOSIT           [ expr $t(TOTAL_C_BC) - $t(TOTAL_D_BC)]
              set RESERVES             [ expr $t(RESERVES_C) + $t(RESERVES_D)]
              set CHARGEBACK_AMOUNT    [ expr $t(CHARGEBACK_C) - $t(CHARGEBACK_D) ]
              set REPRESENTMENT_AMOUNT [ expr $t(REPRESENTMENT_C) - $t(REPRESENTMENT_D)]
              set REFUNDS              [ expr $t(REFUNDS_C) - $t(REFUNDS_D) ]
              set SETTLED_NONBC        [ expr $t(SETTLED_NONBC_C) - $t(SETTLED_NONBC_D) ]
              set MISC_ADJUSTMENTS     [ expr $t(MISC_ADJUSTMENTS_C) - $t(MISC_ADJUSTMENTS_D)]
              set DISCOUNT             [ expr $t(DISCOUNT_C) - $t(DISCOUNT_D) ]
              set ACH_RESUB            [ expr $t(ACH_RESUB_C) - $t(ACH_RESUB_D)]
              set GRAND_SETTLED_BC     [ expr $GRAND_SETTLED_BC + $SETTLED_BC ]
              set GRAND_NETDEPOSIT           [ expr $GRAND_NETDEPOSIT +  $NETDEPOSIT ]
              set GRAND_RESERVES             [ expr $GRAND_RESERVES + $RESERVES ]
              set GRAND_CHARGEBACK_AMOUNT    [ expr $GRAND_CHARGEBACK_AMOUNT + $CHARGEBACK_AMOUNT ]
              set GRAND_REPRESENTMENT_AMOUNT [ expr $GRAND_REPRESENTMENT_AMOUNT + $REPRESENTMENT_AMOUNT ]
              set GRAND_REFUNDS              [ expr $GRAND_REFUNDS + $REFUNDS ]
              set GRAND_SETTLED_NONBC        [ expr $GRAND_SETTLED_NONBC + $SETTLED_NONBC ] 
              set GRAND_MISC_ADJUSTMENTS     [ expr $GRAND_MISC_ADJUSTMENTS + $MISC_ADJUSTMENTS ]
              set GRAND_DISCOUNT             [ expr $GRAND_DISCOUNT + $DISCOUNT ]
              set GRAND_ACH_RESUB            [ expr $GRAND_ACH_RESUB + $ACH_RESUB ]       

        if {$CHARGEBACK_AMOUNT == 0 && $SETTLED_BC == 0 && $SETTLED_NONBC == 0 && $REFUNDS == 0 && $MISC_ADJUSTMENTS == 0 && $DISCOUNT == 0 && $NETDEPOSIT == 0 } {
            puts "skipping merchant, $t(ENTITY_ID)"
        } else {
          set output "$ISO,$t(ENTITY_ID),$NAME,[format "%0.2f" $SETTLED_BC],[format "%0.2f" $SETTLED_NONBC]"
          set output "$output,[format "%0.2f" $CHARGEBACK_AMOUNT],[format "%0.2f" $REPRESENTMENT_AMOUNT]"
          set output "$output,[format "%0.2f" $REFUNDS],[format "%0.2f" $MISC_ADJUSTMENTS],[format "%0.2f" $ACH_RESUB]"
          puts $cur_file "$output,[format "%0.2f" $RESERVES],[format "%0.2f" $DISCOUNT],[format "%0.2f" $NETDEPOSIT]\r"
        }
      }
          set allout " ,,TOTAL:,[format "%0.2f" $GRAND_SETTLED_BC],[format "%0.2f" $GRAND_SETTLED_NONBC]"
          set allout "$allout,[format "%0.2f" $GRAND_CHARGEBACK_AMOUNT],[format "%0.2f" $GRAND_REPRESENTMENT_AMOUNT]"
          set allout "$allout,[format "%0.2f" $GRAND_REFUNDS],[format "%0.2f" $GRAND_MISC_ADJUSTMENTS]"
          set allout "$allout,[format "%0.2f" $GRAND_ACH_RESUB],[format "%0.2f" $GRAND_RESERVES]"
          puts $cur_file "$allout,[format "%0.2f" $GRAND_DISCOUNT],[format "%0.2f" $GRAND_NETDEPOSIT]\r"
          close $cur_file
          if {$mode == "TEST"} {
              exec echo "Please see attached." | mutt -a "$cur_file_name" -s "$file_name" "$SCRIPT_USER@jetpay.com"
          } elseif {$mode == "PROD"} {
              exec echo "Please see attached." | mutt -a "$cur_file_name" -s "$file_name" "reports-clearing@jetpay.com,operations@jetpay.com"
          }
}

if { $argc == 0 } {  

      puts "INSTITUTION 105 "    
     ach_report 105

     
     
} elseif { $argc == 1 } {  
    if { $institution_id == "ALL" } {
    
    	puts "INSTITUTION 105 "    
     	ach_report 105 
     
    } else {
          puts "INSTITUTION $institution_id "  
          ach_report $institution_id      
          exit 0
    }        
} else  {  
    puts "INSTITUTION $institution_id "  
    ach_report $institution_id
    exit 0
} 

oraclose $ach_cursor1
oraclose $ach_cursor2
oralogoff $handler
