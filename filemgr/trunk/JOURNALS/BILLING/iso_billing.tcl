#!/usr/bin/env tclsh

package require Oratcl

##
# Always gonna be transclr4 because of the GetReporting User counts
#set clrdb trnclr4
set clrdb $env(CLR4_DB)
###%%%%%%%%%%%%%%%%%%%%%%%%%###

set authdb $env(TSP4_DB)

set mailfromlist "ajohn@jetpay.com"
set mailto_error "ajohn@jetpay.com"

##
# To add a new Column, 
# 1). Add column_name and description to this list
# 2). Add query to set this column for each entity
# 
# The script will automatically init this value for each entity,
# calculate the subtotal for this column (if numeric 'n') and,
# output the data to the csv in the column order listed
###
set report_data_lst {
					{ACH_CNT "ACH Count" n}
					{NET_SALES_AMT "Net Sales Amount" n}
					{GROSS_SALES_AMT "Gross Sales Amount" n}
					{SALES_CNT "Sales Count" n}
					{SALES_REFUNDS "Sales Refunds" n}
					{RETURNS_CNT "Returns Count" n}
					{DISCOUNT "Discount Charged" n}
					{FANF_FEES "FANF Fee Amount" n}
					{CP_COUNT "Card Present Count" n}
					{CP_AMOUNT "Card Present Amount" n}
					{CNP_COUNT "Card Not Present Count" n}
					{CNP_AMOUNT "Card Not Present Amount" n}
					{CP_CNP_TOTAL_COUNT "TEMP COL CPCNP TOTAL" n}
					{BILLING_TYPE "Billing Type" a}
					{INTERCHANGE_AMT "Interchange" n}
					{REPRESENTMENT_AMT "Representments" n}
					{CHARGEBK_AMT "Chargeback Amount" n}
					{CHARGEBK_CNT "Chargeback Count" n}
					{REPR_FOR_REIMBURSE_AMT "Representments for reimbursements" n}
					{VS_ASSESS_AMT "Visa Assessments" n}
					{VS_FEE_COLLCT "Visa Fee Collection" n}
					{VS_ISA "Visa ISA Fee" n}
					{MC_ASSESS_AMT "Mastercard Assessments" n}
					{MC_FEE_COLLCT "Mastercard Fee Collection" n}
					{DISC_III_I_SALES "Discover Sales" n}
					{DISC_DISCOUNT_CHARGE "Discover Discount Charge" n}
					{DISC_INTERCHANGE_AMT "Discover Interchange" n}
					{DISC_DISPUTES "Discover Disputes" n}
					{DISC_ASSESS_AMT "Discover Assessments" n}
					{VS_ARBITRATION_AMT "Visa Arbitration Amount" n}
					{RETRIEVAL_REQS "Retrieval Requests" n}
					{AUTH_COUNTS "Auth Counts" n}
					{DIALUP_TERM_COUNTS "Dialup Terminal Counts" n}
					{DIALUP_TRANS_COUNTS "Dialup Transaction Counts" n}
					{FRAUD_COUNT "Fraud Counts" n}
					{TSYS_COUNTS "TSYS Counts" n}
					{GET_REP_USERS "GetReporting User counts" n}
					}
###



proc mailsend { email_subject email_recipient email_sender email_body } {
	set temp_value ""
	regsub -all "\:" $email_body "\072" temp_value
    
	exec echo "$temp_value" | mailx -r $email_sender -s "$email_subject" $email_recipient
	#exec echo "$temp_value" |  mail -s "$email_subject" $email_recipient -- -r "$email_sender"
}

proc arg_parse {} {
	global argv institutions_arg date_arg

	#scan for Date
	if { [regexp -- {(-[dD])[ ]+([0-9]{8,8})} $argv dummy1 dummy2 arg_date] } {
		puts "Date argument: $arg_date"
		set date_arg $arg_date
	}

	#scan for Institution
	# ONLY ONE INSTITUTION IS EXPECTED HERE..
	set institutions_arg ""
	set numInst 0
	set numInst [regexp -- {-[iI][ ]+([0-9]{3})} $argv]
    
	if { $numInst > 0 } {
	
	 	set res_lst [regexp -inline -- {-[iI][ ]+([0-9]{3})} $argv]
	 	
	 	for {set x 0} {$x<$numInst} {incr x} {
	 		set institutions_arg "$institutions_arg [lrange $res_lst [expr ($x * 2) + 1] [expr ($x * 2) + 1]]"
	 	}
		
		set institutions_arg [string trim $institutions_arg]
		puts "Institutions: $institutions_arg"
	}
}

