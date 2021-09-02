#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: ep_reject_chk.tcl 3597 2015-12-01 21:27:00Z bjones $
# $Rev: 3597 $
################################################################################
#
# File Name:  ems_report.tcl
#
# Description:  This program generates an Event Management System (EMS) report
#               for dispute and reject activity by institution.
#              
# Script Arguments:  report_date = Run date (e.g., YYYYMMDD).  Optional.  
#                                  Defaults to current date.
#
# Output:  Report emails to configured parties.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

package require Oratcl

#Environment veriables
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

#Email Body Headers variables for rkhan
set mbody_c "ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
set mbody_u "ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
set mbody_h "ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
set mbody_m "ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
set mbody_l "ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

#System information variables....
set sysinfo "System: $box\n Location: $env(PWD) \n\n"

set dt [lindex argv 0]

if {$argc == 1} {
	set currdate "$dt"
	set e_date [string toupper [clock format [ clock scan "$currdate -0 day" ] -format %d-%b-%y]]
	set logdate [clock seconds]
	set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]
} else {
	set logdate [clock seconds]
	set e_date [string toupper [clock format $logdate -format "%d-%b-%y"]]
}

puts $e_date

proc connect_to_db {} {
    global db_logon_handle db_connect_handle msubj_c msubj_u msubj_h msubj_m msubj_l
    global mbody_c mbody_u mbody_h mbody_m mbody_l box clrpath maspath mailtolist mailfromlist clrdb authdb

    if {[catch {set db_logon_handle [oralogon masclr/masclr@$clrdb]} result] } {
        puts "Encountered error $result while trying to connect to DB"
        set mbody "Reject check code could not logon to DB : Msg sent from $env(PWD)/rejeck_chk.tcl\n $result"
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        exit 1
    }
};# end connect_to_db

connect_to_db

set get   [oraopen $db_logon_handle]
set get1  [oraopen $db_logon_handle]
set get2  [oraopen $db_logon_handle]
set get3  [oraopen $db_logon_handle]
set get4  [oraopen $db_logon_handle]
set get20 [oraopen $db_logon_handle]
set get21 [oraopen $db_logon_handle]
set get22 [oraopen $db_logon_handle]
set get23 [oraopen $db_logon_handle]
set get91 [oraopen $db_logon_handle]

set outfile "Priorty.EMS.Notification.Details.$logdate.txt"
set outfile1 "Secondary.EMS.Notification.Detail.$logdate.txt"
set enotify 1

set tcr(MSG) {
	EP_EVENT_ID			12 n {Exception Processing Event Id}
	INSTITUTION_ID 		10 a {Clearing Institution Id}
	TRANS_SEQ_NBR 		12 n {Transaction Sequence Number}
	TRANS_SEQ_NBR_ORIG 	12 n {Original Transaction Sequence Number}
	CARD_SCHEME 		 2 a {Transaction Card Type}
	PAN 				25 a {Card Number}
	PAN_SEQ  			 3 n {Card Number Sequence}
	ARN 				23 a {ARN}
	SEND_ID 			11 a {Send Id}
	RECEIVE_ID 			11 a {Receive Id}
	TRANS_DT 			16 a {Transaction Date}
	MERCH_ID 			30 a {Merchant id}
	AMT_CH_BILL 		15 n {AMT_CH_BILL}
	CH_BILL_CCD 		 3 n {CH_BILL_CCD}
	CH_BILL_EXP 		 1 n {CH_BILL_EXP}
	AMT_TRANS 			15 n {Transaction Amount}
	TRANS_CCD 			 3 n {Transaction Currency Code}
	TRANS_EXP 			 1 n {Trnasaction EXP}
	EMS_CASE_NBR 		15 a {EMS Case Number}
	EMS_ITEM_TYPE 		 4 a {EMS Item Type}
	EMS_DUE_DATE 		16 a {EMS Due Date}
	EMS_OPERATION 		10 a {EMS Operation}
	EMS_OPER_AMT_CR		15 n {EMS Operation Amount Credit}
	EMS_OPER_ACCT_CR 	10 a {EMS Operation Account Credit}
	EMS_OPER_AMT_DB 	15 n {EMS Operation Amount Debit}
	EMS_OPER_ACCT_DB 	10 a {EMS Operation Account Debit}
	EMS_OPER_CCD 		 3 a {EMS Operation Currency Code}
	EMS_OPER_EXP 		 1 n {EMS Operation EXP}
	EMS_DEPARTMENT 		10 a {EMS Department}
	PROCESS 			 5 a {Process}
	REASON_CD 			 4 n {Exception Reason Code}
	EVENT_STATUS 		10 a {Event Status}
	EVENT_REASON 		 4 a {Event Reason}
	MEMO_FREE_TEXT	   100 a {Memo Free Text}
	EVENT_LOG_DATE 		16 a {Event Log Date}
	EVENT_UPD_DATE 		16 a {Event Update Date}
	CP_TO_HISTORY 		 1 a {Copy to History}
	EMS_SPEC_DATA1	   255 a {EMS Specific Data1}
	EMS_SPEC_DATA2	   255 a {EMS Specific Data2}
	EMS_SPEC_DATA3	   255 a {EMS Specific Data3}
	EMS_SPEC_DATA4	   255 a {EMS Specific Data4}
	IN_FILE_NBR	         9 n {Incoming File Number}
	ISS_ACQ_IND 		 3 a {ISS_ACQ_IND}
	EMS_LEDGER 			12 a {EMS Ledger}
}

#Opening Output file to write to
if [catch {open $outfile {WRONLY CREAT APPEND}} fileid1] {
	puts stderr "Cannot open /duplog : $fileid"
	exit 1
}

if [catch {open $outfile1 {WRONLY CREAT APPEND}} fileid2] {
	puts stderr "Cannot open /duplog : $fileid"
	exit 1
}


