#!/usr/bin/env tclsh

# $Id: arb_settlement.tcl 3016 2015-06-25 19:27:17Z jkruse $

# TODO
#   Add report for cases where multiple chargebacks found for arb settle (script
# would need to run
#       additional times for each duplicate)
#   Add notification when original chargeback could not be found

# this script may need to be run from a bash script that will prepare these
# variables
source $env(MASCLR_LIB)/mas_process_lib.tcl

proc setup {} {

	global argv
	MASCLR::set_debug_level 1
	MASCLR::set_up_dates

	namespace eval THIS {
		variable MAS_JOB_NAME "ARBCREDT"
		variable FILE_TYPE "01"
		variable INSTITUTION_ID_VAR ""
		variable FILE_DATE ""
		variable SHORTNAME_VAR ""
		variable TRANS_DATE ""
		variable END_DATE ""
		variable BATCHTIME ""
	}

	MASCLR::open_log_file ""

	MASCLR::add_argument inst_id i [list ARG_REQ ARG_HAS_VAL]
	MASCLR::add_argument file_date file_date [list ARG_NOT_REQ ARG_HAS_VAL ARG_DEFAULT { "set MASCLR::TOMORROW"} ARG_FORMAT {"MASCLR::get_date_with_format $arg_value $MASCLR::DT_EF_FILE_DATE_TRUNC" } ]
	MASCLR::add_argument trans_date trans_date [list ARG_NOT_REQ ARG_HAS_VAL ARG_DEFAULT { "set MASCLR::TODAY"} ARG_FORMAT {"MASCLR::get_date_with_format $arg_value $MASCLR::DT_EF_DB_DATE_SHORT" } ]
	MASCLR::add_argument end_date end_date [list ARG_NOT_REQ ARG_HAS_VAL ARG_DEFAULT { "set MASCLR::TOMORROW"} ARG_FORMAT {"MASCLR::get_date_with_format $arg_value $MASCLR::DT_EF_DB_DATE_SHORT" } ]
	MASCLR::parse_arguments $argv

	set THIS::INSTITUTION_ID_VAR $MASCLR::SCRIPT_ARGUMENTS(INST_ID)
	set THIS::FILE_DATE $MASCLR::SCRIPT_ARGUMENTS(FILE_DATE)
	set THIS::TRANS_DATE $MASCLR::SCRIPT_ARGUMENTS(TRANS_DATE)
	set THIS::END_DATE $MASCLR::SCRIPT_ARGUMENTS(END_DATE)
	set THIS::BATCHTIME $THIS::FILE_DATE

	MASCLR::set_script_alert_level "MEDIUM"

	global env

	#	set_institution_directory

	namespace eval THIS {
		variable OUT_SQL_FILE ""
		variable OUTFILE
	}

	set THIS::OUT_SQL_FILE "arb_settlement_updates_[set THIS::TRANS_DATE]_to_[set THIS::END_DATE]_[set THIS::INSTITUTION_ID_VAR].sql"
	MASCLR::set_out_sql_file_name $THIS::OUT_SQL_FILE
MASCLR::save_updates_to_file
#	MASCLR::live_updates
	set THIS::OUTFILE [set_output_file_name]
}

proc set_output_file_name { } {

	#Temp variable for output file name
	set f_seq 15
	set sequence_no [format %03s $f_seq]
	#set pth ""
	set test_file_name 1
	set jdate [string range $MASCLR::CURRENT_JULIAN_DATE 1 end]
	set dot "."

	append outfile $THIS::INSTITUTION_ID_VAR $dot $THIS::MAS_JOB_NAME $dot $THIS::FILE_TYPE $dot $jdate $dot $sequence_no

	while {$test_file_name == 1} {
		MASCLR::log_message "Checking file name $outfile"
		set ex [file exists $outfile]
		if {$ex == 1} {
			incr f_seq
			set sequence_no [format %03s $f_seq]
			#set pth ""
			#exec mv $outfile TEMP
			set outfile ""
#			set jdate [ clock scan "$currdate"  -base [clock seconds] ]
#			set jdate [clock format $jdate -format "%y%j"]
			

			append outfile $THIS::INSTITUTION_ID_VAR $dot $THIS::MAS_JOB_NAME $dot $THIS::FILE_TYPE $dot $jdate $dot $sequence_no
			set test_file_name 1
		} else {
			set test_file_name 0
		}
	}

	MASCLR::log_message "Using out file name $outfile"
	return $outfile
}

proc get_batch_number { } {
	# get and bump the file number
	set batch_num_file [open "mas_batch_num.txt" "r+"]
	gets $batch_num_file batch_number
	seek $batch_num_file 0 start
	if {$batch_number >= 999999999} {
		puts $batch_num_file 1
	} else {
		puts $batch_num_file [incr batch_number]
	}
	close $batch_num_file

	MASCLR::log_message "Using batch seq num: $batch_number"
	return $batch_number
}

