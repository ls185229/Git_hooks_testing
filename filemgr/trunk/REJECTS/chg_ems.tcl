#!/usr/bin/tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: chg_ems.tcl 4658 2018-08-06 16:46:57Z fcaron $
# $Rev: 4658 $
################################################################################
#
# File Name:  chg_ems.tcl
#
# Description:  This program provides a template for coding TCL scripts.
#               It reads the ent_group and ent_user tables; contents of these
#               tables are written to an output file.
#
# Script Arguments:  -d <Report date> = Run date (e.g., YYYYMMDD).  Optional.  If not used, script defaults to current date.
#                               -t = TEST MODE (Optional)
#
# Output:  None.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

#Environment veriables
set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
#set mailtolist "frank.caron@jetpay.com"
#set mailfromlist $env(MAIL_FROM)
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

#System information variables
set sysinfo "System: $box\n Location: $env(PWD) \n\n"


#===============================================================================
package require Oratcl
lappend auto_path $env(MASCLR_LIB)
package require GetOpts 1.1

if {[catch {set handler [oralogon masclr/masclr@$clrdb]} result]} {
    exec echo "chg_ems.tcl failed to run" | mutt -s "chg_ems.tcl failed to run" $mailtolist
    exit
}

set ems_cursor1  [oraopen $handler]
set ems_cursor2  [oraopen $handler]
set ems_cursor3  [oraopen $handler]
set ems_cursor4  [oraopen $handler]

global ocs_inst_id
global amex_inst_id
global disc_inst_id
global mc_inst_id
global visa_inst_id
global report_date
global report_date_end
global report_date_representment
global prt_report_date
global prt_report_date_representment
global title_date
set mode "PROD"
set cfg_file "ems.cfg"
set in_cfg [open $cfg_file r]
set dateFlag 0

#Read in amex chargeback and inquiry code maps to select statement
set map_file "amex_cbnsp_file_import.map"
set in_map [open $map_file r]
set inq_file "amex_inquiry_codes.txt"
set in_inq [open $inq_file r]
set counter 1

while {[set line_in_map [gets $in_map]] != {} } {
    if {$counter == 1} {
        set amex_subquery "SELECT '[lindex [split $line_in_map \t] 0]' reason_code, q'<[lindex [split $line_in_map \t] 1]>' reason_description FROM dual"
    } else {
        append amex_subquery " UNION ALL SELECT '[lindex [split $line_in_map \t] 0]', q'<[lindex [split $line_in_map \t] 1]>' FROM dual"
    } 
    set counter $counter+1;
}

while {[set line_in_inq [gets $in_inq]] != {} } { 
    append amex_subquery " UNION ALL SELECT '[lindex [split $line_in_inq ~] 0]', '[lindex [split $line_in_inq ~] 1]' FROM dual"
}

#Read in amex chargeback and inquiry code maps to select statement
set map_file "amex_cbnsp_file_import.map"
set in_map [open $map_file r]
set inq_file "amex_inquiry_codes.txt"
set in_inq [open $inq_file r]
set counter 1

while {[set line_in_map [gets $in_map]] != {} } {
    if {$counter == 1} {
        set amex_subquery "SELECT '[lindex [split $line_in_map \t] 0]' reason_code, q'<[lindex [split $line_in_map \t] 1]>' reason_description FROM dual"
    } else {
        append amex_subquery " UNION ALL SELECT '[lindex [split $line_in_map \t] 0]', q'<[lindex [split $line_in_map \t] 1]>' FROM dual"
    } 
    set counter $counter+1;
}

while {[set line_in_inq [gets $in_inq]] != {} } { 
    append amex_subquery " UNION ALL SELECT '[lindex [split $line_in_inq ~] 0]', '[lindex [split $line_in_inq ~] 1]' FROM dual"
}

#set cur_line  [split [set orig_line [gets $in_cfg] ] ~]

