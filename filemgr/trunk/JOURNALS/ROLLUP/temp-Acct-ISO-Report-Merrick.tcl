#!/usr/bin/env tclsh
#/clearing/filemgr/.profile
#
#======================================  ISO INFORMATION
# ======================================
# This script is to generate ISO commision monthly report automaticly for
# previous month
# ISO numbers (as for Jan, 2008):
#              447474                JETPAY MERCHANT SERVICES LLC
#              454045
#                     00             JETPAY ISO SERVICES LLC
#                     21             CONTINENTAL CREDIT SYSTEMS
#                     22             EXPRESS WORKING CAPITAL LLC
#                     33             EVERPAY MERCHANT SOLUTIONS
#                     35             TOGETHER WE CAN CHANGE THE WORLD
#                     44             FIDELITY PAYMENT SOLUTIONS
#                     46             GLOBAL MERCHANT SERVICES
#                     55             WISE SAVINGS
#                     66             CARDPLUS
#                     75             MAJOR FINANCIAL SERVICES
#                     77             FIDELITY PAYMENT SOLUTIONS ISO
#                     85             MERAMAK
#                     87             RR SALES AND MARKETING
#                     96             SOFTWARE PAYMENTS
#                     99             YES4BIZ LLC
##
#======================================  MODIFICATION HISTORY
# =====================================
# Ran for MAY, JUN, and JUL on some fixed dates, need to change that to be run
# for future month.
#
# Version 3.01 Sunny Yang 03-30-2010
#         updated query to take care "dash" in merchant names.
#
# Version 3.00 Sunny Yang 03-13-2010
#         Based on Acct-ISO-Report.tcl-SYANG-new
#         Merchant whoever had activities will be counted and printed out.
#
# Version 2.03 Sunny Yang 01-05-2010
#         Add reporting period of Discount and Interchange on report to avoid
# some confusion Accounting had.
#
# Version 2.02 Sunny Yang 09-09-2009
#         Request by Sara Lewis, update chargebacks to look from 3rd to 2nd.
#
# Version 2.01 Sunny Yang 01-15-2009
#         This version add in 3 columns to list out VS and MC sales rejects. and
# Sales Returns
#                      to balance with Header report sales amount.
#
# Version 2.00 Sunny Yang 10-20-2008
#         This version will automate ISO billing for each ISO. It will reflect
# rates info according
#                      to contract, which are stored into specially built DB
# tables from MASCLR system.
#
# Version 0.04 Sunny Yang 08-27-2008
#         Add Terminal Billing info
#
# Version 0.03 Sunny Yang 07-16-2008
#         Add argument into this script to run on specified dates
#
# Version 0.02 Sunny Yang 06-24-2008
#         Add Interchange, fee collection, Retrival count, Fraud History
#         Goal: add in  ACH Return, CVV2, VBV
#
# Version 0.01 Sunny Yang 02-06-2008
#         Add in factor there are settlement delay for some merchant, so
# date_to_settle
#         needs to be in reporting date period.
#         Took off 3 tables join. Use sub-query instead
#         Plan type N or G
#
# Version 0.01 Sunny Yang 01-22-2008
#         Changes made to sort out report by ISO numbers and subtotal under each
# ISO.
#         Only count active terminals, active merchants
#         Merchant needs to be boarded before the end of reporting period
#         Add REtrieval count
#         Add Chargeback column
#         Take out Mastercard and Visa Fees, ACH returns, Fees per contract
#         Add CVV2/CID, VBV, Fraud counts
#
#
# Version 0.00 Sunny Yang 09-12-2007
#
#===================================================================================================

#===================================================================================================
#Environment veriables.......

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
#====================================================================================================

package require Oratcl

set start_time [clock seconds]

if {[catch {set handlerT [oralogon teihost/quikdraw@$authdb]} result]} {
	exec echo "ISO commission Report failed to run on TEIHOST" | mailx -r teiprod@jetpay.com -s "ISO Commission Report" clearing@jetpay.com
	exit
}
if {[catch {set handlerM [oralogon masclr/masclr@$clrdb]} result]} {
	exec echo "ISO commission Report failed to run on MASCLR" | mailx -r teiprod@jetpay.com -s "ISO Commission Report" clearing@jetpay.com
	exit
}

puts "$clrdb ... $authdb"

set count_cursor1   [oraopen $handlerM]
set count_cursor2   [oraopen $handlerM]
set count_cursor3   [oraopen $handlerT]
set count_cursor4   [oraopen $handlerT]
set count_cursor5   [oraopen $handlerT]
set count_cursor6   [oraopen $handlerT]
set count_cursor7   [oraopen $handlerT]
set count_cursor8   [oraopen $handlerT]
set count_cursor9   [oraopen $handlerT]
set fetch_cursorM1  [oraopen $handlerM]
set fetch_cursorM2  [oraopen $handlerM]
set fetch_cursorM3  [oraopen $handlerM]
set fetch_cursorM4  [oraopen $handlerM]
set fetch_cursorM5  [oraopen $handlerM]
set fetch_cursorM6  [oraopen $handlerM]
set fetch_cursorM7  [oraopen $handlerM]
set fetch_cursorM8  [oraopen $handlerM]
set fetch_cursorM9  [oraopen $handlerM]
set fetch_cursorM10 [oraopen $handlerM]
set cursorM1        [oraopen $handlerM]
set cursorM2        [oraopen $handlerM]
set cursorM3        [oraopen $handlerM]
set cursorM4        [oraopen $handlerM]
set cursorM5        [oraopen $handlerM]
set cursorM6        [oraopen $handlerM]
set cursorM7        [oraopen $handlerM]
set cursorM8        [oraopen $handlerM]
set cursorM9        [oraopen $handlerM]
set cursorM10       [oraopen $handlerM]

#======= DEFINE RATES =====================

set DIAL_MONTHLY_RATE                    0
set AUTH_MONTHLY_RATE                    0
set SETT_MONTHLY_RATE                    0
set MERCHANT_STATEMENT_RATE              0
set MERCHANT_PAGE_RATE                   0
set NON_HIGH_RISK_CP_RATE                0
set NON_HIGH_RISK_NCP_RATE               0
set RISK_FREE_CP                         0
set RISH_FREE_CNP                        0
set DIALUP_MONTHLY_RATE_PER_MERCHANT     0
set RETRIEVALS_RATE                      0

#==========================================

set TERM_COUNT                0
set DIAL_COUNT                0
set MERCHANT_NUM              0
set MERCHANT_NAME             0
set AMOUNT                    0
set CARD_PRESENT_AMOUNT       0
set CARD_NOT_PRESENT_AMOUNT   0
set TERMINAL_COUNT            0
set NON_BANK_COUNT            0
set SETT_TRAN_COUNT           0
set AUTH_TRAN_COUNT           0
set CP_TRAN_COUNT             0
set NP_TRAN_COUNT             0
set PAGE_NUM                  0
set DIAL_TR_COUNT             0
set RETRIVAL_COUNT            0
set DISCOUNT_CHARGE           0
set PASSTHROUGH_AMOUNT        0
set PASSTHROUGH_MS            0
set PASSTHROUGH_VS            0
set ACH_RETURN                0
set AUTH_VOLUME               0
set SETT_VOLUME               0
set DIAL_MONTHLY              0
set FEE_PER_CONTRACT          0
set CHARGE_PER_PAGE           0
set DIAL_MONTHLY_MERCHANT     0
set CHARGEBACK_CNT            0  ;# added on 02-31
set CHARGEBACK_AMT            0  ;# added on 02-31
set FRAUD_COUNT               0
set INTERCHANG_AMOUNT         0
set TERM_COUNT                     0
set ALL_TERMINAL_COUNT             0
set DT_COUNT                       0
set temp_vid                 "SYANG"
set TERMINAL_BILLING               0
set MC_ASSESSMENT_AMT              0
set VS_ASSESSMENT_AMT              0
set RETURN_AMT                     0

set SUB_RETURN_AMT                 0
set SUB_MCASSESSMENT_AMT           0
set SUB_VSASSESSMENT_AMT           0
set SUB_AMOUNT                     0
set SUB_CARD_PRESENT_AMOUNT        0
set SUB_CARD_NOT_PRESENT_AMOUNT    0
set SUB_ALL_TERMINAL_COUNT         0
set SUB_TERMINAL_COUNT             0
set SUB_NON_BANK_COUNT             0
set SUB_SETT_TRAN_COUNT            0
set SUB_AUTH_TRAN_COUNT            0
set SUB_CP_TRAN_COUNT              0
set SUB_NP_TRAN_COUNT              0
set SUB_PAGE_NUM                   0
set SUB_DIAL_TR_COUNT              0
set SUB_RETRIVAL_COUNT             0
set SUB_DISCOUNT_CHARGE            0
set SUB_PASSTHROUGH_AMOUNT         0
set SUB_PASSTHROUGH_MS             0
set SUB_PASSTHROUGH_VS             0
set SUB_ACH_RETURN                 0
set SUB_AUTH_VOLUME                0
set SUB_SETT_VOLUME                0
set SUB_DIAL_MONTHLY               0
set SUB_FEE_PER_CONTRACT           0
set SUB_CHARGE_PER_PAGE            0
set SUB_DIAL_MONTHLY_MERCHANT      0
set SUB_CHARGEBACK_CNT             0  ;# added on 02-31
set SUB_CHARGEBACK_AMT             0  ;# added on 02-31
set SUB_INTERCHANG_AMOUNT          0
set SUB_TERMINAL_BILLING 0

#*****************************************************************************************
set institution_id_var ""
if {$argc == 2 } {
	#puts "Input last day of the Month you want to report on:(format YYYYMMDD, like
	# 20080630) "
	set institution_id_var [string trim [lindex $argv 0]]
	set date [string trim [lindex $argv 1]]
	puts $date
	set auth_end_day $date
	set auth_begin_date [ string toupper [clock format [ clock scan " $date -1 month" ] -format %d-%b-%y ]]
	set auth_begin [ string toupper [clock format [ clock scan " $date -1 month" ] -format %Y%m%d ]]
	puts "auth_begin: $auth_begin"
	set report_date  [ string toupper [clock format [ clock scan " $date -0 day " ] -format %d-%b-%y ]]   ;# 02-APR-08 as of 20080402
	set current_year [string range  $report_date 7 8 ]
	set short_month  [string range $report_date 3 5 ]
	set name_date_year [string range $date 0 3 ]
	set number_date_month  [string range $date 4 5 ]
	set auth_time         "000000"
	set first_day         "01"
	set AUTH_SUMMARY_BEGIN $auth_begin
	set AUTH_BEGIN $AUTH_BEGIN$auth_time
	set AUTH_SUMMARY_END $date
	set AUTH_END $date$auth_time
	puts "AUTH_BEGIN is .....$AUTH_BEGIN....AUTH_END is .....  $AUTH_END"

	if { $short_month == "DEC" } {
		set short_year        [clock format [clock scan "-1 year"] -format %y]                  ;# fall into previous year
		set next_short_year   [clock format [clock scan "-0 year"] -format %y]
		set next_month        [string toupper [clock format [clock scan "$date +1 month"] -format %b]]
	} else {
		set short_year        [clock format [clock scan "-1 year"] -format %y]
		set next_short_year   [clock format [clock scan "-1 year"] -format %y]
		set next_month        [string toupper [clock format [clock scan "$date +1 month"] -format %b]]
	}
	puts "next month: $next_month "
	if { $short_month == "JAN" } {
		set last_short_year        [clock format [clock scan "-1 year"] -format %y]                  ;# fall into previous year
	} else {
		set last_short_year   [clock format [clock scan "-0 year"] -format %y]
	}
	set last_month        [string toupper [clock format [clock scan "$date -1 month"] -format %b]]
} elseif {$argc == 1} {
	set institution_id_var [string trim [lindex $argv 0]]
	set date [clock format [clock scan "-2 month"] -format "%d-%b-%y"]
	set short_month       [string toupper [clock format [clock scan "-2 month"] -format %b]]      ;# DEC... as of 01/27/2008
	set current_year        [clock format [clock scan "-1 month"] -format %y]                     ;# 08... as of 01/27/2008
	set name_date_year      [clock format [clock scan "-2 month"] -format %Y]                      ;# 2008... as of 01/27/2008
	set number_date_month   [clock format [clock scan "-2 month"] -format %m]                      ;# 12... as of 01/27/2008
	set auth_begin_day    "TO_CHAR(LAST_DAY(SYSDATE-(TO_CHAR(SYSDATE,'DD')+62)),'YYYYMMDD')"
	set auth_begin        "$auth_begin_day"
	set auth_end_day      "TO_CHAR(LAST_DAY(SYSDATE-(TO_CHAR(SYSDATE,'DD')+31)),'YYYYMMDD')"
	set auth_end          "$auth_end_day"
	set auth_time         "000000"
	set first_day         "01"

	set query_str " select $auth_begin_day  as AUTH_BEGIN,
		    $auth_end_day  as AUTH_END
			    from dual"
	orasql $count_cursor5 $query_str
	puts $query_str
	while {[orafetch $count_cursor5 -dataarray ad -indexbyname] == 0} {
		set AUTH_BEGIN $ad(AUTH_BEGIN)
		set AUTH_END $ad(AUTH_END)
	}
	set AUTH_SUMMARY_BEGIN $AUTH_BEGIN
	set AUTH_BEGIN $AUTH_BEGIN$auth_time
	set AUTH_SUMMARY_END $AUTH_END
	set AUTH_END $AUTH_END$auth_time
	puts "AUTH_BEGIN is .....$AUTH_BEGIN....AUTH_END is .....  $AUTH_END"

	if { $short_month == "DEC" } {
		set short_year        [clock format [clock scan "-1 year"] -format %y]                  ;# fall into previous year
		set next_short_year   [clock format [clock scan "-0 year"] -format %y]
		set next_month        [string toupper [clock format [clock scan "-1 month"] -format %b]]
	} else {
		set short_year        [clock format [clock scan "-0 year"] -format %y]
		set next_short_year   [clock format [clock scan "-0 year"] -format %y]
		set next_month        [string toupper [clock format [clock scan "-1 month"] -format %b]]
	}
	if { $short_month == "JAN" } {
		set last_short_year        [clock format [clock scan "-1 year"] -format %y]                  ;# fall into previous year
	} else {
		set last_short_year   [clock format [clock scan "-0 year"] -format %y]
	}
	set last_month        [string toupper [clock format [clock scan "$date -2 month"] -format %b]]

} else {
	puts "invalid arguments: inst_id date"
	exit 1
}

