#!/usr/bin/env tclsh
#/clearing/filemgr/.profile
#===============================================================================
#===========================     MODIFY HISTORY     ============================
#===============================================================================
#Version g1.02 rkhan 10-07-2010
# ------- 106 institutions
#
# Version 0.02 Sunny Yang 10-13-2007
# ---- Add reject counts
#
# Version 0.01 Sunny Yang 10-06-2007
# ----Combined part of queries and eliminated loops to improve performance
#
# Version 0.00 Myke Sanders ??
#
#===============================================================================
#==========================  Environment veriables  ============================
#===============================================================================
set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(SEC_DB)
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

#Mode....
#set mode "TEST"
set mode "PROD"

#===============================================================================
set fail_msg "merric-daily-detail.tcl failed to run"
package require Oratcl
    if {[catch {set handler [oralogon masclr/masclr@$clrdb]} result]} {
      puts ">>>$result<<<"
      exec echo $fail_mag | mailx -r $mailfromlist -s $fail_mag $mailtolist
      exit 1
    }

    set daily_cursor1 [oraopen $handler]
    set daily_cursor2 [oraopen $handler]
    set daily_cursor3 [oraopen $handler]
    set daily_cursor4 [oraopen $handler]
    set daily_cursor5 [oraopen $handler]
    set daily_cursor6 [oraopen $handler]
    set daily_cursor7 [oraopen $handler]
    set daily_cursor8 [oraopen $handler]
    set daily_cursor9 [oraopen $handler]
    set daily_cursor10 [oraopen $handler]
    set daily_cursor11 [oraopen $handler]
    set daily_cursor12 [oraopen $handler]
    set daily_cursor14 [oraopen $handler]
    set daily_cursor15 [oraopen $handler]
    set daily_cursor16 [oraopen $handler]
    
#===============================================================================
#                          time settings and arguments         
#===============================================================================
if { $argc == 0 } {
    set institution_num "ROLLUP"
    set fdate     [string toupper [clock format [clock scan "-0 day"] -format %b-%y]]     ;# MAR-08
    set date      [string toupper [clock format [clock scan "-0 day"] -format %d-%b-%y]]  ;# 21-MAR-08
    set filedate  [clock format [clock scan "-0 day"] -format %Y%m%d]                     ;# 20080321
    set tomorrow  [string toupper [clock format [clock scan "+1 day"] -format %d-%b-%y]]
    set yesterday [string toupper [clock format [clock scan "-1 day"] -format %d-%b-%y]]
    set report_ddate            [clock format [clock scan "-0 day"] -format %m/%d/%y]     ;# 03/21/08
    set report_mdate            [clock format [clock scan "-0 day"] -format %m/%y]
    set report_mddate           [clock format [clock scan "-0 day"] -format %m/%d]
    set report_yesterday_mddate [clock format [clock scan "-1 day"] -format %m/%d]
    set mdate     [string toupper [clock format [clock scan "-1 month"] -format %d-%b-%y]]
        orasql $daily_cursor16 "select substr(last_day('$mdate'), 1, 9) as PRE_MAS_END from dual"
        if {[orafetch $daily_cursor16 -dataarray pmtd -indexbyname] == 0} { 
               set pmonend   $pmtd(PRE_MAS_END)        
        }
    set MPRE_RECEIVE_DATE_TIME $pmonend
    set rectime1 " 13:59:59"
    set rectime2 " 14:00:00"
    set MPRE_RECEIVE_DATE_TIME  $MPRE_RECEIVE_DATE_TIME$rectime1
    set PRE_RECEIVE_DATE_TIME   $yesterday$rectime1
    set RECEIVE_DATE_TIME       $date$rectime2
    set CUR_SET_TIME [clock seconds]
    set CUR_JULIAN_DATEX [string range [clock format $CUR_SET_TIME -format "%y%j"] 1 4]
} elseif  { $argc == 1 } {
      set input [ lindex $argv 0 ]
      if { [string length $input ] != 8 && $input != "ROLLUP" && $input != "106"} {
        puts "key in report date or report institution:"
        puts "date format: yyyymmdd "        
        puts "for inst, choose from ROLLUP, 106"
        exit 1
      } elseif {[string length $input ] == 8} {
        set date [ lindex $argv 0 ]
        set institution_num "ROLLUP"
        set CUR_JULIAN_DATEX    [ clock scan "$date"  -base [clock seconds] ]   
        set fdate     [string toupper [clock format [clock scan " $date -0 day"] -format %b-%y]]     ;# MAR-08
        set filedate  [clock format   [clock scan " $date -0 day"] -format %Y%m%d]                     ;# 20080321
        set tomorrow  [string toupper [clock format [clock scan " $date +1 day"] -format %d-%b-%y]]
        set yesterday [string toupper [clock format [clock scan " $date -1 day"] -format %d-%b-%y]]
        set report_ddate            [clock format [clock scan " $date -0 day"] -format %m/%d/%y]     ;# 03/21/08
        set report_mdate            [clock format [clock scan " $date -0 day"] -format %m/%y]
        set report_mddate           [clock format [clock scan " $date -0 day"] -format %m/%d]
        set report_yesterday_mddate [clock format [clock scan " $date -1 day"] -format %m/%d]
        set date      [string toupper [clock format [clock scan " $date -0 day"] -format %d-%b-%y]]  ;# 21-MAR-08
        set mdate     [string toupper [clock format [clock scan "-1 month"] -format %d-%b-%y]]
            orasql $daily_cursor16 "select substr(last_day('$mdate'), 1, 9) as PRE_MAS_END from dual"
            if {[orafetch $daily_cursor16 -dataarray pmtd -indexbyname] == 0} { 
                   set pmonend   $pmtd(PRE_MAS_END)        
            }
        set MPRE_RECEIVE_DATE_TIME $pmonend
        set rectime1 " 13:59:59"
        set rectime2 " 14:00:00"
        set MPRE_RECEIVE_DATE_TIME  $MPRE_RECEIVE_DATE_TIME$rectime1
        set PRE_RECEIVE_DATE_TIME   $yesterday$rectime1
        set RECEIVE_DATE_TIME       $date$rectime2
        set CUR_JULIAN_DATEX        [ clock format $CUR_JULIAN_DATEX -format "%y%j"]
        set CUR_JULIAN_DATEX        [ string range $CUR_JULIAN_DATEX 1 4 ]        
      } elseif {$input == "ROLLUP" || $input == "106"} {
        set institution_num  "ROLLUP"
        set fdate     [string toupper [clock format [clock scan "-0 day"] -format %b-%y]]     ;# MAR-08
        set date      [string toupper [clock format [clock scan "-0 day"] -format %d-%b-%y]]  ;# 21-MAR-08
        set filedate  [clock format [clock scan "-0 day"] -format %Y%m%d]                     ;# 20080321
        set tomorrow  [string toupper [clock format [clock scan "+1 day"] -format %d-%b-%y]]
        set yesterday [string toupper [clock format [clock scan "-1 day"] -format %d-%b-%y]]
        set report_ddate            [clock format [clock scan "-0 day"] -format %m/%d/%y]     ;# 03/21/08
        set report_mdate            [clock format [clock scan "-0 day"] -format %m/%y]
        set report_mddate           [clock format [clock scan "-0 day"] -format %m/%d]
        set report_yesterday_mddate [clock format [clock scan "-1 day"] -format %m/%d]
        set mdate     [string toupper [clock format [clock scan "-1 month"] -format %d-%b-%y]]
            orasql $daily_cursor16 "select substr(last_day('$mdate'), 1, 9) as PRE_MAS_END from dual"
            if {[orafetch $daily_cursor16 -dataarray pmtd -indexbyname] == 0} { 
                   set pmonend   $pmtd(PRE_MAS_END)        
            }
        set MPRE_RECEIVE_DATE_TIME $pmonend
        set rectime1 " 13:59:59"
        set rectime2 " 14:00:00"
        set MPRE_RECEIVE_DATE_TIME  $MPRE_RECEIVE_DATE_TIME$rectime1
        set PRE_RECEIVE_DATE_TIME   $yesterday$rectime1
        set RECEIVE_DATE_TIME       $date$rectime2
        set CUR_SET_TIME [clock seconds]
        set CUR_JULIAN_DATEX [string range [clock format $CUR_SET_TIME -format "%y%j"] 1 4]       
      }
} elseif {$argc == 2} {
    set institution_num  [lindex $argv 0 ]
    if {$institution_num != "106" && $institution_num != "ROLLUP"} {
        puts "Wrong format! for inst, choose from ROLLUP, 106"
        exit 1
      }    
    set date [ lindex $argv 1 ]
    if { [string length $date ] != 8} {
        puts "Wrong date format, should be yyyymmdd "  
        exit 1
    }
    set CUR_JULIAN_DATEX    [ clock scan "$date"  -base [clock seconds] ]   
    set fdate     [string toupper [clock format [clock scan " $date -0 day"] -format %b-%y]]     ;# MAR-08
    set filedate  [clock format   [clock scan " $date -0 day"] -format %Y%m%d]                     ;# 20080321
    set tomorrow  [string toupper [clock format [clock scan " $date +1 day"] -format %d-%b-%y]]
    set yesterday [string toupper [clock format [clock scan " $date -1 day"] -format %d-%b-%y]]
    set report_ddate            [clock format [clock scan " $date -0 day"] -format %m/%d/%y]     ;# 03/21/08
    set report_mdate            [clock format [clock scan " $date -0 day"] -format %m/%y]
    set report_mddate           [clock format [clock scan " $date -0 day"] -format %m/%d]
    set report_yesterday_mddate [clock format [clock scan " $date -1 day"] -format %m/%d]
    set date      [string toupper [clock format [clock scan " $date -0 day"] -format %d-%b-%y]]  ;# 21-MAR-08
    set mdate     [string toupper [clock format [clock scan "$date -1 month"] -format %d-%b-%y]]
        orasql $daily_cursor16 "select substr(last_day('$mdate'), 1, 9) as PRE_MAS_END from dual"
        if {[orafetch $daily_cursor16 -dataarray pmtd -indexbyname] == 0} { 
               set pmonend   $pmtd(PRE_MAS_END)        
        }
    set MPRE_RECEIVE_DATE_TIME $pmonend
    set rectime1 " 13:59:59"
    set rectime2 " 14:00:00"
    set MPRE_RECEIVE_DATE_TIME  $MPRE_RECEIVE_DATE_TIME$rectime1
    set PRE_RECEIVE_DATE_TIME   $yesterday$rectime1
    set RECEIVE_DATE_TIME       $date$rectime2
    set CUR_JULIAN_DATEX        [ clock format $CUR_JULIAN_DATEX -format "%y%j"]
    set CUR_JULIAN_DATEX        [ string range $CUR_JULIAN_DATEX 1 4 ]
}

        set lastday " select substr(last_day('$date'), 1, 9) as MAS_END from dual"
        if {$mode == "TEST"} {
          puts "query: $lastday"
        }
        orasql $daily_cursor14 $lastday
        if {[orafetch $daily_cursor14 -dataarray ad -indexbyname] == 0} { 
               set monend   $ad(MAS_END)        
        }
puts " $clrdb: $authdb ... month-end: $monend"
puts "date: $date.. fdate: $fdate..filedate:$filedate..tomorrow:$tomorrow..yesterday:$yesterday "
puts "report_ddate:$report_ddate..report_mdate: $report_mdate.. report_mddate: $report_mddate"
puts "now it starts from [clock format [clock seconds]]"


