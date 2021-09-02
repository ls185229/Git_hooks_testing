#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

#===============================================================================
#                          Modification History
#===============================================================================
# This version runs for Susq. only
#===============================================================================
# Version 4.1 Sunny Yang 07-30-2010
# -------- As requested by Susq. added Discover id to the report.
#
# Version 4.0 Sunny Yang 03-29-2010
#--------- Clean up
# -------- performance tunning
#
# Version 3.0 Sunny Yang 11-25-2009
# per Susq's request:
#         Add Credit Count by card type
#         Split Chargeback by card type
#
# Version g1.1 Sunny Yang ?
# -------- updated for Reserves
#
# Version g1.0 Sunny Yang 18-AUG-2009
# -------- base on merric-headers.tcl-v2.07 to make this version work for Discover
#
# Version 2.07 Sunny Yang 18-JUN-2009
# -------- Update Rolling Reserve Paying outs
#
# Version 2.06 Sunny Yang 31-MAR-2009
# -------- Adjust sales amount&count to match with DD on Arbitration tid (01000300520%)

# Version 2.05 Sunny Yang 09-MAR-2009
# -------- Pull reject out after conference meeting with Merrick, as Reject should
# -------- not be counted twice and Merrick claimed that they do not match DD with
# -------- Header with IE.
#
# Version 2.03 Sunny Yang 03-MAR-2009
# -------- Updated and then re-installed the old logic on Arbitration tid.
# -------- conclution: we should show Arbitration(fee collection) along with
# -------- 
#
# Version 2.03 Sunny Yang 26-FEB-2009
# -------- Add in DB transactions
#          
# Version 2.02 Sunny Yang 06-JAN-2009
# -------- Updated Sales amounts and counts for Reversal tid 0100030005201, so that
#          reversal gets substracted from sales amount, but still adds up sales counts
#
# Version 2.02 Sunny Yang 02-OCT-2008
# -------- Put reject as part of sales to match with Daily Detail report.
# 
# Version 2.01 Sunny Yang 29-APR-2008
# -------- Add sanity checking to Subtotal and Total.
# -------- Compare add-up subtotal/total to print-out subtotal/total(pulled out by seperate query)
#
# Version 2.00 Sunny Yang 02-APR-2008
# -------- Rewrite the whole thing completely to speed it up
# -------- Add DATE argument from command line to run at given month before the
# -------- before the monthend
#
#
#New version 20070330
#Code updated. Added new output columns listed below
#Chargeback Count, Chargeback Volume, Representment Count, Representment Volume, Merch Reserve Bai
#Code update by Janette at 20070330  
# 

#===============================================================================
#                        Environment veriables
#===============================================================================

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
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

#===============================================================================
package require Oratcl
if {[catch {set handler [oralogon masclr/masclr@$clrdb]} result]} {
  exec echo "merric-headers.tcl failed to run" | mailx -r $mailfromlist -s "merric-headers.tcl" $mailtolist
  exit
}
if {[catch {set handlerT [oralogon teihost/quikdraw@$authdb]} resultauth ]} {
  exec echo "merric-headers.tcl failed to run" | mailx -r $mailfromlist -s "merric-headers.tcl" $mailtolist
  exit
}

set header_cursor1 [oraopen $handler]
set header_cursor2 [oraopen $handler]
set header_cursor3 [oraopen $handler]
set header_cursor4 [oraopen $handler]
set header_cursor5 [oraopen $handler]
set header_cursor6 [oraopen $handler]
set header_cursor7 [oraopen $handler]
set header_cursor8 [oraopen $handler]
set header_cursor9 [oraopen $handler]
set header_cursor10 [oraopen $handlerT]
set header_cursor11 [oraopen $handlerT]
set header_cursor12 [oraopen $handlerT]
set header_cursor13 [oraopen $handlerT]
set header_cursor14 [oraopen $handlerT]

#===============================================================================
#===============================================================================


   if { $argc == 0 } {
        set value "'105'"
        set short_month       [string toupper [clock format [clock scan "-1 month"] -format %b]]      ;# DEC... as of 01/27/2008
        set name_date         [clock format [clock scan "-0 day"] -format %Y%m%d]                     ;# 20080402 as of 04/02/2008
        set report_month      [string toupper [clock format [ clock scan "-1 month" ] -format %B-%Y ]] 
        if { $short_month == "DEC" } {
            set short_year    [clock format [clock scan "-1 month"] -format %y]
            set next_month    [string toupper [clock format [clock scan "-0 month"] -format %b]]
        } else {
            set short_year    [clock format [clock scan "-0 month"] -format %y]
            set next_month    [string toupper [clock format [clock scan "-0 month"] -format %b]]
        }
puts " short_month:$short_month...next_month:$next_month...short_year: $short_year  "
        set report_my     "$short_month-$short_year"
        set ach_date     [string toupper [clock format [ clock scan "-1 month " ] -format %d-%b-%y ]]
        set report_date  [string toupper [clock format [ clock scan "-0 day " ] -format %d-%b-%y ]]
        set today        [string toupper [clock format [ clock scan "-0 day " ] -format %d-%b-%y ]]
        set tomorrow     [string toupper [clock format [ clock scan "+1 day " ] -format %d-%b-%y ]]
        set CUR_SET_TIME [clock seconds ]
        set CUR_JULIAN_DATEX [string range [clock format $CUR_SET_TIME -format "%y%j"] 1 4]
   } elseif { $argc == 1 } {    
        set input        [lindex $argv 0]
        if {[string length $input ] == 8 } {
          set today      [lindex $argv 0]
          set value  "'105'"
        } else {
          puts "Date should be 8 digits, format yyyymmdd"
          exit
        }
        set name_date $today
        set report_date  [ string toupper [clock format [ clock scan " $today -0 day " ] -format %d-%b-%y ]]   ;# 02-APR-08 as of 20080402
        set report_my    [ string toupper [clock format [ clock scan " $today -0 day " ] -format %b-%y ]]      ;# MAR-08 as of 20080331
        puts " report month year is ....$report_my "
        set ach_date            [ string toupper [clock format [ clock scan "$today -0 day " ] -format %d-%b-%y ]]
        set report_month      [ string toupper [clock format [ clock scan "$today -0 month" ] -format %B-%Y ]] 
        set CUR_JULIAN_DATEX    [ clock scan "$today"  -base [clock seconds] ]
        set CUR_JULIAN_DATEX    [ clock format $CUR_JULIAN_DATEX -format "%y%j"]
        set CUR_JULIAN_DATEX    [ string range $CUR_JULIAN_DATEX 1 4 ]
        set today        [ string toupper [clock format [ clock scan "$today -0 day " ] -format %d-%b-%y ]]
        set tomorrow     [ string toupper [clock format [ clock scan "$today +1 day " ] -format %d-%b-%y ]]
   }
