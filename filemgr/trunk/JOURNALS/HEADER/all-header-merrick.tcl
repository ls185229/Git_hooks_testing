#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: all-header-merrick.tcl 2301 2013-05-16 18:52:30Z mitra $

#===============================================================================
#                          Modification History
#===============================================================================
# Version 5.0 Sunny Yang 29-MAR-2010
# -------- debugging
#
# Version 4.0 Sunny Yang 08-DEC-2009
# based on all-header.tcl-v3
# -------- tuning up for performance
# -------- this script is delicated to Merrick from now on since it has different
# ---------requirement from Susq.
#
# Version 3.0. Sunny Yang 03-DEC-2009
# -------- based on all-header.tcl-updateonreserve and merrick's requests
# -------- updates includes:
# -------- MC -  Purchases - International --> need # and $
# --------       Credits - Domestic --> need #
# --------       Credits - International --> need # and $
# -------- Visa - drafts - Ecomm --> need #
# --------        drafts - Traditional --> need #
# --------        Credit vouchers --> need # and $

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

#set box $env(SYS_BOX)
#set clrpath $env(CLR_OSITE_ROOT)
#set maspath $env(MAS_OSITE_ROOT)
#set mailtolist $env(ml2_reports)
#set mailto_error $env(MAIL_TO)
#set mailfromlist $env(MAIL_FROM)

set clrdb $env(CLR4_DB)
#set clrdb clear2

set authdb $env(TSP4_DB)
#set authdb auth2


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

#===============================================================================
package require Oratcl
if {[catch {set handlerM [oralogon masclr/masclr@$clrdb]} result]} {
  #exec echo "merric-headers.tcl failed to run" |  mutt -F /clearing/filemgr/.clearing_muttrc -s "merric-headers.tcl" -- $mailto_error
  exit
}
if {[catch {set handlerT [oralogon teihost/quikdraw@$authdb]} resultauth ]} {
  #exec echo "merric-headers.tcl failed to run" |  mutt -F /clearing/filemgr/.clearing_muttrc -s "merric-headers.tcl" -- $mailto_error
  exit
}

set header_cursorM1  [oraopen $handlerM]
set header_cursorT1  [oraopen $handlerT]

set institution "ALL"

proc date_init {} {
	global name_date report_month report_my ach_date report_date CUR_JULIAN_DATEX

	set name_date         [clock format [clock scan "-0 day"] -format %Y%m%d]                     ;# 20080402 as of 04/02/2008
	set report_month      [ string toupper [clock format [ clock scan "-1 month" ] -format %B-%Y ]]
	set report_my       	[ string toupper [clock format [ clock scan "-1 month" ] -format %b-%Y ]]
	set ach_date		[ string toupper [clock format [ clock scan "-1 month " ] -format %d-%b-%Y ]]
	set report_date		[ string toupper [clock format [ clock scan "-0 day " ] -format %d-%b-%y ]]
	set CUR_JULIAN_DATEX [string range [clock format [clock seconds ] -format "%y%j"] 1 4]
}

proc date_init_from_val {dt_arg} {
	global name_date report_month report_my ach_date report_date CUR_JULIAN_DATEX

	set name_date $dt_arg
	set report_date  [ string toupper [clock format [ clock scan " $dt_arg -0 day " ] -format %d-%b-%y ]]   ;# 02-APR-08 as of 20080402
	set report_my    [ string toupper [clock format [ clock scan " $dt_arg -0 day " ] -format %b-%Y ]]      ;# MAR-08 as of 20080331
	puts " report month year is ....$report_my "

	set ach_date            [ string toupper [clock format [ clock scan "$dt_arg" ] -format %d-%b-%Y ]]
	set report_month      [ string toupper [clock format [ clock scan "$dt_arg" ] -format %B-%Y ]]
	set CUR_JULIAN_DATEX    [ string range [ clock format [ clock scan "$dt_arg" ] -format "%y%j"] 1 4 ]
}

proc month_constraint {column_name value} {
#	global monthStart nextMonthStart
	set first_of_month "01-${value}"
	set first_of_next_month "01-[clock format [clock scan "$first_of_month +1 month"] -format %b-%Y ]"
	return "$column_name >= [string toupper '01-${value}'] AND $column_name < [string toupper '$first_of_next_month']"
}

