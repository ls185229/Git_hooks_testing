#!/usr/bin/env tclsh

################################################################################
# $Id: chargeback_monthend.tcl 
################################################################################
#
# File Name:  fees_collected_monthend.tcl
# Description:  This script generates the monthend Chargeback Report
# Script Arguments: Report Type (IDM, MTL) and Institution ID
#                   IDM is chargeback from Assoc. , MTL is Chargeback to Merchant.
#                   Per Heather IDM can be run 1st of month and MTL on 3rd.
#                   MTL is emailed to other parties and needs the extra days to
#                   ensure all transactions are reported.
# Output:  Chargeback Month End Report
# Return:   0 = Success
#          !0 = Exit with errors
# Notes:  start & end date are calculated
#
#################################################################################

package require Oratcl

global db_logon_handle_

global log_file
global log_file_name
set log_file_name "./LOG/convchg_funding_monthend.log"

global mail_file
set mail_filename "convchg_funding_monthend.mail"
######################################################################
# process Chargeback Month End Report
######################################################################
proc do_report {} {

   global env
   global argv
   global sql_date
   global month_year
   global is_sales_tids
   global is_return_tids
   global is_dispute_tids
   global dt_start
   global dt_end
   global qry
   global cursor_C
   global db_logon_convchg_funding
   global db_login_handle_convchg_funding
   global chargeback_rec
   global month_year
   global counter 
   global rpt_type
   global start_date
   global end_date
   set clrdb $env(IST_DB)

   # Used to parse and execute the PL/SQL command
    if {[catch {set db_logon_handle_convchg_funding [oralogon masclr/masclr@$clrdb]} result]} {
        puts "Encountered error $result while trying to connect to the $clrdb database for convchg_funding Monthly query" 
        exit
    }

    if {[catch {set cursor_C [oraopen $db_logon_handle_convchg_funding]} result]} {
        puts "Encountered error $result while trying to create convchg_funding database handle"
        exit
    }

    set rpt_type [lindex $argv 0] 
    set inst_id [lindex $argv 1] 
   
    set year_month [string range $start_date 0 5] 

    if  { $rpt_type == "IDM" } {
       set file_name "Chrgbck_To_Merch_w_IDM_$year_month.$inst_id.csv"
    } elseif { $rpt_type == "MTL" } {
       set file_name "Chrgbck_From_Assoc_w_MTL_$year_month.$inst_id.csv"
    }

    if { $rpt_type == "MTL" } {    
        set qry "SELECT
            idm.pri_dest_inst_id AS INST_ID,
            idm.merch_id,
            idm.merch_name,
            TRUNC(idm.activity_dt + 1) activity_dt,
            CASE WHEN t.tid_settl_method = 'C' 
                 THEN -1 ELSE 1 END * idm.amt_trans / 100 AS Amount,
            idm.trans_ccd AS AMT_CURR,
            CASE WHEN t.tid_settl_method = 'C' 
                 THEN -1 ELSE 1 END * idm.amt_recon / 100 AS recon,
            idm.recon_ccd AS RECON_CURR,
            CASE WHEN  NOT (idm.amt_recon is null OR idm.amt_recon = 0 OR idm.amt_recon = amt_trans) AND idm.recon_ccd = idm.trans_ccd
                 THEN 
                   CASE WHEN t.tid_settl_method = 'C' 
                        THEN -1 ELSE 1 END * idm.amt_trans / 100 - 
                        CASE WHEN t.tid_settl_method = 'C' 
                        THEN -1 ELSE 1 END * idm.amt_recon / 100 ELSE 0 END AS diff,
            idm.arn,
            SUBSTR(idm.pan,0,6)||'******'||SUBSTR(idm.pan,13,4) pan,
            idm.tid ,
            idm.card_scheme card,
            mtl.gl_date, mtl.payment_seq_nbr AS PAY_SEQ_NO,
            idm.trans_seq_nbr AS TRX_SEQ_NO,
            mtl.external_trans_nbr AS EX_TRX_NO,
            mtl.amt_original,
            mtl.amt_billing,
            mtl.curr_billing,
            aad.payment_proc_dt,
            aad.payment_status AS PAYMENT_STAT
        FROM 
          masclr.in_draft_main idm
          JOIN masclr.tid_adn ta on ta.tid = idm.tid
          JOIN masclr.tid t on t.tid = idm.tid
          LEFT OUTER JOIN masclr.mas_trans_log mtl ON idm.arn = mtl.trans_ref_data AND
          trans_sub_seq = 0 AND SUBSTR(idm.tid, -8, 8) = SUBSTR(mtl.tid, -8, 8)
          LEFT OUTER JOIN masclr.acct_accum_det aad ON mtl.institution_id = aad.institution_id AND mtl.payment_seq_nbr = aad.payment_seq_nbr
        WHERE 
          ta.major_cat = 'DISPUTES' AND
          (idm.activity_dt >= to_date($start_date,'YYYYMMDDHH24MISS') AND idm.activity_dt < to_date($end_date,'YYYYMMDDHH24MISS')) AND
          idm.merch_id in (select entity_id from masclr.entity_to_auth where institution_id = $inst_id)
        ORDER BY 
          idm.pri_dest_inst_id, idm.merch_id, idm.activity_dt, idm.tid"
    } elseif { $rpt_type == "IDM" } {
            set qry "SELECT
                mtl.institution_id AS INST_ID,  
                mtl.entity_id,
                mtl.gl_date,
                CASE WHEN mtl.tid_settl_method = 'C' 
                     THEN -1 ELSE 1 END * mtl.amt_original AS AMT_ORIGINAL,
                mtl.tid tid_mtl,
                idm.tid tid_idm,
                CASE WHEN mtl.tid_settl_method = 'C' 
                     THEN -1 ELSE 1 END * idm.amt_trans / 100 AS AMT_IDM,
                idm.trans_ccd AS AMT_CURR,
                CASE WHEN mtl.tid_settl_method = 'C' 
                     THEN -1 ELSE 1 END * idm.amt_recon / 100 AS recon,
                idm.recon_ccd AS RECON_CURR,
                CASE WHEN NOT (idm.amt_recon IS NULL OR idm.amt_recon = 0 OR idm.amt_recon = amt_trans) AND idm.recon_ccd = idm.trans_ccd
                     THEN 
                        CASE WHEN mtl.tid_settl_method = 'C' 
                             THEN -1 ELSE 1 END * idm.amt_trans / 100 - CASE WHEN mtl.tid_settl_method = 'C' THEN -1 ELSE 1 END * idm.amt_recon / 100  ELSE 0 END AS diff,
               mtl.trans_ref_data arn,
               aad.payment_proc_dt,
               aad.payment_status AS PAYMENT_STAT
            FROM 
              masclr.mas_trans_log mtl
              JOIN masclr.tid_adn ta ON ta.tid = mtl.tid
              LEFT OUTER JOIN masclr.in_draft_main idm ON idm.arn = mtl.trans_ref_data AND substr(idm.tid, -8,  8) = substr(mtl.tid, -8, 8)
              LEFT OUTER JOIN masclr.acct_accum_det aad ON mtl.institution_id = aad.institution_id AND mtl.payment_seq_nbr = aad.payment_seq_nbr
            WHERE 
              ta.major_cat = 'DISPUTES' AND 
              (MTL.GL_DATE >= to_date($start_date,'YYYYMMDDHH24MISS') AND mtl.gl_date < to_date($end_date,'YYYYMMDDHH24MISS')) AND
              mtl.institution_id = $inst_id
            ORDER BY
              MTL.INSTITUTION_ID,  MTL.ENTITY_ID,  GL_DATE, TID"
    }
    global chargeback_rec
    global month_year
 
    if { $rpt_type == "MTL" } { 
        set chargeback_rec "Inst ID, Merch ID,Merch Name,Activity Date,Amt,Amt Curr,Recon, Recon Curr, Difference,ARN,PAN,"
        append chargeback_rec "TID,Card,Pay Seq No.,Trx Seq NO.,Ex Trx No.,Amount Original,Amt Billing,Curr Billing"
        append chargeback_rec "Pmt Proc Date,Pmt Status\n"
    } elseif { $rpt_type == "IDM" } {
        set chargeback_rec "Inst ID,Entity ID,GL Date,Amt Original,TID MTL,TID IDM,Amt IDM,Amt Curr,Recon,Recon Curr,Difference,ARN,"
        append chargeback_rec "Pmt Proc Date,Pmt Status\n"
    }
    
    orasql $cursor_C $qry 
    
    if { $rpt_type == "MTL" } {
        while { [orafetch $cursor_C -dataarray row -indexbyname] != 1403 } {
            ####################################
            # Add current line to report output
            ####################################
            append chargeback_rec "$row(INST_ID)," 
            append chargeback_rec "$row(MERCH_ID)," 
            append chargeback_rec "$row(MERCH_NAME),"
            append chargeback_rec "$row(ACTIVITY_DT),"
            append chargeback_rec "$row(AMOUNT),"
            append chargeback_rec "$row(AMT_CURR),"
            append chargeback_rec "$row(RECON),"
            append chargeback_rec "$row(RECON_CURR),"
            append chargeback_rec "$row(DIFF),"
            append chargeback_rec "$row(ARN),"
            append chargeback_rec "$row(PAN),"
            append chargeback_rec "$row(TID),"
            append chargeback_rec "$row(CARD),"
            append chargeback_rec "$row(PAY_SEQ_NO),"
            append chargeback_rec "$row(TRX_SEQ_NO),"
            append chargeback_rec "$row(EX_TRX_NO),"
            append chargeback_rec "$row(AMT_ORIGINAL),"
            append chargeback_rec "$row(AMT_BILLING),"
            append chargeback_rec "$row(CURR_BILLING),"
            append chargeback_rec "$row(PAYMENT_PROC_DT)"
            append chargeback_rec "$row(PAYMENT_STAT)\n"
        }
    } elseif { $rpt_type == "IDM" } {
        while { [orafetch $cursor_C -dataarray row -indexbyname] != 1403 } {
            ####################################
            # Add current line to report output
            ####################################
            append chargeback_rec "$row(INST_ID)," 
            #append chargeback_rec {="} "$row(ENTITYID)" {",}  
            append chargeback_rec "'$row(ENTITY_ID)," 
            append chargeback_rec "$row(GL_DATE),"
            append chargeback_rec "$row(AMT_ORIGINAL),"
            append chargeback_rec "$row(TID_MTL),"
            append chargeback_rec "$row(TID_IDM),"
            append chargeback_rec "$row(AMT_IDM),"
            append chargeback_rec "$row(AMT_CURR),"
            append chargeback_rec "$row(RECON),"
            append chargeback_rec "$row(RECON_CURR),"
            append chargeback_rec "$row(DIFF),"
            append chargeback_rec "$row(ARN),"
            append chargeback_rec "$row(PAYMENT_PROC_DT),"
            append chargeback_rec "$row(PAYMENT_STAT)\n"
        }
    }
 
    set year_month [clock format [clock seconds] -format "%Y%m"]
    puts "File Name is $file_name" 
    set fl [open $file_name w]
  
    puts $fl $chargeback_rec
    
    close $fl
    
    # exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" -- "accounting@jetpay.com,reports-clearing@jetpay.com" 
    # exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" -- "fcaron@jetpay.com" 
    # exec mv $file_name ./ARCHIVE
}

