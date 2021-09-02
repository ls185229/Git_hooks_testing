#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

###################       MODIFICATION HISTORY        ##########################
#
# Version 1.03 Sunny Yang 11-19-2008
# ----- Add in rolling reserve
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
#################################################################################
##   ******************        USAGE        ***************************
##   ----- To run this file on current date: filename after prompt 
##   ----- To run this file on previous date: filename yyyymmdd
##   ----- To run this file for specified inst: filename inst_id
##
##   ******************************************************************

#Environment veriables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(SEC_DB)
set authdb $env(RPT_DB)

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
if {[catch {set handler [oralogon masclr/masclr@$clrdb]} result]} {
  exec echo "merric-ach-statement.tcl failed to run" | mailx -r $mailfromlist -s "merric-ach-statement.tcl  failed to run" $mailtolist
  exit
}

set ach_cursor1          [oraopen $handler]
set ach_cursor2          [oraopen $handler]

#****************************************************************************************************************
#*************************************       time settings and arguments         ********************************
#****************************************************************************************************************

## by default, ACH runs every day for all institution and generate one report for each institution
## in another word, if running report without arguments, then it will run on the current date for all institution
## if run report on secified date and institution, then take arguments from command line
## and from prompts

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
      puts "*** Running today's reports: $report_date ***"
      
} elseif { $argc == 1 } {
      set input [string trim [lindex $argv 0]]
      if { [string length $input ] == 3 } {
           set institution_id      $input
           set report_date         [string toupper [clock format [clock scan "-0 day"] -format %d-%b-%y]]
      } elseif { [string length $input ] == 8 } {
           set report_date     $input
           set institution_id   "ALL"
      } elseif { [string length $input ] != 8 || [string length $input ] != 3 } {
         puts "INSTITUTION ID SHOULD BE 3 DIGITS! "
         puts "REPORT DATE SHOULD BE 8 DIGITS! "
         puts "PLEASE START OVER! "
      }
      set name_date $report_date
      #set report_date         [clock format [ clock scan $report_date ]]
      set report_month        [ string toupper [clock format [clock scan " $report_date -0 day " ] -format %B]] 
      set report_year         [clock format [clock scan " $report_date -0 day " ] -format %Y]
      set short_report_month  [ string toupper [clock format [clock scan " $report_date -0 day " ] -format %b]] 
      set short_report_year   [clock format [clock scan " $report_date -0 day " ] -format %y]
      set title_date          [clock format [clock scan "$report_date -0 day"] -format %Y%m%d]
      set report_date         [ string toupper [clock format [ clock scan " $report_date -0 day " ] -format %d-%b-%y ]]
      set CUR_JULIAN_DATEX    [ clock scan "$report_date"  -base [clock seconds] ]
      set CUR_JULIAN_DATEX    [clock format $CUR_JULIAN_DATEX -format "%y%j"]
      set CUR_JULIAN_DATEX    [string range $CUR_JULIAN_DATEX 1 4 ]      
      
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
      set name_date           $report_date
      #set report_date         [clock format [ clock scan $report_date ]]
      set report_month        [ string toupper [clock format [clock scan " $report_date -0 day " ] -format %B]] 
      set report_year         [clock format [clock scan " $report_date -0 day " ] -format %Y]
      set short_report_month  [ string toupper [clock format [clock scan " $report_date -0 day " ] -format %b]] 
      set short_report_year   [clock format [clock scan " $report_date -0 day " ] -format %y]
      set title_date          [clock format [clock scan "$report_date -0 day"] -format %Y%m%d]
      set report_date         [ string toupper [clock format [ clock scan " $report_date -0 day " ] -format %d-%b-%y ]]
      set CUR_JULIAN_DATEX    [ clock scan "$report_date"  -base [clock seconds] ]
      set CUR_JULIAN_DATEX    [clock format $CUR_JULIAN_DATEX -format "%y%j"]
      set CUR_JULIAN_DATEX    [string range $CUR_JULIAN_DATEX 1 4 ]
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
      #set report_date         [clock format [ clock scan $report_date ]]
      set name_date $report_date
      set report_month        [ string toupper [clock format [clock scan " $report_date -0 day " ] -format %B]] 
      set report_year         [ clock format [clock scan " $report_date -0 day " ] -format %Y]
      set short_report_month  [ string toupper [clock format [clock scan " $report_date -0 day " ] -format %b]] 
      set short_report_year   [ clock format [clock scan " $report_date -0 day " ] -format %y]
      set title_date          [ clock format [clock scan "$report_date -0 day"] -format %Y%m%d]
      set report_date         [ string toupper [clock format [ clock scan " $report_date -0 day " ] -format %d-%b-%y ]]
      set CUR_JULIAN_DATEX    [ clock scan "$report_date"  -base [clock seconds] ]
      set CUR_JULIAN_DATEX    [ clock format $CUR_JULIAN_DATEX -format "%y%j"]
      set CUR_JULIAN_DATEX    [ string range $CUR_JULIAN_DATEX 1 4 ]
}