puts " report month year is ....$report_my "
puts "today: $today...$tomorrow: $tomorrow"


      set cur_file_name "./105.REPORT.HEADER.$CUR_JULIAN_DATEX.$name_date.001.csv"
      set file_name     "105.REPORT.HEADER.$CUR_JULIAN_DATEX.$name_date.001.csv"
      set cur_file      [open "$cur_file_name" w]
      puts $cur_file "ISO,105"
      puts $cur_file " "
      
      set VISA_COUNT 0
      set VISA_AMOUNT 0
      set VISA_NET_AMOUNT 0
      set VISA_CREDIT_AMOUNT 0
      set MC_COUNT 0
      set MC_AMOUNT 0
      set MC_NET_AMOUNT 0
      set MC_CREDIT_AMOUNT 0
      set RESERVE 0
      
      set MTD_VISA_COUNT 0
      set MTD_VISA_AMOUNT 0
      set MTD_VISA_NET_AMOUNT 0
      set MTD_VISA_CREDIT_AMOUNT 0
      set MTD_MC_COUNT 0
      set MTD_MC_AMOUNT 0
      set MTD_MC_NET_AMOUNT 0
      set MTD_MC_CREDIT_AMOUNT 0
      set MTD_CHARGEBACK_COUNT 0
      set MTD_CHARGEBACK_VOLUME 0
      set MTD_REPRESENT_COUNT 0
      set MTD_REPRESENT_VOLUME 0
      set MTD_RESERVE 0

      puts $cur_file "HEADER"
      puts $cur_file "Date:,$report_month"
      
      set header_line "Merchant ID, Discover ID, Merchant Name,YYYYMM"
      set header_line "$header_line, Visa Count, Visa Gross Amount,Visa Credit Count, Visa Credit Amount, Visa Net Amount"
      set header_line "$header_line, MC Count, MC Gross Amount, MC Credit Count, MC Credit Amount, MC Net Amount"
      set header_line "$header_line, DISC Count, DISC Gross Amount, DISC Credit Count, DISC Credit Amount, DISC Net Amount"
      set header_line "$header_line, EBT Count, EBT Net Amount, Debit Count, Debit Gross Amount, Debit Credit Count, Debit Credit Amount, Debit Net Amount"
      set header_line "$header_line, SIC Code, TAX ID,  ECI,#of Terminal, Status,Start Date, Termination DT"
      set header_line "$header_line, Chgbk MC Cnt, Chgbk MC Amt, Chgbk VS Cnt,Chgbk VS Amt,Chgbk DISC Cnt,Chgbk DISC Amt,Chgbk DB Cnt,Chgbk DB Amt"
      set header_line "$header_line, Representment Cnt, Representment Volume,"
      set header_line "$header_line, Merch Reserve Balance,Address,city,state,zip\r\n"
      puts $cur_file $header_line
      puts "Header: $report_my"

#*** discover id ***
      orasql $header_cursor11 "select unique visa_id, discover_id
                                from merchant
                               where substr(visa_id,1,6) = '402529'"
      while {[orafetch $header_cursor11 -dataarray disc -indexbyname] != 1403} {
          set discno($disc(VISA_ID)) $disc(DISCOVER_ID)
      }
#*** address ***
      set adr_qry "SELECT ena.entity_id as ENTITY_ID,
                          ma.ADDRESS1 as ADDRESS1 ,
                          ma.ADDRESS2 as ADDRESS2,
                          ma.CITY as CITY,
                          ma.POSTAL_CD_ZIP as ZIP,
                          ma.PROV_STATE_ABBREV as STATE 
                   FROM master_address ma, ACQ_ENTITY_ADDRESS ena
                   WHERE ma.address_id = ena.address_id
                     AND ma.institution_id in ($value)
                     AND ena.institution_id in ($value)"
      puts $adr_qry
      orasql $header_cursor1 $adr_qry
      while {[orafetch $header_cursor1 -dataarray adr -indexbyname] != 1403} {
        set address "$adr(ADDRESS1) $adr(ADDRESS2)"
        set city $adr(CITY)
        set zip $adr(ZIP)
        set state $adr(STATE)
        set arradr($adr(ENTITY_ID)) $address
        set arrcity($adr(ENTITY_ID)) $city
        set arrzip($adr(ENTITY_ID)) $zip
        set arrst($adr(ENTITY_ID)) $state
      }
      
#*** Merchant info ***

    set mer_qry "SELECT unique ae.entity_id,
                        replace(ae.entity_dba_name, ',', '') as ENTITY_DBA_NAME,
                        ae.tax_id,
                        ae.default_mcc,ae.actual_start_date,
                        ae.TERMINATION_DATE,
                       ae.PROCESSING_TYPE
                      from acq_entity ae
                      where ae.institution_id in ($value) and
                            ae.actual_start_date <= last_day('$ach_date') "
    #puts "query_string_mer....$mer_qry"
    orasql $header_cursor2 $mer_qry
    while {[orafetch $header_cursor2 -dataarray mer -indexbyname] != 1403} {
            
            if {$mer(TERMINATION_DATE) != ""} {
              set PAY_STATUS INACTIVE
            } else {
              set PAY_STATUS ACTIVE
            }

            set arrname($mer(ENTITY_ID))   $mer(ENTITY_DBA_NAME)
            set arrdate($mer(ENTITY_ID))   $mer(ACTUAL_START_DATE)
            set killdate($mer(ENTITY_ID))  $mer(TERMINATION_DATE)
            set arrtype($mer(ENTITY_ID))   $mer(PROCESSING_TYPE)
            set arrstatus($mer(ENTITY_ID)) $PAY_STATUS
            set arrmcc($mer(ENTITY_ID))    $mer(DEFAULT_MCC)
            set tax($mer(ENTITY_ID))       $mer(TAX_ID)
    }
                  
                  
