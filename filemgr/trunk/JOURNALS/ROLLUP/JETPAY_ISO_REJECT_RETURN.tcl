#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

##################################################################################
# Versopm 0.02 Sunny Yang 06-02-2009
# ----- take off assist from email to list for regular report delievery
#
# Version 0.01 Sunny Yang 02-20-2008
# ----- it is possible for one reject has two reason codes.
# ----- change made to take off duplication
#
# Version 0.01 Sunny Yang 12-10-2007
# 
# 
##################################################################################

#Environment veriables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
#set clrdb $env(SEC_DB)
#set authdb $env(RPT_DB)
set clrdb $env(CLR4_DB)
set authdb $env(TSP4_DB)

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

##################################################################################


package require Oratcl
if {[catch {set handlerM [oralogon masclr/masclr@$clrdb]} result]} {
  puts ">>>$result<<<"
  exec echo "Reject Report failed to run" | mailx -r $mailfromlist -s "Reject Report failed to run" $mailtolist
  exit
}

set fetch_cursorM1 [oraopen $handlerM]
set fetch_cursorM2 [oraopen $handlerM]
set fetch_cursorM3 [oraopen $handlerM]
set fetch_cursorM4 [oraopen $handlerM]
set fetch_cursorM5 [oraopen $handlerM]
set fetch_cursorM6 [oraopen $handlerM]

if { $argc == 0 } {
      set today            [string toupper  [clock format [clock scan "today"]  -format  %d-%b-%y ]]
      set tomorrow         [string toupper  [clock format [clock scan "+1 day"] -format %d-%b-%y]]
      set yesterday        [string toupper [clock format [clock scan "-1 day"] -format %d-%b-%y]]
      set filedate         [clock format [clock scan "today"] -format %Y%m%d]
      set CUR_SET_TIME     [clock seconds]
      set CUR_JULIAN_DATEX [string range [clock format $CUR_SET_TIME -format "%y%j"] 1 4]
} elseif {$argc == 1 && [string length [lindex $argv 0]] == 8 } {
      set today            [lindex $argv 0 ]
      set CUR_JULIAN_DATEX [clock scan "$today"  -base [clock seconds] ]
      set today            [string toupper  [clock format [clock scan $today]  -format  %d-%b-%y ]]
      set tomorrow         [string toupper [clock format [clock scan " $today +1 day"] -format %d-%b-%y]]
      set yesterday        [string toupper [clock format [clock scan " $today -1 day"] -format %d-%b-%y]]
      set filedate         [clock format [clock scan $today] -format %Y%m%d]
      set CUR_JULIAN_DATEX        [ clock format $CUR_JULIAN_DATEX -format "%y%j"]
      set CUR_JULIAN_DATEX        [ string range $CUR_JULIAN_DATEX 1 4 ]  
}
#################################################
# example settings for testing on a certain date
#################################
#set today            18-FEB-08
#set tomorrow         19-FEB-08
#set yesterday        17-FEB-08
#set filedate         20080218
#################################################

#set cur_file_name    "./LOGS/ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.001.csv"
set cur_file_name    "./UPLOAD/ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.001.csv"
set file_name        "ROLLUP.OUTGOING_REJECT.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.001.csv"
set cur_file         [open "$cur_file_name" w]

puts $cur_file  "JETPAY"
puts $cur_file  "ISO OUTGOING REJECT REPORT"
puts $cur_file  "REPORT DATE: , $today "
puts $cur_file  "       "

#set cur_file_name2   "./LOGS/ROLLUP.INCOMING_RETURN.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.002.csv"
set cur_file_name2   "./ARCHIVE/ROLLUP.INCOMING_RETURN.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.002.csv"
set file_name2       "ROLLUP.INCOMING_RETURN.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.002.csv"
set cur_file2        [open "$cur_file_name2" w]

puts $cur_file2 "JETPAY"
puts $cur_file2 "ISO INCOMING RETURN REPORT"
puts $cur_file2 "REPORT DATE:  , $today "
puts $cur_file2 "       "