#===============================================================================
    set prodpathm "/clearing/filemgr/JOURNALS/INST_106/UPLOAD"
    set prodpaths "/clearing/filemgr/JOURNALS"
    if {$mode == "PROD"} {
        if {$institution_num == "ROLLUP" || $institution_num == "106" } {
          set cur_file_name     "$prodpathm/ROLLUP.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.106.001.csv"
          set file_name         "ROLLUP.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.106.001.csv"          
          set cur_file          [open "$file_name" w]
        }
    } elseif {$mode == "TEST"} {
        if {$institution_num == "ROLLUP" || $institution_num == "106" } {
          set cur_file_name     "./ROLLUP.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.106.TEST.csv"
          set file_name         "ROLLUP.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.106.TEST.csv"
          set cur_file          [open "$cur_file_name" w]
        }
    }
    
    set	REP_COUNT107	0
    set	CHR_COUNT107	0
    set	MISC_COUNT107	0
    set	VISA_COUNT107	0
    set	MC_COUNT107	0
    set	AMEX_COUNT107	0
    set	DISC_COUNT107	0
    set	DB_COUNT107	0
    set	JCB_COUNT107	0
    set	VISA_AMOUNT107	0
    set	MC_AMOUNT107	0
    set	AMEX_AMOUNT107	0
    set	DISC_AMOUNT107	0
    set	DB_AMOUNT107	0
    set	JCB_AMOUNT107	0
    set	REP_AMOUNT107	0
    set	CHR_AMOUNT107	0
    set	MISC_AMOUNT107	0
    set	VS_REFUND_AMOUNT107	0
    set	MC_REFUND_AMOUNT107	0
    set	AMEX_REFUND_AMOUNT107	0
    set	DISC_REFUND_AMOUNT107	0
    set	DB_REFUND_AMOUNT107	0
    set	JCB_REFUND_AMOUNT107	0
    set DISC_COUNT107    0
    set DISC_AMOUNT107   0
    set DISC_FEE107      0
    set DISC_TOTAL107    0
    set OTHER_COUNT107   0
    set REP_FEE107       0
    
    set	REP_COUNT101	0
    set	CHR_COUNT101	0
    set	MISC_COUNT101	0
    set	VISA_COUNT101	0
    set	MC_COUNT101	0
    set	AMEX_COUNT101	0
    set	DISC_COUNT101	0
    set	DB_COUNT101	0
    set	JCB_COUNT101	0
    set	VISA_AMOUNT101	0
    set	MC_AMOUNT101	0
    set	AMEX_AMOUNT101	0
    set	DISC_AMOUNT101	0
    set	DB_AMOUNT101	0
    set	JCB_AMOUNT101	0
    set	REP_AMOUNT101	0
    set	CHR_AMOUNT101	0
    set	MISC_AMOUNT101	0
    set	VS_REFUND_AMOUNT101	0
    set	MC_REFUND_AMOUNT101	0
    set	AMEX_REFUND_AMOUNT101	0
    set	DISC_REFUND_AMOUNT101	0
    set	DB_REFUND_AMOUNT101	0
    set	JCB_REFUND_AMOUNT101	0
    set DISC_COUNT101    0
    set DISC_AMOUNT101   0
    set DISC_FEE101      0
    set DISC_TOTAL101    0
    set OTHER_COUNT101   0
    set REP_FEE101       0
    
    set	REP_COUNT_ROLL	0
    set	CHR_COUNT_ROLL	0
    set	MISC_COUNT_ROLL	0
    set	VISA_COUNT_ROLL	0
    set	MC_COUNT_ROLL	0
    set	AMEX_COUNT_ROLL	0
    set	DISC_COUNT_ROLL	0
    set	DB_COUNT_ROLL	0
    set	JCB_COUNT_ROLL	0
    set	VISA_AMOUNT_ROLL	0
    set	MC_AMOUNT_ROLL	0
    set	AMEX_AMOUNT_ROLL	0
    set	DISC_AMOUNT_ROLL	0
    set	DB_AMOUNT_ROLL	0
    set	JCB_AMOUNT_ROLL	0
    set	REP_AMOUNT_ROLL	0
    set	CHR_AMOUNT_ROLL	0
    set	MISC_AMOUNT_ROLL	0
    set	VS_REFUND_AMOUNT_ROLL	0
    set	MC_REFUND_AMOUNT_ROLL	0
    set	AMEX_REFUND_AMOUNT_ROLL	0
    set	DISC_REFUND_AMOUNT_ROLL	0
    set	DB_REFUND_AMOUNT_ROLL	0
    set	JCB_REFUND_AMOUNT_ROLL	0      
    set DISC_COUNT_ROLL    0
    set DISC_AMOUNT_ROLL   0
    set DISC_FEE_ROLL      0
    set DISC_TOTAL_ROLL    0
    set OTHER_COUNT_ROLL   0
    set REP_FEE_ROLL       0
            set TODAY_RESERVE_ROLL       0 
            set TODAY_RESERVE_PAID_ROLL  0 
            set SUB_TODAY_RESERVE_ROLL   0
            set RESERVE_ROLL             0
            set TOTAL_RESERVE_ROLL       0


      
  if {$monend == $date} {
    puts "today is $date: Run for month end transactions!"
      set daily_sales_str "  SELECT institution_id, substr(posting_entity_id, 1,6) as BIN_ID,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and card_scheme = '02') then 1 else 0 end ) as DB_COUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and card_scheme = '03') then 1 else 0 end ) as AMEX_COUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and card_scheme = '04') then 1 else 0 end ) as VS_COUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and card_scheme = '05') then 1 else 0 end ) as MC_COUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and card_scheme = '08') then 1 else 0 end ) as DISC_COUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and card_scheme = '09') then 1 else 0 end ) as JCB_COUNT,
            sum(CASE WHEN( TID in ('010003005301', '010003005401', '010003010102', '010003010101')) then 1 else 0 end) as REP_COUNT,
            sum(CASE WHEN( TID in ('010003015201', '010003015102', '010003015101', '010003015210')) then 1 else 0 end) as CHR_COUNT,
            sum(CASE WHEN( tid in ('010123005102', '010123005101', '010123005202', '010123005201')) then 1 else 0 end) as MISC_COUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and TID_SETTL_METHOD = 'C' and card_scheme = '02') then AMT_ORIGINAL else 0 end ) as DB_AMOUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and TID_SETTL_METHOD = 'C' and card_scheme = '03') then AMT_ORIGINAL else 0 end ) as AMEX_AMOUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and TID_SETTL_METHOD = 'C' and card_scheme = '04') then AMT_ORIGINAL else 0 end ) as VS_AMOUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and TID_SETTL_METHOD = 'C' and card_scheme = '05') then AMT_ORIGINAL else 0 end ) as MC_AMOUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and TID_SETTL_METHOD = 'C' and card_scheme = '08') then AMT_ORIGINAL else 0 end ) as DISC_AMOUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and TID_SETTL_METHOD = 'C' and card_scheme = '09') then AMT_ORIGINAL else 0 end ) as JCB_AMOUNT,
            sum(CASE WHEN( TID in ('010003005301', '010003005401', '010003010102', '010003010101') and TID_SETTL_METHOD = 'C') then AMT_ORIGINAL else 0 end ) as REP_C_AMOUNT,
            sum(CASE WHEN( TID in ('010003005301', '010003005401', '010003010102', '010003010101') and TID_SETTL_METHOD <> 'C') then AMT_ORIGINAL else 0 end) as REP_D_AMOUNT,
            sum(CASE WHEN( TID in ('010003015201', '010003015102', '010003015101', '010003015210' ) and TID_SETTL_METHOD = 'C') then AMT_ORIGINAL else 0 end) as CHR_C_AMOUNT,
            sum(CASE WHEN( TID in ('010003015201', '010003015102', '010003015101', '010003015210') and TID_SETTL_METHOD <> 'C') then AMT_ORIGINAL else 0 end) as CHR_D_AMOUNT,
            sum(CASE WHEN( TID in ('010123005102', '010123005101', '010123005202', '010123005201') and TID_SETTL_METHOD = 'C' ) then AMT_ORIGINAL else 0 end) as MISC_C_AMOUNT,
            sum(CASE WHEN( TID in ('010123005102', '010123005101', '010123005202', '010123005201') and TID_SETTL_METHOD <> 'C') then AMT_ORIGINAL else 0 end) as MISC_D_AMOUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and TID_SETTL_METHOD <> 'C' and card_scheme = '02') then AMT_ORIGINAL else 0 end ) as DB_REFUND_AMOUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and TID_SETTL_METHOD <> 'C' and card_scheme = '03') then AMT_ORIGINAL else 0 end ) as AMEX_REFUND_AMOUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and TID_SETTL_METHOD <> 'C' and card_scheme = '04' ) then AMT_ORIGINAL else 0 end ) as VS_REFUND_AMOUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and TID_SETTL_METHOD <> 'C' and card_scheme = '05') then AMT_ORIGINAL else 0 end ) as MC_REFUND_AMOUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and TID_SETTL_METHOD <> 'C' and card_scheme = '08') then AMT_ORIGINAL else 0 end ) as DISC_REFUND_AMOUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and TID_SETTL_METHOD <> 'C' and card_scheme = '09') then AMT_ORIGINAL else 0 end ) as JCB_REFUND_AMOUNT
            FROM mas_trans_log
            WHERE GL_DATE = '$date' and 
                  settl_flag = 'Y' and
                  institution_id in ('106')
            group by institution_id, substr(posting_entity_id, 1,6)"    
  } else {
      orasql $daily_cursor15 "ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-RR HH24:MI:SS'"
      set daily_sales_str "  SELECT institution_id, substr(posting_entity_id, 1,6) as BIN_ID, 
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and card_scheme = '02') then 1 else 0 end ) as DB_COUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and card_scheme = '03') then 1 else 0 end ) as AMEX_COUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and card_scheme = '04') then 1 else 0 end ) as VS_COUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and card_scheme = '05') then 1 else 0 end ) as MC_COUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and card_scheme = '08') then 1 else 0 end ) as DISC_COUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and card_scheme = '09') then 1 else 0 end ) as JCB_COUNT,
            sum(CASE WHEN( TID in ('010003005301', '010003005401', '010003010102', '010003010101')) then 1 else 0 end) as REP_COUNT,
            sum(CASE WHEN( TID in ('010003015201', '010003015102', '010003015101', '010003015210')) then 1 else 0 end) as CHR_COUNT,
            sum(CASE WHEN( tid in ('010123005102', '010123005101', '010123005202', '010123005201')) then 1 else 0 end) as MISC_COUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and TID_SETTL_METHOD = 'C' and card_scheme = '02') then AMT_ORIGINAL else 0 end ) as DB_AMOUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and TID_SETTL_METHOD = 'C' and card_scheme = '03') then AMT_ORIGINAL else 0 end ) as AMEX_AMOUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and TID_SETTL_METHOD = 'C' and card_scheme = '04') then AMT_ORIGINAL else 0 end ) as VS_AMOUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and TID_SETTL_METHOD = 'C' and card_scheme = '05') then AMT_ORIGINAL else 0 end ) as MC_AMOUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and TID_SETTL_METHOD = 'C' and card_scheme = '08') then AMT_ORIGINAL else 0 end ) as DISC_AMOUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and TID_SETTL_METHOD = 'C' and card_scheme = '09') then AMT_ORIGINAL else 0 end ) as JCB_AMOUNT,
            sum(CASE WHEN( TID in ('010003005301', '010003005401', '010003010102', '010003010101') and TID_SETTL_METHOD = 'C') then AMT_ORIGINAL else 0 end ) as REP_C_AMOUNT,
            sum(CASE WHEN( TID in ('010003005301', '010003005401', '010003010102', '010003010101') and TID_SETTL_METHOD <> 'C') then AMT_ORIGINAL else 0 end) as REP_D_AMOUNT,
            sum(CASE WHEN( TID in ('010003015201', '010003015102', '010003015101', '010003015210' ) and TID_SETTL_METHOD = 'C') then AMT_ORIGINAL else 0 end) as CHR_C_AMOUNT,
            sum(CASE WHEN( TID in ('010003015201', '010003015102', '010003015101', '010003015210') and TID_SETTL_METHOD <> 'C') then AMT_ORIGINAL else 0 end) as CHR_D_AMOUNT,
            sum(CASE WHEN( TID in ('010123005102', '010123005101', '010123005202', '010123005201') and TID_SETTL_METHOD = 'C' ) then AMT_ORIGINAL else 0 end) as MISC_C_AMOUNT,
            sum(CASE WHEN( TID in ('010123005102', '010123005101', '010123005202', '010123005201') and TID_SETTL_METHOD <> 'C') then AMT_ORIGINAL else 0 end) as MISC_D_AMOUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and TID_SETTL_METHOD <> 'C' and card_scheme = '02') then AMT_ORIGINAL else 0 end ) as DB_REFUND_AMOUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and TID_SETTL_METHOD <> 'C' and card_scheme = '03') then AMT_ORIGINAL else 0 end ) as AMEX_REFUND_AMOUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and TID_SETTL_METHOD <> 'C' and card_scheme = '04' ) then AMT_ORIGINAL else 0 end ) as VS_REFUND_AMOUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and TID_SETTL_METHOD <> 'C' and card_scheme = '05') then AMT_ORIGINAL else 0 end ) as MC_REFUND_AMOUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and TID_SETTL_METHOD <> 'C' and card_scheme = '08') then AMT_ORIGINAL else 0 end ) as DISC_REFUND_AMOUNT,
            sum(CASE WHEN( tid in ('010003005102', '010003005101', '010003005201', '010003005202') and TID_SETTL_METHOD <> 'C' and card_scheme = '09') then AMT_ORIGINAL else 0 end ) as JCB_REFUND_AMOUNT
            FROM mas_trans_log
            WHERE GL_DATE = '$date' and 
                  settl_flag = 'Y' and
                  institution_id in ('106') and
                  (institution_id,file_id) in (select institution_id, file_id from mas_file_log
                                                where ((to_date(RECEIVE_DATE_TIME,'DD-MON-RR HH24:MI:SS') < '$RECEIVE_DATE_TIME')
                                                   and (to_date(RECEIVE_DATE_TIME,'DD-MON-RR HH24:MI:SS') > '$PRE_RECEIVE_DATE_TIME')))
            group by institution_id, substr(posting_entity_id, 1,6)"
  }
      if {$mode == "TEST"} {
        puts "daily_sales_str: $daily_sales_str"
      }
      orasql $daily_cursor1 $daily_sales_str
      while {[orafetch $daily_cursor1 -dataarray s -indexbyname] != 1403} {
              set INST_ID $s(INSTITUTION_ID)
	      set bn_id $s(BIN_ID)
              if {$bn_id == "440339"} {
                    set REP_COUNT101          $s(REP_COUNT)     
                    set CHR_COUNT101          $s(CHR_COUNT) 
                    set MISC_COUNT101         $s(MISC_COUNT)
                    set VISA_COUNT101         $s(VS_COUNT)
                    set MC_COUNT101           $s(MC_COUNT) 
                    set AMEX_COUNT101         $s(AMEX_COUNT)
                    set DISC_COUNT101         $s(DISC_COUNT)
                    set DB_COUNT101           $s(DB_COUNT)
                    set JCB_COUNT101          $s(JCB_COUNT)
                    set VISA_AMOUNT101        $s(VS_AMOUNT)
                    set MC_AMOUNT101          $s(MC_AMOUNT)
                    set AMEX_AMOUNT101        $s(AMEX_AMOUNT)
                    set DISC_AMOUNT101        $s(DISC_AMOUNT)
                    set DB_AMOUNT101          $s(DB_AMOUNT)
                    set JCB_AMOUNT101         $s(JCB_AMOUNT)
                    set REP_AMOUNT101          [expr $s(REP_C_AMOUNT) - $s(REP_D_AMOUNT)] 
                    set CHR_AMOUNT101          [expr $s(CHR_C_AMOUNT) - $s(CHR_D_AMOUNT)]  
                    set MISC_AMOUNT101         [expr $s(MISC_C_AMOUNT) - $s(MISC_D_AMOUNT)]
                    set VS_REFUND_AMOUNT101    $s(VS_REFUND_AMOUNT)
                    set MC_REFUND_AMOUNT101    $s(MC_REFUND_AMOUNT) 
                    set AMEX_REFUND_AMOUNT101  $s(AMEX_REFUND_AMOUNT)  
                    set DISC_REFUND_AMOUNT101  $s(DISC_REFUND_AMOUNT)  
                    set DB_REFUND_AMOUNT101    $s(DB_REFUND_AMOUNT) 
                    set JCB_REFUND_AMOUNT101   $s(JCB_REFUND_AMOUNT)                
              } elseif {$bn_id == "461084" } {
                    set REP_COUNT107          $s(REP_COUNT)     
                    set CHR_COUNT107          $s(CHR_COUNT) 
                    set MISC_COUNT107         $s(MISC_COUNT)
                    set VISA_COUNT107         $s(VS_COUNT)
                    set MC_COUNT107           $s(MC_COUNT) 
                    set AMEX_COUNT107         $s(AMEX_COUNT)
                    set DISC_COUNT107         $s(DISC_COUNT)
                    set DB_COUNT107           $s(DB_COUNT)
                    set JCB_COUNT107          $s(JCB_COUNT)
                    set VISA_AMOUNT107        $s(VS_AMOUNT)
                    set MC_AMOUNT107          $s(MC_AMOUNT)
                    set AMEX_AMOUNT107        $s(AMEX_AMOUNT)
                    set DISC_AMOUNT107        $s(DISC_AMOUNT)
                    set DB_AMOUNT107          $s(DB_AMOUNT)
                    set JCB_AMOUNT107         $s(JCB_AMOUNT)
                    set REP_AMOUNT107          [expr $s(REP_C_AMOUNT) - $s(REP_D_AMOUNT)] 
                    set CHR_AMOUNT107          [expr $s(CHR_C_AMOUNT) - $s(CHR_D_AMOUNT)]  
                    set MISC_AMOUNT107         [expr $s(MISC_C_AMOUNT) - $s(MISC_D_AMOUNT)]
                    set VS_REFUND_AMOUNT107    $s(VS_REFUND_AMOUNT)
                    set MC_REFUND_AMOUNT107    $s(MC_REFUND_AMOUNT) 
                    set AMEX_REFUND_AMOUNT107  $s(AMEX_REFUND_AMOUNT)  
                    set DISC_REFUND_AMOUNT107  $s(DISC_REFUND_AMOUNT)  
                    set DB_REFUND_AMOUNT107    $s(DB_REFUND_AMOUNT) 
                    set JCB_REFUND_AMOUNT107   $s(JCB_REFUND_AMOUNT)                 
              }
      }