#*** Funding info ***
    set query_string_acct "select unique OWNER_ENTITY_ID,
                                  ACCT_NBR,
                                  TRANS_ROUTING_NBR
                             from entity_acct
                            where institution_id in ($value)"
    #puts $query_string_acct
    orasql $header_cursor3 $query_string_acct
    while {[orafetch $header_cursor1 -dataarray acct -indexbyname] != 1403} {
      set arraba($acct(OWNER_ENTITY_ID))   $acct(ACCT_NBR)
      set arrdda($acct(OWNER_ENTITY_ID))   $acct(TRANS_ROUTING_NBR)
    }

#*** pull all numbers out ***
    set RESERVE_C           0
    set RESERVE_D           0
    set RESERVE             0
    set CHARGEBACK_C        0
    set CHARGEBACK_D        0
    set CHARGEBACK_COUNT    0
    set REPRESENT_C         0
    set REPRESENT_D         0
    set REPRESENT_COUNT     0
    set VISA_COUNT          0
    set VISA_CREDIT_AMOUNT  0
    set VISA_NET_AMOUNT     0  
    set VISA_AMOUNT         0
    set MC_COUNT            0
    set MC_CREDIT_AMOUNT    0
    set MC_NET_AMOUNT       0
    set MC_AMOUNT           0
    set VS_C                0
    set VS_D                0
    set MC_C                0
    set MC_D                0
    set VS_COUNT            0
    set MC_COUNT            0
    set DB_C                0
    set DB_D                0
    set DB_COUNT            0
    set DS_COUNT            0
    set DS_CREDIT_AMOUNT    0
    set DS_NET_AMOUNT       0  
    set DS_AMOUNT           0
    set DS_C                0
    set DS_D                0
    set DS_COUNT            0

    set MC_CHGBK_C     0
    set MC_CHGBK_D     0
    set VS_CHGBK_C     0
    set VS_CHGBK_D     0
    set DS_CHGBK_C     0
    set DS_CHGBK_D     0
    set DB_CHGBK_C     0
    set DB_CHGBK_D     0
    set MC_CHGBK_CNT   0
    set VS_CHGBK_CNT   0
    set DB_CHGBK_CNT   0
    set DS_CHGBK_CNT   0

    set MTD_MC_CHGBK_C     0
    set MTD_MC_CHGBK_D     0
    set MTD_VS_CHGBK_C     0
    set MTD_VS_CHGBK_D     0
    set MTD_DS_CHGBK_C     0
    set MTD_DS_CHGBK_D     0
    set MTD_DB_CHGBK_C     0
    set MTD_DB_CHGBK_D     0
    set MTD_MC_CHGBK_CNT   0
    set MTD_VS_CHGBK_CNT   0
    set MTD_DB_CHGBK_CNT   0
    set MTD_DS_CHGBK_CNT   0
    set MTD_VISA_CREDIT_COUNT  0
    set MTD_MC_CREDIT_COUNT    0
    set MTD_DISC_CREDIT_COUNT  0
    set MTD_DB_CREDIT_COUNT    0
    