proc do_report {inst} {
	global endDT_YYYYMMDD strtDT_YYYYMMDD CUR_JULIAN_DATEX report_date
	global report_my ach_date report_month begin_nxt_month name_date
	global header_cursorM1 header_cursorT1

	set institution_lst [string map {, " "} $inst ]

	if {[llength $institution_lst] > 1} {
		set inst_label "ROLLUP"
	} else {
		set inst_label $inst
	}

	set sql_inst ""
	foreach x $institution_lst {
		set sql_inst "$sql_inst '$x',"
	}

	set sql_inst [string trimright $sql_inst ","]

	set eid ""

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

	#set query_string_main "SELECT  unique m.institution_id as INSTID, m.entity_id
    #                          FROM mas_trans_log m, acq_entity ae
    #                         WHERE m.entity_id = ae.entity_id
    #                           AND m.institution_id = ae.institution_id
    #                           AND ae.institution_id in ($sql_inst)
    #                           AND ae.ENTITY_LEVEL = '70'
    #                           AND ((([month_constraint m.gl_date $report_my ]) or ([month_constraint m.date_to_settle $report_my]))
    #                                OR
    #                                ((ae.TERMINATION_DATE is null and ae.actual_start_date < '$begin_nxt_month') or
    #                                (ae.TERMINATION_DATE > '01-$report_my' and ae.actual_start_date < '$begin_nxt_month')))
    #                        ORDER BY m.entity_id  "

    set query_string_main "	SELECT  unique m.institution_id as INSTID, m.entity_id
							FROM mas_trans_log m, acq_entity ae
							WHERE m.entity_id = ae.entity_id
								AND m.institution_id = ae.institution_id
								AND ae.institution_id in ($sql_inst)
								AND ae.ENTITY_LEVEL = '70'
								AND (	([month_constraint m.gl_date $report_my ]) OR
										([month_constraint m.date_to_settle $report_my]))
							ORDER BY m.entity_id"

	puts "MAIN: $query_string_main"
	orasql $header_cursorM1 $query_string_main
	while {[set syang [orafetch $header_cursorM1 -dataarray main -indexbyname]] == 0} {

		lappend eid $main(ENTITY_ID)
		set eidToInstit($main(ENTITY_ID)) $main(INSTID)
	}

	puts "%%%%%%%%%%%% Done with Entity Query %%%%%%%%%%%%%%"

#     ******  address  **********
	set query_string_adr "SELECT ena.entity_id as ENTITY_ID, ma.ADDRESS1 as ADDRESS1 , ma.ADDRESS2 as ADDRESS2,
                                   ma.CITY as CITY, ma.POSTAL_CD_ZIP as ZIP, ma.PROV_STATE_ABBREV as STATE
                            FROM master_address ma, ACQ_ENTITY_ADDRESS ena
                            WHERE ma.address_id = ena.address_id
                              AND ma.institution_id in ($sql_inst)
                              AND ena.institution_id in ($sql_inst)"
	puts $query_string_adr
	orasql $header_cursorM1 $query_string_adr
	while {[orafetch $header_cursorM1 -dataarray adr -indexbyname] != 1403} {
		set address "$adr(ADDRESS1) $adr(ADDRESS2)"
		set city $adr(CITY)
		set zip $adr(ZIP)
		set state $adr(STATE)
		set arradr($adr(ENTITY_ID)) $address
		set arrcity($adr(ENTITY_ID)) $city
		set arrzip($adr(ENTITY_ID)) $zip
		set arrst($adr(ENTITY_ID)) $state
		#puts "$adr(ENTITY_ID)....$arradr($adr(ENTITY_ID))...$arrcity($adr(ENTITY_ID))...$arrzip($adr(ENTITY_ID))...$arrst($adr(ENTITY_ID))"
	}

#*******        Merchant info   ***********

	# FIXME add legal name ae.entity_name and ae.tax_id to report
	set query_string_mer "SELECT unique ae.entity_id,
                                                replace(ae.entity_dba_name, ',', '') as ENTITY_DBA_NAME,
                                                replace(ae.entity_name, ',', '') as ENTITY_NAME,
                                                ae.tax_id,
                                                ae.default_mcc,
                                                ae.actual_start_date,
                                                ae.TERMINATION_DATE,
                                                ae.PROCESSING_TYPE,
                                                ae.TAX_ID
                                  FROM acq_entity ae
                                  WHERE ae.institution_id in ($sql_inst) and
                                        ae.actual_start_date <= last_day('$ach_date')
                                  ORDER BY ae.entity_id"
	puts "query_string_mer....$query_string_mer"
	orasql $header_cursorM1 $query_string_mer
	while {[orafetch $header_cursorM1 -dataarray mer -indexbyname] != 1403} {
		if {$mer(TERMINATION_DATE) != ""} {
			set PAY_STATUS INACTIVE
		} else {
			set PAY_STATUS ACTIVE
		}
		# FIXME add legal name ae.entity_name and ae.tax_id (arrlglname & arrtaxid) to report
		set arrlglname($mer(ENTITY_ID))   $mer(ENTITY_NAME)
		set arrtaxid($mer(ENTITY_ID))   $mer(TAX_ID)

		set arrname($mer(ENTITY_ID))   $mer(ENTITY_DBA_NAME)
		set arrdate($mer(ENTITY_ID))   $mer(ACTUAL_START_DATE)
		set killdate($mer(ENTITY_ID))   $mer(TERMINATION_DATE)
		set arrtype($mer(ENTITY_ID))   $mer(PROCESSING_TYPE)
		set arrstatus($mer(ENTITY_ID)) $PAY_STATUS
		set arrmcc($mer(ENTITY_ID))    $mer(DEFAULT_MCC)
		set tax($mer(ENTITY_ID))       $mer(TAX_ID)
	}


#Took off on 12/08/2009: ***  Funding info   ****

#******    pull all numbers out    **********
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

#syang: taking off these counts to match up with I.E and Daily detail
#syang 10-01-2008: chargeback was in ('010003015101', '010003015201', '010003005202')
#syang 03-31-2009 replace tid in ('010003005102',  '010003005101') with tid in ('010003005102', '010003005101', '010003005201', '010003005202')

  #set RESERVE_FLAG "select USER_DEFINED_1 from ACQ_ENTITY_ADD_ON where entity_id = m.entity_id and institution_id = m.institution_id"
	set tid_list1     "'010003015101','010003015201','010003005202','010003005301','010003005401','010003005102','010003005101','010003005201','010003005202', '010003005204','010003005104','010003015301'"
	#set tid_list2     "'010005050000','010007050000'"

	set qry_reserve "SELECT e.institution_id as INSTID,
							mtl.entity_id EID,
							sum(amt_original) as TOTAL
					FROM mas_trans_log mtl, acct_accum_det acct, entity_acct e
					WHERE mtl.payment_seq_nbr  = acct.payment_seq_nbr
						and acct.entity_acct_id = e.entity_acct_id
						and mtl.institution_id = e.institution_id
						and mtl.institution_id in ($sql_inst)
						and e.acct_posting_type = 'R'
						and (acct.payment_status is null
								or acct.payment_status='C'
								or (acct.payment_status='P' and trunc(acct.payment_proc_dt)  >= '$begin_nxt_month'))
						and mtl.gl_date < '$begin_nxt_month'
						and e.institution_id in ($sql_inst)
					GROUP BY e.institution_id, mtl.entity_id
					HAVING sum(amt_original) <> 0
					ORDER BY mtl.entity_id"

	puts "qry_reserve: $qry_reserve"
	orasql $header_cursorM1 $qry_reserve
	while {[set syang [orafetch $header_cursorM1 -dataarray rem -indexbyname]] == 0} {

		#if { $rem(INSTID) == "" && $rem(EID) == "" } {
		#	set arrreserve(ROLLUP) $rem(TOTAL)
		#} elseif { $rem(EID) == "" } {
		#	set arrreserve($rem(INSTID)) $rem(TOTAL)
		#} else {
		#	set arrreserve($rem(EID)) $rem(TOTAL)
		#}

		set arrreserve($rem(EID)) $rem(TOTAL)
	}

	set sale_tid "'010003005102','010003005101','010003005201','010003005202','010123005101','010123005102','010003005204','010003005104','010003005141','010003005142', '010003005143','010003005144'"
	set query_string_all " SELECT institution_id as INSTID,
                                          entity_id as EID,
                SUM(CASE WHEN (m.tid in ('010003015201','010003015102','010003015101','010003015210','010003015301' ) and m.tid_settl_method = 'C' ) Then m.amt_original else 0 end ) AS CHARGEBACK_C,
                SUM(CASE WHEN (m.tid in ('010003015201','010003015102','010003015101','010003015210','010003015301' ) and m.tid_settl_method <> 'C' ) Then m.amt_original else 0 end ) AS CHARGEBACK_D,
                SUM(CASE WHEN (m.tid in ('010003015201','010003015102','010003015101','010003015210','010003015301' )) Then 1 else 0 end ) AS CHARGEBACK_COUNT,
                SUM(CASE WHEN (m.tid in ('010003005301','010003005401','010003010102','010003010101') and m.tid_settl_method = 'C' ) Then m.amt_original else 0 end ) AS REPRESENT_C,
                SUM(CASE WHEN (m.tid in ('010003005301','010003005401','010003010102','010003010101') and m.tid_settl_method <> 'C' ) Then m.amt_original else 0 end ) AS REPRESENT_D,
                SUM(CASE WHEN (m.tid in ('010003005301','010003005401','010003010102','010003010101')) Then 1 else 0 end ) AS REPRESENT_COUNT,
                SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '04' ) Then 1 else 0 end ) AS VS_COUNT,
                SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '05') Then 1 else 0 end ) AS MC_COUNT,
                SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '02') Then 1 else 0 end ) AS DB_COUNT,
                SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '08' ) Then 1 else 0 end ) AS DS_COUNT,
                SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '04' and m.tid_settl_method = 'C' ) Then m.amt_original else 0 end )  AS VS_C,
                SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '04' and m.tid_settl_method <> 'C' ) Then m.amt_original else 0 end ) AS VS_D,
                SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '02' and m.tid_settl_method = 'C' ) Then m.amt_original else 0 end ) AS DB_C,
                SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '02' and m.tid_settl_method <> 'C' ) Then m.amt_original else 0 end ) AS DB_D,
                SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '08' and m.tid_settl_method = 'C' ) Then m.amt_original else 0 end )  AS DS_C,
                SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '08' and m.tid_settl_method <> 'C' ) Then m.amt_original else 0 end ) AS DS_D,
                SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '05' and m.tid_settl_method = 'C' ) Then m.amt_original else 0 end ) AS MC_C,
                SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '05' and m.tid_settl_method <> 'C' ) Then 1 else 0 end ) AS MC_D_CNT,
                SUM(CASE WHEN (m.tid in ($sale_tid) and m.CARD_SCHEME = '05' and m.tid_settl_method <> 'C' ) Then m.amt_original else 0 end ) AS MC_D
             FROM mas_trans_log m
             WHERE [month_constraint gl_date $report_my] and
                   institution_id in ($sql_inst) and
                   settl_flag = 'Y'
             group by rollup (institution_id, entity_id)
             having SUM(CASE WHEN (m.tid in ($tid_list1)) Then 1 else 0 end ) <> 0
             order by entity_id "