###**************************************************************************************************************###
###**************************************************************************************************************###

proc ach_report { institution_num } {
  
      #global  institution_id
      global  ach_cursor1 ach_cursor2
      global  title_date report_date report_month report_year short_report_month short_report_year name_date
      global  CUR_JULIAN_DATEX

      #set cur_file_name    "../INST_$institution_num/UPLOAD/$institution_num.REPORT.ACH.$CUR_JULIAN_DATEX.$title_date.001.csv"
      #set cur_file_name    "../../../../../clearing/filemgr/JOURNALS/INST_$institution_num/UPLOAD/$institution_num.REPORT.ACH.$CUR_JULIAN_DATEX.$title_date.001.csv"
      set cur_file_name    "/clearing/filemgr/JOURNALS/INST_$institution_num/UPLOAD/$institution_num.REPORT.ACH.$CUR_JULIAN_DATEX.$name_date.001.csv"
      #testing at sy home  set cur_file_name    "./UPLOAD/$institution_num.REPORT.ACH.$CUR_JULIAN_DATEX.$name_date.001.csv"
      set file_name        "$institution_num.REPORT.ACH.$CUR_JULIAN_DATEX.$name_date.001.csv"
      #set file_name        "$institution_num.REPORT.ACH.$CUR_JULIAN_DATEX.$title_date.001.csv"
      set cur_file         [open "$cur_file_name" w]
      
      puts $cur_file "ACH REPORT"
      puts $cur_file "DATE:,$report_date\n"
      puts $cur_file "ISO#,Merchant ID, Merchant Name,Settle Bankcards, Settle NonBankcards,Chargeback Amount, Representment, Refunds,Misc Adj., ACH Resub., Reserves, Fees, Net Deposit\r\n"
      
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

      set query_string " select unique mtl.entity_id as ENTITY_ID, acq.parent_entity_id as PARENT_ENTITY_ID, acq.entity_dba_name as ENTITY_DBA_NAME, acq.actual_start_date as ACTUAL_START_DATE, mtl.PAYMENT_SEQ_NBR,  
                           sum(case when(mtl.tid_settl_method = 'C' ) then mtl.amt_original else 0 end) as TOTAL_C_BC,
                           sum(case when(mtl.tid_settl_method = 'D' ) then mtl.amt_original else 0 end) as TOTAL_D_BC,
                          (sum(case when( mtl.tid_settl_method = 'C' AND \
                                          mtl.CARD_SCHEME in ('04', '05') AND \
                                          mtl.tid not in ('010003015102', '010003015201', '010003015210', '010003005301', '010123005102','010003010102') AND \
                                          substr(mtl.tid, 1,6) not in ('010004','010040','010050','010080') AND \
                                          substr(mtl.tid, 1,8) not in ('01000705')) then mtl.amt_original else 0 end) \
                                            - sum(case when (tid = '010123005101' ) then mtl.amt_original else 0 end )) as SETTLED_C_BC , 
                           sum(case when(mtl.tid_settl_method = 'C' AND mtl.tid  in ('010005090000', '010005090001')) then mtl.amt_original else 0 end) as SPLIT_D,
                           sum(case when(mtl.tid_settl_method <> 'C' AND mtl.tid  in ('010005090000', '010005090001')) then mtl.amt_original else 0 end) as SPLIT_C,
                           sum(case when(mtl.tid_settl_method = 'C' AND mtl.tid  in ('010005050000', '010005050001', '010007050000', '010007050001')) then mtl.amt_original else 0 end) as RESERVES_C,
                           sum(case when(mtl.tid_settl_method <> 'C' AND mtl.tid  in ('010005050000', '010005050001', '010007050000', '010007050001')) then mtl.amt_original*-1 else 0 end) as RESERVES_D,
                           sum(case when(mtl.tid_settl_method = 'C' AND mtl.tid  in ('010003015101', '010003015102', '010003015201', '010003015210')) then mtl.amt_original else 0 end) as CHARGEBACK_C,
                           sum(case when(mtl.tid_settl_method <> 'C' AND mtl.tid  in ('010003015101', '010003015102', '010003015201', '010003015210')) then mtl.amt_original else 0 end) as CHARGEBACK_D,
                           sum(case when(mtl.tid_settl_method = 'C' AND mtl.tid  in ('010003005301', '010003005401', '010003010102')) then mtl.amt_original else 0 end) as REPRESENTMENT_C,
                           sum(case when(mtl.tid_settl_method <> 'C' AND mtl.tid  in ('010003005301', '010003005401', '010003010102')) then mtl.amt_original else 0 end) as REPRESENTMENT_D,
                           sum(case when(mtl.tid_settl_method = 'C' AND mtl.tid  in ('010003005102')) then mtl.amt_original else 0 end) as REFUNDS_C,
                           sum(case when(mtl.tid_settl_method <> 'C' AND mtl.tid  in ('010003005102')) then mtl.amt_original else 0 end) as REFUNDS_D,
                           sum(case when(mtl.tid_settl_method = 'C' AND mtl.tid  in ('010003005101', '010003005102', '010123005101', '010123005102' ) AND mtl.CARD_SCHEME not in ('04', '05')) then mtl.amt_original else 0 end) as SETTLED_NONBC_C,
                           sum(case when(mtl.tid_settl_method <> 'C' AND mtl.tid  in ('010003005101', '010003005102', '010123005101', '010123005102'  ) AND mtl.CARD_SCHEME not in ('04', '05')) then mtl.amt_original else 0 end) as SETTLED_NONBC_D,
                           sum(case when(mtl.tid_settl_method = 'C' AND ( substr(mtl.tid, 1,6) = '010008' OR substr(mtl.tid, 1,6) = '010042' OR substr(mtl.tid, 1,6) = '010051')) then mtl.amt_original else 0 end) as MISC_ADJUSTMENTS_C,
                           sum(case when(mtl.tid_settl_method <> 'C' AND ( substr(mtl.tid, 1,6) = '010008' OR substr(mtl.tid, 1,6) = '010042' OR substr(mtl.tid, 1,6) = '010051')) then mtl.amt_original else 0 end) as MISC_ADJUSTMENTS_D,
                           sum(case when(mtl.tid_settl_method = 'C' AND ( substr(mtl.tid, 1,8) = '01000507' OR substr(mtl.tid, 1,6) = '010004' OR substr(mtl.tid, 1,6) = '010040' OR substr(mtl.tid, 1,6) = '010050' OR substr(mtl.tid, 1,6) = '010080')) then mtl.amt_original else 0 end) as DISCOUNT_C,
                           sum(case when(mtl.tid_settl_method <> 'C' AND ( substr(mtl.tid, 1,8) = '01000507' OR substr(mtl.tid, 1,6) = '010004' OR substr(mtl.tid, 1,6) = '010040' OR substr(mtl.tid, 1,6) = '010050' OR substr(mtl.tid, 1,6) = '010080')) then mtl.amt_original else 0 end) as DISCOUNT_D,
                           sum(case when(mtl.tid_settl_method = 'C' AND mtl.tid  in ('010007150000', '010007150001')) then mtl.amt_original else 0 end) as ACH_RESUB_C,
                           sum(case when(mtl.tid_settl_method <> 'C' AND mtl.tid  in ('010007150000', '010007150001')) then mtl.amt_original else 0 end) as ACH_RESUB_D   
                        from mas_trans_log mtl, acq_entity acq 
                        where mtl.entity_id = acq.entity_id
                            and mtl.institution_id = '$institution_num'
                            and mtl.SETTL_FLAG = 'Y'
                            and mtl.PAYMENT_SEQ_NBR in (select PAYMENT_SEQ_NBR
                                                    from ACCT_ACCUM_DET
                                                    where PAYMENT_PROC_DT like '%$report_date%'
                                                     and institution_id = '$institution_num'
                                                     and payment_cycle = '1'
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
              
              set SETTLED_BC           [ expr $t(SETTLED_C_BC) - $t(SPLIT_C) ]  ;# split fund
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
          puts $cur_file "$ISO,$t(ENTITY_ID),$NAME,[format "%0.2f" $SETTLED_BC],[format "%0.2f" $SETTLED_NONBC],[format "%0.2f" $CHARGEBACK_AMOUNT],[format "%0.2f" $REPRESENTMENT_AMOUNT],[format "%0.2f" $REFUNDS],[format "%0.2f" $MISC_ADJUSTMENTS],[format "%0.2f" $ACH_RESUB],[format "%0.2f" $RESERVES],[format "%0.2f" $DISCOUNT],[format "%0.2f" $NETDEPOSIT]\r"
        }
##SYANG        puts $cur_file "$ISO,$t(ENTITY_ID),$NAME,[format "%0.2f" $SETTLED_BC],[format "%0.2f" $SETTLED_NONBC],[format "%0.2f" $CHARGEBACK_AMOUNT],[format "%0.2f" $REPRESENTMENT_AMOUNT],[format "%0.2f" $REFUNDS],[format "%0.2f" $MISC_ADJUSTMENTS],[format "%0.2f" $ACH_RESUB],[format "%0.2f" $RESERVES],[format "%0.2f" $DISCOUNT],[format "%0.2f" $NETDEPOSIT]\r"
      }
          puts $cur_file " ,,TOTAL:,[format "%0.2f" $GRAND_SETTLED_BC],[format "%0.2f" $GRAND_SETTLED_NONBC],[format "%0.2f" $GRAND_CHARGEBACK_AMOUNT],[format "%0.2f" $GRAND_REPRESENTMENT_AMOUNT],[format "%0.2f" $GRAND_REFUNDS],[format "%0.2f" $GRAND_MISC_ADJUSTMENTS],[format "%0.2f" $GRAND_ACH_RESUB],[format "%0.2f" $GRAND_RESERVES],[format "%0.2f" $GRAND_DISCOUNT],[format "%0.2f" $GRAND_NETDEPOSIT]\r"
          close $cur_file 
          exec uuencode $cur_file_name $file_name | mailx -r clearing@jetpay.com -s $file_name clearing@jetpay.com 
}

if { $argc == 0 } {
  
    puts "INSTITUTION 101 "    
    ach_report 101
    
   # puts "INSTITUTION 105 "    
   # ach_report 105

    puts "INSTITUTION 107 "    
    ach_report 107
} elseif { $argc == 1 } {
  
    if { $institution_id == "ALL" } {
        
          puts "INSTITUTION 101 "    
          ach_report 101
          
         # puts "INSTITUTION 105 "    
         # ach_report 105
      
         puts "INSTITUTION 107 "    
         ach_report 107
    } else {
          puts "INSTITUTION $institution_id "  
          ach_report $institution_id
      
          exit 0
    }
        
} elseif { $argc == 2 } { 
          puts "INSTITUTION $institution_id "
          ach_report $institution_id

} else  {
  
    puts "INSTITUTION $institution_id "  
    ach_report $institution_id

    exit 0
} 

oraclose $ach_cursor1
oraclose $ach_cursor2