while {[set line_in [gets $in_cfg]] != {} } {
    set cfg_element [lindex [split $line_in ~] 0]

    switch $cfg_element {
        "OCS_INST_ID"  {set ocs_inst_id [lindex [split $line_in ~] 1]
                        }
        "AMEX_INST_ID" {set amex_inst_id [lindex [split $line_in ~] 1]
                        }
        "DISC_INST_ID" {set disc_inst_id [lindex [split $line_in ~] 1]
                        }
        "MC_INST_ID"   {set mc_inst_id   [lindex [split $line_in ~] 1]
                        }
        "VISA_INST_ID" {set visa_inst_id [lindex [split $line_in ~] 1]
                        }
        default        {}
    }
}
while { [ set err [ getopt $argv "d:t" opt optarg ]] } {
    if { $err < 0 } then {
        puts "error: $argv0 : opt $opt, optarg: $optarg "
        exit 1
    } else {   
        puts "opt: $opt, optarg: $optarg"
        switch -exact $opt {
           d {
                if { [catch {clock scan $optarg  -format %Y%m%d} date ] || ![string equal [clock format $date -format %Y%m%d] $optarg] } {
                    puts "REPORT DATE SHOULD BE 8 DIGITS (YYYYMMDD)! "
                    puts "PLEASE START OVER! "
                    exit 0
                } else {
                    set report_date $optarg
                    set name_date $report_date
                    set title_date [ string toupper [clock format [ clock add [clock scan $report_date -format %Y%m%d] -0 days ] -format %m-%d-%Y ]]
                    set report_date [ string toupper [clock format [ clock add [clock scan $report_date -format %Y%m%d] -0 days ] -format %Y%m%d ]]
                    set report_date_end [string toupper [clock format [ clock add [clock scan $report_date -format %Y%m%d] 1 days] -format %Y%m%d]]
                    set report_date_representment [string toupper [clock format [ clock add [clock scan $report_date -format %Y%m%d] -1 days] -format %Y%m%d]]
                    set prt_report_date [string toupper [clock format [clock add [clock scan $report_date -format %Y%m%d] -0 days] -format %d-%b-%y]]
                    set prt_report_date_representment [string toupper [clock format [clock add [clock scan $report_date -format %Y%m%d] -1 days] -format %d-%b-%y]]
                    set CUR_JULIAN_DATEX [string range [clock format [clock scan $report_date -format %Y%m%d] -format %y%j] 1 4 ]
                    puts "*** Running reports for: $report_date ***"
                    set dateFlag 1
                }
            }
           t {set mode "TEST"}
        }
    }
}

if {!$dateFlag} {
    set prt_report_date [string toupper [clock format [clock seconds] -format %d-%b-%y]]
    set report_date [string toupper [clock format [clock seconds] -format %Y%m%d]]
    set report_date_end [string toupper [clock format [clock add [clock seconds] 1 days ] -format %Y%m%d]]
    set report_date_representment [string toupper [clock format [clock add [clock seconds] -1 days] -format %Y%m%d]]
    set prt_report_date_representment [string toupper [clock format [clock add [clock seconds] -1 days] -format %d-%b-%y]]
    set title_date  [ string toupper [clock format [ clock add [clock scan $report_date -format %Y%m%d] -0 days ] -format %m-%d-%Y ]]
    set CUR_JULIAN_DATEX [string range [clock format [clock seconds ] -format %y%j] 1 4]
    set name_date  [clock format [clock seconds] -format %Y%m%d]
    puts "*** Running today's reports: $report_date ***"
}

if {$mode == "TEST"} {
    set cur_file_name "./ROLLUP.EMS.CB.$CUR_JULIAN_DATEX.$name_date.TEST.csv"
    set file_name "ROLLUP.EMS.CB.$CUR_JULIAN_DATEX.$name_date.TEST.csv"
} elseif {$mode == "PROD"} {
    set cur_file_name "/clearing/filemgr/JOURNALS/ROLLUP/ARCHIVE/ROLLUP.EMS.CB.$CUR_JULIAN_DATEX.$name_date.001.csv"
    set file_name "ROLLUP.EMS.CB.$CUR_JULIAN_DATEX.$name_date.001.csv"
}

set cur_file [open "$cur_file_name" w]

puts $cur_file "Daily Dispute Activity"
puts $cur_file "DATE: $title_date"
set headline "Inst,Merch ID,Merch Name,Trans Date,Settle Date,Card Type,PAN,ARN,Auth Code,Amount"
set headline "$headline,Recon Amount,Currency,Dispute Type,Tran Type,Reason Code,Reason Description"
# set ems_qry "
#        select distinct
#            ep.institution_id,
#            ep.trans_seq_nbr,
#            ep.EMS_ITEM_TYPE,
#            inf.card_scheme,
#            case when (inf.card_scheme in ('04', '05', '03', '08')) then inf.REASON_CD end as REASON,
#            case when (inf.card_scheme = '04') then ve.MSG_REASON_CD_DESC
#                 when (inf.card_scheme = '05') then me.MSG_REASON_CD_DESC_1
#                 when (inf.card_scheme = '03') then 'AMEX'
#                 when (inf.card_scheme = '08') then de.MSG_REASON_CD_DESC_1 end as CD_DESC,
#            replace(inf.merch_name, ',', '') as NAME,
#            inf.merch_id as MID,
#            substr(inf.pan, 1, 6)||'xxxxxx'||substr(inf.pan, 13, 4) as PAN,
#            inf.amt_trans * power(10, -inf.trans_exp) as CB_AMT,
#            inf.trans_ccd as CB_CCB,
#            inf.amt_original * power(10, -inf.original_exp) as ORIG_AMT,
#            inf.original_ccd as ORIG_CCD,
#            inf.amt_recon * power(10, -inf.recon_exp) as RECON_AMT,
#            inf.recon_ccd as RECON_CCD,
#            inf.arn
#        from vs_ems_code ve, mc_ems_code me, ds_ems_code de,
#            in_draft_main inf, ep_event_log ep
#        where ve.MESSAGE_REASON_CODE(+) = inf.REASON_CD
#            and me.MESSAGE_REASON_CODE(+) = inf.REASON_CD
#            and de.MESSAGE_REASON_CODE(+) = inf.REASON_CD
#            and inf.REASON_CD is not null
#            and ep.EMS_ITEM_TYPE in ('CB1', 'CB2', 'RR1')
#            and substr(inf.activity_dt, 1, 9) = '$report_date'
#            and ep.institution_id in ($instlist)
#            and ep.trans_seq_nbr = inf.trans_seq_nbr
#        order by inf.card_scheme ,merch_id"

