#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: drv_america_daily_cb_rp_report.tcl 4662 2018-08-16 13:53:24Z lmendis $

#======================       MODIFICATION HISTORY        ======================
# Version 0.00 Rifat Khan 11-23-2010
# ------------ create csv version of EMS alert for 101 and 107 combined
#

#=============================       USAGE        ==============================
##
##
#===============================================================================
#Environment veriables.......
set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clruser $env(IST_DB_USERNAME)
set clrpwd $env(IST_DB_PASSWORD)
set clrdb $env(CLR4_DB)
set authdb $env(TSP4_DB)
#set clrdb trnclr4

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
if {[catch {set handler [oralogon $clruser/$clrpwd@$clrdb]} result]} {
    exec echo "drv_america_daily_cb_rp_report.tcl failed to run" | \
        mailx -r $mailfromlist -s "drv_america_daily_cb_rp_report.tcl failed to run" $mailtolist
    exit
}
set ems_cursor1          [oraopen $handler]
set ems_cursor2          [oraopen $handler]

#set mode "TEST"
set mode "PROD"
set instlist "'101'"

#===============================================================================
#===================       time settings and arguments       ===================
#===============================================================================

if { $argc == 0 } {
    set report_date         [string toupper [clock format [clock scan "-0 day"] -format %d-%b-%y]]  ;# 20-MAR-08
    set CUR_SET_TIME        [clock seconds ]
    set CUR_JULIAN_DATEX    [string range [clock format $CUR_SET_TIME -format "%y%j"] 1 4]
    set name_date           [clock format [clock scan "-0 day"] -format %Y%m%d]                     ;# 20080609
    puts "*** Running today's reports: $report_date ***"

} elseif { $argc == 1 } {
    set input [string trim [lindex $argv 0]]
    if { [string length $input ] == 8 } {
        set report_date     $input
    } elseif { [string length $input ] != 8} {
        puts "REPORT DATE SHOULD BE 8 DIGITS! "
        puts "PLEASE START OVER! "
        exit 0
    }
    set name_date $report_date
    #set report_date         [clock format [ clock scan $report_date ]]
    set title_date          [clock format [clock scan "$report_date -0 day"] -format %Y%m%d]
    set report_date         [ string toupper [clock format [ clock scan " $report_date -0 day " ] -format %d-%b-%y ]]
    set CUR_JULIAN_DATEX    [ clock scan "$report_date"  -base [clock seconds] ]
    set CUR_JULIAN_DATEX    [clock format $CUR_JULIAN_DATEX -format "%y%j"]
    set CUR_JULIAN_DATEX    [string range $CUR_JULIAN_DATEX 1 4 ]

}

if {$mode == "TEST"} {
    set cur_file_name    "./DRV.AM.EMS.CB.$CUR_JULIAN_DATEX.$name_date.TEST.csv"
    set file_name        "DRV.AM.EMS.CB.$CUR_JULIAN_DATEX.$name_date.TEST.csv"
} elseif {$mode == "PROD"} {
    set cur_file_name    "/clearing/filemgr/JOURNALS/INST_101/ARCHIVE/DRV.AM.EMS.CB.$CUR_JULIAN_DATEX.$name_date.001.csv"
    set file_name        "DRV.AM.EMS.CB.$CUR_JULIAN_DATEX.$name_date.001.csv"
}
set cur_file         [open "$cur_file_name" w]

set entity_list "
    '447474200000362', '447474200000365', '447474200000366', '447474200000367',
    '447474200000368', '447474200000369', '447474200000370', '447474200000371',
    '447474200000372', '447474200000382'"

puts $cur_file "EMS CHARGEBACK REPORT"
puts $cur_file "DATE:,$report_date\n"
set headline "Merchant ID,Merchant Name,PAN,Transaction date,Activity Date,Message Type,Reason Code"
set headline "$headline,Description,CB Amt,CB Currency Code,Original Amt"
set headline "$headline,Original Currency Code,Recon Amt"
puts $cur_file "$headline,Recon Currency Code\r\n"