#puts $query_string_all
	orasql $header_cursorM1 $query_string_all
	while {[set syang [orafetch $header_cursorM1 -dataarray all -indexbyname]] == 0} {

        if { $all(INSTID) == "" && $all(EID) == "" } {
        	set arrchgcnt(ROLLUP)  $all(CHARGEBACK_COUNT)
			set arrrepcnt(ROLLUP)  $all(REPRESENT_COUNT)
			set arrvscnt(ROLLUP)   $all(VS_COUNT)
			set arrmccnt(ROLLUP)   $all(MC_COUNT)
			set arrdscnt(ROLLUP)   $all(DS_COUNT)
			set arrvscamt(ROLLUP)  $all(VS_D)   ;# Credit amount = Refund
			set arrmccamt(ROLLUP)  $all(MC_D)   ;# Credit amount = Refund
			set arrmcccnt(ROLLUP)  $all(MC_D_CNT)   ;# Credit amount = Refund
			set arrdscamt(ROLLUP)  $all(DS_D)   ;# Credit amount = Refund
			set arrchgamt(ROLLUP)  [ expr  $all(CHARGEBACK_C)  -  $all(CHARGEBACK_D)]
			set arrrepamt(ROLLUP)  [ expr $all(REPRESENT_C) -   $all(REPRESENT_D)]
			set arrvsnet(ROLLUP)   [ expr  $all(VS_C)  - $all(VS_D)]
			set arrmcnet(ROLLUP)   [ expr $all(MC_C) - $all(MC_D) ]
			set arrdsnet(ROLLUP)   [ expr  $all(DS_C)  - $all(DS_D)]
			set arrvsamt(ROLLUP)   $all(VS_C)   ;# Total VS sales
			set arrmcamt(ROLLUP)   $all(MC_C)   ;# Total MC sales
			set arrdsamt(ROLLUP)   $all(DS_C)   ;# Total VS sales
			set arrdbcnt(ROLLUP)   $all(DB_COUNT)
			set arrdbcamt(ROLLUP)  $all(DB_D)
			set arrdbnet(ROLLUP)   [ expr  $all(DB_C)  - $all(DB_D)]
			set arrdbamt(ROLLUP)   $all(DB_C)
		} elseif {$all(EID) == ""} {
			set arrchgcnt($all(INSTID))  $all(CHARGEBACK_COUNT)
			set arrrepcnt($all(INSTID))  $all(REPRESENT_COUNT)
			set arrvscnt($all(INSTID))   $all(VS_COUNT)
			set arrmccnt($all(INSTID))   $all(MC_COUNT)
			set arrdscnt($all(INSTID))   $all(DS_COUNT)
			set arrvscamt($all(INSTID))  $all(VS_D)   ;# Credit amount = Refund
			set arrmccamt($all(INSTID))  $all(MC_D)   ;# Credit amount = Refund
			set arrmcccnt($all(INSTID))  $all(MC_D_CNT)   ;# Credit amount = Refund
			set arrdscamt($all(INSTID))  $all(DS_D)   ;# Credit amount = Refund
			set arrchgamt($all(INSTID))  [ expr  $all(CHARGEBACK_C)  -  $all(CHARGEBACK_D)]
			set arrrepamt($all(INSTID))  [ expr $all(REPRESENT_C) -   $all(REPRESENT_D)]
			set arrvsnet($all(INSTID))   [ expr  $all(VS_C)  - $all(VS_D)]
			set arrmcnet($all(INSTID))   [ expr $all(MC_C) - $all(MC_D) ]
			set arrdsnet($all(INSTID))   [ expr  $all(DS_C)  - $all(DS_D)]
			set arrvsamt($all(INSTID))   $all(VS_C)   ;# Total VS sales
			set arrmcamt($all(INSTID))   $all(MC_C)   ;# Total MC sales
			set arrdsamt($all(INSTID))   $all(DS_C)   ;# Total VS sales
			set arrdbcnt($all(INSTID))   $all(DB_COUNT)
			set arrdbcamt($all(INSTID))  $all(DB_D)
			set arrdbnet($all(INSTID))   [ expr  $all(DB_C)  - $all(DB_D)]
			set arrdbamt($all(INSTID))   $all(DB_C)
		} else {
			set arrchgcnt($all(EID))  $all(CHARGEBACK_COUNT)
			set arrrepcnt($all(EID))  $all(REPRESENT_COUNT)
			set arrvscnt($all(EID))   $all(VS_COUNT)
			set arrmccnt($all(EID))   $all(MC_COUNT)
			set arrdscnt($all(EID))   $all(DS_COUNT)
			set arrvscamt($all(EID))  $all(VS_D)   ;# Credit amount = Refund
			set arrmccamt($all(EID))  $all(MC_D)   ;# Credit amount = Refund
			set arrmcccnt($all(EID))  $all(MC_D_CNT)   ;# Credit amount = Refund
			set arrdscamt($all(EID))  $all(DS_D)   ;# Credit amount = Refund
			set arrchgamt($all(EID))  [ expr  $all(CHARGEBACK_C)  -  $all(CHARGEBACK_D)]
			set arrrepamt($all(EID))  [ expr $all(REPRESENT_C) -   $all(REPRESENT_D)]
			set arrvsnet($all(EID))   [ expr  $all(VS_C)  - $all(VS_D)]
			set arrmcnet($all(EID))   [ expr $all(MC_C) - $all(MC_D) ]
			set arrdsnet($all(EID))   [ expr  $all(DS_C)  - $all(DS_D)]
			set arrvsamt($all(EID))   $all(VS_C)   ;# Total VS sales
			set arrmcamt($all(EID))   $all(MC_C)   ;# Total MC sales
			set arrdsamt($all(EID))   $all(DS_C)   ;# Total VS sales
			set arrdbcnt($all(EID))   $all(DB_COUNT)
			set arrdbcamt($all(EID))  $all(DB_D)
			set arrdbnet($all(EID))   [ expr  $all(DB_C)  - $all(DB_D)]
			set arrdbamt($all(EID))   $all(DB_C)
		}
	}