# set ems_qry "
#  SELECT DISTINCT
#  idm.sec_dest_inst_id as INST_ID,
#  SUBSTR(t.description,1,30) AS Tran_Type,
#  ta.minor_cat AS CATEGORY,
#  idm.CARD_SCHEME,
#  CASE WHEN (idm.card_scheme IN ($ocs_inst_id,$visa_inst_id, $mc_inst_id, $amex_inst_id, $disc_inst_id)) THEN idm.REASON_CD END AS REASON,
#  CASE WHEN (idm.card_scheme = $visa_inst_id) THEN ve.MSG_REASON_CD_DESC
#       WHEN (idm.card_scheme = $mc_inst_id) THEN me.MSG_REASON_CD_DESC_1
#       WHEN (idm.card_scheme = $amex_inst_id) THEN 'AMEX'
#       WHEN (idm.card_scheme = $disc_inst_id) THEN de.MSG_REASON_CD_DESC_1 END AS CD_DESC,
#  REPLACE(idm.merch_name, ',', '') AS NAME,
#  idm.merch_id as MERCH_ID,
#  SUBSTR(idm.pan, 1, 6)||'xxxxxx'||substr(idm.pan, 13, 4) AS PAN,
#  idm.amt_trans * power(10, -idm.trans_exp) AS CB_AMT,
#  idm.trans_ccd as CB_CCB,
#  idm.amt_original * power(10, -idm.original_exp) AS ORIG_AMT,
#  idm.original_ccd AS ORIG_CCD,
#  idm.amt_recon * power(10, -idm.recon_exp) as RECON_AMT,
#  idm.recon_ccd as RECON_CCD,
#  idm.arn as ARN
#FROM
#  in_draft_main idm
#  JOIN tid t ON t.tid = idm.tid
#  JOIN tid_adn ta ON ta.tid = idm.tid
#  LEFT OUTER JOIN vs_ems_code ve ON ve.MESSAGE_REASON_CODE = idm.REASON_CD
#  LEFT OUTER JOIN mc_ems_code me ON me.MESSAGE_REASON_CODE = idm.REASON_CD
#  LEFT OUTER JOIN ds_ems_code de ON de.MESSAGE_REASON_CODE = idm.REASON_CD
#WHERE
#  idm.sec_dest_inst_id IS NOT NULL AND
#  idm.tid in (SELECT tid from tid_adn WHERE major_cat = 'DISPUTES') AND
#  (SUBSTR(idm.pan,1,1) NOT IN ('x','0','') OR idm.pan IS NOT NULL) AND
#  in_file_nbr in
#    (SELECT in_file_nbr FROM in_file_log ifl WHERE TRUNC(incoming_dt) = '$report_date' AND
#  ifl.INSTITUTION_ID IN ($ocs_inst_id, $visa_inst_id, $mc_inst_id, $amex_inst_id, $disc_inst_id))
#ORDER BY
#  INST_ID, NAME"