set	REP_COUNT_ROLL	[expr	$REP_COUNT101	+	  $REP_COUNT107	]
set	CHR_COUNT_ROLL	[expr	$CHR_COUNT101	+	$CHR_COUNT107	]
set	MISC_COUNT_ROLL	[expr	$MISC_COUNT101	+	$MISC_COUNT107	]
set	VISA_COUNT_ROLL	[expr	$VISA_COUNT101	+	$VISA_COUNT107	]
set	MC_COUNT_ROLL	[expr	$MC_COUNT101	+	$MC_COUNT107	]
set	AMEX_COUNT_ROLL	[expr	$AMEX_COUNT101	+	$AMEX_COUNT107	]
set	DISC_COUNT_ROLL	[expr	$DISC_COUNT101	+	$DISC_COUNT107	]
set	DB_COUNT_ROLL	[expr	$DB_COUNT101	+	$DB_COUNT107	]
set	JCB_COUNT_ROLL	[expr	$JCB_COUNT101	+	$JCB_COUNT107	]
set	VISA_AMOUNT_ROLL	[expr	$VISA_AMOUNT101	+	$VISA_AMOUNT107	]
set	MC_AMOUNT_ROLL	[expr	$MC_AMOUNT101	+	$MC_AMOUNT107	]
set	AMEX_AMOUNT_ROLL	[expr	$AMEX_AMOUNT101	+	$AMEX_AMOUNT107	]
set	DISC_AMOUNT_ROLL	[expr	$DISC_AMOUNT101	+	$DISC_AMOUNT107	]
set	DB_AMOUNT_ROLL	[expr	$DB_AMOUNT101	+	$DB_AMOUNT107	]
set	JCB_AMOUNT_ROLL	[expr	$JCB_AMOUNT101	+	$JCB_AMOUNT107	]
set	REP_AMOUNT_ROLL	[expr	$REP_AMOUNT101	+	$REP_AMOUNT107	]
set	CHR_AMOUNT_ROLL	[expr	$CHR_AMOUNT101	+	$CHR_AMOUNT107	]
set	MISC_AMOUNT_ROLL	[expr	$MISC_AMOUNT101	+	$MISC_AMOUNT107	]
set	VS_REFUND_AMOUNT_ROLL	[expr	$VS_REFUND_AMOUNT101	+	$VS_REFUND_AMOUNT107	]
set	MC_REFUND_AMOUNT_ROLL	[expr	$MC_REFUND_AMOUNT101	+	$MC_REFUND_AMOUNT107	]
set	AMEX_REFUND_AMOUNT_ROLL	[expr	$AMEX_REFUND_AMOUNT101	+	$AMEX_REFUND_AMOUNT107	]
set	DISC_REFUND_AMOUNT_ROLL	[expr	$DISC_REFUND_AMOUNT101	+	$DISC_REFUND_AMOUNT107	]
set	DB_REFUND_AMOUNT_ROLL	[expr	$DB_REFUND_AMOUNT101	+	$DB_REFUND_AMOUNT107	]
set	JCB_REFUND_AMOUNT_ROLL	[expr	$JCB_REFUND_AMOUNT101	+	$JCB_REFUND_AMOUNT107	]

    
puts "daily_sales_str is done at [clock format [clock seconds]]"
set     INST_ID         0
set	MC_FEE101	0
set	VISA_FEE101	0
set	DB_FEE101	0
set	AMEX_FEE101	0
set	DISC_FEE101	0
set	JCB_FEE101	0
set	OTHER_FEE101	0
set	CHR_FEE101	0

set	MC_FEE107	0
set	VISA_FEE107	0
set	DB_FEE107	0
set	AMEX_FEE107	0
set	DISC_FEE107	0
set	JCB_FEE107	0
set	OTHER_FEE107	0
set	CHR_FEE107	0