set shortname_var ""
switch $institution_id_var {
	"107" {
		set shortname_var "JETPAYIS"
	}
	"101" {
		set shortname_var "JETPAY"
	}
}

#DATE VARIABLES
set ship_date           "$name_date_year$number_date_month"                                    ;# 200712
set name_date           "$short_month-$name_date_year"                                         ;# DEC-2007


# the end dates are exclusive for activity/chargeback
set activity_gl_start_date "01-$short_month-$short_year"
set activity_gl_end_date "01-$next_month-$next_short_year"
set chargeback_gl_start_date "01-$short_month-$short_year"
set chargeback_gl_end_date "01-$next_month-$next_short_year"

set discount_start_gl_date "01-$short_month-$last_short_year"
set discount_end_gl_date "01-$next_month-$next_short_year"
set discount_start_settle_date "01-$short_month-$short_year"
set discount_end_settle_date "01-$next_month-$next_short_year"

set interchange_start_gl_date "01-$short_month-$last_short_year"
set interchange_end_gl_date "01-$next_month-$next_short_year"
set interchange_start_settle_date "01-$short_month-$short_year"
set interchange_end_settle_date "01-$next_month-$next_short_year"

set fee_start_gl_date "01-$short_month-$last_short_year"
set fee_end_gl_date "01-$next_month-$next_short_year"
set fee_start_settle_date "01-$short_month-$short_year"
set fee_end_settle_date "01-$next_month-$next_short_year"


puts " short_month:$short_month...next_month:$next_month...short_year: $short_year ....next_short_year: $next_short_year "
puts "01-$next_month-$current_year"
######time setting#######

# masclr--report starts at last day of month before previous month inclusively
# masclr--report ends at last day of previous month inclusively
set begin_date        "01-$short_month-$short_year"
set end_date          "substr((last_day(sysdate - (to_char(sysdate, 'DD')))), 1, 9)"
set clr_date          "$short_month-$short_year"
puts " clearing date is ....$clr_date "

# teihost transaction--report starts at last day of month before previous month
# inclusively
# teihost transaction--report ends at last day of month previous month
# exclusively
set auth_time         "000000"
set first_day         "01"

set MAS_END      "TO_CHAR(LAST_DAY(SYSDATE-(TO_CHAR(SYSDATE,'DD')+2)),'YYYYMMDD')"
set MAS_BEGIN      "$ship_date$first_day"

set cur_file_name     "./LOG/FULL.ISO.REPORT.$name_date.$institution_id_var.csv"
set file_name         "FULL.ISO.REPORT.$name_date.$institution_id_var.csv"
set cur_file          [open "$cur_file_name" w]

puts $cur_file "JETPAY ISO SERVICES, LLC"
puts $cur_file "ISO COMMISSION MONTHLY REPORT"
puts $cur_file "MERRAMAK"
puts $cur_file "REPORTED MONTH:,$name_date"

puts $cur_file " ,ISO ID, ISO NAME\r"

#syang: before confirmed from Marcy, limited to institution id 101 and 107

set query_string_isolist " select unique substr(ENTITY_ID, 1, 6) as INST,
    substr(ENTITY_ID, 8, 2) as ISO_NO,
    replace(entity_name, ',', '') as NAME
    from acq_entity
    where entity_level = '30' AND
    entity_dba_name not like '%TEST%' AND
    entity_status = 'A' and
    substr(ENTITY_ID, 1, 6) in ('454045', '447474')
    order by substr(ENTITY_ID, 1, 6)"
orasql $fetch_cursorM4 $query_string_isolist
while {[orafetch $fetch_cursorM4 -dataarray isolist -indexbyname] != 1403} {

	switch $isolist(INST) {
		"447474" {set ISO_NO    "447474"
			set ISO_NAME  "JPMS"}
		"454045" {set ISO_NO $isolist(ISO_NO)
			set ISO_NAME $isolist(NAME)}
		default {}
	}
	puts "  $ISO_NO....$ISO_NAME "
	puts $cur_file " ,$ISO_NO, $ISO_NAME \r"
}

puts $cur_file "PER MERCHANT CALCULATIONS AND CHARGES:   "
puts $cur_file "DISCOUNT settled between '$discount_start_settle_date' and  '$discount_end_settle_date' inclusively"
puts $cur_file "INTERCHANGE calculated between '$interchange_start_gl_date' and '$interchange_end_gl_date' inclusively"
puts $cur_file "CHARGEBACK occured between '$chargeback_gl_start_date' and '$chargeback_gl_end_date' inclusively"
puts  "DISCOUNT settled between '$discount_start_settle_date' and  '$discount_end_settle_date' inclusively"
puts  "INTERCHANGE calculated between '$interchange_start_gl_date' and '$interchange_end_gl_date' inclusively"
puts  "chargeback occured between '$chargeback_gl_start_date' and '$chargeback_gl_end_date' inclusively"


#if {0} {
#	puts $auth_begin_day$auth_time
#	puts $auth_end_day$auth_time
#
#	set query_str " select $auth_begin_day  as AUTH_BEGIN,
#			 $auth_end_day  as AUTH_END,
#			 $MAS_END as MAS_END
#				 from dual"
#	orasql $count_cursor5 $query_str
#	puts $query_str
#	while {[orafetch $count_cursor5 -dataarray ad -indexbyname] == 0} {
#		set AUTH_BEGIN $ad(AUTH_BEGIN)
#		set MAS_END  $ad(MAS_END)
#	}
#
#	set AUTH_BEGIN $AUTH_BEGIN$auth_time
#	set AUTH_END $AUTH_END$auth_time
#	puts "AUTH_BEGIN is .....$AUTH_BEGIN....AUTH_END is .....  $AUTH_END"
#}

###********************************          AUTH
# ************************************#####
puts "AUTH"
set GRAND_NONBNK_CNT  0

set query_string " SELECT /* +index(TRANHISTORY_SETTLE_DATE,RPT_HST_REQTYPE,TRANHISTORY_CARD_TYPE) */
merchant.VISA_ID as VISA_ID, count(tranhistory.orig_amount) as TH_COUNT
FROM tranhistory, merchant, master_merchant
WHERE tranhistory.mid = merchant.mid
AND merchant.mmid = master_merchant.mmid
AND master_merchant.shortname = :short_name
AND tranhistory.card_type in ('AX', 'DS')
AND tranhistory.settle_date like :search_date
AND tranhistory.request_type in ('0100', '0200', '0220', '0250', '0400', '0402', '0420')
GROUP BY merchant.VISA_ID
order by substr(merchant.visa_id,8,2), merchant.visa_id "

oraparse $count_cursor3 $query_string
puts " TH_COUNT is $query_string "
puts "bind_vars: :search_date $ship_date% :short_name $shortname_var"
orabind $count_cursor3 :search_date "$ship_date%" :short_name "$shortname_var"
oraexec $count_cursor3

while {[orafetch $count_cursor3 -dataarray non -indexbyname] == 0} {
	set arr($non(VISA_ID)) $non(TH_COUNT)
	#  set GRAND_NONBNK_CNT   [expr $GRAND_NONBNK_CNT + $non(TH_COUNT) ]
}

#Formerly
#set query_string "SELECT  /*+INDEX(transaction TRANSACTION_AUTHDATETIME)*/
# merchant.VISA_ID as VISA_ID, transaction.tid as TH_TID, \
#count(transaction.tid) as DT_COUNT, \
#count(unique transaction.tid) as TERM_COUNT \
#FROM transaction, merchant, master_merchant
#WHERE transaction.mid = merchant.mid
#AND merchant.mmid = master_merchant.mmid
#AND master_merchant.shortname in ('JETPAYIS')
#AND transaction.AUTHDATETIME >= '$AUTH_BEGIN'
#AND transaction.AUTHDATETIME < '$AUTH_END'
#AND transaction.SHIPDATETIME < '$AUTH_END'
#AND transaction.request_type in ('0100', '0200', '0220', '0250', '0400', '0402',
# '0420')
#GROUP BY merchant.VISA_ID, transaction.tid
#ORDER BY substr(merchant.visa_id,8,2), merchant.visa_id, transaction.tid DESC "
set query_string "SELECT clearing_id visa_id, tid th_tid,  sum(cnt) dt_count,
			count(unique tid) as term_count
		FROM auth_count_summary
		WHERE shortname = :short_name
		and auth_day >= :begin_date
		and auth_day < :end_date
		and ship_day < :end_date
		and request_type in ('0100', '0200', '0220', '0250', '0400', '0402', '0420')
		group by clearing_id, tid
		order by substr(clearing_id,8,2), clearing_id, tid desc"

oraparse $count_cursor2 $query_string
puts "TH_TID: $query_string"
puts "bind_vars:  :short_name $shortname_var :begin_date $AUTH_SUMMARY_BEGIN :end_date $AUTH_SUMMARY_END"
orabind $count_cursor2 :short_name $shortname_var :begin_date $AUTH_SUMMARY_BEGIN :end_date $AUTH_SUMMARY_END
oraexec $count_cursor2

while {[orafetch $count_cursor2 -dataarray coun -indexbyname] != 1403} {

	set DIAL_COUNT [regexp -all {[0-9]} $coun(TH_TID)]
	if {$temp_vid != $coun(VISA_ID) } {
		if {$temp_vid == "SYANG" } {
			set temp_vid           $coun(VISA_ID)
			set ALL_TERMINAL_COUNT $coun(TERM_COUNT)
			set TERM_COUNT         $coun(TERM_COUNT)
			set DT_COUNT $coun(DT_COUNT)
			set arrterm($temp_vid) $TERM_COUNT
			set arrdt($temp_vid) $DT_COUNT
			set arrallterm($temp_vid) $ALL_TERMINAL_COUNT
		} else {
			set ALL_TERMINAL_COUNT $coun(TERM_COUNT)
			if {$DIAL_COUNT == 12 } {
				set TERM_COUNT     $coun(TERM_COUNT)
				set DT_COUNT       $coun(DT_COUNT)
			} else {
				set TERM_COUNT 0
				set DT_COUNT   0
			}
			set temp_vid              $coun(VISA_ID)
			set arrterm($temp_vid)    $TERM_COUNT
			set arrdt($temp_vid)      $DT_COUNT
			set arrallterm($temp_vid) $ALL_TERMINAL_COUNT
		}
	} else {
		set ALL_TERMINAL_COUNT [ expr $ALL_TERMINAL_COUNT + $coun(TERM_COUNT)]
		if {$DIAL_COUNT == 12 } {
			set TERM_COUNT         [expr $TERM_COUNT + $coun(TERM_COUNT)]
			set DT_COUNT           [expr $DT_COUNT + $coun(DT_COUNT) ]
			set arrterm($temp_vid) $TERM_COUNT
			set arrdt($temp_vid)   $DT_COUNT
		} else {
			set TERM_COUNT   0
			set DT_COUNT     0
		}
		set arrallterm($temp_vid) $ALL_TERMINAL_COUNT
	}
}

#set query_string  " SELECT merchant.visa_id as VISA_ID,
#    count(transaction.orig_amount) AS AUTH_COUNT
#    FROM transaction, merchant, master_merchant
#    WHERE transaction.mid = merchant.mid
#    AND merchant.mmid = master_merchant.mmid
#    AND master_merchant.shortname in ('JETPAYIS')
#    AND transaction.AUTHDATETIME >= '$AUTH_BEGIN'
#    AND transaction.AUTHDATETIME < '$AUTH_END'
#    AND transaction.SHIPDATETIME < '$AUTH_END'
#    AND transaction.REQUEST_TYPE in ('0100', '0200', '0420', '0440')
#    GROUP BY merchant.visa_id
#    ORDER BY substr(merchant.visa_id, 8, 2), merchant.visa_id "
set query_string "SELECT clearing_id visa_id, sum(cnt) auth_count
                FROM auth_count_summary
                WHERE shortname = :short_name
						and auth_day >= :begin_date
						and auth_day < :end_date
						and ship_day < :end_date
                and request_type in ('0100', '0200', '0420', '0440')
                group by clearing_id
                order by substr(clearing_id,8,2), clearing_id"
oraparse $count_cursor1 $query_string
orabind $count_cursor1 :short_name "$shortname_var" :begin_date $AUTH_SUMMARY_BEGIN :end_date $AUTH_SUMMARY_END
oraexec $count_cursor1
puts " AUTH_COUNT is $query_string "
while {[orafetch $count_cursor1 -dataarray w -indexbyname] != 1403} {
	set AUTH_TRAN_COUNT $w(AUTH_COUNT)
	set arrauth($w(VISA_ID)) $AUTH_TRAN_COUNT
}

# *** Fraud Count ***
set query_str_fraud " SELECT unique m.visa_id as VISA_ID, count(f.orig_amount) AS FRAUD_COUNT
FROM fraud_history f , merchant m
WHERE f.mid = m.mid AND
m.mmid in (select mmid from master_merchant where shortname in ('JETPAYIS')) AND
f.AUTHDATETIME >= '$AUTH_BEGIN' AND
f.AUTHDATETIME < '$AUTH_END' AND
f.SHIPDATETIME < '$AUTH_END'
GROUP BY m.visa_id
ORDER BY substr(m.visa_id, 8, 2), m.visa_id  "

puts "Fraud...$query_str_fraud "
orasql $count_cursor6 $query_str_fraud
while {[orafetch $count_cursor6 -dataarray f -indexbyname] != 1403} {
	set arrfraud($f(VISA_ID)) $f(FRAUD_COUNT)
}