#Procedure for construct tcr records according to above definitions.
proc write_tcr {aname} {
    global tcr
    upvar $aname a
    set l_tcr $a(tcr)
    set result {}

    foreach {fname flength ftype fdesc} $tcr(${l_tcr}) {
        switch -- $ftype {
            a { if {![info exists  a($fname)]} {
                    set  a($fname) {}
                }
                set t [format "%-${flength}.${flength}s" $a($fname)]
                set result "$result$t"
              }
            n { if {![info exists  a($fname)] || ($fname == "filler")} {
                    set  a($fname) 0
                }
                set t [format "%0${flength}.${flength}d" $a($fname)]
                set result "$result$t"
              }
            x { if {![info exists  a($fname)]} {
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
	set i 1

    foreach {fname flength ftype fdesc} $tcr(${l_tcr}) {
		if {[string length $a($fname)] > 14} {
			puts $fd "[format "%-40s >%s<" $fdesc $a($fname)]"
		} else {
			if {$i == 1} {
				puts -nonewline $fd "[format "%-40s >%s<" $fdesc $a($fname)]"
				puts -nonewline $fd "[format "%[expr 16 - [string length $a($fname)]]s" " "]"
				set i 0
			} else {
				set i 1
				puts $fd "[format "%-40s >%s<" $fdesc $a($fname)]"
			}
		}
    }
}


proc write_msg_record {fd aname} {
    global tcr
    upvar $aname a

	set rec(tcr) "MSG"
	set rec(EP_EVENT_ID) $a(EP_EVENT_ID)
	set rec(INSTITUTION_ID) $a(INSTITUTION_ID)
	set rec(TRANS_SEQ_NBR) $a(TRANS_SEQ_NBR)
	set rec(TRANS_SEQ_NBR_ORIG) $a(TRANS_SEQ_NBR_ORIG)
	set rec(CARD_SCHEME) $a(CARD_SCHEME)
	set rec(PAN) " "
	set rec(PAN_SEQ) $a(PAN_SEQ)
	set rec(ARN) $a(ARN)
	set rec(SEND_ID) $a(SEND_ID)
	set rec(RECEIVE_ID) $a(RECEIVE_ID)
	set rec(TRANS_DT) $a(TRANS_DT)
	set rec(MERCH_ID) $a(MERCH_ID)
	set rec(AMT_CH_BILL) $a(AMT_CH_BILL)
	set rec(CH_BILL_CCD) $a(CH_BILL_CCD)
	set rec(CH_BILL_EXP) $a(CH_BILL_EXP)
	set rec(AMT_TRANS) $a(AMT_TRANS)
	set rec(TRANS_CCD) $a(TRANS_CCD)
	set rec(TRANS_EXP) $a(TRANS_EXP)
	set rec(EMS_CASE_NBR) $a(EMS_CASE_NBR)
	set rec(EMS_ITEM_TYPE) $a(EMS_ITEM_TYPE)
	set rec(EMS_DUE_DATE) $a(EMS_DUE_DATE)
	set rec(EMS_OPERATION) $a(EMS_OPERATION)
	set rec(EMS_OPER_AMT_CR) $a(EMS_OPER_AMT_CR)
	set rec(EMS_OPER_ACCT_CR) $a(EMS_OPER_ACCT_CR)
	set rec(EMS_OPER_AMT_DB) $a(EMS_OPER_AMT_DB)
	set rec(EMS_OPER_ACCT_DB) $a(EMS_OPER_ACCT_DB)
	set rec(EMS_OPER_CCD) $a(EMS_OPER_CCD)
	set rec(EMS_OPER_EXP) $a(EMS_OPER_EXP)
	set rec(EMS_DEPARTMENT) $a(EMS_DEPARTMENT)
	set rec(PROCESS) $a(PROCESS)
	set rec(REASON_CD) $a(REASON_CD)
	set rec(EVENT_STATUS) $a(EVENT_STATUS)
	set rec(EVENT_REASON) $a(EVENT_REASON)
	set rec(MEMO_FREE_TEXT) $a(MEMO_FREE_TEXT)
	set rec(EVENT_LOG_DATE) $a(EVENT_LOG_DATE)
	set rec(EVENT_UPD_DATE) $a(EVENT_UPD_DATE)
	set rec(CP_TO_HISTORY) $a(CP_TO_HISTORY)
	set rec(EMS_SPEC_DATA1) $a(EMS_SPEC_DATA1)
	set rec(EMS_SPEC_DATA2) $a(EMS_SPEC_DATA2)
	set rec(EMS_SPEC_DATA3) $a(EMS_SPEC_DATA3)
	set rec(EMS_SPEC_DATA4) $a(EMS_SPEC_DATA4)
	set rec(IN_FILE_NBR) $a(IN_FILE_NBR)
	set rec(ISS_ACQ_IND) $a(ISS_ACQ_IND)
	set rec(EMS_LEDGER) $a(EMS_LEDGER)

    puts $fd [print_tcr rec]
}


#Pulling ems codes description and building an array for later use.
set s "select * from MC_EMS_CODE"

orasql $get $s

while {[set y [orafetch $get -datavariable mscd]] == 0} {
	set msg_rsn_cd [lindex $mscd 0]
	set f_cd [lindex $mscd 1]
	set msg_tp_cd [lindex $mscd 2]
	set msg_tp_desc [lindex $mscd 3]
	set msg_rsn_cd_desc1 [lindex $mscd 4]
	set msg_rsn_cd_desc2 [lindex $mscd 5]
	
	set msg_type_desc($msg_rsn_cd-$f_cd-$msg_tp_cd) $msg_tp_desc
	set msg_rsn_cd_desc($msg_rsn_cd-$f_cd-$msg_tp_cd) "$msg_rsn_cd_desc1 $msg_rsn_cd_desc2"
}

set q "select * from VS_EMS_CODE"

orasql $get1 $q

while {[set z [orafetch $get1 -datavariable vscd]] == 0} {
	set vs_msg_rsn_cd [lindex $vscd 0]
	set vs_f_cd [lindex $vscd 1]
	set vs_msg_tp_cd [lindex $vscd 2]
	set op_reg [lindex $vscd 3]
	set vs_msg_tp_desc [lindex $vscd 4]
	set vs_msg_rsn_cd_desc [lindex $vscd 5]
	set all [lindex $vscd 6]
	set int [lindex $vscd 7]
	set us [lindex $vscd 8]
	set ap [lindex $vscd 9]
	set uk [lindex $vscd 10]
	set can [lindex $vscd 11]
	set otr [lindex $vscd 12]
	
	set vs_msg_type_arry($vs_msg_rsn_cd) $vs_msg_tp_desc
	set vs_msg_rsn_cd_arry($vs_msg_rsn_cd) "\n\nALL_REGION:\n$all\nINTERNATIONAL:\n$int\nUS_REGION:\n$us\nAP_REGION:\n$ap\nUK_DOMESTIC:\n$uk\nCANADA_REGION:\n$can\nOTHER_REGION:\n$otr"
}

set q "select * from DS_EMS_CODE"

orasql $get1 $q

while {[set z [orafetch $get1 -dataarray dscd -indexbyname]] == 0} {
	set ds_rsn_cd($dscd(MESSAGE_REASON_CODE)-$dscd(FUNCTION_CODE)-$dscd(MESSAGE_TYPE_CD)-$dscd(ACTION_CD)) $dscd(DISC_REASON_CD)
	set ds_msg_type_arry($dscd(MESSAGE_REASON_CODE)-$dscd(FUNCTION_CODE)-$dscd(MESSAGE_TYPE_CD)-$dscd(ACTION_CD)) $dscd(MSG_TYPE_DESC)
	set ds_msg_rsn_cd_arry($dscd(MESSAGE_REASON_CODE)-$dscd(FUNCTION_CODE)-$dscd(MESSAGE_TYPE_CD)-$dscd(ACTION_CD)) "\n\n$dscd(MSG_REASON_CD_DESC_1)\n\n$dscd(MSG_REASON_CD_DESC_2)\n\n$dscd(MSG_REASON_CD_DESC_3)"
}

set sql1 "select e.EP_EVENT_ID,
                 e.INSTITUTION_ID,
				 e.TRANS_SEQ_NBR,
				 e.TRANS_SEQ_NBR_ORIG,
				 e.CARD_SCHEME,
				 e.PAN,e.PAN_SEQ,
				 e.ARN,e.SEND_ID,
				 e.RECEIVE_ID,
				 e.TRANS_DT,
				 e.MERCH_ID,
				 e.AMT_CH_BILL,
				 e.CH_BILL_CCD,
				 e.CH_BILL_EXP,
				 e.AMT_TRANS,
				 e.TRANS_CCD,
				 e.TRANS_EXP,
				 e.EMS_CASE_NBR,
				 e.EMS_ITEM_TYPE,
				 e.EMS_DUE_DATE,
				 e.EMS_OPERATION,
				 e.EMS_OPER_AMT_CR,
				 e.EMS_OPER_ACCT_CR,
				 e.EMS_OPER_AMT_DB,
				 e.EMS_OPER_ACCT_DB,
				 e.EMS_OPER_CCD,
				 e.EMS_OPER_EXP,
				 e.EMS_DEPARTMENT,
				 e.PROCESS,
				 e.REASON_CD,
				 e.EVENT_STATUS,
				 e.EVENT_REASON,
				 e.MEMO_FREE_TEXT,
				 e.EVENT_LOG_DATE,
				 e.EVENT_UPD_DATE,
				 e.CP_TO_HISTORY,
				 e.EMS_SPEC_DATA1,
				 e.EMS_SPEC_DATA2,
				 e.EMS_SPEC_DATA3,
				 e.EMS_SPEC_DATA4,
				 e.IN_FILE_NBR,
				 e.ISS_ACQ_IND,
				 e.EMS_LEDGER,
				 i.trans_seq_nbr,
				 i.card_scheme,
				 i.msg_type,
				 i.in_file_nbr,
				 i.in_batch_nbr,
				 i.pan,
				 i.cnv_rate_recon,
				 i.amt_original,
				 i.original_exp,
				 i.trans_dt,
				 i.function_cd,
				 i.reason_cd,
				 i.arn,
				 i.auth_cd,
				 i.merch_id,
				 i.merch_name,
				 i.settl_method_ind,
				 i.msg_nbr,
				 i.trans_clr_status,
				 i.src_inst_id,
				 i.src_file_type,
				 i.activity_dt,
				 i.msg_text_block,
				 i.req_reason_cd
	from EP_EVENT_LOG e, in_draft_main i
	where e.event_log_date = '$e_date' and
	      e.EVENT_STATUS in ('NOTIFY', 'NEW') and
	      e.trans_seq_nbr = i.trans_seq_nbr
	order by e.trans_seq_nbr"

orasql $get2 $sql1

set vsrej 1
set 2rprej 0
set ipmrejectmail 1

while {[set x [orafetch $get2 -dataarray a -indexbyname]] == 0} { 

	puts ">$a(EMS_ITEM_TYPE)-$a(REASON_CD)-$a(CARD_SCHEME)-$a(EP_EVENT_ID)<"
	
	if {![info exists ds_msg_type_arry($a(REASON_CD)-$a(FUNCTION_CD)-$a(MSG_TYPE)-$a(REQ_REASON_CD))]} {
		set ds_msg_type_arry($a(REASON_CD)-$a(FUNCTION_CD)-$a(MSG_TYPE)-$a(REQ_REASON_CD)) "Unknow Please research"
	}
	
	if {![info exists ds_rsn_cd($a(REASON_CD)-$a(FUNCTION_CD)-$a(MSG_TYPE)-$a(REQ_REASON_CD))]} {
		set ds_rsn_cd($a(REASON_CD)-$a(FUNCTION_CD)-$a(MSG_TYPE)-$a(REQ_REASON_CD)) "Unknow Please research"
	}
	
	if {$a(EMS_ITEM_TYPE) != " "} {
		if {$a(REASON_CD) != "6802"} {
			set rec(tcr) "MSG"
			set rec(EP_EVENT_ID) $a(EP_EVENT_ID)
			set rec(INSTITUTION_ID) $a(INSTITUTION_ID)
			set rec(TRANS_SEQ_NBR) $a(TRANS_SEQ_NBR)
			set rec(TRANS_SEQ_NBR_ORIG) $a(TRANS_SEQ_NBR_ORIG)
			set rec(CARD_SCHEME) $a(CARD_SCHEME)
			set rec(PAN) " "
			set rec(PAN_SEQ) $a(PAN_SEQ)
			set rec(ARN) $a(ARN)
			set rec(SEND_ID) $a(SEND_ID)
			set rec(RECEIVE_ID) $a(RECEIVE_ID)
			set rec(TRANS_DT) $a(TRANS_DT)
			set rec(MERCH_ID) $a(MERCH_ID)
			set rec(AMT_CH_BILL) $a(AMT_CH_BILL)
			set rec(CH_BILL_CCD) $a(CH_BILL_CCD)
			set rec(CH_BILL_EXP) $a(CH_BILL_EXP)
			set rec(AMT_TRANS) $a(AMT_TRANS)
			set rec(TRANS_CCD) $a(TRANS_CCD)
			set rec(TRANS_EXP) $a(TRANS_EXP)
			set rec(EMS_CASE_NBR) $a(EMS_CASE_NBR)
	
			set tempeml "999.email"

			switch $a(EMS_ITEM_TYPE) {
			"CR1" 	{set cb_type "CR1 ( 1st Presentment Reject)"; set fileid $fileid1
					 if {$a(CARD_SCHEME) == "04"} {
					 	set vsrej 0 
					 }
					 if {$a(CARD_SCHEME) == "05"} {
						set rejectmail 0
					 }
					}
			"CR2" 	{if {$a(EVENT_REASON) == "EINC"} {
						set cb_type "CR2 ( 2nd Presentment )"; set fileid $fileid1
					 }
					 if {$a(EVENT_REASON) == "ERET"} {
						set cb_type "CR2 ( 2nd Presentment Reject)"; set fileid $fileid1
						if {$2rprej == 0} {
							exec echo "We have atleast one 2nd presentment rejected. Please, see EP ALERT for Detail" | mailx -s "2ND PRESENTMENT REJECT ALERT" clearing@jetpay.com 
							set 2rprej 1
						}
					}} 
			"CB1" 	{set cb_type "CB1 ( 1st Chargeback )"; set fileid $fileid1; set enotify 0;
					 set sql20 "select * from IN_DRAFT_MAIN where arn = '$a(ARN)' and tid in ('010103005101', '010103005102')"
					 puts $sql20
					 orasql $get20 $sql20
					 if {[orafetch $get20 -dataarray cb -indexbyname] != 1403} {
						switch $cb(SRC_INST_ID) {
							"101"	{ switch [string range $cb(MERCH_ID) 7 8] {
										"96"    {set iss "96"}
										"85"    {set iss "85"}
										default {set iss "JPMS"}
									}
									set tempeml "$cb(SRC_INST_ID).$iss.email"
									}
							"105"   {set tempeml "$cb(SRC_INST_ID).email"}
							"107"   {set tempeml "$cb(SRC_INST_ID).email"}
							"111"   {set tempeml "$cb(SRC_INST_ID).email"}
							"117"   {set tempeml "$cb(SRC_INST_ID).email"}
							"121"   {set tempeml "$cb(SRC_INST_ID).email"}
							default {set tempeml "$cb(SRC_INST_ID).email"} 
						}
						exec echo "[string toupper $cb_type]" >> $tempeml
						if {[string trim $a(CARD_SCHEME)] == "05"} {
								if {$a(REASON_CD) != "6802"} {
									exec echo "[format %-25s "Message Card Type"] : $a(CARD_SCHEME)" >> $tempeml
									exec echo "[format %-25s "Message Reason code"] : $a(REASON_CD)" >> $tempeml
									if { [info exists msg_rsn_cd_desc($a(REASON_CD)-$a(FUNCTION_CD)-$a(MSG_TYPE))] } {
										exec echo "[format %-25s "Description"] : $msg_rsn_cd_desc($a(REASON_CD)-$a(FUNCTION_CD)-$a(MSG_TYPE))" >> $tempeml
									} else {
										exec echo "unknown combination of reason code $a(REASON_CD) message type $a(MSG_TYPE) and function code $a(FUNCTION_CD)" >> $tempeml
									}
								}
						} elseif {[string trim $a(CARD_SCHEME)] == "04"} {
								if {$a(REASON_CD) != "0"} {
									exec echo "[format %-25s "Message Card Type"] : $a(CARD_SCHEME)" >> $tempeml
									exec echo "[format %-25s "Message Reason code"] : $a(REASON_CD)" >> $tempeml
									exec echo "[format %-25s "Description"] : $vs_msg_type_arry($a(REASON_CD))" >> $tempeml
								}
						} elseif {[string trim $a(CARD_SCHEME)] == "08"} {
								if {$a(REASON_CD) != "0"} {
									exec echo "[format %-25s "Message Card Type"] : $a(CARD_SCHEME)" >> $tempeml
									exec echo "[format %-25s "Message Reason code"] : $a(REASON_CD) OR $ds_rsn_cd($a(REASON_CD)-$a(FUNCTION_CD)-$a(MSG_TYPE)-$a(REQ_REASON_CD))" >> $tempeml
									exec echo "[format %-25s "Description"] : $ds_msg_type_arry($a(REASON_CD)-$a(FUNCTION_CD)-$a(MSG_TYPE)-$a(REQ_REASON_CD))" >> $tempeml
								}
						} else {if {$a(REASON_CD) != "0"} {
									exec echo "[format %-25s "Message Card Type"] : $a(CARD_SCHEME)" >> $tempeml
									exec echo "[format %-25s "Message Reason code"] : $a(REASON_CD)" >> $tempeml
									exec echo "[format %-25s "Description"] : Unknow reason code $a(REASON_CD) for Card Type $a(CARD_SCHEME)" >> $tempeml
									exec echo "[format %-25s "ARN"] : $a(ARN)" >> $tempeml
								}
						}
						set sql91 "select * from IN_DRAFT_MAIN where trans_seq_nbr = $a(TRANS_SEQ_NBR)"
						orasql $get91 $sql91
						puts $sql91
						exec echo "[format %-30s $cb(MERCH_NAME)][format %-20s $cb(MERCH_ID)][format %-20s "Amount = $[expr $a(AMT_TRANS)/ pow(10, $a(TRANS_EXP))]"] -- Currency = $a(TRANS_CCD)\n" >> $tempeml
						
						if {$a(TRANS_CCD) != $cb(TRANS_CCD)} {
							exec echo "Alert!!! Original Currency Code do not match with CB currency code.\n CB CCD : $a(TRANS_CCD) :: ORIG CCD : $cb(TRANS_CCD) \n ORIG AMT : $[expr $cb(AMT_TRANS)/pow(10, $cb(TRANS_EXP))] \n" >> $tempeml
									if {[orafetch $get91 -dataarray idma -indexbyname] != 1403} {
										exec echo " RECON AMT : $[expr $idma(AMT_RECON)/ pow(10, $idma(RECON_EXP))] RECON CCD : $idma(RECON_CCD) \n" >> $tempeml
									}
						}
					} else {
						exec echo "Can not locate arn:$a(ARN) in IN_DRAFT_MAIN" >> no_orig_list_$logdate.log
					}}
			"CB2" 	{set cb_type "CB2 ( 2nd Chargeback )"; set fileid $fileid1; set enotify 0
					 set sql21 "select * from IN_DRAFT_MAIN where arn = '$a(ARN)' and tid in ('010103005101', '010103005102')"
					 puts $sql21
					 orasql $get21 $sql21
					 if {[orafetch $get21 -dataarray cb2 -indexbyname] != 1403} {
						switch $cb2(SRC_INST_ID) {
							"101"   {switch [string range $cb2(MERCH_ID) 7 8] {
										"96"	{set iss "96"}
										"85"	{set iss "85"}
										default {set iss "JPMS"}
									}
									set tempeml "$cb2(SRC_INST_ID).$iss.email"
									}
							"105"   {set tempeml "$cb2(SRC_INST_ID).email"}
							"107"   {set tempeml "$cb2(SRC_INST_ID).email"}
							"111"   {set tempeml "$cb2(SRC_INST_ID).email"}
							"117"   {set tempeml "$cb2(SRC_INST_ID).email"}
							"121"   {set tempeml "$cb2(SRC_INST_ID).email"}
							default {set tempeml "$cb2(SRC_INST_ID).email"}
							}
							
							exec echo "[string toupper $cb_type]" >> $tempeml
							if {[string trim $a(CARD_SCHEME)] == "05"} {
								if {$a(REASON_CD) != "6802"} {
									exec echo "[format %-25s "Message Card Type"] : $a(CARD_SCHEME)" >> $tempeml
									exec echo "[format %-25s "Message Reason code"] : $a(REASON_CD)" >> $tempeml
									if { [info exists msg_rsn_cd_desc($a(REASON_CD)-$a(FUNCTION_CD)-$a(MSG_TYPE))] } {
										exec echo "[format %-25s "Description"] : $msg_rsn_cd_desc($a(REASON_CD)-$a(FUNCTION_CD)-$a(MSG_TYPE))" >> $tempeml
									} else {
										exec echo "unknown combination of reason code $a(REASON_CD) message type $a(MSG_TYPE) and function code $a(FUNCTION_CD)" >> $tempeml
									}
								}
							} elseif {[string trim $a(CARD_SCHEME)] == "04"} {
								if {$a(REASON_CD) != "0"} {
									exec echo "[format %-25s "Message Card Type"] : $a(CARD_SCHEME)" >> $tempeml
									exec echo "[format %-25s "Message Reason code"] : $a(REASON_CD)" >> $tempeml
									exec echo "[format %-25s "Description"] : $vs_msg_type_arry($a(REASON_CD))" >> $tempeml
								}
							} elseif {[string trim $a(CARD_SCHEME)] == "08"} {
								if {$a(REASON_CD) != "0"} {
									exec echo "[format %-25s "Message Card Type"] : $a(CARD_SCHEME)" >> $tempeml
									exec echo "[format %-25s "Message Reason code"] : $a(REASON_CD) OR $ds_rsn_cd($a(REASON_CD)-$a(FUNCTION_CD)-$a(MSG_TYPE)-$a(REQ_REASON_CD))" >> $tempeml
									exec echo "[format %-25s "Description"] : $ds_msg_type_arry($a(REASON_CD)-$a(FUNCTION_CD)-$a(MSG_TYPE)-$a(REQ_REASON_CD))" >> $tempeml
								}
							} else {
								if {$a(REASON_CD) != "0"} {
									exec echo "[format %-25s "Message Card Type"] : $a(CARD_SCHEME)" >> $tempeml
									exec echo "[format %-25s "Message Reason code"] : $a(REASON_CD)" >> $tempeml
									exec echo "[format %-25s "Description"] : Unknow reason code $a(REASON_CD) for Card Type $a(CARD_SCHEME)" >> $tempeml
								}
							}
							exec echo "[string toupper $cb_type]\n[format %-30s $cb2(MERCH_NAME)][format %-20s $cb2(MERCH_ID)][format %-20s "Amount = $[expr $a(AMT_TRANS)/pow(10,$a(TRANS_EXP))]"] -- Currency = $a(TRANS_CCD)\n" >> $tempeml
							if {$a(TRANS_CCD) != $cb2(TRANS_CCD)} {
								exec echo "Alert!!! Original Currency Code do not match with CB currency code. CB CCD : $a(TRANS_CCD) :: ORIG CCD : $cb2(TRANS_CCD) \n ORIG AMT : $[expr $cb2(AMT_TRANS)/pow(10,$cb2(TRANS_EXP))]" >> $tempeml
								set sql91 "select * from IN_DRAFT_MAIN where trans_seq_nbr = $a(TRANS_SEQ_NBR)"
								orasql $get91 $sql91
								if {[orafetch $get91 -dataarray idma -indexbyname] != 1403} {
									exec echo " RECON AMT : $[expr $idma(AMT_RECON)/pow(10,$idma(RECON_EXP))] RECON CCD : $idma(RECON_CCD) \n" >> $tempeml
								}
							}
					} else {
						exec echo "Can not locate arn:$a(ARN) in IN_DRAFT_MAIN" >> no_orig_list_$logdate.log
					}}
			"RR1" 	{set cb_type "RR1 ( Retrival Request )"; set fileid $fileid1; set enotify 0;
					 set sql22 "select * from IN_DRAFT_MAIN where arn = '$a(ARN)' and tid in ('010103005101', '010103005102')"
					 puts $sql22
					 orasql $get22 $sql22
					 if {[orafetch $get22 -dataarray rr1 -indexbyname] != 1403 } {
						switch $rr1(SRC_INST_ID) {
							"101"   {switch [string range $rr1(MERCH_ID) 7 8] {
										"96"    {set iss "96"}
										"85"    {set iss "85"}
										default {set iss "JPMS"}
									}
									set tempeml "$rr1(SRC_INST_ID).$iss.email"
									}
							"105"   {set tempeml "$rr1(SRC_INST_ID).email"}
							"107"   {set tempeml "$rr1(SRC_INST_ID).email"}
							"111"   {set tempeml "$rr1(SRC_INST_ID).email"}
							"117"   {set tempeml "$rr1(SRC_INST_ID).email"}
							"121"   {set tempeml "$rr1(SRC_INST_ID).email"}
							default {set tempeml "$rr1(SRC_INST_ID).email"}
							}
	
					 exec echo "[string toupper $cb_type]" >> $tempeml
					 if {[string trim $a(CARD_SCHEME)] == "05"} {
						if {$a(REASON_CD) != "6802"} {
							exec echo "[format %-25s "Message Card Type"] : $a(CARD_SCHEME)" >> $tempeml
							exec echo "[format %-25s "Message Reason code"] : $a(REASON_CD)" >> $tempeml
							exec echo "[format %-25s "Description"] : Pls check MC DOC for DESC " >> $tempeml
						}
					 } elseif {[string trim $a(CARD_SCHEME)] == "04"} {
						if {$a(REASON_CD) != "0"} {
							exec echo "[format %-25s "Message Card Type"] : $a(CARD_SCHEME)" >> $tempeml
							exec echo "[format %-25s "Message Reason code"] : $a(REASON_CD)" >> $tempeml
							exec echo "[format %-25s "Description"] : $vs_msg_type_arry($a(REASON_CD))" >> $tempeml
						}
					 } elseif {[string trim $a(CARD_SCHEME)] == "08"} {
						if {$a(REASON_CD) != "0"} {
							exec echo "[format %-25s "Message Card Type"] : $a(CARD_SCHEME)" >> $tempeml
							exec echo "[format %-25s "Message Reason code"] : $a(REASON_CD) OR $ds_rsn_cd($a(REASON_CD)-$a(FUNCTION_CD)-$a(MSG_TYPE)-$a(REQ_REASON_CD))" >> $tempeml
							exec echo "[format %-25s "Description"] : $ds_msg_type_arry($a(REASON_CD)-$a(FUNCTION_CD)-$a(MSG_TYPE)-$a(REQ_REASON_CD))" >> $tempeml
						}
					 } else {
						if {$a(REASON_CD) != "0"} {
							exec echo "[format %-25s "Message Card Type"] : $a(CARD_SCHEME)" >> $tempeml
							exec echo "[format %-25s "Message Reason code"] : $a(REASON_CD)" >> $tempeml
							exec echo "[format %-25s "Description"] : Unknow reason code $a(REASON_CD)" >> $tempeml
							exec echo "ARN: $a(ARN)" >> $tempeml
						}
					 }
					 exec echo "[string toupper $cb_type]\n[format %-30s $rr1(MERCH_NAME)][format %-20s $rr1(MERCH_ID)][format %-20s "Amount = $[expr $a(AMT_ORIGINAL)/pow(10, $a(ORIGINAL_EXP))]"]\n" >> $tempeml
					 } else {
						exec echo "Can not locate arn:$a(ARN) in IN_DRAFT_MAIN" >> no_orig_list_$logdate.log
					}}
			"FI1" 	{set cb_type "FI1 ( Fee Collection/Funds Disbursment )"; set fileid $fileid1}
			"MI1" 	{set cb_type "MI1 ( Fee Collection/Funds Disbursment )"; set fileid $fileid1}
			"FRA" 	{set cb_type "FRA ( Fraud Transaction )"; set fileid $fileid1}
			"PR1" 	{set cb_type "PR1 ( 1st Presentment Reversal )"; set fileid $fileid1}
			"PR2" 	{set cb_type "PR2 ( 2nd Presentment Reversal )"; set fileid $fileid1}
			default {set cb_type ">$a(EMS_ITEM_TYPE)< ( **** Text/Unknown EMS type **** )"; set fileid $fileid2}
			}
	
			set rec(EMS_ITEM_TYPE) $a(EMS_ITEM_TYPE)
			set rec(EMS_DUE_DATE) $a(EMS_DUE_DATE)
			set rec(EMS_OPERATION) $a(EMS_OPERATION)
			set rec(EMS_OPER_AMT_CR) $a(EMS_OPER_AMT_CR)
			set rec(EMS_OPER_ACCT_CR) $a(EMS_OPER_ACCT_CR)
			set rec(EMS_OPER_AMT_DB) $a(EMS_OPER_AMT_DB)
			set rec(EMS_OPER_ACCT_DB) $a(EMS_OPER_ACCT_DB)
			set rec(EMS_OPER_CCD) $a(EMS_OPER_CCD)
			set rec(EMS_OPER_EXP) $a(EMS_OPER_EXP)
			set rec(EMS_DEPARTMENT) $a(EMS_DEPARTMENT)
			set rec(PROCESS) $a(PROCESS)
			set rec(REASON_CD) $a(REASON_CD)
			set rec(EVENT_STATUS) $a(EVENT_STATUS)
			set rec(EVENT_REASON) $a(EVENT_REASON)
			set rec(MEMO_FREE_TEXT) $a(MEMO_FREE_TEXT)
			set rec(EVENT_LOG_DATE) $a(EVENT_LOG_DATE)
			set rec(EVENT_UPD_DATE) $a(EVENT_UPD_DATE)
			set rec(CP_TO_HISTORY) $a(CP_TO_HISTORY)
			set rec(EMS_SPEC_DATA1) $a(EMS_SPEC_DATA1)
			set rec(EMS_SPEC_DATA2) $a(EMS_SPEC_DATA2)
			set rec(EMS_SPEC_DATA3) $a(EMS_SPEC_DATA3)
			set rec(EMS_SPEC_DATA4) $a(EMS_SPEC_DATA4)
			set rec(IN_FILE_NBR) $a(IN_FILE_NBR)
			set rec(ISS_ACQ_IND) $a(ISS_ACQ_IND)
			set rec(EMS_LEDGER) $a(EMS_LEDGER)
	
			puts $fileid "TABLE:	IN_DRAFT_MAIN\n"
			
			puts  $fileid "[format %-40s "Transaction Sequence Number"] $a(TRANS_SEQ_NBR)"
			puts  $fileid "[format %-40s "Card Type"] $a(CARD_SCHEME)"
			puts  $fileid "[format %-40s "Message Type"] $a(MSG_TYPE)"
			puts  $fileid "[format %-40s "In File Number"] $a(IN_FILE_NBR)"
			puts  $fileid "[format %-40s "In Batch Number"] $a(IN_BATCH_NBR)"
			puts  $fileid "[format %-40s "Transaction Amount"] $a(AMT_TRANS)"
			puts  $fileid "[format %-40s "Convertion Rate"] $a(CNV_RATE_RECON)"
			puts  $fileid "[format %-40s "Transaction Date"] $a(TRANS_DT)"
			puts  $fileid "[format %-40s "Function Code"] $a(FUNCTION_CD)"
			puts  $fileid "[format %-40s "Reason Code"] $a(REASON_CD)"
			puts  $fileid "[format %-40s "Arn"] $a(ARN)"
			puts  $fileid "[format %-40s "Transaction Authorization code"] $a(AUTH_CD)"
			puts  $fileid "[format %-40s "Merchant Id"] $a(MERCH_ID)"
			puts  $fileid "[format %-40s "Merchant Name"] $a(MERCH_NAME)"
			puts  $fileid "[format %-40s "Settlement Method Indicatior"] $a(SETTL_METHOD_IND)"
			puts  $fileid "[format %-40s "Massage Number"] $a(MSG_NBR)"
			puts  $fileid "[format %-40s "Transaction Clearing Status"] $a(TRANS_CLR_STATUS)"
			puts  $fileid "[format %-40s "Source Institution Id"] $a(SRC_INST_ID)"
			puts  $fileid "[format %-40s "Source File Type"] $a(SRC_FILE_TYPE)"
			puts  $fileid "[format %-40s "Transaction Activity Date"] $a(ACTIVITY_DT)"
			puts  $fileid "[format %-40s "EMS Item Type"]   $cb_type"
			
			if {[string trim $a(CARD_SCHEME)] == "05"} {
				set f "select * from MC_EMS_CODE where MESSAGE_REASON_CODE = $a(REASON_CD)"
				orasql $get23 $f
				set d [orafetch $get23 -dataarray dummy1]
			
				if {$d == 0} {
					if {$a(REASON_CD) != "6802"} {
						if { [info exists msg_type_desc($a(REASON_CD)-$a(FUNCTION_CD)-$a(MSG_TYPE))] } {
							puts  $fileid "[format %-40s "Message Type Description"] $msg_type_desc($a(REASON_CD)-$a(FUNCTION_CD)-$a(MSG_TYPE))"
						} else {
							puts $fileid "unknown combination of reason code $a(REASON_CD) message type $a(MSG_TYPE) and function code $a(FUNCTION_CD)"
						}	
					if { [info exists msg_rsn_cd_desc($a(REASON_CD)-$a(FUNCTION_CD)-$a(MSG_TYPE))] } {
						puts  $fileid "[format %-40s "Message Reason code Description"] $msg_rsn_cd_desc($a(REASON_CD)-$a(FUNCTION_CD)-$a(MSG_TYPE))"
					} else {
						puts $fileid "unknown combination of reason code $a(REASON_CD) message type $a(MSG_TYPE) and function code $a(FUNCTION_CD)"
					}
					}  
				} else {
					puts  $fileid "[format %-40s "Message Type Description"] Unknown Please research"
					puts  $fileid "[format %-40s "Message Reason code Description"] Unknown Please research"
				} 
				
			} elseif {[string trim $a(CARD_SCHEME)] == "04"} {
				if {$a(REASON_CD) != "0"} {
					puts  $fileid "[format %-40s "Message Type Description"] $vs_msg_type_arry($a(REASON_CD))"
					puts  $fileid "[format %-40s "Message Reason code Description"] $vs_msg_rsn_cd_arry($a(REASON_CD))"
					if {$a(MSG_TEXT_BLOCK) != ""} {
						puts  $fileid "[format %-40s "Message Text Block"] $a(MSG_TEXT_BLOCK)"
					}
			} else {
				set sql2 "select md.mps_id, t5.service_identifier from merchant_desc md, visa_tc50 t5 where md.trans_seq_nbr = t5.trans_seq_nbr and t5.trans_seq_nbr = '$a(TRANS_SEQ_NBR)'"
				puts $sql2
				orasql $get3 $sql2
				orafetch $get3 -dataarray b -indexbyname
			
				if {[set err [oramsg $get3 rc]] == 1403} {
					set b(MPS_ID) " "
					set b(SERVICE_IDENTIFIER) " "
				}
			
				puts  $fileid "[format %-40s "Message Type Description"] Text Message"
				puts  $fileid "[format %-40s "Message Reason code Description"] Please see transaction detail for more information"
			
				if {$a(REASON_CD) == "0"} {
					puts  $fileid "[format %-40s "MPS_ID"] $b(MPS_ID)"
					puts  $fileid "[format %-40s "SERVICE_IDENTIFIER"] $b(SERVICE_IDENTIFIER)"
				}
				
				if {$b(SERVICE_IDENTIFIER) == "PURCHM"} {
					puts $fileid1 "NOTE: A [format %-40s "SERVICE_IDENTIFIER"] $b(SERVICE_IDENTIFIER) TEXT MASSAGE PRESENT in $outfile1"
				}
				
				if {$a(MSG_TEXT_BLOCK) != ""} {
					puts  $fileid "[format %-40s "Message Text Block"] $a(MSG_TEXT_BLOCK)"
				}
			}
			
		} elseif {[string trim $a(CARD_SCHEME)] == "08"} {
			if {$a(REASON_CD) != "0"} {
				puts  $fileid "[format %-40s "Message Type Description"]  $a(REASON_CD) OR $ds_rsn_cd($a(REASON_CD)-$a(FUNCTION_CD)-$a(MSG_TYPE)-$a(REQ_REASON_CD))" 
				puts  $fileid "[format %-40s "Message Reason code Description"] : $ds_msg_type_arry($a(REASON_CD)-$a(FUNCTION_CD)-$a(MSG_TYPE)-$a(REQ_REASON_CD))"
			}
		} else {
			puts  $fileid "[format %-40s "Message Type Description"] Unknown Please research Reason: $a(REASON_CD)"
			puts  $fileid "[format %-40s "Message Reason code Description"] Unknown Please research Card type: $a(CARD_SCHEME)"
		}
		puts $fileid "\n"
		puts $fileid "\n------------------------------------------------------------------------------------------------------------------\n"
		}
	}
}

oralogoff $db_logon_handle
after 1000
close $fileid1
close $fileid2
after 1000


if {[set sz [file size $outfile]] > 0 && [set sz [file size $outfile1]] > 0} {
	exec mutt -a $outfile -a $outfile1 -s "EP ALERTS" Notifications-clearing@jetpay.com < body.txt
} elseif {[set sz [file size $outfile]] > 0 && [set sz [file size $outfile1]] == 0} {
	exec mutt -a $outfile -s "EP ALERTS" Notifications-clearing@jetpay.com < body.txt
} elseif {[set sz [file size $outfile]] == 0 && [set sz [file size $outfile1]] > 0} {
	exec mutt -a $outfile1 -s "EP ALERTS" Notifications-clearing@jetpay.com < body.txt
} else {
	exec echo "NO EP ALERTS" | mailx -r Notifications-clearing@jetpay.com -s "NO EP ALERTS" Notifications-clearing@jetpay.com 
}

set eflist [exec find . -name *.email]

if {$enotify == 0} {
	foreach msgfile $eflist {
		set mfile [string range $msgfile 2 end]
		set result ""
		
		switch $mfile {
		"101.JPMS.email"    {catch {exec mutt -s "JPCS Chargeback and Reject Notifications For JPIS" Notifications-clearing@jetpay.com merlinclearing@tsys.com < $mfile} result
							 if {$result == ""} {
								exec rm $mfile
							}}
		"101.96.email"	    {catch {exec mutt -s "JPCS Chargeback Notifications For Iss 96" Notifications-clearing@jetpay.com < $mfile} result
							 if {$result == ""} {
								exec rm $mfile
							}}
		"101.85.email"	    {catch {exec mutt -s "JPCS Chargeback Notifications For Iss 85" Notifications-clearing@jetpay.com < $mfile} result
							 if {$result == ""} {
								exec rm $mfile
							}}
		"105.email"         {catch {exec mutt -s "JPCS Chargeback and Reject Notifications For JPIS" Notifications-clearing@jetpay.com merlinclearing@tsys.com < $mfile} result 
							 if {$result == ""} {
								exec rm $mfile
							}}
		"107.email"	    	{catch {exec mutt -s "JPCS Chargeback and Reject Notifications For JPIS" Notifications-clearing@jetpay.com merlinclearing@tsys.com < $mfile} result
							 if {$result == ""} {
								exec rm $mfile
							}}                 
		"111.email"         {catch {exec mutt -s "JPCS Chargeback and Reject Notifications For REVWW" Notifications-clearing@jetpay.com merlinclearing@tsys.com < $mfile} result 
							 if {$result == ""} {
								exec rm $mfile
							}}
		"117.email"         {catch {exec mutt -s "JPCS Chargeback and Reject Notifications For SBC" Notifications-clearing@jetpay.com merlinclearing@tsys.com < $mfile} result 
							 if {$result == ""} {
								exec rm $mfile
							}}
		"121.email"         {catch {exec mutt -s "JPCS Chargeback and Reject Notifications For JPIS" Notifications-clearing@jetpay.com merlinclearing@tsys.com < $mfile} result 
							 if {$result == ""} {
								exec rm $mfile
							}}
		default     		{catch {exec mutt -s "JPCS Chargeback and Reject Notifications For JPIS" Notifications-clearing@jetpay.com < $mfile} result
							 if {$result == ""} {
								exec rm $mfile
							}}
		}	
	}
}

if {$vsrej == 0} {
	catch {exec /clearing/filemgr/REJECTS/recv_vs_incomming_rej_file.exp >> /clearing/filemgr/REJECTS/LOG/vsrej.log} result
	puts $result
	set rejfile "DT$logdate-EP204A.EPD"
    if {[file exists EP204A.EPD ]} {
        exec mv EP204A.EPD $rejfile
    } elseif {[file exists EP204A.TXT ]} {
        exec mv EP204A.TXT $rejfile
    } else {
        exec echo "ep_reject_chk.tcl: File EP204A.??? not downloaded to /clearing/filemgr/REJECTS/" | mutt  -s "BASEII REJECT ALERT missing file" Notifications-clearing@jetpay.com
    }

	if {$result == ""} {
        catch {exec echo "Please Review $rejfile at /clearing/filemgr/REJECTS/ARCHIVE" | mailx -r Notifications-clearing@jetpay.com -s "BASEII REJECT ALERT" Notifications-clearing@jetpay.com} result
		puts $result
        if {$result == ""} {
	        exec mv $rejfile ARCHIVE/
        }
    }
}

if {$ipmrejectmail == 0} {
	catch {exec echo "We have ipm rejected. Please, see EMS ALERT for Detail" | mailx -r Notifications-clearing@jetpay.com -s "IPM REJECT ALERT" Notifications-clearing@jetpay.com} result
	puts $result
}

if {[file exist no_orig_list_$logdate.log]} {
	catch {exec mutt -a no_orig_list_$logdate.log -s "EP transactions missing Original transaction list" Notifications-clearing@jetpay.com < body.txt} result
	exec mv no_orig_list_$logdate.log ARCHIVE/
}

after 1000

exec mv $outfile ARCHIVE/
exec mv $outfile1 ARCHIVE/
