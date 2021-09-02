#!/usr/bin/env tclsh

package require Oratcl

#$Id: eom_vol_vsmc_dom_int.tcl 1879 2012-11-06 17:13:49Z ajohn $

set clrdb $env(SEC_DB) 


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
	global date today date_my next_mnth_my prev_mnth_my filedate
	set date			[string toupper [clock format [clock scan "$val"] -format %d-%b-%Y]] 
	set date_my			[string toupper [clock format [clock scan " $date -0 day"] -format %b-%Y]]     ;# MAR-2012
	set next_mnth_my	[string toupper [clock format [clock scan "01-$date_my +1 month"] -format %b-%Y]]     ;# APR-2012
	set prev_mnth_my	[string toupper [clock format [clock scan "01-$date_my -1 month"] -format %b-%Y]]     ;# FEB-2012
	set filedate 		[clock format   [clock scan " $date -0 day"] -format %Y%m]
	set today			[string toupper [clock format [clock seconds] -format %d-%b-%Y]]
}

proc mailsend { email_subject email_recipient email_sender email_body } {
	set temp_value ""
	regsub -all "\:" $email_body "\072" temp_value
    
	exec echo "$temp_value" | mailx -r $email_sender -s "$email_subject" $email_recipient
	#exec echo "$temp_value" |  mail -s "$email_subject" $email_recipient -- -r "$email_sender"
}

if {[catch {set handleC [oralogon masclr/masclr@$clrdb]} result]} {
  mailsend "iso_billing.tcl failed to run" $mailto_error $mailfromlist "iso_billing.tcl failed to run\n$result" 
  exit
}

set cursor_C [oraopen $handleC]