#took out on 08-DEC-2009 as it going nowhere: *** REJECTS ***

#     ****** MC Internationaj transactions ******

	set mc_international "select i.sec_dest_inst_id as instid,
                                   i.merch_id as mid,
                                    sum(case when (tid.tid_settl_method = 'C') then i.amt_trans/-100  else 0 end ) as dtranamt,
                                    sum(case when (tid.tid_settl_method = 'C') then 1  else 0 end ) as dtrancnt,
                                    sum(case when (tid.tid_settl_method = 'D') then i.amt_trans/100  else 0 end ) as ctranamt,
                                    sum(case when (tid.tid_settl_method = 'D') then 1  else 0 end ) as ctrancnt
                             from trans_enrichment t, in_draft_main i, tid
                             where [month_constraint i.activity_dt $report_my] AND
                                  i.tid = tid.tid AND
                                  i.trans_seq_nbr = t.trans_seq_nbr AND
                                  t.tga <> '3' AND
                                  i.sec_dest_inst_id in ($sql_inst) AND
                                  i.card_scheme in ('05')
                             group by rollup (i.sec_dest_inst_id, i.merch_id)
                             order by i.merch_id"

	puts " mc_international: $mc_international"
	orasql $header_cursorM1 $mc_international
	while {[orafetch $header_cursorM1 -dataarray mcout -indexbyname] != 1403} {

      	if { $mcout(INSTID) == "" && $mcout(MID) == "" } {
      		set mcnationscnt(ROLLUP) $mcout(CTRANCNT)
			set mcnationsamt(ROLLUP) $mcout(CTRANAMT)
			set mcnationccnt(ROLLUP) $mcout(DTRANCNT)
			set mcnationcamt(ROLLUP) $mcout(DTRANAMT)
		} elseif {$mcout(MID) == ""} {
			set mcnationscnt($mcout(INSTID)) $mcout(CTRANCNT)
			set mcnationsamt($mcout(INSTID)) $mcout(CTRANAMT)
			set mcnationccnt($mcout(INSTID)) $mcout(DTRANCNT)
			set mcnationcamt($mcout(INSTID)) $mcout(DTRANAMT)
		} else {
			set mcnationscnt($mcout(MID)) $mcout(CTRANCNT)
			set mcnationsamt($mcout(MID)) $mcout(CTRANAMT)
			set mcnationccnt($mcout(MID)) $mcout(DTRANCNT)
			set mcnationcamt($mcout(MID)) $mcout(DTRANAMT)
		}
	}