#set report_date "20170221"
#set report_date_representment "20170220"
#puts "ems query: $ems_qry"
#
# RETRIEVALS
#
set ems_qry "
    select DISTINCT
        substr(NVL(in_draft_main.sec_dest_inst_id,in_draft_main.pri_dest_inst_id),1,4) sec_dest_inst_id,
        substr(in_draft_main.merch_id,1,15) merch_id,
        REPLACE(in_draft_main.merch_name, ',', '') merch_name,
        substr(in_draft_main.trans_dt,1,9) trans_dt,
        substr(in_draft_main.activity_dt,1,9) activity_dt,
        substr(card_scheme.card_scheme_name,1,10) card_scheme_name,
        substr(in_draft_main.pan,1,6)||'*'|| substr(in_draft_main.pan,13,4) pan,
        in_draft_main.arn arn,
        in_draft_main.auth_cd auth_cd,
        case when tid.tid_settl_method = 'D' then -1 else 1 end *
            in_draft_main.amt_trans * power(10, -NVL(in_draft_main.trans_exp,(SELECT cc.curr_exponent FROM currency_code cc 
            WHERE cc.curr_code = in_draft_main.trans_ccd))) amt_trans,
        case when tid.tid_settl_method = 'D' then -1 else 1 end *
            NVL(in_draft_main.amt_recon, in_draft_emc.amt_orig_recon) * power(10, -NVL(in_draft_main.recon_exp,(SELECT cc.curr_exponent 
            FROM currency_code cc WHERE cc.curr_code = in_draft_main.trans_ccd))) amt_recon,
        in_draft_main.trans_ccd trans_ccd,
        tid_adn.minor_cat minor_cat,
        substr(tid.description,1,30) description,
        NVL(NVL(to_char(in_draft_main.reason_cd), to_char(amex_dispute_txn.reason_code)), to_char(SUBSTR(vva.vrol_fin_id, 1, 4))) reason_cd,
        CASE WHEN (in_draft_main.card_scheme = '04') THEN substr(vs_ems_code.MSG_REASON_CD_DESC,1,40)
            WHEN (in_draft_main.card_scheme = '05') THEN substr(mc_ems_code.MSG_REASON_CD_DESC_1,1,40)
            WHEN (in_draft_main.card_scheme = '03') THEN NVL(amex_ems_code.reason_description,'AMEX')
            WHEN (in_draft_main.card_scheme = '08') THEN substr(ds_ems_code.MSG_REASON_CD_DESC_1,1,40)
        END msg_reason_cd_desc1
    from card_scheme,
        tid,
        tid_adn,
        in_draft_main
        LEFT OUTER JOIN in_draft_emc ON in_draft_main.trans_seq_nbr = in_draft_emc.trans_seq_nbr
        LEFT OUTER JOIN visa_vcr_adn vva on in_draft_main.trans_seq_nbr = vva.trans_seq_nbr
        LEFT OUTER JOIN vs_ems_code ON to_char(vs_ems_code.MESSAGE_REASON_CODE) = NVL(to_char(in_draft_main.REASON_CD), SUBSTR(vva.vrol_fin_id, 1, 4)) or to_char(vs_ems_code.MESSAGE_REASON_CODE) = NVL('0' || to_char(in_draft_main.REASON_CD), SUBSTR(vva.vrol_fin_id,1,4))
        LEFT OUTER JOIN amex_dispute_txn ON to_char(amex_dispute_txn.trans_seq_nbr) = to_char(in_draft_main.trans_seq_nbr)
        LEFT OUTER JOIN ($amex_subquery) amex_ems_code ON to_char(amex_ems_code.reason_code) = to_char(amex_dispute_txn.reason_code)
        LEFT OUTER JOIN mc_ems_code ON to_char(mc_ems_code.MESSAGE_REASON_CODE) = to_char(in_draft_main.REASON_CD) and
            to_char(mc_ems_code.FUNCTION_CODE) = to_char(in_draft_main.FUNCTION_CD)
        LEFT OUTER JOIN ds_ems_code ON to_char(ds_ems_code.MESSAGE_REASON_CODE) = to_char(in_draft_main.REASON_CD) and
            to_char(ds_ems_code.FUNCTION_CODE) = to_char(in_draft_main.FUNCTION_CD)
    where in_draft_main.card_scheme = card_scheme.card_scheme AND
        in_draft_main.tid = tid.tid AND
        in_draft_main.tid = tid_adn.tid AND
        tid_adn.major_cat = 'DISPUTES' AND
        tid_adn.minor_cat = 'RETRIEVALS' AND
        (substr(in_draft_main.pan,1,1) not in ('x','0','') OR in_draft_main.pan is not NULL) AND
        in_draft_main.in_file_nbr in (
            select in_file_nbr from in_file_log
            where trunc(incoming_dt) >= to_date('$report_date','YYYYMMDD') and
                trunc(incoming_dt) < to_date('$report_date_end','YYYYMMDD') and
                institution_id in (
                    '$ocs_inst_id', '$visa_inst_id', '$mc_inst_id', '$amex_inst_id',
                    '$disc_inst_id'))
    order by sec_dest_inst_id,
        substr(card_scheme.card_scheme_name,1,10),
        tid_adn.minor_cat"
puts $ems_qry

if {$mode == "TEST"} {
    puts "ems query: $ems_qry"
}

orasql $ems_cursor1 $ems_qry
puts $cur_file ""
puts $cur_file "Retrieval Requests"
puts $cur_file "Expected MAS Processing Date $prt_report_date"
puts $cur_file ""
puts $cur_file "$headline"

while {[orafetch $ems_cursor1 -dataarray ems -indexbyname] != 1403} {
    set output_line "$ems(SEC_DEST_INST_ID),'$ems(MERCH_ID),$ems(MERCH_NAME),$ems(TRANS_DT),$ems(ACTIVITY_DT),"
    append output_line "$ems(CARD_SCHEME_NAME),'$ems(PAN),'$ems(ARN),$ems(AUTH_CD),"
    append output_line "$ems(AMT_TRANS),$ems(AMT_RECON),$ems(TRANS_CCD),$ems(MINOR_CAT),"
    append output_line "$ems(DESCRIPTION),$ems(REASON_CD),$ems(MSG_REASON_CD_DESC1)"
    puts $cur_file "$output_line\r"
}