set	MC_FEE_ROLL	0
set	VISA_FEE_ROLL	0
set	DB_FEE_ROLL	0
set	AMEX_FEE_ROLL	0
set	DISC_FEE_ROLL	0
set	JCB_FEE_ROLL	0
set	OTHER_FEE_ROLL	0
set	CHR_FEE_ROLL	0

#set     cardtype    "'02', '03', '04', '05', '08', '09'"
 
puts "Today is $date: run for month end fees!"
      set daily_fees_str " SELECT /*+INDEX(payment_log XIE2PAYMENT_LOG)*/ m.institution_id as inst, 
	    substr(m.posting_entity_id, 1,6) as fee_bin_id, 
            substr(p.payment_proc_dt,1,9) as dt,            
            (sum(CASE WHEN((substr(m.TID, 1, 6) = '010004' and m.tid not like '01000428%') and m.card_scheme = '02' and m.tid_settl_method = 'C') then m.AMT_ORIGINAL else 0 end)
           - sum(CASE WHEN((substr(m.TID, 1, 6) = '010004' and m.tid not like '01000428%') and m.card_scheme = '02' and m.tid_settl_method <> 'C') then m.AMT_ORIGINAL else 0 end)) as DB_FEE,
            (sum(CASE WHEN((substr(m.TID, 1, 6) = '010004' and m.tid not like '01000428%') and m.card_scheme = '03' and m.tid_settl_method = 'C') then m.AMT_ORIGINAL else 0 end)
           - sum(CASE WHEN((substr(m.TID, 1, 6) = '010004' and m.tid not like '01000428%') and m.card_scheme = '03' and m.tid_settl_method <> 'C') then m.AMT_ORIGINAL else 0 end)) as AX_FEE,
            (sum(CASE WHEN((substr(m.TID, 1, 6) = '010004' and m.tid not like '01000428%') and m.card_scheme = '04' and m.tid_settl_method = 'C') then m.AMT_ORIGINAL else 0 end)
           - sum(CASE WHEN((substr(m.TID, 1, 6) = '010004' and m.tid not like '01000428%') and m.card_scheme = '04' and m.tid_settl_method <> 'C') then m.AMT_ORIGINAL else 0 end)) as VS_FEE,
            (sum(CASE WHEN((substr(m.TID, 1, 6) = '010004' and m.tid not like '01000428%') and m.card_scheme = '05' and m.tid_settl_method = 'C') then m.AMT_ORIGINAL else 0 end)
           - sum(CASE WHEN((substr(m.TID, 1, 6) = '010004' and m.tid not like '01000428%') and m.card_scheme = '05' and m.tid_settl_method <> 'C') then m.AMT_ORIGINAL else 0 end)) as MC_FEE,
            (sum(CASE WHEN((substr(m.TID, 1, 6) = '010004' and m.tid not like '01000428%') and m.card_scheme = '08' and m.tid_settl_method = 'C') then m.AMT_ORIGINAL else 0 end)
           - sum(CASE WHEN((substr(m.TID, 1, 6) = '010004' and m.tid not like '01000428%') and m.card_scheme = '08' and m.tid_settl_method <> 'C') then m.AMT_ORIGINAL else 0 end)) as DS_FEE,
            (sum(CASE WHEN((substr(m.TID, 1, 6) = '010004' and m.tid not like '01000428%') and m.card_scheme = '09' and m.tid_settl_method = 'C') then m.AMT_ORIGINAL else 0 end)
           - sum(CASE WHEN((substr(m.TID, 1, 6) = '010004' and m.tid not like '01000428%') and m.card_scheme = '09' and m.tid_settl_method <> 'C') then m.AMT_ORIGINAL else 0 end)) as JC_FEE,
            (sum(CASE WHEN((substr(m.TID, 1, 6) = '010004' and m.tid not like '01000428%') and m.tid_settl_method = 'C' and m.card_scheme not in ('02','04','05','08','12')) then m.AMT_ORIGINAL else 0 end)
           - sum(CASE WHEN((substr(m.TID, 1, 6) = '010004' and m.tid not like '01000428%') and m.tid_settl_method <> 'C' and m.card_scheme not in ('02','04','05','08','12')) then m.AMT_ORIGINAL else 0 end)) as O_FEE,
            (sum(CASE WHEN( m.TID_SETTL_METHOD = 'C' and m.TID in ('010004160000', '010004160001')) then m.AMT_ORIGINAL else 0 end)
           - sum(CASE WHEN( m.TID_SETTL_METHOD <> 'C' and m.TID in ('010004160000', '010004160001')) then m.AMT_ORIGINAL else 0 end)) as CHR_FEE
       FROM mas_trans_log m, payment_log p
       WHERE m.payment_seq_nbr = p.payment_seq_nbr
             and m.institution_id = p.institution_id
             and p.payment_proc_dt like '%$fdate%'
             and (m.tid like '010004%' and m.tid not like '01000428%' )
             and m.settl_flag = 'Y'
             and m.institution_id in ('106')
       GROUP BY m.institution_id, rollup(p.payment_proc_dt), substr(m.posting_entity_id, 1,6)
       order BY m.institution_id, p.payment_proc_dt, substr(m.posting_entity_id, 1,6)"    
      
      if {$mode == "TEST"} {
          puts "daily_fees_str: $daily_fees_str"
      }
      orasql $daily_cursor4 $daily_fees_str
      while {[orafetch $daily_cursor4 -dataarray f -indexbyname] != 1403} {
          if {$f(DT) == $date} {
              set INST_ID $f(INST)
	      set fb_id $f(FEE_BIN_ID)
              if {$fb_id == "440339" } {
                    set MC_FEE101            $f(MC_FEE)
                    set VISA_FEE101          $f(VS_FEE)
                    set DB_FEE101            $f(DB_FEE)
                    set AMEX_FEE101          $f(AX_FEE)
                    set DISC_FEE101          $f(DS_FEE)
                    set JCB_FEE101           $f(JC_FEE)
                    set OTHER_FEE101         $f(O_FEE)
                    set CHR_FEE101           $f(CHR_FEE)
              } elseif {$fb_id == "461084" } {
                    set MC_FEE107            $f(MC_FEE)
                    set VISA_FEE107          $f(VS_FEE)
                    set DB_FEE107            $f(DB_FEE)
                    set AMEX_FEE107          $f(AX_FEE)
                    set DISC_FEE107          $f(DS_FEE)
                    set JCB_FEE107           $f(JC_FEE)
                    set OTHER_FEE107         $f(O_FEE)
                    set CHR_FEE107           $f(CHR_FEE)                    
              }
          }
      }
      
set	MC_FEE_ROLL	  [expr	$MC_FEE101	+ $MC_FEE107]
set	VISA_FEE_ROLL	  [expr	$VISA_FEE101	+ $VISA_FEE107]
set	DB_FEE_ROLL	  [expr	$DB_FEE101	+ $DB_FEE107]
set	AMEX_FEE_ROLL	  [expr	$AMEX_FEE101	+ $AMEX_FEE107]
set	DISC_FEE_ROLL	  [expr	$DISC_FEE101	+ $DISC_FEE107]
set	JCB_FEE_ROLL	  [expr	$JCB_FEE101	+ $JCB_FEE107]
set	OTHER_FEE_ROLL	  [expr	$OTHER_FEE101	+ $OTHER_FEE107]
set	CHR_FEE_ROLL	  [expr	$CHR_FEE101	+ $CHR_FEE107]              
  
puts "fees_str is done at [clock format [clock seconds]]"

set     INST_ID                 0
set	TODAY_RESERVE101	0
set	TODAY_RESERVE_PAID101	0
set	SUB_TODAY_RESERVE101	0
set	RESERVE101	        0
set	TOTAL_RESERVE101	0
set	DISCOUNT101	        0
set	DISCOUNT_COUNT101	0
set	GRAND_DISCOUNT_COUNT101	0
set	GRAND_DISCOUNT101	0
set	TODAY_RESERVE107	0
set	TODAY_RESERVE_PAID107	0
set	SUB_TODAY_RESERVE107	0
set	RESERVE107	        0
set	TOTAL_RESERVE107	0
set	DISCOUNT107	        0
set	DISCOUNT_COUNT107	0
set	GRAND_DISCOUNT_COUNT107	0
set	GRAND_DISCOUNT107	0

# or aad.payment_proc_dt  > '$date'
      set discnt_tid "'010003005101','010003005102','010003005301','010003005301','010003010102','010003010101'"
      set discnt_str "  SELECT /*+ parallel(m, 3, 3) */ m.institution_id, substr(m.posting_entity_id, 1,6) as bin_id,
            sum(CASE WHEN((m.DATE_TO_SETTLE > '$yesterday' and m.activity_date_time < '$date') and m.tid in ($discnt_tid) and m.tid_settl_method = 'C' ) then m.AMT_ORIGINAL else 0 end) as DISCOUNT_C,
            sum(CASE WHEN((m.DATE_TO_SETTLE > '$yesterday' and m.activity_date_time < '$date') and m.tid in ($discnt_tid) and m.tid_settl_method <> 'C' ) then m.AMT_ORIGINAL else 0 end) as DISCOUNT_D,
            sum(CASE WHEN((m.DATE_TO_SETTLE > '$yesterday' and m.activity_date_time < '$date') and m.tid in ($discnt_tid)) then 1 else 0 end) as DISCOUNT_COUNT,
            sum(CASE WHEN((m.DATE_TO_SETTLE > '$date' and m.activity_date_time < '$tomorrow') and m.tid in ($discnt_tid) and m.tid_settl_method = 'C' ) then m.AMT_ORIGINAL else 0 end) as GRAND_DISCOUNT_C,
            sum(CASE WHEN((m.DATE_TO_SETTLE > '$date' and m.activity_date_time < '$tomorrow') and m.tid in ($discnt_tid) and m.tid_settl_method <> 'C' ) then m.AMT_ORIGINAL else 0 end) as GRAND_DISCOUNT_D,
            sum(CASE WHEN((m.DATE_TO_SETTLE > '$date' and m.activity_date_time < '$tomorrow') and m.tid in ($discnt_tid)) then 1 else 0 end) as GRAND_DISCOUNT_COUNT     
       FROM  mas_trans_log m
       WHERE  settl_flag = 'Y'
          and institution_id in ('106')
          and (m.DATE_TO_SETTLE > '$yesterday' and m.activity_date_time < '$tomorrow')
          and m.tid in ($discnt_tid)
       GROUP BY m.institution_id,substr(m.posting_entity_id, 1,6)"

      orasql $daily_cursor6 $discnt_str
      if {$mode == "TEST"} {
          puts "discnt_str...$discnt_str"
      }
      while {[orafetch $daily_cursor6 -dataarray mtdf -indexbyname] != 1403} {
             set INST_ID $mtdf(INSTITUTION_ID)
	     set dis_b_id $mtdf(BIN_ID)
             if {$INST_ID == "101" || $dis_b_id == "440339" } {
                set DISCOUNT101           [expr $mtdf(DISCOUNT_D) - $mtdf(DISCOUNT_C) ]        ;# to manipulate the data to the format bank wants              
                set DISCOUNT_COUNT101      $mtdf(DISCOUNT_COUNT)         
                set GRAND_DISCOUNT_COUNT101  $mtdf(GRAND_DISCOUNT_COUNT)
                set GRAND_DISCOUNT101     [expr  $mtdf(GRAND_DISCOUNT_D) -  $mtdf(GRAND_DISCOUNT_C) ]  ;# to manipulate the data to the format bank wants             
              } elseif {$INST_ID == "105"} {
                set DISCOUNT105           [expr $mtdf(DISCOUNT_D) - $mtdf(DISCOUNT_C) ]        ;# to manipulate the data to the format bank wants              
                set DISCOUNT_COUNT105      $mtdf(DISCOUNT_COUNT)  
                set GRAND_DISCOUNT_COUNT105  $mtdf(GRAND_DISCOUNT_COUNT)
                set GRAND_DISCOUNT105     [expr  $mtdf(GRAND_DISCOUNT_D) -  $mtdf(GRAND_DISCOUNT_C) ]  ;# to manipulate the data to the format bank wants                   
              } elseif {$INST_ID == "107" || $dis_b_id == "461084" } {
                set DISCOUNT107           [expr $mtdf(DISCOUNT_D) - $mtdf(DISCOUNT_C) ]        ;# to manipulate the data to the format bank wants              
                set DISCOUNT_COUNT107      $mtdf(DISCOUNT_COUNT)         
                set GRAND_DISCOUNT_COUNT107  $mtdf(GRAND_DISCOUNT_COUNT)
                set GRAND_DISCOUNT107     [expr  $mtdf(GRAND_DISCOUNT_D) -  $mtdf(GRAND_DISCOUNT_C) ]  ;# to manipulate the data to the format bank wants                                     
              } 
      }            
        set	DISCOUNT_ROLL          [expr $DISCOUNT107 + $DISCOUNT101]
        set	DISCOUNT_COUNT_ROLL    [expr $DISCOUNT_COUNT107 + $DISCOUNT_COUNT101]  
        set	GRAND_DISCOUNT_COUNT10 [expr $GRAND_DISCOUNT_COUNT107 + $GRAND_DISCOUNT_COUNT101]
        set	GRAND_DISCOUNT_ROLL    [expr $GRAND_DISCOUNT107 + $GRAND_DISCOUNT101]
     