###********************************          AUTH END
# *************************************########
# **************  for now, all CVV2 set to NULL, nobody get charged
# ****************
# use masclr.merchant_fee_flags

#if {0} {
#	# *********************************        MAS INST 101
## *************************************
#	set inst_101 "101"
#	set query_string_clr " SELECT unique m.entity_id as VISA_ID,
#		    (select replace(entity_dba_name, ',' , '') from acq_entity where
# entity_id = m.entity_id) as NAME,
#		    SUM(CASE WHEN (m.tid in ('010003005101' , '010123005102',
# '010003005102','010123005101') and m.tid_settl_method = 'C' and
# i.pos_crd_present = '1' and m.trans_sub_seq = '0') Then m.amt_original else 0
# end ) AS CP_S_AMOUNT,
#		    SUM(CASE WHEN (m.tid in ('010003005101' , '010123005102',
# '010003005102','010123005101') and m.tid_settl_method = 'D' and
# i.pos_crd_present = '1' and m.trans_sub_seq = '0') Then m.amt_original else 0
# end) AS CP_R_AMOUNT,
#		    SUM(CASE WHEN (m.tid in ('010003005101' , '010123005102',
# '010003005102','010123005101') and m.tid_settl_method = 'C' and
# (i.pos_crd_present <> '1' or i.pos_crd_present is null ) and m.trans_sub_seq =
# '0') Then m.amt_original else 0 end ) AS CNP_S_AMOUNT,
#		    SUM(CASE WHEN (m.tid in ('010003005101' , '010123005102',
# '010003005102','010123005101') and m.tid_settl_method = 'D' and
# (i.pos_crd_present <> '1' or i.pos_crd_present is null ) and m.trans_sub_seq =
# '0') Then m.amt_original else 0 end) AS CNP_R_AMOUNT,
#		    SUM(CASE WHEN (m.tid in ('010003005101' , '010123005102',
# '010003005102','010123005101') and m.tid_settl_method = 'C' and
# i.pos_crd_present = '1' and m.trans_sub_seq = '0') Then 1 else 0 end ) AS
# CP_S_COUNT,
#		    SUM(CASE WHEN (m.tid in ('010003005101' , '010123005102',
# '010003005102','010123005101') and m.tid_settl_method = 'D' and
# i.pos_crd_present = '1' and m.trans_sub_seq = '0') Then 1 else 0 end) AS
# CP_R_COUNT,
#		    SUM(CASE WHEN (m.tid in ('010003005101' , '010123005102',
# '010003005102','010123005101') and m.tid_settl_method = 'C' and
# (i.pos_crd_present <> '1' or i.pos_crd_present is null ) and m.trans_sub_seq =
# '0') Then 1 else 0 end ) AS CNP_S_COUNT,
#		    SUM(CASE WHEN (m.tid in ('010003005101' , '010123005102',
# '010003005102','010123005101') and m.tid_settl_method = 'D' and
# (i.pos_crd_present <> '1' or i.pos_crd_present is null ) and m.trans_sub_seq =
# '0') Then 1 else 0 end) AS CNP_R_COUNT,
#		    SUM(CASE WHEN ((m.tid in ('010003005101' , '010123005102', '010003005102'
# , '010123005101' )  and m.trans_sub_seq = '0')
#					    or (m.tid = '010003005301')) Then 1 else 0 end) AS TOTAL_COUNT,
#		    ( SUM(CASE WHEN (m.tid in ('010123005102','010123005101') and
# m.tid_settl_method = 'C' and m.trans_sub_seq = '0') Then m.amt_original else 0
# end )
#		      - SUM(CASE WHEN (m.tid in ('010123005102','010123005101') and
# m.tid_settl_method = 'D' and m.trans_sub_seq = '0') Then m.amt_original else 0
# end) ) AS RETURN_AMOUNT,
#		    SUM(CASE WHEN ((m.gl_date >= '$activity_gl_start_date' and m.gl_date <
# '$chargeback_gl_end_date') and m.tid in ('010003005301', '010003005401',
# '010003010102','010003015201', '010003015102', '010003015101', '010003015210')
# and m.tid_settl_method = 'C' )Then m.amt_original else 0 end ) as
# CHARGEBACK_S_AMT,
#		    SUM(CASE WHEN ((m.gl_date >= '$activity_gl_start_date' and m.gl_date <
# '$chargeback_gl_end_date') and m.tid in ('010003005301', '010003005401',
# '010003010102','010003015201', '010003015102', '010003015101', '010003015210')
# and m.tid_settl_method = 'D' )Then m.amt_original else 0 end ) as
# CHARGEBACK_R_AMT,
#		    SUM(CASE WHEN ((m.gl_date >= '$activity_gl_start_date' and m.gl_date <
# '$chargeback_gl_end_date') and m.tid in ('010003005301', '010003005401',
# '010003010102','010003015201', '010003015102', '010003015101', '010003015210'))
# Then 1 else 0 end ) as CHARGEBACK_CNT
#			    FROM mas_trans_log m, in_draft_main i
#			    WHERE  m.institution_id = '101'
#			    AND m.trans_ref_data = i.arn
#			    AND to_char(m.external_trans_nbr) = to_char(i.trans_seq_nbr)
#				AND m.gl_date >= '$activity_gl_start_date' and m.gl_date <
# '$activity_gl_end_date'
#			    AND m.settl_flag = 'Y'
#			    GROUP BY m.entity_id
#			    ORDER BY substr(m.entity_id, 8,2), m.entity_id "
#
#	orasql $cursorM1 $query_string_clr
#	puts "query_string_clr: $query_string_clr"
#	while {[orafetch $cursorM1 -dataarray clr -indexbyname] != 1403} {
#		set AMOUNT [expr ($clr(CP_S_AMOUNT) + $clr(CNP_S_AMOUNT)) -
# ($clr(CP_R_AMOUNT) + $clr(CNP_R_AMOUNT))]
#		set CARD_PRESENT_AMOUNT     [expr $clr(CP_S_AMOUNT) - $clr(CP_R_AMOUNT) ]
#		set CARD_NOT_PRESENT_AMOUNT [expr $clr(CNP_S_AMOUNT) - $clr(CNP_R_AMOUNT)]
#		set CP_TRAN_COUNT           [expr $clr(CP_S_COUNT) + $clr(CP_R_COUNT)]
#		set NP_TRAN_COUNT           [expr $clr(CNP_S_COUNT) + $clr(CNP_R_COUNT)]
#		set SETT_TRAN_COUNT         $clr(TOTAL_COUNT)
#		set SETT_VOLUME             [expr $SETT_TRAN_COUNT * $SETT_MONTHLY_RATE ]
#		set CHARGEBACK_AMT          [expr $clr(CHARGEBACK_S_AMT) -
# $clr(CHARGEBACK_R_AMT)]
#		set CHARGEBACK_CNT          $clr(CHARGEBACK_CNT)
#		set RETURN_AMT              $clr(RETURN_AMOUNT)
#
#		set arramt($clr(VISA_ID))     $AMOUNT
#		set arrcpamt($clr(VISA_ID))   $CARD_PRESENT_AMOUNT
#		set arrcnpamt($clr(VISA_ID))  $CARD_NOT_PRESENT_AMOUNT
#		set arrcpcnt($clr(VISA_ID))   $CP_TRAN_COUNT
#		set arrcnpcnt($clr(VISA_ID))  $NP_TRAN_COUNT
#		set arrsetcnt($clr(VISA_ID))  $SETT_TRAN_COUNT
#		set arrsetamt($clr(VISA_ID))  $SETT_VOLUME
#		set arrchgamt($clr(VISA_ID))  $CHARGEBACK_AMT
#		set arrchgcnt($clr(VISA_ID))  $CHARGEBACK_CNT
#		set arrreturnamt($clr(VISA_ID))  $RETURN_AMT
#
#		set SUB_AMOUNT                  [expr $SUB_AMOUNT + $AMOUNT ]
#		set SUB_CARD_PRESENT_AMOUNT     [expr $SUB_CARD_PRESENT_AMOUNT +
# $CARD_PRESENT_AMOUNT ]
#		set SUB_CARD_NOT_PRESENT_AMOUNT [expr $SUB_CARD_NOT_PRESENT_AMOUNT +
# $CARD_NOT_PRESENT_AMOUNT ]
#		set SUB_CP_TRAN_COUNT           [expr $SUB_CP_TRAN_COUNT + $CP_TRAN_COUNT]
#		set SUB_NP_TRAN_COUNT           [expr $SUB_NP_TRAN_COUNT + $NP_TRAN_COUNT]
#		set SUB_SETT_TRAN_COUNT         [expr $SUB_SETT_TRAN_COUNT +
# $SETT_TRAN_COUNT]
#		set SUB_SETT_VOLUME             [expr $SUB_SETT_TRAN_COUNT *
# $SETT_MONTHLY_RATE ]    ;# check this one with notes
#		set SUB_CHARGEBACK_CNT          [expr $SUB_CHARGEBACK_CNT + $CHARGEBACK_CNT]
#		set SUB_CHARGEBACK_AMT          [expr $SUB_CHARGEBACK_AMT + $CHARGEBACK_AMT]
#		set SUB_RETURN_AMT              [expr $SUB_RETURN_AMT + $RETURN_AMT]
#	}
#	set arrsubamt($inst_101)     $SUB_AMOUNT
#	set arrsubcpamt($inst_101)   $SUB_CARD_PRESENT_AMOUNT
#	set arrsubcnpamt($inst_101)  $SUB_CARD_NOT_PRESENT_AMOUNT
#	set arrsubcpcnt($inst_101)   $SUB_CP_TRAN_COUNT
#	set arrsubcnpcnt($inst_101)  $SUB_NP_TRAN_COUNT
#	set arrsubsetamt($inst_101)  $SUB_SETT_TRAN_COUNT
#	set arrsubsetcnt($inst_101)  $SUB_SETT_VOLUME
#	set arrsubchgamt($inst_101)  $SUB_CHARGEBACK_AMT
#	set arrsubchgcnt($inst_101)  $SUB_CHARGEBACK_CNT
#	set arrsubreturnamt($inst_101)  $SUB_RETURN_AMT
#
#	set query_string_clr2 " SELECT m.entity_id as VISA_ID,
#		    SUM( CASE WHEN((date_to_settle > '$fee_start_settle_date' and
# date_to_settle < '$fee_end_settle_date') and ((m.TID LIKE '010004%' and m.tid
# not like '01000428%') or m.tid like '01000507%' ) and m.settl_flag = 'Y' and
# m.tid_settl_method = 'C') \
#				    then m.AMT_ORIGINAL end ) as CREDIT_AMOUNT,
#		    SUM( CASE WHEN((date_to_settle > '$fee_start_settle_date' and
# date_to_settle < '$fee_end_settle_date') and ((m.TID LIKE '010004%' and m.tid
# not like '01000428%') or m.tid like '01000507%' ) and m.settl_flag = 'Y' and
# m.tid_settl_method = 'D') \
#				    then m.AMT_ORIGINAL end ) as DEBIT_AMOUNT,
#		    (SUM(CASE WHEN((gl_date > '$fee_start_settle_date' and gl_date <
# '$fee_end_settle_date') and  m.tid in ('010004020000', '010004020005') and
# m.tid_settl_method = 'D' ) then AMT_ORIGINAL else 0 end) \
#		     - SUM(CASE WHEN( (gl_date > '$fee_start_settle_date' and gl_date <
# '$fee_end_settle_date') and m.tid in ('010004020000', '010004020005') and
# m.tid_settl_method = 'C' ) then AMT_ORIGINAL else 0 end)) as INTERCHANGE_AMT,
#		    SUM(CASE WHEN( (gl_date > '$fee_start_settle_date' and gl_date <
# '$fee_end_settle_date') and m.tid in ('010004020000', '010004020005') ) then 1
# else 0 end) as INTERCHANGE_CNT,
#		    (SUM(CASE WHEN((gl_date > '$fee_start_gl_date' and gl_date <
# '$fee_end_gl_date') and mas_code= 'MC_ASSMT' and m.tid_settl_method = 'D') then
# AMT_ORIGINAL else 0 end)
#		     - SUM(CASE WHEN((gl_date > '$fee_start_gl_date' and gl_date <
# '$fee_end_gl_date') and mas_code= 'MC_ASSMT' and m.tid_settl_method = 'C') then
# AMT_ORIGINAL else 0 end)) as MC_ASSESSMENT_AMT,
#		    (SUM(CASE WHEN((gl_date > '$fee_start_gl_date' and gl_date <
# '$fee_end_gl_date') and mas_code= 'VISA_ASSMT' and m.tid_settl_method = 'D')
# then AMT_ORIGINAL else 0 end)
#		     - SUM(CASE WHEN((gl_date > '$fee_start_gl_date' and gl_date <
# '$fee_end_gl_date') and mas_code= 'VISA_ASSMT' and m.tid_settl_method = 'C')
# then AMT_ORIGINAL else 0 end)) as VS_ASSESSMENT_AMT,
#		    SUM(CASE WHEN(substr(m.date_to_settle,4,6) = '$short_month-$short_year'
# and m.mas_code in ('0204RREQ', ' 0205RREQ')) then 1 else 0 end) as
# RETRIEVAL_CNT
#			    FROM mas_trans_log m
#			    WHERE m.institution_id = '101'
#			    AND ((date_to_settle > '30-APR-10' and date_to_settle <
# '$fee_end_settle_date')
#					    or (gl_date > '30-APR-10' and gl_date < '$fee_end_settle_date'))
#			    GROUP BY m.entity_id
#			    ORDER BY substr(m.entity_id, 8,2), m.entity_id "
#	orasql $cursorM2 $query_string_clr2
#	puts "query_string_clr2: $query_string_clr2"
#	while {[orafetch $cursorM2 -dataarray clr2 -indexbyname] != 1403} {
#		set DISCOUNT_CHARGE             [expr $clr2(DEBIT_AMOUNT) -
# $clr2(CREDIT_AMOUNT) ]
#		set INTERCHANG_AMOUNT           $clr2(INTERCHANGE_AMT)
#		set MC_ASSESSMENT_AMT              $clr2(MC_ASSESSMENT_AMT)
#		set arrmcassess($clr2(VISA_ID))   $MC_ASSESSMENT_AMT
#		set VS_ASSESSMENT_AMT              $clr2(VS_ASSESSMENT_AMT)
#		set arrvsassess($clr2(VISA_ID))   $VS_ASSESSMENT_AMT
#		set arrinchg($clr2(VISA_ID))    $INTERCHANG_AMOUNT
#		set arrretrival($clr2(VISA_ID)) $clr2(RETRIEVAL_CNT)
#		set arrdischg($clr2(VISA_ID))   $DISCOUNT_CHARGE
#
#		set SUB_DISCOUNT_CHARGE         [expr $SUB_DISCOUNT_CHARGE + $DISCOUNT_CHARGE
# ]
#		set SUB_INTERCHANG_AMOUNT       [expr $SUB_INTERCHANG_AMOUNT +
# $INTERCHANG_AMOUNT ]
#		set SUB_MCASSESSMENT_AMT       [expr $SUB_MCASSESSMENT_AMT +
# $MC_ASSESSMENT_AMT ]
#		set SUB_VSASSESSMENT_AMT       [expr $SUB_VSASSESSMENT_AMT +
# $VS_ASSESSMENT_AMT ]
#	}
#	set arrsubdischg($inst_101)     $SUB_DISCOUNT_CHARGE
#	set arrsubinchg($inst_101)      $SUB_INTERCHANG_AMOUNT
#	set arrsubmcassess($inst_101)     $SUB_MCASSESSMENT_AMT
#	set arrsubvsassess($inst_101)     $SUB_VSASSESSMENT_AMT
#
#}