#Defining tcr records type , length and description below

#Mas file Header Record

set tcr(FH) {
	fhtrans_type             2 a {File Header Transmission Type}
	file_type                2 a {File Type}
	file_date_time          16 x {File Date and Time}
	activity_source         16 a {Activity Source}
	activity_job_name        8 a {Activity Job name}
	suspend_level            1 a {Suspend Level}
}

#Mas Batch Header Record

set tcr(BH) {
	bhtrans_type             2 a {Batch Header Transmission Type}
	batch_curr               3 a {Currency of the batch}
	activity_date_time_bh   16 x {System date and time}
	merchantid              30 a {ID of the merchant}
	inbatchnbr               9 n {Batch number}
	infilenbr                9 n {File number}
	billind                  1 a {Non Activity Batch Header Fee}
	orig_batch_id            9 a {Original Batch ID}
	orig_file_id             9 a {Original File ID}
	ext_batch_id            25 a {External Batch ID}
	ext_file_id             25 a {External File ID}
	sender_id               25 a {Merchant ID for the batch}
	microfilm_nbr           30 a {Microfilm Locator number}
	institution_id          10 a {Institution ID}
	batch_capture_dt        16 a {Batch Capture Date and Time}
}

#Mas Batch Trailer Record

set tcr(BT) {
	bttrans_type             2 a {Batch Trailer Transmission Type}
	batch_amt               12 n {Total Transaction Amount in a Batch}
	batch_cnt               10 n {Total Transaction count in a Batch}
	batch_add_amt1          12 n {Total additional1 amount in a Batch}
	batch_add_cnt1          10 n {Total additional1 count in a Batch}
	batch_add_amt2          12 n {Total additional2 amount in a Batch}
	batch_add_cnt2          10 n {Total additional2 count in a Batch}
}

#Mas File Trailer Record

set tcr(FT) {
	fttrans_type             2 a {File Trailer Transmission Type}
	file_amt                12 n {Total Transaction Amount in a File}
	file_cnt                10 n {Total Transaction count in a File}
	file_add_amt1           12 n {Total additional1 amount in a File}
	file_add_cnt1           10 n {Total additional1 count in a File}
	file_add_amt2           12 n {Total additional2 amount in a File}
	file_add_cnt2           10 n {Total additional2 count in a File}
}

#Mas Message Detail Record

set tcr(01) {
	mgtrans_type             2 a {Message Detail Transmission Type}
	trans_id                12 a {Unique Transmission identifier}
	entity_id               18 a {Internal entity id}
	card_scheme              2 a {Card Scheme identifier}
	mas_code                25 a {Mas Code}
	mas_code_downgrade      25 a {Mas codes for Downgraded Transaction}
	nbr_of_items            10 n {Number of items in the transaction record}
	amt_original            12 n {Original amount of a Transaction}
	add_cnt1                10 n {Number of items included in add_amt1}
	add_amt1                12 n {Additional Amount 1}
	add_cnt2                10 n {Number of items included in add_amt2}
	add_amt2                12 n {Additional Amount 2}
	external_trans_id       25 a {The extarnal transaction id}
	trans_ref_data          23 a {Reference Data}
	suspend_reason           2 a {The Suspend reason code}
}

#Procedure for construct tcr records according to above definitions.

proc write_tcr {aname} {
	global tcr
	upvar $aname a
	set l_tcr $a(tcr)
	set result {}

	foreach {fname flength ftype fdesc} $tcr(${l_tcr}) {
		switch -- $ftype {
			a {
				if {![info exists  a($fname)]} {
					set  a($fname) {}
				}
				set t [format "%-${flength}.${flength}s" $a($fname)]
				set result "$result$t"
			}
			n {
				if {![info exists  a($fname)] || ($fname == "filler")} {
					set  a($fname) 0
				}
				set t [format "%0${flength}.${flength}d" $a($fname)]
				set result "$result$t"
			}
			x {
				if {![info exists  a($fname)]} {
					set  a($fname) {}
				}
				set t [format "%-0${flength}.${flength}s" $a($fname)]
				set result "$result$t"
			}

		}

	}
	return $result
}

#Procedure read_tcr Not use at the moment

proc read_tcr {inrec aname } {
	global tcr
	upvar $aname a
	set l_tcr [string range $inrec 0 1]
	set cur_pos 0
	foreach {fname flength ftype fdesc} $tcr(${l_tcr}) {
		set a [string range $cur_pos [expr $cur_pos + $flength - 1] ]
		set cur_pos [expr $cur_pos + $flength ]
	}
}

#Precedure print_tcr Not used at the moment