proc report {value} {

global fetch_cursorM1  fetch_cursorM2 fetch_cursorM3 fetch_cursorM4 fetch_cursorM5 fetch_cursorM6
global cur_file cur_file2 today yesterday tomorrow
#global fdate report_ddate report_mdate test_cursor1 cur_file date fetch_cursor tomorrow yesterday report_yesterday_mddate report_mddate
set AMOUNT      0
set MC_TOTAL1   0
set MC_AMOUNT1  0
set VS_TOTAL1   0
set MC_AMOUNT1  0
set MC_TOTAL2   0
set MC_AMOUNT2  0
set VS_TOTAL2   0
set VS_AMOUNT2  0
set MC_C_TOTAL1 0
set MC_C_TOTAL2 0
set MC_D_TOTAL1 0
set MC_D_TOTAL2 0
set VS_C_TOTAL1 0
set VS_C_TOTAL2 0
set VS_D_TOTAL1 0
set VS_D_TOTAL2 0
set INDICATOR   0

puts $cur_file "PLAN TYPE:  , MASTER CARD"
puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE, INDICATOR"

set TRANS_SEQ_NBR 0

     set query_stringM1 "SELECT unique m.TRANS_SEQ_NBR, substr(m.MSG_ERROR_IND, 8,4) as REASON, 
                                to_char(ep.AMT_TRANS /100, '999999999.00') as AMOUNT,
                                ep.pan as ACCT, ep.EVENT_LOG_DATE as A_DATE, ep.institution_id, ep.CARD_SCHEME,
                                ind.ACTIVITY_DT, ind.arn as ARN, ind.tid, tid.TID_SETTL_METHOD as INDICATOR, TID.DESCRIPTION AS TRAN_CODE
                         FROM IPM_REJECT_MSG m, ep_event_log ep, in_draft_main ind, tid
                         WHERE m.TRANS_SEQ_NBR = ep.TRANS_SEQ_NBR
                               AND ind.TRANS_SEQ_NBR = ep.trans_seq_nbr
                               AND ind.tid = tid.tid
                               AND ep.CARD_SCHEME = '05'
                               AND ep.TRANS_SEQ_NBR in (SELECT unique TRANS_SEQ_NBR
                                                        FROM ep_event_log
                                                        WHERE EMS_ITEM_TYPE in ( 'CR1', 'CR2')
                                                             AND Event_log_date like '$today%'
                                                             AND institution_id  in ($value))
                        ORDER BY   m.TRANS_SEQ_NBR "
     puts $query_stringM1                                             
     orasql $fetch_cursorM1 $query_stringM1
     while {[orafetch $fetch_cursorM1 -dataarray s -indexbyname] != 1403} {
      #puts "I am in"
      
        if { $TRANS_SEQ_NBR != $s(TRANS_SEQ_NBR)} {
          
              set TRANS_SEQ_NBR  $s(TRANS_SEQ_NBR)
              set ACCOUNT_NBR_MC [string replace $s(ACCT) 5 13 xxxxxxxxx ]
              set DATE $s(A_DATE)
              set REASON $s(REASON)
              set MC_AMOUNT1 $s(AMOUNT)
              set INDICATOR $s(INDICATOR)
              set REF_NO $s(ARN)
              set TRAN_CODE $s(TRAN_CODE)
              set CARD_TYPE MC
              
   #puts " MC_AMOUNT1: $MC_AMOUNT1....$INDICATOR"        
              if { $MC_AMOUNT1 != 0 } {
                
                  if { $INDICATOR == "C" } {
                    #set MC_C_TOTAL1 [ expr $MC_C_TOTAL1 + $MC_AMOUNT1 ]
                    set MC_C_TOTAL1 [ expr  [string map {, ""} $MC_C_TOTAL1] + [string map {, ""} $MC_AMOUNT1] ]
                    puts " MC_C_TOTAL1 is $MC_C_TOTAL1"
                  } else {
                    #set MC_D_TOTAL1 [ expr $MC_D_TOTAL1 + $MC_AMOUNT1 ]
                    set MC_D_TOTAL1 [ expr  [string map {, ""} $MC_D_TOTAL1] + [string map {, ""} $MC_AMOUNT1] ]
                     puts " MC_D_TOTAL1 is $MC_D_TOTAL1"
                  }
              } else {
                set MC_D_TOTAL1 0
                set MC_C_TOTAL1 0
              }
            puts $cur_file " $ACCOUNT_NBR_MC,$TRAN_CODE, $$MC_AMOUNT1,$REF_NO,$DATE,'$REASON, $INDICATOR\r\n"      
        }
     }

    puts $cur_file " >>>>> TOTAL <<<<< "
    puts $cur_file "**************************************************************,*******************"
    puts $cur_file " Master Card Outgoing Rejects Debit Subtotal:, $$MC_D_TOTAL1 "
    puts $cur_file " Master Card Outgoing Rejects Credit Subtotal:, $$MC_C_TOTAL1 "
    puts $cur_file "  "     
    puts $cur_file "PLAN TYPE: ,  VISA"
    puts $cur_file "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR "
    
    set TRANS_SEQ_NBR 0
    set INDICATOR     0
    
      set query_stringM2 "SELECT unique v.TRANS_SEQ_NBR, v.return_reason_cd1 as REASON, 
                                 to_char(ep.AMT_TRANS /100, '999999999.00') as AMOUNT,
                                 ep.pan as ACCT, ep.EVENT_LOG_DATE as A_DATE, ep.institution_id, ep.CARD_SCHEME,
                                 ind.ACTIVITY_DT, ind.arn as ARN, ind.tid, tid.TID_SETTL_METHOD as INDICATOR, tid.DESCRIPTION as TRAN_CODE
                          FROM visa_rtn_rclas_adn v, ep_event_log ep, in_draft_main ind, tid
                          WHERE v.TRANS_SEQ_NBR = ep.TRANS_SEQ_NBR
                                AND ind.TRANS_SEQ_NBR = ep.trans_seq_nbr
                                AND ind.tid = tid.tid
                                AND ep.CARD_SCHEME = '04'
                                AND ep.TRANS_SEQ_NBR in (SELECT unique TRANS_SEQ_NBR
                                                         FROM ep_event_log
                                                         WHERE EMS_ITEM_TYPE in ( 'CR1', 'CR2')
                                                              AND Event_log_date like '$today%'
                                                              AND institution_id  in ($value))
                          ORDER BY   v.TRANS_SEQ_NBR "
      puts $query_stringM2                                                   
      orasql $fetch_cursorM2 $query_stringM2
      while {[orafetch $fetch_cursorM2 -dataarray ss -indexbyname] != 1403} {
        
         if { $TRANS_SEQ_NBR != $ss(TRANS_SEQ_NBR)} {
          
              set TRANS_SEQ_NBR  $ss(TRANS_SEQ_NBR)
             set ACCOUNT_NBR_VS [string replace $ss(ACCT) 5 13 xxxxxxxxx ]
             set DATE $ss(A_DATE)
             set REASON $ss(REASON)
             set VS_AMOUNT1 $ss(AMOUNT)
             #set VS_TOTAL1 [ expr $VS_TOTAL1 + $VS_AMOUNT1 ]
             set REF_NO $ss(ARN)
             set TRAN_CODE $ss(TRAN_CODE)
             set INDICATOR $ss(INDICATOR)
             set CARD_TYPE VS
             if { $VS_AMOUNT1 != 0 } {
                
                  if { $INDICATOR == "C" } {
                    #set VS_C_TOTAL1 [ expr $VS_C_TOTAL1 + $VS_AMOUNT1 ]
                    set VS_C_TOTAL1 [ expr  [string map {, ""} $VS_C_TOTAL1] + [string map {, ""} $VS_AMOUNT1] ]
                    puts " vs_c_total1 is $VS_C_TOTAL2"
                  } else {
                    #set VS_D_TOTAL1 [ expr $VS_D_TOTAL1 + $VS_AMOUNT1 ]
                    set VS_C_TOTAL1 [ expr  [string map {, ""} $VS_C_TOTAL1] + [string map {, ""} $VS_AMOUNT1] ]
                    puts " vs_d_total1 is $VS_D_TOTAL2"
                  }
              } else {
                set VS_D_TOTAL1 0
                set VS_C_TOTAL1 0
              }
             #if { $s(TRAN_CD) == 010003005101 } {
             #     set TRAN_CODE CREDIT
             # } else { 
             #     set TRAN_CODE DEBT
             # }
              #
             puts $cur_file " $ACCOUNT_NBR_VS,$TRAN_CODE,$$VS_AMOUNT1,$REF_NO,$DATE,'$REASON, $INDICATOR\r\n"     
         }
      }

      puts $cur_file " >>>>> TOTAL <<<<< "
      puts $cur_file "**************************************************************,*******************"
      puts $cur_file " Visa Card Outgoing Rejects Debit Subtotal:, $$VS_D_TOTAL1 "
      puts $cur_file " Visa Card Outgoing Rejects Credit Subtotal:, $$VS_C_TOTAL1 "
#puts $cur_file2 "OUTGOING REJECTS       "

puts $cur_file2 "  "
puts $cur_file2 "PLAN TYPE: ,MASTER CARD "
puts $cur_file2 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"

        set query_stringM3 " SELECT to_char(ind.amt_trans /100, '999999999.00') as AMOUNT,
                                    ind.pan as ACCT, ind.activity_dt as I_DATE,  ind.card_scheme, ind.arn as ARN, tid.TID_SETTL_METHOD as INDICATOR,
                                    tid.DESCRIPTION as TRAN_CODE
                             FROM in_draft_main ind, tid
                             WHERE ind.tid = tid.tid
                                  AND ind.msg_text_block like '%JPREJECT%'
                                  AND ind.card_scheme = '05'
                                  AND ind.activity_dt like '$yesterday%'
                                  AND ind.SEC_DEST_INST_ID in ($value)"
        orasql $fetch_cursorM3 $query_stringM3
        while {[orafetch $fetch_cursorM3 -dataarray inr -indexbyname ] != 1403 } {
              set MC_ACCOUNT_NBR [string replace $inr(ACCT) 5 13 xxxxxxxxx ]
              set MC_DATE $inr(I_DATE)
              set MC_REASON NA
              set MC_AMOUNT2 $inr(AMOUNT)
              set MC_REF_NO $inr(ARN)
              set MC_TRAN_CODE $inr(TRAN_CODE)
              set INDICATOR $inr(INDICATOR) 
              if { $MC_AMOUNT2 != 0 } {
                  if { $INDICATOR == "C" } {
                    #set MC_C_TOTAL2 [ expr $MC_C_TOTAL2 + $MC_AMOUNT2 ]
                    set MC_C_TOTAL2 [ expr  [string map {, ""} $MC_C_TOTAL2] + [string map {, ""} $MC_AMOUNT2] ]
                     puts " MC_C_TOTAL2 is $MC_C_TOTAL2"
                  } else {
                    #set MC_D_TOTAL2 [ expr $MC_D_TOTAL2 + $MC_AMOUNT2 ]
                    set MC_D_TOTAL2 [ expr  [string map {, ""} $MC_D_TOTAL2] + [string map {, ""} $MC_AMOUNT2] ]
                     puts " MC_D_TOTAL2 is $MC_D_TOTAL2"
                  }
              } else {
                set MC_D_TOTAL2 0
                set MC_C_TOTAL2 0
              }
          puts $cur_file2 " $MC_ACCOUNT_NBR,$MC_TRAN_CODE,$$MC_AMOUNT2,$MC_REF_NO,$MC_DATE,$MC_REASON, $INDICATOR\r\n"  
        }
          
          puts $cur_file2 " >>>>> TOTAL <<<<< "
          puts $cur_file2 "**************************************************************,*******************"
          puts $cur_file2 " Master Card Incoming Returns Debit Subtotal:, $$MC_D_TOTAL2 "
          puts $cur_file2 " Master Card Incoming Returns Credit Subtotal:, $$MC_C_TOTAL2 "
          
          puts $cur_file2 "  "          
          puts $cur_file2 "PLAN TYPE: ,VISA"
          puts $cur_file2 "ACCOUNT NUMBER, TRAN CODE, AMOUNT, REFERENCE NUMBER, DATE, REASON CODE,  INDICATOR"
          set INDICATOR   0
          
        set query_stringM4 " SELECT to_char(ind.amt_trans /100, '999999999.00') as AMOUNT,
                                    ind.pan as ACCT, ind.activity_dt as I_DATE,  ind.card_scheme, ind.arn as ARN,
                                    tid.TID_SETTL_METHOD as INDICATOR, tid.DESCRIPTION as TRAN_CODE
                             FROM in_draft_main ind, tid
                             WHERE ind.tid = tid.tid
                                  AND ind.msg_text_block like '%JPREJECT%'
                                  AND ind.card_scheme = '04'
                                  AND ind.activity_dt like '$yesterday%'
                                  AND ind.SEC_DEST_INST_ID in ($value)"
        orasql $fetch_cursorM4 $query_stringM4
        while {[orafetch $fetch_cursorM4 -dataarray inr2 -indexbyname ] != 1403 } {
              set VS_ACCOUNT_NBR [string replace $inr2(ACCT) 5 13 xxxxxxxxx ]
              set DATE $inr2(I_DATE)
              set VS_REASON NA
              set VS_AMOUNT2 $inr2(AMOUNT)
              #set VS_TOTAL2 [ expr $VS_TOTAL2 + $VS_AMOUNT2 ]
              set VS_REF_NO $inr2(ARN)
              set TRAN_CODE $inr2(TRAN_CODE)
              set INDICATOR $inr2(INDICATOR)
              set CARD_TYPE VS
              if { $VS_AMOUNT2 != 0 } {
                
                  if { $INDICATOR == "C" } {
                    #set VS_C_TOTAL2 [ expr $VS_C_TOTAL2 + $VS_AMOUNT2 ]
                    set VS_C_TOTAL2 [ expr  [string map {, ""} $VS_C_TOTAL2] + [string map {, ""} $VS_AMOUNT2] ]
                    puts " vs_c_total2 is $VS_C_TOTAL2"
                  } else {
                    #set VS_D_TOTAL2 [ expr $VS_D_TOTAL2 + $VS_AMOUNT2 ]
                    set VS_D_TOTAL2 [ expr  [string map {, ""} $VS_D_TOTAL2] + [string map {, ""} $VS_AMOUNT2] ]
                    puts " vs_d_total2 is $VS_D_TOTAL2"
                  }
              } else {
                set VS_D_TOTAL2 0
                set VS_C_TOTAL2 0
              }
              puts $cur_file2 " $VS_ACCOUNT_NBR,$TRAN_CODE, $$VS_AMOUNT2,$VS_REF_NO,$DATE,$VS_REASON, $INDICATOR\r\n"  
        }
        puts $cur_file2 " >>>>> TOTAL <<<<< "
        puts $cur_file2 "**************************************************************,*******************"
        puts $cur_file2 " Visa Card Incoming Returns Debit Subtotal:, $$VS_D_TOTAL2 "
        puts $cur_file2 " Visa Card Incoming Returns Credit Subtotal:, $$VS_C_TOTAL2 "
}
  puts $cur_file "ISO:,101"
  report 101
  puts $cur_file " "
  puts $cur_file " "
  puts $cur_file2 " "
  puts $cur_file2 " "
  puts $cur_file "ISO:,107"
  report 107
  puts $cur_file " "
  puts $cur_file " "
  puts $cur_file2 " "
  puts $cur_file2 " "
  puts $cur_file "ISO:,ALL"
  report "'101','107'"


  close $cur_file
  close $cur_file2
###################################################
# keep all clearing email to clearing email account
###########
exec uuencode $cur_file_name $file_name | mailx -r $mailfromlist -s $file_name clearing@jetpay.com
exec uuencode $cur_file_name2 $file_name2 | mailx -r $mailfromlist -s $file_name2 clearing@jetpay.com

oraclose $fetch_cursorM1
oraclose $fetch_cursorM2
oraclose $fetch_cursorM3
oraclose $fetch_cursorM4