#if {$short_month == "MAY" && $short_year == "08"} {
#	set query_string_clr3 "select mtl.entity_id, sum(mtl.amt_original) as
# MC_BORDER_FEE
#		from mas_trans_log mtl
#		where mtl.tid in ('010004330000', '010004360000') and
#		institution_id = '101' and
#		date_to_settle like '%MAY-08%' and
#		((mtl.non_act_fee_pkg_id > 12454 and
#		  mtl.institution_id = 101) or
#		 (mtl.non_act_fee_pkg_id > 52126 and
#		  mtl.institution_id = 107) or
#		 mtl.fee_pkg_id != 0)
#		group by mtl.entity_id
#		order by mtl.entity_id "
#} else {
#}

#TEMP

set query_string_clr3 "select mtl.entity_id, sum(mtl.amt_original) as MC_BORDER_FEE
from mas_trans_log mtl
where mtl.mas_code in ('MC_BORDER','MC_GLOBAL_ACQ') and
mtl.tid like '010004%' and
substr(mtl.date_to_settle,4,6) = '$short_month-$short_year'
and gl_date > '$fee_start_gl_date'
and institution_id = '$institution_id_var'
and (institution_id, file_id) in (
 select institution_id, file_id from mas_file_log
 where institution_id = '$institution_id_var'
 and receive_date_time > add_months('$fee_start_gl_date', -1)
 and file_name not like '%CLEARING%'
)
group by mtl.entity_id
order by mtl.entity_id "
orasql $cursorM3 $query_string_clr3
while {[orafetch $cursorM3 -dataarray clr3 -indexbyname] != 1403} {
	set arrmcborfee($clr3(ENTITY_ID)) $clr3(MC_BORDER_FEE)
	#puts " arrmcborfee.... $arrmcborfee($clr3(ENTITY_ID))"
}

set query_string_clr4 " select mtl.entity_id, sum(mtl.amt_original) as VS_ISA_FEE
from masclr.mas_trans_log mtl
where mtl.mas_code in ('VS_ISA_FEE','VS_ISA_HI_RISK_FEE','VS_INT_ACQ_FEE')and
mtl.tid like '010004%' and
substr(mtl.date_to_settle,4,6) = '$short_month-$short_year'
and gl_date > '$fee_start_gl_date'
and institution_id = '$institution_id_var'
and (institution_id, file_id) in (
 select institution_id, file_id from mas_file_log
 where institution_id = '$institution_id_var'
 and receive_date_time > add_months('$fee_start_gl_date', -1)
  and file_name not like '%CLEARING%'
)
group by mtl.entity_id
order by mtl.entity_id "

orasql $cursorM4 $query_string_clr4
while {[orafetch $cursorM4 -dataarray clr4 -indexbyname] != 1403} {
	set arrvsisafee($clr4(ENTITY_ID)) $clr4(VS_ISA_FEE)
	#puts " arrvsisafee.... $arrvsisafee($clr4(ENTITY_ID))"
}

set query_string_clr5 "select entity_id,
    sum(ISO_EQ_COST) as ISO_EQ_COST,
    sum(ISO_DNLD_COST) as ISO_DNLD_COST,
    sum(ISO_REPAIR_COST) as ISO_REPAIR_COST,
    sum(ISO_SHIPPING) as ISO_SHIPPING
    from mas_terminal_log
    where substr(BILLING_DT, 1, 9) = last_day('01-$next_month-$next_short_year')
    group by entity_id
    order by entity_id"
orasql $cursorM7 $query_string_clr5
#puts "term bill: $query_string_clr5 "
while {[orafetch $cursorM7 -dataarray clr5 -indexbyname] != 1403} {
	set isoeqp($clr5(ENTITY_ID))       $clr5(ISO_EQ_COST)
	set isodnld($clr5(ENTITY_ID))      $clr5(ISO_DNLD_COST)
	set isorepair($clr5(ENTITY_ID))    $clr5(ISO_REPAIR_COST)
	set isoshipping($clr5(ENTITY_ID))  $clr5(ISO_SHIPPING)
	set arrtermbilling($clr5(ENTITY_ID)) [expr $isoeqp($clr5(ENTITY_ID))  + $isodnld($clr5(ENTITY_ID)) + $isorepair($clr5(ENTITY_ID)) + $isoshipping($clr5(ENTITY_ID))]
}

#***** REJECTS ********

set reject_mtd1 "select merch_id, to_char(sum(amt_trans)/100, '999999.00') as amt_trans, card_scheme \
	    from in_draft_main
	    where msg_text_block like '%JPREJECT%' and
	    (activity_dt > '01-$short_month-$short_year' and substr(activity_dt, 1, 9) <= last_day('01-$short_month-$short_year'))
		and in_file_nbr in (select in_file_nbr from in_file_log where institution_id = '$institution_id_var'
		 and end_dt > '01-$short_month-$short_year' and end_dt <=  last_day('01-$short_month-$short_year'))
	    group by merch_id, card_scheme"

orasql $fetch_cursorM1 $reject_mtd1
puts "reject mtd....$reject_mtd1"
while {[orafetch $fetch_cursorM1 -dataarray mtdw -indexbyname] != 1403} {
	if {$mtdw(CARD_SCHEME) == "04"} {
		set vrej($mtdw(MERCH_ID)) $mtdw(AMT_TRANS)
	} else {
		set mrej($mtdw(MERCH_ID)) $mtdw(AMT_TRANS)
	}
}