#     ******* VS Ecomm transactions ***********
#     only transaction_type I consider ecommerce txn


	#generate the VISA_ID's for the given institution*********************************************************
	set decode_routine ""
	set vbin_list ""
	set qry_VID "SELECT distinct INSTITUTION_ID, VISA_BIN from entity_to_auth where INSTITUTION_ID in ($sql_inst)"

	orasql $header_cursorM1 $qry_VID
	while {[orafetch $header_cursorM1 -dataarray vsid -indexbyname] != 1403} {
		set decode_routine "$decode_routine '$vsid(VISA_BIN)', '$vsid(INSTITUTION_ID)',"
		set vbin_list "$vbin_list '$vsid(VISA_BIN)',"
	}

	set vbin_list [string trimright $vbin_list ","]
	set decode_routine "decode(substr(merchant.VISA_ID,1,6), $decode_routine 'ROLLUP')"
	#***********************************************************************************************************

	set vs_ecomm "SELECT  /*+INDEX(t TRANHISTORY_SETTLE_DATE)*/  $decode_routine as instid,
						merchant.VISA_ID as EID,
						sum(case when (t.TRANSACTION_TYPE = 'I') then 1 else 0 end ) as ecommcnt,
						sum(case when (t.TRANSACTION_TYPE = 'R') then 1 else 0 end ) as retailcnt,
						sum(case when (t.REQUEST_TYPE = '0420') then 1 else 0 end ) as creditcnt,
						sum(case when (t.REQUEST_TYPE = '0420') then amount else 0 end ) as creditamt
					FROM tranhistory t, merchant, master_merchant
					WHERE t.mid = merchant.mid
						AND merchant.mmid = master_merchant.mmid
						AND master_merchant.shortname in ('JETPAY', 'JETPAYIS')
						AND t.settle_date >= '$strtDT_YYYYMMDD'
						AND t.settle_date < '$endDT_YYYYMMDD'
						AND t.card_type = 'VS'
						AND (t.REQUEST_TYPE = '0420' or t.TRANSACTION_TYPE in ('R','I'))
					GROUP BY rollup (substr(merchant.VISA_ID,1,6), merchant.VISA_ID)
					ORDER BY merchant.VISA_ID"

	orasql $header_cursorT1 $vs_ecomm
	puts "vs_ecomm: $vs_ecomm"
	while {[orafetch $header_cursorT1 -dataarray vse -indexbyname] != 1403} {


		if {$vse(INSTID) == "" && $vse(EID) == ""} {
			set vecommcnt(ROLLUP)  $vse(ECOMMCNT)
			set vretailcnt(ROLLUP) $vse(RETAILCNT)
			set vcreditcnt(ROLLUP) $vse(CREDITCNT)
			set vcreditamt(ROLLUP) $vse(CREDITAMT)
		} elseif {$vse(EID) == ""} {
			set vecommcnt($vse(INSTID))  $vse(ECOMMCNT)
			set vretailcnt($vse(INSTID)) $vse(RETAILCNT)
			set vcreditcnt($vse(INSTID)) $vse(CREDITCNT)
			set vcreditamt($vse(INSTID)) $vse(CREDITAMT)
		} else {
            set vecommcnt($vse(EID))  $vse(ECOMMCNT)
            set vretailcnt($vse(EID)) $vse(RETAILCNT)
            set vcreditcnt($vse(EID)) $vse(CREDITCNT)
            set vcreditamt($vse(EID)) $vse(CREDITAMT)
        }
	}

