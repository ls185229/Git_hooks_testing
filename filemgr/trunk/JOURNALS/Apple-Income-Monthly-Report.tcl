#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

#$Id: Apple-Income-Monthly-Report.tcl 4572 2018-05-18 20:42:55Z bjones $

#******************        Modification History          *************************
# Version 1.00 Sunny Yang 01-DEC-2009
# -------- updated ISA and Cross Border fee parts
#
# Version 1.00 Sunny Yang 29-AUG-2008
# -------- Automate Apple's Monthly Income Report for Marcy

##################################################################################


#Environment veriables.......

set clruser $env(IST_DB_USERNAME)
set clrpwd $env(IST_DB_PASSWORD)
set clrdb $env(SEC_DB)
#set clrdb trnclr4
set authdb $env(ATH_DB)
#set authdb auth2

####################################################################################################################


#**********************   SYANG  ************************************************

package require Oratcl

if {[catch {set handlerM [oralogon $clruser/$clrpwd@$clrdb]} result]} {
  ## exec echo "MASCLR: Apple-Income-Monthly-Report.tcl failed to run" | mailx -r $mailfromlist -s "MASCLR: Apple-Income-Monthly-Report.tcl failed to run" jsmith@jetpay.com
    exec echo "MASCLR: Apple-Income-Monthly-Report.tcl failed to run" | mailx -r $mailfromlist -s "MASCLR: Apple-Income-Monthly-Report.tcl failed to run" clearing@jetpay.com
  exit
} else {
    puts "COnnected"
}


#puts $env(SEC_DB)

set M_cursor [oraopen $handlerM]

proc init_dates { val } {
    global CUR_JULIAN_DATEX name_date report_month report_my next_my

    set date  [ string toupper [clock format [ clock scan "$val" -format %Y%m%d ] -format %d-%b-%Y ]]

    set report_month     [string toupper [clock format [ clock scan "$date" ] -format %B-%Y ]]

    set report_my           [string toupper [clock format [ clock scan "$date" ] -format %b-%Y ]]
    set next_my             [string toupper [clock format [ clock scan "$date +1 month" ] -format %b-%Y ]]
    set CUR_JULIAN_DATEX    [string range [clock format [ clock scan "-0 day " ] -format "%y%j"] 1 4]
    set name_date           [clock format [clock scan "-0 day"] -format %Y%m%d]

}

if { $argc == 1 } {

    set arg0_len [string length [lindex $argv 0]]

    if { $arg0_len == 6 } {
        set dt [lindex $argv 0]                         ;#yyyymm 201203
        init_dates "${dt}01"
    } else {
        puts "USAGE: $argv0 \[date yyyymm\]"
        exit
    }

} else {
    init_dates "[clock format [clock scan "-1 month"] -format %Y%m]01"
}

#set cur_file_name "./ROLLUP.REPORT.HEADER.$CUR_JULIAN_DATEX.$name_date.001.csv"
#set file_name     "ROLLUP.REPORT.HEADER.$CUR_JULIAN_DATEX.$name_date.001.csv"

set cur_file_name  "./APPLE.INCOME.MONTHLY.REPORT.$CUR_JULIAN_DATEX.$name_date.csv"
set file_name      "APPLE.INCOME.MONTHLY.REPORT.$CUR_JULIAN_DATEX.$name_date.csv"
set cur_file       [open "$cur_file_name" w]

puts $cur_file "APPLE MONTHLY INCOME REPORT"
puts $cur_file "Date:,$report_month"
puts $cur_file "Merchant ID, Merchant Name, Tran Count, Sales, Gross Income, Interchange, Assess Fee, MC&VS Fees, Discount,  Net Income\r\n"

#        set last_day "select TO_CHAR(LAST_DAY(to_date('$date')),'DD-MON-YY') as LAST_DAY
#                            from dual "

set SUB_FEE             0
set SUB_ASSESS          0
set SUB_INCHG           0
set SUB_DISCOUNT        0
set SUB_TRAN_COUNT      0
set SUB_SALES_AMT       0
set GROSS_INCOME        0
set NET                 0
set SUB_GROSS           0
set SUB_NET             0
#    ******    pull fees out    **********

#set query_fee " SELECT unique entity_id,
#               SUM(CASE WHEN(mas_code in ('MC_BORDER','MC_GLOBAL_ACQ') and tid like '010004%') then amt_original else 0 end) as MC_BORDER_FEE,
#               SUM(CASE WHEN(mas_code in ('VS_ISA_FEE','VS_ISA_HI_RISK_FEE') and tid like '010004%') then amt_original else 0 end) as VS_ISA_FEE,
#               (SUM(CASE WHEN( m.tid in ('010004030000') and m.tid_settl_method = 'D' and m.card_scheme in ('04','05') ) then AMT_ORIGINAL else 0 end) \
#                 - SUM(CASE WHEN( m.tid in ('010004030000') and m.tid_settl_method = 'C' and m.card_scheme = '05') then AMT_ORIGINAL else 0 end)) as ASSESSMENT_AMT,
#               (SUM(CASE WHEN( m.tid in ('010004020000', '010004020005') and m.tid_settl_method = 'D' ) then AMT_ORIGINAL else 0 end) \
#                 - SUM(CASE WHEN( m.tid in ('010004020000', '010004020005') and m.tid_settl_method = 'C' ) then AMT_ORIGINAL else 0 end)) as INTERCHANGE_AMT,
#               SUM(CASE WHEN(mas_code in ('VISA_DISCOUNT', 'MC_DISCOUNT')) then m.amt_original else 0 end ) as DISCOUNT
#                       FROM mas_trans_log m
#                       WHERE date_to_settle >= '01-$report_my' AND date_to_settle < '01-$next_my' and
#                             institution_id = '101' and
#                             entity_id in ('447474210000133', '447474210000135', '447474210000136', '447474210000139', '447474310000101')
#                       group by entity_id
#                       order by entity_id "