proc init_dates {val} {
	global date date_my filedate today next_mnth_my CUR_JULIAN_DATEX date_strt_frontend next_mnth_frontend
	set date    [string toupper [clock format [clock scan "$val"] -format %d-%b-%Y]] 
	set date_my     [string toupper [clock format [clock scan " $date -0 day"] -format %b-%Y]]     ;# MAR-2012
	set next_mnth_my     [string toupper [clock format [clock scan "01-$date_my +1 month"] -format %b-%Y]]     ;# APR-2012
	set date_strt_frontend    [clock format [clock scan "$date -0 day"] -format %Y%m%d%H%M%S]     ;# 20120809204501
	set next_mnth_frontend    [clock format [clock scan "01-$date_my +1 month"] -format %Y%m%d%H%M%S]     ;# 20120809204501
	set filedate  [clock format   [clock scan " $date -0 day"] -format %Y%m]                     ;# 20080321
	set today     [string toupper [clock format [clock scan " $date +0 day"] -format %d-%b-%Y]]
}

if {[catch {set handleC [oralogon masclr/masclr@$clrdb]} result]} {
  mailsend "iso_billing.tcl failed to run" $mailto_error $mailfromlist "iso_billing.tcl failed to run\n$result" 
  exit
}

if {[catch {set handleA [oralogon teihost/quikdraw@$authdb]} resultauth ]} {
  mailsend "iso_billing.tcl failed to run" $mailto_error $mailfromlist "iso_billing.tcl failed to run\n$result"
  exit
}

set cursor_C  [oraopen $handleC]
set cursor_A [oraopen $handleA]

proc do_report {} {
	global cursor_C cursor_A
	global date_my next_mnth_my institutions_arg filedate report_data_lst
	global date_strt_frontend next_mnth_frontend

	set sql_inst $institutions_arg

	set entity_qry	"select Entity_id, Entity_dba_Name, Entity_Name, institution_id, billing_type
						from MASCLR.acq_entity
						where institution_id in ($sql_inst)
						and ((entity_status = 'A')  or (entity_status = 'C' and (termination_date-90)  > '01-$date_my'))
						order by entity_id"

	puts "Fetching active merchant list"
	orasql $cursor_C $entity_qry
	
	while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {		

		##
		#  eid_list is the list of entities included in this report
		# 	It's elements are in the form: 'institution_ID'.'Entity_ID'
		###
		lappend eid_list "$row(INSTITUTION_ID).$row(ENTITY_ID)"
		
		#This allows us to easily check if an entity is part of the report by using 'info exists'
		set report_entities($row(INSTITUTION_ID).$row(ENTITY_ID)) 1
		
		set repdata($row(INSTITUTION_ID).$row(ENTITY_ID).DBA_NAME) [string map {"," "."} $row(ENTITY_DBA_NAME)]
		set repdata($row(INSTITUTION_ID).$row(ENTITY_ID).NAME) [string map {"," "."} $row(ENTITY_NAME)]
		set repdata($row(INSTITUTION_ID).$row(ENTITY_ID).BILLING_TYPE) $row(BILLING_TYPE)
	}
	
	##
	#Get frontend mids needed later for all auth queries
	###
	set ent_to_auth_qry "select institution_id, entity_id, mid
					from entity_to_auth 
					where institution_id in ($sql_inst)"

	set mids(0) ""

	set mid_lst_indx 0
	set cur_indx_in_lst 0

	orasql $cursor_C $ent_to_auth_qry

	while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
	
		lappend mids($mid_lst_indx) $row(MID)
		
		#This will be used later to link mids to their entity for the report
		set ENTITY $row(INSTITUTION_ID).$row(ENTITY_ID)
		set mid_to_entity($row(MID)) $ENTITY
	
		#We limit the count of mids per var below 1000
		#Oracle complains if the <where foo in ('1','2'...)
		#contains more than 1000 elements>
		if {$cur_indx_in_lst >= 999} {
		
			incr mid_lst_indx
			set cur_indx_in_lst 0
		} else {
			incr cur_indx_in_lst
		}
	}
	
	#init report data
	foreach col $report_data_lst {
	
		if {[lindex $col 2] == "n"} {
			foreach eid $eid_list {
				set repdata($eid.[lindex $col 0])	0
			}
		
			set repdata(SUB.[lindex $col 0])	0
		} else {
			foreach eid $eid_list {
				if {![ info exists repdata($eid.[lindex $col 0]) ]} {set repdata($eid.[lindex $col 0])	""}
			}
		}
	}
	
	puts "Fetching sales data"
	set IS_SALES "tid in ('010003005102', '010003005101', '010003005201', '010003005202', '010003005104','010003005204')"

	set sales_qry "select entity_id, institution_id, 
				sum(case when tid_settl_method = 'C' then amt_original else 0 end) as sales_C_amt,
				sum(case when tid_settl_method <> 'C' then amt_original else 0 end) as sales_D_amt, 
				sum(case when (tid = '010003005102' and tid_settl_method <> 'C') then -1*amt_original 
						 when (tid = '010003005102' and tid_settl_method = 'C') then amt_original
							else 0 end) as SALES_REFUNDS,
				sum(case when tid_settl_method = 'C' then 1 else 0 end) as Sales_Count,
				sum(case when tid_settl_method <> 'C' then 1 else 0 end) as Returns_Count
				FROM masclr.mas_trans_log 
				WHERE $IS_SALES
					and gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my'
					and card_scheme in ('02','03','09','04','08', '05') 
					and settl_flag = 'Y' 
					and institution_id in ($sql_inst)
				group by entity_id, institution_id 
				order by entity_id"
	
	orasql $cursor_C $sales_qry
				
	while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
	
		set ENTITY $row(INSTITUTION_ID).$row(ENTITY_ID)
				
		if {[info exists report_entities($ENTITY)]} {
			
			set repdata($ENTITY.NET_SALES_AMT) 		[expr $row(SALES_C_AMT) - $row(SALES_D_AMT)]
			set repdata($ENTITY.GROSS_SALES_AMT) 	$row(SALES_C_AMT)
			set repdata($ENTITY.SALES_CNT) 			$row(SALES_COUNT)
			set repdata($ENTITY.RETURNS_CNT) 		$row(RETURNS_COUNT)
			set repdata($ENTITY.SALES_REFUNDS)		$row(SALES_REFUNDS)
		}
	}
	
	puts "Fetching card present/card not present"
	set IS_SALES "m.tid in ('010003005102', '010003005101', '010003005201', '010003005202', '010003005104','010003005204')"