set ems_qry "
select unique ep.institution_id,
        ep.trans_seq_nbr,
        ep.EMS_ITEM_TYPE,
        inf.card_scheme,
        case when (inf.card_scheme in ('04', '05', '08')) then inf.REASON_CD end as REASON,
        case when (inf.card_scheme = '04') then vs_ems_code.MSG_REASON_CD_DESC
            when (inf.card_scheme = '05') then mc_ems_code.MSG_REASON_CD_DESC_1
            when (inf.card_scheme = '08') then ds_ems_code.MSG_REASON_CD_DESC_1 end as CD_DESC,
        replace(inf.merch_name, ',', '') as NAME,
        inf.merch_id as MID,
        substr(inf.pan,1,6)||'xxxxxx'||substr(inf.pan, 13, 4) as PAN,
        inf.trans_dt as TRANS_DT,
        ep.EVENT_LOG_DATE as EMS_DATE,
        nvl(inf.amt_trans, 0) as CB_AMT,
        inf.trans_ccd as CB_CCB,
        nvl(inf.amt_original, 0) as ORIG_AMT,
        inf.original_ccd as ORIG_CCD,
        nvl(inf.amt_recon, 0) as RECON_AMT,
        inf.recon_ccd as RECON_CCD
    from ep_event_log ep, in_draft_main inf
    LEFT OUTER JOIN vs_ems_code ON to_char(vs_ems_code.MESSAGE_REASON_CODE) = to_char(inf.REASON_CD) and 
      to_char(vs_ems_code.FUNCTION_CODE) = to_char(inf.FUNCTION_CD)  
    LEFT OUTER JOIN mc_ems_code ON to_char(mc_ems_code.MESSAGE_REASON_CODE) = to_char(inf.REASON_CD) and 
      to_char(mc_ems_code.FUNCTION_CODE) = to_char(inf.FUNCTION_CD)  
    LEFT OUTER JOIN ds_ems_code ON to_char(ds_ems_code.MESSAGE_REASON_CODE) = to_char(inf.REASON_CD) and 
      to_char(ds_ems_code.FUNCTION_CODE) = to_char(inf.FUNCTION_CD)  
    where inf.REASON_CD is not null
    and ep.EMS_ITEM_TYPE in ('CB1', 'CB2', 'RR1', 'CR2')
    and ep.institution_id = '101'
    and ep.trans_seq_nbr = inf.trans_seq_nbr
    and ep.arn in (
        SELECT mas_trans_log.trans_ref_data
        FROM mas_trans_log mas_trans_log,
            acct_accum_det acct_accum_det
        WHERE mas_trans_log.payment_seq_nbr IN (
            SELECT payment_seq_nbr
            FROM acct_accum_det
            WHERE TRUNC(payment_proc_dt, 'DDD') =
                TRUNC(to_date('$report_date', 'DD-MON-YY'), 'DDD')
            AND institution_id = '101'
        )
        AND mas_trans_log.institution_id     = '101'
        AND mas_trans_log.posting_entity_id IN ($entity_list)
        AND mas_trans_log.payment_seq_nbr    = acct_accum_det.payment_seq_nbr
        AND mas_trans_log.institution_id     = acct_accum_det.institution_id
        and acct_accum_det.PAYMENT_STATUS = 'P'
        and mas_trans_log.tid in (
            '010003005301', '010003005401', '010003010102', '010003010101',
            '010003015201', '010003015102', '010003015101', '010003015210')
    )
    order by inf.card_scheme"
if {$mode == "TEST"} {
    puts "ems query: $ems_qry"
}
orasql $ems_cursor1 $ems_qry
while {[orafetch $ems_cursor1 -dataarray ems -indexbyname] != 1403} {
    set    output_line "$ems(MID),$ems(NAME),$ems(PAN),$ems(TRANS_DT),$ems(EMS_DATE),"
    append output_line "$ems(EMS_ITEM_TYPE),$ems(REASON),$ems(CD_DESC),"
    append output_line "[format "%0.2f" $ems(CB_AMT)],$ems(CB_CCB),[format "%0.2f" $ems(ORIG_AMT)]"
    puts $cur_file "$output_line,$ems(ORIG_CCD),[format "%0.2f" $ems(RECON_AMT)]\r"
}

close $cur_file
# set ck_email "Reports-clearing@jetpay.com,Jetpay.support@drive-america.com,Kelsey.Madkin@driven-solutions.com,Patty.Baker@driven-solutions.com"
set ck_email "Reports-clearing@jetpay.com,Jetpay.support@drive-america.com"
if {$mode == "PROD"} {
    exec mutt -a $cur_file_name -s "$file_name" -- $ck_email < generic_funding_report_email_body.txt
} elseif {$mode == "TEST"} {
    exec mutt -a $cur_file_name -s "$file_name" -- clearing@jetpay.com < generic_funding_report_email_body.txt
}

oraclose $ems_cursor1
oraclose $ems_cursor2