proc print_tcr {fd aname}  {
	global tcr
	upvar $aname a
	set l_tcr $a(tcr)
	set result {}
	foreach {fname flength ftype fdesc} $trc(${l_tcr}) {
		puts $fd [format "%25.25s >%s<" $fdesc $a($fname) ]
	}
}

#Below all Procedures write_??_record to assign values to the tcr fields and call
# write_tcr to constuct the tcr records

proc write_fh_record {fd aname} {
	global tcr
	upvar $aname a
	set rec(tcr) "FH"
	set rec(fhtrans_type) "FH"
	set rec(file_type) $THIS::FILE_TYPE
	set rec(file_date_time) $a(file_date_time)
	set rec(activity_source) $a(activity_source)
	set rec(activity_job_name) $a(activity_job_name)
	set rec(suspend_level) "B"
	puts $fd [write_tcr rec]
}

proc write_bh_record {fd aname} {
	global tcr
	upvar $aname a
	set 25spcs [format %-25s " "]
	set 23spcs [format %-23s " "]
	set rec(tcr) "BH"
	set rec(bhtrans_type) "BH"
	set rec(batch_curr) $a(batch_curr)
	set rec(activity_date_time_bh) $a(activity_date_time_bh)
	set rec(merchantid) $a(merchantid)
	set rec(inbatchnbr) $a(inbatchnbr)
	set rec(infilenbr) $a(infilenbr)
	set rec(billind) "N"
	set rec(orig_batch_id) "         "
	set rec(orig_file_id) "         "
	set rec(ext_batch_id) $25spcs
	set rec(ext_file_id) $25spcs
	set rec(sender_id) $a(sender_id)
	set rec(microfilm_nbr) [format %-30s " "]
	set rec(institution_id) $a(institution_id)
	set rec(batch_capture_dt) $a(batch_capture_dt)

	puts $fd [write_tcr rec]
}

proc write_md_record {fd aname} {
	global tcr
	upvar $aname a
	set 25spcs [format %-25s " "]
	set 23spcs [format %-23s " "]
	set rec(tcr) "01"
	set rec(mgtrans_type) "01"
	set rec(trans_id) $a(trans_id)
	set rec(entity_id) $a(entity_id)
	set rec(card_scheme) $a(card_scheme)
	set rec(mas_code) $a(mas_code)
	set rec(mas_code_downgrade) $25spcs
	set rec(nbr_of_items) $a(nbr_of_items)
	set rec(amt_original) $a(amt_original)
	set rec(add_cnt1) "0000000000"
	set rec(add_amt1) "000000000000"
	set rec(add_cnt2) "0000000000"
	set rec(add_amt2) "000000000000"
	set rec(trans_ref_data) $a(trans_ref_data)
	set rec(suspend_reason) [format %-2s " "]
	set rec(external_trans_id) $a(external_trans_id)

	puts $fd [write_tcr rec]
}

proc write_bt_record {fd aname} {
	global tcr
	upvar $aname a
	set rec(tcr) "BT"
	set rec(bttrans_type) "BT"
	set rec(batch_amt) $a(batch_amt)
	set rec(batch_cnt) $a(batch_cnt)
	set rec(batch_add_amt1) [format %012d "0"]
	set rec(batch_add_cnt1) [format %010d "0"]
	set rec(batch_add_amt2) [format %012d "0"]
	set rec(batch_add_cnt2) [format %010d "0"]

	puts $fd [write_tcr rec]
}

proc write_ft_record {fd aname} {
	global tcr
	upvar $aname a
	set rec(tcr) "FT"
	set rec(fttrans_type) "FT"
	set rec(file_amt) $a(file_amt)
	set rec(file_cnt) $a(file_cnt)
	set rec(file_add_amt1) [format %012d "0"]
	set rec(file_add_cnt1) [format %010d "0"]
	set rec(file_add_amt2) [format %012d "0"]
	set rec(file_add_cnt2) [format %010d "0"]

	puts $fd [write_tcr rec]
}

proc write_fh_record {fd aname} {
	global tcr
	upvar $aname a
	set rec(tcr) "FH"
	set rec(fhtrans_type) "FH"
	set rec(file_type) $THIS::FILE_TYPE
	set rec(file_date_time) $a(file_date_time)
	set rec(activity_source) $a(activity_source)
	set rec(activity_job_name) $a(activity_job_name)
	set rec(suspend_level) "B"
	puts $fd [write_tcr rec]
}