########################################################################
# open_log_file
########################################################################
proc open_log_file {} {

    global log_file_name
    global log_file
    
    if {[catch {open $log_file_name a} log_file]} {
        puts stderr "Cannot open file $log_file_name for logging."
        return
    }
};# end open_log_file

##################################################
# open_mail_file
##################################################
proc open_mail_file {} {

    global mail_file
    global mail_filename
    
    if {[catch {open $mail_filename w} mail_file]} {
        puts stderr "Cannot open file $mail_filename for Chargeback settlement mail."
        return
    }
};# end open_mail_file

##################################################
# write_log_message
##################################################
proc write_log_message { log_msg_text } {

    global log_file

    if { [catch {puts $log_file "[clock format [clock seconds] -format "%D %T"] $log_msg_text"} ]} {
        puts stderr "[clock format [clock seconds] -format "%D %T"] $log_msg"
    }
    flush $log_file
};# end log_message

#################################################
# close_log_file
##################################################
proc close_log_file {} {

    global log_file_name
    global log_file
    
    if {[catch {close $log_file} response]} {
        puts stderr "Cannot close file $log_file_name.  Changes may not be saved to the file."
        exit 1
    }
};# end close_log_file

##################################################
# close_mail_file
##################################################
proc close_mail_file {} {

    global mail_file_name
    global mail_file
    
    if {[catch {close $mail_file} response]} {
        puts stderr "Cannot close file $mail_filename.  Changes may not be saved to the file."
        exit 1
    }
};# end close_mail_file