puts $cur_file ""
#
# CHARGEBACKS
#
set ems_qry "
    select DISTINCT
        substr(NVL(in_draft_main.sec_dest_inst_id,in_draft_main.pri_dest_inst_id),1,4) sec_dest_inst_id,
        substr(in_draft_main.merch_id,1,15) merch_id,
        REPLACE(in_draft_main.merch_name, ',', '') merch_name,
        substr(in_draft_main.trans_dt,1,9) trans_dt,
        substr(in_draft_main.activity_dt,1,9) activity_dt,
        substr(card_scheme.card_scheme_name,1,10) card_scheme_name,
        substr(in_draft_main.pan,1,6)||'*'|| substr(in_draft_main.pan,13,4) pan,
        in_draft_main.arn arn,
        in_draft_main.auth_cd auth_cd,
        case when tid.tid_settl_method = 'D' then -1 else 1 end *
            in_draft_main.amt_trans * power(10, -NVL(in_draft_main.trans_exp,(SELECT cc.curr_exponent FROM currency_code cc WHERE cc.curr_code = in_draft_main.trans_ccd))) amt_trans,
        case when tid.tid_settl_method = 'D' then -1 else 1 end *
            NVL(in_draft_main.amt_recon, in_draft_emc.amt_orig_recon) * power(10, -NVL(in_draft_main.recon_exp,(SELECT cc.curr_exponent FROM currency_code cc WHERE cc.curr_code = in_draft_main.trans_ccd))) amt_recon,
        in_draft_main.trans_ccd trans_ccd,
        tid_adn.minor_cat minor_cat,
        substr(tid.description,1,30) description,
        NVL(NVL(to_char(in_draft_main.reason_cd), to_char(amex_dispute_txn.reason_code)), to_char(SUBSTR(vva.vrol_fin_id, 1, 4))) reason_cd,
        CASE WHEN (in_draft_main.card_scheme = '04') THEN substr(vs_ems_code.MSG_REASON_CD_DESC,1,40)
            WHEN (in_draft_main.card_scheme = '05') THEN substr(mc_ems_code.MSG_REASON_CD_DESC_1,1,40)
            WHEN (in_draft_main.card_scheme = '03') THEN NVL(amex_ems_code.reason_description,'AMEX')
            WHEN (in_draft_main.card_scheme = '08') THEN substr(ds_ems_code.MSG_REASON_CD_DESC_1,1,40)
        END msg_reason_cd_desc1
    from card_scheme,
        tid,
        tid_adn,
        in_draft_main
        LEFT OUTER JOIN in_draft_emc ON in_draft_main.trans_seq_nbr = in_draft_emc.trans_seq_nbr
        LEFT OUTER JOIN visa_vcr_adn vva on in_draft_main.trans_seq_nbr = vva.trans_seq_nbr
        LEFT OUTER JOIN vs_ems_code ON to_char(vs_ems_code.MESSAGE_REASON_CODE) = NVL(to_char(in_draft_main.REASON_CD), SUBSTR(vva.vrol_fin_id, 1, 4)) or to_char(vs_ems_code.MESSAGE_REASON_CODE) = NVL('0' || to_char(in_draft_main.REASON_CD), SUBSTR(vva.vrol_fin_id,1,4))
        LEFT OUTER JOIN amex_dispute_txn ON to_char(amex_dispute_txn.trans_seq_nbr) = to_char(in_draft_main.trans_seq_nbr)
        LEFT OUTER JOIN ($amex_subquery) amex_ems_code ON to_char(amex_ems_code.reason_code) = to_char(amex_dispute_txn.reason_code)
        LEFT OUTER JOIN mc_ems_code ON to_char(mc_ems_code.MESSAGE_REASON_CODE) = to_char(in_draft_main.REASON_CD) and
            to_char(mc_ems_code.FUNCTION_CODE) = to_char(in_draft_main.FUNCTION_CD)
        LEFT OUTER JOIN ds_ems_code ON to_char(ds_ems_code.MESSAGE_REASON_CODE) = to_char(in_draft_main.REASON_CD) and
            to_char(ds_ems_code.FUNCTION_CODE) = to_char(in_draft_main.FUNCTION_CD)
    where in_draft_main.card_scheme = card_scheme.card_scheme AND
        in_draft_main.tid = tid.tid AND
        in_draft_main.tid = tid_adn.tid AND
        tid_adn.major_cat = 'DISPUTES' AND
        tid_adn.minor_cat = 'CHARGEBACK' AND
        (substr(in_draft_main.pan,1,1) not in ('x','0','') OR in_draft_main.pan is not NULL) AND
        in_draft_main.in_file_nbr in (
            select in_file_nbr from in_file_log
            where trunc(incoming_dt) >= to_date('$report_date','YYYYMMDD') and
            trunc(incoming_dt) < to_date('$report_date_end','YYYYMMDD') and
            institution_id in ('$ocs_inst_id', '$visa_inst_id', '$mc_inst_id',
                '$amex_inst_id', '$disc_inst_id'))
    order by sec_dest_inst_id,
        substr(card_scheme.card_scheme_name,1,10),
        tid_adn.minor_cat"