#syang: taking off these counts to match up with I.E and Daily detail
#syang 10-01-2008: chargeback was in ('010003015101', '010003015201', '010003005202')
#syang 03-31-2009 replace tid in ('010003005102',  '010003005101') with tid in ('010003005102', '010003005101', '010003005201', '010003005202')

  #set RESERVE_FLAG "select USER_DEFINED_1 from ACQ_ENTITY_ADD_ON where entity_id = m.entity_id and institution_id = m.institution_id"
  set tid_list1     "'010003015101', '010003015201', '010003005202','010003005301', '010003005401','010003005102', '010003005101', '010003005201', '010003005202'"
  set tid_list2     "'010005050000', '010007050000'"

    set qry_reserve "select mtl.entity_id, sum(amt_original) as TOTAL
                      from mas_trans_log mtl, acct_accum_det acct, entity_acct e
                      where mtl.payment_seq_nbr  = acct.payment_seq_nbr
                          and acct.entity_acct_id = e.entity_acct_id
                          and mtl.institution_id = e.institution_id
                          and mtl.institution_id in ($value)
                          and e.acct_posting_type = 'R'
                         and (acct.payment_status is null or acct.payment_proc_dt  > '$today')
                         and mtl.gl_date < '$tomorrow'
                      group by mtl.entity_id
                      order by mtl.entity_id"  
    
    puts "  qry_reserve: $qry_reserve" 
    orasql $header_cursor7 $qry_reserve
    while {[set syang [orafetch $header_cursor7 -dataarray rem -indexbyname]] == 0} {  
        set arrreserve($rem(ENTITY_ID)) $rem(TOTAL)
        set  RESERVE [expr $RESERVE + $rem(TOTAL)]          
        set MERCHANT_NUM 0               
    }
    set arrMreserve($value) $RESERVE
    set RESERVE 0
                    
    set sale_tid "'010003005102','010003005101','010003005201','010003005202','010123005101','010123005102'"           
    set query_string_all " SELECT  unique decode(institution_id, '105', '105', 'ROLL') as INSTID, entity_id,
        SUM(CASE WHEN (m.tid in ('010003015201','010003015102','010003015101','010003015210' ) and m.tid_settl_method = 'C' and card_scheme = '02') Then m.amt_original else 0 end ) AS DB_CHARGEBACK_C,
        SUM(CASE WHEN (m.tid in ('010003015201','010003015102','010003015101','010003015210' ) and m.tid_settl_method <> 'C' and card_scheme = '02') Then m.amt_original else 0 end ) AS DB_CHARGEBACK_D,
        SUM(CASE WHEN (m.tid in ('010003015201','010003015102','010003015101','010003015210' ) and card_scheme = '02') Then 1 else 0 end ) AS DB_CHARGEBACK_COUNT,
        SUM(CASE WHEN (m.tid in ('010003015201','010003015102','010003015101','010003015210' ) and m.tid_settl_method = 'C' and card_scheme = '04') Then m.amt_original else 0 end ) AS VS_CHARGEBACK_C,
        SUM(CASE WHEN (m.tid in ('010003015201','010003015102','010003015101','010003015210' ) and m.tid_settl_method <> 'C' and card_scheme = '04') Then m.amt_original else 0 end ) AS VS_CHARGEBACK_D,
        SUM(CASE WHEN (m.tid in ('010003015201','010003015102','010003015101','010003015210' ) and card_scheme = '04') Then 1 else 0 end ) AS VS_CHARGEBACK_COUNT,
        SUM(CASE WHEN (m.tid in ('010003015201','010003015102','010003015101','010003015210' ) and m.tid_settl_method = 'C' and card_scheme = '05') Then m.amt_original else 0 end ) AS MC_CHARGEBACK_C,
        SUM(CASE WHEN (m.tid in ('010003015201','010003015102','010003015101','010003015210' ) and m.tid_settl_method <> 'C' and card_scheme = '05') Then m.amt_original else 0 end ) AS MC_CHARGEBACK_D,
        SUM(CASE WHEN (m.tid in ('010003015201','010003015102','010003015101','010003015210' ) and card_scheme = '05') Then 1 else 0 end ) AS MC_CHARGEBACK_COUNT,
        SUM(CASE WHEN (m.tid in ('010003015201','010003015102','010003015101','010003015210' ) and m.tid_settl_method = 'C' and card_scheme = '08') Then m.amt_original else 0 end ) AS DS_CHARGEBACK_C,
        SUM(CASE WHEN (m.tid in ('010003015201','010003015102','010003015101','010003015210' ) and m.tid_settl_method <> 'C' and card_scheme = '08') Then m.amt_original else 0 end ) AS DS_CHARGEBACK_D,
        SUM(CASE WHEN (m.tid in ('010003015201','010003015102','010003015101','010003015210' ) and card_scheme = '08') Then 1 else 0 end ) AS DS_CHARGEBACK_COUNT,
        SUM(CASE WHEN (m.tid in ('010003005301','010003005401','010003010102','010003010101') and m.tid_settl_method = 'C' ) Then m.amt_original else 0 end ) AS REPRESENT_C,
        SUM(CASE WHEN (m.tid in ('010003005301','010003005401','010003010102','010003010101') and m.tid_settl_method <> 'C' ) Then m.amt_original else 0 end ) AS REPRESENT_D,
        SUM(CASE WHEN (m.tid in ('010003005301','010003005401','010003010102','010003010101')) Then 1 else 0 end ) AS REPRESENT_COUNT,
        SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '04' ) Then 1 else 0 end) AS VS_COUNT,
        SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '05') Then 1 else 0 end) AS MC_COUNT,
        SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '02') Then 1 else 0 end) AS DB_COUNT,
        SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '08' ) Then 1 else 0 end) AS DS_COUNT,
        SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '04' and m.tid_settl_method <> 'C') Then 1 else 0 end) AS VS_D_COUNT,
        SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '05' and m.tid_settl_method <> 'C') Then 1 else 0 end) AS MC_D_COUNT,
        SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '02' and m.tid_settl_method <> 'C') Then 1 else 0 end) AS DB_D_COUNT,
        SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '08' and m.tid_settl_method <> 'C') Then 1 else 0 end) AS DS_D_COUNT,
        SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '04' and m.tid_settl_method = 'C') Then m.amt_original else 0 end )  AS VS_C,
        SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '04' and m.tid_settl_method <> 'C') Then m.amt_original else 0 end ) AS VS_D,
        SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '02' and m.tid_settl_method = 'C') Then m.amt_original else 0 end ) AS DB_C,
        SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '02' and m.tid_settl_method <> 'C') Then m.amt_original else 0 end ) AS DB_D,
        SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '08' and m.tid_settl_method = 'C') Then m.amt_original else 0 end )  AS DS_C,
        SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '08' and m.tid_settl_method <> 'C') Then m.amt_original else 0 end ) AS DS_D,
        SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '05' and m.tid_settl_method = 'C') Then m.amt_original else 0 end ) AS MC_C,
        SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '05' and m.tid_settl_method <> 'C') Then m.amt_original else 0 end ) AS MC_D
     FROM mas_trans_log m
     WHERE gl_date like '%$report_my%' and 
           institution_id in ($value) and
           settl_flag = 'Y' 
      group by  rollup (entity_id), institution_id
     having SUM(CASE WHEN (m.tid in ($tid_list1)) Then 1 else 0 end ) <> 0 
     order by entity_id "
                           
