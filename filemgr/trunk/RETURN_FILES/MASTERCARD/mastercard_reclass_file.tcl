#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: mastercard_reclass_file.tcl 2410 2013-08-28 18:07:47Z devans $
# $Rev: 2410 $
################################################################################


##################################################################################
# 
# mastercard_reclass_file.tcl parses through the incoming Mastercard T884 reporting 
# file and generates the report used to investigate reclassified transactions.
#
##################################################################################
package require Oratcl

#System variables
set box $env(SYS_BOX)
set clrdb $env(IST_DB)
set clearing_in_loc $env(CLR_OSITE_DATA)
set sysinfo "System: $box\n Location: $env(PWD) \n\n"

#Global variables for file processing
global STD_OUT_CHANNEL
set STD_OUT_CHANNEL stderr

global clr_db_logon
global inst_file_mask

global db_logon_handle_cutoff_batch
global db_logon_handle_global_seq_ctrl
global db_logon_handle_in_draft_main
global db_logon_handle_in_draft_emc
global db_logon_handle_in_file_log
global db_logon_handle_attribute_value
global cutoff_batch_c
global global_seq_ctrl_c
global in_draft_main_c
global in_draft_emc_c
global in_file_log_c
global attribute_value_c

global log_file
global log_file_name
set log_filename [lindex $argv 0]

global input_acquirer_file
global input_acquirer_filename
set input_acquirer_filename [lindex $argv 1]

global mail_file
global mail_filename
set mail_filename [lindex $argv 2]

global cfg_file
global cfg_filename
set cfg_filename [lindex $argv 3]
   
global run_file_date
set run_file_date [lindex $argv 4]
set yyyy [string range $run_file_date 0 3]
set mm [string range $run_file_date 4 5]
set dd [string range $run_file_date 6 7]
global system_time
set system_time [clock format [clock scan $yyyy-$mm-$dd] -format "%y%j" -timezone :America/Chicago]

global run_mode
set run_mode [lindex $argv 5]


##################################################
# open_input_acquirer_file
#   Open acquirer reporting file from Mastercard
##################################################
proc open_input_acquirer_file {} {

    global input_acquirer_filename
    global input_acquirer_file
    
    if {[catch {open $input_acquirer_filename r} input_acquirer_file]} {
        puts stderr "Cannot open file input_acquirer_filename for reading."
        exit 0
    }
    
};# end open_input_acquirer_file


##################################################
# open_log_file
#   Open the Mastercard reclass log file.
##################################################
proc open_log_file {} {

    global log_filename
    global log_file
    
    if {[catch {open $log_filename a} log_file]} {
        puts stderr "Cannot open file $log_file for logging."
        return
    }
    
};# end open_log_file


##################################################
# open_cfg_file
#   Open the Mastercard reclass configuration file.
##################################################
proc open_cfg_file {} {

    global clr_db_logon
    global cfg_element
    global cfg_file
    global cfg_filename
    global inst_file_mask
    
    if {[catch {open $cfg_filename r} cfg_file]} {
        puts stderr "Cannot open file $cfg_file for configurations."
        return
    }

    while {[set line_in [gets $cfg_file]] != {} } {
        set cfg_element [lindex [split $line_in ,] 0]
 
        switch $cfg_element {
            "CLR_DB_LOGON" {
                set clr_db_logon [lindex [split $line_in ,] 1]
            }
            "FILE_MASK" {
                set inst_file_mask [lindex [split $line_in ,] 1]
            }
            default {
            }
        }
    }
    
};# end open_cfg_file


##################################################
# open_mail_file
#   Open Mastercard reclass activity mail file.
##################################################
proc open_mail_file {} {

    global mail_file
    global mail_filename
    
    if {[catch {open $mail_filename a} mail_file]} {
        puts stderr "Cannot open file $mail_file for reclass transaction mail."
        return
    }
    
};# end open_mail_file


########################################
# open_db
#   Connect to the Clearing database.
########################################
proc open_db {} {

    global clrdb
    global clr_db_logon
    global db_logon_handle_cutoff_batch
    global db_logon_handle_global_seq_ctrl
    global db_logon_handle_in_draft_main
    global db_logon_handle_in_draft_emc
    global db_logon_handle_in_file_log
    global db_logon_handle_attribute_value
    global cutoff_batch_c
    global global_seq_ctrl_c
    global in_draft_main_c
    global in_draft_emc_c
    global in_file_log_c
    global attribute_value_c

    #
    # Open in_file_log
    #
    if {[catch {set db_logon_handle_in_file_log [oralogon $clr_db_logon@$clrdb]} result] } {
        puts "Encountered error $result while trying to connect to the $clrdb database for in_file_log"
        exit
    }
    if {[catch {set in_file_log_c [oraopen $db_logon_handle_in_file_log]} result]} {
        puts "Encountered error $result while trying to create in_file_log database handle"
        exit
    }

    #
    # Open cutoff_batch
    #
    if {[catch {set db_logon_handle_cutoff_batch [oralogon $clr_db_logon@$clrdb]} result] } {
        puts "Encountered error $result while trying to connect to the $clrdb database for cutoff_batch"
        exit
    }
    if {[catch {set cutoff_batch_c [oraopen $db_logon_handle_cutoff_batch]} result]} {
        puts "Encountered error $result while trying to create cutoff_batch database handle"
        exit
    }
 
    #
    # Open in_draft_main
    #
    if {[catch {set db_logon_handle_in_draft_main [oralogon $clr_db_logon@$clrdb]} result] } {
        puts "Encountered error $result while trying to connect to the $clrdb database for in_draft_main"
        exit
    }
    if {[catch {set in_draft_main_c [oraopen $db_logon_handle_in_draft_main]} result]} {
        puts "Encountered error $result while trying to create in_draft_main database handle"
        exit
    }

    #
    # Open in_draft_emc
    #
    if {[catch {set db_logon_handle_in_draft_emc [oralogon $clr_db_logon@$clrdb]} result] } {
        puts "Encountered error $result while trying to connect to the $clrdb database for in_draft_emc"
        exit
    }
    if {[catch {set in_draft_emc_c [oraopen $db_logon_handle_in_draft_emc]} result]} {
        puts "Encountered error $result while trying to create in_draft_emc database handle"
        exit
    }

 
    #
    # Open global_seq_ctrl
    #
    if {[catch {set db_logon_handle_global_seq_ctrl [oralogon $clr_db_logon@$clrdb]} result] } {
        puts "Encountered error $result while trying to connect to the $clrdb database for global_seq_ctrl"
        exit
    }
    if {[catch {set global_seq_ctrl_c [oraopen $db_logon_handle_global_seq_ctrl]} result]} {
        puts "Encountered error $result while trying to create global_seq_ctrl database handle"
        exit
    }

    #
    # Open attribute_value
    #
    if {[catch {set db_logon_handle_attribute_value [oralogon $clr_db_logon@$clrdb]} result] } {
        puts "Encountered error $result while trying to connect to the $clrdb database for attribute_value"
        exit
    }
    if {[catch {set attribute_value_c [oraopen $db_logon_handle_attribute_value]} result]} {
        puts "Encountered error $result while trying to create attribute_value database handle"
        exit
    }

};# end open_db