orasql $ems_cursor2 $ems_qry


puts $cur_file ""
puts $cur_file "Chargebacks"
puts $cur_file "Expected MAS Processing Date $prt_report_date"
puts $cur_file ""
puts $cur_file "$headline"

while {[orafetch $ems_cursor2 -dataarray ems -indexbyname] != 1403} {
    set output_line "$ems(SEC_DEST_INST_ID),'$ems(MERCH_ID),$ems(MERCH_NAME),$ems(TRANS_DT),$ems(ACTIVITY_DT),"
    append output_line "$ems(CARD_SCHEME_NAME),'$ems(PAN),'$ems(ARN),$ems(AUTH_CD),"
    append output_line "$ems(AMT_TRANS),$ems(AMT_RECON),$ems(TRANS_CCD),$ems(MINOR_CAT),"
    append output_line "$ems(DESCRIPTION),$ems(REASON_CD),$ems(MSG_REASON_CD_DESC1)"
    puts $cur_file "$output_line\r"
}

puts $cur_file ""
puts $cur_file ""

#
# REPRESENTMENTS
#
set ems_qry "
    select DISTINCT
        substr(NVL(in_draft_main.sec_dest_inst_id,in_draft_main.pri_dest_inst_id),1,4) sec_dest_inst_id,
        substr(in_draft_main.merch_id,1,15) merch_id,
        REPLACE(in_draft_main.merch_name, ',', '') merch_name,
        substr(in_draft_main.trans_dt,1,9) trans_dt,
        substr(in_draft_main.activity_dt,1,9) activity_dt,
        substr(card_scheme.card_scheme_name,1,10) card_scheme_name,
        substr(in_draft_main.pan,1,6)||'*'|| substr(in_draft_main.pan,13,4) pan,
        in_draft_main.arn arn,
        in_draft_main.auth_cd auth_cd,
        case when tid.tid_settl_method = 'D' then -1 else 1 end *
            in_draft_main.amt_trans * power(10, -NVL(in_draft_main.trans_exp,(SELECT cc.curr_exponent FROM currency_code cc WHERE cc.curr_code = in_draft_main.trans_ccd))) amt_trans,
        case when tid.tid_settl_method = 'D' then -1 else 1 end *
            NVL(in_draft_main.amt_recon, in_draft_emc.amt_orig_recon) * power(10, -NVL(in_draft_main.recon_exp,(SELECT cc.curr_exponent FROM currency_code cc WHERE cc.curr_code = in_draft_main.trans_ccd))) amt_recon,
        in_draft_main.trans_ccd trans_ccd,
        tid_adn.minor_cat minor_cat,
        substr(tid.description,1,30) description,
        NVL(NVL(to_char(in_draft_main.reason_cd), to_char(amex_dispute_txn.reason_code)), to_char(SUBSTR(vva.vrol_fin_id, 1, 4))) reason_cd,
        CASE WHEN (in_draft_main.card_scheme = '04') THEN substr(vs_ems_code.MSG_REASON_CD_DESC,1,40)
            WHEN (in_draft_main.card_scheme = '05') THEN substr(mc_ems_code.MSG_REASON_CD_DESC_1,1,40)
            WHEN (in_draft_main.card_scheme = '03') THEN NVL(amex_ems_code.reason_description, 'AMEX')
            WHEN (in_draft_main.card_scheme = '08') THEN substr(ds_ems_code.MSG_REASON_CD_DESC_1,1,40)
        END msg_reason_cd_desc1
    from card_scheme,
        tid,
        tid_adn,
        in_draft_main
        LEFT OUTER JOIN in_draft_emc ON in_draft_main.trans_seq_nbr = in_draft_emc.trans_seq_nbr
        LEFT OUTER JOIN visa_vcr_adn vva on in_draft_main.trans_seq_nbr = vva.trans_seq_nbr
        LEFT OUTER JOIN vs_ems_code ON to_char(vs_ems_code.MESSAGE_REASON_CODE) = NVL(to_char(in_draft_main.REASON_CD), SUBSTR(vva.vrol_fin_id, 1, 4)) or to_char(vs_ems_code.MESSAGE_REASON_CODE) = NVL('0' || to_char(in_draft_main.REASON_CD), SUBSTR(vva.vrol_fin_id,1,4))
        LEFT OUTER JOIN amex_dispute_txn ON to_char(amex_dispute_txn.trans_seq_nbr) = to_char(in_draft_main.trans_seq_nbr)
        LEFT OUTER JOIN ($amex_subquery) amex_ems_code ON to_char(amex_ems_code.reason_code) = to_char(amex_dispute_txn.reason_code)
        LEFT OUTER JOIN mc_ems_code ON to_char(mc_ems_code.MESSAGE_REASON_CODE) = to_char(in_draft_main.REASON_CD) and
            to_char(mc_ems_code.FUNCTION_CODE) = to_char(in_draft_main.FUNCTION_CD)
        LEFT OUTER JOIN ds_ems_code ON to_char(ds_ems_code.MESSAGE_REASON_CODE) = to_char(in_draft_main.REASON_CD) and
            to_char(ds_ems_code.FUNCTION_CODE) = to_char(in_draft_main.FUNCTION_CD)
    where in_draft_main.card_scheme = card_scheme.card_scheme AND
        in_draft_main.tid = tid.tid AND
        in_draft_main.tid = tid_adn.tid AND
        tid_adn.major_cat = 'DISPUTES' AND
        tid_adn.minor_cat = 'REPRESENTMENT' AND
        (substr(in_draft_main.pan,1,1) not in ('x','0','') OR
            in_draft_main.pan is not NULL) AND
        in_draft_main.in_file_nbr in (
            select in_file_nbr from in_file_log
            where trunc(incoming_dt) >= to_date('$report_date','YYYYMMDD') and
                trunc(incoming_dt) < to_date('$report_date_end','YYYYMMDD') and
                institution_id in (
                    '$ocs_inst_id', '$visa_inst_id', '$mc_inst_id',
                    '$amex_inst_id', '$disc_inst_id'))
    order by sec_dest_inst_id,
        substr(card_scheme.card_scheme_name,1,10),
        tid_adn.minor_cat"