puts "query_string_all: $query_string_all  "                    
    orasql $header_cursor5 $query_string_all
    while {[set syang [orafetch $header_cursor5 -dataarray all -indexbyname]] == 0} {
          set MERCHANT_NUM         $all(ENTITY_ID)
          if {$all(INSTID) == "105" &&  [string length $all(ENTITY_ID)] == "15"} {
              set arrrepcnt($all(ENTITY_ID))  $all(REPRESENT_COUNT) 
              set arrvscnt($all(ENTITY_ID))   $all(VS_COUNT) 
              set arrmccnt($all(ENTITY_ID))   $all(MC_COUNT)
              set arrdscnt($all(ENTITY_ID))   $all(DS_COUNT)
              set arrvsccnt($all(ENTITY_ID))  $all(VS_D_COUNT) 
              set arrmcccnt($all(ENTITY_ID))  $all(MC_D_COUNT) 
              set arrdsccnt($all(ENTITY_ID))  $all(DS_D_COUNT) 
              set arrvscamt($all(ENTITY_ID))  $all(VS_D)   ;# Credit amount = Refund
              set arrmccamt($all(ENTITY_ID))  $all(MC_D)   ;# Credit amount = Refund
              set arrdscamt($all(ENTITY_ID))  $all(DS_D)   ;# Credit amount = Refund
              set arrrepamt($all(ENTITY_ID))  [expr $all(REPRESENT_C) -   $all(REPRESENT_D)]
              set arrvsnet($all(ENTITY_ID))   [expr  $all(VS_C)  - $all(VS_D)]
              set arrmcnet($all(ENTITY_ID))   [expr $all(MC_C) - $all(MC_D) ]
              set arrdsnet($all(ENTITY_ID))   [expr  $all(DS_C)  - $all(DS_D)]
              set arrvsamt($all(ENTITY_ID))   $all(VS_C)   ;# Total VS sales
              set arrmcamt($all(ENTITY_ID))   $all(MC_C)   ;# Total MC sales
              set arrdsamt($all(ENTITY_ID))   $all(DS_C)   ;# Total VS sales
              set arrdbcnt($all(ENTITY_ID))   $all(DB_COUNT)
              set arrdbcamt($all(ENTITY_ID))  $all(DB_D)
              set arrdbnet($all(ENTITY_ID))   [expr  $all(DB_C)  - $all(DB_D)]
              set arrdbamt($all(ENTITY_ID))   $all(DB_C) 
    
              set  arrvsccnt($MERCHANT_NUM)      $all(VS_D_COUNT)
              set  arrmcccnt($MERCHANT_NUM)      $all(MC_D_COUNT)
              set  arrdsccnt($MERCHANT_NUM)      $all(DS_D_COUNT)
              set  arrdbccnt($MERCHANT_NUM)      $all(DB_D_COUNT)
              set  arrmcchgcnt($MERCHANT_NUM)    $all(MC_CHARGEBACK_COUNT)
              set  arrmcchgamt($MERCHANT_NUM)    [expr  $all(MC_CHARGEBACK_C)  -  $all(MC_CHARGEBACK_D)]
              set  arrvschgcnt($MERCHANT_NUM)    $all(VS_CHARGEBACK_COUNT)
              set  arrvschgamt($MERCHANT_NUM)    [expr  $all(VS_CHARGEBACK_C)  -  $all(VS_CHARGEBACK_D)]
              set  arrdschgcnt($MERCHANT_NUM)    $all(DS_CHARGEBACK_COUNT)
              set  arrdschgamt($MERCHANT_NUM)    [expr  $all(DS_CHARGEBACK_C)  -  $all(DS_CHARGEBACK_D)]
              set  arrdbchgcnt($MERCHANT_NUM)    $all(DB_CHARGEBACK_COUNT)
              set  arrdbchgamt($MERCHANT_NUM)    [expr  $all(DB_CHARGEBACK_C)  -  $all(DB_CHARGEBACK_D)]           
          } elseif {$all(INSTID) == "105" &&  [string length $all(ENTITY_ID)] < "2"} {
              set MTD_REPRESENT_COUNT      $all(REPRESENT_COUNT)
              set MTD_REPRESENT_VOLUME     [expr $all(REPRESENT_C) - $all(REPRESENT_D)]              
              set MTD_VISA_COUNT           $all(VS_COUNT)  
              set MTD_VISA_CREDIT_AMOUNT   $all(VS_D)
              set MTD_VISA_NET_AMOUNT      [expr $all(VS_C) - $all(VS_D)]
              set MTD_VISA_AMOUNT          $all(VS_C)                                    
              set MTD_MC_COUNT             $all(MC_COUNT)
              set MTD_MC_CREDIT_AMOUNT     $all(MC_D)
              set MTD_MC_NET_AMOUNT        [expr $all(MC_C) - $all(MC_D)]
              set MTD_MC_AMOUNT            $all(MC_C)               
              set MTD_DISC_COUNT           $all(DS_COUNT)  
              set MTD_DISC_CREDIT_AMOUNT   $all(DS_D)
              set MTD_DISC_NET_AMOUNT      [expr $all(DS_C) - $all(DS_D)]
              set MTD_DISC_AMOUNT          $all(DS_C)                                                    
              set MTD_DB_COUNT             $all(DB_COUNT)  
              set MTD_DB_CREDIT_AMOUNT     $all(DB_D)
              set MTD_DB_NET_AMOUNT        [expr $all(DB_C) - $all(DB_D)]
              set MTD_DB_AMOUNT            $all(DB_C)
              set MTD_MC_CHGBK             [expr $all(MC_CHARGEBACK_C) - $all(MC_CHARGEBACK_D)]
              set MTD_VS_CHGBK             [expr $all(VS_CHARGEBACK_C) - $all(VS_CHARGEBACK_D)]
              set MTD_DS_CHGBK             [expr $all(DS_CHARGEBACK_C) - $all(DS_CHARGEBACK_D)]
              set MTD_DB_CHGBK             [expr $all(DB_CHARGEBACK_C) -$all(DB_CHARGEBACK_D)]
              set MTD_MC_CHGBK_CNT         $all(MC_CHARGEBACK_COUNT)
              set MTD_VS_CHGBK_CNT         $all(VS_CHARGEBACK_COUNT)
              set MTD_DB_CHGBK_CNT         $all(DB_CHARGEBACK_COUNT)
              set MTD_DS_CHGBK_CNT         $all(DS_CHARGEBACK_COUNT)
              set MTD_VISA_CREDIT_COUNT    $all(VS_D_COUNT)
              set MTD_MC_CREDIT_COUNT      $all(MC_D_COUNT)
              set MTD_DISC_CREDIT_COUNT    $all(DS_D_COUNT)
              set MTD_DB_CREDIT_COUNT      $all(DB_D_COUNT)          
          }
    }
                 
  
#*** REJECTS ***

      set reject_mtd1 "select merch_id,
                              to_char(sum(amt_trans)/100, '999999.00') as amt_trans,
                              count(pan) as count,
                              card_scheme 
                        from in_draft_main 
                        where msg_text_block like '%JPREJECT%' and
                              (activity_dt > '01-$report_my' and substr(activity_dt, 1, 9) <= last_day('$ach_date')) and
                              SEC_DEST_INST_ID in ($value)
                        group by merch_id, card_scheme"
                        
      orasql $header_cursor7 $reject_mtd1
      puts "reject_mtd1:$reject_mtd1"
      while {[orafetch $header_cursor7 -dataarray mtdw -indexbyname] != 1403} {
        if {$mtdw(CARD_SCHEME) == "04"} {
            set vrej($mtdw(MERCH_ID)) $mtdw(AMT_TRANS)
        } elseif {$mtdw(CARD_SCHEME) == "05"} {
            set mrej($mtdw(MERCH_ID)) $mtdw(AMT_TRANS)
        } elseif {$mtdw(CARD_SCHEME) == "02"} {
            set brej($mtdw(MERCH_ID)) $mtdw(AMT_TRANS)
        } elseif {$mtdw(CARD_SCHEME) == "08"} {
            set drej($mtdw(MERCH_ID)) $mtdw(AMT_TRANS)
        }
      }