############################################
# Parse arguments if given
############################################
proc arg_parse {} {
    global date_given argv

    #scan for Date
    if  { [regexp -- {-[dD][ ]+([0-9]{8})} $argv dummy date_given] } {
        puts "Date entered: $date_given"
    }
}

##############################################
# Initialize dates - if date passed base on
# current date, otherwise use previous month.
# Calculate start date, end date, file date 
# and report year/month
##############################################

proc init_dates {val} {
    global start_date end_date file_date curdate report_month rpt_type argv
   
     set rpt_type [lindex $argv 0]
  
    set curdate [clock format [clock seconds] -format %d-%b-%Y]
    puts "Date Generated: $curdate"         

    set start_date [clock format [clock scan "$val"] -format %Y%m01000000]
    puts "Start date is >= $start_date "

    if {$rpt_type == "MTL"} {
        set end_date [clock format [clock scan "$val +1 month"] -format %Y%m01000000]
        puts "End date is  < $end_date "
    } elseif  { $rpt_type == "IDM" } {
        set end_date [clock format [clock scan "$val +1 month"] -format %Y%m01000000]
        puts "End date is now  < $end_date "
    }

    set file_date  [clock format [clock scan "$val"] -format %Y%m]
    puts "File date: $file_date"

    set report_month  [clock format [clock scan "$val"] -format %b_%Y]
    puts " Report Month: $report_month"
}

#################################################
#  MAIN
#################################################

arg_parse

if {[info exists date_given]} {
    init_dates [clock format [clock scan $date_given -format %Y%m%d] -format %d-%b-%Y]     
} else {
    init_dates [clock format [clock scan "-1 month" -base [clock seconds]] -format %Y%m01]                             
}

open_log_file

write_log_message "START Chargeback Month End Report ***"
open_mail_file
write_log_message "Select Chargeback Month Funding End Records ***"
do_report
write_log_message "END Chargeback Month Funding End Report ***"
close_log_file
oraclose $cursor_C
