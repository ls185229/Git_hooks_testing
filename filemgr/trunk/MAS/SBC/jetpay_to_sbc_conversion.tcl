#!/usr/bin/env tclsh
#/clearing/filemgr/.profile


################################################################################
#
#    File Name - 
#
#    Description - 
#
#    Arguments - $1 = 
#                $2 = 
#                $3 = 
#                $4 = 
#                $5 = 
#                $6 =
#                    
#    Return - 0 = Success
#             1 = Fail
#
#    Exit - 1 -
#           2 -
#           3 - DB Error
#
#    Note -
#
################################################################################
# $Id: $
# $Rev: $
# $Author: $
################################################################################

package require Oratcl

## Enviornment Variable ##
set box $env(SYS_BOX)
set prod_db $env(IST_DB)
set prod_auth_db $env(ATH_DB)
set sysinfo "System: $box \nLocation: $env(PWD) \n\n"

## Global Variable ##
set programName "[lindex [split [file tail $argv0] .] 0]"

################################################################################
#
#    Procedure Name - usage
#
#    Description - Print the script usage
#
###############################################################################
proc usage {} {
   global programName

   puts "Usage:   $programName <arg1> <arg2>"
   puts "     where <arg1> -  "
}

################################################################################
#
#    Procedure Name - init
#
#    Description - Initialize program arguments 
#
###############################################################################
proc init {} {
   global programName

   foreach {opt} [split $argv -] {
      switch -exact -- [lindex $opt 0] {
         "d" {
            set runDate [lrange $opt 1 end]
         }
         "m" {
            set mode [lrange $opt 1 end]
         }
      }
   }

   if {$runDate == ""} {
      set runDate [clock format [clock second] -format "%Y%m%d"]
   }

   if {$mode == ""} {
      set mode "PROD"
   }

   ### Read the config file to get DB params
   readCfgFile $cfg_file

   ### Intitalize database variables
   initDB


}

################################################################################
#
#    Procedure Name - initDB
#
#    Description - Setup the DB, tables and handles
#
#    Return - exit 3 if any error
#
###############################################################################
proc initDB {} {
   global programName
   global prod_db
   global prod_auth_db
   global clr_db_logon
   global auth_db_logon
   global acq_entity_tb
   global mas_fees_tb
   global non_act_fee_tb
   global entity_acct_tb
   global settl_plan_tb
   global merchant_tb
   global verify_handle
   global settl_type_tb
   global settl_refund_tb
   

   ## MASCLR and TIEHOST connection ##
   if {[catch { set clr_db_logon_handle [oralogon $clr_db_logon@$prod_db] } result] } {
      puts "Encountered error $result while trying to connect to the $prod_db database "
      exit 3
   }

   if {[catch {set auth_db_logon_handle [oralogon $auth_db_logon@$prod_auth_db]} result ]  } {
      puts "Encountered error $result while trying to connect to the $prod_auth_db database "
      exit 3
   }

   if {[catch {
           set merchant_tb           [oraopen $auth_db_logon_handle]
           set verify_handle         [oraopen $auth_db_logon_handle]
           set acq_entity_tb         [oraopen $clr_db_logon_handle]
           set mas_fees_tb           [oraopen $clr_db_logon_handle]
           set non_act_fee_tb        [oraopen $clr_db_logon_handle]
           set entity_acct_tb        [oraopen $clr_db_logon_handle]
           set settl_plan_tb         [oraopen $clr_db_logon_handle]
           set settl_type_tb         [oraopen $clr_db_logon_handle]
           set settl_refund_tb       [oraopen $clr_db_logon_handle]
        } result ]} {
      puts "Encountered error $result while creating db handles"
      exit 3
   }

}


################################################################################
#
#    Procedure Name - readCfgFile
#
#    Description - 
#
#    Return - 
#
###############################################################################
proc readCfgFile {cfg_file_name} {
   global programName
   global clr_db_logon
   global auth_db_logon

   set clr_db_logon ""

   if {[catch {open $cfg_file_name r} file_ptr]} {
      puts "File Open Err:Cannot open config file $cfg_file_name"
      exit 1
   }


   while { [set line [gets $file_ptr]] != {}} {
      set line_parms [split $line ,]
      switch -exact -- [lindex  $line_parms 0] {
         "CLR_DB_LOGON" {
            set clr_db_logon [lindex $line_parms 1]
         }
         "AUTH_DB_LOGON" {
            set auth_db_logon [lindex $line_parms 1]
         }
         default {
            puts "Unknown config parameter [lindex $line_parms 0]"
         }
      }
   }

   close $file_ptr

   if {$clr_db_logon == ""} {
      puts "Unable to find CLR_DB_LOGON params in $cfg_file_name, exiting..."
      exit 2
   }

}