set query_fee "SELECT unique entity_id,
                SUM(CASE WHEN( m.tid_settl_method = 'C') then AMT_ORIGINAL else 0 end) as TOTAL_FEES_C,
                SUM(CASE WHEN( m.tid_settl_method <> 'C') then AMT_ORIGINAL else 0 end) as TOTAL_FEES_D,
                SUM(CASE WHEN(mas_code in ('MC_BORDER','MC_GLOBAL_ACQ') and tid like '010004%') then amt_original else 0 end) as MC_BORDER_FEE,
                SUM(CASE WHEN(mas_code in ('VS_ISA_FEE','VS_ISA_HI_RISK_FEE') and tid like '010004%') then amt_original else 0 end) as VS_ISA_FEE,
                SUM(CASE WHEN( m.tid in ('010004020000', '010004020005') and m.tid_settl_method = 'D' ) then AMT_ORIGINAL else 0 end) as INTERCHANGE_AMT_D,
                SUM(CASE WHEN( m.tid in ('010004020000', '010004020005') and m.tid_settl_method = 'C' ) then AMT_ORIGINAL else 0 end) as INTERCHANGE_AMT_C,
                SUM(CASE WHEN(mas_code in ('VISA_DISCOUNT', 'MC_DISCOUNT')) then m.amt_original else 0 end ) as DISCOUNT,
                /*Not very Clean.. everything not included above goes to assessment fees*/
                SUM(CASE WHEN (mas_code in ('MC_BORDER','MC_GLOBAL_ACQ') and tid like '010004%') then 0
                         WHEN (mas_code in ('VS_ISA_FEE','VS_ISA_HI_RISK_FEE') and tid like '010004%') then 0
                         WHEN (m.tid in ('010004020000', '010004020005') ) then 0
                         WHEN (mas_code in ('VISA_DISCOUNT', 'MC_DISCOUNT')) then 0
                         WHEN (m.tid_settl_method <> 'C') then 0
                         ELSE  AMT_ORIGINAL end) as TOTAL_ASSESS_C,
                SUM(CASE WHEN (mas_code in ('MC_BORDER','MC_GLOBAL_ACQ') and tid like '010004%') then 0
                         WHEN (mas_code in ('VS_ISA_FEE','VS_ISA_HI_RISK_FEE') and tid like '010004%') then 0
                         WHEN (m.tid in ('010004020000', '010004020005') ) then 0
                         WHEN (mas_code in ('VISA_DISCOUNT', 'MC_DISCOUNT')) then 0
                         WHEN (m.tid_settl_method = 'C') then 0
                         ELSE  AMT_ORIGINAL end) as TOTAL_ASSESS_D
                       FROM mas_trans_log m
                       WHERE date_to_settle >= '01-$report_my' AND date_to_settle < '01-$next_my'
                             and institution_id = '101'
                             and entity_id in ('447474210000133', '447474210000135', '447474210000136', '447474210000139', '447474310000101')
                             and (substr(m.tid, 1,8) = '01000507' OR substr(m.tid, 1,6) in ('010004','010040','010050','010080','010014'))
                       group by entity_id
                       order by entity_id"

puts $query_fee
orasql $M_cursor $query_fee
while {[set syang [orafetch $M_cursor -dataarray fee -indexbyname]] == 0} {
    set arrfee($fee(ENTITY_ID))      [expr $fee(MC_BORDER_FEE) + $fee(VS_ISA_FEE)]
    set arrassess($fee(ENTITY_ID))   [expr $fee(TOTAL_ASSESS_D) - $fee(TOTAL_ASSESS_C)]
    set arrinchg($fee(ENTITY_ID))    [expr $fee(INTERCHANGE_AMT_D) - $fee(INTERCHANGE_AMT_C)]
    set arrdiscount($fee(ENTITY_ID)) $fee(DISCOUNT)

    set SUB_FEE      [expr $SUB_FEE  + [expr $fee(MC_BORDER_FEE) + $fee(VS_ISA_FEE)]]
    set SUB_ASSESS   [expr $SUB_ASSESS + [expr $fee(TOTAL_ASSESS_D) - $fee(TOTAL_ASSESS_C)]]
    set SUB_INCHG    [expr $SUB_INCHG  + [expr $fee(INTERCHANGE_AMT_D) - $fee(INTERCHANGE_AMT_C)]]
    set SUB_DISCOUNT [expr $SUB_DISCOUNT + $fee(DISCOUNT)]
}
#    ******   pull sales out and write everything to report *******
#syang 12-01-2008: take off '010123005101', '010123005102' after talked with Marcy