puts "discnt_str is done at [clock format [clock seconds]]"

        set VISA_AMOUNT101        [expr $VISA_AMOUNT101 -   $VS_REFUND_AMOUNT101]
        set MC_AMOUNT101          [expr $MC_AMOUNT101 -   $MC_REFUND_AMOUNT101]
        set AMEX_AMOUNT101        [expr $AMEX_AMOUNT101 - $AMEX_REFUND_AMOUNT101]
        set DISC_AMOUNT101        [expr $DISC_AMOUNT101 - $DISC_REFUND_AMOUNT101]
        set DB_AMOUNT101          [expr $DB_AMOUNT101  -  $DB_REFUND_AMOUNT101]
        set JCB_AMOUNT101         [expr $JCB_AMOUNT101 -  $JCB_REFUND_AMOUNT101]
        
        set VISA_AMOUNT107        [expr $VISA_AMOUNT107 -   $VS_REFUND_AMOUNT107]
        set MC_AMOUNT107          [expr $MC_AMOUNT107 -   $MC_REFUND_AMOUNT107]
        set AMEX_AMOUNT107        [expr $AMEX_AMOUNT107 - $AMEX_REFUND_AMOUNT107]
        set DISC_AMOUNT107        [expr $DISC_AMOUNT107 - $DISC_REFUND_AMOUNT107]
        set DB_AMOUNT107          [expr $DB_AMOUNT107  -  $DB_REFUND_AMOUNT107]
        set JCB_AMOUNT107         [expr $JCB_AMOUNT107 -  $JCB_REFUND_AMOUNT107]

        set VISA_AMOUNT_ROLL        [expr $VISA_AMOUNT107 +   $VISA_AMOUNT101]
        set MC_AMOUNT_ROLL          [expr $MC_AMOUNT107 +   $MC_AMOUNT101]
        set AMEX_AMOUNT_ROLL        [expr $AMEX_AMOUNT107 + $AMEX_AMOUNT101]
        set DISC_AMOUNT_ROLL        [expr $DISC_AMOUNT107 + $DISC_AMOUNT101]
        set DB_AMOUNT_ROLL          [expr $DB_AMOUNT107  +  $DB_AMOUNT101]
        set JCB_AMOUNT_ROLL         [expr $JCB_AMOUNT107 +  $JCB_AMOUNT101]

        set query_reserve "SELECT /*+ parallel(m, 3, 3) */ m.institution_id as INST_ID,substr(m.posting_entity_id, 1,6) as bin_id,
                                    m.entity_id,
                                    m.tid,
                                    substr(m.gl_date,1,9) as gl_date,
                                    substr(m.date_to_settle,1,9) as date_to_settle,
                                    substr(aad.payment_proc_dt,1,9) as paydate,
                                    sum(m.amt_original) as TOTAL
                             FROM mas_trans_log m, acct_accum_det aad, entity_acct ea
                             WHERE  m.payment_seq_nbr = aad.payment_seq_nbr 
                                 AND aad.entity_acct_id = ea.entity_acct_id
                                 AND m.institution_id = aad.institution_id
                                 AND ea.institution_id = m.institution_id
                                 AND m.institution_id in ('106')
                                 and m.entity_id in (select unique ae.entity_id
                                                     from acq_entity ae, acq_entity_add_on aea
                                                     where ae.entity_id = aea.entity_id
                                                       and substr(aea.user_defined_1,1,7) in ('ROLLING','RESERVE')
                                                       and ae.institution_id in  ('106'))
                                 AND m.tid in ('010005050000', '010007050000','010005050001', '010007050001')
                                 AND (aad.payment_status is null or aad.payment_proc_dt  > '$date')
                                 AND m.gl_date < '$tomorrow'
                              GROUP BY m.institution_id,substr(m.posting_entity_id, 1,6),m.entity_id,  m.tid, m.gl_date,m.date_to_settle,aad.payment_proc_dt
                              ORDER BY  substr(m.posting_entity_id, 1,6),m.tid"
        if {$mode == "TEST"} {
            puts "query_reserve: $query_reserve"
        }
        orasql $daily_cursor7 $query_reserve
        while {[orafetch $daily_cursor7 -dataarray resvr -indexbyname] != 1403} {
 #TODAY_RESERVE101:      reseve takein
 #TODAY_RESERVE_PAID101: reserver payout
 #SUB_TODAY_RESERVE101:  subtotal of takein and payout
 #RESERVE101:            begining balance of reserve
 #TOTAL_RESERVE101:      ending balance of reserve
 
              if {$resvr(BIN_ID) == "440339" } {
                  if {$resvr(TID) == "010007050000"} {
                      if {$resvr(PAYDATE) == "$date"} {
                         set TODAY_RESERVE_PAID101 [expr $TODAY_RESERVE_PAID101 + $resvr(TOTAL)]
                      } else {
                         set TOTAL_RESERVE101 [expr $TOTAL_RESERVE101 - $resvr(TOTAL)]
                      }
                  } elseif {$resvr(TID) == "010007050001"} {
                      if {$resvr(PAYDATE) == "$date"} {
                         set TODAY_RESERVE_PAID101 [expr $TODAY_RESERVE_PAID101 - $resvr(TOTAL)]
                      } else {
                         set TOTAL_RESERVE101 [expr $TOTAL_RESERVE101 + $resvr(TOTAL)]
                      }
                  }
                  if {$resvr(TID) == "010005050000" && $resvr(GL_DATE) == "$date"} {
                        set TODAY_RESERVE101 [expr $TODAY_RESERVE101 - $resvr(TOTAL)]         
                  } elseif {$resvr(TID) == "010005050001" && $resvr(GL_DATE) == "$date"} {
                         set TODAY_RESERVE101 [expr $TODAY_RESERVE101 + $resvr(TOTAL)]
                  }                  
                  set SUB_TODAY_RESERVE101   [expr $TODAY_RESERVE101 + $TODAY_RESERVE_PAID101]
                  set RESERVE101 [expr $TOTAL_RESERVE101 - $SUB_TODAY_RESERVE101]
              }
              
              if {$resvr(BIN_ID) == "461084"} {
                  if {$resvr(TID) == "010007050000"} {
                      if {$resvr(PAYDATE) == "$date"} {
                         set TODAY_RESERVE_PAID107 [expr $TODAY_RESERVE_PAID107 + $resvr(TOTAL)]
                      } else {
                      set TOTAL_RESERVE107 [expr $TOTAL_RESERVE107 - $resvr(TOTAL)]
                      }
                  } elseif {$resvr(TID) == "010007050001"} {
                      if {$resvr(PAYDATE) == "$date"} {
                         set TODAY_RESERVE_PAID107 [expr $TODAY_RESERVE_PAID107 - $resvr(TOTAL)]
                      } else {
                      set TOTAL_RESERVE107 [expr $TOTAL_RESERVE107 + $resvr(TOTAL)]
                      }
                  }
                  if {$resvr(TID) == "010005050000" && $resvr(GL_DATE) == "$date"} {
                        set TODAY_RESERVE107 [expr $TODAY_RESERVE107 - $resvr(TOTAL)]         
                  } elseif {$resvr(TID) == "010005050001" && $resvr(GL_DATE) == "$date"} {
                         set TODAY_RESERVE107 [expr $TODAY_RESERVE107 + $resvr(TOTAL)]
                  }                  
                  set SUB_TODAY_RESERVE107   [expr $TODAY_RESERVE107 + $TODAY_RESERVE_PAID107]
                  set RESERVE107 [expr $TOTAL_RESERVE107 - $SUB_TODAY_RESERVE107]
              }
              
            set	TODAY_RESERVE_ROLL        [expr $TODAY_RESERVE107 + $TODAY_RESERVE101]
            set	TODAY_RESERVE_PAID_ROLL   [expr $TODAY_RESERVE_PAID107 + $TODAY_RESERVE_PAID101]
            set	SUB_TODAY_RESERVE_ROLL    [expr $SUB_TODAY_RESERVE107 + $SUB_TODAY_RESERVE101]                
            set	RESERVE_ROLL              [expr $RESERVE107 + $RESERVE101]
            set	TOTAL_RESERVE_ROLL        [expr $TOTAL_RESERVE107 + $TOTAL_RESERVE101]               
              
        }
puts "reserve is done at [clock format [clock seconds]]"

        set INST_ID       0
        set ACH_AMOUNT101 0
        set ACH_COUNT101  0
        set ACH_AMOUNT107 0
        set ACH_COUNT107  0
        set ACH_AMOUNT_ROLL 0
        set ACH_COUNT_ROLL  0
        
    #********    Pull ACH counts and amounts   **********#
    
    set query_string_ach " select unique aad.institution_id,
					 substr(aagld.owner_entity_id, 1,6) as bin_id,
                                         sum(aad.amt_fee) as FEE,
                                         sum(aad.amt_pay) as PAYMENT,
                                         count(1) as ACH_COUNT
                           from ACCT_ACCUM_DET aad join entity_acct aagld on aagld.ENTITY_ACCT_ID = aad.ENTITY_ACCT_ID
                           where aad.PAYMENT_PROC_DT like '%$date%'
                                 and aad.payment_cycle = '1'
                                 and aad.payment_status = 'P'
				 and aad.institution_id = '106'
				 and aad.institution_id = aagld.institution_id
                            group by aad.institution_id, substr(aagld.owner_entity_id, 1,6)"
    if {$mode == "TEST"} {
      puts "ACH query: $query_string_ach"
    }
    orasql $daily_cursor2 $query_string_ach

    while {[orafetch $daily_cursor2 -dataarray ach -indexbyname] != 1403} {
        set INST_ID $ach(INSTITUTION_ID)
	set ach_b_id $ach(BIN_ID)
        if {$ach_b_id == "440339"} {
            set ACH_AMOUNT101 [expr $ach(FEE) - $ach(PAYMENT)]
            set ACH_COUNT101  $ach(ACH_COUNT)
        } elseif {$ach_b_id == "461084" } {
            set ACH_AMOUNT107 [expr $ach(FEE) - $ach(PAYMENT)]
            set ACH_COUNT107  $ach(ACH_COUNT)                        
        }                    
    }
                
    set ACH_AMOUNT_ROLL [expr $ACH_AMOUNT101 + $ACH_AMOUNT107]
    set ACH_COUNT_ROLL  [expr $ACH_COUNT101 + $ACH_COUNT107]              
  