#     ******  Terminal Info  **********
# Q: do we need subtotals of terminal counts?

      set query_terminal "select  unique m.visa_id as VID, count(t.tid) as TERM_CNT
                            from teihost.terminal t, teihost.merchant m
                           where t.mid = m.mid and
                                 substr(m.visa_id, 1, 6) in ($vbin_list) and
                                 t.active = 'A'
                           group by m.visa_id
                           order by m.visa_id"
	puts $query_terminal
	orasql $header_cursorT1 $query_terminal
	while {[orafetch $header_cursorT1 -dataarray term -indexbyname] != 1403} {
		set termcnt($term(VID)) $term(TERM_CNT)
	}

# main? HAHAHAHAHAHAHAHHA..
#===============================================================================
#***    MAIN:     ***
#===============================================================================
    #set eid101 ""
    #set eid107 ""
    #set eidroll ""
    set cur_file_name "./ROLLUP.REPORT.HEADER.$CUR_JULIAN_DATEX.$name_date.$inst_label.001.csv"
    set file_name     "ROLLUP.REPORT.HEADER.$CUR_JULIAN_DATEX.$name_date.$inst_label.001.csv"
    set cur_file      [open "$cur_file_name" w]
    puts  "cur_file_name: $cur_file_name...report month year: $report_my... begin_nxt_month: $begin_nxt_month..."

    puts $cur_file "HEADER"
    puts $cur_file "Date:,$report_month"
    puts $cur_file " "
    puts $cur_file "ISO:,$inst_label"
    puts $cur_file " "
    # FIXME add legal name ae.entity_name and ae.tax_id to report
    set header_line "Merchant ID,Merchant DBA Name,Merchant Legal Name,Tax ID,YYYYMM"
    # set header_line "Merchant ID, Merchant Name,YYYYMM"
    set header_line "$header_line, Visa Count, Visa Gross Amount, Visa Credit Amount, Visa Net Amount"
    set header_line "$header_line, VS Drafts Ecomm CNT, VS Drafts Tranditional CNT"
    set header_line "$header_line, VS Credit Vouchers CNT, VS Credit Vouchers AMT"
    set header_line "$header_line, MC Count, MC Gross Amount, MC Credit Amount, MC Net Amount"
    set header_line "$header_line, MC International Purchase Cnt, MC International Purchase AMT"
    set header_line "$header_line, MC International Credit CNT, MC International Credit AMT"
    set header_line "$header_line, MC Domestic Credit CNT"
    set header_line "$header_line, DISC Count, DISC Gross Amount, DISC Credit Amount, DISC Net Amount"
    set header_line "$header_line, EBT Count, EBT Net Amount, Debit Count, Debit Gross Amount, Debit Credit Amount, Debit Net Amount"
    set header_line "$header_line, SIC Code, TAX ID,  ECI,#of Terminal, Status,Start Date, Termination DT, Chargeback Count"
    set header_line "$header_line, Chargeback Volume, Representment Count, Representment Volume, Merch Reserve Balance,Address,city,state,zip\r\n"
    puts $cur_file $header_line
    puts "Header: $report_my"

	foreach en $eid {
		if {![info exists tax($en)]} 		{set tax($en) 			0}
		if {![info exists arrchgcnt($en)]}	{set arrchgcnt($en) 	0}
		if {![info exists arrchgamt($en)]}	{set arrchgamt($en)		0}
		if {![info exists arrrepcnt($en)]}	{set arrrepcnt($en)		0}
		if {![info exists arrrepamt($en)]}	{set arrrepamt($en)		0}
		if {![info exists arrmccnt($en)]}	{set arrmccnt($en)		0}
		if {![info exists killdate($en)]}	{set killdate($en)		0}
		if {![info exists arrvscnt($en)]}	{set arrvscnt($en)		0}
		if {![info exists arrvsamt($en)]}	{set arrvsamt($en)		0}
		if {![info exists arrvscamt($en)]}	{set arrvscamt($en)		0}
		if {![info exists arrvsnet($en)]}	{set arrvsnet($en)		0}
		if {![info exists arrmcamt($en)]}	{set arrmcamt($en)		0}
		if {![info exists arrmccamt($en)]}	{set arrmccamt($en)		0}
		if {![info exists arrmcccnt($en)]}	{set arrmcccnt($en)		0}
		if {![info exists arrmcnet($en)]}	{set arrmcnet($en)		0}
		if {![info exists arrreserve($en)]}	{set arrreserve($en)	0}
		if {![info exists mrej($en)]}		{set mrej($en)			0}
		if {![info exists vrej($en)]}		{set vrej($en)			0}
		if {![info exists brej($en)]}		{set brej($en)			0}
		if {![info exists termcnt($en)]}	{set termcnt($en)		0}
		if {![info exists arrdbcnt($en)]}	{set arrdbcnt($en)		0}
		if {![info exists arrdbamt($en)]}	{set arrdbamt($en)		0}
		if {![info exists arrdbcamt($en)]}	{set arrdbcamt($en)		0}
		if {![info exists arrdbnet($en)]}	{set arrdbnet($en)		0}

		if {![info exists arrdscnt($en)]}	{set arrdscnt($en)		0}
		if {![info exists arrdsamt($en)]}	{set arrdsamt($en)		0}
		if {![info exists arrdscamt($en)]}	{set arrdscamt($en)		0}
		if {![info exists arrdsnet($en)]}	{set arrdsnet($en)		0}
		if {![info exists drej($en)]}		{set drej($en)			0}

		if {![info exists vecommcnt($en)]}		{set vecommcnt($en)		0}
		if {![info exists vretailcnt($en)]}		{set vretailcnt($en)	0}
		if {![info exists vcreditcnt($en)]} 	{set vcreditcnt($en)	0}
		if {![info exists vcreditamt($en)]}		{set vcreditamt($en)	0}
		if {![info exists mcnationscnt($en)]}	{set mcnationscnt($en)	0}
		if {![info exists mcnationsamt($en)]}	{set mcnationsamt($en)	0}
		if {![info exists mcnationccnt($en)]}	{set mcnationccnt($en)	0}
		if {![info exists mcnationcamt($en)]}	{set mcnationcamt($en)	0}

		#set the reserve total for the institution to be the sum of entities included in this report
		if {![info exists arrreserve($eidToInstit($en))]} {set arrreserve($eidToInstit($en)) 0}

		set arrreserve($eidToInstit($en)) [expr $arrreserve($eidToInstit($en)) + $arrreserve($en)]

        # FIXME add legal name ae.entity_name and ae.tax_id (arrlglname & arrtaxid) to report
        set entry_data " $en,$arrname($en),$arrlglname($en),$arrtaxid($en),$report_date ,$arrvscnt($en)"
        # set entry_data " $en,$arrname($en),$report_date ,$arrvscnt($en)"
        set entry_data "$entry_data, $arrvsamt($en),$arrvscamt($en)"
        set entry_data "$entry_data, $arrvsnet($en)"
        set entry_data "$entry_data, $vecommcnt($en), $vretailcnt($en)"
        set entry_data "$entry_data, $vcreditcnt($en), $vcreditamt($en)"
        set entry_data "$entry_data, $arrmccnt($en) "
        set entry_data "$entry_data, $arrmcamt($en),$arrmccamt($en), $arrmcnet($en)"
        set entry_data "$entry_data, $mcnationscnt($en), $mcnationsamt($en)"
        set entry_data "$entry_data, $mcnationccnt($en), $mcnationcamt($en), [expr $arrmcccnt($en)- $mcnationccnt($en)]"
        set entry_data "$entry_data, $arrdscnt($en), $arrdsamt($en),$arrdscamt($en), $arrdsnet($en)"
        set entry_data "$entry_data, , ,$arrdbcnt($en)"
        set entry_data "$entry_data, $arrdbamt($en),$arrdbcamt($en)"
        set entry_data "$entry_data, $arrdbnet($en),$arrmcc($en),$tax($en), $arrtype($en)"
        set entry_data "$entry_data, $termcnt($en), $arrstatus($en),$arrdate($en),$killdate($en)"
        set entry_data "$entry_data, $arrchgcnt($en), $arrchgamt($en), $arrrepcnt($en), $arrrepamt($en)"
        set entry_data "$entry_data, $arrreserve($en) ,$arradr($en), $arrcity($en),$arrst($en),$arrzip($en)\r"
        puts $cur_file $entry_data

	}

	foreach in $inst_label {
		if {![info exists arrvscnt($in)]}		{set arrvscnt($in)		0}
		if {![info exists arrvsamt($in)]}		{set arrvsamt($in)		0}
		if {![info exists arrvscamt($in)]}		{set arrvscamt($in)		0}
		if {![info exists arrvsnet($in)]}		{set arrvsnet($in)		0}
		if {![info exists vecommcnt($in)]}		{set vecommcnt($in)		0}
		if {![info exists vretailcnt($in)]}		{set vretailcnt($in)	0}
		if {![info exists vcreditcnt($in)]}		{set vcreditcnt($in)	0}
		if {![info exists vcreditamt($in)]}		{set vcreditamt($in)	0}
		if {![info exists arrmccnt($in)]}		{set arrmccnt($in)		0}
		if {![info exists arrmcamt($in)]}		{set arrmcamt($in)		0}
		if {![info exists arrmccamt($in)]}		{set arrmccamt($in)		0}
		if {![info exists arrmcnet($in)]}		{set arrmcnet($in)		0}
		if {![info exists mcnationscnt($in)]}	{set mcnationscnt($in)	0}
		if {![info exists mcnationsamt($in)]}	{set mcnationsamt($in)	0}
		if {![info exists mcnationccnt($in)]}	{set mcnationccnt($in)	0}
		if {![info exists mcnationcamt($in)]}	{set mcnationcamt($in)	0}
		if {![info exists arrmcccnt($in)]}		{set arrmcccnt($in)		0}
		if {![info exists mcnationccnt($in)]}	{set mcnationccnt($in)	0}
		if {![info exists arrdscnt($in)]}		{set arrdscnt($in)		0}
		if {![info exists arrdsamt($in)]}		{set arrdsamt($in)		0}
		if {![info exists arrdscamt($in)]}		{set arrdscamt($in)		0}
		if {![info exists arrdsnet($in)]}		{set arrdsnet($in)		0}
		if {![info exists arrdbcnt($in)]}		{set arrdbcnt($in)		0}
		if {![info exists arrdbamt($in)]}		{set arrdbamt($in)		0}
		if {![info exists arrdbcamt($in)]}		{set arrdbcamt($in)		0}
		if {![info exists arrdbnet($in)]}		{set arrdbnet($in)		0}
		if {![info exists arrchgcnt($in)]}		{set arrchgcnt($in)		0}
		if {![info exists arrchgamt($in)]}		{set arrchgamt($in)		0}
		if {![info exists arrrepcnt($in)]}		{set arrrepcnt($in)		0}
		if {![info exists arrrepamt($in)]}		{set arrrepamt($in)		0}
		if {![info exists arrreserve($in)]}		{set arrreserve($in)	0}

		# FIXME add legal name ae.entity_name and ae.tax_id to report
		set entry_data " SUBTOTAL,,,,,$arrvscnt($in)"
		# set entry_data " SUBTOTAL,,,$arrvscnt($in)"
		set entry_data "$entry_data, $arrvsamt($in),$arrvscamt($in)"
		set entry_data "$entry_data, $arrvsnet($in)"
		set entry_data "$entry_data, $vecommcnt($in), $vretailcnt($in)"
		set entry_data "$entry_data, $vcreditcnt($in), $vcreditamt($in)"
		set entry_data "$entry_data, $arrmccnt($in) "
		set entry_data "$entry_data, $arrmcamt($in),$arrmccamt($in), $arrmcnet($in)"
		set entry_data "$entry_data, $mcnationscnt($in), $mcnationsamt($in)"
		set entry_data "$entry_data, $mcnationccnt($in), $mcnationcamt($in), [expr $arrmcccnt($in)- $mcnationccnt($in)]"
		set entry_data "$entry_data, $arrdscnt($in), $arrdsamt($in),$arrdscamt($in), $arrdsnet($in)"
		set entry_data "$entry_data, , ,$arrdbcnt($in)"
		set entry_data "$entry_data, $arrdbamt($in),$arrdbcamt($in)"
		set entry_data "$entry_data, $arrdbnet($in),,,"
		set entry_data "$entry_data, ,,,"
		set entry_data "$entry_data, $arrchgcnt($in), $arrchgamt($in), $arrrepcnt($in), $arrrepamt($in)"
		set entry_data "$entry_data, $arrreserve($in) ,, ,,\r"
		puts $cur_file $entry_data
	}




  close $cur_file
  puts $cur_file_name
}
  #exec echo "Merrick Header report - $file_name" | mutt -F /clearing/filemgr/.clearing_muttrc -a $cur_file_name -- $mailtolist