#*** Terminal Info ***
      set query_terminal "select  unique m.visa_id as VID, count(t.tid) as TERM_CNT
                            from terminal t, merchant m
                           where t.mid = m.mid and
                                 substr(m.visa_id, 1, 6) in ('447474', '454045', '402529') and 
                                 t.active = 'A'
                           group by m.visa_id
                           order by m.visa_id"
      puts $query_terminal
      orasql $header_cursor10 $query_terminal
      while {[orafetch $header_cursor10 -dataarray term -indexbyname] != 1403} {
              set termcnt($term(VID)) $term(TERM_CNT)                      
      }
#===============================================================================        
#==========================       MAIN:       ==================================
#===============================================================================

     set qry_main "SELECT  unique ae.entity_id
                    FROM acq_entity ae, mas_trans_log m
                   WHERE ae.entity_id = m.entity_id
                      AND ae.institution_id = m.institution_id
                      AND ae.institution_id in ($value) 
                      AND ae.ENTITY_LEVEL = '70' 
                      AND (((ae.TERMINATION_DATE is null and ae.actual_start_date <= last_day('$ach_date')) or
                          (ae.TERMINATION_DATE > '01-$report_my' and ae.actual_start_date <= last_day('$ach_date')))
                          OR (m.gl_date like '%$report_my%' or date_to_settle like '%$report_my%'))
                   ORDER BY entity_id  "
     puts "MAIN: $qry_main"
      orasql $header_cursor4 $qry_main
      while {[set syang [orafetch $header_cursor4 -dataarray main -indexbyname]] == 0} {
            
          set MERCHANT_NUM $main(ENTITY_ID)            
          catch {set syangtax $tax($MERCHANT_NUM)}       resulttax 
          catch {set syangchg $arrchgcnt($MERCHANT_NUM)} resultchgcnt
          catch {set syangchg $arrchgamt($MERCHANT_NUM)} resultchgamt
          catch {set syangrep $arrrepcnt($MERCHANT_NUM)} resultrepcnt
          catch {set syangrep $arrrepamt($MERCHANT_NUM)} resultrepamt
          catch {set syangmc $arrmccnt($MERCHANT_NUM)}   resultmccnt
          catch {set syang $killdate($MERCHANT_NUM)}     resulttermdt
          catch {set syang $arrvscnt($MERCHANT_NUM)}     resultvscnt
          catch {set syang $arrvsamt($MERCHANT_NUM)}     resultvsamt
          catch {set syang $arrvscamt($MERCHANT_NUM)}    resultvscamt
          catch {set syang $arrvsnet($MERCHANT_NUM)}     resultvsnet
          catch {set syang $arrmccnt($MERCHANT_NUM)}     resultmccnt
          catch {set syang $arrmcamt($MERCHANT_NUM)}     resultmcamt
          catch {set syang $arrmccamt($MERCHANT_NUM)}    resultmccamt
          catch {set syang $arrmcnet($MERCHANT_NUM)}     resultmcnet
          catch {set syang $arrreserve($MERCHANT_NUM)}   resultreserve
          catch {set syang $mrej($MERCHANT_NUM)}         resultmrej
          catch {set syang $vrej($MERCHANT_NUM)}         resultvrej
          catch {set syang $brej($MERCHANT_NUM)}         resultbrej
          catch {set syang $termcnt($MERCHANT_NUM)}      resultterm
          catch {set syang $arrdbcnt($MERCHANT_NUM)}     resultdbcnt
          catch {set syang $arrdbamt($MERCHANT_NUM)}     resultdbamt
          catch {set syang $arrdbcamt($MERCHANT_NUM)}    resultdbcamt
          catch {set syang $arrdbnet($MERCHANT_NUM)}     resultdbnet            
          catch {set syang $arrdscnt($MERCHANT_NUM)}     resultdscnt
          catch {set syang $arrdsamt($MERCHANT_NUM)}     resultdsamt
          catch {set syang $arrdscamt($MERCHANT_NUM)}    resultdscamt
          catch {set syang $arrdsnet($MERCHANT_NUM)}     resultdsnet
          catch {set syang $drej($MERCHANT_NUM)}         resultdrej
          catch {set syang $arrvsccnt($MERCHANT_NUM)}    resultvsc
          catch {set syang $arrmcccnt($MERCHANT_NUM)}    resultmcc
          catch {set syang $arrdsccnt($MERCHANT_NUM)}    resultdsc
          catch {set syang $arrdbccnt($MERCHANT_NUM)}    resultdbc
          catch {set syang $arrmcchgcnt($MERCHANT_NUM)}  resultmcchgcnt
          catch {set syang $arrmcchgamt($MERCHANT_NUM)}  resultmcchgamt
          catch {set syang $arrvschgcnt($MERCHANT_NUM)}  resultvschgcnt
          catch {set syang $arrvschgamt($MERCHANT_NUM)}  resultvschgamt
          catch {set syang $arrdschgcnt($MERCHANT_NUM)}  resultdschgcnt
          catch {set syang $arrdschgamt($MERCHANT_NUM)}  resultdschgamt
          catch {set syang $arrdbchgcnt($MERCHANT_NUM)}  resultdbchgcnt
          catch {set syang $arrdbchgamt($MERCHANT_NUM)}  resultdbchgamt
          catch {set syang $discno($MERCHANT_NUM)}       resultdiscno
          
          if {[string range $resultdiscno 0 9] == "can't read"} {   
            set discno($MERCHANT_NUM) 0
          } 
          if {[string range $resulttax 0 9] == "can't read"} {   
            set tax($MERCHANT_NUM) 0
          }                         
          if {[string range $resultvsc 0 9] == "can't read"} {   
            set arrvsccnt($MERCHANT_NUM) 0
          }
          if {[string range $resultmcc 0 9] == "can't read"} {   
            set arrmcccnt($MERCHANT_NUM) 0
          }
          if {[string range $resultdsc 0 9] == "can't read"} {   
            set arrdsccnt($MERCHANT_NUM) 0
          }
          if {[string range $resultdbc 0 9] == "can't read"} {   
            set arrdbccnt($MERCHANT_NUM) 0
          }
          if {[string range $resultmcchgcnt 0 9] == "can't read"} {   
            set arrmcchgcnt($MERCHANT_NUM) 0
          }
          if {[string range $resultmcchgamt 0 9] == "can't read"} {   
            set arrmcchgamt($MERCHANT_NUM) 0
          }
          if {[string range $resultvschgcnt 0 9] == "can't read"} {   
            set arrvschgcnt($MERCHANT_NUM) 0
          }
          if {[string range $resultvschgamt 0 9] == "can't read"} {   
            set arrvschgamt($MERCHANT_NUM) 0
          }
          if {[string range $resultdschgcnt 0 9] == "can't read"} {   
            set arrdschgcnt($MERCHANT_NUM) 0
          }
          if {[string range $resultdschgamt 0 9] == "can't read"} {
            set arrdschgamt($MERCHANT_NUM) 0
          }
          if {[string range $resultdbchgcnt 0 9] == "can't read"} {   
            set arrdbchgcnt($MERCHANT_NUM) 0
          }
          if {[string range $resultdbchgamt 0 9] == "can't read"} {   
            set arrdbchgamt($MERCHANT_NUM) 0
          }     
          if {[string range $resultdscnt 0 9] == "can't read"} {
              set arrdscnt($MERCHANT_NUM) 0
          }
          if {[string range $resultdsamt 0 9] == "can't read"} {
              set arrdsamt($MERCHANT_NUM) 0
          }
          if {[string range $resultdscamt 0 9] == "can't read"} {
              set arrdscamt($MERCHANT_NUM) 0
          }  
          if {[string range $resultdsnet 0 9] == "can't read"} {
              set arrdsnet($MERCHANT_NUM) 0
          }  
          if {[string range $resultdrej 0 9] == "can't read"} {
              set drej($MERCHANT_NUM) 0
          }        
          if {[string range $resultbrej 0 9] == "can't read"} {
              set brej($MERCHANT_NUM) 0
          }  
          if {[string range $resultdbcnt 0 9] == "can't read"} {
              set arrdbcnt($MERCHANT_NUM) 0
          }
          if {[string range $resultdbamt 0 9] == "can't read"} {
              set arrdbamt($MERCHANT_NUM) 0
          } 
          if {[string range $resultdbcamt 0 9] == "can't read"} {
              set arrdbcamt($MERCHANT_NUM) 0
          }
          if {[string range $resultdbnet 0 9] == "can't read"} {
              set arrdbnet($MERCHANT_NUM) 0
          }            
          if {[string range $resultterm 0 9] == "can't read"} {
              set termcnt($MERCHANT_NUM) 0
          }           
          if {[string range $resultmrej 0 9] == "can't read"} {
              set mrej($MERCHANT_NUM) 0
          } 
          if {[string range $resultvrej 0 9] == "can't read"} {
              set vrej($MERCHANT_NUM) 0
          } 
          if {[string range $resultreserve 0 9] == "can't read"} {
              set arrreserve($MERCHANT_NUM) 0
          }
          if {[string range $resultvsnet 0 9] == "can't read"} {
              set arrvsnet($MERCHANT_NUM) 0
          }
          if {[string range $resultmcnet 0 9] == "can't read"} {
              set arrmcnet($MERCHANT_NUM) 0
          }
          if {[string range $resultvsamt 0 9] == "can't read"} {
              set arrvsamt($MERCHANT_NUM) 0
          } 
          if {[string range $resultvscamt 0 9] == "can't read"} {
              set arrvscamt($MERCHANT_NUM) 0
          }   
          if {[string range $resultmcamt 0 9] == "can't read"} {
              set arrmcamt($MERCHANT_NUM) 0
          }   
          if {[string range $resultmccnt 0 9] == "can't read"} {
              set arrmccnt($MERCHANT_NUM) 0
          }   
          if {[string range $resultmccamt 0 9] == "can't read"} {
              set arrmccamt($MERCHANT_NUM) 0
          }
          if {[string range $resultchgamt 0 9] == "can't read"} {
              set arrchgamt($MERCHANT_NUM) 0
          }
          if {[string range $resultchgcnt 0 9] == "can't read"} {
              set arrchgcnt($MERCHANT_NUM) 0
          }
          if {[string range $resultrepamt 0 9] == "can't read" } {
              set  arrrepamt($MERCHANT_NUM)  0
          }            
          if {[string range $resultrepcnt 0 9] == "can't read" } {
              set  arrrepcnt($MERCHANT_NUM)  0
          }
          if { [string range $resultvscnt 0 9] == "can't read" } {
              set arrvscnt($MERCHANT_NUM) 0
          } 
          if { [string range $resultmccnt 0 9] == "can't read" } {
              set arrmccnt($MERCHANT_NUM) 0
          } 
          if { [string range $resulttermdt 0 9 ] == "can't read" } {
              set killdate($MERCHANT_NUM) ""
          }   
      
        set entry_data " $MERCHANT_NUM,$discno($MERCHANT_NUM),$arrname($MERCHANT_NUM),$report_date ,$arrvscnt($MERCHANT_NUM)"
        set entry_data "$entry_data, $arrvsamt($MERCHANT_NUM),$arrvsccnt($MERCHANT_NUM),$arrvscamt($MERCHANT_NUM)"
        set entry_data "$entry_data, $arrvsnet($MERCHANT_NUM),$arrmccnt($MERCHANT_NUM)"
        set entry_data "$entry_data, $arrmcamt($MERCHANT_NUM),$arrmcccnt($MERCHANT_NUM), $arrmccamt($MERCHANT_NUM), $arrmcnet($MERCHANT_NUM)"
        set entry_data "$entry_data, $arrdscnt($MERCHANT_NUM), $arrdsamt($MERCHANT_NUM), $arrdsccnt($MERCHANT_NUM), $arrdscamt($MERCHANT_NUM)"
        set entry_data "$entry_data, $arrdsnet($MERCHANT_NUM), , ,$arrdbcnt($MERCHANT_NUM)"
        set entry_data "$entry_data, $arrdbamt($MERCHANT_NUM), $arrdbccnt($MERCHANT_NUM),$arrdbcamt($MERCHANT_NUM)"
        set entry_data "$entry_data, $arrdbnet($MERCHANT_NUM),$arrmcc($MERCHANT_NUM),$tax($MERCHANT_NUM), $arrtype($MERCHANT_NUM)"
        set entry_data "$entry_data, $termcnt($MERCHANT_NUM), $arrstatus($MERCHANT_NUM),$arrdate($MERCHANT_NUM),$killdate($MERCHANT_NUM)"
        set entry_data "$entry_data, $arrmcchgcnt($MERCHANT_NUM), $arrmcchgamt($MERCHANT_NUM)"
        set entry_data "$entry_data, $arrvschgcnt($MERCHANT_NUM), $arrvschgamt($MERCHANT_NUM)"
        set entry_data "$entry_data, $arrdschgcnt($MERCHANT_NUM), $arrdschgamt($MERCHANT_NUM)"
        set entry_data "$entry_data, $arrdbchgcnt($MERCHANT_NUM), $arrdbchgamt($MERCHANT_NUM)"
        set entry_data "$entry_data, $arrrepcnt($MERCHANT_NUM), $arrrepamt($MERCHANT_NUM)"
        set entry_data "$entry_data, $arrreserve($MERCHANT_NUM) ,$arradr($MERCHANT_NUM), $arrcity($MERCHANT_NUM),$arrst($MERCHANT_NUM),$arrzip($MERCHANT_NUM)\r"
        puts $cur_file $entry_data
      }     
      set V_OUTGOING_REJECT 0 
      set M_OUTGOING_REJECT 0
      set B_OUTGOING_REJECT 0
      set D_OUTGOING_REJECT 0
      
      set reject_mtd2 "select to_char(sum(amt_trans)/100, '999999.00') as amt_trans, count(pan) as count, card_scheme
                        from in_draft_main
                        where msg_text_block like '%JPREJECT%'
                              and (activity_dt > '01-$report_my' and substr(activity_dt, 1, 9) <= last_day('$ach_date'))
                              and SEC_DEST_INST_ID in ($value)
                        group by card_scheme"
                        
      orasql $header_cursor8 $reject_mtd2
      puts "reject mtd....$reject_mtd2"
      while {[orafetch $header_cursor8 -dataarray mtdw -indexbyname] != 1403} {
        if {$mtdw(CARD_SCHEME) == "04"} {
            set V_OUTGOING_REJECT $mtdw(AMT_TRANS)
        } elseif {$mtdw(CARD_SCHEME) == "05"} {
            set M_OUTGOING_REJECT $mtdw(AMT_TRANS)
        } elseif {$mtdw(CARD_SCHEME) == "02"} {
            set B_OUTGOING_REJECT $mtdw(AMT_TRANS)
        }  elseif {$mtdw(CARD_SCHEME) == "08"} {
            set D_OUTGOING_REJECT $mtdw(AMT_TRANS)
        }
      }           
      puts " V_OUTGOING_REJECT: $V_OUTGOING_REJECT...  M_OUTGOING_REJECT: $M_OUTGOING_REJECT...D_OUTGOING_REJECT: $D_OUTGOING_REJECT... B_OUTGOING_REJECT:$B_OUTGOING_REJECT"
      
      set syang "SUBTOTAL: "
      puts $cur_file " "
      set mtd_data ",,,$syang,$MTD_VISA_COUNT,$MTD_VISA_AMOUNT ,$MTD_VISA_CREDIT_COUNT,$MTD_VISA_CREDIT_AMOUNT,$MTD_VISA_NET_AMOUNT"
      set mtd_data "$mtd_data,$MTD_MC_COUNT,$MTD_MC_AMOUNT,$MTD_MC_CREDIT_COUNT, $MTD_MC_CREDIT_AMOUNT, $MTD_MC_NET_AMOUNT"
      set mtd_data "$mtd_data,$MTD_DISC_COUNT,$MTD_DISC_AMOUNT ,$MTD_DISC_CREDIT_COUNT,$MTD_DISC_CREDIT_AMOUNT, $MTD_DISC_NET_AMOUNT"
      set mtd_data "$mtd_data,,,$MTD_DB_COUNT,$MTD_DB_AMOUNT,$MTD_DB_CREDIT_COUNT,$MTD_DB_CREDIT_AMOUNT"
      set mtd_data "$mtd_data, $MTD_DB_NET_AMOUNT,,,,,,,"
      set mtd_data "$mtd_data, $MTD_MC_CHGBK_CNT,$MTD_MC_CHGBK"
      set mtd_data "$mtd_data, $MTD_VS_CHGBK_CNT,$MTD_VS_CHGBK"
      set mtd_data "$mtd_data, $MTD_DS_CHGBK_CNT,$MTD_DS_CHGBK"
      set mtd_data "$mtd_data, $MTD_DB_CHGBK_CNT,$MTD_DB_CHGBK"
      set mtd_data "$mtd_data, $MTD_REPRESENT_COUNT,$MTD_REPRESENT_VOLUME"
      set mtd_data "$mtd_data, $arrMreserve($value),\r"
      puts $cur_file $mtd_data

      close $cur_file
      puts "$value...$cur_file_name"
      exec uuencode $cur_file_name $file_name | mailx -r clearing@jetpay.com -s $file_name reports-clearing@jetpay.com



oraclose $header_cursor1
oraclose $header_cursor2
oraclose $header_cursor3
oraclose $header_cursor4
oraclose $header_cursor5
oraclose $header_cursor6
oraclose $header_cursor7
oraclose $header_cursor8
oraclose $header_cursor9
oraclose $header_cursor10
oraclose $header_cursor11
oraclose $header_cursor12
oraclose $header_cursor13
oraclose $header_cursor14
oralogoff $handler
             
# *******************************************************     END        **********************************************************