#***************************************************************************************************
#**********************               >>>>>>   Main 101  <<<<<<<<<
# *************************
#***************************************************************************************************
#
#if {0} {
#	set query_string_clr  " SELECT unique a.entity_id as MERCHANT_ID,
#	    replace(a.entity_dba_name, ',' , '') as MERCHANT_NAME,
#	    TERMINATION_DATE, CREATION_DATE
#		    FROM acq_entity a, mas_trans_log m
#		    WHERE a.entity_level = '70'  AND
#		    a.entity_id = m.entity_id AND
#		    a.institution_id = '101' AND
#		    a.entity_dba_name not like '%TEST%'  AND
#		    (substr(m.date_to_settle,4,6) = '$short_month-$short_year' or
#		     substr(m.gl_date,4,6) = '$short_month-$short_year')
#		    ORDER BY substr(a.entity_id, 8, 2), a.entity_id "
#	orasql $fetch_cursorM7 $query_string_clr
#	#puts "merchants....$query_string_clr"
#	while {[orafetch $fetch_cursorM7 -dataarray mer -indexbyname] != 1403} {
#		set MERCHANT_NUM $mer(MERCHANT_ID)
#		set MERCHANT_NAME $mer(MERCHANT_NAME)
#
#		set NON_BANK_COUNT 0
#		set DIAL_COUNT 0
#		set c 0
#		set IDcount 0
#		set TERM_COUNT 0
#		set DT_COUNT 0
#
#		catch {set x $arr($MERCHANT_NUM)} result
#		#               puts ">>>$result<<<"
#		if {[string range $result 0 9] == "can't read"} {
#			set NON_BANK_COUNT 0
#			set SUB_NON_BANK_COUNT 0
#		} else {
#			set  NON_BANK_COUNT  $arr($MERCHANT_NUM)
#			set  SUB_NON_BANK_COUNT [expr $SUB_NON_BANK_COUNT + $NON_BANK_COUNT]
#			#	       puts "  NON_BANK_COUNT is  $arr($MERCHANT_NUM)"
#		}
#
#		catch {set x1 $arrterm($MERCHANT_NUM)} result1
#		#puts "*****$result1******"
#		if {[string range $result1 0 9] == "can't read"} {
#			set TERMINAL_COUNT 0
#			set SUB_TERMINAL_COUNT 0
#		} else {
#			set TERMINAL_COUNT $arrterm($MERCHANT_NUM)
#			set SUB_TERMINAL_COUNT [expr $SUB_TERMINAL_COUNT + $TERMINAL_COUNT]
#			set DIAL_MONTHLY_MERCHANT [expr $TERMINAL_COUNT *
# $DIALUP_MONTHLY_RATE_PER_MERCHANT]
#		}
#
#		catch {set x2 $arrdt($MERCHANT_NUM)} result2
#		#puts ">>>>>$result2<<<<<<"
#		if {[string range $result2 0 9] == "can't read"} {
#			set DIAL_TR_COUNT 0
#			set SUB_DIAL_TR_COUNT 0
#		} else {
#			set DIAL_TR_COUNT $arrdt($MERCHANT_NUM)
#			set SUB_DIAL_TR_COUNT [expr $SUB_DIAL_TR_COUNT + $DIAL_TR_COUNT ]
#			set DIAL_MONTHLY [expr $DIAL_TR_COUNT * $DIAL_MONTHLY_RATE]
#			#puts " DT_COUNT for $MERCHANT_NUM is $arrdt($MERCHANT_NUM) and DIAL_monthly
# is
## $DIAL_MONTHLY "
#			#puts " $DIAL_TR_COUNT......$DIAL_MONTHLY"
#		}
#
#		catch {set x3 $arrauth($MERCHANT_NUM)} result3
#		#puts "*****$result1******"
#		if {[string range $result3 0 9] == "can't read"} {
#			set AUTH_TRAN_COUNT 0
#			set SUB_AUTH_TRAN_COUNT 0
#		} else {
#			set AUTH_TRAN_COUNT $arrauth($MERCHANT_NUM)
#			set SUB_AUTH_TRAN_COUNT [expr $SUB_AUTH_TRAN_COUNT + $AUTH_TRAN_COUNT]
#			#puts " Auth_tran_coun for $MERCHANT_NUM is $arrauth($MERCHANT_NUM) "
#			set AUTH_VOLUME [expr $AUTH_TRAN_COUNT * $AUTH_MONTHLY_RATE ]
#		}
#
#		catch {set x4 $arrallterm($MERCHANT_NUM)} result4
#		#  puts "*****$result4******"
#		if {[string range $result4 0 9] == "can't read"} {
#			set ALL_TERMINAL_COUNT 0
#			set SUB_ALL_TERMINAL_COUNT 0
#		} else {
#			set ALL_TERMINAL_COUNT $arrallterm($MERCHANT_NUM)
#			set SUB_ALL_TERMINAL_COUNT [expr $SUB_ALL_TERMINAL_COUNT +
# $ALL_TERMINAL_COUNT ]
#			#puts " ALL_TERMINAL_COUNT for $MERCHANT_NUM is $arrallterm($MERCHANT_NUM) "
#		}
#
#		set MERNAME  [string map {" " "-"} $MERCHANT_NAME ]
#		set MERNAME  [string map {"." "-"} $MERNAME ]
#		set MERCHANT_PAGE
# /clearing/filemgr/STATEMENTS/INST_447474/ARCHIVE/$MERCHANT_NUM-$short_month-$short_year.pdf
#		set MERCHANT_PAGE_SEP
# /clearing/filemgr/STATEMENTS/INST_447474/ARCHIVE/$MERCHANT_NUM-$MERNAME-$short_month-$short_year.pdf
#		#set MERCHANT_PAGE
##
# /clearing/filemgr/STATEMENTS/INST_447474/$MERCHANT_NUM-$short_month-$short_year.pdf
#		#set MERCHANT_PAGE
## /clearing/filemgr/STATEMENTS/INST_447474/ARCHIVE/$MERCHANT_NUM-$clr_date.pdf
#		if {[catch {set PAGE_NUM [exec grep Count $MERCHANT_PAGE]}]} {
#			#set PAGE_NUM 0
#			#set SUB_PAGE_NUM 0
#			#puts "Can not read PDF file $MERCHANT_NUM-$short_month-$short_year.pdf try
# more"
#			if {[catch {set PAGE_NUM [exec grep Count $MERCHANT_PAGE_SEP]}]} {
#				#puts "it really not existed: $MERCHANT_PAGE_SEP"
#			} else {
#				set PAGE_NUM [string range "[exec grep Count $MERCHANT_PAGE_SEP]" 7 7]
#				set SUB_PAGE_NUM [expr $SUB_PAGE_NUM + $PAGE_NUM]
#				#puts "SUB_PAGE_NUM expr $SUB_PAGE_NUM + $PAGE_NUM : $MERCHANT_PAGE_SEP ]"
#			}
#		} else {
#			set PAGE_NUM [string range "[exec grep Count $MERCHANT_PAGE_SEP]" 7 7]
#			set SUB_PAGE_NUM [expr $SUB_PAGE_NUM + $PAGE_NUM]
#			#puts "SUB_PAGE_NUM expr $SUB_PAGE_NUM + $PAGE_NUM : $MERCHANT_PAGE_SEP ]"
#		}
#		set CHARGE_PER_PAGE [expr $PAGE_NUM * $MERCHANT_PAGE_RATE ]
#
#		#SYANG: take out FEE_PER_CONTRACT per request by Marcy and Pei
#		#puts "page number is $PAGE_NUM"
#		# Fees per Contract
#		#        if {$MERCHANT_NUM > 0 } {
#		#         set FEE_PER_CONTRACT 1
#		#        } else {
#		#          set FEE_PER_CONTRACT 0
#		#        }
#		#
#		catch {set syang $arramt($MERCHANT_NUM)}       result5
#		catch {set syang $arrcpamt($MERCHANT_NUM)}     result6
#		catch {set syang $arrcnpamt($MERCHANT_NUM)}    result7
#		catch {set syang $arrsetcnt($MERCHANT_NUM)}    result8
#		catch {set syang $arrcpcnt($MERCHANT_NUM)}     result9
#		catch {set syang $arrcnpcnt($MERCHANT_NUM)}    result10
#		catch {set syang $arrchgcnt($MERCHANT_NUM)}    result11
#		catch {set syang $arrchgamt($MERCHANT_NUM)}    result12
#		catch {set syang $arrdischg($MERCHANT_NUM)}    result13
#		catch {set syang $arrfraud($MERCHANT_NUM)}     result53
#		catch {set syang $arrinchg($MERCHANT_NUM)}     result55
#		catch {set syang $arrretrival($MERCHANT_NUM)}  result58
#		catch {set syang $arrmcborfee($MERCHANT_NUM)}  result60
#		catch {set syang $arrvsisafee($MERCHANT_NUM)}  result61
#		catch {set syang $arrmcassess($MERCHANT_NUM)}  result66
#		catch {set syang $arrvsassess($MERCHANT_NUM)}  result67
#		catch {set syang $arrtermbilling($MERCHANT_NUM)}  resulttermbill
#
#		if {[string range $resulttermbill 0 9] == "can't read" } {
#			set TERMINAL_BILLING 0
#		} else {
#			set TERMINAL_BILLING $arrtermbilling($MERCHANT_NUM)
#			set SUB_TERMINAL_BILLING [ expr $SUB_TERMINAL_BILLING + $TERMINAL_BILLING]
#		}
#		if {[string range $result66 0 9] == "can't read" } {
#			set MC_ASSESSMENT_AMT 0
#		} else {
#			set MC_ASSESSMENT_AMT $arrmcassess($MERCHANT_NUM)
#		}
#		if {[string range $result67 0 9] == "can't read" } {
#			set VS_ASSESSMENT_AMT 0
#		} else {
#			set VS_ASSESSMENT_AMT $arrvsassess($MERCHANT_NUM)
#		}
#
#		if {[string range $result60 0 9] == "can't read" } {
#			set MC_BORDER_FEE 0
#		} else {
#			set MC_BORDER_FEE $arrmcborfee($MERCHANT_NUM)
#		}
#		if {[string range $result61 0 9] == "can't read" } {
#			set VS_ISA_FEE 0
#		} else {
#			set VS_ISA_FEE $arrvsisafee($MERCHANT_NUM)
#		}
#		if {[string range $result58 0 9] == "can't read" } {
#			set RETRIVAL_COUNT 0
#		} else {
#			set RETRIVAL_COUNT $arrretrival($MERCHANT_NUM)
#		}
#		if {[string range $result5 0 9] == "can't read" } {
#			set AMOUNT 0
#		} else {
#			set AMOUNT $arramt($MERCHANT_NUM)
#		}
#		if {[string range $result6 0 9] == "can't read" } {
#			set CARD_PRESENT_AMOUNT 0
#		} else {
#			set CARD_PRESENT_AMOUNT $arrcpamt($MERCHANT_NUM)
#		}
#		if {[string range $result7 0 9] == "can't read" } {
#			set CARD_NOT_PRESENT_AMOUNT 0
#		} else {
#			set CARD_NOT_PRESENT_AMOUNT $arrcnpamt($MERCHANT_NUM)
#		}
#		if {[string range $result8 0 9] == "can't read" } {
#			set SETT_TRAN_COUNT 0
#		} else {
#			set SETT_TRAN_COUNT  $arrsetcnt($MERCHANT_NUM)
#		}
#		if {[string range $result9 0 9] == "can't read" } {
#			set CP_TRAN_COUNT 0
#		} else {
#			set CP_TRAN_COUNT $arrcpcnt($MERCHANT_NUM)
#		}
#		if {[string range $result10 0 9] == "can't read"} {
#			set NP_TRAN_COUNT 0
#		} else {
#			set NP_TRAN_COUNT $arrcnpcnt($MERCHANT_NUM)
#		}
#		if {[string range $result11 0 9] == "can't read"} {
#			set CHARGEBACK_CNT 0
#		} else {
#			set  CHARGEBACK_CNT $arrchgcnt($MERCHANT_NUM)
#		}
#		if {[string range $result12 0 9] == "can't read"} {
#			set CHARGEBACK_AMT 0
#		} else {
#			set CHARGEBACK_AMT $arrchgamt($MERCHANT_NUM)
#		}
#		if {[string range $result13 0 9] == "can't read"} {
#			set DISCOUNT_CHARGE 0
#		} else {
#			set DISCOUNT_CHARGE $arrdischg($MERCHANT_NUM)
#		}
#		if {[string range $result53 0 9] == "can't read"} {
#			set FRAUD_COUNT 0
#		} else {
#			set FRAUD_COUNT $arrfraud($MERCHANT_NUM)
#		}
#		if {[string range $result55 0 9] == "can't read"} {
#			set INTERCHANG_AMOUNT 0
#		} else {
#			set INTERCHANG_AMOUNT $arrinchg($MERCHANT_NUM)
#		}
#		catch {set syang $mrej($MERCHANT_NUM)} resultmrej
#		catch {set syang $vrej($MERCHANT_NUM)} resultvrej
#		if {[string range $resultmrej 0 9] == "can't read"} {
#			set mrej($MERCHANT_NUM) 0
#			set sub_101_mrej 0
#		} else {
#			set sub_101_mrej [expr $sub_101_mrej + $mrej($MERCHANT_NUM)]
#		}
#		if {[string range $resultvrej 0 9] == "can't read"} {
#			set vrej($MERCHANT_NUM) 0
#			set sub_101_vrej 0
#		} else {
#			set sub_101_vrej [expr $sub_101_vrej + $vrej($MERCHANT_NUM)]
#		}
#		catch {set syang107 $arrreturnamt($MERCHANT_NUM)}  resultreturnamt
#		if {[string range $resultreturnamt 0 9] == "can't read"} {
#			set arrreturnamt($MERCHANT_NUM) 0
#		}
#		if {0} {
#			set detail101 "$MERCHANT_NUM, $MERCHANT_NAME,
# $AMOUNT,$arrreturnamt($MERCHANT_NUM)"
#			set detail101 "$detail101,$vrej($MERCHANT_NUM),
# $mrej($MERCHANT_NUM),$CARD_PRESENT_AMOUNT"
#			set detail101 "$detail101, $CARD_NOT_PRESENT_AMOUNT,$ALL_TERMINAL_COUNT"
#			set detail101 "$detail101,$TERMINAL_COUNT, $TERMINAL_BILLING,
# $NON_BANK_COUNT,$SETT_TRAN_COUNT,$AUTH_TRAN_COUNT"
#			set detail101
# "$detail101,$CP_TRAN_COUNT,$NP_TRAN_COUNT,$PAGE_NUM,$DIAL_TR_COUNT,$CHARGEBACK_CNT,$CHARGEBACK_AMT"
#			set detail101
# "$detail101,$RETRIVAL_COUNT,$DISCOUNT_CHARGE,$INTERCHANG_AMOUNT,$MC_ASSESSMENT_AMT"
#			puts $cur_file "$detail101,$VS_ASSESSMENT_AMT, $MC_BORDER_FEE,$VS_ISA_FEE, ,
# , ,$FRAUD_COUNT\r "
#		}
#
#		puts $cur_file " $MERCHANT_NUM, $MERCHANT_NAME,
# $AMOUNT,$arrreturnamt($MERCHANT_NUM), $vrej($MERCHANT_NUM),
# $mrej($MERCHANT_NUM), $CARD_PRESENT_AMOUNT, $CARD_NOT_PRESENT_AMOUNT,
# $ALL_TERMINAL_COUNT, \
#				    $TERMINAL_COUNT,$TERMINAL_BILLING,$NON_BANK_COUNT,$SETT_TRAN_COUNT,
# $AUTH_TRAN_COUNT, \
#				    $CP_TRAN_COUNT,$NP_TRAN_COUNT,$PAGE_NUM,$DIAL_TR_COUNT,$CHARGEBACK_CNT,
# $CHARGEBACK_AMT,\
#				    $RETRIVAL_COUNT,$DISCOUNT_CHARGE,$INTERCHANG_AMOUNT,$MC_ASSESSMENT_AMT,
# $VS_ASSESSMENT_AMT, $MC_BORDER_FEE, $VS_ISA_FEE, , , , $FRAUD_COUNT\r"
#
#		set MERCHANT_NUM              0
#		set MERCHANT_NAME             0
#		set AMOUNT                    0
#		set CARD_PRESENT_AMOUNT       0
#		set CARD_NOT_PRESENT_AMOUNT   0
#		set TERMINAL_COUNT            0
#		set NON_BANK_COUNT            0
#		set SETT_TRAN_COUNT           0
#		set AUTH_TRAN_COUNT           0
#		set CP_TRAN_COUNT             0
#		set NP_TRAN_COUNT             0
#		set PAGE_NUM                  0
#		set DIAL_TR_COUNT             0
#		set RETRIVAL_COUNT            0
#		set DISCOUNT_CHARGE           0
#		set PASSTHROUGH_AMOUNT        0
#		set PASSTHROUGH_MS            0
#		set PASSTHROUGH_VS            0
#		set ACH_RETURN                0
#		set AUTH_VOLUM                0
#		set SETT_VOLUME               0
#		set DIAL_MONTHLY              0
#		set FEE_PER_CONTRACT          0
#		set CHARGE_PER_PAGE           0
#		set DIAL_MONTHLY_MERCHANT     0
#		set TERMINAL_BILLING          0
#	}
#	catch {set syang $arrsubamt($inst_101)}      result30
#	catch {set syang $arrsubcpamt($inst_101)}    result31
#	catch {set syang $arrsubcnpamt($inst_101)}   result32
#	catch {set syang $arrsubsetcnt($inst_101)}   result33
#	catch {set syang $arrsubcpcnt($inst_101)}    result34
#	catch {set syang $arrsubcnpcnt($inst_101)}   result35
#	catch {set syang $arrsubchgcnt($inst_101)}   result36
#	catch {set syang $arrsubchgamt($inst_101)}   result37
#	catch {set syang $arrsubdischg($inst_101)}   result38
#	catch {set syang $arrsubfraud($inst_101)}    result56
#
#	if {[string range $result30 0 9] == "can't read" } {
#		set arrsubamt($inst_101) 0
#	}
#	if { [string range $result31 0 9] == "can't read" } {
#		set arrsubcpamt($inst_101) 0
#	}
#	if { [string range $result32 0 9] == "can't read" } {
#		set arrsubcnpamt($inst_101) 0
#	}
#	if { [string range $result33 0 9] == "can't read" } {
#		set arrsubsetcnt($inst_101) 0
#	}
#	if { [string range $result34 0 9] == "can't read" } {
#		set arrsubcpcnt($inst_101) 0
#	}
#	if { [string range $result35 0 9] == "can't read" } {
#		set arrsubcnpcnt($inst_101) 0
#	}
#	if { [string range $result36 0 9] == "can't read" } {
#		set arrsubchgcnt($inst_101) 0
#	}
#	if { [string range $result37 0 9] == "can't read" } {
#		set arrsubchgamt($inst_101) 0
#	}
#	if { [string range $result38 0 9] == "can't read" } {
#		set arrsubdischg($inst_101) 0
#	}
#	if { [string range $result56 0 9] == "can't read" } {
#		set arrsubinchg($inst_101) 0
#	}
#	catch {set syang107 $arrsubreturnamt($inst_101)}  resultsubreturnamt
#	if {[string range $resultsubreturnamt 0 9] == "can't read"} {
#		set arrsubreturnamt($inst_101) 0
#	}
#
#	puts $cur_file "                 "
#	puts $cur_file " * SUBTOTAL  :, JPMS ,
# $arrsubamt($inst_101),$arrsubreturnamt($inst_101),$sub_101_vrej,$sub_101_mrej,$arrsubcpamt($inst_101),
# $arrsubcnpamt($inst_101), $ALL_TERMINAL_COUNT, \
#		$TERMINAL_COUNT,$SUB_TERMINAL_BILLING,
# $NON_BANK_COUNT,$arrsubsetcnt($inst_101), $AUTH_TRAN_COUNT, \
#		$arrsubcpcnt($inst_101),$arrsubcnpcnt($inst_101),$PAGE_NUM,$DIAL_TR_COUNT,$arrsubchgcnt($inst_101),
# $arrsubchgamt($inst_101),\
#		$RETRIVAL_COUNT,$arrsubdischg($inst_101),$arrsubinchg($inst_101) , , , ,\r"
#} ;# end if

puts $cur_file "                 "