puts "ACH is done at [clock format [clock seconds]]"

    
    #*******    Pull the reject counts and amounts  *******#
    
    set V_OUTGOING_REJECT101 0
    set V_REJECT_COUNT101    0 
    set V_REJECT_COUNT101    0
    set V_OUTGOING_REJECT107 0
    set V_REJECT_COUNT107    0 
    set M_OUTGOING_REJECT101 0
    set M_REJECT_COUNT101    0 
    set M_OUTGOING_REJECT107 0
    set M_REJECT_COUNT107    0
    set V_OUTGOING_REJECT_ROLL 0
    set V_REJECT_COUNT_ROLL    0 
    set M_OUTGOING_REJECT_ROLL 0
    set M_REJECT_COUNT_ROLL    0
    set INCOMING_REJECT101     0
    set INCOMING_REJECT107     0
    
      set query_string "select unique SEC_DEST_INST_ID as INST, arn, substr(MERCH_ID, 1, 6) as bin_id,
                               activity_dt, tid,
                               sum(amt_trans) as amt_trans,
                               count(pan) as count, card_scheme
                          from in_draft_main
                          where tid  like '01010300510%'
                            and msg_text_block like '%JPREJECT%'
                            and activity_dt like '$yesterday%'
                            and in_file_nbr in (select in_file_nbr from in_file_log where end_dt like '$yesterday%')
                        group by SEC_DEST_INST_ID,substr(MERCH_ID, 1, 6), arn, activity_dt, tid, card_scheme
                        order by substr(MERCH_ID, 1, 6),arn"
      orasql $daily_cursor9 $query_string
      if {$mode == "TEST"} {
        puts "query: $query_string"
      }
      while {[orafetch $daily_cursor9 -dataarray w -indexbyname] != 1403} {
        set INST_ID $w(INST)        
	set rj_b_id $w(BIN_ID)
            if {$w(CARD_SCHEME) == "04"} {
                if {$rj_b_id == "440339" } {
                    if {$w(TID) == "010103005101"} {
                        set V_OUTGOING_REJECT101 [expr $V_OUTGOING_REJECT101 + $w(AMT_TRANS)]
                        set V_REJECT_COUNT101    [expr $w(COUNT) + $V_REJECT_COUNT101]                
                    } elseif {$w(TID) == "010103005102"} {
                        set V_OUTGOING_REJECT101 [expr $V_OUTGOING_REJECT101 - $w(AMT_TRANS)]
                        set V_REJECT_COUNT101    [expr $w(COUNT) + $V_REJECT_COUNT101]
                    }
                } elseif {$rj_b_id == "461084"} {
                    if {$w(TID) == "010103005101"} {
                        set V_OUTGOING_REJECT107 [expr $V_OUTGOING_REJECT107 + $w(AMT_TRANS)]
                        set V_REJECT_COUNT107    [expr $w(COUNT) + $V_REJECT_COUNT107]                
                    } elseif {$w(TID) == "010103005102"} {
                        set V_OUTGOING_REJECT107 [expr $V_OUTGOING_REJECT107 - $w(AMT_TRANS)]
                        set V_REJECT_COUNT107    [expr $w(COUNT) + $V_REJECT_COUNT107]
                    }                
                }
            } elseif {$w(CARD_SCHEME) == "05"} {
                if {$rj_b_id == "440339"} {
                    if {$w(TID) == "010103005101"} {
                        set M_OUTGOING_REJECT101 [expr $M_OUTGOING_REJECT101 + $w(AMT_TRANS)]
                        set M_REJECT_COUNT101 [expr $w(COUNT) + $M_REJECT_COUNT101]
                    } elseif {$w(TID) == "010103005102"} {
                        set M_OUTGOING_REJECT101 [expr $M_OUTGOING_REJECT101 - $w(AMT_TRANS)]
                        set M_REJECT_COUNT101 [expr $w(COUNT) + $M_REJECT_COUNT101]                
                    }
                } elseif {$rj_b_id == "461084"} {
                    if {$w(TID) == "010103005101"} {
                        set M_OUTGOING_REJECT107 [expr $M_OUTGOING_REJECT107 + $w(AMT_TRANS)]
                        set M_REJECT_COUNT107 [expr $w(COUNT) + $M_REJECT_COUNT107]
                    } elseif {$w(TID) == "010103005102"} {
                        set M_OUTGOING_REJECT107 [expr $M_OUTGOING_REJECT107 - $w(AMT_TRANS)]
                        set M_REJECT_COUNT107 [expr $w(COUNT) + $M_REJECT_COUNT107]                
                    }
                }                    
            }
      }
puts "daily reject is done at [clock format [clock seconds]]"
 
set stop_amt101 0
set stop_amt107 0
set stop_amt_roll 0
set INST_ID     0
        set stop_pay " select ea.institution_id as INST, substr(owner_entity_id,1,6) as bin_id, sum(aad.amt_pay) as stop_amt
                         from acct_accum_det aad join entity_acct ea on ea.institution_id = aad.institution_id
                                                  and ea.entity_acct_id = aad.entity_acct_id
                        where (ea.stop_pay_flag = 'Y' or ea.stop_fee_flag = 'Y')
                           and acct_posting_type = 'C'
                           and aad.payment_status is NULL
                        group by ea.institution_id,substr(owner_entity_id,1,6)" 

        orasql $daily_cursor11 $stop_pay
        if {$mode == "TEST"} {
          puts "stop pay: $stop_pay"
        }
        while {[orafetch $daily_cursor11 -dataarray stop -indexbyname] != 1403} {
            set INST_ID  $stop(INST)
	    set stp_b_id $stop(BIN_ID)
            if {$stp_b_id == "440339"} {
               set stop_amt101 $stop(STOP_AMT)
            } elseif {$stp_b_id == "461084"} {
               set stop_amt107 $stop(STOP_AMT)
            }
        }
        
      set stop_amt_roll [expr $stop_amt101 + $stop_amt107]
      set AMEX_COUNT101    0
      set JCB_COUNT101     0
      set EBT_COUNT101     0
      set AMEX_AMOUNT101   0 
      set JCB_AMOUNT101    0
      set EBT_AMOUNT101    0
      set AMEX_FEE101      0
      set JCB_FEE101       0
      set EBT_FEE101       0
      set AMEX_TOTAL101    0
      set JCB_TOTAL101     0
      set EBT_TOTAL101     0
      set MAMEX_FEE101     0
      set MJCB_FEE101      0
      set MEBT_FEE101      0
      set MAMEX_COUNT101   0
      set MJCB_COUNT101    0
      set MEBT_COUNT101    0
      set MAMEX_AMOUNT101  0
      set MJCB_AMOUNT101   0
      set MEBT_AMOUNT101   0
      set MAMEX_TOTAL101   0
      set MJCB_TOTAL101    0
      set MEBT_TOTAL101    0

      set AMEX_COUNT107    0
      set JCB_COUNT107     0
      set EBT_COUNT107     0
      set AMEX_AMOUNT107   0 
      set JCB_AMOUNT107    0
      set EBT_AMOUNT107    0
      set AMEX_FEE107      0
      set JCB_FEE107       0
      set EBT_FEE107       0
      set AMEX_TOTAL107    0
      set JCB_TOTAL107     0
      set EBT_TOTAL107     0
      set MAMEX_FEE107     0
      set MJCB_FEE107      0
      set MEBT_FEE107      0
      set MAMEX_COUNT107   0
      set MJCB_COUNT107    0
      set MEBT_COUNT107    0
      set MAMEX_AMOUNT107  0
      set MJCB_AMOUNT107   0
      set MEBT_AMOUNT107   0
      set MAMEX_TOTAL107   0
      set MJCB_TOTAL107    0
      set MEBT_TOTAL107    0
      
    #  puts $query_string
      set REJECT_COUNT101        [expr $V_REJECT_COUNT101 + $M_REJECT_COUNT101 ]
      
      if {$V_OUTGOING_REJECT101 != 0 } {
        set V_OUTGOING_REJECT101 "[string range $V_OUTGOING_REJECT101 0 [expr [string length $V_OUTGOING_REJECT101] -3]].[string range $V_OUTGOING_REJECT101 [expr [string length $V_OUTGOING_REJECT101] -2] [expr [string length $V_OUTGOING_REJECT101] -1]]"
      }
      if {$M_OUTGOING_REJECT101 != 0 } {
        set M_OUTGOING_REJECT101 "[string range $M_OUTGOING_REJECT101 0 [expr [string length $M_OUTGOING_REJECT101] -3]].[string range $M_OUTGOING_REJECT101 [expr [string length $M_OUTGOING_REJECT101] -2] [expr [string length $M_OUTGOING_REJECT101] -1]]"
      }
      if {$INCOMING_REJECT101 != 0 } {
        set INCOMING_REJECT "[string range $INCOMING_REJECT 0 [expr [string length $INCOMING_REJECT] -3]].[string range $INCOMING_REJECT [expr [string length $INCOMING_REJECT] -2] [expr [string length $INCOMING_REJECT] -1]]"
      }  

      set INCOMING_REJECT101     [expr $INCOMING_REJECT101 - $V_OUTGOING_REJECT101 - $M_OUTGOING_REJECT101]
      set REJECT_COUNT101        [expr $V_REJECT_COUNT101 + $M_REJECT_COUNT101]
      set VISA_AMOUNT101         [expr $VISA_AMOUNT101 + $V_OUTGOING_REJECT101]
      set MC_AMOUNT101           [expr $MC_AMOUNT101 +  $M_OUTGOING_REJECT101] 
      set VISA_TOTAL101          [expr $VISA_AMOUNT101 + $VISA_FEE101]
      set MC_TOTAL101            [expr $MC_AMOUNT101 + $MC_FEE101]
      set AMEX_FEE101		0        
      set AMEX_TOTAL101          [expr $AMEX_AMOUNT101 + $AMEX_FEE101]  
      #set DISC_FEE101              0
      set DISC_TOTAL101          [expr $DISC_AMOUNT101 + $DISC_FEE101]
      set DB_TOTAL101            [expr $DB_AMOUNT101 + $DB_FEE101]
      set JCB_TOTAL101           [expr $JCB_AMOUNT101 + $JCB_FEE101] 
      set REJECT_COUNT101        [expr $V_REJECT_COUNT101 + $M_REJECT_COUNT101 ]
      
      
      set REJECT_COUNT107        [expr $V_REJECT_COUNT107 + $M_REJECT_COUNT107 ]
      
      if {$V_OUTGOING_REJECT107 != 0 } {
        set V_OUTGOING_REJECT107 "[string range $V_OUTGOING_REJECT107 0 [expr [string length $V_OUTGOING_REJECT107] -3]].[string range $V_OUTGOING_REJECT107 [expr [string length $V_OUTGOING_REJECT107] -2] [expr [string length $V_OUTGOING_REJECT107] -1]]"
      }
      if {$M_OUTGOING_REJECT107 != 0 } {
        set M_OUTGOING_REJECT107 "[string range $M_OUTGOING_REJECT107 0 [expr [string length $M_OUTGOING_REJECT107] -3]].[string range $M_OUTGOING_REJECT107 [expr [string length $M_OUTGOING_REJECT107] -2] [expr [string length $M_OUTGOING_REJECT107] -1]]"
      }
      if {$INCOMING_REJECT107 != 0 } {
        set INCOMING_REJECT "[string range $INCOMING_REJECT 0 [expr [string length $INCOMING_REJECT] -3]].[string range $INCOMING_REJECT [expr [string length $INCOMING_REJECT] -2] [expr [string length $INCOMING_REJECT] -1]]"
      }    

      set INCOMING_REJECT107     [expr $INCOMING_REJECT107 - $V_OUTGOING_REJECT107 - $M_OUTGOING_REJECT107]
      set REJECT_COUNT107        [expr $V_REJECT_COUNT107 + $M_REJECT_COUNT107]
      set VISA_AMOUNT107         [expr $VISA_AMOUNT107 + $V_OUTGOING_REJECT107]
      set MC_AMOUNT107           [expr $MC_AMOUNT107 +  $M_OUTGOING_REJECT107] 
      set VISA_TOTAL107          [expr $VISA_AMOUNT107 + $VISA_FEE107]
      set MC_TOTAL107            [expr $MC_AMOUNT107 + $MC_FEE107]
      set AMEX_FEE107		  0        
      set AMEX_TOTAL107          [expr $AMEX_AMOUNT107 + $AMEX_FEE107]  
      #set DISC_FEE107              0
      set DISC_TOTAL107          [expr $DISC_AMOUNT107 + $DISC_FEE107]
      set DB_TOTAL107            [expr $DB_AMOUNT107 + $DB_FEE107]
      set JCB_TOTAL107           [expr $JCB_AMOUNT107 + $JCB_FEE107] 
      set REJECT_COUNT107        [expr $V_REJECT_COUNT107 + $M_REJECT_COUNT107 ]
 
 
      set INCOMING_REJECT_ROLL     [expr $INCOMING_REJECT107 + $INCOMING_REJECT101]
      set REJECT_COUNT_ROLL        [expr $REJECT_COUNT107 + $REJECT_COUNT101]
      set VISA_AMOUNT_ROLL         [expr $VISA_AMOUNT107 + $VISA_AMOUNT101]
      set MC_AMOUNT_ROLL           [expr $MC_AMOUNT107 +  $MC_AMOUNT101] 
      set VISA_TOTAL_ROLL          [expr $VISA_TOTAL107 + $VISA_TOTAL101]
      set MC_TOTAL_ROLL            [expr $MC_TOTAL107  + $MC_TOTAL101]
      set AMEX_FEE_ROLL		   0        
      set AMEX_TOTAL_ROLL          [expr $AMEX_TOTAL107 + $AMEX_TOTAL101]  
      #set DISC_FEE_ROLL            0
      set DISC_TOTAL_ROLL          [expr $DISC_TOTAL107 + $DISC_TOTAL101]
      set DB_TOTAL_ROLL            [expr $DB_TOTAL107 +$DB_TOTAL101]
      set JCB_TOTAL_ROLL           [expr $JCB_TOTAL107 + $JCB_TOTAL101] 
      set REJECT_COUNT_ROLL        [expr $REJECT_COUNT107 + $REJECT_COUNT107]
      