proc main {} {

	if { [catch {setup} failure] } {
		MASCLR::log_message "setup failed: $failure"
		MASCLR::close_all_and_exit_with_code $MASCLR::FAILURE_CONDITION
	}
	global env
	set arb_settlement_login_data "masclr/masclr@$env(IST_DB)"
#	set arb_settlement_login_data "masclr/masclr@trnclr4"
	if { [catch {set arb_settlement_handle [MASCLR::open_db_connection "arb_settlement" $arb_settlement_login_data]} failure] } {
		MASCLR::log_message $failure
		MASCLR::close_all_and_exit_with_code $MASCLR::FAILURE_CONDITION
	}

	namespace eval THIS {
		variable EMAIL_BODY "The following fee collections/arbitration settlements will be sent to MAS for payment:\n\n"
	}

	# need cursors update_cursor and get_arb_records_cursor get_original_cb_cursor
	# get_mas_code_tid_cursor
	if { [catch {set get_arb_records_cursor [MASCLR::open_cursor $arb_settlement_handle]} failure] } {
		set message "Could not open cursor: $failure"
		MASCLR::close_all_and_exit_with_code 1 "$failure"
	}
	if { [catch {set get_original_cb_cursor [MASCLR::open_cursor $arb_settlement_handle]} failure] } {
		set message "Could not open cursor: $failure"
		MASCLR::close_all_and_exit_with_code 1 "$failure"
	}
	if { [catch {set get_mas_code_tid_cursor [MASCLR::open_cursor $arb_settlement_handle]} failure] } {
		set message "Could not open cursor: $failure"
		MASCLR::close_all_and_exit_with_code 1 "$failure"
	}
	if { [catch {set update_cursor [MASCLR::open_cursor $arb_settlement_handle]} failure] } {
		set message "Could not open cursor: $failure"
		MASCLR::close_all_and_exit_with_code 1 "$failure"
	}
	if { [catch {set insert_cursor [MASCLR::open_cursor $arb_settlement_handle]} failure] } {
		set message "Could not open cursor: $failure"
		MASCLR::close_all_and_exit_with_code 1 "$failure"
	}

	oraparse $get_arb_records_cursor {alter session set nls_date_format='DD-MON-YYYY HH24:MI:SS'}
	oraexec $get_arb_records_cursor

	##Opening Output file to write to

	if [catch {open $THIS::OUTFILE {WRONLY CREAT APPEND}} fileid] {
		set message "Cannot open file : $fileid"
		MASCLR::log_message $message
		MASCLR::close_all_and_exit_with_code 1 $message
	}

	## Writing File Header into the Mas file

	set rec(file_date_time) $THIS::BATCHTIME
	set rec(activity_source) "JETPAYLLC"
	set rec(activity_job_name) "MAS"

	write_fh_record $fileid rec

	## Declaring Variables and initializing

	set batch_total_count 0
	set batch_total_amount 0
	set file_total_count 0
	set file_total_amount 0
	set loop 1
	set sendemail 1

	## Get the transactions to work with
	## Big query, runs fast
	set get_transactions_sql "  SELECT idm.activity_dt , epl.event_log_date    ,
	(SELECT trans_dt FROM in_draft_main
	WHERE trans_seq_nbr =
	CASE WHEN epl.trans_seq_nbr_orig = 0 THEN (SELECT MAX(trans_seq_nbr) FROM in_draft_main WHERE pan              = idm.pan
	  AND tid               IN ('010103015101') AND pri_dest_inst_id   = epl.institution_id
	  AND trans_seq_nbr IN (SELECT trans_seq_nbr FROM ep_event_log WHERE ems_item_type = 'CB1'))
	 ELSE epl.trans_seq_nbr_orig
	END) AS orig_trans_dt,
	idm.trans_seq_nbr  ,
	CASE WHEN epl.trans_seq_nbr_orig = 0 THEN (SELECT MAX(trans_seq_nbr) FROM in_draft_main WHERE pan              = idm.pan
	  AND tid               IN ('010103015101') AND pri_dest_inst_id   = epl.institution_id
	  AND trans_seq_nbr in (SELECT trans_seq_nbr FROM ep_event_log WHERE ems_item_type = 'CB1')
	  ) ELSE epl.trans_seq_nbr_orig
	 END AS orig_trans_seq_nbr_lookup,
	 (SELECT merch_id FROM in_draft_main WHERE trans_seq_nbr =
	  CASE WHEN epl.trans_seq_nbr_orig = 0 THEN (SELECT MAX(trans_seq_nbr) FROM in_draft_main
	  WHERE pan              = idm.pan AND tid               IN ('010103015101')
	  AND pri_dest_inst_id   = epl.institution_id
	  AND trans_seq_nbr IN (SELECT trans_seq_nbr FROM ep_event_log WHERE ems_item_type = 'CB1')
	  )
	  ELSE epl.trans_seq_nbr_orig
	  END) AS orig_merch_id,
	  (SELECT merch_name FROM in_draft_main WHERE trans_seq_nbr = CASE WHEN epl.trans_seq_nbr_orig = 0
	  THEN (SELECT MAX(trans_seq_nbr) FROM in_draft_main WHERE pan              = idm.pan
	  AND tid               IN ('010103015101') AND pri_dest_inst_id   = epl.institution_id
	  AND trans_seq_nbr IN (SELECT trans_seq_nbr FROM ep_event_log WHERE ems_item_type = 'CB1')
	  )
	  ELSE epl.trans_seq_nbr_orig
	  END) AS orig_merch_name ,
	  idm.tid              , t.tid_settl_method   , idm.card_scheme      ,
	  idm.pri_dest_inst_id , idm.pan              ,
	  (SELECT arn FROM in_draft_main WHERE trans_seq_nbr =
	  CASE WHEN epl.trans_seq_nbr_orig = 0 THEN (SELECT MAX(trans_seq_nbr) FROM in_draft_main
	  WHERE pan              = idm.pan AND tid               IN ('010103015101')
	  AND pri_dest_inst_id   = epl.institution_id
	  AND trans_seq_nbr IN
	  (SELECT trans_seq_nbr FROM ep_event_log WHERE ems_item_type = 'CB1')
	  )
	  ELSE epl.trans_seq_nbr_orig
	  END
	  ) AS orig_arn                  ,
	  idm.amt_trans                   , idm.trans_ccd                   ,
	  idm.trans_exp                   , idm.amt_recon                   , idm.recon_ccd                   ,
	  idm.recon_exp                   , idm.msg_type                    , idm.function_cd                 ,
	  idm.reason_cd                   , idm.receiving_inst_id           , idm.msg_nbr                     ,
	  idm.msg_text_block              , idm.external_file_id            , idm.activity_dt                 ,
	  epl.ep_event_id                 , epl.institution_id              , epl.send_id                     ,
	  epl.receive_id                  , epl.ems_item_type               , epl.event_status                ,
	  epl.event_reason                , epl.memo_free_text              , eh.event_status AS hist_status  ,
	  eh.process      AS hist_process , eh.event_reason AS hist_reason,
	  idm.p_cd_trans_type
	   FROM in_draft_main idm
	JOIN tid t ON t.tid = idm.tid
	LEFT JOIN ep_event_log epl ON idm.trans_seq_nbr = epl.trans_seq_nbr
	LEFT JOIN in_draft_baseii idb ON idm.trans_seq_nbr = idb.trans_seq_nbr
	LEFT JOIN ep_history eh ON idm.trans_seq_nbr = eh.trans_seq_nbr
	  WHERE (idm.in_file_nbr in (select in_file_nbr from in_file_log where 
			   (external_file_name like '%T112%' or external_file_name like '%CTF%') 
			   and end_dt between '$THIS::TRANS_DATE' and '$THIS::END_DATE'
	  )
	  AND idm.tid          IN ('010103010101', '010103010102') -- these are the two TIDs
	  AND (activity_dt  between '$THIS::TRANS_DATE' and '$THIS::END_DATE')
	  AND idm.pan IS NOT NULL      -- have to have the pan to track back to original
	  AND idm.pan NOT LIKE '0000%' -- have to have the pan to track back to original
	  AND idm.reason_cd       != '170'   -- filing fees/retrieval fees
	  AND idm.pri_dest_inst_id = '$THIS::INSTITUTION_ID_VAR'
	  AND epl.ems_item_type    = 'MI1'
	  AND epl.event_status     = 'NOTIFY'
	  AND eh.event_status     IS NULL)"
#	OR (
#	  idm.tid in ('010103005401','010103005402')
#	 AND idm.pan IS NOT NULL
#	 AND idm.pan NOT LIKE '0000%'
#	 AND idm.card_scheme = '08'
#	 AND idm.msg_type in ('2230', '2530')
#	 AND idm.pri_dest_inst_id = '$THIS::INSTITUTION_ID_VAR'
#	 AND epl.ems_item_type    = 'PR2'
#	 AND idm.in_file_nbr in (
#	  select in_file_nbr from in_file_log where external_file_name like 'disc.disp%'
#	  AND end_dt between '$THIS::TRANS_DATE' and '$THIS::END_DATE'
#	))	"

	if { [catch { orasql $get_arb_records_cursor $get_transactions_sql } failure ] } {
		MASCLR::log_message $get_transactions_sql
		MASCLR::log_message "Database error: $failure"
		MASCLR::close_all_and_exit_with_code 1 "$failure"
	}
	MASCLR::log_message $get_transactions_sql 1

	## Keep track of how many successful matches were found
	set matches_found 0

	## Loop through each fee collection found for the given date that matches
	## all other requirements for an arb message

	while {1} {
		if { [catch { orafetch $get_arb_records_cursor -dataarray arbitration_transaction_arr -indexbyname} failure ] } {
			MASCLR::log_message "Database error: $failure"
			MASCLR::close_all_and_exit_with_code 1 "$failure"
		}
		if {[oramsg $get_arb_records_cursor rc] == 1403} { break; }
		# this next one is unnecessary but just here for paranoia's sake
		# to prevent an endless loop in case something really odd happens
		if {[oramsg $get_arb_records_cursor rc] != 0} { break; }

		#  if the ARN is empty, go find the original
		if { $arbitration_transaction_arr(ORIG_ARN) == "" } {
			MASCLR::log_message "Could not get ARN of original chargeback.  Skipping trans_seq_nbr $arbitration_transaction_arr(TRANS_SEQ_NBR)"
			continue
		} else {
			## When we find the original transaction because of a filled in ARN
			## then use those values
			set merch_id_var $arbitration_transaction_arr(ORIG_MERCH_ID)
			set merch_name_var $arbitration_transaction_arr(ORIG_MERCH_NAME)
			set arn_var $arbitration_transaction_arr(ORIG_ARN)
			set orig_trans_dt_var $arbitration_transaction_arr(ORIG_TRANS_DT)
			set munged_pan_var "[string range $arbitration_transaction_arr(PAN) 0 5]******[string range $arbitration_transaction_arr(PAN) 12 15]"
			set activity_dt_var $arbitration_transaction_arr(ACTIVITY_DT)
			set original_trans_seq_nbr $arbitration_transaction_arr(ORIG_TRANS_SEQ_NBR_LOOKUP)
		};# end if ARN == ""

		## At this point, either the ARN was found from the original chargeback,
		## or the ARN was filled in manually.  Either way, we can proceed with this arb
		# transaction

		## Get the TID and MAS_CODE from a mapping table
		set get_mas_code_tid_sql "SELECT mas_code, mas_activity_tid, mas_card_scheme,t.tid_settl_method
			FROM flmgr_tid_map ftm
			JOIN tid t on t.tid = ftm.mas_activity_tid
			WHERE clr_card_scheme = '$arbitration_transaction_arr(CARD_SCHEME)'
			AND ep_ems_item_type = '$arbitration_transaction_arr(EMS_ITEM_TYPE)'
			AND clr_tid = '$arbitration_transaction_arr(TID)'
			AND clr_msg_type = '$arbitration_transaction_arr(MSG_TYPE)'
			AND clr_function_cd = '$arbitration_transaction_arr(FUNCTION_CD)'
			AND clr_reason_cd = '$arbitration_transaction_arr(REASON_CD)'
			AND mas_job_name = '$THIS::MAS_JOB_NAME'
			AND CLR_P_CD_TRANS_TYPE = nvl('$arbitration_transaction_arr(P_CD_TRANS_TYPE)',0)"
		MASCLR::log_message $get_mas_code_tid_sql 1
		if { [catch { orasql $get_mas_code_tid_cursor $get_mas_code_tid_sql } failure ] } {
			MASCLR::log_message "Database error: $failure"
			MASCLR::close_all_and_exit_with_code 1 "$failure"
		}
		if { [catch { orafetch $get_mas_code_tid_cursor -dataarray mas_code_tid_arr -indexbyname} failure ] } {
			MASCLR::log_message "Database error: $failure"
			MASCLR::close_all_and_exit_with_code 1 "$failure"
		}
		if { [oramsg $get_mas_code_tid_cursor rows ] != 1 } {
			MASCLR::log_message "Expected 1 row.  Found [MASCLR::get_affected_rows $get_mas_code_tid_cursor]"
			MASCLR::close_all_and_exit_with_code 1 "When looking for MAS_CODE/TID for fee, expected 1 row.  Found [MASCLR::get_affected_rows $get_mas_code_tid_cursor]"
		}

		MASCLR::log_message "Found $mas_code_tid_arr(MAS_CODE) $mas_code_tid_arr(MAS_ACTIVITY_TID) $mas_code_tid_arr(MAS_CARD_SCHEME)"

		## See if we've already settled this one before to prevent duplicates (if running
# on previous dates)
		set mas_trans_log_lookup_sql "SELECT * from mas_trans_log
		WHERE (institution_id, file_id) in
		(SELECT institution_id, file_id from mas_file_log where file_name like '%$THIS::MAS_JOB_NAME%'
		and institution_id = '$THIS::INSTITUTION_ID_VAR')
		and trans_ref_data = '$arn_var'
		and tid = '$mas_code_tid_arr(MAS_ACTIVITY_TID)'
		and amt_billing = '[expr $arbitration_transaction_arr(AMT_RECON) / 100.0]'"
		MASCLR::log_message $mas_trans_log_lookup_sql 1
		if { [catch { orasql $get_mas_code_tid_cursor $mas_trans_log_lookup_sql } failure ] } {
			MASCLR::log_message "Database error: $failure"
			MASCLR::close_all_and_exit_with_code 1 "$failure"
		}
		if { [catch { orafetch $get_mas_code_tid_cursor -dataarray mas_code_tid_arr -indexbyname} failure ] } {
			MASCLR::log_message "Database error: $failure"
			MASCLR::close_all_and_exit_with_code 1 "$failure"
		}
		if { [oramsg $get_mas_code_tid_cursor rows] > 0 } {
			MASCLR::log_message "Skipping $arbitration_transaction_arr(CARD_SCHEME) arbitration \
			[expr { $arbitration_transaction_arr(TID_SETTL_METHOD) == "D" ? "Debit" : \
			$arbitration_transaction_arr(TID_SETTL_METHOD) == "C" ? "Credit" : "Unknown" }] \
			settlement coming in on $activity_dt_var for original date $orig_trans_dt_var \
			\nfor $merch_id_var $merch_name_var  --  $arn_var  --  $munged_pan_var \
			in the amount of [expr $arbitration_transaction_arr(AMT_RECON) / 100.0]\nThis has already been settled through MAS."
			continue
		}

		## update the arbitration record with data from the original
		set update_arbitration_record_sql "UPDATE in_draft_main
			SET merch_id = '$merch_id_var',
				merch_name = '$merch_name_var',
				arn = '$arn_var'
			WHERE trans_seq_nbr = '$arbitration_transaction_arr(TRANS_SEQ_NBR)'"

		if { [catch {MASCLR::update_record $update_cursor $update_arbitration_record_sql} failure] } {
			set message "Error updating arbitration record: $failure"
			oraroll $arb_settlement_handle
			MASCLR::log_message $message
			MASCLR::close_all_and_exit_with_code 1 $message
		}
		MASCLR::log_message "LIVE_UPDATES is set to $MASCLR::LIVE_UPDATES" 1
		if { $MASCLR::LIVE_UPDATES == 1 } {
			if { [MASCLR::get_affected_rows $update_cursor] != 1 } {
				set message "Expected 1 row to be updated.  [MASCLR::get_affected_rows $update_cursor] updated instead"
				oraroll $arb_settlement_handle
				MASCLR::log_message $message
				MASCLR::close_all_and_exit_with_code 1 $message
			}
		}

		## update ep_event_log's arb record with data from the original
		set update_ep_event_log_arbitration_record_sql "UPDATE ep_event_log
			SET merch_id = '$merch_id_var',
				trans_seq_nbr_orig = '$original_trans_seq_nbr',
				arn = '$arn_var'
			WHERE trans_seq_nbr = '$arbitration_transaction_arr(TRANS_SEQ_NBR)'"

		if { [catch {MASCLR::update_record $update_cursor $update_ep_event_log_arbitration_record_sql} failure] } {
			set message "Error updating arbitration record: $failure"
			oraroll $arb_settlement_handle
			MASCLR::log_message $message
			MASCLR::close_all_and_exit_with_code 1 $message
		}
		if { $MASCLR::LIVE_UPDATES == 1 } {
			if { [MASCLR::get_affected_rows $update_cursor] != 1 } {
				set message "Expected 1 row to be updated.  [MASCLR::get_affected_rows $update_cursor] updated instead"
				oraroll $arb_settlement_handle
				MASCLR::log_message $message
				MASCLR::close_all_and_exit_with_code 1 $message
			}
			oracommit $arb_settlement_handle
		}

		## update the arbitration record with data from the original

		append THIS::EMAIL_BODY "Found $arbitration_transaction_arr(CARD_SCHEME) arbitration \
[expr { $mas_code_tid_arr(TID_SETTL_METHOD) == "D" ? "Debit" : \
$mas_code_tid_arr(TID_SETTL_METHOD) == "C" ? "Credit" : "Unknown" }] \
settlement coming in on $activity_dt_var for original date $orig_trans_dt_var \
\nfor $merch_id_var $merch_name_var  --  $arn_var  --  $munged_pan_var \
in the amount of [expr $arbitration_transaction_arr(AMT_RECON) / 100.0]\n\n"

		## Writing Batch Header Or Batch Trailer

		set batch_total_count 0
		set batch_total_amount 0

		set rec(batch_curr) "$arbitration_transaction_arr(RECON_CCD)"
		set rec(activity_date_time_bh) $THIS::BATCHTIME
		set rec(merchantid) "$merch_id_var"
		set rec(inbatchnbr) [get_batch_number]
		set rec(infilenbr)  1
		set rec(batch_capture_dt) $THIS::BATCHTIME
		set rec(sender_id) $merch_name_var
		set rec(institution_id) $arbitration_transaction_arr(INSTITUTION_ID)

		write_bh_record $fileid rec

		## Writing Message Detail records

		set rec(entity_id) $merch_id_var
		set rec(external_trans_id) $arbitration_transaction_arr(TRANS_SEQ_NBR)
		set rec(trans_ref_data) $arn_var
		## Keeping track of how many matches were found
		incr matches_found

		set rec(mas_code) $mas_code_tid_arr(MAS_CODE)
		set rec(trans_id) $mas_code_tid_arr(MAS_ACTIVITY_TID)
		set rec(card_scheme) $mas_code_tid_arr(MAS_CARD_SCHEME)

		set rec(nbr_of_items) "1"
		if {$arbitration_transaction_arr(RECON_CCD) == "840"} {
			set rec(amt_original) $arbitration_transaction_arr(AMT_RECON)
			write_md_record $fileid rec
			incr batch_total_count
			set batch_total_amount [expr $batch_total_amount + $arbitration_transaction_arr(AMT_RECON)]
			incr file_total_count
			set file_total_amount [expr $file_total_amount + $arbitration_transaction_arr(AMT_RECON)]
		} else {
			MASCLR::log_message "Cannot process non-840 currency code for arbitration credit. Transaction $arbitration_transaction_arr(TRANS_SEQ_NBR)."
		}
		MASCLR::log_message "Accumulated $batch_total_amount $file_total_amount $batch_total_count $file_total_count"

		## Writing last batch Trailer Record
		set rec(batch_amt) $batch_total_amount
		set rec(batch_cnt) $batch_total_count
		write_bt_record $fileid rec
		set batch_total_count 0
		set batch_total_amount 0
	} ;# end while to fetch all arbitration transactions

	# Writing File Trailer Record

	set rec(file_amt) $file_total_amount
	set rec(file_cnt) $file_total_count

	write_ft_record $fileid rec

	# Closing Output file

	close $fileid

	if { $matches_found > 0 } {
		global env
		set target_directory "[exec pwd]/MAS_FILES"
		append THIS::EMAIL_BODY "\n\nMAS file $env(SYS_BOX):$target_directory/$THIS::OUTFILE prepared for importing in MAS"

		MASCLR::close_file $THIS::OUT_SQL_FILE

		## Prepare permissions for MAS
		if { [catch {exec chmod 775 $THIS::OUTFILE} failure] } {
			MASCLR::log_message "Could not chmod $THIS::OUTFILE: $failure"
		}
		if { [catch {exec mv $THIS::OUTFILE $target_directory} failure] } {
			MASCLR::log_message "Could not move $THIS::OUTFILE to $target_directory : $failure"
		}
		# sending an sql update file to shannon to run later -- this is only going to happen for a few weeks, then will switch to live updates
		set email(file_list) "$THIS::OUT_SQL_FILE"
		set email(mailto) "clearing@jetpay.com,cblizzard@tsys.com,chargebacks@jetpay.com"
		set email(mailfrom) ""
		set email(subject) "Arbitration settlement report for $THIS::TRANS_DATE to $THIS::END_DATE for institution $THIS::INSTITUTION_ID_VAR"
		set email(body) $THIS::EMAIL_BODY
		if { [catch {MASCLR::send_info_email [array get email]} failure] } {
			MASCLR::log_message "Could not send email: $failure"
		}
#		if { [catch {exec echo $email(body) | mailx -s "$email(subject)" $email(mailto)} failure] } {
#			MASCLR::log_message "Could not send email: $failure"
#		}
#		set email(subject) "Arbitration settlement follow-up sql for $THIS::TRANS_DATE to $THIS::END_DATE for  $THIS::INSTITUTION_ID_VAR"
#		if { [catch {MASCLR::send_info_email [array get email]} failure] } {
#			MASCLR::log_message "Could not send email: $failure"
#		}
#		if { [catch {exec cat $THIS::OUT_SQL_FILE | mailx -s "$email(subject)" $email(mailto)} failure] } {
#			MASCLR::log_message "Could not send email: $failure"
#		}
		if { [catch {exec mv $THIS::OUT_SQL_FILE ARCHIVE} failure] } {
			MASCLR::log_message "Could not archive sql file $THIS::OUT_SQL_FILE: $failure"
		}

	} else {
		catch {file delete $THIS::OUTFILE} failure
		catch {file delete $THIS::OUT_SQL_FILE} failure
	}

	# need to close cursors update_cursor and get_arb_records_cursor
	MASCLR::close_cursor $update_cursor
	MASCLR::close_cursor $insert_cursor
	MASCLR::close_cursor $get_arb_records_cursor
	MASCLR::close_cursor $get_original_cb_cursor
	MASCLR::close_cursor $get_mas_code_tid_cursor

	MASCLR::close_all_and_exit_with_code 0
}

# end main

main