orasql $ems_cursor3 $ems_qry
puts $ems_qry

puts $cur_file "Representments"
puts $cur_file "Expected MAS Processing Date $prt_report_date_representment"
puts $cur_file ""
puts $cur_file "$headline"

while {[orafetch $ems_cursor3 -dataarray ems -indexbyname] != 1403} {
    set output_line "$ems(SEC_DEST_INST_ID),'$ems(MERCH_ID),$ems(MERCH_NAME),$ems(TRANS_DT),$ems(ACTIVITY_DT),"
    append output_line "$ems(CARD_SCHEME_NAME),'$ems(PAN),'$ems(ARN),$ems(AUTH_CD),"
    append output_line "$ems(AMT_TRANS),$ems(AMT_RECON),$ems(TRANS_CCD),$ems(MINOR_CAT),"
    append output_line "$ems(DESCRIPTION),$ems(REASON_CD),$ems(MSG_REASON_CD_DESC1)"
    puts $cur_file "$output_line\r"
}

set ems_qry "
    select DISTINCT
        substr(NVL(in_draft_main.sec_dest_inst_id,in_draft_main.pri_dest_inst_id),1,4) sec_dest_inst_id,
        substr(in_draft_main.merch_id,1,15) merch_id,
        REPLACE(in_draft_main.merch_name, ',', '') merch_name,
        substr(in_draft_main.trans_dt,1,9) trans_dt,
        substr(in_draft_main.activity_dt,1,9) activity_dt,
        substr(card_scheme.card_scheme_name,1,10) card_scheme_name,
        substr(in_draft_main.pan,1,6)||'*'|| substr(in_draft_main.pan,13,4) pan,
        in_draft_main.arn arn,
        in_draft_main.auth_cd auth_cd,
        case when tid.tid_settl_method = 'D' then -1 else 1 end *
            in_draft_main.amt_trans * power(10, -NVL(in_draft_main.trans_exp,(SELECT cc.curr_exponent FROM currency_code cc WHERE cc.curr_code = in_draft_main.trans_ccd))) amt_trans,
        case when tid.tid_settl_method = 'D' then -1 else 1 end *
            NVL(in_draft_main.amt_recon, in_draft_emc.amt_orig_recon) * power(10, -NVL(in_draft_main.recon_exp,(SELECT cc.curr_exponent FROM currency_code cc WHERE cc.curr_code = in_draft_main.trans_ccd))) amt_recon,
        in_draft_main.trans_ccd trans_ccd,
        tid_adn.minor_cat minor_cat,
        substr(tid.description,1,30) description,
        NVL(NVL(to_char(in_draft_main.reason_cd), to_char(amex_dispute_txn.reason_code)), to_char(SUBSTR(vva.vrol_fin_id, 1, 4))) reason_cd,
        CASE WHEN (in_draft_main.card_scheme = '04') THEN substr(vs_ems_code.MSG_REASON_CD_DESC,1,40)
            WHEN (in_draft_main.card_scheme = '05') THEN substr(mc_ems_code.MSG_REASON_CD_DESC_1,1,40)
            WHEN (in_draft_main.card_scheme = '03') THEN NVL(amex_ems_code.reason_description, 'AMEX')
            WHEN (in_draft_main.card_scheme = '08') THEN substr(ds_ems_code.MSG_REASON_CD_DESC_1,1,40)
        END msg_reason_cd_desc1
    from card_scheme,
        tid,
        tid_adn,
        in_draft_main
        LEFT OUTER JOIN in_draft_emc ON in_draft_main.trans_seq_nbr = in_draft_emc.trans_seq_nbr
        LEFT OUTER JOIN visa_vcr_adn vva on in_draft_main.trans_seq_nbr = vva.trans_seq_nbr
        LEFT OUTER JOIN vs_ems_code ON to_char(vs_ems_code.MESSAGE_REASON_CODE) = NVL(to_char(in_draft_main.REASON_CD), SUBSTR(vva.vrol_fin_id, 1, 4)) or to_char(vs_ems_code.MESSAGE_REASON_CODE) = NVL('0' || to_char(in_draft_main.REASON_CD), SUBSTR(vva.vrol_fin_id,1,4))
        LEFT OUTER JOIN amex_dispute_txn ON to_char(amex_dispute_txn.trans_seq_nbr) = to_char(in_draft_main.trans_seq_nbr)
        LEFT OUTER JOIN ($amex_subquery) amex_ems_code ON to_char(amex_ems_code.reason_code) = to_char(amex_dispute_txn.reason_code)
        LEFT OUTER JOIN mc_ems_code ON to_char(mc_ems_code.MESSAGE_REASON_CODE) = to_char(in_draft_main.REASON_CD) and
            to_char(mc_ems_code.FUNCTION_CODE) = to_char(in_draft_main.FUNCTION_CD)
        LEFT OUTER JOIN ds_ems_code ON to_char(ds_ems_code.MESSAGE_REASON_CODE) = to_char(in_draft_main.REASON_CD) and
            to_char(ds_ems_code.FUNCTION_CODE) = to_char(in_draft_main.FUNCTION_CD)
    where in_draft_main.card_scheme = card_scheme.card_scheme AND
        in_draft_main.tid = tid.tid AND
        in_draft_main.tid = tid_adn.tid AND
        tid_adn.major_cat = 'DISPUTES' AND
        tid_adn.minor_cat = 'ARBITRATION' AND
        substr(in_draft_main.pan,1,1) not in ('x','0') AND
        in_draft_main.in_file_nbr in (
            select in_file_nbr from in_file_log
            where trunc(incoming_dt) >= to_date('$report_date','YYYYMMDD') and
                trunc(incoming_dt) < to_date('$report_date_end','YYYYMMDD') and
                institution_id in (
                    '$ocs_inst_id', '$visa_inst_id', '$mc_inst_id', '$amex_inst_id',
                    '$disc_inst_id'))
    order by sec_dest_inst_id,
        substr(card_scheme.card_scheme_name,1,10),
        tid_adn.minor_cat"