set SUB_AMOUNT                     0
set SUB_CARD_PRESENT_AMOUNT        0
set SUB_CARD_NOT_PRESENT_AMOUNT    0
set SUB_ALL_TERMINAL_COUNT         0
set SUB_TERMINAL_COUNT             0
set SUB_NON_BANK_COUNT             0
set SUB_SETT_TRAN_COUNT            0
set SUB_AUTH_TRAN_COUNT            0
set SUB_CP_TRAN_COUNT              0
set SUB_NP_TRAN_COUNT              0
set SUB_PAGE_NUM                   0
set SUB_DIAL_TR_COUNT              0
set SUB_RETRIVAL_COUNT             0
set SUB_DISCOUNT_CHARGE            0
set SUB_PASSTHROUGH_AMOUNT         0
set SUB_PASSTHROUGH_MS             0
set SUB_PASSTHROUGH_VS             0
set SUB_ACH_RETURN                 0
set SUB_AUTH_VOLUME                0
set SUB_SETT_VOLUME                0
set SUB_DIAL_MONTHLY               0
#set SUB_FEE_PER_CONTRACT           0
set SUB_CHARGE_PER_PAGE            0
set SUB_DIAL_MONTHLY_MERCHANT      0
set SUB_CHARGEBACK_CNT             0
set SUB_CHARGEBACK_AMT             0
set SUB_TERMINAL_BILLING           0
#====================================================================================================================
### *****************************************         MAS INST 107
# *****************************************
#====================================================================================================================

#set inst_107 "107"
set query_string_clr " SELECT unique m.entity_id as VISA_ID,
    (select replace(entity_dba_name, ',' , '') from acq_entity where entity_id = m.entity_id) as NAME,
    SUM(CASE WHEN (m.tid in ('010003005101' , '010123005102', '010003005102','010123005101') and m.tid_settl_method = 'C' and i.pos_crd_present = '1' and m.trans_sub_seq = '0') Then m.amt_original else 0 end ) AS CP_S_AMOUNT,
    SUM(CASE WHEN (m.tid in ('010003005101' , '010123005102', '010003005102','010123005101') and m.tid_settl_method = 'D' and i.pos_crd_present = '1' and m.trans_sub_seq = '0') Then m.amt_original else 0 end) AS CP_R_AMOUNT,
    SUM(CASE WHEN (m.tid in ('010003005101' , '010123005102', '010003005102','010123005101') and m.tid_settl_method = 'C' and (i.pos_crd_present <> '1' or i.pos_crd_present is null ) and m.trans_sub_seq = '0') Then m.amt_original else 0 end ) AS CNP_S_AMOUNT,
    SUM(CASE WHEN (m.tid in ('010003005101' , '010123005102', '010003005102','010123005101') and m.tid_settl_method = 'D' and (i.pos_crd_present <> '1' or i.pos_crd_present is null ) and m.trans_sub_seq = '0') Then m.amt_original else 0 end) AS CNP_R_AMOUNT,
    SUM(CASE WHEN (m.tid in ('010003005101' , '010123005102', '010003005102','010123005101') and m.tid_settl_method = 'C' and i.pos_crd_present = '1' and m.trans_sub_seq = '0') Then 1 else 0 end ) AS CP_S_COUNT,
    SUM(CASE WHEN (m.tid in ('010003005101' , '010123005102', '010003005102','010123005101') and m.tid_settl_method = 'D' and i.pos_crd_present = '1' and m.trans_sub_seq = '0') Then 1 else 0 end) AS CP_R_COUNT,
    SUM(CASE WHEN (m.tid in ('010003005101' , '010123005102', '010003005102','010123005101') and m.tid_settl_method = 'C' and (i.pos_crd_present <> '1' or i.pos_crd_present is null ) and m.trans_sub_seq = '0') Then 1 else 0 end ) AS CNP_S_COUNT,
    SUM(CASE WHEN (m.tid in ('010003005101' , '010123005102', '010003005102','010123005101') and m.tid_settl_method = 'D' and (i.pos_crd_present <> '1' or i.pos_crd_present is null ) and m.trans_sub_seq = '0') Then 1 else 0 end) AS CNP_R_COUNT,
    SUM(CASE WHEN ((m.tid in ('010003005101' , '010123005102', '010003005102' , '010123005101') and m.trans_sub_seq = '0')
			    or (m.tid = '010003005301')) Then 1 else 0 end) AS TOTAL_COUNT,
    ( SUM(CASE WHEN (m.tid in ('010123005102','010123005101') and m.tid_settl_method = 'C' and m.trans_sub_seq = '0') Then m.amt_original else 0 end )
      - SUM(CASE WHEN (m.tid in ('010123005102','010123005101') and m.tid_settl_method = 'D' and m.trans_sub_seq = '0') Then m.amt_original else 0 end) ) AS RETURN_AMOUNT,
    SUM(CASE WHEN ((m.gl_date >= :cb_gl_start_date and m.gl_date < :cb_gl_end_date) and m.tid in ('010003005301', '010003005401', '010003010102','010003015201', '010003015102', '010003015101', '010003015210') and m.tid_settl_method = 'C' )Then m.amt_original else 0 end ) as CHARGEBACK_S_AMT,
    SUM(CASE WHEN ((m.gl_date >= :cb_gl_start_date and m.gl_date < :cb_gl_end_date) and m.tid in ('010003005301', '010003005401', '010003010102','010003015201', '010003015102', '010003015101', '010003015210') and m.tid_settl_method = 'D' )Then m.amt_original else 0 end ) as CHARGEBACK_R_AMT,
    SUM(CASE WHEN ((m.gl_date >= :cb_gl_start_date and m.gl_date < :cb_gl_end_date) and m.tid in ('010003005301', '010003005401', '010003010102','010003015201', '010003015102', '010003015101', '010003015210')) Then 1 else 0 end ) as CHARGEBACK_CNT
    FROM mas_trans_log m, in_draft_main i
    WHERE  m.institution_id = :institution_id
	AND m.trans_ref_data = i.arn
AND to_char(m.external_trans_nbr) = to_char(i.trans_seq_nbr)
	and i.in_file_nbr in (select in_file_nbr from in_file_log where
	 institution_id = :institution_id and incoming_dt >
	 add_months(:act_gl_start_date,-1))
	AND m.gl_date >= :act_gl_start_date and m.gl_date < :act_gl_end_date
	AND m.settl_flag = 'Y'
	GROUP BY m.entity_id
	ORDER BY substr(m.entity_id, 8,2), m.entity_id "

oraparse $cursorM6 $query_string_clr
puts "query: $query_string_clr"
puts "bind_vars: :cb_gl_start_date $chargeback_gl_start_date :cb_gl_end_date $chargeback_gl_end_date :institution_id $institution_id_var :act_gl_start_date $activity_gl_start_date :act_gl_end_date $activity_gl_end_date"
orabind $cursorM6 :cb_gl_start_date $chargeback_gl_start_date :cb_gl_end_date $chargeback_gl_end_date \
	:institution_id $institution_id_var :act_gl_start_date $activity_gl_start_date :act_gl_end_date $activity_gl_end_date
oraexec $cursorM6
#orasql $cursorM6 $query_string_clr
while {[orafetch $cursorM6 -dataarray clr -indexbyname] != 1403} {
	set AMOUNT [expr ($clr(CP_S_AMOUNT) + $clr(CNP_S_AMOUNT)) - ($clr(CP_R_AMOUNT) + $clr(CNP_R_AMOUNT))]
	set CARD_PRESENT_AMOUNT     [expr $clr(CP_S_AMOUNT) - $clr(CP_R_AMOUNT) ]
	set CARD_NOT_PRESENT_AMOUNT [expr $clr(CNP_S_AMOUNT) - $clr(CNP_R_AMOUNT)]
	set CP_TRAN_COUNT           [expr $clr(CP_S_COUNT) + $clr(CP_R_COUNT)]
	set NP_TRAN_COUNT           [expr $clr(CNP_S_COUNT) + $clr(CNP_R_COUNT)]
	set SETT_TRAN_COUNT         $clr(TOTAL_COUNT)
	set SETT_VOLUME             [expr $SETT_TRAN_COUNT * $SETT_MONTHLY_RATE ]
	set CHARGEBACK_AMT          [expr $clr(CHARGEBACK_S_AMT) - $clr(CHARGEBACK_R_AMT)]
	set CHARGEBACK_CNT          $clr(CHARGEBACK_CNT)
	set arrreturnamt($clr(VISA_ID))  $RETURN_AMT

	set arramt($clr(VISA_ID))      $AMOUNT
	set arrcpamt($clr(VISA_ID))   $CARD_PRESENT_AMOUNT
	set arrcnpamt($clr(VISA_ID))  $CARD_NOT_PRESENT_AMOUNT
	set arrcpcnt($clr(VISA_ID))   $CP_TRAN_COUNT
	set arrcnpcnt($clr(VISA_ID))  $NP_TRAN_COUNT
	set arrsetcnt($clr(VISA_ID))  $SETT_TRAN_COUNT
	set arrsetamt($clr(VISA_ID))  $SETT_VOLUME
	set arrchgamt($clr(VISA_ID))  $CHARGEBACK_AMT
	set arrchgcnt($clr(VISA_ID))  $CHARGEBACK_CNT
}

set query_string_clr2 " SELECT m.entity_id as VISA_ID,
    SUM( CASE WHEN((date_to_settle > :fee_start_settle_date and date_to_settle < :fee_end_settle_date) and ((m.TID LIKE '010004%' and m.tid not like '01000428%') or m.tid like '01000507%' ) and m.settl_flag = 'Y' and m.tid_settl_method = 'C') \
		    then m.AMT_ORIGINAL end ) as CREDIT_AMOUNT,
    SUM( CASE WHEN((date_to_settle > :fee_start_settle_date and date_to_settle < :fee_end_settle_date) and ((m.TID LIKE '010004%' and m.tid not like '01000428%') or m.tid like '01000507%' ) and m.settl_flag = 'Y' and m.tid_settl_method = 'D') \
		    then m.AMT_ORIGINAL end ) as DEBIT_AMOUNT,
    (SUM(CASE WHEN((gl_date > :interchange_start_gl_date and gl_date < :interchange_end_gl_date) and  m.tid in ('010004020000', '010004020005') and m.tid_settl_method = 'D' ) then AMT_ORIGINAL else 0 end) \
     - SUM(CASE WHEN( (gl_date > :interchange_start_gl_date and gl_date < :interchange_end_gl_date) and m.tid in ('010004020000', '010004020005') and m.tid_settl_method = 'C' ) then AMT_ORIGINAL else 0 end)) as INTERCHANGE_AMT,
    SUM(CASE WHEN( (gl_date > :interchange_start_gl_date and gl_date < :interchange_end_gl_date) and m.tid in ('010004020000', '010004020005') ) then 1 else 0 end) as INTERCHANGE_CNT,
    (SUM(CASE WHEN((gl_date > :interchange_start_gl_date and gl_date < :interchange_end_gl_date) and mas_code= 'MC_ASSMT' and m.tid_settl_method = 'D') then AMT_ORIGINAL else 0 end)
     - SUM(CASE WHEN((gl_date > :interchange_start_gl_date and gl_date < :interchange_end_gl_date) and mas_code= 'MC_ASSMT' and m.tid_settl_method = 'C') then AMT_ORIGINAL else 0 end)) as MC_ASSESSMENT_AMT,
    (SUM(CASE WHEN((gl_date > :interchange_start_gl_date and gl_date < :interchange_end_gl_date) and mas_code= 'VISA_ASSMT' and m.tid_settl_method = 'D') then AMT_ORIGINAL else 0 end)
     - SUM(CASE WHEN((gl_date > :interchange_start_gl_date and gl_date < :interchange_end_gl_date) and mas_code= 'VISA_ASSMT' and m.tid_settl_method = 'C') then AMT_ORIGINAL else 0 end)) as VS_ASSESSMENT_AMT,
    SUM(CASE WHEN(  substr(m.date_to_settle,4,6) = :date_to_settle and m.mas_code in ('0204RREQ','0205RREQ')) then 1 else 0 end) as RETRIEVAL_CNT
    FROM mas_trans_log m
    WHERE m.institution_id = :institution_id
    AND ((date_to_settle > :fee_start_settle_date and date_to_settle < :fee_end_settle_date)
		    or (gl_date > :fee_start_gl_date and gl_date < :fee_end_gl_date))
    GROUP BY m.entity_id
    ORDER BY substr(m.entity_id, 8,2), m.entity_id "

oraparse $cursorM5 $query_string_clr2
puts "query: $query_string_clr2"
puts "bind_vars: :institution_id $institution_id_var :fee_start_settle_date $fee_start_settle_date :fee_end_settle_date $fee_end_settle_date :fee_start_gl_date $fee_start_gl_date :fee_end_gl_date $fee_end_gl_date :interchange_start_gl_date $interchange_start_gl_date :interchange_end_gl_date $interchange_end_gl_date :date_to_settle $short_month-$short_year"
orabind $cursorM5 :institution_id $institution_id_var :fee_start_settle_date $fee_start_settle_date \
	:fee_end_settle_date $fee_end_settle_date :fee_start_gl_date $fee_start_gl_date :fee_end_gl_date $fee_end_gl_date \
	:interchange_start_gl_date $interchange_start_gl_date :interchange_end_gl_date $interchange_end_gl_date \
	:date_to_settle $short_month-$short_year

oraexec $cursorM5
#orasql $cursorM5 $query_string_clr2
while {[orafetch $cursorM5 -dataarray clr2 -indexbyname] != 1403} {
	set DISCOUNT_CHARGE           [expr $clr2(DEBIT_AMOUNT) - $clr2(CREDIT_AMOUNT) ]
	set RETRIEVAL_CNT              $clr2(RETRIEVAL_CNT)
	set INTERCHANG_AMOUNT          $clr2(INTERCHANGE_AMT)
	set MC_ASSESSMENT_AMT              $clr2(MC_ASSESSMENT_AMT)
	set arrmcassess($clr2(VISA_ID))   $MC_ASSESSMENT_AMT
	set VS_ASSESSMENT_AMT              $clr2(VS_ASSESSMENT_AMT)
	set arrvsassess($clr2(VISA_ID))   $VS_ASSESSMENT_AMT
	set arrinchg($clr2(VISA_ID))   $INTERCHANG_AMOUNT
	set arrdischg($clr2(VISA_ID))  $DISCOUNT_CHARGE
	set INTERCHANG_AMOUNT          $clr2(INTERCHANGE_AMT)
	set arrinchg($clr2(VISA_ID))   $INTERCHANG_AMOUNT
	set arrretrival($clr2(VISA_ID)) $RETRIEVAL_CNT
}