######
#MAIN
#####

if { $argc == 0 } {
	date_init
} elseif { $argc == 1 } {
	if {[string length [lindex $argv 0]] == 3 } {
		set institution [lindex $argv 0]
		date_init
	} else {

		set dt_arg         [lindex $argv 0]
		if { [string length $dt_arg ] != 8 } {
			puts "REPORT DATE SHOULD BE 8 DIGITS: (format like 20080331 ) "
			set dt_arg [gets stdin]
		}
		date_init_from_val $dt_arg
	}
} elseif { $argc == 2 } {
	set institution [lindex $argv 0]
	set dt_arg [lindex $argv 1]
	if { [string length $dt_arg ] != 8 } {
		puts "REPORT DATE SHOULD BE 8 DIGITS: (format like 20080331 ) "
		set dt_arg [gets stdin]
	}
	date_init_from_val $dt_arg
}

set begin_nxt_month [clock format [clock scan "01-$report_my +1 month"] -format %d-%b-%Y]
set endDT_YYYYMMDD "[clock format [clock scan "01-$report_my +1 month"] -format %Y%m%d]000000"
set strtDT_YYYYMMDD "[clock format [clock scan "01-$report_my"] -format %Y%m%d]000000"

if {$institution == "ALL"} {
	set institution "101,107,112"
}

do_report $institution

oraclose $header_cursorM1
oraclose $header_cursorT1
oralogoff $handlerM
oralogoff $handlerT

# *******************************************************     END        **********************************************************