orasql $ems_cursor4 $ems_qry

exec sleep 5

puts $cur_file ""
puts $cur_file ""
puts $cur_file "Pre-Arbitrations"
puts $cur_file "Expected MAS Processing Date $prt_report_date"
puts $cur_file ""
puts $cur_file "$headline"

while {[orafetch $ems_cursor4 -dataarray ems -indexbyname] != 1403} {
    set output_line "$ems(SEC_DEST_INST_ID),'$ems(MERCH_ID),$ems(MERCH_NAME),$ems(TRANS_DT),$ems(ACTIVITY_DT),"
    append output_line "$ems(CARD_SCHEME_NAME),'$ems(PAN),'$ems(ARN),$ems(AUTH_CD),"
    append output_line "$ems(AMT_TRANS),$ems(AMT_RECON),$ems(TRANS_CCD),$ems(MINOR_CAT),"
    append output_line "$ems(DESCRIPTION),$ems(REASON_CD),$ems(MSG_REASON_CD_DESC1)"
    puts $cur_file "$output_line\r"

}

close $cur_file

set ck_email "risk@jetpay.com, Reports-clearing@jetpay.com"
append ck_email ", CBlizzard@tsys.com, accounting@jetpay.com"

#set ck_email "frank.caron@jetpay.com"

if {$mode == "PROD"} {
    exec echo "Please see attached." | mutt -a "$cur_file_name" -s "$file_name" -- $ck_email
} elseif {$mode == "TEST"} {
    exec echo "Please see attached." | mutt -a "$cur_file_name" -s "$file_name" -- clearing@jetpay.com
}

oraclose $ems_cursor1
oraclose $ems_cursor2
oraclose $ems_cursor3
oraclose $ems_cursor4
