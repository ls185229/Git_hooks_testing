#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

#$Id: all-I-E.tcl 1701 2012-03-27 20:55:36Z ajohn $

## ******************           Modification History         *******************
#
# Version v3 Sunny Yang 31-MAR-2010
# -------- NOTE: this version ran for 2010 Mar report
#
# Version v3 Sunny yang 02-NOV-2009 (NOTE: this version ran for NOV report)
# -------- correct REFUND numbers by adding in 010123005101/02.
#
# Version g1.0 Sunny Yang 18-AUG-2009
# -------- base on merric-I-E.tcl-v2.06-v3 to make this version work for Discover
#
#  Version 2.06-v3 Sunny Yang 06-01-2009
#  ------- Add in arbitration TID (fee collection): 010003010101
#
# Version  2.06-v2  Sunny Yang 01-APR-2009
# -------- Added in 0100030052%
# -------- Needs to watch 0101230051% for next month
#
# Version 2.06 Sunny Yang 11-MAR-2009
# -------- Add in DB txn according to Merrick's sample file.
#
# Version 2.05 Sunny Yang 09-MAR-2009
# -------- Pull reject out after conference meeting with Merrick, as Reject should
# -------- not be counted twice and Merrick claimed that they do not match DD with
# -------- Header with IE.
#
#  Version 2.03 Sunny Yang 03-03-2009
#  ------- Add in arbitration TID (fee collection): 010003010102
#
#  Version 2.02 Sunny Yang 02-10-2009
#  ------- keep testing merchants everywhere so Merrick reports can be balanced out
#
#  version 2.01 Sunny Yang 10-02-2008
#  ------ Add reject as part of sales to match with Daily Detail report.
#
## Version 2.0 Sunny Yang 04-07-2008 
#  ------ rewrite completely to speed the whole thing up
#  ------ took out "01000802" and "01000801" for now according to Rifat's request
#  ------ Keep the related column name and set aside related part of query for 
#  -------    future request.
#  -------uncommented out counts for inactive merchants with modifications on
#  ------ ENTITY_TO_AUTH table.
#  ------ changes on ENTITY_TO_AUTH table includes adding status "A", adding 
#  ------ suspending time and final termination time
#  ------ combine all 3 parts (MC, VS, and count) back together
#
## Version before
## The purpose of report is to summarize counts and amounts for each card scheme,
## merchant for report month, quarter-to-date, year-to-date
## It started as one report and then broke into 3 parts due to running time
##

#  *******************                  USAGE                *******************          
#  -- without argument: report on all institutions for previous month
#  -- input date argument (format: yyyymmdd): report on period from first day 
#  --     of that month to the month end
#  -- input institution argument: report on THE inst for the previous month
#  -- input both specified date and insitution
#  -- option to key in correction if input format is wrong
#  ------ always stop at last of the month for MTD, QTD and YTD
#
#*******************************************************************************

#********************         Environment veriables         ********************

set clrdb $env(CLR4_DB)
#set clrdb trnclr4

####################################################################################################################

package require Oratcl
if {[catch {set handler [oralogon masclr/masclr@$clrdb]} result]} {
#  exec echo "IE report failed to run" | mailx -r $mailfromlist -s "merric-I-E.tcl" $mailtolist
  exit
}
puts $clrdb
#   ***** cursors ******

set ie_cursor  [oraopen $handler]

proc unoct {s} {
    set u [string trimleft $s 0]
    if {$u == ""} {
        return 0
    } else {
        return $u
    }
};# end unoct

proc get_quarter {dt} {
	set mnt [format %d [clock format [clock scan "$dt"] -format %m]]
}

proc init_dates {value} {
	#VALUE SHOULD BE A DATE IN THE MONTH WE ARE INTERESTED IN

	global year_date title_date report_date 
	global sql_begin_day begin_day sql_start_of_year sql_end_day
	global CUR_JULIAN_DATEX mmm_report_month long_report_year
	global RepQtr RepMon strt_of_qtr qtr_criteria qtr_fee_criteria
puts $value	
	set report_date "01-[clock format [clock scan $value] -format %b-%Y]"
	set year_date   [clock format [clock scan $value] -format %y ]	;# Year of given date
	set long_report_month   [string toupper [clock format [clock scan $report_date] -format %B]]	;# MARCH     as of 03-31-2008
	set long_report_year    [clock format [clock scan $report_date] -format %Y]						;# 2008      as of 03-31-2008
	set mmm_report_month	[string toupper [clock format [clock scan $report_date] -format %b]]		;# MAR       as of 03-31-2008
	set RepMon				[clock format [clock scan $report_date] -format %m]
	
	set sql_start_of_year [string toupper [clock format [clock scan "01-JAN-$long_report_year"] -format %d-%b-%Y]]
	
	set title_date	[clock format [clock scan $report_date ] -format %Y%m%d]						;# yyyymmdd
	
	# First day of the month after report_date
	set sql_end_day	[clock format [clock scan "$report_date +1 month"] -format %d-%b-%Y]			;# First of next month (use '<' in qry)
	
	set begin_day $report_date
	set tmp [clock format [clock scan "$report_date -1 day"] -format %d-%b-%Y]
	set sql_begin_day "to_date('$tmp 23:59:59', 'dd-mon-yyyy hh24:mi:ss')"
	
	set RepQtr	[expr int([expr ceil([format %.2f [unoct [clock format [clock scan "$report_date"] -format %m]]]/3.0)])]
	set strt_of_qtr	[clock format [clock scan "01[format %0.2d [expr (($RepQtr - 1) * 3) + 1]]$year_date" -format %d%m%y] -format %d-%b-%Y]
	set sql_start_of_qtr [clock format [clock scan "$strt_of_qtr -1 day"] -format %d-%b-%Y]
	
	set qtr_criteria 		"(gl_date > to_date( '$sql_start_of_qtr 23:59:59', 'dd-mon-yyyy hh24:mi:ss') and gl_date < '$sql_end_day')"
	set qtr_fee_criteria	"(date_to_settle > to_date( '$sql_start_of_qtr 23:59:59', 'dd-mon-yyyy hh24:mi:ss') and date_to_settle < '$sql_end_day')"
	
	puts "year:\t\t\t$year_date"
	puts "report date:\t\t$report_date"
	puts "title date:\t\t$title_date"
	puts "SQL End day:\t\t$sql_end_day"
	puts "SQL Begin day:\t\t$sql_begin_day"
	puts "SQL start of year:\t$sql_start_of_year"
	puts "RepQtr:\t\t$RepQtr"
	puts "Start of Qtr:\t\t$strt_of_qtr"
          
	set CUR_SET_TIME        [clock seconds ]
	set CUR_JULIAN_DATEX    [string range [clock format $CUR_SET_TIME -format "%y%j"] 1 4]
	puts "*** Running today's reports: $report_date ***"
}

set institution_id "ALL"

# ***********************************************************
# ******* Report on current date and all institutions *******
# ***********************************************************
if { $argc == 0 } {      
      init_dates [clock format [clock scan "-1 month"] -format %d-%b-%Y]

} elseif { $argc == 1 } {
      
	set input [string trim [lindex $argv 0]]
	
	if { [string length $input ] == 3 } {
	
		#Report on selected institution
		set institution_id [string trim [lindex $argv 0]]
		init_dates [clock format [clock scan "-1 month"] -format %d-%b-%Y]
		
	} elseif { [string length $input ] == 8 } {
	
		#Report on selected date
		init_dates [clock format [clock scan $input -format %Y%m%d] -format %d-%b-%Y]

	} else {
		puts " this is wrong input, start over please! "
		exit 1
	}
 
#     *********  Report on selected date and institution  *********      
} elseif { $argc == 2 } {
	set institution_id [string trim [lindex $argv 0]]
	if { [string length $institution_id ] != 3 } {
		puts "INSTITUTION ID SHOULD BE 3 DIGITS: "
		set institution_id [gets stdin]
	}
	
	set dt [lindex $argv 1]
	if { [string length $dt ] != 8 } {
		puts "REPORT DATE SHOULD BE 8 DIGITS: (format like 20080401 ) "
		set dt [gets stdin]
	}
	
	init_dates [clock format [clock scan $dt -format %Y%m%d] -format %d-%b-%Y]
	
} else {
      puts " figure out what you want and start over...bye!"
      exit 0          
}

puts ">>>>>>>>>>>>>>>>>>>>>CHECK 010123005101 AND 010123005101<<<<<<<<<<<<<<<<"

puts "******* DONOT FORGET TO CHECK MERCHANT COUNTS !!!! ********"
puts "   "
puts "$mmm_report_month $long_report_year"  
puts " month: (gl_date >= '$begin_day' and gl_date < '$sql_end_day')"
puts " Quarter: $qtr_criteria.....$qtr_fee_criteria "
puts " year: (gl_date >= '$sql_start_of_year' and gl_date < '$sql_end_day') "