set query_sale "SELECT unique entity_id, (select unique entity_dba_name from acq_entity where entity_id = m.entity_id) as entity_name,
    SUM(CASE WHEN (m.tid in ('010003005102','010003005101','010003005201','010003005202','010123005101','010123005102','010003005204') and m.CARD_SCHEME in ('04','05')) Then 1 else 0 end ) AS SALES_COUNT ,
    (SUM(CASE WHEN (m.tid in ('010003005102','010003005101','010003005201','010003005202','010123005101','010123005102','010003005204') and m.CARD_SCHEME in ('04','05') and m.tid_settl_method = 'C' ) Then m.amt_original else 0 end ) \
        - SUM(CASE WHEN (m.tid in ('010003005102','010003005101','010003005201','010003005202','010123005101','010123005102','010003005204') and m.CARD_SCHEME in('04','05') and m.tid_settl_method <> 'C' ) Then m.amt_original else 0 end ) )AS SALES_AMT
                       FROM mas_trans_log m
                       WHERE gl_date >= '01-$report_my' AND gl_date < '01-$next_my' and
                             institution_id = '101'  and
                             entity_id in ('447474210000133', '447474210000135', '447474210000136', '447474210000139', '447474310000101')
                       group by entity_id
                       order by entity_id "
        puts $query_sale
        orasql $M_cursor $query_sale
        while {[set syang [orafetch $M_cursor -dataarray sale -indexbyname]] == 0} {
              set MERCHANT_NUM         $sale(ENTITY_ID)
              set MERCHANT_NAME        $sale(ENTITY_NAME)
              set TRAN_COUNT           $sale(SALES_COUNT)
              set SALES_AMT            $sale(SALES_AMT)

              set SUB_TRAN_COUNT      [expr $SUB_TRAN_COUNT + $TRAN_COUNT]
              set SUB_SALES_AMT       [expr $SUB_SALES_AMT +  $SALES_AMT]

            catch {set syang $arrfee($MERCHANT_NUM)} resultfee
            if {[string range $resultfee 0 9] == "can't read"} {
                set MC_VS_FEE 0
            } else {
                set MC_VS_FEE $arrfee($MERCHANT_NUM)
            }
            catch {set syang $arrassess($MERCHANT_NUM)} resultassess
            if {[string range $resultassess 0 9] == "can't read"} {
                set ASSESSMENT_AMT 0
            } else {
                set ASSESSMENT_AMT $arrassess($MERCHANT_NUM)
            }
            catch {set syang $arrinchg($MERCHANT_NUM)} resultinchg
            if {[string range $resultinchg 0 9] == "can't read"} {
                set INTERCHANGE_AMT 0
            } else {
                set INTERCHANGE_AMT $arrinchg($MERCHANT_NUM)
            }
            catch {set syang $arrdiscount($MERCHANT_NUM)} resultdiscount
            if {[string range $resultdiscount 0 9] == "can't read"} {
                set DISCOUNT 0
            } else {
                set DISCOUNT $arrdiscount($MERCHANT_NUM)
            }

            set GROSS_INCOME [expr  $INTERCHANGE_AMT + $MC_VS_FEE +  $ASSESSMENT_AMT + $DISCOUNT]
            set NET          [expr  $MC_VS_FEE + $DISCOUNT]

            set SUB_GROSS [expr $SUB_GROSS + $GROSS_INCOME ]
            set SUB_NET   [expr $SUB_NET + $NET]

        puts $cur_file " $MERCHANT_NUM,$MERCHANT_NAME, $TRAN_COUNT,$SALES_AMT,$GROSS_INCOME,$INTERCHANGE_AMT,$ASSESSMENT_AMT,$MC_VS_FEE,$DISCOUNT, $NET \r"

            set MERCHANT_NUM       0
            set MERCHANT_NAME      0
            set TRAN_COUNT         0
            set SALES_AMT          0
            set MC_VS_FEE          0
            set ASSESSMENT_AMT     0
            set INTERCHANGE_AMT    0
            set DISCOUNT           0
            set GROSS_INCOME       0
            set NET                0
      }

      puts $cur_file "TOTAL: , , $SUB_TRAN_COUNT, $SUB_SALES_AMT, $SUB_GROSS, $SUB_INCHG, $SUB_ASSESS, $SUB_FEE, $SUB_DISCOUNT, $SUB_NET\r"

  close $cur_file
  ## exec uuencode $cur_file_name $file_name | mailx -r clearing@jetpay.com -s $file_name jsmith@jetpay.com
  exec uuencode $cur_file_name $file_name | mailx -r clearing@jetpay.com -s $file_name clearing@jetpay.com
oraclose $M_cursor
# *******************************************************     END        **********************************************************