# *** assign subtotal of first section ***
# syang: report Discover for map merchants now 2009-08-03


      set D_SUB_SCNT101       [expr $VISA_COUNT101 + $MC_COUNT101 + $AMEX_COUNT101 + $DISC_COUNT101 + $JCB_COUNT101 + $DB_COUNT101 + $EBT_COUNT101]
      set D_SUB_SAMT101       [expr $VISA_AMOUNT101 + $MC_AMOUNT101 + $AMEX_AMOUNT101 + $DISC_AMOUNT101 + $DB_AMOUNT101 + $JCB_AMOUNT101 + $EBT_AMOUNT101 ]
      set D_SUB_FAMT101       [expr $VISA_FEE101 + $MC_FEE101 + $AMEX_FEE101 + $DISC_FEE101 + $DB_FEE101 + $JCB_FEE101 + $EBT_FEE101  + $OTHER_FEE101]
      set D_SUB_ACCTEFFECT101 [expr $VISA_TOTAL101 + $MC_TOTAL101 + $AMEX_TOTAL101 + $DISC_TOTAL101 + $JCB_TOTAL101 + $DB_TOTAL101 + $EBT_TOTAL101  + $OTHER_FEE101]


      set D_SUB_SCNT107       [expr $VISA_COUNT107 + $MC_COUNT107 + $AMEX_COUNT107 + $DISC_COUNT107 + $JCB_COUNT107 + $DB_COUNT107 + $EBT_COUNT107]
      set D_SUB_SAMT107       [expr $VISA_AMOUNT107 + $MC_AMOUNT107 + $AMEX_AMOUNT107 + $DISC_AMOUNT107 + $DB_AMOUNT107 + $JCB_AMOUNT107 + $EBT_AMOUNT107 ]
      set D_SUB_FAMT107       [expr $VISA_FEE107 + $MC_FEE107 + $AMEX_FEE107 + $DISC_FEE107 + $DB_FEE107 + $JCB_FEE107 + $EBT_FEE107  + $OTHER_FEE107]
      set D_SUB_ACCTEFFECT107 [expr $VISA_TOTAL107 + $MC_TOTAL107 + $AMEX_TOTAL107 + $DISC_TOTAL107 + $JCB_TOTAL107 + $DB_TOTAL107 + $EBT_TOTAL107  + $OTHER_FEE107]

      set AMEX_COUNT_ROLL    0
      set JCB_COUNT_ROLL     0
      set EBT_COUNT_ROLL     0
      set AMEX_AMOUNT_ROLL   0 
      set JCB_AMOUNT_ROLL    0
      set EBT_AMOUNT_ROLL    0
      set AMEX_FEE_ROLL      0
      set JCB_FEE_ROLL       0
      set EBT_FEE_ROLL       0
      set AMEX_TOTAL_ROLL    0
      set JCB_TOTAL_ROLL     0
      set EBT_TOTAL_ROLL     0
      set D_SUB_SCNT_ROLL       [expr $D_SUB_SCNT107 + $D_SUB_SCNT101]
      set D_SUB_SAMT_ROLL       [expr $D_SUB_SAMT107 + $D_SUB_SAMT101]
      set D_SUB_FAMT_ROLL       [expr $D_SUB_FAMT107 + $D_SUB_FAMT101]
      set D_SUB_ACCTEFFECT_ROLL [expr $D_SUB_ACCTEFFECT107 + $D_SUB_ACCTEFFECT101]
     