proc IE_report { institution_num } {
      
	global   ie_cursor
	global  last_day year_date title_date report_date sql_end_day sql_begin_day qtr_criteria qtr_fee_criteria
	global  quarter_start long_report_month long_report_year short_report_month short_report_year sql_start_of_year
	global  CUR_JULIAN_DATEX report_date RepQtr RepMon
	global  cur_file_name file_name cur_file   
      
	set Month_Discount_Count 0
	set Quarter_Discount_Count 0
	set Year_Discount_Count 0

#            ****** SECTION_HEADER ******
#            ****************************

	set query_mer_cnt1 "select sum(cnt) as ACTIVE_MER from
							(select unique mtl.entity_id, 1 cnt
							from mas_trans_log mtl, entity_to_auth eta
							where mtl.entity_id = eta.entity_id
							and eta.status = 'A'
							and gl_date > $sql_begin_day and gl_date < '$sql_end_day'
							and mtl.institution_id in ($institution_num))";


	orasql $ie_cursor $query_mer_cnt1
	if {[orafetch $ie_cursor -dataarray mercnt -indexbyname] != 1403} {
		set Live_Count    $mercnt(ACTIVE_MER)
		#set Dead_Count    $mercnt(INACTIVE_MER)
	}
	
	puts "live count: $Live_Count" 
	#puts  $query_mer_cnt1


	#!!!!WE HAVE TO DISCUSS THIS QUERY.. ITS A SURE TABLE SCAN!!!!
	
	#set query_mer_cnt2 "select  count(unique entity_id) as INACTIVE_MER
	#			from mas_trans_log
	#			where gl_date not like '%$short_report_month-$short_report_year'
	#			and institution_id in ($institution_num)
	#			and entity_id in (select entity_id from entity_to_auth where status  = 'S')"
	
	set query_mer_cnt2 "select sum(cnt) as INACTIVE_MER from
							(select unique mtl.entity_id, 1 cnt
							from mas_trans_log mtl, entity_to_auth eta
							where mtl.entity_id = eta.entity_id
							and eta.status = 'S'
							and gl_date > $sql_begin_day and gl_date < '$sql_end_day'
							and mtl.institution_id in ($institution_num))";
							          
          orasql $ie_cursor $query_mer_cnt2
          while {[orafetch $ie_cursor -dataarray mercnt2 -indexbyname] != 1403} {
               set Dead_Count    $mercnt2(INACTIVE_MER)
          }   
          puts "Dead count: $Dead_Count"
          
	puts $cur_file "Monthly Processor Income & Expense Report\r"
	puts $cur_file "$report_date\r"
	puts $cur_file "ALL PLAN TYPES,MTD,,QTD,,YTD "
	puts $cur_file "ACTIVE MERCHANTS, $Live_Count "
	puts $cur_file "INACTIVE MERCHANTS, $Dead_Count "
	puts $cur_file "TOTAL MERCHANTS, [expr $Dead_Count + $Live_Count],,,,"

	set Month_Count 1
	set Quarter_Count 1
	set Year_Count 1
      
    #initialize variables
    # M: Month, Q: Quarter-to-date, Y: Year-to-date
    
    foreach cat { "" ALL_ VS_ VSCON_ VSDEB_ VSBUS_ MC_ MCCON_ MCDEB_ MCBUS_ DSC_ DSCCON_ DSCDEB_ DSCBUS_ DB_} {
    	foreach period {M Q Y} {
    		set Chargeback_Volume(${cat}${period}) 		0
			set Chargeback_Count(${cat}${period}) 		0
			set Representment_Volume(${cat}${period}) 	0
			set Representment_Count(${cat}${period}) 	0	
			set Discount_Volume(${cat}${period}) 		0
			set Discount_Count(${cat}${period}) 		0
			set Expense_Volume(${cat}${period}) 		0	
			set Volume(${cat}${period}) 				0
			set Count(${cat}${period}) 					0
			set Refund_Volume(${cat}${period}) 			0
			set Refund_Count(${cat}${period}) 			0
			set Minimum_Volume(${cat}${period}) 		0
			set Minimum_Count(${cat}${period}) 			0
			set Interchange_Volume(${cat}${period}) 	0
			set Interchange_Count(${cat}${period}) 		0
			set Income_Volume(${cat}${period}) 			0
			set Income_Count(${cat}${period}) 			0

			set Sales_Adj_Volume(${cat}${period})		0	
			set Sales_Adj_Count(${cat}${period})		0	
			set Credit_Adj_Volume(${cat}${period})		0
			set Credit_Adj_Count(${cat}${period})		0
    	}
    }
		
	set Merchant_Count 0

	set Discount_Count(M) 1
	set Discount_Count(Q) 1
	set Discount_Count(Y) 1

	#           <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~QUERY DEFINITIONS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
	set IS_SALES		"(tid in ('010123005101','010123005102') or substr(TID, 1, 10) in ('0100030051','0100030052')) and tid_settl_method = 'C'"
	set IS_REFUND		"(tid in ('010123005101','010123005102') or substr(TID, 1, 10) in ('0100030051','0100030052')) and tid_settl_method = 'D'"
	set IS_CHRG_BK	"tid in ('010003015201','010003015102','010003015101','010003015210','010003015301')"
	set IS_REPR		"tid in ('010003005301','010003005401','010003010102','010003010101')"
	
	set IS_MAS_CONSUMER	"mas_code in (select mas_code from mas_code where IRF_PROG_IND_DESC = 'CONSUMER')"
	set IS_MAS_DEBIT		"mas_code in (select mas_code from mas_code where IRF_PROG_IND_DESC = 'DEBIT')"
	set IS_MAS_BUSINESS	"mas_code in (select mas_code from mas_code where IRF_PROG_IND_DESC = 'BUSINESS')"
	#           <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
      
	set query_string_m "select TO_CHAR( gl_date, 'MM') mnth, TO_CHAR( gl_date, 'Q') qtr,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method = 'C' and CARD_SCHEME in ('04','05','02','08')) then AMT_ORIGINAL else 0 end) as ALL_CHARGBACK_C,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method <> 'C' and CARD_SCHEME in ('04','05','02','08')) then AMT_ORIGINAL else 0 end) as ALL_CHARGBACK_D,
	sum(CASE WHEN( $IS_CHRG_BK and CARD_SCHEME in ('04','05','02','08')) then 1 else 0 end) as ALL_CHARGBACK_CNT,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method = 'C' and CARD_SCHEME = '04') then AMT_ORIGINAL else 0 end) as VS_CHARGBACK_C,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method <> 'C' and CARD_SCHEME = '04') then AMT_ORIGINAL else 0 end) as VS_CHARGBACK_D,
	sum(CASE WHEN( $IS_CHRG_BK and CARD_SCHEME = '04') then 1 else 0 end) as VS_CHARGBACK_CNT,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method = 'C' and CARD_SCHEME = '02') then AMT_ORIGINAL else 0 end) as DB_CHARGBACK_C,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method <> 'C' and CARD_SCHEME = '02') then AMT_ORIGINAL else 0 end) as DB_CHARGBACK_D,
	sum(CASE WHEN( $IS_CHRG_BK and CARD_SCHEME = '02') then 1 else 0 end) as DB_CHARGBACK_CNT,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method = 'C' and CARD_SCHEME ='05') then AMT_ORIGINAL else 0 end) as MC_CHARGBACK_C,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method <> 'C' and CARD_SCHEME ='05') then AMT_ORIGINAL else 0 end) as MC_CHARGBACK_D,
	sum(CASE WHEN( $IS_CHRG_BK and CARD_SCHEME = '05') then 1 else 0 end) as MC_CHARGBACK_CNT,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method = 'C' and CARD_SCHEME = '08') then AMT_ORIGINAL else 0 end) as DSC_CHARGBACK_C,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method <> 'C' and CARD_SCHEME = '08') then AMT_ORIGINAL else 0 end) as DSC_CHARGBACK_D,
	sum(CASE WHEN( $IS_CHRG_BK and CARD_SCHEME = '08') then 1 else 0 end) as DSC_CHARGBACK_CNT,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method = 'C' and CARD_SCHEME = '04' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as VSCON_CHARGBACK_C,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method <> 'C' and CARD_SCHEME = '04' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as VSCON_CHARGBACK_D,
	sum(CASE WHEN( $IS_CHRG_BK and CARD_SCHEME in ('04') and $IS_MAS_CONSUMER) then 1 else 0 end) as VSCON_CHARGBACK_CNT,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method = 'C' and CARD_SCHEME = '04' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as VSDEB_CHARGBACK_C,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method <> 'C' and CARD_SCHEME = '04' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as VSDEB_CHARGBACK_D,
	sum(CASE WHEN( $IS_CHRG_BK and CARD_SCHEME = '04' and $IS_MAS_DEBIT) then 1 else 0 end) as VSDEB_CHARGBACK_CNT,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method = 'C' and CARD_SCHEME = '04' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as VSBUS_CHARGBACK_C,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method <> 'C' and CARD_SCHEME = '04' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as VSBUS_CHARGBACK_D,
	sum(CASE WHEN( $IS_CHRG_BK and CARD_SCHEME = '04' and $IS_MAS_BUSINESS) then 1 else 0 end) as VSBUS_CHARGBACK_CNT,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method = 'C' and CARD_SCHEME in ('05') and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as MCCON_CHARGBACK_C,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method <> 'C' and CARD_SCHEME in ('05') and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as MCCON_CHARGBACK_D,
	sum(CASE WHEN( $IS_CHRG_BK and CARD_SCHEME in ('05') and $IS_MAS_CONSUMER) then 1 else 0 end) as MCCON_CHARGBACK_CNT,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method = 'C' and CARD_SCHEME ='05' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as MCDEB_CHARGBACK_C,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method <> 'C' and CARD_SCHEME ='05' and $IS_MAS_DEBIT ) then AMT_ORIGINAL else 0 end) as MCDEB_CHARGBACK_D,
	sum(CASE WHEN( $IS_CHRG_BK and CARD_SCHEME = '05' and $IS_MAS_DEBIT) then 1 else 0 end) as MCDEB_CHARGBACK_CNT,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method = 'C' and CARD_SCHEME ='05' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as MCBUS_CHARGBACK_C,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method <> 'C' and CARD_SCHEME ='05' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as MCBUS_CHARGBACK_D,
	sum(CASE WHEN( $IS_CHRG_BK and CARD_SCHEME = '05' and $IS_MAS_BUSINESS) then 1 else 0 end) as MCBUS_CHARGBACK_CNT,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method = 'C' and CARD_SCHEME = '08' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as DSCCON_CHARGBACK_C,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method <> 'C' and CARD_SCHEME = '08' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as DSCCON_CHARGBACK_D,
	sum(CASE WHEN( $IS_CHRG_BK and CARD_SCHEME in ('08') and $IS_MAS_CONSUMER) then 1 else 0 end) as DSCCON_CHARGBACK_CNT,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method = 'C' and CARD_SCHEME = '08' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as DSCDEB_CHARGBACK_C,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method <> 'C' and CARD_SCHEME = '08' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as DSCDEB_CHARGBACK_D,
	sum(CASE WHEN( $IS_CHRG_BK and CARD_SCHEME = '08' and $IS_MAS_DEBIT) then 1 else 0 end) as DSCDEB_CHARGBACK_CNT,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method = 'C' and CARD_SCHEME = '08' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as DSCBUS_CHARGBACK_C,
	sum(CASE WHEN( $IS_CHRG_BK and tid_settl_method <> 'C' and CARD_SCHEME = '08' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as DSCBUS_CHARGBACK_D,
	sum(CASE WHEN( $IS_CHRG_BK and CARD_SCHEME = '08' and $IS_MAS_BUSINESS) then 1 else 0 end) as DSCBUS_CHARGBACK_CNT,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME in ('04','05','02','08')) then AMT_ORIGINAL else 0 end) as ALL_SALES_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME in ('04','05','02','08')) then 1 else 0 end) as ALL_SALES_CNT_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME = '04') then AMT_ORIGINAL else 0 end) as VS_SALES_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME = '04') then 1 else 0 end) as VS_SALES_CNT_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME in ('05')) then AMT_ORIGINAL else 0 end) as MC_SALES_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME in ('05')) then 1 else 0 end) as MC_SALES_CNT_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME = '08') then AMT_ORIGINAL else 0 end) as DSC_SALES_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME = '08') then 1 else 0 end) as DSC_SALES_CNT_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME in ('02')) then AMT_ORIGINAL else 0 end) as DB_SALES_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME in ('02')) then 1 else 0 end) as DB_SALES_CNT_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME = '04' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as VSCON_SALES_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME = '04' and $IS_MAS_CONSUMER) then 1 else 0 end) as  VSCON_SALES_CNT_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME = '04' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as VSDEB_SALES_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME = '04' and $IS_MAS_DEBIT) then 1 else 0 end) as VSDEB_SALES_CNT_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME = '04' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as VSBUS_SALES_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME = '04' and $IS_MAS_BUSINESS) then 1 else 0 end) as VSBUS_SALES_CNT_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME in ('05') and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as MCCON_SALES_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME in ('05') and $IS_MAS_CONSUMER) then 1 else 0 end) as MCCON_SALES_CNT_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME in ('05') and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as MCDEB_SALES_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME in ('05')and $IS_MAS_DEBIT) then 1 else 0 end) as MCDEB_SALES_CNT_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME in ('05') and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as MCBUS_SALES_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME in ('05') and $IS_MAS_BUSINESS) then 1 else 0 end) as MCBUS_SALES_CNT_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME = '08' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as DSCCON_SALES_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME = '08' and $IS_MAS_CONSUMER) then 1 else 0 end) as  DSCCON_SALES_CNT_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME = '08' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as DSCDEB_SALES_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME = '08' and $IS_MAS_DEBIT) then 1 else 0 end) as DSCDEB_SALES_CNT_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME = '08' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as DSCBUS_SALES_C,
	sum(CASE WHEN( $IS_SALES and CARD_SCHEME = '08' and $IS_MAS_BUSINESS) then 1 else 0 end) as DSCBUS_SALES_CNT_C,
	sum(CASE WHEN( $IS_REPR and tid_settl_method = 'C' and CARD_SCHEME in ('04','05','02','08')) then AMT_ORIGINAL else 0 end) as ALL_REP_C,
	sum(CASE WHEN( $IS_REPR and tid_settl_method <> 'C' and CARD_SCHEME in ('04','05','02','08')) then AMT_ORIGINAL else 0 end) as ALL_REP_D,
	sum(CASE WHEN( $IS_REPR and CARD_SCHEME in ('04','05','02','08')) then 1 else 0 end) as ALL_REP_CNT,
	sum(CASE WHEN( $IS_REPR and tid_settl_method = 'C' and CARD_SCHEME = '04') then AMT_ORIGINAL else 0 end) as VS_REP_C,
	sum(CASE WHEN( $IS_REPR and tid_settl_method <> 'C' and CARD_SCHEME = '04') then AMT_ORIGINAL else 0 end) as VS_REP_D,
	sum(CASE WHEN( $IS_REPR and CARD_SCHEME = '04') then 1 else 0 end) as VS_REP_CNT,
	sum(CASE WHEN( $IS_REPR and tid_settl_method = 'C' and CARD_SCHEME = '05') then AMT_ORIGINAL else 0 end) as MC_REP_C,
	sum(CASE WHEN( $IS_REPR and tid_settl_method <> 'C' and CARD_SCHEME = '05') then AMT_ORIGINAL else 0 end) as MC_REP_D,
	sum(CASE WHEN( $IS_REPR and CARD_SCHEME = '05') then 1 else 0 end) as MC_REP_CNT,
	sum(CASE WHEN( $IS_REPR and tid_settl_method = 'C' and CARD_SCHEME = '08') then AMT_ORIGINAL else 0 end) as DSC_REP_C,
	sum(CASE WHEN( $IS_REPR and tid_settl_method <> 'C' and CARD_SCHEME = '08') then AMT_ORIGINAL else 0 end) as DSC_REP_D,
	sum(CASE WHEN( $IS_REPR and CARD_SCHEME = '08') then 1 else 0 end) as DSC_REP_CNT,
	sum(CASE WHEN( $IS_REPR and tid_settl_method = 'C' and CARD_SCHEME = '02') then AMT_ORIGINAL else 0 end) as DB_REP_C,
	sum(CASE WHEN( $IS_REPR and tid_settl_method <> 'C' and CARD_SCHEME = '02') then AMT_ORIGINAL else 0 end) as DB_REP_D,
	sum(CASE WHEN( $IS_REPR and CARD_SCHEME ='02') then 1 else 0 end) as DB_REP_CNT,
	sum(CASE WHEN( $IS_REPR and tid_settl_method = 'C' and CARD_SCHEME = '04' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as VSCON_REP_C,
	sum(CASE WHEN( $IS_REPR and tid_settl_method <> 'C' and CARD_SCHEME = '04' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as VSCON_REP_D,
	sum(CASE WHEN( $IS_REPR and CARD_SCHEME = '04' and $IS_MAS_CONSUMER) then 1 else 0 end) as VSCON_REP_CNT,
	sum(CASE WHEN( $IS_REPR and tid_settl_method = 'C' and CARD_SCHEME = '04' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as VSDEB_REP_C,
	sum(CASE WHEN( $IS_REPR and tid_settl_method <> 'C' and CARD_SCHEME = '04' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as VSDEB_REP_D,
	sum(CASE WHEN( $IS_REPR and CARD_SCHEME = '04' and $IS_MAS_DEBIT) then 1 else 0 end) as VSDEB_REP_CNT,
	sum(CASE WHEN( $IS_REPR and tid_settl_method = 'C' and CARD_SCHEME = '04' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as VSBUS_REP_C,
	sum(CASE WHEN( $IS_REPR and tid_settl_method <> 'C' and CARD_SCHEME = '04' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as VSBUS_REP_D,
	sum(CASE WHEN( $IS_REPR and CARD_SCHEME = '04' and $IS_MAS_BUSINESS) then 1 else 0 end) as VSBUS_REP_CNT,
	sum(CASE WHEN( $IS_REPR and tid_settl_method = 'C' and CARD_SCHEME = '05' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as MCBUS_REP_C,
	sum(CASE WHEN( $IS_REPR and tid_settl_method <> 'C' and CARD_SCHEME = '05' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as MCBUS_REP_D,
	sum(CASE WHEN( $IS_REPR and CARD_SCHEME = '05' and $IS_MAS_BUSINESS) then 1 else 0 end) as MCBUS_REP_CNT,
	sum(CASE WHEN( $IS_REPR and tid_settl_method = 'C' and CARD_SCHEME = '05' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as MCDEB_REP_C,
	sum(CASE WHEN( $IS_REPR and tid_settl_method <> 'C' and CARD_SCHEME = '05' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as MCDEB_REP_D,
	sum(CASE WHEN( $IS_REPR and CARD_SCHEME = '05' and $IS_MAS_DEBIT) then 1 else 0 end) as MCDEB_REP_CNT,
	sum(CASE WHEN( $IS_REPR and tid_settl_method = 'C' and CARD_SCHEME = '05' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as MCCON_REP_C,
	sum(CASE WHEN( $IS_REPR and tid_settl_method <> 'C' and CARD_SCHEME = '05' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as MCCON_REP_D,
	sum(CASE WHEN( $IS_REPR and CARD_SCHEME = '05' and $IS_MAS_CONSUMER) then 1 else 0 end) as MCCON_REP_CNT,
	sum(CASE WHEN( $IS_REPR and tid_settl_method = 'C' and CARD_SCHEME = '08' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as DSCCON_REP_C,
	sum(CASE WHEN( $IS_REPR and tid_settl_method <> 'C' and CARD_SCHEME = '08' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as DSCCON_REP_D,
	sum(CASE WHEN( $IS_REPR and CARD_SCHEME = '08' and $IS_MAS_CONSUMER) then 1 else 0 end) as DSCCON_REP_CNT,
	sum(CASE WHEN( $IS_REPR and tid_settl_method = 'C' and CARD_SCHEME = '08' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as DSCDEB_REP_C,
	sum(CASE WHEN( $IS_REPR and tid_settl_method <> 'C' and CARD_SCHEME = '08' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as DSCDEB_REP_D,
	sum(CASE WHEN( $IS_REPR and CARD_SCHEME = '08' and $IS_MAS_DEBIT) then 1 else 0 end) as DSCDEB_REP_CNT,
	sum(CASE WHEN( $IS_REPR and tid_settl_method = 'C' and CARD_SCHEME = '08' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as DSCBUS_REP_C,
	sum(CASE WHEN( $IS_REPR and tid_settl_method <> 'C' and CARD_SCHEME = '08' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as DSCBUS_REP_D,
	sum(CASE WHEN( $IS_REPR and CARD_SCHEME = '08' and $IS_MAS_BUSINESS) then 1 else 0 end) as DSCBUS_REP_CNT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME in ('04','05','02','08')) then AMT_ORIGINAL else 0 end) as ALL_REFUND_AMT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME in ('04','05','02','08')) then 1 else 0 end) as ALL_REFUND_CNT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME in ('04')) then AMT_ORIGINAL else 0 end) as VS_REFUND_AMT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME in ('04')) then 1 else 0 end) as VS_REFUND_CNT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME in ('05')) then AMT_ORIGINAL else 0 end) as MC_REFUND_AMT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME in ('05')) then 1 else 0 end) as MC_REFUND_CNT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME in ('08')) then AMT_ORIGINAL else 0 end) as DSC_REFUND_AMT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME in ('08')) then 1 else 0 end) as DSC_REFUND_CNT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME in ('02')) then AMT_ORIGINAL else 0 end) as DB_REFUND_AMT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME in ('02')) then 1 else 0 end) as DB_REFUND_CNT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME = '04' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as VSCON_REFUND_AMT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME = '04' and $IS_MAS_CONSUMER) then 1 else 0 end) as VSCON_REFUND_CNT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME = '04' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as VSDEB_REFUND_AMT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME = '04' and $IS_MAS_DEBIT) then 1 else 0 end) as VSDEB_REFUND_CNT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME = '04' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as VSBUS_REFUND_AMT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME = '04' and $IS_MAS_BUSINESS) then 1 else 0 end) as VSBUS_REFUND_CNT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME = '05' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as MCCON_REFUND_AMT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME = '05' and $IS_MAS_CONSUMER) then 1 else 0 end) as MCCON_REFUND_CNT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME = '05' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as MCDEB_REFUND_AMT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME = '05' and $IS_MAS_DEBIT) then 1 else 0 end) as MCDEB_REFUND_CNT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME = '05' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as MCBUS_REFUND_AMT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME = '05' and $IS_MAS_BUSINESS) then 1 else 0 end) as MCBUS_REFUND_CNT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME = '08' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as DSCCON_REFUND_AMT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME = '08' and $IS_MAS_CONSUMER) then 1 else 0 end) as DSCCON_REFUND_CNT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME = '08' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as DSCDEB_REFUND_AMT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME = '08' and $IS_MAS_DEBIT) then 1 else 0 end) as DSCDEB_REFUND_CNT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME = '08' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as DSCBUS_REFUND_AMT,
	sum(CASE WHEN( $IS_REFUND and CARD_SCHEME = '08' and $IS_MAS_BUSINESS) then 1 else 0 end) as DSCBUS_REFUND_CNT
                         from mas_trans_log
                         where  institution_id in ($institution_num) 
                         AND (gl_date >= '$sql_start_of_year' and gl_date < '$sql_end_day')
                         GROUP BY TO_CHAR( gl_date, 'MM'), TO_CHAR( gl_date, 'Q')"
                        #puts $query_string_m
	orasql $ie_cursor $query_string_m
	while {[orafetch $ie_cursor -dataarray rec -indexbyname] != 1403} {
	
		if { $rec(MNTH) == $RepMon } {
			foreach cat {ALL VS VSCON VSDEB VSBUS MC MCCON MCDEB MCBUS DSC DSCCON DSCDEB DSCBUS DB} {
				set Chargeback_Volume(${cat}_M)    [expr $rec(${cat}_CHARGBACK_C) - $rec(${cat}_CHARGBACK_D)]
				set Chargeback_Count(${cat}_M)     $rec(${cat}_CHARGBACK_CNT)
				set Volume(${cat}_M)               $rec(${cat}_SALES_C)
				set Count(${cat}_M)                $rec(${cat}_SALES_CNT_C)
				set Representment_Volume(${cat}_M) [expr $rec(${cat}_REP_C) - $rec(${cat}_REP_D)]
				set Representment_Count(${cat}_M)  $rec(${cat}_REP_CNT)
				set Refund_Volume(${cat}_M)        $rec(${cat}_REFUND_AMT)
				set Refund_Count(${cat}_M)         $rec(${cat}_REFUND_CNT)
			}
		}
		
		if { $rec(QTR) == $RepQtr } {
			foreach cat {ALL VS VSCON VSDEB VSBUS MC MCCON MCDEB MCBUS DSC DSCCON DSCDEB DSCBUS DB} {
				set Chargeback_Volume(${cat}_Q)		[expr $Chargeback_Volume(${cat}_Q) + ( $rec(${cat}_CHARGBACK_C) - $rec(${cat}_CHARGBACK_D))]
				set Chargeback_Count(${cat}_Q)		[expr $Chargeback_Count(${cat}_Q) + $rec(${cat}_CHARGBACK_CNT)]
				set Volume(${cat}_Q)				[expr $Volume(${cat}_Q) + $rec(${cat}_SALES_C)]
				set Count(${cat}_Q)					[expr $Count(${cat}_Q) + $rec(${cat}_SALES_CNT_C)]
				set Representment_Volume(${cat}_Q)	[expr $Representment_Volume(${cat}_Q) + ( $rec(${cat}_REP_C) - $rec(${cat}_REP_D))]
				set Representment_Count(${cat}_Q)	[expr $Representment_Count(${cat}_Q) + $rec(${cat}_REP_CNT)]
				set Refund_Volume(${cat}_Q)			[expr $Refund_Volume(${cat}_Q) + $rec(${cat}_REFUND_AMT)]
				set Refund_Count(${cat}_Q)			[expr $Refund_Count(${cat}_Q) + $rec(${cat}_REFUND_CNT)]
			}
		}
		
		foreach cat {ALL VS VSCON VSDEB VSBUS MC MCCON MCDEB MCBUS DSC DSCCON DSCDEB DSCBUS DB} {
			set Chargeback_Volume(${cat}_Y)    [expr $Chargeback_Volume(${cat}_Y) + ( $rec(${cat}_CHARGBACK_C) - $rec(${cat}_CHARGBACK_D) )]
			set Chargeback_Count(${cat}_Y)     [expr $Chargeback_Count(${cat}_Y) + $rec(${cat}_CHARGBACK_CNT)]
			
			if {${cat}=="ALL"} {puts "ALL_SALES_Y: $rec(${cat}_SALES_C)"}
			
			set Volume(${cat}_Y)               [expr $Volume(${cat}_Y) + $rec(${cat}_SALES_C)]
			set Count(${cat}_Y)                [expr $Count(${cat}_Y) + $rec(${cat}_SALES_CNT_C)]
			set Representment_Volume(${cat}_Y) [expr $Representment_Volume(${cat}_Y) + ( $rec(${cat}_REP_C) - $rec(${cat}_REP_D) )]
			set Representment_Count(${cat}_Y)  [expr $Representment_Count(${cat}_Y) + $rec(${cat}_REP_CNT)]
			set Refund_Volume(${cat}_Y)        [expr $Refund_Volume(${cat}_Y) + $rec(${cat}_REFUND_AMT)]
			set Refund_Count(${cat}_Y)         [expr $Refund_Count(${cat}_Y) + $rec(${cat}_REFUND_CNT)]
		}		                 
	}
	
	set IS_DISCOUNT 	"( substr(TID, 1, 6) = '010004' or substr(TID, 1, 8) = '01000507')"
	set IS_INTERCHANGE 	"tid in ('010004020000','010004020005')"
                        
	set query_string_m2 "SELECT TO_CHAR( date_to_settle, 'MM') mnth, TO_CHAR( date_to_settle, 'Q') qtr,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method = 'C' and CARD_SCHEME in ('04','05','02','08')) then AMT_ORIGINAL else 0 end) as ALL_DISCOUNT_C,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method <> 'C' and CARD_SCHEME in ('04','05','02','08')) then AMT_ORIGINAL else 0 end) as ALL_DISCOUNT_D,
	sum(CASE WHEN($IS_DISCOUNT and CARD_SCHEME in ('04','05','02','08')) then 1 else 0 end) as ALL_DISCOUNT_CNT,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method = 'C' and CARD_SCHEME in ('04')) then AMT_ORIGINAL else 0 end) as VS_DISCOUNT_C,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method <> 'C' and CARD_SCHEME in ('04')) then AMT_ORIGINAL else 0 end) as VS_DISCOUNT_D,
	sum(CASE WHEN($IS_DISCOUNT and CARD_SCHEME in ('04')) then 1 else 0 end) as VS_DISCOUNT_CNT,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method = 'C'  and CARD_SCHEME in ('05') ) then AMT_ORIGINAL else 0 end) as MC_DISCOUNT_C,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method <> 'C'  and CARD_SCHEME in ('05')) then AMT_ORIGINAL else 0 end) as MC_DISCOUNT_D,
	sum(CASE WHEN($IS_DISCOUNT and CARD_SCHEME in ('05')) then 1 else 0 end) as MC_DISCOUNT_CNT,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method = 'C' and CARD_SCHEME in ('08')) then AMT_ORIGINAL else 0 end) as DSC_DISCOUNT_C,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method <> 'C' and CARD_SCHEME in ('08')) then AMT_ORIGINAL else 0 end) as DSC_DISCOUNT_D,
	sum(CASE WHEN($IS_DISCOUNT and CARD_SCHEME in ('08')) then 1 else 0 end) as DSC_DISCOUNT_CNT,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method = 'C'  and CARD_SCHEME in ('02') ) then AMT_ORIGINAL else 0 end) as DB_DISCOUNT_C,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method <> 'C'  and CARD_SCHEME in ('02')) then AMT_ORIGINAL else 0 end) as DB_DISCOUNT_D,
	sum(CASE WHEN($IS_DISCOUNT and CARD_SCHEME in ('02')) then 1 else 0 end) as DB_DISCOUNT_CNT,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method = 'C' and CARD_SCHEME = '04' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as VSCON_DISCOUNT_C,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method <> 'C' and CARD_SCHEME = '04' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as VSCON_DISCOUNT_D,
	sum(CASE WHEN($IS_DISCOUNT and CARD_SCHEME = '04' and $IS_MAS_CONSUMER) then 1 else 0 end) as VSCON_DISCOUNT_CNT,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method = 'C'  and CARD_SCHEME = '04' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as VSDEB_DISCOUNT_C,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method <> 'C'  and CARD_SCHEME = '04' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as VSDEB_DISCOUNT_D,
	sum(CASE WHEN($IS_DISCOUNT and CARD_SCHEME = '04' and $IS_MAS_DEBIT) then 1 else 0 end) as VSDEB_DISCOUNT_CNT,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method = 'C'  and CARD_SCHEME = '04' and $IS_MAS_BUSINESS ) then AMT_ORIGINAL else 0 end) as VSBUS_DISCOUNT_C,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method <> 'C'  and CARD_SCHEME = '04' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as VSBUS_DISCOUNT_D,
	sum(CASE WHEN($IS_DISCOUNT and CARD_SCHEME = '04' and $IS_MAS_BUSINESS) then 1 else 0 end) as VSBUS_DISCOUNT_CNT,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method = 'C'  and CARD_SCHEME = '05' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as MCDEB_DISCOUNT_C,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method <> 'C' and CARD_SCHEME = '05' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as MCDEB_DISCOUNT_D,
	sum(CASE WHEN($IS_DISCOUNT and CARD_SCHEME = '05' and $IS_MAS_DEBIT) then 1 else 0 end) as MCDEB_DISCOUNT_CNT,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method = 'C' and CARD_SCHEME = '05' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as MCBUS_DISCOUNT_C,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method <> 'C' and CARD_SCHEME = '05' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as MCBUS_DISCOUNT_D,
	sum(CASE WHEN($IS_DISCOUNT and CARD_SCHEME = '05' and $IS_MAS_BUSINESS) then 1 else 0 end) as MCBUS_DISCOUNT_CNT,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method = 'C' and CARD_SCHEME = '05' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as MCCON_DISCOUNT_C,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method <> 'C' and CARD_SCHEME = '05' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as MCCON_DISCOUNT_D,
	sum(CASE WHEN($IS_DISCOUNT and CARD_SCHEME = '05' and $IS_MAS_CONSUMER) then 1 else 0 end) as MCCON_DISCOUNT_CNT,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method = 'C' and CARD_SCHEME = '08' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as DSCCON_DISCOUNT_C,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method <> 'C' and CARD_SCHEME = '08' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as DSCCON_DISCOUNT_D,
	sum(CASE WHEN($IS_DISCOUNT and CARD_SCHEME = '08' and $IS_MAS_CONSUMER) then 1 else 0 end) as DSCCON_DISCOUNT_CNT,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method = 'C' and CARD_SCHEME = '08' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as DSCDEB_DISCOUNT_C,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method <> 'C' and CARD_SCHEME = '08' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as DSCDEB_DISCOUNT_D,
	sum(CASE WHEN($IS_DISCOUNT and CARD_SCHEME = '08' and $IS_MAS_DEBIT) then 1 else 0 end) as DSCDEB_DISCOUNT_CNT,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method = 'C' and CARD_SCHEME = '08' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as DSCBUS_DISCOUNT_C,
	sum(CASE WHEN($IS_DISCOUNT and settl_flag = 'Y' and tid_settl_method <> 'C' and CARD_SCHEME = '08' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as DSCBUS_DISCOUNT_D,
	sum(CASE WHEN($IS_DISCOUNT and CARD_SCHEME = '08' and $IS_MAS_BUSINESS) then 1 else 0 end) as DSCBUS_DISCOUNT_CNT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME in ('04','05','02','08')) then AMT_ORIGINAL else 0 end) as ALL_INCOME_AMT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME in ('04','05','02','08')) then 1 else 0 end) as ALL_INCOME_CNT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME in ('05')) then AMT_ORIGINAL else 0 end) as MC_INCOME_AMT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME in ('05')) then 1 else 0 end) as MC_INCOME_CNT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME in ('04')) then AMT_ORIGINAL else 0 end) as VS_INCOME_AMT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME in ('04')) then 1 else 0 end) as VS_INCOME_CNT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME in ('02')) then AMT_ORIGINAL else 0 end) as DB_INCOME_AMT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME in ('02')) then 1 else 0 end) as DB_INCOME_CNT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME in ('08')) then AMT_ORIGINAL else 0 end) as DSC_INCOME_AMT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME in ('08')) then 1 else 0 end) as DSC_INCOME_CNT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME = '04' and $IS_MAS_CONSUMER) then 1 else 0 end) as VSCON_INCOME_CNT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME = '04' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as VSCON_INCOME_AMT,                                 
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME = '04' and $IS_MAS_DEBIT) then 1 else 0 end) as VSDEB_INCOME_CNT,                               
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME = '04' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as VSDEB_INCOME_AMT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME = '04' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as VSBUS_INCOME_AMT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME = '04' and $IS_MAS_BUSINESS) then 1 else 0 end) as VSBUS_INCOME_CNT,                                
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME = '05' and $IS_MAS_CONSUMER) then 1 else 0 end) as MCCON_INCOME_CNT,                               
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME = '05' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as MCCON_INCOME_AMT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME = '05' and $IS_MAS_DEBIT) then 1 else 0 end) as MCDEB_INCOME_CNT,              
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME = '05' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as MCDEB_INCOME_AMT,                                
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME = '05' and $IS_MAS_BUSINESS) then 1 else 0 end) as MCBUS_INCOME_CNT,                   
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME = '05' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as MCBUS_INCOME_AMT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME = '08' and $IS_MAS_CONSUMER) then 1 else 0 end) as DSCCON_INCOME_CNT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME = '08' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as DSCCON_INCOME_AMT,                                 
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME = '08' and $IS_MAS_DEBIT) then 1 else 0 end) as DSCDEB_INCOME_CNT,                               
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME = '08' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as DSCDEB_INCOME_AMT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME = '08' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as DSCBUS_INCOME_AMT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010040' and CARD_SCHEME = '08' and $IS_MAS_BUSINESS) then 1 else 0 end) as DSCBUS_INCOME_CNT,    
	sum(CASE WHEN(substr(TID, 1, 6) = '010041' and CARD_SCHEME in ('04','05','02','08')) then AMT_ORIGINAL else 0 end) as ALL_EXP_AMT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010041' and CARD_SCHEME in ('04')) then AMT_ORIGINAL else 0 end) as VS_EXP_AMT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010041' and CARD_SCHEME in ('05')) then AMT_ORIGINAL else 0 end) as MC_EXP_AMT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010041' and CARD_SCHEME in ('02')) then AMT_ORIGINAL else 0 end) as DB_EXP_AMT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010041' and CARD_SCHEME in ('08')) then AMT_ORIGINAL else 0 end) as DSC_EXP_AMT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010041' and CARD_SCHEME = '04' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as VSCON_EXP_AMT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010041' and CARD_SCHEME = '04' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as VSDEB_EXP_AMT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010041' and CARD_SCHEME = '04' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as VSBUS_EXP_AMT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010041' and CARD_SCHEME = '05' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as MCCON_EXP_AMT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010041' and CARD_SCHEME = '05' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as MCDEB_EXP_AMT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010041' and CARD_SCHEME = '05' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as MCBUS_EXP_AMT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010041' and CARD_SCHEME = '08' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as DSCCON_EXP_AMT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010041' and CARD_SCHEME = '08' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as DSCDEB_EXP_AMT,
	sum(CASE WHEN(substr(TID, 1, 6) = '010041' and CARD_SCHEME = '08' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as DSCBUS_EXP_AMT,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method = 'C' and CARD_SCHEME in ('04','05','02','08')) then AMT_ORIGINAL else 0 end) as ALL_INTERCHANGE_C,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method <> 'C' and CARD_SCHEME in ('04','05','02','08')) then AMT_ORIGINAL else 0 end) as ALL_INTERCHANGE_D,
	sum(CASE WHEN($IS_INTERCHANGE and CARD_SCHEME in ('04','05','02','08')) then 1 else 0 end) as ALL_INTERCHANGE_CNT,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method = 'C' and CARD_SCHEME in ('04')) then AMT_ORIGINAL else 0 end) as VS_INTERCHANGE_C,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method <> 'C' and CARD_SCHEME in ('04')) then AMT_ORIGINAL else 0 end) as VS_INTERCHANGE_D,
	sum(CASE WHEN($IS_INTERCHANGE and CARD_SCHEME in ('04')) then 1 else 0 end) as VS_INTERCHANGE_CNT,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method = 'C' and CARD_SCHEME in ('05')) then AMT_ORIGINAL else 0 end) as MC_INTERCHANGE_C,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method <> 'C' and CARD_SCHEME in ('05')) then AMT_ORIGINAL else 0 end) as MC_INTERCHANGE_D,
	sum(CASE WHEN($IS_INTERCHANGE and CARD_SCHEME in ('05')) then 1 else 0 end) as MC_INTERCHANGE_CNT,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method = 'C' and CARD_SCHEME in ('02')) then AMT_ORIGINAL else 0 end) as DB_INTERCHANGE_C,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method <> 'C' and CARD_SCHEME in ('02')) then AMT_ORIGINAL else 0 end) as DB_INTERCHANGE_D,
	sum(CASE WHEN($IS_INTERCHANGE and CARD_SCHEME in ('02')) then 1 else 0 end) as DB_INTERCHANGE_CNT,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method = 'C' and CARD_SCHEME in ('08')) then AMT_ORIGINAL else 0 end) as DSC_INTERCHANGE_C,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method <> 'C' and CARD_SCHEME in ('08')) then AMT_ORIGINAL else 0 end) as DSC_INTERCHANGE_D,
	sum(CASE WHEN($IS_INTERCHANGE and CARD_SCHEME in ('08')) then 1 else 0 end) as DSC_INTERCHANGE_CNT,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method = 'C' and CARD_SCHEME = '04' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as VSCON_INTERCHANGE_C,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method <> 'C' and CARD_SCHEME = '04' and $IS_MAS_CONSUMER ) then AMT_ORIGINAL else 0 end) as VSCON_INTERCHANGE_D,
	sum(CASE WHEN($IS_INTERCHANGE and CARD_SCHEME = '04' and $IS_MAS_CONSUMER) then 1 else 0 end) as VSCON_INTERCHANGE_CNT,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method = 'C' and CARD_SCHEME = '04' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as VSDEB_INTERCHANGE_C,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method <> 'C' and CARD_SCHEME = '04' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as VSDEB_INTERCHANGE_D,
	sum(CASE WHEN($IS_INTERCHANGE and CARD_SCHEME = '04' and $IS_MAS_DEBIT) then 1 else 0 end) as VSDEB_INTERCHANGE_CNT,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method = 'C' and CARD_SCHEME = '04' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as VSBUS_INTERCHANGE_C,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method <> 'C' and CARD_SCHEME = '04' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as VSBUS_INTERCHANGE_D,
	sum(CASE WHEN($IS_INTERCHANGE and CARD_SCHEME = '04' and $IS_MAS_BUSINESS) then 1 else 0 end) as VSBUS_INTERCHANGE_CNT,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method = 'C' and CARD_SCHEME = '05' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as MCDEB_INTERCHANGE_C,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method <> 'C' and CARD_SCHEME = '05' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as MCDEB_INTERCHANGE_D,
	sum(CASE WHEN($IS_INTERCHANGE and CARD_SCHEME = '05' and $IS_MAS_DEBIT) then 1 else 0 end) as MCDEB_INTERCHANGE_CNT,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method = 'C' and CARD_SCHEME = '05' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as MCCON_INTERCHANGE_C,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method <> 'C' and CARD_SCHEME = '05' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as MCCON_INTERCHANGE_D,
	sum(CASE WHEN($IS_INTERCHANGE and CARD_SCHEME = '05' and $IS_MAS_CONSUMER) then 1 else 0 end) as MCCON_INTERCHANGE_CNT,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method = 'C' and CARD_SCHEME = '05' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as MCBUS_INTERCHANGE_C,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method <> 'C' and CARD_SCHEME = '05' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as MCBUS_INTERCHANGE_D,
	sum(CASE WHEN($IS_INTERCHANGE and CARD_SCHEME = '05' and $IS_MAS_BUSINESS) then 1 else 0 end) as MCBUS_INTERCHANGE_CNT,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method = 'C' and CARD_SCHEME = '08' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as DSCCON_INTERCHANGE_C,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method <> 'C' and CARD_SCHEME = '08' and $IS_MAS_CONSUMER ) then AMT_ORIGINAL else 0 end) as DSCCON_INTERCHANGE_D,
	sum(CASE WHEN($IS_INTERCHANGE and CARD_SCHEME = '08' and $IS_MAS_CONSUMER) then 1 else 0 end) as DSCCON_INTERCHANGE_CNT,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method = 'C' and CARD_SCHEME = '08' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as DSCDEB_INTERCHANGE_C,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method <> 'C' and CARD_SCHEME = '08' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as DSCDEB_INTERCHANGE_D,
	sum(CASE WHEN($IS_INTERCHANGE and CARD_SCHEME = '08' and $IS_MAS_DEBIT) then 1 else 0 end) as DSCDEB_INTERCHANGE_CNT,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method = 'C' and CARD_SCHEME = '08' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as DSCBUS_INTERCHANGE_C,
	sum(CASE WHEN($IS_INTERCHANGE and tid_settl_method <> 'C' and CARD_SCHEME = '08' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as DSCBUS_INTERCHANGE_D,
	sum(CASE WHEN($IS_INTERCHANGE and CARD_SCHEME = '08' and $IS_MAS_BUSINESS) then 1 else 0 end) as DSCBUS_INTERCHANGE_CNT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME in ('04','05','02','08')) then AMT_ORIGINAL else 0 end) as ALL_MIN_AMT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME in ('04','05','02','08')) then 1 else 0 end) as ALL_MIN_CNT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME in ('04')) then AMT_ORIGINAL else 0 end) as VS_MIN_AMT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME in ('04')) then 1 else 0 end) as VS_MIN_CNT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME in ('05') ) then AMT_ORIGINAL else 0 end) as MC_MIN_AMT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME in ('05') ) then 1 else 0 end) as MC_MIN_CNT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME in ('08')) then AMT_ORIGINAL else 0 end) as DSC_MIN_AMT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME in ('08')) then 1 else 0 end) as DSC_MIN_CNT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME in ('02')) then AMT_ORIGINAL else 0 end) as DB_MIN_AMT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME in ('02')) then 1 else 0 end) as DB_MIN_CNT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME = '04' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as VSCON_MIN_AMT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME = '04' and $IS_MAS_CONSUMER) then 1 else 0 end) as VSCON_MIN_CNT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME = '04' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as VSDEB_MIN_AMT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME = '04' and $IS_MAS_DEBIT) then 1 else 0 end) as VSDEB_MIN_CNT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME = '04' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as VSBUS_MIN_AMT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME = '04' and $IS_MAS_BUSINESS) then 1 else 0 end) as VSBUS_MIN_CNT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME = '05' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as MCDEB_MIN_AMT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME = '05' and $IS_MAS_DEBIT) then 1 else 0 end) as MCDEB_MIN_CNT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME = '05' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as MCCON_MIN_AMT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME = '05' and $IS_MAS_CONSUMER) then 1 else 0 end) as MCCON_MIN_CNT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME = '05' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as MCBUS_MIN_AMT, 
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME = '05' and $IS_MAS_BUSINESS) then 1 else 0 end) as MCBUS_MIN_CNT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME = '08' and $IS_MAS_CONSUMER) then AMT_ORIGINAL else 0 end) as DSCCON_MIN_AMT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME = '08' and $IS_MAS_CONSUMER) then 1 else 0 end) as DSCCON_MIN_CNT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME = '08' and $IS_MAS_DEBIT) then AMT_ORIGINAL else 0 end) as DSCDEB_MIN_AMT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME = '08' and $IS_MAS_DEBIT) then 1 else 0 end) as DSCDEB_MIN_CNT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME = '08' and $IS_MAS_BUSINESS) then AMT_ORIGINAL else 0 end) as DSCBUS_MIN_AMT,
	sum(CASE WHEN( substr(TID, 1, 8) = '01000419' and CARD_SCHEME = '08' and $IS_MAS_BUSINESS) then 1 else 0 end) as DSCBUS_MIN_CNT
                         from mas_trans_log
                         where  institution_id in ($institution_num) and
                                (date_to_settle >= '$sql_start_of_year' and date_to_settle < '$sql_end_day')
                         GROUP BY TO_CHAR( date_to_settle, 'MM'), TO_CHAR( date_to_settle, 'Q')"
      #puts $query_string_m
      orasql $ie_cursor $query_string_m2
	while {[orafetch $ie_cursor -dataarray m2 -indexbyname] != 1403} {
		if { $m2(MNTH) == $RepMon } {
			foreach cat {ALL VS VSCON VSDEB VSBUS MC MCCON MCDEB MCBUS DSC DSCCON DSCDEB DSCBUS DB} {
				set Discount_Volume(${cat}_M)      [expr $m2(${cat}_DISCOUNT_C) -$m2(${cat}_DISCOUNT_D)]
				set Discount_Count(${cat}_M)       $m2(${cat}_DISCOUNT_CNT)
				set Income_Volume(${cat}_M)        $m2(${cat}_INCOME_AMT)
				set Income_Count(${cat}_M)         $m2(${cat}_INCOME_CNT)
				set Expense_Volume(${cat}_M)       $m2(${cat}_EXP_AMT)
				set Interchange_Volume(${cat}_M)   [expr $m2(${cat}_INTERCHANGE_C) - $m2(${cat}_INTERCHANGE_D)]
				set Interchange_Count(${cat}_M)    $m2(${cat}_INTERCHANGE_CNT)
				set Minimum_Volume(${cat}_M)       $m2(${cat}_MIN_AMT)
				set Minimum_Count(${cat}_M)        $m2(${cat}_MIN_CNT)
			}
		}

		if { $m2(QTR) == $RepQtr } {
			foreach cat {ALL VS VSCON VSDEB VSBUS MC MCCON MCDEB MCBUS DSC DSCCON DSCDEB DSCBUS DB} {
				set Discount_Volume(${cat}_Q)      [expr $Discount_Volume(${cat}_Q) + ( $m2(${cat}_DISCOUNT_C) -$m2(${cat}_DISCOUNT_D) )]
				set Discount_Count(${cat}_Q)       [expr $Discount_Count(${cat}_Q) + $m2(${cat}_DISCOUNT_CNT)]
				set Income_Volume(${cat}_Q)        [expr $Income_Volume(${cat}_Q) + $m2(${cat}_INCOME_AMT)]
				set Income_Count(${cat}_Q)         [expr $Income_Count(${cat}_Q) + $m2(${cat}_INCOME_CNT)]
				set Expense_Volume(${cat}_Q)       [expr $Expense_Volume(${cat}_Q) + $m2(ALL_EXP_AMT)]
				set Interchange_Volume(${cat}_Q)   [expr $Interchange_Volume(${cat}_Q) + ( $m2(${cat}_INTERCHANGE_C) - $m2(${cat}_INTERCHANGE_D) )]
				set Interchange_Count(${cat}_Q)    [expr $Interchange_Count(${cat}_Q) + $m2(${cat}_INTERCHANGE_CNT)]
				set Minimum_Volume(${cat}_Q)       [expr $Minimum_Volume(${cat}_Q) + $m2(${cat}_MIN_AMT)]
				set Minimum_Count(${cat}_Q)        [expr $Minimum_Count(${cat}_Q) + $m2(${cat}_MIN_CNT)]
			}
      	}
      	
		foreach cat {ALL VS VSCON VSDEB VSBUS MC MCCON MCDEB MCBUS DSC DSCCON DSCDEB DSCBUS DB} {
			set Discount_Volume(${cat}_Y)      [expr $Discount_Volume(${cat}_Y) + ( $m2(${cat}_DISCOUNT_C) -$m2(${cat}_DISCOUNT_D) )]
			set Discount_Count(${cat}_Y)       [expr $Discount_Count(${cat}_Y) + $m2(${cat}_DISCOUNT_CNT)]
			set Income_Volume(${cat}_Y)        [expr $Income_Volume(${cat}_Y) + $m2(${cat}_INCOME_AMT)]
			set Income_Count(${cat}_Y)         [expr $Income_Count(${cat}_Y) + $m2(${cat}_INCOME_CNT)]
			set Expense_Volume(${cat}_Y)       [expr $Expense_Volume(${cat}_Y) + $m2(${cat}_EXP_AMT)]
			set Interchange_Volume(${cat}_Y)   [expr $Interchange_Volume(${cat}_Y) + ( $m2(${cat}_INTERCHANGE_C) - $m2(${cat}_INTERCHANGE_D) )]
			set Interchange_Count(${cat}_Y)    [expr $Interchange_Count(${cat}_Y) + $m2(${cat}_INTERCHANGE_CNT)]
			set Minimum_Volume(${cat}_Y)       [expr $Minimum_Volume(${cat}_Y) + $m2(${cat}_MIN_AMT)]
			set Minimum_Count(${cat}_Y)        [expr $Minimum_Count(${cat}_Y) + $m2(${cat}_MIN_CNT)]
		}
	}