################################################################################
#
#    Procedure Name - 
#
#    Description - 
#                 
#    Return -
#
###############################################################################
proc getMerchInfo {} {
   global programName
   global acq_entity_tb
   global mas_fees_tb
   global merchant_tb
   global verify_handle
   global out_file_ptr
   global non_act_fee_tb
   global entity_acct_tb
   global settl_plan_tb
   global settl_type_tb
   global settl_refund_tb

   set out_file "jetpay_105_merchant_boarding.csv"

   set rsrv 0
   set rsrv_percent 0
   
   set merchant_id	                     "0"
   set irs_tax_id_type	                 "0"
   set irs_tax_id_no	                 "0"
   set legal_business_name	             "0"
   set dba	                             "0"
   set mailing_address	                 "0"
   set mailing_city	                     "0"
   set mailing_state	                 "0"
   set mailing_zip	                     "0"
   set billing_address	                 "0"
   set billing_city	                     "0"
   set billing_state	                 "0"
   set billing_zip	                     "0"
   set business_phone	                 "0"
   set business_fax	                     "0"
   set email	                         "0"
   set url	                             "0"
   set location_address	                 "0"
   set location_city	                 "0"
   set location_state	                 "0"
   set location_zip	                     "0"
   set location_country	                 "0"
   set contact_first_name	             "0"
   set contact_last_name	             "0"
   set contact_phone	                 "0"
   set contact_fax	                     "0"
   set business_open_date	             "0"
   set length_of_ownership	             "0"
   set no_locations	                     "0"
   set avg_ticket_amount	             "0"
   set ave_month_volume	                 "0"
   set high_ticket_amount	             "0"
   set type_of_business	                 "0"
   set type_of_sale	                     "0"
   set site_inspection	                 "0"
   set high_month_volume	             "0"
   set swiped_perc	                     "0"
   set keyed_imprint_perc	             "0"
   set keyed_noimprint_perc	             "0"
   set face_to_face_perc	             "0"
   set mail_order_perc	                 "0"
   set tel_order_perc	                 "0"
   set internet_perc	                 "0"
   set ownership_type	                 "0"
   set fed_tid	                         "0"
   set owner1_first_name	             "0"
   set owner1_last_name	                 "0"
   set owner1_title	                     "0"
   set owner1_ownership_perc	         "0"
   set owner1_home_address	             "0"
   set owner1_home_city	                 "0"
   set owner1_home_state	             "0"
   set owner1_home_zip	                 "0"
   set owner1_social_securrity_no	     "0"
   set owner1_home_phone	             "0"
   set owner1_dob	                     "0"
   set owner2_first_name	             "0"
   set owner2_last_name	                 "0"
   set owner2_title	                     "0"
   set owner2_ownership_perc	         "0"
   set owner2_home_address	             "0"
   set owner2_home_city	                 "0"
   set owner2_home_state	             "0"
   set owner2_home_zip	                 "0"
   set owner2_social_securrity_no	     "0"
   set owner2_home_phone	             "0"
   set owner2_dob	                     "0"
   set trade_reference1	                 "0"
   set trade_reference1_contact	         "0"
   set trade_reference1_account_no	     "0"
   set trade_reference1_phone	         "0"
   set trade_reference2	                 "0"
   set trade_reference2_contact	         "0"
   set trade_reference2_phone	         "0"
   set trade_reference2_account_no	     "0"
   set own_other_business	             "0"
   set processing	                     "0"
   set bankcard_terminated	             "0"
   set amex	                             "0"
   set amex_discount_rate	             "0"
   set amex_flat_fee	                 "0"
   set amex_retail	                     "0"
   set amex_trans_fee	                 "0"
   set amex_services_trans_fee	         "0"
   set amex_annual_charge_volume	     "0"
   set amex_avg_ticket	                 "0"
   set amex_monthly_gross_pay	         "0"
   set amex_daily_gross_pay	             "0"
   set amex_pay_frequency	             "0"
   set amex_no	                             "0"
   set discover_no	                     "0"
   set jcb_no	                         "0"
   set check_guar	                     "0"
   set check_guar_co	                 "0"
   set check_guar_method	             "0"
   set ecr_software_internet_type	     "0"
   set terminal_type	                 "0"
   set type_of_printer	                 "0"
   set type_of_pin_pad	                 "0"
   set tip_line_required	             "0"
   set auto_batch	                     "0"
   set manual_imprinter	                 "0"
   set business_type	                 "0"
   set mc_qcr1_disc	                     "0"
   set mc_qcr1_trans	                 "0"
   set mc_qcr2_disc	                     "0"
   set mc_qcr2_trans	                 "0"
   set mc_qcr3_disc	                     "0"
   set mc_qcr3_trans	                 "0"
   set mc_qcr4_disc	                     "0"
   set mc_qcr4_trans	                 "0"
   set mc_qcr5_disc	                     "0"
   set mc_qcr5_trans	                 "0"
   set vs_qcr1_disc	                     "0"
   set vs_qcr1_trans	                 "0"
   set vs_qcr2_disc	                     "0"
   set vs_qcr2_trans	                 "0"
   set vs_qcr3_disc	                     "0"
   set vs_qcr3_trans	                 "0"
   set vs_qcr4_disc	                     "0"
   set vs_qcr4_trans	                 "0"
   set vs_qcr5_disc	                     "0"
   set vs_qcr5_trans	                 "0"
   set disc_qcr1_disc	                 "0"
   set disc_qcr1_trans	                 "0"
   set disc_qcr2_disc	                 "0"
   set disc_qcr2_trans	                 "0"
   set disc_qcr3_disc	                 "0"
   set disc_qcr3_trans	                 "0"
   set disc_qcr4_disc	                 "0"
   set disc_qcr4_trans	                 "0"
   set disc_qcr5_disc	                 "0"
   set disc_qcr5_trans	                 "0"
   set pti_credit_trans                  "0"
   set pti_debit_disc	                 "0"
   set pti_debit_trans	                 "0"
   set ach_fee	                         "0"
   set amex_auth_fee	                 "0"
   set debit_atm_fee	                 "0"
   set discover_auth_fee	             "0"
   set mc_vs_auth_fee	                 "0"
   set voice_auth_fee	                 "0"
   set jcb_auth_fee	                     "0"
   set ach_reject_fee	                 "0"
   set annual_fee	                     "0"
   set chargeback_fee                    "0"
   set merchant_club_fee	             "0"
   set early_cancelation_fee	         "0"
   set pci_non_compliance_fee	         "0"
   set min_monthly_disc_fee	             "0"
   set monthly_gateway_fee	             "0"
   set statement_fee	                 "0"
   set online_merchant_portal	         "0"
   set bank_phone	                     "0"
   set bank_name	                     "0"
   set bank_transit_number	             "0"
   set bank_dda_no	                     "0"
   set location_type	                 "0"
   set photo	                         "0"
   set dob	                             "0"
   set fulfillment_house_used	         "0"
   set delivery_methods	                 "0"
   set form__of_id	                     "0"
   set business_description	             "0"
   set charging_policy	                 "0"
   set refund_policy	                 "0"
   set sufficient_inventory	             "0"
   set mc_vs_decals_visible	             "0"
   set business_o_and_o	                 "0"
   set delivery_time_of_sale	         "0"
   set sales_phone_no	                 "0"
   set sales_signing_rep	             "0"
   set sales_chain_id	                 "0"
   set amex_category_code	             "0"
   set visa_mc_category_code	         "0"
   set irs_category_code	             "0"
   set application_fee	                 "0"
   set retrieval_fee	                 "0"
   set help_desk_fee	                 "0"
   set visa_mid	                         "0"
   set gross_vs_net	                     "0"
   set daily_vs_monthly	                 "0"
   set interchange_plus	                 "0"
   set pti_credit_disc	                 "0"
   set gov_comp_fee	                     "0"
   set roll_res_perc	                 "0"
   set roll_res_lot	                     "0"
   set roll_res_amt	                     "0"
   set billing_descriptor	             "0"
   set type_of_id_info	                 "0"
   set interchange_fee_give_back	     "0"
   set roll_reserve	                     "0"
   set tokenization_fee	                 "0"
   set sales_number	                     "0"
   set avs_fee	                       "0"
   set cvv2_fee	                       "0"
   set bi_annual_fee	                 "0"
   set capture_mode	                     "0"
   set build_terminal_load	             "0"
   set terminal_description              "0"


   #### Open output file
   if {[catch {open $out_file {WRONLY CREAT APPEND}} out_file_ptr]} {
      puts "Open Err: Cannot open $out_file"
      exit 1
   }

   puts $out_file_ptr "merchant_id;irs_tax_id_type;irs_tax_id_no;legal_business_name;dba;mailing_address;mailing_city;mailing_state;mailing_zip;billing_address;billing_city;billing_state;billing_zip;business_phone;business_fax;email;url;location_address;location_city;location_state;location_zip;location_country;contact_first_name;contact_last_name;contact_phone;contact_fax;business_open_date;length_of_ownership;no_locations;avg_ticket_amount;ave_month_volume;high_ticket_amount;type_of_business;type_of_sale;site_inspection;high_month_volume;swiped_perc;keyed_imprint_perc;keyed_noimprint_perc;face_to_face_perc;mail_order_perc;tel_order_perc;internet_perc;ownership_type;fed_tid;owner1_first_name;owner1_last_name;owner1_title;owner1_ownership_perc;owner1_home_address;owner1_home_city;owner1_home_state;owner1_home_zip;owner1_social_securrity_no;owner1_home_phone;owner1_dob;owner2_first_name;owner2_last_name;owner2_title;owner2_ownership_perc;owner2_home_address;owner2_home_city;owner2_home_state;owner2_home_zip;owner2_social_securrity_no;owner2_home_phone;owner2_dob;trade_reference1;trade_reference1_contact;trade_reference1_account_no;trade_reference1_phone;trade_reference2;trade_reference2_contact;trade_reference2_phone;trade_reference2_account_no;own_other_business;processing;bankcard_terminated;amex;amex_discount_rate;amex_flat_fee;amex_retail;amex_trans_fee;amex_services_trans_fee;amex_annual_charge_volume;amex_avg_ticket;amex_monthly_gross_pay;amex_daily_gross_pay;amex_pay_frequency;amex_no;discover_no;jcb_no;check_guar;check_guar_co;check_guar_method;ecr_software_internet_type;terminal_type;type_of_printer;type_of_pin_pad;tip_line_required;auto_batch;manual_imprinter;business_type;mc_qcr1_disc;mc_qcr1_trans;mc_qcr2_disc;mc_qcr2_trans;mc_qcr3_disc;mc_qcr3_trans;mc_qcr4_disc;mc_qcr4_trans;mc_qcr5_disc;mc_qcr5_trans;vs_qcr1_disc;vs_qcr1_trans;vs_qcr2_disc;vs_qcr2_trans;vs_qcr3_disc;vs_qcr3_trans;vs_qcr4_disc;vs_qcr4_trans;vs_qcr5_disc;vs_qcr5_trans;disc_qcr1_disc;disc_qcr1_trans;disc_qcr2_disc;disc_qcr2_trans;disc_qcr3_disc;disc_qcr3_trans;disc_qcr4_disc;disc_qcr4_trans;disc_qcr5_disc;disc_qcr5_trans;pti_credit_trans;pti_debit_disc;pti_debit_trans;ach_fee;amex_auth_fee;debit_atm_fee;discover_auth_fee ;mc_vs_auth_fee ;voice_auth_fee;jcb_auth_fee;ach_reject_fee ;annual_fee;chargeback_fee ;merchant_club_fee;early_cancelation_fee;pci_non_compliance_fee;min_monthly_disc_fee;monthly_gateway_fee;statement_fee;online_merchant_portal;bank_phone;bank_name;bank_transit_number;bank_dda_no;location_type;photo;dob;fulfillment_house_used;delivery_methods;form__of_id;business_description;charging_policy;refund_policy;sufficient_inventory;mc_vs_decals_visible;business_o_and_o;delivery_time_of_sale;sales_phone_no;sales_signing_rep;sales_chain_id;amex_category_code;visa_mc_category_code;irs_category_code;application_fee;retrieval_fee ;help_desk_fee;visa_mid;gross_vs_net;daily_vs_monthly;interchange_plus;pti_credit_disc;gov_comp_fee;roll_res_perc;roll_res_lot;roll_res_amt;billing_descriptor;type_of_id_info;interchange_fee_give_back;roll_reserve;tokenization_fee;sales_number;avs_fee ;cvv2_fee;bi_annual_fee;capture_mode;build_terminal_load;terminal_description"



   set ae_query "SELECT ae.institution_id,                  
       ae.entity_id,                            
       ae.entity_dba_name,                      
       ae.tax_id,
       ae.entity_name,
       ae.default_mcc,                          
       ae.billing_type,                         
       to_char(ae.actual_start_date,'yyyy/dd/mm') as ACTUAL_START_DATE,
       ae.termination_date,                     
       ae.rsrv_fund_status,                     
       ae.rsrv_percentage,
       ae.rsrv_to_be_met,                       
       ae.company_type,                         
       ae.processing_type,                      
       ae.settl_plan_id,                        
       (SELECT address1                         
       FROM master_address                      
       WHERE institution_id = '105'             
       AND address_id      IN                   
         (SELECT address_id                     
         FROM acq_entity_address                
         WHERE institution_id = '105'           
         AND entity_id        = ae.entity_id    
         AND address_role     = 'LOC'           
         )                                      
       ) AS  LOC_ADDRESS ,                      
       (SELECT city                             
       FROM master_address                      
       WHERE institution_id = '105'             
       AND address_id      IN                   
         (SELECT address_id                     
         FROM acq_entity_address                
         WHERE institution_id = '105'           
         AND entity_id        = ae.entity_id    
         AND address_role     = 'LOC'           
         )                                      
       ) AS  LOC_CITY ,                         
       (SELECT PROV_STATE_ABBREV                
       FROM master_address                      
       WHERE institution_id = '105'             
       AND address_id      IN                   
         (SELECT address_id                     
         FROM acq_entity_address                
         WHERE institution_id = '105'           
         AND entity_id        = ae.entity_id    
         AND address_role     = 'LOC'           
         )                                      
       ) AS  LOC_STATE ,                        
       (SELECT POSTAL_CD_ZIP                    
       FROM master_address                      
       WHERE institution_id = '105'             
       AND address_id      IN                   
         (SELECT address_id                     
         FROM acq_entity_address                
         WHERE institution_id = '105'           
         AND entity_id        = ae.entity_id    
         AND address_role     = 'LOC'           
         )                                      
       ) AS  LOC_ZIP ,                          
       (SELECT url                              
       FROM master_address                      
       WHERE institution_id = '105'             
       AND address_id      IN                   
         (SELECT address_id                     
         FROM acq_entity_address                
         WHERE institution_id = '105'           
         AND entity_id        = ae.entity_id    
         AND address_role     = 'LOC'           
         )                                      
       ) AS  LOC_URL ,                          
       (SELECT replace(phone1,'-','')
       FROM master_address                      
       WHERE institution_id = '105'             
       AND address_id      IN                   
         (SELECT address_id                     
         FROM acq_entity_address                
         WHERE institution_id = '105'           
         AND entity_id        = ae.entity_id    
         AND address_role     = 'LOC'           
         )                                      
       ) AS  LOC_PHONE ,                        
       (SELECT replace(fax,'-','')
       FROM master_address
       WHERE institution_id = '105'
       AND address_id      IN
         (SELECT address_id
         FROM acq_entity_address
         WHERE institution_id = '105'
         AND entity_id        = ae.entity_id
         AND address_role     = 'LOC'
         )
       ) AS  LOC_FAX ,
       (SELECT email_address
       FROM master_address
       WHERE institution_id = '105'
       AND address_id      IN
         (SELECT address_id
         FROM acq_entity_address
         WHERE institution_id = '105'
         AND entity_id        = ae.entity_id
         AND address_role     = 'LOC'
         )
       ) AS  LOC_EMAIL_ADDRESS ,
       (SELECT country
       FROM master_address
       WHERE institution_id = '105'
       AND address_id      IN
         (SELECT address_id
         FROM acq_entity_address
         WHERE institution_id = '105'
         AND entity_id        = ae.entity_id
         AND address_role     = 'LOC'
         )
       ) AS  LOC_COUNTRY,
       (SELECT address1                         
       FROM master_address                      
       WHERE institution_id = '105'             
       AND address_id      IN                   
         (SELECT address_id                     
         FROM acq_entity_address                
         WHERE institution_id = '105'           
         AND entity_id        = ae.entity_id    
         AND address_role     = 'BIL'           
         )                                      
       ) AS  BIL_ADDRESS ,                      
       (SELECT city                             
       FROM master_address                      
       WHERE institution_id = '105'             
       AND address_id      IN                   
         (SELECT address_id                     
         FROM acq_entity_address                
         WHERE institution_id = '105'           
         AND entity_id        = ae.entity_id    
         AND address_role     = 'BIL'           
         )                                      
       ) AS  BIL_CITY ,                         
       (SELECT PROV_STATE_ABBREV                
       FROM master_address                      
       WHERE institution_id = '105'             
       AND address_id      IN                   
         (SELECT address_id                     
         FROM acq_entity_address                
         WHERE institution_id = '105'           
         AND entity_id        = ae.entity_id    
         AND address_role     = 'BIL'           
         )                                      
       ) AS  BIL_STATE ,                        
       (SELECT POSTAL_CD_ZIP                    
       FROM master_address                      
       WHERE institution_id = '105'             
       AND address_id      IN                   
         (SELECT address_id                     
         FROM acq_entity_address                
         WHERE institution_id = '105'           
         AND entity_id        = ae.entity_id    
         AND address_role     = 'BIL'           
         )                                      
       ) AS  BIL_ZIP ,                          
       (SELECT url                              
       FROM master_address                      
       WHERE institution_id = '105'             
       AND address_id      IN                   
         (SELECT address_id                     
         FROM acq_entity_address                
         WHERE institution_id = '105'           
         AND entity_id        = ae.entity_id    
         AND address_role     = 'BIL'           
         )                                      
       ) AS  BIL_URL ,                          
       (SELECT replace(phone1,'-','')
       FROM master_address                      
       WHERE institution_id = '105'             
       AND address_id      IN                   
         (SELECT address_id                     
         FROM acq_entity_address                
         WHERE institution_id = '105'           
         AND entity_id        = ae.entity_id    
         AND address_role     = 'BIL'           
         )                                      
       ) AS  BIL_PHONE ,                        
       (SELECT address1                         
       FROM master_contact                      
       WHERE institution_id = '105'             
       AND contact_id      IN                   
         (SELECT contact_id                     
         FROM acq_entity_contact                
         WHERE institution_id = '105'           
         AND entity_id        = ae.entity_id    
         AND contact_role     = 'DEF'           
         )                                      
       ) AS  DEF_ADDRESS ,                      
       (SELECT city                             
       FROM master_contact                      
       WHERE institution_id = '105'             
       AND contact_id      IN                   
         (SELECT contact_id                     
         FROM acq_entity_contact                
         WHERE institution_id = '105'           
         AND entity_id        = ae.entity_id    
         AND contact_role     = 'DEF'           
         )                                      
       ) AS  DEF_CITY ,                         
       (SELECT PROV_STATE_ABBREV                
       FROM master_contact                      
       WHERE institution_id = '105'             
       AND contact_id      IN                   
         (SELECT contact_id                     
         FROM acq_entity_contact                
         WHERE institution_id = '105'           
         AND entity_id        = ae.entity_id    
         AND contact_role     = 'DEF'           
         )                                      
       ) AS  DEF_STATE ,                        
       (SELECT POSTAL_CD_ZIP                    
       FROM master_contact                      
       WHERE institution_id = '105'             
       AND contact_id      IN                   
         (SELECT contact_id                     
         FROM acq_entity_contact                
         WHERE institution_id = '105'           
         AND entity_id        = ae.entity_id    
         AND contact_role     = 'DEF'           
         )                                      
       ) AS  DEF_ZIP ,                          
       (SELECT first_name                       
       FROM master_contact                      
       WHERE institution_id = '105'             
       AND contact_id      IN                   
         (SELECT contact_id                     
         FROM acq_entity_contact                
         WHERE institution_id = '105'           
         AND entity_id        = ae.entity_id    
         AND contact_role     = 'DEF'           
         )                                      
       ) AS  DEF_FIRST_NAME ,                   
       (SELECT last_name                        
       FROM master_contact                      
       WHERE institution_id = '105'             
       AND contact_id      IN                   
         (SELECT contact_id                     
         FROM acq_entity_contact                
         WHERE institution_id = '105'           
         AND entity_id        = ae.entity_id    
         AND contact_role     = 'DEF'           
         )                                      
       ) AS  DEF_LAST_NAME ,                    
       (SELECT professional_title               
       FROM master_contact                      
       WHERE institution_id = '105'             
       AND contact_id      IN                   
         (SELECT contact_id                     
         FROM acq_entity_contact                
         WHERE institution_id = '105'           
         AND entity_id        = ae.entity_id    
         AND contact_role     = 'DEF'           
         )                                      
       ) AS  DEF_PROF_TITLE ,                   
       (SELECT email_address                    
       FROM master_contact                      
       WHERE institution_id = '105'             
       AND contact_id      IN                   
         (SELECT contact_id                     
         FROM acq_entity_contact                
         WHERE institution_id = '105'           
         AND entity_id        = ae.entity_id    
         AND contact_role     = 'DEF'           
         )                                      
       ) AS  DEF_EMAIL ,
       (SELECT phone1
       FROM master_contact
       WHERE institution_id = '105'
       AND contact_id      IN
         (SELECT contact_id
         FROM acq_entity_contact
         WHERE institution_id = '105'
         AND entity_id        = ae.entity_id
         AND contact_role     = 'DEF'
         )
       ) AS  DEF_PHONE1,
       (SELECT country                          
       FROM master_contact                      
       WHERE institution_id = '105'             
       AND contact_id      IN                   
         (SELECT contact_id                     
         FROM acq_entity_contact                
         WHERE institution_id = '105'           
         AND entity_id        = ae.entity_id    
         AND contact_role     = 'DEF'           
         )                                      
       ) AS  DEF_COUNTRY ,                      
       (SELECT replace(fax,'-','')
       FROM master_contact                      
       WHERE institution_id = '105'             
       AND contact_id      IN                   
         (SELECT contact_id                     
         FROM acq_entity_contact                
         WHERE institution_id = '105'           
         AND entity_id        = ae.entity_id    
         AND contact_role     = 'DEF'           
         )                                      
       ) AS  DEF_FAX                            
FROM acq_entity ae                         
WHERE ae.institution_id ='105'             
AND ae.entity_level     = '70'
AND ae.entity_status    = 'A'
and ae.entity_id not in ('402529211000171',
'402529411000242',
'402529421060207',
'402529299000099',
'402529413000010',
'402529413000011',
'402529213000014',
'402529213000013',
'402529213000018',
'402529213000017',
'402529213000012')
order by ae.billing_type,ae.entity_id"

#AND ae.entity_id        in ('402529211000209','402529230120010','402529211000143', '402529211000187', '402529211000202',
#'402529221080011',
#'402529232000011',
#'402529241690374',
#'402529256000011',
#'402529287000045')

   ##puts "T-1 ae_query - $ae_query"
   orasql $acq_entity_tb $ae_query

   while {[orafetch $acq_entity_tb -dataarray entity -indexbyname] != 1403} {

     ### Get amex and discover id
     set query "select unique VISA_ID,DISCOVER_ID,AMEX_SE_NO
                from merchant
                where visa_id = '$entity(ENTITY_ID)'"
     ##puts "T-1 query-$query"
     orasql $merchant_tb $query

     if {[catch {orafetch $merchant_tb -dataarray merch -indexbyname} result]} {
        puts "Error: Could not find this entity in merchant table - $query"
     }


     switch -exact -- $entity(PROCESSING_TYPE) {
         "I" {
            set proc_type "Internet"
         }
         "R" {
            set proc_type "Retail"
         }
         "M" {
            set proc_type "Mail Order Telephone Order"
         }
         default {
            set proc_type ""
         }
     }

     switch -exact -- $entity(BILLING_TYPE) {
         "PT" {
            set bill_type "1"
         }
         "BT" {
            set bill_type "0"
         }
         default {
            set bill_type ""
         }
     }

     ### Get Reserve Information
     
     if { [string equal $entity(RSRV_FUND_STATUS) "R"] } {
        set rsrv 1
        set rsrc_percent $entity(RSRV_PERCENTAGE)
     } else {
        set rsrv 0
        set rsrc_percent 0
     }

     set query "select unique institution_id,fee_pkg_id,card_scheme,mas_code,tid_Fee,rate_per_item,rate_percent
               from mas_fees
               where institution_id ='105'
               and card_scheme  in ('00','03','02','04','05','08')
               and fee_pkg_id in (select fee_pkg_id
                                  from entity_fee_pkg
                                  where institution_id ='105'
                                  and entity_id = '$entity(ENTITY_ID)'
                                  and end_date is null)
               and fee_pkg_id not in ('33','34','11','21')
               and tid_fee in (select tid
                               from settl_plan_tid
                               where settl_flag = 'Y' 
                               and settl_plan_id in (select settl_plan_id
                                                     from acq_entity 
                                                     where institution_id  ='105'
                                                     and entity_id ='$entity(ENTITY_ID)') )
               order by card_scheme,mas_code"

   set discount 0
   set settle_fee 0
   set intchg_refund 0
   set ach_proc 0
   set achrej   0
   set axauth   0
   set dsauth   0
   set vsmcauth 0
   set cb       0
   set rr       0
   set avs      0
   set cvv      0
   set vt1    0
   set vt2    0
   set vt3    0
   set mt1    0
   set mt2    0
   set mt3    0
   set dt1    0
   set dt2    0
   set dt3    0 
  
   set monmin 0
   set govcomp 0

   set freq ""
   set type ""

   set routnbr 0
   set acctnbr 0
      orasql $mas_fees_tb $query

      ### Get activity fees
      while {[orafetch $mas_fees_tb -dataarray masfees -indexbyname] != 1403} {
            switch -exact -- $masfees(MAS_CODE) {
               "DISC_DISCOUNT" -
               "MC_DISCOUNT" -
               "VISA_DISCOUNT" {
                   set discount $masfees(RATE_PERCENT)
               }
               "VISA_SETTLE" -
               "MC_SETTLE" -
               "DISC_SETTLE" {
                   set settle_fee $masfees(RATE_PER_ITEM)
               }
               "00ACHPRC" {
                   set ach_proc $masfees(RATE_PER_ITEM)
               }
               "00ACHREJ" {
                   set achrej $masfees(RATE_PER_ITEM)
               }
               "AMEX_AUTH" {
                   set axauth $masfees(RATE_PER_ITEM)
               } 
               "DISC_AUTH" {
                   set dsauth $masfees(RATE_PER_ITEM)
               }
               "VISA_AUTH" -
               "MC_AUTH" {
                   set vsmcauth $masfees(RATE_PER_ITEM)
               }
               "08CHGBCKFEE" -
               "05CHGBCKFEE" - 
               "04CHGBCKFEE" {
                   set cb $masfees(RATE_PER_ITEM)
               }
               "0205RREQ" -
               "0208RREQ" -
               "0204RREQ" {
                   set rr $masfees(RATE_PER_ITEM)
               }
               "00AAVSCHK" -
               "03AAVSCHK" -
               "04AAVSCHK" -
               "05AAVSCHK" -
               "08AAVSCHK" {
                    set avs $masfees(RATE_PER_ITEM)
               }
               "00ACVVCHK" -
               "03ACVVCHK" -
               "04ACVVCHK" -
               "05ACVVCHK" -
               "08ACVVCHK" {
                    set cvv $masfees(RATE_PER_ITEM)
               }
               "VISA_T1" -
               "NS_VISA_T1" -
               "TFP_VISA_T1" {
                    set vt1 $masfees(RATE_PERCENT)
               }
               "VISA_T2" {
                    set vt2 $masfees(RATE_PERCENT)
               }
               "VISA_T3" {
                    set vt3 $masfees(RATE_PERCENT)
               }
               "NS_VISA_T2" -
               "TFP_VISA_T2"  {
                    set vt2 $masfees(RATE_PERCENT)
                    set vt3 $masfees(RATE_PERCENT)
               }
               "MC_T1"  -
               "NS_MC_T1" -
               "TFP_MC_T1" {
                    set mt1 $masfees(RATE_PERCENT)
               }
               "MC_T2" {
                    set mt2 $masfees(RATE_PERCENT)
               }
               "MC_T3" {
                    set mt3 $masfees(RATE_PERCENT)
               }
               "NS_MC_T2" -
               "TFP_MC_T2"  {
                    set mt2 $masfees(RATE_PERCENT)
                    set mt3 $masfees(RATE_PERCENT)
               }
               "DISC_T1" -
               "NS_DISC_T1" -
               "TFP_DISC_T1" {
                    set dt1 $masfees(RATE_PERCENT)
               }
               "DISC_T2" {
                    set dt2 $masfees(RATE_PERCENT)
               }
               "DISC_T3" {
                    set dt3 $masfees(RATE_PERCENT)
               }
               "NS_DISC_T2" -
               "TFP_DISC_T2"  {
                    set dt2 $masfees(RATE_PERCENT)
                    set dt3 $masfees(RATE_PERCENT)
               }
               default {
               }
            } ;#switch case
      }; #end of while mas fees
 
   
      ### Get non-activity fees

      set query "select institution_id,non_act_fee_pkg_id,charge_method,generate_freq,tid,mas_code,fee_amt
                 from non_activity_fees
                 where institution_id = '105'
                 and non_act_fee_pkg_id in ( select non_act_fee_pkg_id
                                             from ent_nonact_fee_pkg
                                             where institution_id = '105'
                                             and entity_id = '$entity(ENTITY_ID)'
                                             and end_date is null) "


      orasql $non_act_fee_tb $query

      while {[orafetch $non_act_fee_tb -dataarray nonactfees -indexbyname] != 1403} {
          switch -exact -- $nonactfees(MAS_CODE) {
               "00MONMIN" {
                   set monmin $nonactfees(FEE_AMT)
               }
               "00GOVCOMP" {
                   set govcomp $nonactfees(FEE_AMT)
               }
               default {
               }
          }; #switch nonactfees

      }; #end of while non_act_fees

     ### Get info on interchange refund or not

     set query "select count(1) as COUNT
                from settl_plan_tid
                where institution_id = '105'
                and settl_flag = 'Y'
                and tid in ('010004020005','010004700005')
                and card_scheme in ('04','05','02','08')
                and settl_plan_id = '$entity(SETTL_PLAN_ID)'"

     orasql $settl_refund_tb $query

     orafetch $settl_refund_tb -dataarray refundItchg -indexbyname
     if {$refundItchg(COUNT) == 0} {
        set intchg_refund 0
     } else {
         set intchg_refund 1
     }


     ### Get settle frequency

     set query "select unique institution_id,settl_plan_id,settl_flag,card_scheme,settl_freq
                from settl_plan_tid
                where institution_id = '105'
                and card_scheme = '04'
                and tid in ('010004010000','010004020000')
                and settl_plan_id in (select settl_plan_id from acq_entity where institution_id = '105' and entity_id = '$entity(ENTITY_ID)')"

      orasql $settl_plan_tb $query

      while {[orafetch $settl_plan_tb -dataarray settlplan -indexbyname] != 1403} {
          switch -exact -- $settlplan(SETTL_FREQ) {
               "M" { 
                   set freq "Monthly"
               }
               "D" {
                   set freq "Daily"
               }
               default {
                   set freq ""
               }
          }; #switch settlplan

      }; #end of while settle plan

      #### Get Net/Gross

      set query "select institution_id,settl_plan_id,settl_plan_type,plan_desc
                 from settl_plan
                 where institution_id = '105'
                 and settl_plan_id = '$entity(SETTL_PLAN_ID)' "

      ##puts "T-1 query - $query"
 
      orasql $settl_type_tb $query

      while {[orafetch $settl_type_tb -dataarray settl_type -indexbyname] != 1403} {
          switch -exact -- $settl_type(SETTL_PLAN_TYPE) {
               "N" {
                   set type "Net"
               }
               "G" {
                   set type "Gross"
               }
               default {
                   set type ""
               }
          }
      } ; #end of while settl_type

      ### Get banking info

      set query "select institution_id,entity_acct_id,owner_entity_id,customer_name,trans_routing_nbr,acct_nbr,acct_type,acct_posting_type
                 from entity_acct
                 where institution_id = '105'
                 and acct_posting_type = 'A'
                 and owner_entity_id = '$entity(ENTITY_ID)'"

      orasql $entity_acct_tb $query

      while {[orafetch $entity_acct_tb -dataarray ea -indexbyname] != 1403} {
         set routnbr "$ea(TRANS_ROUTING_NBR)"
         set acctnbr "$ea(ACCT_NBR)"
      } ; #end of while for entity_acct


      set merchant_id                 $entity(ENTITY_ID)
      set irs_tax_id_type             ""
      set irs_tax_id_no               $entity(TAX_ID)  
      set legal_business_name         $entity(ENTITY_NAME)  
      set dba                         $entity(ENTITY_DBA_NAME)
      set interchange_plus            $entity(BILLING_TYPE)
      set mailing_address             $entity(LOC_ADDRESS)  
      set mailing_city                $entity(LOC_CITY)  
      set mailing_state               $entity(LOC_STATE)  
      set mailing_zip                 $entity(LOC_ZIP)  
      set billing_address             $entity(BIL_ADDRESS)  
      set billing_city                $entity(BIL_CITY)  
      set billing_state               $entity(BIL_STATE)  
      set billing_zip                 $entity(BIL_ZIP)  
      set business_phone              $entity(LOC_PHONE)  
      set business_fax                $entity(LOC_FAX)  
      set email                       $entity(LOC_EMAIL_ADDRESS)
      set url                         $entity(BIL_URL)  
      set location_address            $entity(LOC_ADDRESS)  
      set location_city               $entity(LOC_CITY)  
      set location_state              $entity(LOC_STATE)  
      set location_zip                $entity(LOC_ZIP)  
      set location_country            $entity(LOC_COUNTRY)  
      set contact_first_name          $entity(DEF_FIRST_NAME)  
      set contact_last_name           $entity(DEF_LAST_NAME)  
      set contact_phone               $entity(DEF_PHONE1)  
      set contact_fax                 $entity(DEF_FAX)  
      set business_open_date          $entity(ACTUAL_START_DATE)  
      set length_of_ownership         ""  
      set no_locations                ""  
      set avg_ticket_amount           ""  
      set ave_month_volume            ""  
      set high_ticket_amount          ""  
      set type_of_business            $proc_type  
      set type_of_sale                $proc_type
      set site_inspection             ""  
      set high_month_volume           ""  
      set swiped_perc                 ""  
      set keyed_imprint_perc          ""  
      set keyed_noimprint_perc        ""  
      set face_to_face_perc           ""  
      set mail_order_perc             ""  
      set tel_order_perc              ""  
      set internet_perc               ""  
      set ownership_type              ""  
      set fed_tid                     ""  
      set owner1_first_name           ""  
      set owner1_last_name            ""  
      set owner1_title                ""  
      set owner1_ownership_perc       ""  
      set owner1_home_address         ""  
      set owner1_home_city            ""  
      set owner1_home_state           ""  
      set owner1_home_zip             ""  
      set owner1_social_securrity_no  ""  
      set owner1_home_phone           ""  
      set owner1_dob                  ""  
      set owner2_first_name           ""            
      set owner2_last_name            ""  
      set owner2_title                ""  
      set owner2_ownership_perc       ""  
      set owner2_home_address         ""  
      set owner2_home_city            ""  
      set owner2_home_state           ""  
      set owner2_home_zip             ""  
      set owner2_social_securrity_no  ""  
      set owner2_home_phone           ""  
      set owner2_dob                  ""  
      set trade_reference1            ""  
      set trade_reference1_contact    ""  
      set trade_reference1_account_no ""  
      set trade_reference1_phone      ""  
      set trade_reference2            ""  
      set trade_reference2_contact    ""  
      set trade_reference2_phone      ""  
      set trade_reference2_account_no ""  
      set own_other_business          ""  
      set processing                  "Y"  
      set bankcard_terminated         "N" 
      set amex                        ""  
      set amex_discount_rate          ""  
      set amex_flat_fee               ""  
      set amex_retail                 ""  
      set amex_trans_fee              ""  
      set amex_services_trans_fee     ""  
      set amex_annual_charge_volume   ""  
      set amex_avg_ticket             ""  
      set amex_monthly_gross_pay      ""  
      set amex_daily_gross_pay        ""  
      set amex_pay_frequency          ""  
      set amex_no                     $merch(AMEX_SE_NO) 
      set discover_no                 $merch(DISCOVER_ID)  
      set jcb_no                      ""  
      set check_guar                  ""
      set check_guar_co               ""
      set check_guar_method           ""
      set ecr_software_internet_type  ""
      set terminal_type               ""
      set type_of_printer             ""
      set type_of_pin_pad             ""
      set tip_line_required           ""
      set auto_batch                  ""
      set manual_imprinter            ""
      set business_type               ""
      set mc_qcr1_disc                "$mt1"      
      set mc_qcr1_trans               "$settle_fee"      
      set mc_qcr2_disc                "$mt2"      
      set mc_qcr2_trans               ""      
      set mc_qcr3_disc                "$mt3"      
      set mc_qcr3_trans               ""      
      set mc_qcr4_disc                ""      
      set mc_qcr4_trans               ""      
      set mc_qcr5_disc                ""      
      set mc_qcr5_trans               ""      
      set vs_qcr1_disc                "$vt1"      
      set vs_qcr1_trans               "$settle_fee"      
      set vs_qcr2_disc                "$vt2"      
      set vs_qcr2_trans               ""      
      set vs_qcr3_disc                "$vt3"      
      set vs_qcr3_trans               ""      
      set vs_qcr4_disc                ""      
      set vs_qcr4_trans               ""      
      set vs_qcr5_disc                ""      
      set vs_qcr5_trans               ""      
      set disc_qcr1_disc              "$dt1"      
      set disc_qcr1_trans             "$settle_fee"      
      set disc_qcr2_disc              "$dt2"      
      set disc_qcr2_trans             ""      
      set disc_qcr3_disc              "$dt3"      
      set disc_qcr3_trans             ""      
      set disc_qcr4_disc              ""      
      set disc_qcr4_trans             ""      
      set disc_qcr5_disc              ""      
      set disc_qcr5_trans             ""      
      set pti_credit_trans            ""      
      set pti_debit_disc              ""      
      set pti_debit_trans             ""      
      set ach_fee                     "$ach_proc"      
      set amex_auth_fee               "$axauth"      
      set debit_atm_fee               ""      
      set discover_auth_fee           "$dsauth"      
      set mc_vs_auth_fee              "$vsmcauth"      
      set voice_auth_fee              ""      
      set jcb_auth_fee                ""      
      set ach_reject_fee              "$achrej"      
      set annual_fee                  ""      
      set chargeback_fee              "$cb"      
      set merchant_club_fee           ""      
      set early_cancelation_fee       ""      
      set pci_non_compliance_fee      ""      
      set min_monthly_disc_fee        "$monmin"      
      set monthly_gateway_fee         ""      
      set statement_fee               ""      
      set online_merchant_portal      ""      
      set bank_phone                  ""      
      set bank_name                   ""      
      set bank_transit_number         "$routnbr"      
      set bank_dda_no                 "$acctnbr"      
      set location_type               ""      
      set photo                       ""      
      set dob                         ""      
      set fulfillment_house_used      ""      
      set delivery_methods            ""      
      set form__of_id                 ""      
      set business_description        ""      
      set charging_policy             ""      
      set refund_policy               ""      
      set sufficient_inventory        ""      
      set mc_vs_decals_visible        ""      
      set business_o_and_o            ""      
      set delivery_time_of_sale       ""      
      set sales_phone_no              ""      
      set sales_signing_rep           ""      
      set sales_chain_id              ""      
      set amex_category_code          ""      
      set visa_mc_category_code       "$entity(DEFAULT_MCC)"      
      set irs_category_code           ""      
      set application_fee             ""      
      set retrieval_fee               "$rr"      
      set help_desk_fee               ""      
      set visa_mid                    ""      
      set gross_vs_net                "$type"      
      set daily_vs_monthly            "$freq"      
      set interchange_plus            "$bill_type"      
      set pti_credit_disc             "$discount"      
      set gov_comp_fee                "$govcomp"      
      set roll_res_perc               "$rsrv_percent"      
      set roll_res_lot                ""      
      set roll_res_amt                ""      
      set billing_descriptor          ""      
      set type_of_id_info             ""      
      set interchange_fee_give_back   "$intchg_refund"      
      set roll_reserve                "$rsrv"      
      set tokenization_fee            ""      
      set sales_number                ""      
      set avs_fee                     "$avs"    
      set cvv2_fee                    "$cvv"    
      set bi_annual_fee               ""    
      set capture_mode                ""      
      set build_terminal_load         ""      
      set terminal_description        ""   
    
   puts $out_file_ptr "$merchant_id;$irs_tax_id_type;$irs_tax_id_no;$legal_business_name;$dba;$mailing_address;$mailing_city;$mailing_state;$mailing_zip;$billing_address;$billing_city;$billing_state;$billing_zip;$business_phone;$business_fax;$email;$url;$location_address;$location_city;$location_state;$location_zip;$location_country;$contact_first_name;$contact_last_name;$contact_phone;$contact_fax;$business_open_date;$length_of_ownership;$no_locations;$avg_ticket_amount;$ave_month_volume;$high_ticket_amount;$type_of_business;$type_of_sale;$site_inspection;$high_month_volume;$swiped_perc;$keyed_imprint_perc;$keyed_noimprint_perc;$face_to_face_perc;$mail_order_perc;$tel_order_perc;$internet_perc;$ownership_type;$fed_tid;$owner1_first_name;$owner1_last_name;$owner1_title;$owner1_ownership_perc;$owner1_home_address;$owner1_home_city;$owner1_home_state;$owner1_home_zip;$owner1_social_securrity_no;$owner1_home_phone;$owner1_dob;$owner2_first_name;$owner2_last_name;$owner2_title;$owner2_ownership_perc;$owner2_home_address;$owner2_home_city;$owner2_home_state;$owner2_home_zip;$owner2_social_securrity_no;$owner2_home_phone;$owner2_dob;$trade_reference1;$trade_reference1_contact;$trade_reference1_account_no;$trade_reference1_phone;$trade_reference2;$trade_reference2_contact;$trade_reference2_phone;$trade_reference2_account_no;$own_other_business;$processing;$bankcard_terminated;$amex;$amex_discount_rate;$amex_flat_fee;$amex_retail;$amex_trans_fee;$amex_services_trans_fee;$amex_annual_charge_volume;$amex_avg_ticket;$amex_monthly_gross_pay;$amex_daily_gross_pay;$amex_pay_frequency;$amex_no;$discover_no;$jcb_no;$check_guar;$check_guar_co;$check_guar_method;$ecr_software_internet_type;$terminal_type;$type_of_printer;$type_of_pin_pad;$tip_line_required;$auto_batch;$manual_imprinter;$business_type;$mc_qcr1_disc;$mc_qcr1_trans;$mc_qcr2_disc;$mc_qcr2_trans;$mc_qcr3_disc;$mc_qcr3_trans;$mc_qcr4_disc;$mc_qcr4_trans;$mc_qcr5_disc;$mc_qcr5_trans;$vs_qcr1_disc;$vs_qcr1_trans;$vs_qcr2_disc;$vs_qcr2_trans;$vs_qcr3_disc;$vs_qcr3_trans;$vs_qcr4_disc;$vs_qcr4_trans;$vs_qcr5_disc;$vs_qcr5_trans;$disc_qcr1_disc;$disc_qcr1_trans;$disc_qcr2_disc;$disc_qcr2_trans;$disc_qcr3_disc;$disc_qcr3_trans;$disc_qcr4_disc;$disc_qcr4_trans;$disc_qcr5_disc;$disc_qcr5_trans;$pti_credit_trans;$pti_debit_disc;$pti_debit_trans;$ach_fee;$amex_auth_fee;$debit_atm_fee;$discover_auth_fee ;$mc_vs_auth_fee ;$voice_auth_fee;$jcb_auth_fee;$ach_reject_fee ;$annual_fee;$chargeback_fee ;$merchant_club_fee;$early_cancelation_fee;$pci_non_compliance_fee;$min_monthly_disc_fee;$monthly_gateway_fee;$statement_fee;$online_merchant_portal;$bank_phone;$bank_name;$bank_transit_number;$bank_dda_no;$location_type;$photo;$dob;$fulfillment_house_used;$delivery_methods;$form__of_id;$business_description;$charging_policy;$refund_policy;$sufficient_inventory;$mc_vs_decals_visible;$business_o_and_o;$delivery_time_of_sale;$sales_phone_no;$sales_signing_rep;$sales_chain_id;$amex_category_code;$visa_mc_category_code;$irs_category_code;$application_fee;$retrieval_fee ;$help_desk_fee;$visa_mid;$gross_vs_net;$daily_vs_monthly;$interchange_plus;$pti_credit_disc;$gov_comp_fee;$roll_res_perc;$roll_res_lot;$roll_res_amt;$billing_descriptor;$type_of_id_info;$interchange_fee_give_back;$roll_reserve;$tokenization_fee;$sales_number;$avs_fee ;$cvv2_fee  ;$bi_annual_fee;$capture_mode;$build_terminal_load;$terminal_description"


   }; # end of main while loop

   close $out_file_ptr
}

##########
## MAIN ##
##########

readCfgFile db_params.cfg
initDB
getMerchInfo
exit