proc do_report {inst} {
	global cursor_C date_my next_mnth_my filedate today


	set vs_mc_dom_int_COLS {
							{VS_DOM_AMOUNT_CRD "VS Domestic Amount Credit"}
							{VS_INT_AMOUNT_CRD "VS International Amount Credit"}
							{VS_DOM_AMOUNT_DBT "VS Domestic Amount Debit"}
							{VS_INT_AMOUNT_DBT "VS International Amount Debit"}
							{VS_DOM_CNT_CRD "VS Domestic Count Credit"}
							{VS_INT_CNT_CRD "VS International Count Credit"}
							{VS_DOM_CNT_DBT "VS Domestic Count Debit"}
							{VS_INT_CNT_DBT "VS International Count Debit"}
							{MC_DOM_AMOUNT_CRD "MC Domestic Amount Credit"}
							{MC_INT_AMOUNT_CRD "MC International Amount Credit"}
							{MC_DOM_AMOUNT_DBT "MC Domestic Amount Debit"}
							{MC_INT_AMOUNT_DBT "MC International Amount Debit" }
							{MC_DOM_CNT_CRD "MC Domestic Count Credit"}
							{MC_INT_CNT_CRD "MC International Count Credit"}
							{MC_DOM_CNT_DBT "MC Domestic Count Debit"}
							{MC_INT_CNT_DBT "MC International Count Debit"}
	}
	
	foreach col $vs_mc_dom_int_COLS {
		set TOT($col) 0
	}
	
	set vs_mc_dom_int_splits_qry "SELECT m.institution_id INST, substr(m.posting_entity_id, 1,6) as BIN, 
		SUM(CASE WHEN ( i.tga = '3' and m.tid_settl_method = 'C' and m.card_scheme = '04') Then m.amt_original else 0 end ) AS VS_DOM_AMOUNT_CRD, 
		SUM(CASE WHEN ( i.tga <> '3' and m.tid_settl_method = 'C'and m.card_scheme = '04') Then m.amt_original else 0 end) AS VS_INT_AMOUNT_CRD, 
		SUM(CASE WHEN ( i.tga = '3' and m.tid_settl_method = 'D' and m.card_scheme = '04') Then m.amt_original else 0 end ) AS VS_DOM_AMOUNT_DBT, 
		SUM(CASE WHEN ( i.tga <> '3' and m.tid_settl_method = 'D'and m.card_scheme = '04') Then m.amt_original else 0 end) AS VS_INT_AMOUNT_DBT, 
		SUM(CASE WHEN ( i.tga = '3' and m.tid_settl_method = 'C' and m.card_scheme = '04') Then 1 else 0 end ) AS VS_DOM_CNT_CRD, 
		SUM(CASE WHEN ( i.tga <> '3' and m.tid_settl_method = 'C' and m.card_scheme = '04') Then 1 else 0 end) AS VS_INT_CNT_CRD, 
		SUM(CASE WHEN ( i.tga = '3' and m.tid_settl_method = 'D' and m.card_scheme = '04') Then 1 else 0 end ) AS VS_DOM_CNT_DBT, 
		SUM(CASE WHEN ( i.tga <> '3' and m.tid_settl_method = 'D' and m.card_scheme = '04') Then 1 else 0 end) AS VS_INT_CNT_DBT, 
		SUM(CASE WHEN ( i.tga = '3' and m.tid_settl_method = 'C' and m.card_scheme = '05') Then m.amt_original else 0 end ) AS MC_DOM_AMOUNT_CRD, 
		SUM(CASE WHEN ( i.tga <> '3' and m.tid_settl_method = 'C'and m.card_scheme = '05') Then m.amt_original else 0 end) AS MC_INT_AMOUNT_CRD, 
		SUM(CASE WHEN ( i.tga = '3' and m.tid_settl_method = 'D' and m.card_scheme = '05') Then m.amt_original else 0 end ) AS MC_DOM_AMOUNT_DBT, 
		SUM(CASE WHEN ( i.tga <> '3' and m.tid_settl_method = 'D'and m.card_scheme = '05') Then m.amt_original else 0 end) AS MC_INT_AMOUNT_DBT, 
		SUM(CASE WHEN ( i.tga = '3' and m.tid_settl_method = 'C' and m.card_scheme = '05') Then 1 else 0 end ) AS MC_DOM_CNT_CRD, 
		SUM(CASE WHEN ( i.tga <> '3' and m.tid_settl_method = 'C' and m.card_scheme = '05') Then 1 else 0 end) AS MC_INT_CNT_CRD, 
		SUM(CASE WHEN ( i.tga = '3' and m.tid_settl_method = 'D' and m.card_scheme = '05') Then 1 else 0 end ) AS MC_DOM_CNT_DBT, 
		SUM(CASE WHEN ( i.tga <> '3' and m.tid_settl_method = 'D' and m.card_scheme = '05') Then 1 else 0 end) AS MC_INT_CNT_DBT 
		FROM masclr.mas_trans_log m, masclr.TRANS_ENRICHMENT i 
		WHERE to_number(m.external_trans_nbr) = i.trans_seq_nbr 
		AND m.gl_date >= '01-$date_my' and m.gl_date < '01-$next_mnth_my' 
		AND m.institution_id in ($inst) 
		AND m.trans_sub_seq = '0'
		AND m.settl_flag = 'Y' 
		AND trans_sub_seq = '0' 
		GROUP BY m.institution_id, substr(m.posting_entity_id, 1,6)"
	
	orasql $cursor_C $vs_mc_dom_int_splits_qry

	while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
		
		set record "$row(BIN),"
		foreach col $vs_mc_dom_int_COLS {
			set record "${record}$row([lindex $col 0]),"
			set TOT($col) [expr $TOT($col) + $row([lindex $col 0])]
		}
		
		lappend VSMC_DOM_INT_DETAILS "$record"
	}


	set filename "EOM.Volume.MC_VS_dom_int.$filedate.$inst.csv"
	set cur_file [open "$filename" w]

	set header "BIN,"
	foreach col $vs_mc_dom_int_COLS {
		set header "${header}[lindex $col 1],"
	}
	
	puts $cur_file "institution $inst END OF MONTH VISA MASTERCARD DOMESTIC/INTERNATIONAL SPLIT\n\n\n"
	puts $cur_file "Generated: $today\n\n"
	puts $cur_file "$header\n"
	
	
	foreach recrow $VSMC_DOM_INT_DETAILS {
		puts $cur_file $recrow
	}
	
	set footer ""
	foreach col $vs_mc_dom_int_COLS {
		set footer "${footer},$TOT($col)"
	}
	
	puts $cur_file $footer
	
	close $cur_file
	
	exec echo "See attached file." | mutt -a $filename -s "$filename" -- "accounting@jetpay.com, reports-clearing@jetpay.com"

}




arg_parse

if {![info exists date_arg]} {
	#Runs previous month if no date arg is given
	init_dates [clock format [clock scan "-1 month"] -format %d-%b-%Y]
} else {
	init_dates [clock format [clock scan $date_arg -format %Y%m%d ] -format %d-%b-%Y]
}

if {$institutions_arg != ""} {
	puts "Running $argv0 for $institutions_arg $date_my"
	do_report $institutions_arg
} else {
	puts "Institution required.\nUsage: $argv0 -I nnn \[-D yyyymmdd\]"
}

oraclose $cursor_C
oralogoff $handleC