##################################################
# write_log_message
#   Write message to the Merlin log file.
##################################################
proc write_log_message { log_msg_text } {

    global log_file

    if { [catch {puts $log_file "[clock format [clock seconds] -format "%D %T"] $log_msg_text \n"} ]} {
        puts stderr "[clock format [clock seconds] -format "%D %T"] $log_msg"
    }

};# end log_message


##################################################
# compose_mail_msg
#   Compose a mail message to Clearing with basic
#   transaction data.
##################################################
proc compose_mail_msg { mail_rec } {

    global mail_file
   
    puts $mail_file $mail_rec
 
};# end compose_mail_msg


##################################################
# process_reclass
#   Update reclass-related information in the
#   Clearing database.
##################################################
proc process_reclass { mc_reclass_in_file_nbr line_in } {

    global db_logon_handle_attribute_value
    global db_logon_handle_cutoff_batch
    global db_logon_handle_global_seq_ctrl
    global db_logon_handle_in_draft_main
    global db_logon_handle_in_draft_emc
    global attribute_value_c
    global cutoff_batch_c
    global global_seq_ctrl_c
    global in_draft_main_c
    global in_draft_emc_c
    global in_file_log_c
    global inst_file_mask
    global run_file_date
    global system_time

    #
    # Parse the Mastercard reclass input line and find the original transaction in in_draft_main:
    #
    set mc_reclass_arn [string range $line_in 177 199]

    set in_draft_main_orig_query "select o.trans_seq_nbr,
                                         o.msg_type,
                                         o.tid,
                                         o.card_scheme,
                                         o.mas_code,
                                         o.in_file_nbr,
                                         o.in_batch_nbr,
                                         o.external_record_id,
                                         o.pri_dest_inst_id,
                                         o.pri_dest_file_type,
                                         o.pri_dest_clr_mode,
                                         o.sec_dest_inst_id,
                                         o.sec_dest_file_type,
                                         o.sec_dest_clr_mode,
                                         o.irfp,
                                         o.amt_irfp,
                                         o.irfp_ccd,
                                         o.irfp_exp,
                                         o.pan,
                                         o.p_cd_trans_type,
                                         o.p_cd_from_acct,
                                         o.p_cd_to_acct,
                                         o.amt_trans,
                                         o.trans_ccd,
                                         o.trans_exp,
                                         o.amt_recon,
                                         o.recon_ccd,
                                         o.recon_exp,
                                         o.amt_ch_bill,
                                         o.ch_bill_ccd,
                                         o.ch_bill_exp,
                                         o.cnv_rate_recon,
                                         o.cnv_rate_ch_bill,
                                         o.stan,
                                         o.trans_dt,
                                         o.transmit_dt,
                                         o.expiry_date,
                                         o.pos_crddat_in_cap,
                                         o.pos_ch_auth_cap,
                                         o.pos_crd_capt_cap,
                                         o.pos_operating_env,
                                         o.pos_ch_present,
                                         o.pos_crd_present,
                                         o.pos_crddat_in_mode,
                                         o.pos_ch_auth_method,
                                         o.pos_ch_auth_entity,
                                         o.pos_crddat_out_cap,
                                         o.pos_term_out_cap,
                                         o.pos_pin_capt_mode,
                                         o.pos_cat_level_ind,
                                         o.card_seq_nbr,
                                         o.function_cd,
                                         o.reason_cd,
                                         o.mcc,
                                         o.arn,
                                         o.acq_inst_id,
                                         o.forwarding_inst_id,
                                         o.receiving_inst_id,
                                         o.track2_data,
                                         o.retv_ref_nbr,
                                         o.auth_cd,
                                         o.action_cd,
                                         o.cat_id,
                                         o.merch_id,
                                         translate(o.merch_name, '''', '-') as merch_name,
                                         o.merch_address1,
                                         o.merch_address2,
                                         o.merch_city,
                                         o.merch_prov_state,
                                         o.merch_post_cd_zip,
                                         o.merch_cntry_cd_num,
                                         o.merch_cntry_cd_alp,
                                         o.track1_data,
                                         o.amt_fees,
                                         o.fees_ccd,
                                         o.fees_exp,
                                         o.settl_method_ind,
                                         o.msg_nbr,
                                         o.doc_ind,
                                         o.doc_type,
                                         o.trans_lifecycle_id,
                                         o.card_iss_ref_data,
                                         o.msg_text_block,
                                         o.chgbk_ref_nbr,
                                         o.req_reason_cd,
                                         o.orig_mtid,
                                         o.orig_stan,
                                         o.orig_trans_dt,
                                         o.orig_acq_inst_id,
                                         o.amt_original,
                                         o.original_ccd,
                                         o.original_exp,
                                         o.amt_ch_bill_fee,
                                         o.ch_bill_fee_ccd,
                                         o.ch_bill_fee_exp,
                                         o.recurring_pay_ind,
                                         o.fulfill_doc_type,
                                         o.mas_code_downgrade,
                                         o.reversal_ind,
                                         o.trans_dest,
                                         o.trans_originator,
                                         o.fee_reason_cd,
                                         o.amt_amex_tax,
                                         o.amex_tax_ccd,
                                         o.amex_tax_exp,
                                         o.clearing_flag,
                                         o.prop_licence_flag,
                                         o.merch_status,
                                         o.err_cd,
                                         o.tc50_msg_text,
                                         o.trans_clr_status,
                                         o.tc_qualifier,
                                         o.ichg_fee_category,
                                         o.film_locator,
                                         o.clr_date_j,
                                         o.amt_auth,
                                         o.auth_ccd,
                                         o.auth_exp,
                                         o.external_file_id,
                                         o.src_inst_id,
                                         o.src_file_type,
                                         o.irfee_amt_sign,
                                         o.orig_reason_cd,
                                         o.tier_ind,
                                         o.external_sender_id,
                                         o.activity_dt,
                                         o.batchmicrofilm_nbr,
                                         o.network_id,
                                         o.fpi_others,
                                         o.tga_intercountry,
                                         o.p_cd_pcode,
                                         o.partial_ship_ind,
                                         o.amt_cashback                 
                                  from in_draft_main o
                                  where o.arn = '$mc_reclass_arn' AND (o.tid = '010103005101' OR o.tid = '010103005102')"
    

    orasql $in_draft_main_c $in_draft_main_orig_query

    if {[orafetch $in_draft_main_c -dataarray in_draft_main_orig -indexbyname] != 1403 } {
        set mc_reclass_msg_type $in_draft_main_orig(MSG_TYPE)
        set mc_reclass_tid $in_draft_main_orig(TID)
        set mc_reclass_card_scheme $in_draft_main_orig(CARD_SCHEME)
        set mc_reclass_mas_code $in_draft_main_orig(MAS_CODE)
        set mc_reclass_external_record_id $in_draft_main_orig(EXTERNAL_RECORD_ID)
        set mc_reclass_pri_dest_inst_id $in_draft_main_orig(PRI_DEST_INST_ID)
        set mc_reclass_pri_dest_file_type $in_draft_main_orig(PRI_DEST_FILE_TYPE)
        set mc_reclass_sec_dest_inst_id $in_draft_main_orig(SEC_DEST_INST_ID)
        set mc_reclass_sec_dest_file_type $in_draft_main_orig(SEC_DEST_FILE_TYPE)
        set mc_reclass_sec_dest_clr_mode $in_draft_main_orig(SEC_DEST_CLR_MODE)
        set mc_reclass_irfp $in_draft_main_orig(IRFP)
        set mc_reclass_amt_irfp $in_draft_main_orig(AMT_IRFP)
        set mc_reclass_irfp_ccd $in_draft_main_orig(IRFP_CCD)
        set mc_reclass_irfp_exp $in_draft_main_orig(IRFP_EXP)
        set mc_reclass_pan $in_draft_main_orig(PAN)
        set mc_reclass_p_cd_trans_type $in_draft_main_orig(P_CD_TRANS_TYPE)
        set mc_reclass_p_cd_from_acct $in_draft_main_orig(P_CD_FROM_ACCT)
        set mc_reclass_p_cd_to_acct $in_draft_main_orig(P_CD_TO_ACCT)
        set mc_reclass_amt_trans $in_draft_main_orig(AMT_TRANS)
        set mc_reclass_trans_ccd $in_draft_main_orig(TRANS_CCD)
        set mc_reclass_trans_exp $in_draft_main_orig(TRANS_EXP)
        set mc_reclass_amt_recon $in_draft_main_orig(AMT_RECON)
        set mc_reclass_recon_ccd $in_draft_main_orig(RECON_CCD)
        set mc_reclass_recon_exp $in_draft_main_orig(RECON_EXP)
        set mc_reclass_amt_ch_bill $in_draft_main_orig(AMT_CH_BILL)
        set mc_reclass_ch_bill_ccd $in_draft_main_orig(CH_BILL_CCD)
        set mc_reclass_ch_bill_exp $in_draft_main_orig(CH_BILL_EXP)
        set mc_reclass_cnv_rate_recon $in_draft_main_orig(CNV_RATE_RECON)
        set mc_reclass_cnv_rate_ch_bill $in_draft_main_orig(CNV_RATE_CH_BILL)
        set mc_reclass_stan $in_draft_main_orig(STAN)
        set mc_reclass_trans_dt $in_draft_main_orig(TRANS_DT)
        set mc_reclass_transmit_dt $in_draft_main_orig(TRANSMIT_DT)
        set mc_reclass_expiry_date $in_draft_main_orig(EXPIRY_DATE)
        set mc_reclass_pos_crddat_in_cap $in_draft_main_orig(POS_CRDDAT_IN_CAP)
        set mc_reclass_pos_ch_auth_cap $in_draft_main_orig(POS_CH_AUTH_CAP)
        set mc_reclass_pos_crd_capt_cap $in_draft_main_orig(POS_CRD_CAPT_CAP)
        set mc_reclass_pos_operating_env $in_draft_main_orig(POS_OPERATING_ENV)
        set mc_reclass_pos_ch_present $in_draft_main_orig(POS_CH_PRESENT)
        set mc_reclass_pos_crd_present $in_draft_main_orig(POS_CRD_PRESENT)
        set mc_reclass_pos_crddat_in_mode $in_draft_main_orig(POS_CRDDAT_IN_MODE)
        set mc_reclass_pos_ch_auth_method $in_draft_main_orig(POS_CH_AUTH_METHOD)
        set mc_reclass_pos_ch_auth_entity $in_draft_main_orig(POS_CH_AUTH_ENTITY)
        set mc_reclass_pos_crddat_out_cap $in_draft_main_orig(POS_CRDDAT_OUT_CAP)
        set mc_reclass_pos_term_out_cap $in_draft_main_orig(POS_TERM_OUT_CAP)
        set mc_reclass_pos_pin_capt_mode $in_draft_main_orig(POS_PIN_CAPT_MODE)
        set mc_reclass_pos_cat_level_ind $in_draft_main_orig(POS_CAT_LEVEL_IND)
        set mc_reclass_card_seq_nbr $in_draft_main_orig(CARD_SEQ_NBR)
        set mc_reclass_function_cd $in_draft_main_orig(FUNCTION_CD)
        set mc_reclass_reason_cd $in_draft_main_orig(REASON_CD)
        set mc_reclass_mcc $in_draft_main_orig(MCC)
        set mc_reclass_arn $in_draft_main_orig(ARN)
        set mc_reclass_acq_inst_id $in_draft_main_orig(ACQ_INST_ID)
        set mc_reclass_forwarding_inst_id $in_draft_main_orig(FORWARDING_INST_ID)
        set mc_reclass_receiving_inst_id $in_draft_main_orig(RECEIVING_INST_ID)
        set mc_reclass_track2_data $in_draft_main_orig(TRACK2_DATA)
        set mc_reclass_retv_ref_nbr $in_draft_main_orig(RETV_REF_NBR)
        set mc_reclass_auth_cd $in_draft_main_orig(AUTH_CD)
        set mc_reclass_action_cd $in_draft_main_orig(ACTION_CD)
        set mc_reclass_cat_id $in_draft_main_orig(CAT_ID)
        set mc_reclass_merch_id $in_draft_main_orig(MERCH_ID)
        set mc_reclass_merch_name $in_draft_main_orig(MERCH_NAME)
        set mc_reclass_merch_address1 $in_draft_main_orig(MERCH_ADDRESS1)
        set mc_reclass_merch_address2 $in_draft_main_orig(MERCH_ADDRESS2)
        set mc_reclass_merch_city $in_draft_main_orig(MERCH_CITY)
        set mc_reclass_merch_prov_state $in_draft_main_orig(MERCH_PROV_STATE)
        set mc_reclass_merch_post_cd_zip $in_draft_main_orig(MERCH_POST_CD_ZIP)
        set mc_reclass_merch_cntry_cd_num $in_draft_main_orig(MERCH_CNTRY_CD_NUM)
        set mc_reclass_merch_cntry_cd_alp $in_draft_main_orig(MERCH_CNTRY_CD_ALP)
        set mc_reclass_track1_data $in_draft_main_orig(TRACK1_DATA)
        set mc_reclass_amt_fees $in_draft_main_orig(AMT_FEES)
        set mc_reclass_fees_ccd $in_draft_main_orig(FEES_CCD)
        set mc_reclass_fees_exp $in_draft_main_orig(FEES_EXP)
        set mc_reclass_msg_nbr $in_draft_main_orig(MSG_NBR)
        set mc_reclass_doc_ind $in_draft_main_orig(DOC_IND)
        set mc_reclass_doc_type $in_draft_main_orig(DOC_TYPE)
        set mc_reclass_trans_lifecycle_id $in_draft_main_orig(TRANS_LIFECYCLE_ID)
        set mc_reclass_card_iss_ref_data $in_draft_main_orig(CARD_ISS_REF_DATA)
        set mc_reclass_msg_text_block $in_draft_main_orig(MSG_TEXT_BLOCK)
        set mc_reclass_chgbk_ref_nbr $in_draft_main_orig(CHGBK_REF_NBR)
        set mc_reclass_req_reason_cd $in_draft_main_orig(REQ_REASON_CD)
        set mc_reclass_orig_mtid $in_draft_main_orig(ORIG_MTID)
        set mc_reclass_orig_stan $in_draft_main_orig(ORIG_STAN)
        set mc_reclass_orig_trans_dt $in_draft_main_orig(ORIG_TRANS_DT)
        set mc_reclass_orig_acq_inst_id $in_draft_main_orig(ORIG_ACQ_INST_ID)
        set mc_reclass_amt_original $in_draft_main_orig(AMT_ORIGINAL)
        set mc_reclass_original_ccd $in_draft_main_orig(ORIGINAL_CCD)
        set mc_reclass_original_exp $in_draft_main_orig(ORIGINAL_EXP)
        set mc_reclass_amt_ch_bill_fee $in_draft_main_orig(AMT_CH_BILL_FEE)
        set mc_reclass_ch_bill_fee_ccd $in_draft_main_orig(CH_BILL_FEE_CCD)
        set mc_reclass_ch_bill_fee_exp $in_draft_main_orig(CH_BILL_FEE_EXP)
        set mc_reclass_recurring_pay_ind $in_draft_main_orig(RECURRING_PAY_IND)
        set mc_reclass_fulfill_doc_type $in_draft_main_orig(FULFILL_DOC_TYPE)
        set mc_reclass_mas_code_downgrade $in_draft_main_orig(MAS_CODE_DOWNGRADE)
        set mc_reclass_reversal_ind $in_draft_main_orig(REVERSAL_IND)
        set mc_reclass_trans_dest $in_draft_main_orig(TRANS_DEST)
        set mc_reclass_trans_originator $in_draft_main_orig(TRANS_ORIGINATOR)
        set mc_reclass_fee_reason_cd $in_draft_main_orig(FEE_REASON_CD)
        set mc_reclass_amt_amex_tax $in_draft_main_orig(AMT_AMEX_TAX)
        set mc_reclass_amex_tax_ccd $in_draft_main_orig(AMEX_TAX_CCD)
        set mc_reclass_amex_tax_exp $in_draft_main_orig(AMEX_TAX_EXP)
        set mc_reclass_clearing_flag $in_draft_main_orig(CLEARING_FLAG)
        set mc_reclass_prop_licence_flag $in_draft_main_orig(PROP_LICENCE_FLAG)
        set mc_reclass_merch_status $in_draft_main_orig(MERCH_STATUS)
        set mc_reclass_err_cd $in_draft_main_orig(ERR_CD)
        set mc_reclass_tc50_msg_text $in_draft_main_orig(TC50_MSG_TEXT)
        set mc_reclass_tc_qualifier $in_draft_main_orig(TC_QUALIFIER)
        set mc_reclass_ichg_fee_category $in_draft_main_orig(ICHG_FEE_CATEGORY)
        set mc_reclass_film_locator $in_draft_main_orig(FILM_LOCATOR)
        set mc_reclass_amt_auth $in_draft_main_orig(AMT_AUTH)
        set mc_reclass_auth_ccd $in_draft_main_orig(AUTH_CCD)
        set mc_reclass_auth_exp $in_draft_main_orig(AUTH_EXP)
        set mc_reclass_external_file_id $in_draft_main_orig(EXTERNAL_FILE_ID)
        set mc_reclass_irfee_amt_sign $in_draft_main_orig(IRFEE_AMT_SIGN)
        set mc_reclass_orig_reason_cd $in_draft_main_orig(ORIG_REASON_CD)
        set mc_reclass_tier_ind $in_draft_main_orig(TIER_IND)
        set mc_reclass_external_sender_id $in_draft_main_orig(EXTERNAL_SENDER_ID)
        set mc_reclass_batchmicrofilm_nbr $in_draft_main_orig(BATCHMICROFILM_NBR)
        set mc_reclass_network_id $in_draft_main_orig(NETWORK_ID)
        set mc_reclass_fpi_others $in_draft_main_orig(FPI_OTHERS)
        set mc_reclass_tga_intercountry $in_draft_main_orig(TGA_INTERCOUNTRY)
        set mc_reclass_p_cd_pcode $in_draft_main_orig(P_CD_PCODE)
        set mc_reclass_partial_ship_ind $in_draft_main_orig(PARTIAL_SHIP_IND)
        set mc_reclass_amt_cashback $in_draft_main_orig(AMT_CASHBACK)
    } else {
        write_log_message "Original Mastercard sale or credit transaction was not found for ARN $mc_reclass_arn; investigate this, as reclass will not be processed."
        exit 1
    }

    
    set in_draft_emc_orig_query "select *
                                  from in_draft_emc emc
                                  where emc.trans_seq_nbr = $in_draft_main_orig(TRANS_SEQ_NBR)"



    orasql $in_draft_emc_c $in_draft_emc_orig_query
    
    if {[orafetch $in_draft_emc_c -dataarray in_draft_emc_orig -indexbyname] != 1403 } {
    } else {
        write_log_message "Original Mastercard EMC seq_nbr was not found for ARN $mc_reclass_arn; investigate this, as reclass will not be processed."
        exit 1
    }


    #
    # Determine the reclass TID
    #
    if {$mc_reclass_tid == "010103005101"} { 
        set mc_reclass_tid "010133005101"
    } else {
        set mc_reclass_tid "010133005102"
    }		

    #
    # Determine the mc_reclass_mas_code_downgrade value from attribute_value
    #
    set mc_downgrade_psl [string range $line_in 216 217]
    set mc_orig_ird [string range $line_in 10 11]

    puts $mc_downgrade_psl
    puts $mc_orig_ird

    set attribute_value_query "select a.attribute_value
                               from attribute_value a
                               where a.attribute_id = '95' and a.attribute_value like '%$mc_downgrade_psl,%'
                               or a.attribute_id = '95' and a.attribute_value like '%,$mc_downgrade_psl%'"

    puts $attribute_value_query
    
    orasql $attribute_value_c $attribute_value_query

    if {[orafetch $attribute_value_c -dataarray attribute_value -indexbyname] != 1403 } {
        set mas_code_attribute_value $attribute_value(ATTRIBUTE_VALUE)
        set mas_code_start_position [string first ")(" $mas_code_attribute_value]
        set mas_code_start_position [expr $mas_code_start_position + 2]
        set mas_code_end_position [string last ")" $mas_code_attribute_value]
        set mas_code_end_position [expr $mas_code_end_position - 1]
        set mc_reclass_mas_code_downgrade [string range $mas_code_attribute_value $mas_code_start_position $mas_code_end_position]
    } else {
        write_log_message "attribute_value was not able to be obtained from attribute_value. $mc_downgrade_psl $mc_settl_flg"
        exit 1
    }

    #
    # Set mc_reclass_msg_text_block
    #
    if {[string range $line_in 305 305] != "1"} {
      set mc_reclass_msg_text_block "MASTERCARD RECLASS REASON(S): Timeliness Error - code is [string range $line_in 305 305] "
    } else { 
      if {[string range $line_in 306 306] != "1"} {
        set mc_reclass_msg_text_block "MASTERCARD RECLASS REASON(S): Magnetic Stripe Error - code is [string range $line_in 306 306] "
      } else { 
        if {[string range $line_in 307 307] != "1"} {
          set mc_reclass_msg_text_block "MASTERCARD RECLASS REASON(S): MCC Error - code is [string range $line_in 307 307] "
        } else {
          if {[string range $line_in 308 308] != "1"} {
            set mc_reclass_msg_text_block "MASTERCARD RECLASS REASON(S): Authorization Code Error - code is [string range $line_in 308 308] "
          } else {
            if {[string range $line_in 309 309] != "1"} {
              set mc_reclass_msg_text_block "MASTERCARD RECLASS REASON(S): Transaction Amt Error - code is [string range $line_in 309 309] "
            } else { 
              set mc_reclass_msg_text_block "MASTERCARD RECLASS REASON(S): UNDEFINED RECLASSIFICATION ERROR "
            }
          }
        }
      }
    }
     
    #
    # Write the reclass transaction information to the mail file
    #
    set mail_rec [format "%4s" $mc_reclass_sec_dest_inst_id]
    append mail_rec [format "%2s" " "]
    append mail_rec [format "%15s" $mc_reclass_merch_id]           
    append mail_rec [format "%2s" " "]
    append mail_rec [format "%20s" $mc_reclass_merch_name]           
    append mail_rec [format "%2s" " "]
    append mail_rec [format "%-23s" $mc_reclass_arn]
    append mail_rec [format "%2s" " "]
    append mail_rec [format "%-18s" $mc_reclass_mas_code]
    append mail_rec [format "%2s" " "]
    append mail_rec [format "%-18s" $mc_reclass_mas_code_downgrade]
    append mail_rec [format "%2s" " "]
    if {[string range $line_in 305 305] != "1"} {
      append mail_rec "Timeliness Error - code is [string range $line_in 305 305] "
    } else {
      if {[string range $line_in 306 306] != "1"} {
        append mail_rec "Magnetic Stripe Error - code is [string range $line_in 306 306] "
      } else {
        if {[string range $line_in 307 307] != "1"} {
          append mail_rec "MCC Error - code is [string range $line_in 307 307] "
        } else {
          if {[string range $line_in 308 308] != "1"} {
            append mail_rec "Authorization Code Error - code is [string range $line_in 308 308] "
          } else {
            if {[string range $line_in 309 309] != "1"} {
              append mail_rec "Transaction Amt Error - code is [string range $line_in 309 309] "
            } else { 
              append mail_rec "UNDEFINED RECLASSIFICATION ERROR "
            }
          }
        }
      }
    }

    compose_mail_msg $mail_rec

    #
    # Obtain the next available trans_seq_nbr from global_seq_ctrl;
    # advance value in global_seq_ctrl
    #
    set global_seq_ctrl_query "select g.last_seq_nbr
                               from global_seq_ctrl g
                               where g.seq_name = 'trans_seq_nbr'"
    
    orasql $global_seq_ctrl_c $global_seq_ctrl_query

    if {[orafetch $global_seq_ctrl_c -dataarray global_seq_ctrl -indexbyname] != 1403 } {
        set mc_reclass_trans_seq_nbr [expr $global_seq_ctrl(LAST_SEQ_NBR) + 1]
    } else {
        write_log_message "trans_seq_nbr was not able to be obtained from global_seq_ctrl."
        exit 1
    }

    set global_seq_ctrl_update_query "update global_seq_ctrl
                                      set last_seq_nbr = '$mc_reclass_trans_seq_nbr'
                                      where seq_name = 'trans_seq_nbr'"
 
    if {[catch {orasql $global_seq_ctrl_c $global_seq_ctrl_update_query } ora_err]} {
        oraroll $db_logon_handle_global_seq_ctrl
        puts stderr "Database update rollback for error $ora_err"
        puts stderr "[oramsg $global_seq_ctrl_c all]"
        exit 1
    } else {
        oracommit $db_logon_handle_global_seq_ctrl
    }            

    #
    # Insert reclass transaction into in_draft_main
    #
    set in_draft_main_insert_query "insert into in_draft_main
                                    (TRANS_SEQ_NBR,
                                     MSG_TYPE,
                                     TID,
                                     CARD_SCHEME,
                                     MAS_CODE,
                                     IN_FILE_NBR,
                                     IN_BATCH_NBR,
                                     EXTERNAL_RECORD_ID,
                                     PRI_DEST_INST_ID,
                                     PRI_DEST_FILE_TYPE,
                                     PRI_DEST_CLR_MODE,
                                     SEC_DEST_INST_ID,
                                     SEC_DEST_FILE_TYPE,
                                     SEC_DEST_CLR_MODE,
                                     IRFP,
                                     AMT_IRFP,
                                     IRFP_CCD,
                                     IRFP_EXP,
                                     PAN,
                                     P_CD_TRANS_TYPE,
                                     P_CD_FROM_ACCT,
                                     P_CD_TO_ACCT,
                                     AMT_TRANS,
                                     TRANS_CCD,
                                     TRANS_EXP,
                                     AMT_RECON,
                                     RECON_CCD,
                                     RECON_EXP,
                                     AMT_CH_BILL,
                                     CH_BILL_CCD,
                                     CH_BILL_EXP,
                                     CNV_RATE_RECON,
                                     CNV_RATE_CH_BILL,
                                     STAN,
                                     TRANS_DT,
                                     TRANSMIT_DT,
                                     EXPIRY_DATE,
                                     POS_CRDDAT_IN_CAP,
                                     POS_CH_AUTH_CAP,
                                     POS_CRD_CAPT_CAP,
                                     POS_OPERATING_ENV,
                                     POS_CH_PRESENT,
                                     POS_CRD_PRESENT,
                                     POS_CRDDAT_IN_MODE,
                                     POS_CH_AUTH_METHOD,
                                     POS_CH_AUTH_ENTITY,
                                     POS_CRDDAT_OUT_CAP,
                                     POS_TERM_OUT_CAP,
                                     POS_PIN_CAPT_MODE,
                                     POS_CAT_LEVEL_IND,
                                     CARD_SEQ_NBR,
                                     FUNCTION_CD,
                                     REASON_CD,
                                     MCC,
                                     ARN,
                                     ACQ_INST_ID,
                                     FORWARDING_INST_ID,
                                     RECEIVING_INST_ID,
                                     TRACK2_DATA,
                                     RETV_REF_NBR,
                                     AUTH_CD,
                                     ACTION_CD,
                                     CAT_ID,
                                     MERCH_ID,
                                     MERCH_NAME,
                                     MERCH_ADDRESS1,
                                     MERCH_ADDRESS2,
                                     MERCH_CITY,
                                     MERCH_PROV_STATE,
                                     MERCH_POST_CD_ZIP,
                                     MERCH_CNTRY_CD_NUM,
                                     MERCH_CNTRY_CD_ALP,
                                     TRACK1_DATA,
                                     AMT_FEES,
                                     FEES_CCD,
                                     FEES_EXP,
                                     SETTL_METHOD_IND,
                                     MSG_NBR,
                                     DOC_IND,
                                     DOC_TYPE,
                                     TRANS_LIFECYCLE_ID,
                                     CARD_ISS_REF_DATA,
                                     MSG_TEXT_BLOCK,
                                     CHGBK_REF_NBR,
                                     REQ_REASON_CD,
                                     ORIG_MTID,
                                     ORIG_STAN,
                                     ORIG_TRANS_DT,
                                     ORIG_ACQ_INST_ID,
                                     AMT_ORIGINAL,
                                     ORIGINAL_CCD,
                                     ORIGINAL_EXP,
                                     AMT_CH_BILL_FEE,
                                     CH_BILL_FEE_CCD,
                                     CH_BILL_FEE_EXP,
                                     RECURRING_PAY_IND,
                                     FULFILL_DOC_TYPE,
                                     MAS_CODE_DOWNGRADE,
                                     REVERSAL_IND,
                                     TRANS_DEST,
                                     TRANS_ORIGINATOR,
                                     FEE_REASON_CD,
                                     AMT_AMEX_TAX,
                                     AMEX_TAX_CCD,
                                     AMEX_TAX_EXP,
                                     CLEARING_FLAG,
                                     PROP_LICENCE_FLAG,
                                     MERCH_STATUS,
                                     ERR_CD,
                                     TC50_MSG_TEXT,
                                     TRANS_CLR_STATUS,
                                     TC_QUALIFIER,
                                     ICHG_FEE_CATEGORY,
                                     FILM_LOCATOR,
                                     CLR_DATE_J,
                                     AMT_AUTH,
                                     AUTH_CCD,
                                     AUTH_EXP,
                                     EXTERNAL_FILE_ID,
                                     SRC_INST_ID,
                                     SRC_FILE_TYPE,
                                     IRFEE_AMT_SIGN,
                                     ORIG_REASON_CD,
                                     TIER_IND,
                                     EXTERNAL_SENDER_ID,
                                     ACTIVITY_DT,
                                     BATCHMICROFILM_NBR,
                                     NETWORK_ID,
                                     FPI_OTHERS,
                                     TGA_INTERCOUNTRY,
                                     P_CD_PCODE,
                                     PARTIAL_SHIP_IND,
                                     AMT_CASHBACK) values
                                    ('$mc_reclass_trans_seq_nbr',
                                     '$mc_reclass_msg_type',
                                     '$mc_reclass_tid',
                                     '$mc_reclass_card_scheme',
                                     '$mc_reclass_mas_code',
                                     '$mc_reclass_in_file_nbr',
                                     '0',
                                     '$mc_reclass_external_record_id',
                                     '$mc_reclass_pri_dest_inst_id',
                                     '$mc_reclass_pri_dest_file_type',
                                     'D',
                                     '$mc_reclass_sec_dest_inst_id',
                                     '$mc_reclass_sec_dest_file_type',
                                     '$mc_reclass_sec_dest_clr_mode',
                                     '$mc_reclass_irfp',
                                     '$mc_reclass_amt_irfp',
                                     '$mc_reclass_irfp_ccd',
                                     '$mc_reclass_irfp_exp',
                                     '$mc_reclass_pan',
                                     '$mc_reclass_p_cd_trans_type',
                                     '$mc_reclass_p_cd_from_acct',
                                     '$mc_reclass_p_cd_to_acct',
                                     '$mc_reclass_amt_trans',
                                     '$mc_reclass_trans_ccd',
                                     '$mc_reclass_trans_exp',
                                     '$mc_reclass_amt_recon',
                                     '$mc_reclass_recon_ccd',
                                     '$mc_reclass_recon_exp',
                                     '$mc_reclass_amt_ch_bill',
                                     '$mc_reclass_ch_bill_ccd',
                                     '$mc_reclass_ch_bill_exp',
                                     '$mc_reclass_cnv_rate_recon',
                                     '$mc_reclass_cnv_rate_ch_bill',
                                     '$mc_reclass_stan',
                                     '$mc_reclass_trans_dt',
                                     '$mc_reclass_transmit_dt',
                                     '$mc_reclass_expiry_date',
                                     '$mc_reclass_pos_crddat_in_cap',
                                     '$mc_reclass_pos_ch_auth_cap',
                                     '$mc_reclass_pos_crd_capt_cap',
                                     '$mc_reclass_pos_operating_env',
                                     '$mc_reclass_pos_ch_present',
                                     '$mc_reclass_pos_crd_present',
                                     '$mc_reclass_pos_crddat_in_mode',
                                     '$mc_reclass_pos_ch_auth_method',
                                     '$mc_reclass_pos_ch_auth_entity',
                                     '$mc_reclass_pos_crddat_out_cap',
                                     '$mc_reclass_pos_term_out_cap',
                                     '$mc_reclass_pos_pin_capt_mode',
                                     '$mc_reclass_pos_cat_level_ind',
                                     '$mc_reclass_card_seq_nbr',
                                     '$mc_reclass_function_cd',
                                     '$mc_reclass_reason_cd',
                                     '$mc_reclass_mcc',
                                     '$mc_reclass_arn',
                                     '$mc_reclass_acq_inst_id',
                                     '$mc_reclass_forwarding_inst_id',
                                     '$mc_reclass_receiving_inst_id',
                                     '$mc_reclass_track2_data',
                                     '$mc_reclass_retv_ref_nbr',
                                     '$mc_reclass_auth_cd',
                                     '$mc_reclass_action_cd',
                                     '$mc_reclass_cat_id',
                                     '$mc_reclass_merch_id',
                                     '$mc_reclass_merch_name',
                                     '$mc_reclass_merch_address1',
                                     '$mc_reclass_merch_address2',
                                     '$mc_reclass_merch_city',
                                     '$mc_reclass_merch_prov_state',
                                     '$mc_reclass_merch_post_cd_zip',
                                     '$mc_reclass_merch_cntry_cd_num',
                                     '$mc_reclass_merch_cntry_cd_alp',
                                     '$mc_reclass_track1_data',
                                     '$mc_reclass_amt_fees',
                                     '$mc_reclass_fees_ccd',
                                     '$mc_reclass_fees_exp',
                                     '0',
                                     '$mc_reclass_msg_nbr',
                                     '$mc_reclass_doc_ind',
                                     '$mc_reclass_doc_type',
                                     '$mc_reclass_trans_lifecycle_id',
                                     '$mc_reclass_card_iss_ref_data',
                                     '$mc_reclass_msg_text_block',
                                     '$mc_reclass_chgbk_ref_nbr',
                                     '$mc_reclass_req_reason_cd',
                                     '$mc_reclass_orig_mtid',
                                     '$mc_reclass_orig_stan',
                                     '$mc_reclass_orig_trans_dt',
                                     '$mc_reclass_orig_acq_inst_id',
                                     '$mc_reclass_amt_original',
                                     '$mc_reclass_original_ccd',
                                     '$mc_reclass_original_exp',
                                     '$mc_reclass_amt_ch_bill_fee',
                                     '$mc_reclass_ch_bill_fee_ccd',
                                     '$mc_reclass_ch_bill_fee_exp',
                                     '$mc_reclass_recurring_pay_ind',
                                     '$mc_reclass_fulfill_doc_type',
                                     '$mc_reclass_mas_code_downgrade',
                                     '$mc_reclass_reversal_ind',
                                     '$mc_reclass_trans_dest',
                                     '$mc_reclass_trans_originator',
                                     '$mc_reclass_fee_reason_cd',
                                     '$mc_reclass_amt_amex_tax',
                                     '$mc_reclass_amex_tax_ccd',
                                     '$mc_reclass_amex_tax_exp',
                                     '$mc_reclass_clearing_flag',
                                     '$mc_reclass_prop_licence_flag',
                                     '$mc_reclass_merch_status',
                                     '$mc_reclass_err_cd',
                                     '$mc_reclass_tc50_msg_text',
                                     'X',
                                     '$mc_reclass_tc_qualifier',
                                     '$mc_reclass_ichg_fee_category',
                                     '$mc_reclass_film_locator',
                                     '$system_time',
                                     '$mc_reclass_amt_auth',
                                     '$mc_reclass_auth_ccd',
                                     '$mc_reclass_auth_exp',
                                     '$mc_reclass_external_file_id',
                                     '05',
                                     '55',
                                     '$mc_reclass_irfee_amt_sign',
                                     '$mc_reclass_orig_reason_cd',
                                     '$mc_reclass_tier_ind',
                                     '$mc_reclass_external_sender_id',
                                     to_date($run_file_date,'YYYYMMDD'),
                                     '$mc_reclass_batchmicrofilm_nbr',
                                     '$mc_reclass_network_id',
                                     '$mc_reclass_fpi_others',
                                     '$mc_reclass_tga_intercountry',
                                     '$mc_reclass_p_cd_pcode',
                                     '$mc_reclass_partial_ship_ind',
                                     '$mc_reclass_amt_cashback')"
    if {[catch {orasql $in_draft_main_c $in_draft_main_insert_query } ora_err]} {
        oraroll $db_logon_handle_in_draft_main
        puts stderr "Database update rollback for error $ora_err"
        puts stderr "[oramsg $in_draft_main_c all]"
        exit 1
    } else {
        oracommit $db_logon_handle_in_draft_main
    }            

    #
    # Insert reclass emc transaction into in_draft_emc
    #
    set in_draft_emc_insert_query "insert into in_draft_emc
                                    (TRANS_SEQ_NBR,
                                     ICHG_RATE_DESIGNAT, 
                                     IRD_ORIG) values
                                    ('$mc_reclass_trans_seq_nbr',
                                     '$mc_downgrade_psl',
                                     '$mc_orig_ird')"
    if {[catch {orasql $in_draft_emc_c $in_draft_emc_insert_query } ora_err]} {
        oraroll $db_logon_handle_in_draft_emc
        puts stderr "Database update rollback for error $ora_err"
        puts stderr "[oramsg $in_draft_emc_c all]"
        exit 1
    } else {
        oracommit $db_logon_handle_in_draft_emc
    }


};# end process_reclass


##################################################
# parse_reclass_rec
#   Parse the reclass record from the incoming
#   Mastercard acquirer reporting file.
##################################################
proc parse_reclass_rec {} {

    global db_logon_handle_global_seq_ctrl
    global db_logon_handle_in_file_log
    global global_seq_ctrl_c
    global in_file_log_c
    global inst_file_mask
    global input_acquirer_file
    global run_file_date   
        
    #
    # Obtain the next available in_file_nbr from global_seq_ctrl;
    # advance value in global_seq_ctrl
    #
    set global_seq_ctrl_query "select g.last_seq_nbr
                               from global_seq_ctrl g
                               where g.seq_name = 'in_file_nbr'"
    
    orasql $global_seq_ctrl_c $global_seq_ctrl_query

    if {[orafetch $global_seq_ctrl_c -dataarray global_seq_ctrl -indexbyname] != 1403 } {
        set mc_reclass_in_file_nbr [expr $global_seq_ctrl(LAST_SEQ_NBR) + 1]
    } else {
        write_log_message "ep_event_id was not able to be obtained from global_seq_ctrl."
        exit 1
    }

    set global_seq_ctrl_update_query "update global_seq_ctrl
                                      set last_seq_nbr = '$mc_reclass_in_file_nbr'
                                      where seq_name = 'in_file_nbr'"
 
    if {[catch {orasql $global_seq_ctrl_c $global_seq_ctrl_update_query } ora_err]} {
        oraroll $db_logon_handle_global_seq_ctrl
        puts stderr "Database update rollback for error $ora_err"
        puts stderr "[oramsg $global_seq_ctrl_c all]"
        exit 1
    } else {
        oracommit $db_logon_handle_global_seq_ctrl
    }            

    #
    # Insert record into in_file_log in order to track Mastercard reclass processing into Clearing
    #
    set in_file_log_insert_query "insert into in_file_log
                                  (IN_FILE_NBR,
                                   INSTITUTION_ID,
                                   FILE_TYPE,
                                   INCOMING_DT,
                                   EXTERNAL_FILE_ID,
                                   IN_FILE_STATUS,
                                   END_DT,
                                   EXTERNAL_FILE_NAME,
                                   EXTERNAL_SENDER_ID) values
                                  ('$mc_reclass_in_file_nbr',
                                   '$inst_file_mask',
                                   '55',
                                   to_date($run_file_date,'YYYYMMDD'),
                                   '000',
                                   'C',
                                   to_date($run_file_date,'YYYYMMDD'),
                                   'mc.rcls.$run_file_date',
                                   '')"
  
    if {[catch {orasql $in_file_log_c $in_file_log_insert_query } ora_err]} {
        oraroll $db_logon_handle_in_file_log
        puts stderr "Database update rollback for error $ora_err"
        puts stderr "[oramsg $in_file_log_c all]"
        exit 1
    } else {
        oracommit $db_logon_handle_in_file_log
    }            

    set reclass_tran_det_rec_count "0"
    set mail_rec "INST"
    append mail_rec [format "%2s" " "]
    append mail_rec "MERCHANT ID"
    append mail_rec [format "%6s" " "]
    append mail_rec "MERCHANT NAME"
    append mail_rec [format "%14s" " "]
    append mail_rec "ARN"
    append mail_rec [format "%22s" " "]
    append mail_rec "ORIG MAS CODE"
    append mail_rec [format "%7s" " "]
    append mail_rec "MAS CODE DOWNGRADE"
    append mail_rec [format "%2s" " "]
    append mail_rec "RECLASS REASON(S) for $run_file_date"
    compose_mail_msg $mail_rec
    set mail_rec ""
    compose_mail_msg $mail_rec

    while {[set line_in [gets $input_acquirer_file]] != {} } {

        set file_complete [string range $line_in 17 27]
        set msg_brand_code [string range $line_in 0 2]

        if {$file_complete == "NO ACTIVITY" && $reclass_tran_det_rec_count < 1} {
            set $mail_rec "No reclasses received from Mastercard for processing today."
            compose_mail_msg $mail_rec
            exit 0
        } elseif {$file_complete == "NO ACTIVITY" && $reclass_tran_det_rec_count > 0} {
            write_log_message "$reclass_tran_det_rec_count trans processed from the Mastercard acquirer reporting file for in_file_nbr $mc_reclass_in_file_nbr"
            exit 0
        } elseif {$msg_brand_code != "   "} {
            incr reclass_tran_det_rec_count 
            process_reclass $mc_reclass_in_file_nbr $line_in
        } else {
      }
    }
 
};# end parse_reclass_rec


##################################################
# close_mail_file
#   Close reclass mail file.
##################################################
proc close_mail_file {} {

    global mail_file_name
    global mail_file
    
    if {[catch {close $mail_file} response]} {
        puts stderr "Cannot close file $mail_file.  Changes may not be saved to the file."
        exit 1
    }
    
};# end close_mail_file


########################################
# close_db
#   Connect to the Clearing database.
########################################
proc close_db {} {

    global clrdb
    global db_logon_handle_cutoff_batch
    global db_logon_handle_global_seq_ctrl
    global db_logon_handle_in_draft_main
    global db_logon_handle_in_file_log
    global db_logon_handle_attribute_value
    global cutoff_batch_c
    global global_seq_ctrl_c
    global in_draft_main_c
    global in_file_log_c
    global attribute_value_c

    #
    # Close in_file_log
    #
    oraclose $in_file_log_c
    if {[catch {oralogoff $db_logon_handle_in_file_log} result]} {
        puts "Encountered error $result while trying to close the $clrdb database connection for in_file_log"
        exit 1
    }

    #
    # Close cutoff_batch
    #
    oraclose $cutoff_batch_c
    if {[catch {oralogoff $db_logon_handle_cutoff_batch} result]} {
        puts "Encountered error $result while trying to close the $clrdb database connection for cutoff_batch"
        exit 1
    }
 
    #
    # Close in_draft_main
    #
    oraclose $in_draft_main_c
    if {[catch {oralogoff $db_logon_handle_in_draft_main} result]} {
        puts "Encountered error $result while trying to close the $clrdb database connection for in_draft_main"
        exit 1
    }
 
    #
    # Close global_seq_ctrl
    #
    oraclose $global_seq_ctrl_c
    if {[catch {oralogoff $db_logon_handle_global_seq_ctrl} result]} {
        puts "Encountered error $result while trying to close the $clrdb database connection for global_seq_ctrl"
        exit 1
    }
 
    #
    # Close attribute_value
    #
    oraclose $attribute_value_c
    if {[catch {oralogoff $db_logon_handle_attribute_value} result]} {
        puts "Encountered error $result while trying to close the $clrdb database connection for attribute_value"
        exit 1
    }
 
};# end close_db


##################################################
# close_input_acquirer_file
#   Close acquirer reporting file from Mastercard.
##################################################
proc close_input_acquirer_file {} {

    global input_acquirer_file_name
    global input_acquirer_file
    
    if {[catch {close $input_acquirer_file} response]} {
        puts stderr "Cannot close file $input_acquirer_file."
        exit 1
    }
    
};# end close_input_acquirer_file


##################################################
# close_cfg_file
#   Close Merlin configuration file.
##################################################
proc close_cfg_file {} {

    global cfg_filename
    global cfg_file
    
    if {[catch {close $cfg_file} response]} {
        puts stderr "Cannot close file $cfg_file."
        exit 1
    }
    
};# end close_cfg_file


##################################################
# close_log_file
#   Close Merlin FTP log file.
##################################################
proc close_log_file {} {

    global log_filename
    global log_file
    
    if {[catch {close $log_file} response]} {
        puts stderr "Cannot close file $log_file.  Changes may not be saved to the file."
        exit 1
    }
    
};# end close_log_file


########
# MAIN #
########
open_log_file
write_log_message "Starting Mastercard activity file analysis for reclasses"
open_input_acquirer_file
open_cfg_file
open_mail_file
open_db

parse_reclass_rec

close_db
close_mail_file
close_cfg_file
close_input_acquirer_file
write_log_message "Ending Mastercard reclass processing into Clearing"
close_log_file