#=========  Header ============
  if {$institution_num == "ROLLUP"} {
 
 #write rollup
      #106
            puts "running for institution 106: 440339"
            puts $cur_file "ISO:,440339"
            puts $cur_file " "
            puts $cur_file " "
            puts $cur_file "DAILY DETAIL REPORT"
            puts $cur_file "TRN,---, FOR: $report_ddate,---,---,---"
            puts $cur_file "CD,COUNT, AMOUNT,FEES,ACCOUNT EFFECT\r\n"
            puts $cur_file "VISA,$VISA_COUNT101,$$VISA_AMOUNT101,$$VISA_FEE101,$$VISA_TOTAL101"
            puts $cur_file "MC,$MC_COUNT101,$$MC_AMOUNT101,$$MC_FEE101,$$MC_TOTAL101"
            puts $cur_file "AMEX,$AMEX_COUNT101,$$AMEX_AMOUNT101,$$AMEX_FEE101,$$AMEX_TOTAL101"
            puts $cur_file "DISC,$DISC_COUNT101,$$DISC_AMOUNT101,$$DISC_FEE101,$$DISC_TOTAL101"
            #puts $cur_file "TE,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00"
            puts $cur_file "JCB,$JCB_COUNT101,$$JCB_AMOUNT101,$$JCB_FEE101,$$JCB_TOTAL101"
            puts $cur_file "DBT,$DB_COUNT101,$$DB_AMOUNT101,$$DB_FEE101,$$DB_TOTAL101"
            puts $cur_file "EBT,0.00,\$0,\$0,\$0"
            puts $cur_file "MISC ADJ ,0.00,\$0,\$0,\$0"
            puts $cur_file "OTHER,$OTHER_COUNT101, ,$$OTHER_FEE101,$$OTHER_FEE101"
            puts $cur_file "SUBTOTAL,$D_SUB_SCNT101,$$D_SUB_SAMT101,$$D_SUB_FAMT101,$$D_SUB_ACCTEFFECT101"
            puts $cur_file " "
            puts $cur_file "REJECTS:"
            puts $cur_file "SUBTOTAL,$REJECT_COUNT101,$$INCOMING_REJECT101,0.00,$$INCOMING_REJECT101"
            puts $cur_file " "
            puts $cur_file "MISC ADJ: "
            puts $cur_file "SUBTOTAL,$MISC_COUNT101,$$MISC_AMOUNT101,0.00,$$MISC_AMOUNT101"
            puts $cur_file " "
            puts $cur_file "CHARGEBACKS:"
            puts $cur_file "CGB,$CHR_COUNT101,$$CHR_AMOUNT101,$$CHR_FEE101,$$CHR_AMOUNT101"
            puts $cur_file "REP,$REP_COUNT101,$$REP_AMOUNT101,$$REP_FEE101,$$REP_AMOUNT101"
            puts $cur_file "SUBTOTAL:,[expr $CHR_COUNT101 + $REP_COUNT101],$[expr $CHR_AMOUNT101 + $REP_AMOUNT101],$[expr $CHR_FEE101 + $REP_FEE101],$[expr $CHR_AMOUNT101 + $REP_AMOUNT101]"
            puts $cur_file " "
            puts $cur_file "RESERVES:"
            puts $cur_file "Res Addition,,,,$$TODAY_RESERVE101"
            puts $cur_file "Res Release,,,,$$TODAY_RESERVE_PAID101"
            puts $cur_file "SUBTOTAL:,,,,$$SUB_TODAY_RESERVE101"
            puts $cur_file " "
            puts $cur_file "DEPOSITS:"
            puts $cur_file "ACH:,$ACH_COUNT101, , ,$$ACH_AMOUNT101"
            puts $cur_file "ARJ:,0, , , 0.00"
            puts $cur_file "SUBTOTAL:,$ACH_COUNT101, , ,$$ACH_AMOUNT101"
            puts $cur_file " "
            puts $cur_file "Begining Payable Balance,$report_yesterday_mddate,,,$$DISCOUNT101"
            puts $cur_file "Account Effect:,,,,$[expr [expr $GRAND_DISCOUNT101 - $DISCOUNT101] + $stop_amt101]"
            puts $cur_file "Ending Payable Balance,$report_mddate,,,$[expr $GRAND_DISCOUNT101 + $stop_amt101]"
            puts $cur_file " "
            puts $cur_file "Begining Reserve Balance,$report_yesterday_mddate,,,$$RESERVE101"
            puts $cur_file "Account Effect:,,,,$$SUB_TODAY_RESERVE101"
            puts $cur_file "Ending Reserve Balance,$report_mddate,,,$$TOTAL_RESERVE101"          
          
       #106
           puts "running for institution 106 461084"
            puts $cur_file " "
            puts $cur_file " "
            puts $cur_file "ISO:,461084"
            puts $cur_file " "
            puts $cur_file " "
           puts $cur_file "DAILY DETAIL REPORT"
            puts $cur_file "TRN,---, FOR: $report_ddate,---,---,---"
            puts $cur_file "CD,COUNT, AMOUNT,FEES,ACCOUNT EFFECT\r\n"
            puts $cur_file "VISA,$VISA_COUNT107,$$VISA_AMOUNT107,$$VISA_FEE107,$$VISA_TOTAL107"
            puts $cur_file "MC,$MC_COUNT107,$$MC_AMOUNT107,$$MC_FEE107,$$MC_TOTAL107"
            puts $cur_file "AMEX,$AMEX_COUNT107,$$AMEX_AMOUNT107,$$AMEX_FEE107,$$AMEX_TOTAL107"
            puts $cur_file "DISC,$DISC_COUNT107,$$DISC_AMOUNT107,$$DISC_FEE107,$$DISC_TOTAL107"
            #puts $cur_file "TE,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00"
            puts $cur_file "JCB,$JCB_COUNT107,$$JCB_AMOUNT107,$$JCB_FEE107,$$JCB_TOTAL107"
            puts $cur_file "DBT,$DB_COUNT107,$$DB_AMOUNT107,$$DB_FEE107,$$DB_TOTAL107"
            puts $cur_file "EBT,0.00,\$0,\$0,\$0"
            puts $cur_file "MISC ADJ ,0.00,\$0,\$0,\$0"
            puts $cur_file "OTHER,$OTHER_COUNT107, ,$$OTHER_FEE107,$$OTHER_FEE107"
            puts $cur_file "SUBTOTAL,$D_SUB_SCNT107,$$D_SUB_SAMT107,$$D_SUB_FAMT107,$$D_SUB_ACCTEFFECT107"
            puts $cur_file " "
            puts $cur_file "REJECTS:"
            puts $cur_file "SUBTOTAL,$REJECT_COUNT107,$$INCOMING_REJECT107,0.00,$$INCOMING_REJECT107"
            puts $cur_file " "
            puts $cur_file "MISC ADJ: "
            puts $cur_file "SUBTOTAL,$MISC_COUNT107,$$MISC_AMOUNT107,0.00,$$MISC_AMOUNT107"
            puts $cur_file " "
            puts $cur_file "CHARGEBACKS:"
            puts $cur_file "CGB,$CHR_COUNT107,$$CHR_AMOUNT107,$$CHR_FEE107,$$CHR_AMOUNT107"
            puts $cur_file "REP,$REP_COUNT107,$$REP_AMOUNT107,$$REP_FEE107,$$REP_AMOUNT107"
            puts $cur_file "SUBTOTAL:,[expr $CHR_COUNT107 + $REP_COUNT107],$[expr $CHR_AMOUNT107 + $REP_AMOUNT107],$[expr $CHR_FEE107 + $REP_FEE107],$[expr $CHR_AMOUNT107 + $REP_AMOUNT107]"
            puts $cur_file " "
            puts $cur_file "RESERVES:"
            puts $cur_file "Res Addition,,,,$$TODAY_RESERVE107"
            puts $cur_file "Res Release,,,,$$TODAY_RESERVE_PAID107"
            puts $cur_file "SUBTOTAL:,,,,$$SUB_TODAY_RESERVE107"
            puts $cur_file " "
            puts $cur_file "DEPOSITS:"
            puts $cur_file "ACH:,$ACH_COUNT107, , ,$$ACH_AMOUNT107"
            puts $cur_file "ARJ:,0, , , 0.00"
            puts $cur_file "SUBTOTAL:,$ACH_COUNT107, , ,$$ACH_AMOUNT107"
            puts $cur_file " "
            puts $cur_file "Begining Payable Balance,$report_yesterday_mddate,,,$$DISCOUNT107"
            puts $cur_file "Account Effect:,,,,$[expr [expr $GRAND_DISCOUNT107 - $DISCOUNT107] + $stop_amt107]"
            puts $cur_file "Ending Payable Balance,$report_mddate,,,$[expr $GRAND_DISCOUNT107 + $stop_amt107]"
            puts $cur_file " "
            puts $cur_file "Begining Reserve Balance,$report_yesterday_mddate,,,$$RESERVE107"
            puts $cur_file "Account Effect:,,,,$$SUB_TODAY_RESERVE107"
            puts $cur_file "Ending Reserve Balance,$report_mddate,,,$$TOTAL_RESERVE107"          
          
       #440339&461084
            puts "running for institution 106"
            puts $cur_file " "
            puts $cur_file " "
            puts $cur_file "ISO:,ALL"
            puts $cur_file " "
            puts $cur_file " "
            puts $cur_file "DAILY DETAIL REPORT"
            puts $cur_file "TRN,---, FOR: $report_ddate,---,---,---"
            puts $cur_file "CD,COUNT, AMOUNT,FEES,ACCOUNT EFFECT\r\n"
            puts $cur_file "VISA,$VISA_COUNT_ROLL,$$VISA_AMOUNT_ROLL,$$VISA_FEE_ROLL,$$VISA_TOTAL_ROLL"
            puts $cur_file "MC,$MC_COUNT_ROLL,$$MC_AMOUNT_ROLL,$$MC_FEE_ROLL,$$MC_TOTAL_ROLL"
            puts $cur_file "AMEX,$AMEX_COUNT_ROLL,$$AMEX_AMOUNT_ROLL,$$AMEX_FEE_ROLL,$$AMEX_TOTAL_ROLL"
            puts $cur_file "DISC,$DISC_COUNT_ROLL,$$DISC_AMOUNT_ROLL,$$DISC_FEE_ROLL,$$DISC_TOTAL_ROLL"
            #puts $cur_file "TE,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00"
            puts $cur_file "JCB,$JCB_COUNT_ROLL,$$JCB_AMOUNT_ROLL,$$JCB_FEE_ROLL,$$JCB_TOTAL_ROLL"
            puts $cur_file "DBT,$DB_COUNT_ROLL,$$DB_AMOUNT_ROLL,$$DB_FEE_ROLL,$$DB_TOTAL_ROLL"
            puts $cur_file "EBT,0.00,\$0,\$0,\$0"
            puts $cur_file "MISC ADJ ,0.00,\$0,\$0,\$0"
            puts $cur_file "OTHER,$OTHER_COUNT_ROLL, ,$$OTHER_FEE_ROLL,$$OTHER_FEE_ROLL"
            puts $cur_file "SUBTOTAL,$D_SUB_SCNT_ROLL,$$D_SUB_SAMT_ROLL,$$D_SUB_FAMT_ROLL,$$D_SUB_ACCTEFFECT_ROLL"
            puts $cur_file " "
            puts $cur_file "REJECTS:"
            puts $cur_file "SUBTOTAL,$REJECT_COUNT_ROLL,$$INCOMING_REJECT_ROLL,0.00,$$INCOMING_REJECT_ROLL"
            puts $cur_file " "
            puts $cur_file "MISC ADJ: "
            puts $cur_file "SUBTOTAL,$MISC_COUNT_ROLL,$$MISC_AMOUNT_ROLL,0.00,$$MISC_AMOUNT_ROLL"
            puts $cur_file " "
            puts $cur_file "CHARGEBACKS:"
            puts $cur_file "CGB,$CHR_COUNT_ROLL,$$CHR_AMOUNT_ROLL,$$CHR_FEE_ROLL,$$CHR_AMOUNT_ROLL"
            puts $cur_file "REP,$REP_COUNT_ROLL,$$REP_AMOUNT_ROLL,$$REP_FEE_ROLL,$$REP_AMOUNT_ROLL"
            puts $cur_file "SUBTOTAL:,[expr $CHR_COUNT_ROLL + $REP_COUNT_ROLL],$[expr $CHR_AMOUNT_ROLL + $REP_AMOUNT_ROLL],$[expr $CHR_FEE_ROLL + $REP_FEE_ROLL],$[expr $CHR_AMOUNT_ROLL + $REP_AMOUNT_ROLL]"
            puts $cur_file " "
            puts $cur_file "RESERVES:"
            puts $cur_file "Res Addition,,,,$$TODAY_RESERVE_ROLL"
            puts $cur_file "Res Release,,,,$$TODAY_RESERVE_PAID_ROLL"
            puts $cur_file "SUBTOTAL:,,,,$$SUB_TODAY_RESERVE_ROLL"
            puts $cur_file " "
            puts $cur_file "DEPOSITS:"
            puts $cur_file "ACH:,$ACH_COUNT_ROLL, , ,$$ACH_AMOUNT_ROLL"
            puts $cur_file "ARJ:,0, , , 0.00"
            puts $cur_file "SUBTOTAL:,$ACH_COUNT_ROLL, , ,$$ACH_AMOUNT_ROLL"
            puts $cur_file " "
            puts $cur_file "Begining Payable Balance,$report_yesterday_mddate,,,$$DISCOUNT_ROLL"
            puts $cur_file "Account Effect:,,,,$[expr [expr $GRAND_DISCOUNT_ROLL - $DISCOUNT_ROLL] + $stop_amt_roll]"
            puts $cur_file "Ending Payable Balance,$report_mddate,,,$[expr $GRAND_DISCOUNT_ROLL + $stop_amt_roll]"
            puts $cur_file " "
            puts $cur_file "Begining Reserve Balance,$report_yesterday_mddate,,,$$RESERVE_ROLL"
            puts $cur_file "Account Effect:,,,,$$SUB_TODAY_RESERVE_ROLL"
            puts $cur_file "Ending Reserve Balance,$report_mddate,,,$$TOTAL_RESERVE_ROLL"          
            
  }

#==============================
          if  {$institution_num == "ROLLUP" || $institution_num == "106"} {
                close $cur_file
                if {$mode == "TEST"} {
                    exec uuencode $cur_file_name $file_name | mailx -r reports-clearing@jetpay.com -s $file_name reports-clearing@jetpay.com      
                } elseif {$mode == "PROD"} {
                    exec uuencode $file_name $file_name | mailx -r reports-clearing@jetpay.com -s $file_name reports-clearing@jetpay.com      
		    exec mv $file_name $cur_file_name
                }          

          }
oraclose $daily_cursor1
oraclose $daily_cursor2
oraclose $daily_cursor3
oraclose $daily_cursor4
oraclose $daily_cursor5
oraclose $daily_cursor6
oraclose $daily_cursor7
oraclose $daily_cursor8
oraclose $daily_cursor9
oraclose $daily_cursor10
oraclose $daily_cursor11
oraclose $daily_cursor12
oraclose $daily_cursor14
oraclose $daily_cursor15
oraclose $daily_cursor16
oralogoff $handler