##
# ******************************************************************************************************
## ********************************************** MAIN 107
# **********************************************
##*******************************************************************************************************

set query_string_iso "   SELECT unique substr(entity_id, 8, 2) as ISO_ID
FROM acq_entity
WHERE entity_level = '70'
AND entity_status = 'A'
AND institution_id = '$institution_id_var'
AND entity_dba_name not like '%TEST%'
ORDER BY substr(entity_id, 8, 2) "
orasql $fetch_cursorM3 $query_string_iso
puts "iso....$query_string_iso"
while {[orafetch $fetch_cursorM3 -dataarray iso -indexbyname] != 1403} {

	puts $cur_file "ISO $iso(ISO_ID)"
	puts $cur_file "Merchant ID, Merchant Name,Total Sales Volume, Sales Return, VS Reject, MC Reject, CP Sales Volume, CNP Sales Volume, Number of Terminals, # of Dialup Terminals, Terminal Billing, NON Bankcard count, Sett Transaction # Count, Auth Transaction Count, CP Transaction Count, CNP Transaction Count, Merchant Page Count,Dialup Transaction Count, Chargeback Count, Chargeback Amount, Retrieval Count, Discount Charged, Interchange (Passthrough), MC Assessment, VS Assessment, Mastercard Fee Collection, Visa Fee Collection, ACH Return, CVV2, VBV, Fraud Count \r\n"
	
	set SUB_AMOUNT    0
	set  SUB_NON_BANK_COUNT 0
	set SUB_TERMINAL_COUNT 0
	set SUB_ALL_TERMINAL_COUNT 0
	set SUB_DIAL_TR_COUNT 0
	set SUB_CARD_PRESENT_AMOUNT     0
	set SUB_CARD_NOT_PRESENT_AMOUNT 0
	set SUB_CP_TRAN_COUNT           0
	set SUB_NP_TRAN_COUNT           0
	set SUB_SETT_TRAN_COUNT         0
	set SUB_SETT_VOLUME             0
	set SUB_CHARGEBACK_AMT          0
	set SUB_CHARGEBACK_CNT          0
set SUB_FRAUD_COUNT				0
	set SUB_AUTH_TRAN_COUNT 0
	set SUB_DISCOUNT_CHARGE    0
	set SUB_INTERCHANG_AMOUNT			0
	set SUB_PASSTHROUGH_AMOUNT 0
	set SUB_PASSTHROUGH_MS     0
	set SUB_PASSTHROUGH_VS     0
	set SUB_RETURN_AMT         0
	set SUB_RETRIVAL_COUNT 0
	set SUB_VS_ASSESSMENT_AMT 0
	set SUB_MC_ASSESSMENT_AMT 0
	set SUB_VS_ISA_FEE 0
	set SUB_MC_BORDER_FEE 0

	set ISO_ID $iso(ISO_ID)
	puts " iso id is $ISO_ID"
	
	# get all entities that had anything settle in the period
	# removing 			    AND (to_char(m.date_to_settle,'MON-YY') = :date_to_settle or
# to_char(m.gl_date,'MON-YY') = :date_to_settle)
	# replacing with payment_seq_nbr subquery
#	

	
	set clr_qry " SELECT unique a.entity_id as MERCHANT_ID,
		replace(a.entity_dba_name, ',' , '') as MERCHANT_NAME,
		TERMINATION_DATE,
		CREATION_DATE
			FROM acq_entity a 
	  join entity_acct ae on a.institution_id = ae.institution_id and a.entity_id = ae.owner_entity_id
	  join acct_accum_det aad on aad.institution_id = ae.institution_id and
	  aad.entity_acct_id = ae.entity_acct_id
			WHERE a.entity_level = '70'
			AND a.institution_id = '$institution_id_var'
			AND substr(a.entity_id, 8, 2) = '$ISO_ID'
			AND a.entity_dba_name not like '%TEST%'
	  and aad.payment_status is not null
	  and AAD.SETTL_DATE like '%$short_month-$short_year%'
			ORDER BY  a.entity_id "
#	oraparse $fetch_cursorM10 $clr_qry
	puts "query: $clr_qry"
#	set bind_vars [dict create :institution_id $institution_id_var :iso_id $ISO_ID :date_to_settle_like "%$short_month-$short_year%"]
	
	
#	puts "bind_vars: $bind_vars"
#	orabind $fetch_cursorM10 $bind_vars
	orasql $fetch_cursorM10 $clr_qry
	
	#orasql $fetch_cursorM4 $clr_qry
	puts "merchants....$clr_qry"
	while {[orafetch $fetch_cursorM10 -dataarray mer -indexbyname] != 1403} {
		puts $mer(MERCHANT_ID)
		set MERCHANT_NUM $mer(MERCHANT_ID)
		set MERCHANT_NAME $mer(MERCHANT_NAME)
		# NON Bankcard Count:
		set NON_BANK_COUNT 0
		set DIAL_COUNT 0
		set c 0
		set IDcount 0
		set TERM_COUNT 0
		set DT_COUNT 0

		catch {set x $arr($MERCHANT_NUM)} result
		if {[string range $result 0 9] == "can't read"} {
			set NON_BANK_COUNT 0
			#set SUB_NON_BANK_COUNT 0
		} else {
			set  NON_BANK_COUNT  $arr($MERCHANT_NUM)
			
		}
		set  SUB_NON_BANK_COUNT [expr $SUB_NON_BANK_COUNT + $NON_BANK_COUNT]

		catch {set x1 $arrterm($MERCHANT_NUM)} result1
		#puts "*****$result1******"
		if {[string range $result1 0 9] == "can't read"} {
			set TERMINAL_COUNT 0
			#set SUB_TERMINAL_COUNT 0
		} else {
			set TERMINAL_COUNT $arrterm($MERCHANT_NUM)
			
			set DIAL_MONTHLY_MERCHANT [expr $TERMINAL_COUNT * $DIALUP_MONTHLY_RATE_PER_MERCHANT]
		}
		set SUB_TERMINAL_COUNT [expr $SUB_TERMINAL_COUNT + $TERMINAL_COUNT]
		
		catch {set x2 $arrdt($MERCHANT_NUM)} result2
		#puts ">>>>>$result2<<<<<<"
		if {[string range $result2 0 9] == "can't read"} {
			set DIAL_TR_COUNT 0
			#set SUB_DIAL_TR_COUNT 0
		} else {
			set DIAL_TR_COUNT $arrdt($MERCHANT_NUM)
			
			set DIAL_MONTHLY [expr $DIAL_TR_COUNT * $DIAL_MONTHLY_RATE]
			#puts " DT_COUNT for $MERCHANT_NUM is $arrdt($MERCHANT_NUM) and DIAL_monthly is
			# $DIAL_MONTHLY "
			#puts " $DIAL_TR_COUNT......$DIAL_MONTHLY"
		}
	set SUB_DIAL_TR_COUNT [expr $SUB_DIAL_TR_COUNT + $DIAL_TR_COUNT ]
		
		catch {set x3 $arrauth($MERCHANT_NUM)} result3
		#puts "*****$result1******"
		if {[string range $result3 0 9] == "can't read"} {
			set AUTH_TRAN_COUNT 0
			
		} else {
			set AUTH_TRAN_COUNT $arrauth($MERCHANT_NUM)
			
			# puts " Auth_tran_coun for $MERCHANT_NUM is $arrauth($MERCHANT_NUM) "
			set AUTH_VOLUME [expr $AUTH_TRAN_COUNT * $AUTH_MONTHLY_RATE ]
		}
set SUB_AUTH_TRAN_COUNT [expr $SUB_AUTH_TRAN_COUNT + $AUTH_TRAN_COUNT]
		
		catch {set x4 $arrallterm($MERCHANT_NUM)} result4
		#puts "*****$result4******"
		if {[string range $result4 0 9] == "can't read"} {
			set ALL_TERMINAL_COUNT 0
			
		} else {
			set ALL_TERMINAL_COUNT $arrallterm($MERCHANT_NUM)
			
			# puts " ALL_TERMINAL_COUNT for $MERCHANT_NUM is $arrallterm($MERCHANT_NUM) "
		}
		set SUB_ALL_TERMINAL_COUNT [expr $SUB_ALL_TERMINAL_COUNT + $ALL_TERMINAL_COUNT ]
		
		## commenting for now since this always gives  0
		set MERNAME  [string map {" " "-"} $MERCHANT_NAME ]
		set MERNAME  [string map {"." "-"} $MERNAME ]
		set MERCHANT_PAGE /clearing/filemgr/STATEMENTS/INST_447474/ARCHIVE/$MERCHANT_NUM-$short_month-$short_year.pdf
		set MERCHANT_PAGE_SEP /clearing/filemgr/STATEMENTS/INST_447474/ARCHIVE/$MERCHANT_NUM-$MERNAME-$short_month-$short_year.pdf
		if {[catch {set PAGE_NUM [exec grep Count $MERCHANT_PAGE]}]} {
			if {[catch {set PAGE_NUM [exec grep Count $MERCHANT_PAGE_SEP]}]} {
				puts "no statement available"
			} else {
				set PAGE_NUM [string range "[exec grep Count $MERCHANT_PAGE_SEP]" 7 7]
				#set SUB_PAGE_NUM [expr $SUB_PAGE_NUM + $PAGE_NUM]
			}
		} else {
			set PAGE_NUM [string range "[exec grep Count $MERCHANT_PAGE_SEP]" 7 7]
			
		}
		set SUB_PAGE_NUM [expr $SUB_PAGE_NUM + $PAGE_NUM]
		set CHARGE_PER_PAGE [expr $PAGE_NUM * $MERCHANT_PAGE_RATE ]
		

		catch {set syang107 $arramt($MERCHANT_NUM)}    result14
		catch {set syang107 $arrcpamt($MERCHANT_NUM)}  result15
		catch {set syang107 $arrcnpamt($MERCHANT_NUM)} result16
		catch {set syang107 $arrsetcnt($MERCHANT_NUM)} result17
		catch {set syang107 $arrcpcnt($MERCHANT_NUM)}  result18
		catch {set syang107 $arrcnpcnt($MERCHANT_NUM)} result19
		catch {set syang107 $arrchgcnt($MERCHANT_NUM)} result20
		catch {set syang107 $arrchgamt($MERCHANT_NUM)} result21
		catch {set syang107 $arrdischg($MERCHANT_NUM)}       result22
		catch {set syang107 $arrfraud($MERCHANT_NUM)}        result54
		catch {set syang107 $arrinchg($MERCHANT_NUM)}        result57
		catch {set syang107 $arrretrival($MERCHANT_NUM)}     result59
		catch {set syang107 $arrmcborfee($MERCHANT_NUM)}     result62
		catch {set syang107 $arrvsisafee($MERCHANT_NUM)}     result63
		catch {set syang107 $arrmcassess($MERCHANT_NUM)}     result64
		catch {set syang107 $arrvsassess($MERCHANT_NUM)}     result65
		catch {set syang107 $arrtermbilling($MERCHANT_NUM)}  resulttermbill

		catch {set syang107 $arrreturnamt($MERCHANT_NUM)}  resultreturnamt
		if {[string range $resultreturnamt 0 9] == "can't read"} {
			set  arrreturnamt($MERCHANT_NUM) 0
		}
		

		if {[string range $resulttermbill 0 9] == "can't read" } {
			set TERMINAL_BILLING 0
		} else {
			set TERMINAL_BILLING $arrtermbilling($MERCHANT_NUM)			
		}
		set SUB_TERMINAL_BILLING [ expr $SUB_TERMINAL_BILLING + $TERMINAL_BILLING]
		
		#puts "MC_BORDER_FEE"
		if {[string range $result62 0 9] == "can't read" } {
			set MC_BORDER_FEE 0
			# puts " $MERCHANT_NUM $result62 "
		} else {
			set MC_BORDER_FEE $arrmcborfee($MERCHANT_NUM)
		}
		set SUB_MC_BORDER_FEE [expr $SUB_MC_BORDER_FEE + $MC_BORDER_FEE]
		if {[string range $result63 0 9] == "can't read" } {
			set VS_ISA_FEE 0
			# puts " $MERCHANT_NUM $result63 "
		} else {
			set VS_ISA_FEE $arrvsisafee($MERCHANT_NUM)
		}
		set SUB_VS_ISA_FEE [expr $SUB_VS_ISA_FEE + $VS_ISA_FEE]
		if {[string range $result64 0 9] == "can't read" } {
			set MC_ASSESSMENT_AMT 0
			# puts " $MERCHANT_NUM $result64 "
		} else {
			set MC_ASSESSMENT_AMT $arrmcassess($MERCHANT_NUM)
		}
		set SUB_MC_ASSESSMENT_AMT [expr $SUB_MC_ASSESSMENT_AMT + $MC_ASSESSMENT_AMT]
		if {[string range $result64 0 9] == "can't read" } {
			set VS_ASSESSMENT_AMT 0
			# puts " $MERCHANT_NUM $result65 "
		} else {
			set VS_ASSESSMENT_AMT $arrvsassess($MERCHANT_NUM)
		}
		set SUB_VS_ASSESSMENT_AMT [expr $SUB_VS_ASSESSMENT_AMT + $VS_ASSESSMENT_AMT]
		if {[string range $result59 0 9] == "can't read"} {
			set RETRIVAL_COUNT 0
			#puts " 107 $MERCHANT_NUM $result14 "
		} else {
			set RETRIVAL_COUNT $arrretrival($MERCHANT_NUM)
		}
		set SUB_RETRIVAL_COUNT [expr $SUB_RETRIVAL_COUNT + $RETRIVAL_COUNT]
		if {[string range $result14 0 9] == "can't read"} {
			set AMOUNT 0
			#puts " 107 $MERCHANT_NUM $result14 "
		} else {
			set AMOUNT $arramt($MERCHANT_NUM)
		}
		set SUB_AMOUNT [expr $SUB_AMOUNT + $AMOUNT]

		puts "CARD_PRESENT_AMOUNT"
		if {[string range $result15 0 9] == "can't read"} {
			set CARD_PRESENT_AMOUNT 0
			#puts " 107 $MERCHANT_NUM $result15 "
		} else {
			set CARD_PRESENT_AMOUNT $arrcpamt($MERCHANT_NUM)
		}
		set SUB_CARD_PRESENT_AMOUNT [expr $SUB_CARD_PRESENT_AMOUNT + $CARD_PRESENT_AMOUNT]

		if { [string range $result16 0 9] == "can't read"} {
			set  CARD_NOT_PRESENT_AMOUNT 0
			#puts " 107 $MERCHANT_NUM $result16 "
		}  else {
			set CARD_NOT_PRESENT_AMOUNT $arrcnpamt($MERCHANT_NUM)
		}
		set SUB_CARD_NOT_PRESENT_AMOUNT [expr $SUB_CARD_NOT_PRESENT_AMOUNT + $CARD_NOT_PRESENT_AMOUNT]

		if { [string range $result17 0 9] == "can't read" } {
			set SETT_TRAN_COUNT 0
			#puts " 107 $MERCHANT_NUM $result17 "
		}  else {
			set SETT_TRAN_COUNT  $arrsetcnt($MERCHANT_NUM)
		}
		set SUB_SETT_TRAN_COUNT [expr  $SUB_SETT_TRAN_COUNT + $SETT_TRAN_COUNT]

		if { [string range $result18 0 9] == "can't read" } {
			set CP_TRAN_COUNT 0
			#puts " 107 $MERCHANT_NUM $result18 "
		} else {
			set CP_TRAN_COUNT $arrcpcnt($MERCHANT_NUM)
		}
		set SUB_CP_TRAN_COUNT [expr $SUB_CP_TRAN_COUNT + $CP_TRAN_COUNT]

		if { [string range $result19 0 9] == "can't read"} {
			set NP_TRAN_COUNT 0
			#puts " 107 $MERCHANT_NUM $result19 "
		}  else {
			set NP_TRAN_COUNT $arrcnpcnt($MERCHANT_NUM)
		}
		set SUB_NP_TRAN_COUNT [expr $SUB_NP_TRAN_COUNT + $NP_TRAN_COUNT]

		if { [string range $result20 0 9] == "can't read" } {
			set CHARGEBACK_CNT 0
			#puts " 107 $MERCHANT_NUM $result20"
		}  else {
			set  CHARGEBACK_CNT $arrchgcnt($MERCHANT_NUM)
		}
		set SUB_CHARGEBACK_CNT [expr $SUB_CHARGEBACK_CNT + $CHARGEBACK_CNT]

		if { [string range $result21 0 9] == "can't read" } {
			set CHARGEBACK_AMT 0
			#puts " 107 $MERCHANT_NUM $result21 "
		}  else {
			set CHARGEBACK_AMT $arrchgamt($MERCHANT_NUM)
		}
		set SUB_CHARGEBACK_AMT [expr $SUB_CHARGEBACK_AMT + $CHARGEBACK_AMT]

		puts "DISCOUNT_CHARGE"
		if {[string range $result22 0 9] == "can't read" } {
			set DISCOUNT_CHARGE 0
			#puts " 107 $MERCHANT_NUM $result22"
		}  else {
			set DISCOUNT_CHARGE $arrdischg($MERCHANT_NUM)
		}
		set SUB_DISCOUNT_CHARGE [expr $SUB_DISCOUNT_CHARGE + $DISCOUNT_CHARGE]

		if {[string range $result54 0 9] == "can't read"} {
			set FRAUD_COUNT 0
			#puts " $MERCHANT_NUM $result54 "
		} else {
			set FRAUD_COUNT $arrfraud($MERCHANT_NUM)
		}
		set SUB_FRAUD_COUNT [expr $SUB_FRAUD_COUNT + $FRAUD_COUNT]
		
		if {[string range $result57 0 9] == "can't read"} {
			set INTERCHANG_AMOUNT 0
			#puts " $MERCHANT_NUM $result57 "
		} else {
			set INTERCHANG_AMOUNT $arrinchg($MERCHANT_NUM)
		}
		set SUB_INTERCHANG_AMOUNT [expr $SUB_INTERCHANG_AMOUNT + $INTERCHANG_AMOUNT]

		catch {set syang $mrej($MERCHANT_NUM)} resultmrej
		catch {set syang $vrej($MERCHANT_NUM)} resultvrej
		if {[string range $resultmrej 0 9] == "can't read"} {
			set mrej($MERCHANT_NUM) 0
		}
		if {[string range $resultvrej 0 9] == "can't read"} {
			set vrej($MERCHANT_NUM) 0
		}
		puts "Writing line $MERCHANT_NUM, $MERCHANT_NAME, $AMOUNT,$arrreturnamt($MERCHANT_NUM), $vrej($MERCHANT_NUM), $mrej($MERCHANT_NUM), $CARD_PRESENT_AMOUNT, $CARD_NOT_PRESENT_AMOUNT, $ALL_TERMINAL_COUNT, $TERMINAL_COUNT,$TERMINAL_BILLING,$NON_BANK_COUNT,$SETT_TRAN_COUNT, $AUTH_TRAN_COUNT, $CP_TRAN_COUNT,$NP_TRAN_COUNT,$PAGE_NUM,$DIAL_TR_COUNT,$CHARGEBACK_CNT, $CHARGEBACK_AMT, $RETRIVAL_COUNT,$DISCOUNT_CHARGE,$INTERCHANG_AMOUNT,$MC_ASSESSMENT_AMT, $VS_ASSESSMENT_AMT, $MC_BORDER_FEE, $VS_ISA_FEE, , , , $FRAUD_COUNT"
		
		puts $cur_file "$MERCHANT_NUM,$MERCHANT_NAME,$AMOUNT,$arrreturnamt($MERCHANT_NUM),$vrej($MERCHANT_NUM),$mrej($MERCHANT_NUM),$CARD_PRESENT_AMOUNT,$CARD_NOT_PRESENT_AMOUNT,$ALL_TERMINAL_COUNT,$TERMINAL_COUNT,$TERMINAL_BILLING,$NON_BANK_COUNT,$SETT_TRAN_COUNT,$AUTH_TRAN_COUNT,$CP_TRAN_COUNT,$NP_TRAN_COUNT,$PAGE_NUM,$DIAL_TR_COUNT,$CHARGEBACK_CNT,$CHARGEBACK_AMT,$RETRIVAL_COUNT,$DISCOUNT_CHARGE,$INTERCHANG_AMOUNT,$MC_ASSESSMENT_AMT,$VS_ASSESSMENT_AMT,$MC_BORDER_FEE,$VS_ISA_FEE,,,,$FRAUD_COUNT\r"

		set MERCHANT_NUM              0
		set MERCHANT_NAME             0
		set AMOUNT                    0
		set CARD_PRESENT_AMOUNT       0
		set CARD_NOT_PRESENT_AMOUNT   0
		set TERMINAL_COUNT            0
		set NON_BANK_COUNT            0
		set SETT_TRAN_COUNT           0
		set AUTH_TRAN_COUNT           0
		set CP_TRAN_COUNT             0
		set NP_TRAN_COUNT             0
		set PAGE_NUM                  0
		set DIAL_TR_COUNT             0
		set RETRIVAL_COUNT            0
		set DISCOUNT_CHARGE           0
		set PASSTHROUGH_AMOUNT        0
		set PASSTHROUGH_MS            0
		set PASSTHROUGH_VS            0
		set ACH_RETURN                0
		set AUTH_VOLUM                0
		set SETT_VOLUME               0
		set DIAL_MONTHLY              0
		set FEE_PER_CONTRACT          0
		set CHARGE_PER_PAGE           0
		set DIAL_MONTHLY_MERCHANT     0
		
	}

	
	puts "writing subtotal line"
	puts $cur_file "                 "
	puts $cur_file "Subtotal for $ISO_ID"
	#puts $cur_file " $AMOUNT,$arrreturnamt($MERCHANT_NUM),$vrej($MERCHANT_NUM),$mrej($MERCHANT_NUM),$CARD_PRESENT_AMOUNT,$CARD_NOT_PRESENT_AMOUNT,$ALL_TERMINAL_COUNT,$TERMINAL_COUNT,$TERMINAL_BILLING,$NON_BANK_COUNT,$SETT_TRAN_COUNT, $AUTH_TRAN_COUNT,$CP_TRAN_COUNT,$NP_TRAN_COUNT,$PAGE_NUM,$DIAL_TR_COUNT,$CHARGEBACK_CNT, $CHARGEBACK_AMT,$RETRIVAL_COUNT,$DISCOUNT_CHARGE,$INTERCHANG_AMOUNT,$MC_ASSESSMENT_AMT,$VS_ASSESSMENT_AMT,$MC_BORDER_FEE,$VS_ISA_FEE,,,,$FRAUD_COUNT\r"
	#puts $cur_file " $SUB_AMOUNT,$SUB_RETURN_AMT,,,$SUB_CARD_PRESENT_AMOUNT,$SUB_CARD_NOT_PRESENT_AMOUNT,$SUB_ALL_TERMINAL_COUNT,$SUB_TERMINAL_COUNT,$SUB_TERMINAL_BILLING,$SUB_NON_BANK_COUNT,$SUB_SETT_TRAN_COUNT, $SUB_AUTH_TRAN_COUNT, $SUB_CP_TRAN_COUNT,$SUB_NP_TRAN_COUNT,$SUB_PAGE_NUM,$SUB_DIAL_TR_COUNT,$SUB_CHARGEBACK_CNT,$SUB_CHARGEBACK_AMT,$SUB_RETRIVAL_COUNT,$SUB_DISCOUNT_CHARGE,,,,,\r"
	puts $cur_file " **SUBTOTAL**:,,$SUB_AMOUNT,$SUB_RETURN_AMT,,,$SUB_CARD_PRESENT_AMOUNT,$SUB_CARD_NOT_PRESENT_AMOUNT,$SUB_ALL_TERMINAL_COUNT,$SUB_TERMINAL_COUNT,$SUB_TERMINAL_BILLING,$SUB_NON_BANK_COUNT,$SUB_SETT_TRAN_COUNT, $SUB_AUTH_TRAN_COUNT, $SUB_CP_TRAN_COUNT,$SUB_NP_TRAN_COUNT,$SUB_PAGE_NUM,$SUB_DIAL_TR_COUNT,$SUB_CHARGEBACK_CNT,$SUB_CHARGEBACK_AMT,$SUB_RETRIVAL_COUNT,$SUB_DISCOUNT_CHARGE,$SUB_INTERCHANG_AMOUNT,$SUB_MC_ASSESSMENT_AMT,$SUB_VS_ASSESSMENT_AMT,$SUB_MC_BORDER_FEE,$SUB_VS_ISA_FEE,,,,$SUB_FRAUD_COUNT\r"
	puts $cur_file "                 "

	set SUB_AMOUNT                     0
	set SUB_CARD_PRESENT_AMOUNT        0
	set SUB_CARD_NOT_PRESENT_AMOUNT    0
	set SUB_ALL_TERMINAL_COUNT         0
	set SUB_TERMINAL_COUNT             0
	set SUB_NON_BANK_COUNT             0
	set SUB_SETT_TRAN_COUNT            0
	set SUB_AUTH_TRAN_COUNT            0
	set SUB_CP_TRAN_COUNT              0
	set SUB_NP_TRAN_COUNT              0
	set SUB_PAGE_NUM                   0
	set SUB_DIAL_TR_COUNT              0
	set SUB_RETRIVAL_COUNT             0
	set SUB_DISCOUNT_CHARGE            0
	set SUB_INTERCHANG_AMOUNT			0
	set SUB_PASSTHROUGH_AMOUNT         0
	set SUB_PASSTHROUGH_MS             0
	set SUB_PASSTHROUGH_VS             0
	set SUB_ACH_RETURN                 0
	set SUB_AUTH_VOLUME                0
	set SUB_SETT_VOLUME                0
	set SUB_DIAL_MONTHLY               0
	#set SUB_FEE_PER_CONTRACT           0
	set SUB_CHARGE_PER_PAGE            0
	set SUB_DIAL_MONTHLY_MERCHANT      0
	set SUB_CHARGEBACK_CNT             0
	set SUB_CHARGEBACK_AMT             0
	set SUB_TERMINAL_BILLING          0
	set SUB_RETRIVAL_COUNT 0
	set SUB_VS_ASSESSMENT_AMT 0
	set SUB_MC_ASSESSMENT_AMT 0
	set SUB_VS_ISA_FEE 0
	set SUB_MC_BORDER_FEE 0
set SUB_FRAUD_COUNT				0
}

puts "out of ISO loop"

close $cur_file

exec mutt -a $cur_file_name -s $cur_file_name -- clearing-np@jetpay.com < /dev/null
oraclose $count_cursor1
oraclose $count_cursor2
oraclose $count_cursor3
oraclose $count_cursor4
oraclose $count_cursor5
oraclose $count_cursor6
oraclose $count_cursor7
oraclose $count_cursor8
oraclose $count_cursor9
oraclose $fetch_cursorM1
oraclose $fetch_cursorM2
oraclose $fetch_cursorM3
oraclose $cursorM1
oraclose $cursorM2
oraclose $cursorM3
oraclose $cursorM4
oraclose $cursorM5
oraclose $cursorM6
oraclose $cursorM7
oraclose $cursorM8
oraclose $cursorM9
oraclose $cursorM10

set end_time [clock seconds]
puts "started at [clock format $start_time] \nended at [clock format $end_time] "