#  ***** MERCHANT COUNT ********
	set query_string_num " SELECT count(1) as count
                           FROM acq_entity
                          WHERE entity_level = '70'
                           AND ( parent_entity_id = '447474000000000' OR (substr(parent_entity_id, 1, 6) = '454045' and substr(parent_entity_id, 10, 6) = '000000'))
                           AND institution_id in ($institution_num) "
	orasql $ie_cursor $query_string_num
	if {[orafetch $ie_cursor -dataarray num -indexbyname] != 1403} {
		set ALL_Merchant_Count [expr $Merchant_Count + $num(COUNT)]
	}

	puts "CHARGEBACK"
    
	foreach cat {ALL VS MC DB DSC VSCON VSDEB VSBUS MCCON MCDEB MCBUS DSCCON DSCDEB DSCBUS} {
    	
    	if { $Discount_Count(${cat}_M) == 0 } {
			set Discount_Count(${cat}_M) 1
			set Discount_Count(${cat}_Q) 1
			set Discount_Count(${cat}_Y) 1
		}
		
		if { $Count(${cat}_M) == 0 } {
			set Count(${cat}_M) 1
			set Count(${cat}_Q) 1
			set Count(${cat}_Y) 1
		}
		
		#if { $Net_Sale_Count(${cat}_M) == 0 } {
          set Net_Sale_Count(${cat}_M) 1
          set Net_Sale_Count(${cat}_Q) 1
          set Net_Sale_Count(${cat}_Y) 1
        #}
        
        foreach period {M Q Y} {
        
			set Discount_Average_Volume(${cat}_$period) [expr $Discount_Volume(${cat}_$period) / $Discount_Count(${cat}_$period)]
			set Net_Sale_Volume(${cat}_$period) [expr $Volume(${cat}_$period) - $Refund_Volume(${cat}_$period)]
			set Net_Sale_Count(${cat}_$period) [expr $Count(${cat}_$period) + $Refund_Count(${cat}_$period)]
			set Income_Average_Volume(${cat}_$period) 0
			set Expense_Average_Volume(${cat}_$period) 0
			set Average_Volume(${cat}_$period) 0
        }
	}

	if {$ALL_Merchant_Count != 0 } {
	
		foreach cat {ALL VS MC DB DSC VSCON VSDEB VSBUS MCCON MCDEB MCBUS DSCCON DSCDEB DSCBUS} {
	
			set Income_Average_Volume(${cat}_M) [expr $Net_Sale_Volume(${cat}_M) / $Net_Sale_Count(${cat}_M)]
			set Income_Average_Volume(${cat}_Q) [expr $Net_Sale_Volume(${cat}_Q) / $Net_Sale_Count(${cat}_Q)]
			set Income_Average_Volume(${cat}_Y) [expr $Net_Sale_Volume(${cat}_Y) / $Net_Sale_Count(${cat}_Y)]
			
			set Expense_Average_Volume(${cat}_M) [expr $Expense_Volume(${cat}_M) / $ALL_Merchant_Count]
			set Expense_Average_Volume(${cat}_Q) [expr $Expense_Volume(${cat}_Q) / $ALL_Merchant_Count]
			set Expense_Average_Volume(${cat}_Y) [expr $Expense_Volume(${cat}_Y) / $ALL_Merchant_Count]
			
			set Average_Volume(${cat}_M) [expr $Volume(${cat}_M) / $Count(${cat}_M)]
			set Average_Volume(${cat}_Q) [expr $Volume(${cat}_Q) / $Count(${cat}_Q)]
			set Average_Volume(${cat}_Y) [expr $Volume(${cat}_Y) / $Count(${cat}_Y)]			
		}
	}

	set interchangeBuff_VS [list]
	set interchangeBuff_MC [list]
	set interchangeBuff_DSC [list]

	set query_interchange_vsmqy " select MTL.card_scheme c_scheme, mc.MAS_DESC as MAS_DESC,
    sum(CASE WHEN( (date_to_settle >= '$sql_start_of_year' and date_to_settle < '$sql_end_day')  and MTL.tid_settl_method = 'C') then amt_original else 0 end) as Y_INTERCHG_C,
    sum(CASE WHEN( (date_to_settle >= '$sql_start_of_year' and date_to_settle < '$sql_end_day') and MTL.tid_settl_method <> 'C') then amt_original else 0 end) as Y_INTERCHG_D,
    sum(CASE WHEN( (date_to_settle >= '$sql_start_of_year' and date_to_settle < '$sql_end_day') and MTL.tid_settl_method = 'C') then 1 else 0 end) as Y_INTERCHG_CNT_C,
    sum(CASE WHEN( (date_to_settle >= '$sql_start_of_year' and date_to_settle < '$sql_end_day') and MTL.tid_settl_method <>'C') then 1 else 0 end) as Y_INTERCHG_CNT_D,
    sum(CASE WHEN( $qtr_fee_criteria and MTL.tid_settl_method = 'C') then amt_original else 0 end) as Q_INTERCHG_C,
    sum(CASE WHEN( $qtr_fee_criteria and MTL.tid_settl_method <> 'C') then amt_original else 0 end) as Q_INTERCHG_D,
    sum(CASE WHEN( $qtr_fee_criteria and MTL.tid_settl_method = 'C') then 1 else 0 end) as Q_INTERCHG_CNT_C,
    sum(CASE WHEN( $qtr_fee_criteria and MTL.tid_settl_method <> 'C') then 1 else 0 end) as Q_INTERCHG_CNT_D,
    sum(CASE WHEN( (gl_date > $sql_begin_day and gl_date < '$sql_end_day') and MTL.tid_settl_method = 'C') then amt_original else 0 end) as M_INTERCHG_C,
    sum(CASE WHEN( (gl_date > $sql_begin_day and gl_date < '$sql_end_day') and MTL.tid_settl_method <> 'C') then amt_original else 0 end) as M_INTERCHG_D,
    sum(CASE WHEN( (gl_date > $sql_begin_day and gl_date < '$sql_end_day') and MTL.tid_settl_method = 'C') then 1 else 0 end) as M_INTERCHG_CNT_C,
    sum(CASE WHEN( (gl_date > $sql_begin_day and gl_date < '$sql_end_day') and MTL.tid_settl_method <> 'C') then 1 else 0 end) as M_INTERCHG_CNT_D
                              from mas_trans_log MTL, mas_code MC
                              where MC.mas_code = MTL.mas_code
                                and date_to_settle >= '$sql_start_of_year' and gl_date < '$sql_end_day' /*To narrow scope of query*/
                                and mtl.institution_id in ($institution_num)
                                and MTL.tid in ('010004020000','010004020005')
                                and MTL.card_scheme in ('04','05','08')
                              group by MTL.card_scheme, mc.MAS_DESC
                              having (sum(CASE WHEN( (date_to_settle >= '$sql_start_of_year' and date_to_settle < '$sql_end_day')) then 1 else 0 end) <> 0)
                              order by mc.MAS_DESC "

	puts "interchange: $query_interchange_vsmqy"
    orasql $ie_cursor $query_interchange_vsmqy
    while {[orafetch $ie_cursor -dataarray irow -indexbyname] != 1403} {   

		switch -exact -- $irow(C_SCHEME) {
			"04" {
					lappend interchangeBuff_VS " $irow(MAS_DESC), $irow(M_INTERCHG_CNT_C),$irow(M_INTERCHG_C),$irow(Q_INTERCHG_CNT_C),$irow(Q_INTERCHG_C),$irow(Y_INTERCHG_CNT_C),$irow(Y_INTERCHG_C)"
          			lappend interchangeBuff_VS " $irow(MAS_DESC), $irow(M_INTERCHG_CNT_D),$irow(M_INTERCHG_D),$irow(Q_INTERCHG_CNT_D),$irow(Q_INTERCHG_D),$irow(Y_INTERCHG_CNT_D),$irow(Y_INTERCHG_D)"
          		}
          	"05" {
					lappend interchangeBuff_MC " $irow(MAS_DESC), $irow(M_INTERCHG_CNT_C),$irow(M_INTERCHG_C),$irow(Q_INTERCHG_CNT_C),$irow(Q_INTERCHG_C),$irow(Y_INTERCHG_CNT_C),$irow(Y_INTERCHG_C)"
          			lappend interchangeBuff_MC " $irow(MAS_DESC), $irow(M_INTERCHG_CNT_D),$irow(M_INTERCHG_D),$irow(Q_INTERCHG_CNT_D),$irow(Q_INTERCHG_D),$irow(Y_INTERCHG_CNT_D),$irow(Y_INTERCHG_D)"
          		}
          	"08" {
					lappend interchangeBuff_DSC " $irow(MAS_DESC), $irow(M_INTERCHG_CNT_C),$irow(M_INTERCHG_C),$irow(Q_INTERCHG_CNT_C),$irow(Q_INTERCHG_C),$irow(Y_INTERCHG_CNT_C),$irow(Y_INTERCHG_C)"
          			lappend interchangeBuff_DSC " $irow(MAS_DESC), $irow(M_INTERCHG_CNT_D),$irow(M_INTERCHG_D),$irow(Q_INTERCHG_CNT_D),$irow(Q_INTERCHG_D),$irow(Y_INTERCHG_CNT_D),$irow(Y_INTERCHG_D)"
          		}
		}    
    }
    
    set catDescriptor(ALL)		""
    set catDescriptor(VS) 		"TOTAL VISA"
    set catDescriptor(VSCON)	"CONSUMER VISA"
    set catDescriptor(VSDEB) 	"VISA DEBIT"
    set catDescriptor(VSBUS)	"VISA BUSINESS"
    set catDescriptor(MC)		"TOTAL MASTERCARD"
    set catDescriptor(MCCON)	"CONSUMER MASTERCARD"
    set catDescriptor(MCDEB)	"MASTERCARD DEBIT"
    set catDescriptor(MCBUS)	"MASTERCARD BUSINESS"
    set catDescriptor(AX)		"AMEX"
    set catDescriptor(DSC)		"TOTAL DISCOVER"
    set catDescriptor(DSCCON)	"CONSUMER DISCOVER"
    set catDescriptor(DSCDEB)	"DISCOVER DEBIT"
    set catDescriptor(DSCBUS)	"DISCOVER BUSINESS"
    set catDescriptor(DB)		"TOTAL DEBIT CARD"
	
	foreach cat {ALL VS VSCON VSDEB VSBUS MC MCCON MCDEB MCBUS AX DSC DSCCON DSCDEB DSCBUS DB} {
	
		puts $cur_file $catDescriptor($cat)
 		puts $catDescriptor($cat)
 		
 		if {$cat == "AX"} {
 			puts $cur_file "\r"
 			continue
 		}
 
		puts $cur_file " TOTAL SALES VOLUME, $Count(${cat}_M),$Volume(${cat}_M),$Count(${cat}_Q),$Volume(${cat}_Q),$Count(${cat}_Y),$Volume(${cat}_Y)\r"
		puts $cur_file " TOTAL CREDIT VOLUME, $Refund_Count(${cat}_M),$Refund_Volume(${cat}_M),$Refund_Count(${cat}_Q),$Refund_Volume(${cat}_Q),$Refund_Count(${cat}_Y),$Refund_Volume(${cat}_Y)\r"
		puts $cur_file " NET SALES, $Net_Sale_Count(${cat}_M),$Net_Sale_Volume(${cat}_M),$Net_Sale_Count(${cat}_Q),$Net_Sale_Volume(${cat}_Q),$Net_Sale_Count(${cat}_Y),$Net_Sale_Volume(${cat}_Y)\r"
		puts $cur_file "\r"
		puts $cur_file " FEES\r"
		puts $cur_file "DISCOUNT, , $Discount_Volume(${cat}_M), , $Discount_Volume(${cat}_Q),,$Discount_Volume(${cat}_Y)\r"
		puts $cur_file "MINIMUM DISCOUNT,,$Minimum_Volume(${cat}_M),,$Minimum_Count(${cat}_Q),,$Minimum_Count(${cat}_Y)\r"
		puts $cur_file "DUE MERCHANT \r"
		#puts $cur_file "DUE BANK, , $Discount_Volume(${cat}_M), , $Discount_Volume(${cat}_Q),,$Discount_Volume(${cat}_Y)\r"
		puts $cur_file "NET, , $Discount_Volume(${cat}_M), , $Discount_Volume(${cat}_Q),,$Discount_Volume(${cat}_Y)\r"
		puts $cur_file "\r"
		puts $cur_file "TOTAL INTERCHANGE,,$Interchange_Volume(${cat}_M),,$Interchange_Volume(${cat}_Q),,$Interchange_Volume(${cat}_Y)\r"
		puts $cur_file "\r"
		
		if {$Count(${cat}_M) != 0 } {
			puts $cur_file "AVERAGE TICKET,,[format "%0.2f" $Income_Average_Volume(${cat}_M)],,[format "%0.2f" $Income_Average_Volume(${cat}_Q)],,[format "%0.2f" $Income_Average_Volume(${cat}_Y)]\r"
			puts $cur_file "AVERAGE DISCOUNT,,$Discount_Average_Volume(${cat}_M),,$Discount_Average_Volume(${cat}_M),,$Discount_Average_Volume(${cat}_M)\r"
        } else {
			puts $cur_file "AVERAGE TICKET,,,,,,\r"
			puts $cur_file "AVERAGE DISCOUNT\r"
        }

		puts $cur_file "AVERAGE EXPENSE,,$Expense_Average_Volume(${cat}_M),,$Expense_Average_Volume(${cat}_Q),,$Expense_Average_Volume(${cat}_Y) \r"
		puts $cur_file "AVERAGE INCOME,,$Income_Average_Volume(${cat}_M),,$Income_Average_Volume(${cat}_Q),,$Income_Average_Volume(${cat}_Y)\r"
		puts $cur_file "CHARGEBACKS,$Chargeback_Count(${cat}_M),$Chargeback_Volume(${cat}_M),$Chargeback_Count(${cat}_Q),$Chargeback_Volume(${cat}_Q),$Chargeback_Count(${cat}_Y),$Chargeback_Volume(${cat}_Y) \r"
		puts $cur_file "CHARGEBACKS CREDITS,$Representment_Count(${cat}_M),$Representment_Volume(${cat}_M),$Representment_Count(${cat}_Q),$Representment_Volume(${cat}_Q),$Representment_Count(${cat}_Y),$Representment_Volume(${cat}_Y),\r"
		puts $cur_file "CHARGEBACKS REVERSALS\r"
		puts $cur_file "SALES ADJ\r"
		puts $cur_file "CREDIT ADJ\r"
		puts $cur_file "\r"
						
		if {$cat == "VS" || $cat == "MC" || $cat == "DSC" } {
			foreach x [subst $[subst "interchangeBuff_$cat"]] {
				puts $cur_file $x
			}
			puts $cur_file "\r"
		}
	}
      
	puts $cur_file "JCB"
	puts "JCB"
	puts $cur_file "\r"
     
	puts $cur_file "EBT"
	puts "EBT"
	puts $cur_file "\r"
      
	puts $cur_file "\r\n"
	puts $cur_file "\r\n"
	puts $cur_file "\r\n"
	puts $cur_file "\r\n" 
}

set cur_file_name "./ROLLUP.REPORT.IE.$CUR_JULIAN_DATEX.$title_date.$institution_id.001.csv"
set file_name "ROLLUP.REPORT.IE.$CUR_JULIAN_DATEX.$title_date.$institution_id.001.csv"

set cur_file [open "$cur_file_name" w]

if { $institution_id == "ALL" } {
   
	puts $cur_file "ROLLUP,"
	puts "ISO,101,107,112,113,114,115,116"
	IE_report 101,107,112,113,114,115,116
  
} else {
  	puts $cur_file "ISO, $institution_id "
    puts "ISO, $institution_id "
            IE_report $institution_id
}

close $cur_file
  
puts "******* DO NOT FORGET TO CHECK MERCHANT COUNTS !!!! ********"

# exec uuencode $cur_file_name $file_name | mailx -r clearing@jetpay.com -s $file_name clearing@jetpay.com
#exec uuencode $cur_file_name $file_name | mailx -r clearing@jetpay.com -s $file_name reports-clearing@jetpay.com

oraclose $ie_cursor
oralogoff $handler