set presentNotpresent_qry "SELECT m.institution_id, m.entity_id, 
	SUM(CASE 	WHEN (m.tid_settl_method = 'C' and i.pos_crd_present = '1') Then m.amt_original 
				WHEN (m.tid_settl_method = 'D' and i.pos_crd_present = '1') Then -1*m.amt_original else 0 end) AS CP_AMOUNT, 
	SUM(CASE 	WHEN (m.tid_settl_method = 'C' and (i.pos_crd_present <> '1' or i.pos_crd_present is null )) Then m.amt_original 
				WHEN (m.tid_settl_method = 'D' and (i.pos_crd_present <> '1' or i.pos_crd_present is null )) Then -1*m.amt_original else 0 end) AS CNP_AMOUNT, 
	SUM(CASE WHEN (i.pos_crd_present = '1') Then 1 else 0 end ) AS CP_COUNT, 
	SUM(CASE WHEN (i.pos_crd_present <> '1' or i.pos_crd_present is null ) Then 1 else 0 end ) AS CNP_COUNT, 
	count(1) AS CP_CNP_TOTAL_COUNT 
	FROM masclr.mas_trans_log m, masclr.in_draft_main i 
	WHERE m.institution_id in ($sql_inst)
	and m.trans_ref_data = i.arn 
	and to_number(m.external_trans_nbr) = to_char(i.trans_seq_nbr) 
	and m.trans_sub_seq = '0'
	and $IS_SALES
	and m.gl_date >= '01-$date_my' and m.gl_date < '01-$next_mnth_my'
	and m.settl_flag = 'Y' 
	group by m.institution_id, m.entity_id"

	orasql $cursor_C $presentNotpresent_qry
				
	while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
	
		set ENTITY $row(INSTITUTION_ID).$row(ENTITY_ID)
				
		if {[info exists report_entities($ENTITY)]} {
			
			set repdata($ENTITY.CP_AMOUNT) 			$row(CP_AMOUNT)
			set repdata($ENTITY.CNP_AMOUNT) 		$row(CNP_AMOUNT)
			set repdata($ENTITY.CP_COUNT) 			$row(CP_COUNT)
			set repdata($ENTITY.CNP_COUNT) 			$row(CNP_COUNT)
			set repdata($ENTITY.CP_CNP_TOTAL_COUNT)	$row(CP_CNP_TOTAL_COUNT)
		}
	}

	
	puts "Fetching ACH Counts"
	#Probably need to move this inside someother qry that uses acct_accum_detail
	set ach_cnt_qry "SELECT ea.institution_id, ea.owner_entity_id ENTITY_ID, COUNT(1) AS ACH_CNT
					FROM masclr.acct_accum_det a, masclr.entity_acct ea
					WHERE (ea.entity_acct_id = a.entity_acct_id and ea.institution_id = a.institution_id)
						and a.payment_status = 'P'
						and a.institution_id in ($sql_inst)
						and a.payment_proc_dt >= '01-$date_my' and a.payment_proc_dt < '01-$next_mnth_my'
					GROUP BY ea.institution_id, ea.owner_entity_id"
	
	orasql $cursor_C $ach_cnt_qry
				
	while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
	
		set ENTITY $row(INSTITUTION_ID).$row(ENTITY_ID)
				
		if {[info exists report_entities($ENTITY)]} {
			set repdata($ENTITY.ACH_CNT) 	$row(ACH_CNT)
		}
	}
	
	puts "Fetching Assessments"
	set assess_qry "SELECT institution_id, entity_id, 
		sum(case when (card_scheme ='08' and tid_settl_method <> 'C') then amt_original 
			when (card_scheme ='08' and tid_settl_method = 'C') then amt_original * -1 else 0 end) as DSC_ASSESS_AMT,
		sum( case when (tid_settl_method <> 'C' and card_scheme = '04') then amt_original 
			when (tid_settl_method = 'C' and card_scheme = '04') then amt_original * -1 else 0 end) as VS_ASSESS_AMT, 
		sum( case when (tid_settl_method <> 'C' and card_scheme = '05') then amt_original 
			when (tid_settl_method = 'C' and card_scheme = '05') then amt_original * -1 else 0 end) as MC_ASSESS_AMT 
		FROM masclr.mas_trans_log 
		WHERE gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my'
			and tid in ( '010004030000' ,'010004030005','010004030001') 
			and card_scheme in ('04','05','08') 
			and institution_id in ($sql_inst)
		GROUP BY institution_id,entity_id"
	
	orasql $cursor_C $assess_qry
	
	while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
	
		set ENTITY $row(INSTITUTION_ID).$row(ENTITY_ID)
		
		if {[info exists report_entities($ENTITY)]} {
			
			set repdata($ENTITY.DISC_ASSESS_AMT)	$row(DSC_ASSESS_AMT)
			set repdata($ENTITY.VS_ASSESS_AMT)		$row(VS_ASSESS_AMT)
			set repdata($ENTITY.MC_ASSESS_AMT)		$row(MC_ASSESS_AMT)
		}
	}
	
	puts "Fetching Disc MAP_Phase I & III"
	set IS_MERCH_FEE "(substr(m.tid, 1,8) = '01000507' OR substr(m.tid, 1,6) in ('010004'))"
	set IS_DISPUTE "m.tid in ('010003005301', '010003005401', '010003015201', '010003015102', '010003015101')"
	
	set disc_sales_qry "SELECT m.entity_id, m.institution_id, 
				(SUM( CASE WHEN m.tid_settl_method = 'C' and $IS_SALES then m.AMT_ORIGINAL else 0 end ) 
					- SUM( CASE WHEN m.tid_settl_method = 'D' and $IS_SALES then m.AMT_ORIGINAL else 0 end)) as DISC_III_I_SALES,
				(SUM(CASE WHEN( $IS_MERCH_FEE and m.tid_settl_method = 'D') then m.AMT_ORIGINAL else 0 end ) 
					- SUM(CASE WHEN( $IS_MERCH_FEE and m.tid_settl_method = 'C') then m.AMT_ORIGINAL else 0 end )) as DISCOUNT_CHARGE, 
				(SUM(CASE WHEN( m.tid in ('010004020000','010004020005') and m.tid_settl_method = 'D' ) then m.AMT_ORIGINAL else 0 end) 
					-  SUM(CASE WHEN(m.tid in ('010004020000','010004020005') and m.tid_settl_method = 'C' ) then m.AMT_ORIGINAL else 0 end)) as INTERCHANGE_AMT,
				SUM( CASE WHEN m.tid_settl_method = 'D' and $IS_DISPUTE then m.AMT_ORIGINAL else 0 end) as DISC_DISPUTES
				FROM mas_trans_log m join acq_entity ae on (m.entity_id=ae.entity_id and m.institution_id = ae.institution_id), merchant_flag mf 
				WHERE (m.entity_id = mf.entity_id and m.institution_id = mf.institution_id)
					and m.institution_id in ($sql_inst)
					and m.card_scheme = '08' 
					and (mf.flag_type = 'MAP_PHASE3' or (mf.flag_type = 'MAP_PHASE1' and ae.creation_date < '01-MAY-2010')) 
					and gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my' 
					and ($IS_SALES OR $IS_MERCH_FEE OR $IS_DISPUTE)
					and substr(tid, 0, 8) <> '01000428'
				GROUP BY m.entity_id, m.institution_id"
	
	orasql $cursor_C $disc_sales_qry
				
	while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
	
		set ENTITY $row(INSTITUTION_ID).$row(ENTITY_ID)
				
		if {[info exists report_entities($ENTITY)]} {
			set repdata($ENTITY.DISC_III_I_SALES) $row(DISC_III_I_SALES)
			set repdata($ENTITY.DISC_DISCOUNT_CHARGE) $row(DISCOUNT_CHARGE)
			set repdata($ENTITY.DISC_INTERCHANGE_AMT) $row(INTERCHANGE_AMT)
			set repdata($ENTITY.DISC_DISPUTES) $row(DISC_DISPUTES)
		}
	}
	
	puts "Fetching Arbitration amounts"
	set arb_qry "select institution_id, entity_id, 
					sum(case when (mas_code = '04ARBCRDT') then amt_original else amt_original* -1 end) as VS_ARB_AMT 
				FROM mas_trans_log 
				WHERE mas_code in ('04ARBCRDT','04ARBDBT') 
					and gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my'
					and institution_id in ($sql_inst)
				GROUP BY institution_id, entity_id"
	
	orasql $cursor_C $arb_qry
	
	while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
		
		set ENTITY $row(INSTITUTION_ID).$row(ENTITY_ID)
		
		if {[info exists report_entities($ENTITY)]} {
			set repdata($ENTITY.VS_ARBITRATION_AMT) $row(VS_ARB_AMT)
		}
	}
	
	puts "Fetching Visa ISA"
	set vs_isa_qry "select institution_id, entity_id, sum(amt_original) as VS_ISA_AMT 
					FROM mas_trans_log
					WHERE tid = '010004330000'
						and mas_code = 'VS_ISA_FEE'
						and institution_id in ($sql_inst)
						and ((gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my') or 
								(date_to_settle >= '01-$date_my' and date_to_settle < '01-$next_mnth_my'))
					GROUP BY institution_id, entity_id"
	
	orasql $cursor_C $vs_isa_qry
				
	while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
	
		set ENTITY $row(INSTITUTION_ID).$row(ENTITY_ID)
		
		if {[info exists report_entities($ENTITY)]} {
			set repdata($ENTITY.VS_ISA) $row(VS_ISA_AMT)
		}
	}
	
	puts "Fetching Visa and MC Fee Collection"
	set fee_collct_qry "SELECT institution_id, entity_id,
							SUM( CASE WHEN SUBSTR(mas_code,1,2) = 'MC' then amt_original else 0 END) AS MC_FEE_COLLCT,
							SUM( CASE WHEN SUBSTR(mas_code,1,2) = 'VS' then amt_original else 0 END) AS VS_FEE_COLLCT
						FROM mas_trans_log
						WHERE mas_code IN ('MC_BORDER','MC_GLOBAL_ACQ','VS_ISA_FEE','VS_ISA_HI_RISK_FEE','VS_INT_ACQ_FEE')
							and (substr(tid, 1,8) = '01000507' OR substr(tid, 1,6) in ('010004','010040','010050','010080','010014'))
							and gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my'
							and institution_id in ($sql_inst)
						GROUP BY institution_id, entity_id"

	orasql $cursor_C $fee_collct_qry
	
	while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
	
		set ENTITY $row(INSTITUTION_ID).$row(ENTITY_ID)
		
		if {[info exists report_entities($ENTITY)]} {
			set repdata($ENTITY.VS_FEE_COLLCT) $row(VS_FEE_COLLCT)
			set repdata($ENTITY.MC_FEE_COLLCT) $row(MC_FEE_COLLCT)
		}
	}
	
	puts "Fetching Representments"
	set repr_qry "SELECT institution_id, entity_id, 
					sum(CASE WHEN( tid in ('010003005301', '010003005401') and TID_SETTL_METHOD = 'C') then AMT_ORIGINAL 
							 WHEN( tid in ('010003005301', '010003005401') and TID_SETTL_METHOD <> 'C') then -1*AMT_ORIGINAL 
							 else 0 end) as REPRESENTMENT_AMT,
					sum(CASE WHEN( tid in ('010003010102', '010003010101') and TID_SETTL_METHOD = 'C') then AMT_ORIGINAL 
							 WHEN( tid in ('010003010102', '010003010101') and TID_SETTL_METHOD <> 'C') then -1*AMT_ORIGINAL 
							 else 0 end) as REPR_FOR_REIMBURSE_AMT
				FROM mas_trans_log
				WHERE gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my'
					and settl_flag = 'Y'
					and institution_id in ($sql_inst)
					and TID in ('010003005301', '010003005401', '010003010102', '010003010101')
				GROUP BY institution_id, entity_id"

	orasql $cursor_C $repr_qry
	
	while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
	
		set ENTITY $row(INSTITUTION_ID).$row(ENTITY_ID)
		
		if {[info exists report_entities($ENTITY)]} {
			set repdata($ENTITY.REPRESENTMENT_AMT) $row(REPRESENTMENT_AMT)
			set repdata($ENTITY.REPR_FOR_REIMBURSE_AMT) $row(REPR_FOR_REIMBURSE_AMT)
		}
	}
	
	puts "Fetching Chargebacks"
	set IS_CHRGBK "TID in ('010003010101', '010003010102', '010003015101','010003015102','010003015201','010003015210','010003015301')"

	set chrgbk_qry "SELECT institution_id, entity_id,
					sum(CASE WHEN( TID_SETTL_METHOD = 'C') then AMT_ORIGINAL
							WHEN( TID_SETTL_METHOD <> 'C') then -1*AMT_ORIGINAL else 0 end) as CHARGEBK_AMT,
					SUM(case when amt_original <> 0 then 1 else 0 end) as CHARGEBK_CNT
					FROM masclr.mas_trans_log
					WHERE gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my'
					and $IS_CHRGBK
					and institution_id in ($sql_inst)
					GROUP BY institution_id, entity_id"
	
	orasql $cursor_C $chrgbk_qry
	
	while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
	
		set ENTITY $row(INSTITUTION_ID).$row(ENTITY_ID)
		
		if {[info exists report_entities($ENTITY)]} {
			set repdata($ENTITY.CHARGEBK_AMT) $row(CHARGEBK_AMT)
			set repdata($ENTITY.CHARGEBK_CNT) $row(CHARGEBK_CNT)
		}
	}
	
	puts "Fetching Discount"
	set discnt_qry "SELECT institution_id, entity_id,
					sum(CASE WHEN m.tid_settl_method = 'D' then m.AMT_billing 
							WHEN m.tid_settl_method <> 'D' then -1*m.AMT_billing else 0 end) as DISCOUNT
					FROM masclr.mas_trans_log m
					WHERE gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my'
						and (substr(m.tid, 1,8) = '01000507' OR substr(m.tid, 1,6) in ('010004','010040','010050','010080','010014'))
						and substr(m.tid,1,8) <> '01000428'
						and institution_id in ($sql_inst)
					GROUP BY institution_id, entity_id"
	
	orasql $cursor_C $discnt_qry
	
	while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
	
		set ENTITY $row(INSTITUTION_ID).$row(ENTITY_ID)
		
		if {[info exists report_entities($ENTITY)]} {
			set repdata($ENTITY.DISCOUNT) $row(DISCOUNT)
		}
	}
	
	puts "Fetching FANF"
	set fanf_qry "SELECT institution_id, entity_id, 
					sum(CASE 	WHEN (TID_SETTL_METHOD = 'C') then AMT_ORIGINAL 
								WHEN(TID_SETTL_METHOD <> 'C') then -1*AMT_ORIGINAL else 0 end) as FANF_FEES
					FROM masclr.mas_trans_log 
					WHERE gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my'
					and settl_flag = 'Y'
					and institution_id in ($sql_inst)
					and substr(mas_code,1,4) = 'FANF'
					GROUP BY institution_id, entity_id"
	
	orasql $cursor_C $fanf_qry
	
	while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
	
		set ENTITY $row(INSTITUTION_ID).$row(ENTITY_ID)
		
		if {[info exists report_entities($ENTITY)]} {
			set repdata($ENTITY.FANF_FEES) $row(FANF_FEES)
		}
	}
	
	puts "Fetching Interchange"
	set interchg_qry "select mtl.institution_id, mtl.entity_id, ae.billing_type,
						sum( case when (ae.billing_type = 'PT' and mtl.settl_flag = 'Y' and mtl.tid_settl_method ='D') then mtl.amt_original 
									when (ae.billing_type = 'PT' and mtl.settl_flag = 'Y' and mtl.tid_settl_method = 'C') then -1*mtl.amt_original
									when (ae.billing_type = 'BT' and mtl.settl_flag = 'N' and mtl.tid_settl_method ='D') then mtl.amt_original
									when (ae.billing_type = 'BT' and mtl.settl_flag = 'N' and mtl.tid_settl_method = 'C') then -1*mtl.amt_original
							else 0 end) as INTERCHANGE_AMT
					from masclr.mas_trans_log mtl, MASCLR.acq_entity ae
					where mtl.posting_entity_id = ae.entity_id
						and mtl.gl_date >=  '01-$date_my' and mtl.gl_date < '01-$next_mnth_my'
						and mtl.tid in ( '010004020000' ,'010004020005','010004020001')
						and mtl.card_scheme in ('04','08', '05')
						and mtl.institution_id in ($sql_inst)
					group by mtl.institution_id, mtl.entity_id, ae.billing_type"
	
	orasql $cursor_C $interchg_qry
	
	while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
	
		set ENTITY $row(INSTITUTION_ID).$row(ENTITY_ID)
		
		if {[info exists report_entities($ENTITY)]} {
			set repdata($ENTITY.INTERCHANGE_AMT) $row(INTERCHANGE_AMT)
		}
	}
	
	puts "Fetching retrieval requests"
	set retrievalReq_qry "select institution_id, entity_id, count(1) RETRIEVAL_REQS
							from masclr.mas_trans_log
							where institution_id in ($sql_inst)
							and mas_code in ('0204RREQ','0205RREQ','0207RREQ','0208RREQ')
							and gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my'
							group by institution_id, entity_id"
	
	orasql $cursor_C $retrievalReq_qry
	
	while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
	
		set ENTITY $row(INSTITUTION_ID).$row(ENTITY_ID)
		
		if {[info exists report_entities($ENTITY)]} {
			set repdata($ENTITY.RETRIEVAL_REQS) $row(RETRIEVAL_REQS)
		}
	}
	
	puts "Fetching TSYS counts"
	set tsys_count_qry "SELECT e_to_a.institution_id, e_to_a.entity_id, COUNT(1) TSYS_COUNTS
						FROM
							PRECS_TRANSACTION_DETAIL ptd,
							PRECS_MERCHANT_RECORD_DETAIL pmrd,
							PRECS_FILE_LOG pfl,
							entity_to_auth e_to_a
						WHERE pfl.cs_file_nbr = pmrd.cs_file_nbr
						AND pfl.cs_file_nbr = ptd.cs_file_nbr
						AND ptd.mh_rec_nbr = pmrd.mh_rec_nbr
						and pmrd.ACQUIRER_BIN = e_to_a.visa_bin
						and pfl.END_DT >=  '01-$date_my' and pfl.END_DT < '01-$next_mnth_my'
						AND pfl.FILE_TYPE = 'FI0007'
						AND e_to_a.institution_id in ($sql_inst)
						GROUP BY e_to_a.institution_id, e_to_a.entity_id"
	
	orasql $cursor_C $tsys_count_qry
	
	while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
	
		set ENTITY $row(INSTITUTION_ID).$row(ENTITY_ID)
		
		if {[info exists report_entities($ENTITY)]} {
			set repdata($ENTITY.TSYS_COUNTS) $row(TSYS_COUNTS)
		}
	}
	
	##
	##############AUTH #################
	# Run queries for each set of MIDs 
	# *less than 1000 mids per set*
	###
	puts "Fetching:	AUTH_COUNTS"
	puts "			DIALUP_TERM_COUNTS"
	puts "			DIALUP_TRANS_COUNTS"
	puts "			FRAUD_COUNT"
	for {set i 0} {$i <= $mid_lst_indx} {incr i} {

		set mid_sql_lst ""
		foreach x $mids($i) {
			set mid_sql_lst "$mid_sql_lst, '$x'"
		}
	
		set mid_sql_lst [string trim $mid_sql_lst {,}]

		#TODO: This query is WRONG and needs to be revised
		set bad_auth_counts_qry "Select  m.mid, count(1) AUTH_COUNTS
		from teihost.tranhistory t, teihost.terminal tt, teihost.merchant m, teihost.master_merchant mm
		where t.tid = tt.tid 
		and t.mid=m.mid 
		and tt.mid=m.mid 
		and m.mmid= mm.mmid 
		and m.mid in ($mid_sql_lst)
		and mm.shortname = 'JETPAYIS'
		and substr(tt.tid, 1,4) <> 'JSYS'
		and settle_date >= '$date_strt_frontend'
		and settle_date < '$next_mnth_frontend'
		GROUP BY m.mid"

		orasql $cursor_A $bad_auth_counts_qry
	
		while {[orafetch $cursor_A -dataarray row -indexbyname] != 1403} {
	
			set ENTITY $mid_to_entity($row(MID))
		
			if {[info exists report_entities($ENTITY)]} {
				set repdata($ENTITY.AUTH_COUNTS) $row(AUTH_COUNTS)
			}
		}
		
		#TODO: This query needs to be revised
		set terminal_counts_qry "SELECT  m.mid, sum(case when regexp_like(t.tid, '^-?\[\[:digit:\],.\]*\$') then 1 else 0 end) as DIALUP_TERM_COUNTS
								FROM teihost.terminal t, teihost.merchant m, teihost.master_merchant mm
								WHERE t.mid=m.mid 
								and m.mmid= mm.mmid
								and mm.shortname = 'JETPAYIS'
								and mm.active = 'A'
								and m.mid in ($mid_sql_lst)
								and m.active = 'A'
								and t.active = 'A'
								and t.mid = m.mid 
								and case when regexp_like(t.tid, '^-?\[\[:digit:\],.\]*\$') then t.tid end is not null 
								GROUP BY m.mid"
		
		orasql $cursor_A $terminal_counts_qry
		
		while {[orafetch $cursor_A -dataarray row -indexbyname] != 1403} {
	
			set ENTITY $mid_to_entity($row(MID))
		
			if {[info exists report_entities($ENTITY)]} {
				set repdata($ENTITY.DIALUP_TERM_COUNTS) $row(DIALUP_TERM_COUNTS)
			}
		}
		
		#TODO: This query needs to be revised
		set dialup_trnx_counts_qry "select t.mid, count(1) DIALUP_TRANS_COUNTS
								from teihost.transaction t 
								where (t.authdatetime >= '$date_strt_frontend'
								and t.authdatetime < '$next_mnth_frontend')
								and t.mid in ($mid_sql_lst)
								and (t.tid BETWEEN ('000000000000') AND ('999999999999'))
								and t.shipdatetime < '$next_mnth_frontend'
								and t.request_type in ('0100', '0200', '0220', '0250', '0400', '0402', '0420')
								group by t.mid"
		
		orasql $cursor_A $dialup_trnx_counts_qry
		
		while {[orafetch $cursor_A -dataarray row -indexbyname] != 1403} {
	
			set ENTITY $mid_to_entity($row(MID))
		
			if {[info exists report_entities($ENTITY)]} {
				set repdata($ENTITY.DIALUP_TRANS_COUNTS) $row(DIALUP_TRANS_COUNTS)
			}
		}
		
		set fraud_count_qry "SELECT unique m.mid, count(f.orig_amount) AS FRAUD_COUNT
							FROM teihost.fraud_history f, teihost.merchant m, teihost.master_merchant mm
							WHERE f.mid = m.mid 
							and m.mmid = mm.mmid
							and mm.shortname in ('JETPAYIS')
							and m.mid in ($mid_sql_lst)
							and f.AUTHDATETIME >= '$date_strt_frontend'
							and f.AUTHDATETIME <  '$next_mnth_frontend'
							and f.SHIPDATETIME <  '$next_mnth_frontend'
							GROUP BY m.mid"
		
		orasql $cursor_A $fraud_count_qry
		
		while {[orafetch $cursor_A -dataarray row -indexbyname] != 1403} {
	
			set ENTITY $mid_to_entity($row(MID))
		
			if {[info exists report_entities($ENTITY)]} {
				set repdata($ENTITY.FRAUD_COUNT) $row(FRAUD_COUNT)
			}
		}
	}
	
	puts "Fetching GetReporting User counts"
	
	set getRep_user_cnt_qry "select eta.institution_id, eta.entity_id, count (unique u.username) as GET_REP_USERS
							from port.user_profiles u, port.master_entity_hierarchy h, entity_to_auth eta
							WHERE u.entity_code = h.entity_code 
								AND u.entity_type = h.entity_type 
								and h.entity_id = eta.entity_id
								and eta.institution_id in ($sql_inst)
							group by eta.institution_id, eta.entity_id"

	orasql $cursor_C $getRep_user_cnt_qry
	
	while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
	
		set ENTITY $row(INSTITUTION_ID).$row(ENTITY_ID)
		
		if {[info exists report_entities($ENTITY)]} {
			set repdata($ENTITY.GET_REP_USERS) $row(GET_REP_USERS)
		}
	}
	
	##
	# Report Output
	# No need to add anything below here
	###%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%###
	###............................................................................................###
	###%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%###
	set filename "IsoBilling.$filedate.$institutions_arg.csv"
	set cur_file [open "$filename" w]

	#Output column names
	set rep "Entity ID,DBA Name,Name"
	foreach col $report_data_lst {
		set rep "${rep},[lindex $col 1]"
	}
	
	#Output data rows
	foreach eid $eid_list {
		
		#Write entity row to report
		set rep "${rep}\n[string range $eid 4 end],$repdata($eid.DBA_NAME),$repdata($eid.NAME)"
		
		foreach col $report_data_lst {
			set rep "${rep},$repdata($eid.[lindex $col 0])"
		}
	}
	
	#Calc subtotals from Entity data
	foreach col $report_data_lst {
		#If it is numeric
		if {[lindex $col 2] == "n"} {
			foreach eid $eid_list {
				set repdata(SUB.[lindex $col 0]) [expr $repdata(SUB.[lindex $col 0]) + $repdata($eid.[lindex $col 0])]
			}
		} else {
			set repdata(SUB.[lindex $col 0]) ""
		}
	}
	
	#Write Subtotals
	set rep "${rep}\n,,"
	foreach col $report_data_lst {
		set rep "${rep},$repdata(SUB.[lindex $col 0])"
	}
	
	puts $cur_file $rep
	close $cur_file
}

##
# Main
###

arg_parse

if {![info exists date_arg]} {
	init_dates [clock format [clock scan "-0 day"] -format %d-%b-%Y]
} else {
	init_dates [clock format [clock scan $date_arg -format %Y%m%d ] -format %d-%b-%Y]
}

if {$institutions_arg != ""} {
	do_report
} else {
	puts "Institution required.\nUsage: $argv0 -I nnn \[-D yyyymmdd\]"
}


oraclose $cursor_C
oraclose $cursor_A
oralogoff $handleC
oralogoff $handleA
