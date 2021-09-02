#!/usr/bin/tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: pin_debit_load.tcl 4580 2018-05-25 06:53:37Z millig $
# $Rev: 4580 $
################################################################################
#
# File Name:  pin_debit_load.tcl
#
# Description:  This script moves daily PIN debit transactions from the
#               authorization settlement to the tranhistory table.  It then
#               loads the transactions into the in_draft_pin_debit table for
#               further processing.
#
# Script Arguments:  -c = Configuration file name.  Required.  No default.
#                    -d = Run date (e.g., YYYYMMDD).  Required.  No default.
#                         Defaults to current date.
#                    -l = Log file name.  Required.  No default.
#
# Output:  Confirmation emails to configured parties.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################
package require Oratcl

#System variables
set box $env(SYS_BOX)
set ath_db $env(ATH_DB)
set ath_db_username $env(ATH_DB_USERNAME)
set ath_db_password $env(ATH_DB_PASSWORD)
set clr_db $env(IST_DB)
set clr_db_username $env(IST_DB_USERNAME)
set clr_db_password $env(IST_DB_PASSWORD)
set sysinfo "System: $box\n Location: $env(PWD) \n\n"

#Global variables
global argv


######################################
# Jobs Times Table Globals - NPP-7450
######################################
set job_script_name "pin_debit_load.tcl"
set job_source "SETTLEMENT"
set job_dest "TRANHISTORY"
set job_id_seq_gen_name "SEQ_JOB_EVENT_REC_ID"
set tran_id_seq_gen_name "SEQ_TRAN_EVENT_REC_ID"



################################################################################
#
# Procedure Name:  init_program
#
# Description:     Initialize program arguments
# Error Return:    1 [Script error]
#
################################################################################
proc init_program {} {
   global argv
   global pin_debit_load_dict

   set pin_debit_load_dict [dict create]
   set num_script_args [lindex $argv 0]
   set i 1

   while {$i < $num_script_args} {
      set script_arg [string range [string trim [lindex $argv $i]] 1 1]
      set script_arg_val [string range [lindex $argv $i] 2 end]

      switch $script_arg {
         "c"     {if {[string length $script_arg_val] != 0} {
                     set cfg_filename "cfg_filename"
                     dict set pin_debit_load_dict $cfg_filename $script_arg_val
                  } else {
                     puts stdout "Configuration file full path name must be specified with the -c option"
                     exit 1
                  }}
         "d"     {if {[string length $script_arg_val] != 0} {
                     set current_date $script_arg_val
                     set run_file_date "run_file_date"
                     dict set pin_debit_load_dict $run_file_date $script_arg_val
                  } else {
                     set current_date "[clock format [clock seconds] -format "%Y%m%d"]"
                     set run_file_date "run_file_date"
                     dict set pin_debit_load_dict $run_file_date $current_date
                  }}
         "l"     {if {[string length $script_arg_val] != 0} {
                     set log_filename "log_filename"
                     dict set pin_debit_load_dict $log_filename $script_arg_val
                  } else {
                     puts stdout "Log file full path name must be specified with the -l option"
                     exit 1
                  }}
         default {puts stdout "$script_arg is an invalid script argument for this program"
                  exit 1
                 }
      }
      set i [incr $i]
   }

   if {$i != $num_script_args} {
      puts stdout "Number of script arguments evaluted ($i) does not equal number of expected script arguments ($num_script_args)"
      exit 1
   }

};# end init_program


################################################################################
#
# Procedure Name:  open_log_file
#
# Description:     Opens the log file for this program
# Error Return:    21 [Log file cannot be opened]
#
################################################################################
proc open_log_file {} {

   global pin_debit_load_dict

   set log_filename [dict get $pin_debit_load_dict log_filename]

   if {[catch {open $log_filename a} file_ptr]} {
      write_log_message "Cannot open file $log_filename for logging."
      exit 21
   }

   set log_file_ptr "log_file_ptr"
   dict set pin_debit_load_dict $log_file_ptr $file_ptr

};# end open_log_file


################################################################################
#
# Procedure Name:  read_cfg_file
#
# Description:     Obtains the configuration parameters for the program
# Error Return:    11 [Config file cannot be opened]
#                  13 [Config file cannot be closed]
#
################################################################################
proc read_cfg_file {} {

   global pin_debit_load_dict

   set cfg_filename [dict get $pin_debit_load_dict cfg_filename]

   if {[catch {open $cfg_filename r} file_ptr]} {
       write_log_message "Cannot open file $cfg_filename for configurations."
       exit 11
   }

   while {[set line_in [gets $file_ptr]] != {} } {
      set key [lindex [split $line_in ,] 0]
      set val [lindex [split $line_in ,] 1]
      dict set pin_debit_load_dict [string tolower $key] $val
   }

   if {[catch {close $file_ptr} response]} {
      write_log_message "Cannot close file $cfg_filename."
      exit 13
   }

};# end read_cfg_file


################################################################################
# Procedure Name:  write_log_message
#
# Description:     Writes a message to the log file for this program
# Error Return:    None
#
################################################################################
proc write_log_message {log_msg_text} {

   global pin_debit_load_dict

   set log_file_ptr [dict get $pin_debit_load_dict log_file_ptr]

   if { [catch {puts $log_file_ptr "[clock format [clock seconds] -format "%D %T"] $log_msg_text"} ]} {
      write_log_message "[clock format [clock seconds] -format "%D %T"] $log_msg_text"
   }

};# end write_log_message

################################################################################
# Procedure Name:  debug_mode
#
# Description:     Writes a message to the log file for this program
#                  Same as write_log_message. Only purpose is to make add and remove
#                  logging easier for debugging purpose
# Error Return:    None
#
################################################################################
proc debug_mode {log_msg_text} {

   global pin_debit_load_dict

   set log_file_ptr [dict get $pin_debit_load_dict log_file_ptr]

   if { [catch {puts $log_file_ptr "[clock format [clock seconds] -format "%D %T"] $log_msg_text"} ]} {
      write_log_message "[clock format [clock seconds] -format "%D %T"] $log_msg_text"
   }

};# end debug_mode


################################################################################
#
# Procedure Name:  open_db
#
# Description:     Connects to the database and open tables used by the program;
#                  A maximum of 25 table cursors may be opened per logon handle
# Error Return:    50 [Database connection failed]
#                  51 [Database table cursor failed]
#
################################################################################
proc open_db {} {

   global ath_db
   global ath_db_username
   global ath_db_password
   global clr_db
   global clr_db_username
   global clr_db_password
   global pin_debit_load_dict
   global jte_job_id_crsr
   global jte_job_insert_crsr
   global jte_job_update_crsr
   global jte_tran_insert_crsr
   global jte_trans_other4_crsr

   #
   # Connect to the Auth database
   #
   if {[catch {set db_logon_handle [oralogon $ath_db_username/$ath_db_password@$ath_db]} ora_result] } {
      puts "Encountered error $ora_result while trying to connect to the $ath_db database"
      exit 50
   }
   set ath_db_logon_handle "ath_db_logon_handle"
   dict set pin_debit_load_dict $ath_db_logon_handle $db_logon_handle

   # Jobs Times Table Cursors for Auth Database - NPP-7450
   set jte_job_id_crsr        [oraopen $db_logon_handle]
   set jte_job_insert_crsr    [oraopen $db_logon_handle]
   set jte_job_update_crsr    [oraopen $db_logon_handle]
   set jte_tran_insert_crsr   [oraopen $db_logon_handle]
   set jte_trans_other4_crsr  [oraopen $db_logon_handle]

   #
   # Open auth_addenda table cursor
   #
   if {[catch {set table_cursor [oraopen $db_logon_handle]} ora_result]} {
      puts "Encountered error $ora_result while trying to create auth_addenda cursor handle"
      exit 51
   }
   set auth_addenda_cursor "auth_addenda_cursor"
   dict set pin_debit_load_dict $auth_addenda_cursor $table_cursor

   #
   # Open encryption_addenda table cursor
   #
   if {[catch {set table_cursor [oraopen $db_logon_handle]} ora_result]} {
      puts "Encountered error $ora_result while trying to create encryption_addenda cursor handle"
      exit 51
   }
   set encryption_addenda_cursor "encryption_addenda_cursor"
   dict set pin_debit_load_dict $encryption_addenda_cursor $table_cursor

   #
   # Open merchant table cursor
   #
   if {[catch {set table_cursor [oraopen $db_logon_handle]} ora_result]} {
      puts "Encountered error $ora_result while trying to create merchant cursor handle"
      exit 51
   }
   set merchant_cursor "merchant_cursor"
   dict set pin_debit_load_dict $merchant_cursor $table_cursor

   #
   # Open settlement table cursor
   #
   if {[catch {set table_cursor [oraopen $db_logon_handle]} ora_result]} {
      puts "Encountered error $ora_result while trying to create settlement cursor handle"
      exit 51
   }
   set settlement_cursor "settlement_cursor"
   dict set pin_debit_load_dict $settlement_cursor $table_cursor

   #
   # Open settlement table deletion cursor
   #
   if {[catch {set table_cursor [oraopen $db_logon_handle]} ora_result]} {
      puts "Encountered error $ora_result while trying to create settlement deletion cursor handle"
      exit 51
   }
   set settlement_delete_cursor "settlement_delete_cursor"
   dict set pin_debit_load_dict $settlement_delete_cursor $table_cursor

   #
   # Open tranhistory table cursor
   #
   if {[catch {set table_cursor [oraopen $db_logon_handle]} ora_result]} {
      puts "Encountered error $ora_result while trying to create tranhistory cursor handle"
      exit 51
   }
   set tranhistory_cursor "tranhistory_cursor"
   dict set pin_debit_load_dict $tranhistory_cursor $table_cursor

   #
   # Connect to the Clearing database
   #
   if {[catch {set db_logon_handle [oralogon $clr_db_username/$clr_db_password@$clr_db]} ora_result] } {
      puts "Encountered error $ora_result while trying to connect to the $clr_db database"
      exit 50
   }
   set clr_db_logon_handle "clr_db_logon_handle"
   dict set pin_debit_load_dict $clr_db_logon_handle $db_logon_handle

   #
   # Open acq_entity_add_on table cursor
   #
   if {[catch {set table_cursor [oraopen $db_logon_handle]} ora_result]} {
      puts "Encountered error $ora_result while trying to create acq_entity_add_on cursor handle"
      exit 51
   }
   set acq_entity_add_on_cursor "acq_entity_add_on_cursor"
   dict set pin_debit_load_dict $acq_entity_add_on_cursor $table_cursor

   #
   # Open bin table cursor
   #
   if {[catch {set table_cursor [oraopen $db_logon_handle]} ora_result]} {
      puts "Encountered error $ora_result while trying to create bin cursor handle"
      exit 51
   }
   set bin_cursor "bin_cursor"
   dict set pin_debit_load_dict $bin_cursor $table_cursor

   #
   # Open currency_code table cursor
   #
   if {[catch {set table_cursor [oraopen $db_logon_handle]} ora_result]} {
      puts "Encountered error $ora_result while trying to create currency_code cursor handle"
      exit 51
   }
   set currency_code_cursor "currency_code_cursor"
   dict set pin_debit_load_dict $currency_code_cursor $table_cursor

   #
   # Open entity_to_auth table cursor
   #
   if {[catch {set table_cursor [oraopen $db_logon_handle]} ora_result]} {
      puts "Encountered error $ora_result while trying to create entity_to_auth cursor handle"
      exit 51
   }
   set entity_to_auth_cursor "entity_to_auth_cursor"
   dict set pin_debit_load_dict $entity_to_auth_cursor $table_cursor

   #
   # Open global_seq_ctrl table cursor
   #
   if {[catch {set table_cursor [oraopen $db_logon_handle]} ora_result]} {
      puts "Encountered error $ora_result while trying to create global_seq_ctrl cursor handle"
      exit 51
   }
   set global_seq_ctrl_cursor "global_seq_ctrl_cursor"
   dict set pin_debit_load_dict $global_seq_ctrl_cursor $table_cursor

   #
   # Open in_draft_pin_debit table cursor
   #
   if {[catch {set table_cursor [oraopen $db_logon_handle]} ora_result]} {
      puts "Encountered error $ora_result while trying to create in_draft_pin_debit cursor handle"
      exit 51
   }
   set in_draft_pin_debit_cursor "in_draft_pin_debit_cursor"
   dict set pin_debit_load_dict $in_draft_pin_debit_cursor $table_cursor

   #
   # Open mbr_bin table cursor
   #
   if {[catch {set table_cursor [oraopen $db_logon_handle]} ora_result]} {
      puts "Encountered error $ora_result while trying to create mbr_bin cursor handle"
      exit 51
   }
   set mbr_bin_cursor "mbr_bin_cursor"
   dict set pin_debit_load_dict $mbr_bin_cursor $table_cursor

   #
   # Open pin_debit_fee_qual table cursor
   #
   if {[catch {set table_cursor [oraopen $db_logon_handle]} ora_result]} {
      puts "Encountered error $ora_result while trying to create pin_debit_fee_qual cursor handle"
      exit 51
   }
   set pin_debit_fee_qual_cursor "pin_debit_fee_qual_cursor"
   dict set pin_debit_load_dict $pin_debit_fee_qual_cursor $table_cursor

   #
   # Open visa_reg_ardef table cursor
   #
   if {[catch {set table_cursor [oraopen $db_logon_handle]} ora_result]} {
      puts "Encountered error $ora_result while trying to create visa_reg_ardef cursor handle"
      exit 51
   }
   set visa_reg_ardef_cursor "visa_reg_ardef_cursor"
   dict set pin_debit_load_dict visa_reg_ardef_cursor $table_cursor



};# end open_db


##############################################################################
#
# Procedure Name:  determine_pos_cond
#
# Description:     Determine the POS condition code:
#                    I --> Internet
#                    * --> Default
# Error Return:    None
#
################################################################################
proc determine_pos_cond {pos_entry transaction_type market_type} {

   global pin_debit_load_dict

   #
   # Set POS condition for ecommerce transactions
   #
   # Auth DE 2 [subfield 1] Values:
   #   00 -> PAN entry mode unknown [default]
   #   01 -> PAN manual entry
   #   02 -> PAN auto-entry via magnetic stripe-track data is not required OR
   #         The acquirer is not qualified to submit magnetic stripe transactions, so MasterCard
   #         replaced value 90 or 91 with value 02.
   #   03 -> PAN auto-entry via bar code reader
   #   04 -> PAN auto-entry via optical character reader (OCR)
   #   05 -> PAN auto-entry via chip
   #   07 -> PAN auto-entry via contactless M/Chip
   #   08 -> PAN auto-entry via contactless M/Chip Contactless Mapping Service applied
   #   09 -> PAN entry via electronic commerce, including remote chip
   #   79 -> A hybrid terminal with an online connection to the acquirer failed in sending a chip
   #         fallback transaction (in which DE 22, subfield 1 = 80) to the issuer OR
   #         a hybrid terminal with no online connection to the acquirer failed to read the chip card.
   #         The merchant is prompted to read the magnetic stripe from the card, the magstripe is
   #         successfully read and indicates a service code 2XX (or 6XX if card is domestic).
   #         To complete the transaction in both cases, a voice transaction takes place during which
   #         the merchant communicates the PAN and the expiry date originating from the magstripe
   #         track 2 data to the acquirer. The acquirer then sends an online transaction to the issuer in
   #         which the value of DE 22, subfield 1 = 79 and in which DE 61 subfield 11 indicate that
   #         the terminal is chip capable.
   #   80 -> Chip card at chip-capable terminal was unable to process transaction using data on the
   #         chip; therefore, the terminal defaulted to the magnetic stripe-read PAN. The full track
   #         data has been read from the data encoded on the card and transmitted within the
   #         Authorization Request/0100 in DE 45 (Track 1 Data) or DE 35 (Track 2 Data) without
   #         alteration or truncation. To use this value, the acquirer must be qualified to use value 90.
   #   81 -> PAN entry via electronic commerce, including chip.
   #   82 -> PAN Auto Entry via Server (issuer, acquirer, or third party vendor system). This value will
   #         also be sent to issuers when a MasterCard Digital Enablement Service token was used to
   #         initiate the transaction and acquirer DE 22, subfield 1 = 07 or 91.
   #   90 -> PAN auto-entry via magnetic stripe-the full track data has been read from the data
   #         encoded on the card and transmitted within the authorization request in DE 35 (Track 2
   #         Data) or DE 45 (Track 1 Data) without alteration or truncation.
   #   91 -> PAN auto-entry via contactless magnetic stripe-the full track data has been read from
   #         the data on the card and transmitted within the authorization request in DE 35 (Track 2
   #         Data) or DE 45 (Track 1 Data) without alteration or truncation.
   #   95 -> Visa only. Chip card with unreliable Card Verification Value (CVV) data.
   #
   # Clearing IPM Values:
   #   0 -> Unspecified; data unavailable [default]
   #   1 -> Manual input; no terminal
   #   2 -> Magnetic stripe reader input
   #   6 -> Key entered input
   #   A -> PAN auto-entry via contactless magnetic stripe
   #   B -> Magnetic stripe reader input; track data captured and passed unaltered
   #   C -> Online Chip
   #   F -> Offline Chip
   #   M -> PAN auto-entry via contactless M/Chip
   #   N -> Contactless input, PAN Mapping Service applied
   #        (This value is visible only to issuers; acquirers use value A or M.)
   #   O -> PAN entry via electronic commerce, including remote chip, MasterCard Digital Enablement Service applied
   #        (This value is visible only to issuers; acquirers use value R.)
   #   R -> PAN entry via electronic commerce, including remote chip
   #   S -> Electronic commerce
   #   T -> PAN auto entry via server (issuer, acquirer, or third party vendor system)
   #   V -> Electronic commerce or PAN auto entry via server, Card on File service applied
   #
   # JetPay Mappings:  note -- (V is not supported by FIS)
   #   0 -> transaction_type I -> S [Electronic commerce]
   #     -> transaction_type M -> 1 [Manual input; no terminal]
   #     -> transaction_type R -> 6 [Key entered input]
   #     -> transaction_type T -> 1 [Manual input; no terminal]
   #     -> transaction_type U -> S [Electronic commerce]
   #                           -> 0 [Unspecified; data unavailable]
   #     -> transaction_type Y -> S [Electronic commerce]
   #   1 -> B [Magnetic stripe reader input; track data captured and passed unaltered]
   #   2 -> B [Magnetic stripe reader input; track data captured and passed unaltered]
   #   4 -> C [Online Chip]
   #   7 -> transaction_type I -> R [PAN entry via electronic commerce, including remote chip]
   #     -> transaction_type Y -> R [PAN entry via electronic commerce, including remote chip]
   #     -> transaction_type <> I -> M [PAN auto-entry via contactless M/Chip]
   #   9 -> A [PAN auto-entry via contactless magnetic stripe]
   #
   switch $pos_entry {
      "0"       {switch $transaction_type {
                   "I"     {set pos_cond "I"}
                   "M"     {set pos_cond "I"}
                   "R"     {set pos_cond "*"}
                   "T"     {set pos_cond "*"}
                   "U"     {if {$market_type == "I"} {
                               set pos_cond "I"
                            } else {
                               set pos_cond "*"
                            }}
                   "Y"     {set pos_cond "I"}
                   default {set pos_cond "*"}
                }}
      "1"       {set pos_cond "*"}
      "2"       {set pos_cond "*"}
      "3"       {set pos_cond "*"}
      "4"       {set pos_cond "I"}
      "5"       {set pos_cond "I"}
      "7"       {switch $transaction_type {
                   "I"     {set pos_cond "I"}
                   "Y"     {set pos_cond "I"}
                   default {set pos_cond "*"}
                }}
      "8"       {set pos_cond "*"}
      "9"       {set pos_cond "*"}
      "79"      {set pos_cond "*"}
      "80"      {set pos_cond "*"}
      "81"      {set pos_cond "I"}
      "82"      {set pos_cond "*"}
      "90"      {set pos_cond "*"}
      "91"      {set pos_cond "*"}
      "95"      {set pos_cond "I"}
      default   {set pos_cond "*"}
   }


   return $pos_cond

};# determine_pos_cond


##############################################################################
#
# Procedure Name:  assign_accel_exchange_mas_code
#
# Description:     Determine the Accel/Exchange MAS code
# Error Return:    None
#
################################################################################
proc assign_accel_exchange_mas_code {network_id tid amt_trans pos_entry transaction_type market_type card_present mcc tier_ind intl_ind regulated_rate_ind iss_product_id iss_card_product_type pin_used card_scheme_var_value} {

   global pin_debit_load_dict

   #
   # Determine POS condition
   #

   set pos_cond_support_accel [dict get $pin_debit_load_dict pos_cond_support_accel]

   if {$pos_cond_support_accel == "Y"} {
      set pos_cond [determine_pos_cond $pos_entry $transaction_type $market_type]
   } else {
      set pos_cond "*"
   }

   #
   # assess pin_used:  if pin_used = N then add a P to the POS condition
   #
   if {$pin_used == "N"} {
      append pos_cond "P"
   }


   #
   # Determine small ticket eligibility
   #
   set smtkt_limit_accel [dict get $pin_debit_load_dict smtkt_limit_accel]

   if {$amt_trans >= $smtkt_limit_accel} {
      set smltkt_ind "N"
   } else {
      set smltkt_ind "Y"
   }

   #
   # Determine issuer card arrangement
   #
   # A --> Assurance
   # M --> Member Advantage
   # S --> Standard
   # X --> Special
   #
   # Note:  Currently not fully supported
   #
   switch $card_scheme_var_value {
      "04"        {set iss_card_arrangement "S1"
                  }
      "08"        {set iss_card_arrangement "S3"
                  }
      default     {set iss_card_arrangement "S2"
                  }
   }

   #
   # Determine issuer card product type
   #
   set iss_card_product_type "D"

   #
   # Determine tier level
   #
   # Note:  Currently not fully supported
   #
   if {($regulated_rate_ind == "N") && ($tier_ind != "")} {
      set tier_level $tier_ind
   } else {
      set tier_level "*"
   }

   #
   # Obtain the MAS code
   #
   set default_mas_code_accel [dict get $pin_debit_load_dict default_mas_code_accel]
   set mas_code [determine_mas_code $network_id $mcc $tid $iss_card_arrangement $iss_card_product_type $pos_cond $regulated_rate_ind $smltkt_ind $tier_level $default_mas_code_accel]

   return $mas_code

};# assign_accel_exchange_mas_code


##############################################################################
#
# Procedure Name:  assign_affn_mas_code
#
# Description:     Assign the AFFN MAS code
# Error Return:    None
#
################################################################################
proc assign_affn_mas_code {network_id tid amt_trans pos_entry transaction_type market_type card_present mcc tier_ind intl_ind regulated_rate_ind iss_product_id iss_card_product_type} {

   global pin_debit_load_dict

   #
   # Determine POS condition
   #
   set pos_cond_support_affn [dict get $pin_debit_load_dict pos_cond_support_affn]

   if {$pos_cond_support_affn == "Y"} {
      set pos_cond [determine_pos_cond $pos_entry $transaction_type $market_type]
   } else {
      set pos_cond "*"
   }

   #
   # Determine small ticket eligibility
   #
   set smtkt_limit_affn [dict get $pin_debit_load_dict smtkt_limit_affn]

   if {$amt_trans >= $smtkt_limit_affn} {
      set smltkt_ind "N"
   } else {
      set smltkt_ind "Y"
   }

   #
   # Determine issuer card arrangement
   #
   # S --> Standard
   #
   set iss_card_arrangement "S"

   #
   # Determine issuer card product type
   #
   set iss_card_product_type "D"

   #
   # Determine tier level
   #
   set tier_level "*"

   #
   # Obtain the MAS code
   #
   set default_mas_code_affn [dict get $pin_debit_load_dict default_mas_code_affn]
   set mas_code [determine_mas_code $network_id $mcc $tid $iss_card_arrangement $iss_card_product_type $pos_cond $regulated_rate_ind $smltkt_ind $tier_level $default_mas_code_affn]

   return $mas_code

};# assign_affn_mas_code


##############################################################################
#
# Procedure Name:  assign_cu24_mas_code
#
# Description:     Assign the CU24 MAS code
# Error Return:    None
#
################################################################################
proc assign_cu24_mas_code {network_id tid amt_trans pos_entry transaction_type market_type card_present mcc tier_ind intl_ind regulated_rate_ind iss_product_id iss_card_product_type} {

   global pin_debit_load_dict

   #
   # Determine POS condition
   #
   set pos_cond_support_cu24 [dict get $pin_debit_load_dict pos_cond_support_cu24]

   if {$pos_cond_support_cu24 == "Y"} {
      set pos_cond [determine_pos_cond $pos_entry $transaction_type $market_type]
   } else {
      set pos_cond "*"
   }

   #
   # Determine small ticket eligibility
   #
   set smtkt_limit_cu24 [dict get $pin_debit_load_dict smtkt_limit_cu24]

   if {$amt_trans >= $smtkt_limit_cu24} {
      set smltkt_ind "N"
   } else {
      set smltkt_ind "Y"
   }

   #
   # Determine issuer card arrangement
   #
   # S --> Standard
   #
   set iss_card_arrangement "S"

   #
   # Determine issuer card product type
   #
   set iss_card_product_type "D"

   #
   # Determine tier level
   #
   # Note:  Currently not fully supported
   #
   if {(($mcc == "5541") ||
        ($mcc == "5542") ||
        ($mcc == "7511") ||
        ($mcc == "5812") ||
        ($mcc == "5814") ||
        ($mcc == "5300") ||
        ($mcc == "5411") ||
        ($regulated_rate_ind == "N")) && ($tier_ind != "")} {
      set tier_level $tier_ind
   } else {
      set tier_level "*"
   }

   #
   # Obtain the MAS code
   #
   set default_mas_code_cu24 [dict get $pin_debit_load_dict default_mas_code_cu24]
   set mas_code [determine_mas_code $network_id $mcc $tid $iss_card_arrangement $iss_card_product_type $pos_cond $regulated_rate_ind $smltkt_ind $tier_level $default_mas_code_cu24]

   return $mas_code

};# assign_cu24_mas_code


##############################################################################
#
# Procedure Name:  assign_ebt_mas_code
#
# Description:     Assign the EBT MAS code
# Error Return:    None
#
################################################################################
proc assign_ebt_mas_code {network_id tid amt_trans pos_entry transaction_type market_type card_present mcc tier_ind intl_ind regulated_rate_ind iss_product_id iss_card_product_type ebt_type} {

   global pin_debit_load_dict

   #
   # Determine POS condition
   #
   set pos_cond_support_ebt [dict get $pin_debit_load_dict pos_cond_support_ebt]

   if {$pos_cond_support_ebt == "Y"} {
      set pos_cond [determine_pos_cond $pos_entry $transaction_type $market_type]
   } else {
      set pos_cond "*"
   }

   #
   # Determine small ticket eligibility
   #
   set smtkt_limit_ebt [dict get $pin_debit_load_dict smtkt_limit_ebt]

   if {$amt_trans >= $smtkt_limit_ebt} {
      set smltkt_ind "N"
   } else {
      set smltkt_ind "Y"
   }

   #
   # Determine issuer card arrangement
   #
   # S --> Standard
   #
   set iss_card_arrangement "S"

   #
   # Determine issuer card product type
   #
   set iss_card_product_type "D"

   #
   # Determine tier level
   #
   set tier_level "*"

   #
   # Obtain the MAS code
   #
   set default_mas_code_ebt [dict get $pin_debit_load_dict default_mas_code_ebt]
   set mas_code [determine_mas_code $network_id $mcc $tid $iss_card_arrangement $iss_card_product_type $pos_cond $regulated_rate_ind $smltkt_ind $tier_level $default_mas_code_ebt]

         if { $ebt_type != "" } {
             switch $ebt_type {
             "F"     {set mas_code "0102EBTFOOD"}
             "C"     {set mas_code "0102EBTCASHBACK"}
             "V"     {set mas_code "0102EBTVOUCHER"}
             }
         }
   return $mas_code

};# assign_ebt_mas_code


##############################################################################
#
# Procedure Name:  assign_interac_mas_code
#
# Description:     Assign the Interac MAS code
# Error Return:    None
#
################################################################################
proc assign_interac_mas_code {network_id tid amt_trans pos_entry transaction_type market_type card_present mcc tier_ind intl_ind regulated_rate_ind iss_product_id iss_card_product_type} {

   global pin_debit_load_dict

   #
   # Determine POS condition
   #
   set pos_cond_support_interac [dict get $pin_debit_load_dict pos_cond_support_interac]

   if {$pos_cond_support_interac == "Y"} {
      set pos_cond [determine_pos_cond $pos_entry $transaction_type $market_type]
   } else {
      set pos_cond "*"
   }

   #
   # Determine small ticket eligibility
   #
   set smtkt_limit_interac [dict get $pin_debit_load_dict smtkt_limit_interac]

   if {$amt_trans >= $smtkt_limit_interac} {
      set smltkt_ind "N"
   } else {
      set smltkt_ind "Y"
   }

   #
   # Determine issuer card arrangement
   #
   # S --> Standard
   #
   set iss_card_arrangement "S"

   #
   # Determine issuer card product type
   #
   set iss_card_product_type "D"

   #
   # Determine tier level
   #
   set tier_level "*"

   #
   # Obtain the MAS code
   #
   set default_mas_code_interac [dict get $pin_debit_load_dict default_mas_code_interac]
   set mas_code [determine_mas_code $network_id $mcc $tid $iss_card_arrangement $iss_card_product_type $pos_cond $regulated_rate_ind $smltkt_ind $tier_level $default_mas_code_interac]

   return $mas_code

};# assign_interac_mas_code


##############################################################################
#
# Procedure Name:  assign_interlink_mas_code
#
# Description:     Assign the Interlink MAS code
# Error Return:    None
#
################################################################################
proc assign_interlink_mas_code {network_id tid amt_trans pos_entry transaction_type market_type card_present mcc tier_ind intl_ind regulated_rate_ind iss_product_id iss_card_product_type} {

   global pin_debit_load_dict

   #
   # Determine POS condition
   #
   set pos_cond_support_intlk [dict get $pin_debit_load_dict pos_cond_support_intlk]

   if {$pos_cond_support_intlk == "Y"} {
      set pos_cond [determine_pos_cond $pos_entry $transaction_type $market_type]
   } else {
      set pos_cond "*"
   }

   #
   # Determine small ticket eligibility
   #
   set smtkt_limit_intlk [dict get $pin_debit_load_dict smtkt_limit_intlk]

   if {$amt_trans >= $smtkt_limit_intlk} {
      set smltkt_ind "N"
   } else {
      set smltkt_ind "Y"
   }

   #
   # Determine issuer card arrangement
   #
   # B --> Business
   # C --> Consumer
   # M --> Commercial Prepaid
   #
   set iss_card_arrangement "C"
   set card_product_business_list [dict get $pin_debit_load_dict card_product_business_list]
   set card_product_corp_list [dict get $pin_debit_load_dict card_product_corp_list]
   set card_product_fleet [dict get $pin_debit_load_dict card_product_fleet]
   set card_product_purch_list [dict get $pin_debit_load_dict card_product_purch_list]
   set card_product_comm_list [dict get $pin_debit_load_dict card_product_comm_list]

   if {$regulated_rate_ind == "N"} {
      if {[lsearch -exact $card_product_business_list $iss_product_id] == 0 ||
          [lsearch -exact $card_product_corp_list $iss_product_id] == 0     ||
          [lsearch -exact $card_product_fleet $iss_product_id] == 0         ||
          [lsearch -exact $card_product_purch_list $iss_product_id] == 0} {
         set iss_card_arrangement "B"
      } elseif {[lsearch $card_product_comm_list $iss_product_id] == 0} {
         if {($iss_card_product_type == "P")} {
            set iss_card_arrangement "M"
         } else {
            set iss_card_arrangement "B"
         }
      } else {
         set iss_card_arrangement "C"
      }
   }

   #
   # Determine issuer card product type
   #
   if {$iss_card_arrangement != "P"} {
      set iss_card_product_type "D"
   }

   #
   # Determine tier level
   #
   set tier_level "*"

   #
   # Obtain the MAS code
   #
   set default_mas_code_intlk [dict get $pin_debit_load_dict default_mas_code_intlk]
   set mas_code [determine_mas_code $network_id $mcc $tid $iss_card_arrangement $iss_card_product_type $pos_cond $regulated_rate_ind $smltkt_ind $tier_level $default_mas_code_intlk]

   return $mas_code

};# assign_interlink_mas_code


##############################################################################
#
# Procedure Name:  assign_maestro_mas_code
#
# Description:     Assign the Maestro MAS code
# Error Return:    None
#
################################################################################
proc assign_maestro_mas_code {network_id tid amt_trans pos_entry transaction_type market_type card_present mcc tier_ind intl_ind regulated_rate_ind iss_product_id iss_card_product_type} {

   global pin_debit_load_dict

   #
   # Determine POS condition
   #
   set pos_cond_support_maestro [dict get $pin_debit_load_dict pos_cond_support_maestro]

   if {$pos_cond_support_maestro == "Y"} {
      set pos_cond [determine_pos_cond $pos_entry $transaction_type $market_type]
   } else {
      set pos_cond "*"
   }

   #
   # Determine small ticket eligibility
   #
   set smtkt_limit_maestro [dict get $pin_debit_load_dict smtkt_limit_maestro]

   if {$amt_trans >= $smtkt_limit_maestro} {
      set smltkt_ind "N"
   } else {
      set smltkt_ind "Y"
   }

   #
   # Determine issuer card arrangement
   #
   # S --> Standard
   #
   set iss_card_arrangement "S"

   #
   # Determine issuer card product type
   #
   set iss_card_product_type "D"

   #
   # Determine tier level
   #
   # Note:  Currently not fully supported
   #
   if {(($mcc == "5499") ||
        ($mcc == "5814") ||
        ($mcc == "7832") ||
        ($mcc == "5300") ||
        ($mcc == "5411") ||
        ($regulated_rate_ind == "N")) && ($tier_ind != "")} {
      set tier_level $tier_ind
   } else {
      set tier_level "*"
   }

   #
   # Obtain the MAS code
   #
   set default_mas_code_maestro [dict get $pin_debit_load_dict default_mas_code_maestro]
   set mas_code [determine_mas_code $network_id $mcc $tid $iss_card_arrangement $iss_card_product_type $pos_cond $regulated_rate_ind $smltkt_ind $tier_level $default_mas_code_maestro]

   return $mas_code

};# assign_maestro_mas_code


##############################################################################
#
# Procedure Name:  assign_nets_mas_code
#
# Description:     Assign the NETS MAS code
# Error Return:    None
#
################################################################################
proc assign_nets_mas_code {network_id tid amt_trans pos_entry transaction_type market_type card_present mcc tier_ind intl_ind regulated_rate_ind iss_product_id iss_card_product_type} {

   global pin_debit_load_dict

   #
   # Determine POS condition
   #
   set pos_cond_support_nets [dict get $pin_debit_load_dict pos_cond_support_nets]

   if {$pos_cond_support_nets == "Y"} {
      set pos_cond [determine_pos_cond $pos_entry $transaction_type $market_type]
   } else {
      set pos_cond "*"
   }

   #
   # Determine small ticket eligibility
   #
   set smtkt_limit_nets [dict get $pin_debit_load_dict smtkt_limit_nets]

   if {$amt_trans >= $smtkt_limit_nets} {
      set smltkt_ind "N"
   } else {
      set smltkt_ind "Y"
   }

   #
   # Determine issuer card arrangement
   #
   # S --> Standard
   #
   set iss_card_arrangement "S"

   #
   # Determine issuer card product type
   #
   set iss_card_product_type "D"

   #
   # Determine tier level
   #
   set tier_level "*"

   #
   # Obtain the MAS code
   #
   set default_mas_code_nets [dict get $pin_debit_load_dict default_mas_code_nets]
   set mas_code [determine_mas_code $network_id $mcc $tid $iss_card_arrangement $iss_card_product_type $pos_cond $regulated_rate_ind $smltkt_ind $tier_level $default_mas_code_nets]

   return $mas_code

};# assign_nets_mas_code


##############################################################################
#
# Procedure Name:  assign_nyce_mas_code
#
# Description:     Assign the NYCE MAS code
# Error Return:    None
#
################################################################################
proc assign_nyce_mas_code {network_id tid amt_trans pos_entry transaction_type market_type card_present mcc tier_ind intl_ind regulated_rate_ind iss_product_id iss_card_product_type} {

   global pin_debit_load_dict

   #
   # Determine POS condition
   #
   set pos_cond_support_nyce [dict get $pin_debit_load_dict pos_cond_support_nyce]

   if {$pos_cond_support_nyce == "Y"} {
      set pos_cond [determine_pos_cond $pos_entry $transaction_type $market_type]
   } else {
      set pos_cond "*"
   }

   #
   # Determine small ticket eligibility
   #
   set smtkt_limit_nyce [dict get $pin_debit_load_dict smtkt_limit_nyce]

   if {$amt_trans >= $smtkt_limit_nyce} {
      set smltkt_ind "N"
   } else {
      set smltkt_ind "Y"
   }

   #
   # Determine issuer card arrangement
   #
   # P --> Premier
   # S --> Standard
   #
   # Note:  Currently not supported
   #
   set iss_card_arrangement "S"

   #
   # Determine issuer card product type
   #
   set iss_card_product_type "D"

   #
   # Determine tier level
   #
   # Note:  Currently not fully supported
   #
   if {(($iss_card_arrangement != "P") && ($regulated_rate_ind == "N")) && ($tier_ind != "")} {
      set tier_level $tier_ind
   } else {
      set tier_level "*"
   }

   #
   # Obtain the MAS code
   #
   set default_mas_code_nyce [dict get $pin_debit_load_dict default_mas_code_nyce]
   set mas_code [determine_mas_code $network_id $mcc $tid $iss_card_arrangement $iss_card_product_type $pos_cond $regulated_rate_ind $smltkt_ind $tier_level $default_mas_code_nyce]

   return $mas_code

};# assign_nyce_mas_code


##############################################################################
#
# Procedure Name:  assign_pulse_mas_code
#
# Description:     Assign the NYCE MAS code
# Error Return:    None
#
################################################################################
proc assign_pulse_mas_code {network_id tid amt_trans pos_entry transaction_type market_type card_present mcc tier_ind intl_ind regulated_rate_ind iss_product_id iss_card_product_type} {

   global pin_debit_load_dict

   #
   # Determine POS condition
   #
   set pos_cond_support_pulse [dict get $pin_debit_load_dict pos_cond_support_pulse]

   if {$pos_cond_support_pulse == "Y"} {
      set pos_cond [determine_pos_cond $pos_entry $transaction_type $market_type]
   } else {
      set pos_cond "*"
   }

   #
   # Determine small ticket eligibility
   #
   set smtkt_limit_pulse [dict get $pin_debit_load_dict smtkt_limit_pulse]

   if {$amt_trans >= $smtkt_limit_pulse} {
      set smltkt_ind "N"
   } else {
      set smltkt_ind "Y"
   }

   #
   # Determine issuer card arrangement
   #
   # C --> Choice
   # L --> Limited
   # S --> Standard
   #
   # Note:  Currently not supported
   #
   set iss_card_arrangement "S"

   #
   # Determine issuer card product type
   #
   if {$iss_card_arrangement != "P"} {
      set iss_card_product_type "D"
   }

   #
   # Determine tier level
   #
   set tier_level "*"

   #
   # Obtain the MAS code
   #
   set default_mas_code_pulse [dict get $pin_debit_load_dict default_mas_code_pulse]
   set mas_code [determine_mas_code $network_id $mcc $tid $iss_card_arrangement $iss_card_product_type $pos_cond $regulated_rate_ind $smltkt_ind $tier_level $default_mas_code_pulse]

   return $mas_code

};# assign_pulse_mas_code


##############################################################################
#
# Procedure Name:  assign_shazam_mas_code
#
# Description:     Assign the NYCE MAS code
# Error Return:    None
#
################################################################################
proc assign_shazam_mas_code {network_id tid amt_trans pos_entry transaction_type market_type card_present mcc tier_ind intl_ind regulated_rate_ind iss_product_id iss_card_product_type} {

   global pin_debit_load_dict

   #
   # Determine POS condition
   #
   set pos_cond_support_shazam [dict get $pin_debit_load_dict pos_cond_support_shazam]

   if {$pos_cond_support_shazam == "Y"} {
      set pos_cond [determine_pos_cond $pos_entry $transaction_type $market_type]
   } else {
      set pos_cond "*"
   }

   #
   # Determine small ticket eligibility
   #
   set smtkt_limit_shazam [dict get $pin_debit_load_dict smtkt_limit_shazam]

   if {$amt_trans >= $smtkt_limit_shazam} {
      set smltkt_ind "N"
   } else {
      set smltkt_ind "Y"
   }

   #
   # Determine issuer card arrangement
   #
   # S --> Standard
   #
   # Note:  Currently not supported
   #
   set iss_card_arrangement "S"

   #
   # Determine issuer card product type
   #
   set iss_card_product_type "D"

   #
   # Determine tier level
   #
   # Note:  Currently not fully supported
   #
   if {(($mcc != "4111") ||
        ($mcc != "5499") ||
        ($mcc != "5814") ||
        ($mcc != "5994") ||
        ($mcc != "7211") ||
        ($mcc != "7338") ||
        ($mcc != "7523") ||
        ($mcc != "7542") ||
        ($mcc != "7832") ||
        ($mcc != "7841")) && ($tier_ind != "")} {
      set tier_level $tier_ind
   } else {
      set tier_level "*"
   }

   #
   # Obtain the MAS code
   #
   set default_mas_code_shazam [dict get $pin_debit_load_dict default_mas_code_shazam]
   set mas_code [determine_mas_code $network_id $mcc $tid $iss_card_arrangement $iss_card_product_type $pos_cond $regulated_rate_ind $smltkt_ind $tier_level $default_mas_code_shazam]

   return $mas_code

};# assign_shazam_mas_code


##############################################################################
#
# Procedure Name:  assign_star_mas_code
#
# Description:     Assign the NYCE MAS code
# Error Return:    None
#
################################################################################
proc assign_star_mas_code {network_id tid amt_trans pos_entry transaction_type market_type card_present mcc tier_ind intl_ind regulated_rate_ind iss_product_id iss_card_product_type} {

   global pin_debit_load_dict

   #
   # Determine POS condition
   #
   set pos_cond_support_star [dict get $pin_debit_load_dict pos_cond_support_star]

   if {$pos_cond_support_star == "Y"} {
      set pos_cond [determine_pos_cond $pos_entry $transaction_type $market_type]
   } else {
      set pos_cond "*"
   }

   #
   # Determine small ticket eligibility
   #
   set smtkt_limit_star [dict get $pin_debit_load_dict smtkt_limit_star]

   if {$amt_trans >= $smtkt_limit_star} {
      set smltkt_ind "N"
   } else {
      set smltkt_ind "Y"
   }

   #
   # Determine issuer card arrangement
   #
   # P --> Preferred
   # S --> Standard
   #
   # Note:  Currently not supported
   #
   set iss_card_arrangement "S"

   #
   # Determine issuer card product type
   #
   set iss_card_product_type "D"

   #
   # Determine tier level
   #
   # Note:  Currently not fully supported
   #
   if {(($mcc != "5912") ||
        ($mcc != "8011") ||
        ($mcc != "8062") ||
        ($mcc != "8099") ||
        ($mcc != "4111") ||
        ($mcc != "5499") ||
        ($mcc != "5994") ||
        ($mcc != "7211") ||
        ($mcc != "7338") ||
        ($mcc != "7523") ||
        ($mcc != "7542") ||
        ($mcc != "7832") ||
        ($mcc != "7841") ||
        ($transaction_type != "U")) && ($tier_ind != "")} {
      set tier_level $tier_ind
   } else {
      set tier_level "*"
   }

   #
   # Obtain the MAS code
   #
   set default_mas_code_star [dict get $pin_debit_load_dict default_mas_code_star]
   set mas_code [determine_mas_code $network_id $mcc $tid $iss_card_arrangement $iss_card_product_type $pos_cond $regulated_rate_ind $smltkt_ind $tier_level $default_mas_code_star]

   return $mas_code

};# assign_star_mas_code

##############################################################################
#
# Procedure Name:  determine_mas_code
#
# Description:     Determine the MAS code
# Error Return:    54 [Database select operation failed]
#
################################################################################
proc determine_mas_code {network_id mcc tid iss_card_arrangement iss_card_product_type pos_cond regulated_rate_ind smltkt_ind tier_level default_mas_code} {

   global pin_debit_load_dict

   #
   # Determine transaction type from the TID:
   #     010003005101 -> Sale
   #     010003005102 -> Refund
   #
   switch $tid {
      "010003005101"       {set tran_type "*"
                           }
      "010003005102"       {set tran_type "R"
                           }
      default              {set tran_type "*"
                           }
   }

   #
   # Set the intial MCC for lookups;
   # travel-related MCCs are set to 3000 or 7011
   #
   switch [string range $mcc 0 0] {
      "3"      {set mcc_value "3000"
               }
      "7"      {if {($mcc >= "7011") && ($mcc <= "7512")} {
                  set mcc_value "7011"
               } else {
                  set mcc_value $mcc
               }}
      default  {set mcc_value $mcc
               }
   }

   #
   # Obtain the MAS code for a specified MCC
   #
   set pin_debit_fee_qual_cursor [dict get $pin_debit_load_dict pin_debit_fee_qual_cursor]

   set pin_debit_fee_qual_query_mcc "SELECT mas_code as MAS_CODE
                                       FROM pin_debit_fee_qual
                                      WHERE network_id = :network_id_var
                                        AND mcc = :mcc_value_var
                                        AND tran_type = :tran_type_var
                                        AND iss_card_arrangement = :iss_card_arrangement_var
                                        AND iss_card_product_type = :iss_card_product_type_var
                                        AND pos_cond = :pos_cond_var
                                        AND regulated_rate_ind = :regulated_rate_ind_var
                                        AND smltkt_ind = :smltkt_ind_var
                                        AND tier_id = :tier_id_var"

   if {[oraparse $pin_debit_fee_qual_cursor $pin_debit_fee_qual_query_mcc
      orabind  $pin_debit_fee_qual_cursor :network_id_var "$network_id" :mcc_value_var "$mcc_value" :tran_type_var "$tran_type" :iss_card_arrangement_var "$iss_card_arrangement" :iss_card_product_type_var "$iss_card_product_type" :pos_cond_var "$pos_cond" :regulated_rate_ind_var "$regulated_rate_ind" :smltkt_ind_var "$smltkt_ind" :tier_id_var "$tier_level"
      oraexec  $pin_debit_fee_qual_cursor ] != 0} {
      write_log_message "pin_debit_fee_qual_query_mcc bind failed with [oramsg $pin_debit_fee_qual_cursor rc] [oramsg $pin_debit_fee_qual_cursor error]"
      close_db
      close_log_file
      exit 51
   } else {
      if {[orafetch $pin_debit_fee_qual_cursor -dataarray pin_debit_fee_qual_query_mcc_results -indexbyname] != 1403 } {
         set mas_code $pin_debit_fee_qual_query_mcc_results(MAS_CODE)
      } else {
         #
         # Obtain the MAS code with a non-specified MCC
         #
         set mcc_value "*"
         set pin_debit_fee_qual_cursor [dict get $pin_debit_load_dict pin_debit_fee_qual_cursor]

         set pin_debit_fee_qual_query "SELECT mas_code as MAS_CODE
                                         FROM pin_debit_fee_qual
                                        WHERE network_id = :network_id_var
                                          AND mcc = :mcc_value_var
                                          AND tran_type = :tran_type_var
                                          AND iss_card_arrangement = :iss_card_arrangement_var
                                          AND iss_card_product_type = :iss_card_product_type_var
                                          AND pos_cond = :pos_cond_var
                                          AND regulated_rate_ind = :regulated_rate_ind_var
                                          AND smltkt_ind = :smltkt_ind_var
                                          AND tier_id = :tier_id_var"

         if {[oraparse $pin_debit_fee_qual_cursor $pin_debit_fee_qual_query
            orabind  $pin_debit_fee_qual_cursor :network_id_var "$network_id" :mcc_value_var "$mcc_value" :tran_type_var "$tran_type" :iss_card_arrangement_var "$iss_card_arrangement" :iss_card_product_type_var "$iss_card_product_type" :pos_cond_var "$pos_cond" :regulated_rate_ind_var "$regulated_rate_ind" :smltkt_ind_var "$smltkt_ind" :tier_id_var "$tier_level"
            oraexec  $pin_debit_fee_qual_cursor ] != 0} {
            write_log_message "pin_debit_fee_qual_query bind failed with [oramsg $pin_debit_fee_qual_cursor rc] [oramsg $pin_debit_fee_qual_cursor error]"
            close_db
            close_log_file
            exit 51
         } else {
            if {[orafetch $pin_debit_fee_qual_cursor -dataarray pin_debit_fee_qual_query_results -indexbyname] != 1403 } {
               set mas_code $pin_debit_fee_qual_query_results(MAS_CODE)
            } else {
               set mas_code $default_mas_code
            }
         }
      }
   }

   return $mas_code

};# determine_mas_code


##############################################################################
#
# Procedure Name:  import_pin_debit_trans
#
# Description:     Import PIN debit trans into in_draft_pin_debit
# Error Return:    54 [Database select operation failed]
#                  55 [Database insert operation failed]
#                  56 [Database update operation failed]
#                  57 [Database delete operation failed]
#                  62 [Invalid value]
#
################################################################################
proc import_pin_debit_trans {} {

   global pin_debit_load_dict

   set action_code [dict get $pin_debit_load_dict action_code]
   set ath_db_logon_handle [dict get $pin_debit_load_dict ath_db_logon_handle]
   set card_type [dict get $pin_debit_load_dict card_type]
   set clr_db_logon_handle [dict get $pin_debit_load_dict clr_db_logon_handle]
   set debit_card_scheme [dict get $pin_debit_load_dict debit_card_scheme]
   set mbr_bin_card_scheme [dict get $pin_debit_load_dict mbr_bin_card_scheme]
   set merch_active [dict get $pin_debit_load_dict merch_active]
   set run_file_date [dict get $pin_debit_load_dict run_file_date]
   set sec_dest_clr_mode [dict get $pin_debit_load_dict sec_dest_clr_mode]
   set sec_dest_file_type [dict get $pin_debit_load_dict sec_dest_file_type]
   set updt_tran_status [dict get $pin_debit_load_dict updt_tran_status]
   set pin_debit_tran_count 0

   #
   # Obtain the next available pin_debit_import_run_nbr from global_seq_ctrl;
   # advance the value in global_seq_ctrl
   #
   set global_seq_ctrl_cursor [dict get $pin_debit_load_dict global_seq_ctrl_cursor]
   set global_seq_ctrl_query_seq_name_1 "pin_debit_import_run_nbr"

   set global_seq_ctrl_query_1 "SELECT last_seq_nbr as PIN_DEBIT_IMPORT_RUN_NBR
                                  FROM global_seq_ctrl
                                 WHERE seq_name = :seq_name_var"

   if {[oraparse $global_seq_ctrl_cursor $global_seq_ctrl_query_1
        orabind  $global_seq_ctrl_cursor :seq_name_var "$global_seq_ctrl_query_seq_name_1"
        oraexec  $global_seq_ctrl_cursor ] != 0} {
      write_log_message "global_seq_ctrl_query_1 bind failed with [oramsg $global_seq_ctrl_cursor rc] [oramsg $global_seq_ctrl_cursor error]"
      close_db
      close_log_file
      exit 51
   } else {
      if {[orafetch $global_seq_ctrl_cursor -dataarray global_seq_ctrl_query_1_results -indexbyname] != 1403 } {
         set pin_debit_import_run_nbr [expr $global_seq_ctrl_query_1_results(PIN_DEBIT_IMPORT_RUN_NBR) + 1]

         set global_seq_ctrl_update_query_1 "UPDATE global_seq_ctrl
                                                SET last_seq_nbr = '$pin_debit_import_run_nbr'
                                              WHERE seq_name = '$global_seq_ctrl_query_seq_name_1'"

         if {[catch {orasql $global_seq_ctrl_cursor $global_seq_ctrl_update_query_1 } ora_err]} {
            oraroll $clr_db_logon_handle
            write_log_message "global_seq_ctrl_update_query_1 update rollback for error $ora_err"
            write_log_message "[oramsg $global_seq_ctrl_cursor all]"
            exit 56
         } else {
            oracommit $clr_db_logon_handle
         }
      } else {
         write_log_message "pin_debit_import_run_nbr was not able to be obtained from global_seq_ctrl_query"
         write_log_message "global_seq_ctrl_query_1 select failed with [oramsg $global_seq_ctrl_cursor rc] [oramsg $global_seq_ctrl_cursor error]"
         close_db
         close_log_file
         exit 54
      }
   }

   #
   # Locate transactions in the settlement table
   #
   set settlement_select_query "
       SELECT s.mid as MID,
           s.tid as TID,
           s.transaction_id as TRANSACTION_ID,
           s.request_type as REQUEST_TYPE,
           s.transaction_type as TRANSACTION_TYPE,
           s.cardnum as CARDNUM,
           s.exp_date as EXP_DATE,
           s.amount as AMOUNT,
           s.orig_amount as ORIG_AMOUNT,
           s.incr_amount as INCR_AMOUNT,
           s.fee_amount as FEE_AMOUNT,
           s.tax_amount as TAX_AMOUNT,
           s.process_code as PROCESS_CODE,
           s.status as STATUS,
           s.authdatetime as AUTHDATETIME,
           s.auth_timer as AUTH_TIMER,
           s.auth_code as AUTH_CODE,
           s.auth_source as AUTH_SOURCE,
           s.action_code as ACTION_CODE,
           s.shipdatetime as SHIPDATETIME,
           s.ticket_no as TICKET_NO,
           s.network_id as NETWORK_ID,
           s.addendum_bitmap as ADDENDUM_BITMAP,
           s.capture as CAPTURE,
           s.pos_entry as POS_ENTRY,
           s.card_id_method as CARD_ID_METHOD,
           s.retrieval_no as RETRIEVAL_NO,
           s.avs_response as AVS_RESPONSE,
           s.aci as ACI,
           s.cps_auth_id as CPS_AUTH_ID,
           s.cps_tran_id as CPS_TRAN_ID,
           s.cps_validation_code as CPS_VALIDATION_CODE,
           s.currency_code as CURRENCY_CODE,
           s.clerk_id as CLERK_ID,
           s.shift as SHIFT,
           s.hub_flag as HUB_FLAG,
           s.billing_type as BILLING_TYPE,
           s.batch_no as BATCH_NO,
           s.item_no as ITEM_NO,
           s.other_data as OTHER_DATA,
           s.settle_date as SETTLE_DATE,
           s.card_type as CARD_TYPE,
           s.cvv as CVV,
           s.pc_type as PC_TYPE,
           s.currency_rate as CURRENCY_RATE,
           s.other_data2 as OTHER_DATA2,
           s.other_data3 as OTHER_DATA3,
           s.other_data4 as OTHER_DATA4,
           s.arn as ARN,
           s.market_type as MARKET_TYPE,
           s.vv_result as VV_RESULT,
           s.card_present as CARD_PRESENT,
           s.card_program as CARD_PROGRAM,
           s.addenda_present as ADDENDA_PRESENT,
           s.authorization_authority as AUTHORIZATION_AUTHORITY,
           s.origination_ip as ORIGINATION_IP,
           s.subscriber as SUBSCRIBER,
           s.external_transaction_id as EXTERNAL_TRANSACTION_ID,
           s.cardholder_verif_meth as CARDHOLDER_VERIF_METH,
           s.card_level_results as CARD_LEVEL_RESULTS,
           s.token_used as TOKEN_USED,
           s.token_requested as TOKEN_REQUESTED,
           s.system_trace_number as SYSTEM_TRACE_NUMBER,
           aci_requested as ACI_REQUESTED,
           nvl(aa.system_trace_number, 0) as SYSTEM_TRACE_NUMBER,
           nvl(aa.tip_amount, 0) as TIP_AMOUNT,
           trim(aa.ebt_type) as EBT_TYPE,
           ea.pin_used as PIN_USED,
           m.long_name as MERCH_NAME,
           m.address_1 as MERCH_ADDRESS1,
           m.address_2 as MERCH_ADDRESS2,
           m.city as MERCH_CITY,
           m.state as MERCH_PROV_STATE,
           m.zip as MERCH_POST_CD_ZIP,
           m.sic_code as MCC,
           m.currency_code as CURRENCY_CODE,
           mar.institution_id as INST_ID,
           case when m.visa_id = ' '
                then m.debit_id
                else m.visa_id end as MERCH_ID,
           mm.bin_number as ACQ_BIN
      FROM settlement s
      left outer join auth_addenda aa
          on s.other_data3 = aa.unique_id
      left outer join encryption_addenda ea
          on s.other_data3 = ea.unique_id
      left outer join merchant m
          on s.mid = m.mid
      left outer join merchant_addenda_rt mar
          on s.mid = mar.mid
      left outer join master_merchant mm
          on m.mmid = mm.mmid
     WHERE s.action_code = :action_code_var
       AND s.card_type = :card_type_var
       AND substr(s.shipdatetime, 1, 8) <= :shipdatetime
       AND s.status is not null
       AND m.active = :merch_active_var
       ORDER BY s.mid"

   set settlement_cursor [dict get $pin_debit_load_dict settlement_cursor]

   if {[oraparse $settlement_cursor $settlement_select_query
        orabind  $settlement_cursor :action_code_var "$action_code" :card_type_var "$card_type" :merch_active_var "$merch_active" :shipdatetime "$run_file_date"
        oraexec  $settlement_cursor ] != 0} {
      write_log_message "Settlement table row not able to be obtained."
      write_log_message "settlement_select_query bind failed with [oramsg $settlement_cursor rc] [oramsg $settlement_cursor error]."
      close_db
      close_log_file
      exit 51
   } else {
      #
      # Cycle through each transaction
      #
      while {[orafetch $settlement_cursor -dataarray settlement_select_query_results -indexbyname] != 1403} {
         incr pin_debit_tran_count

         #
         # Obtain the next available pin_debit_import_trans_seq_nbr from global_seq_ctrl;
         # advance the value in global_seq_ctrl
         #

         set settlement_card_num $settlement_select_query_results(CARDNUM)

         set global_seq_ctrl_cursor [dict get $pin_debit_load_dict global_seq_ctrl_cursor]
         set global_seq_ctrl_query_seq_name_2 "pin_debit_import_trans_seq_nbr"

         set global_seq_ctrl_query_2 "SELECT last_seq_nbr as PIN_DEBIT_IMPORT_TRANS_SEQ_NBR
                                        FROM global_seq_ctrl
                                       WHERE seq_name = :seq_name_var"

         if {[oraparse $global_seq_ctrl_cursor $global_seq_ctrl_query_2
              orabind  $global_seq_ctrl_cursor :seq_name_var "$global_seq_ctrl_query_seq_name_2"
              oraexec  $global_seq_ctrl_cursor ] != 0} {
            write_log_message "global_seq_ctrl_query_2 bind failed with [oramsg $global_seq_ctrl_cursor rc] [oramsg $global_seq_ctrl_cursor error]"
            close_db
            close_log_file
            exit 51
         } else {
            if {[orafetch $global_seq_ctrl_cursor -dataarray global_seq_ctrl_query_2_results -indexbyname] != 1403 } {
               set pin_debit_import_trans_seq_nbr [expr $global_seq_ctrl_query_2_results(PIN_DEBIT_IMPORT_TRANS_SEQ_NBR) + 1]

               set global_seq_ctrl_update_query_2 "UPDATE global_seq_ctrl
                                                      SET last_seq_nbr = '$pin_debit_import_trans_seq_nbr'
                                                   WHERE seq_name = '$global_seq_ctrl_query_seq_name_2'"

               if {[catch {orasql $global_seq_ctrl_cursor $global_seq_ctrl_update_query_2 } ora_err]} {
                  oraroll $clr_db_logon_handle
                  write_log_message "global_seq_ctrl_update_query_2 update rollback for error $ora_err"
                  write_log_message "[oramsg $global_seq_ctrl_cursor all]"
                  exit 56
               } else {
                  oracommit $clr_db_logon_handle
               }
            } else {
               write_log_message "pin_debit_import_trans_seq_nbr was not able to be obtained from global_seq_ctrl_query"
               write_log_message "global_seq_ctrl_query_2 select failed with [oramsg $global_seq_ctrl_cursor rc] [oramsg $global_seq_ctrl_cursor error]"
               close_db
               close_log_file
               exit 54
            }
         }

         set tip_amount $settlement_select_query_results(TIP_AMOUNT)
         set system_trace_number $settlement_select_query_results(SYSTEM_TRACE_NUMBER)
         set pin_used  $settlement_select_query_results(PIN_USED)
         set merch_name $settlement_select_query_results(MERCH_NAME)
         set merch_address1 $settlement_select_query_results(MERCH_ADDRESS1)
         set merch_address2 $settlement_select_query_results(MERCH_ADDRESS2)
         set merch_city $settlement_select_query_results(MERCH_CITY)
         set merch_prov_state $settlement_select_query_results(MERCH_PROV_STATE)
         set merch_post_cd_zip $settlement_select_query_results(MERCH_POST_CD_ZIP)
         set mcc $settlement_select_query_results(MCC)
         set currency_code $settlement_select_query_results(CURRENCY_CODE)
         set inst_id $settlement_select_query_results(INST_ID)
         set merch_id $settlement_select_query_results(MERCH_ID)
         set acq_bin $settlement_select_query_results(ACQ_BIN)


         #
         # Find the merchant tier information
         #
         set acq_entity_add_on_cursor [dict get $pin_debit_load_dict acq_entity_add_on_cursor]

         set acq_entity_add_on_query "SELECT user_defined_3 as TIER_IND,
                                             user_defined_4 as SALES_VOL,
                                             user_defined_5 as TOT_SALES,
                                             user_defined_6 as VOLUME_PERIOD
                                        FROM acq_entity_add_on
                                       WHERE entity_id = :entity_id_var"

         if {[oraparse $acq_entity_add_on_cursor $acq_entity_add_on_query
              orabind  $acq_entity_add_on_cursor :entity_id_var "$merch_id"
              oraexec  $acq_entity_add_on_cursor ] != 0} {
            write_log_message "acq_entity_add_on_query bind failed with [oramsg $acq_entity_add_on_cursor rc] [oramsg $acq_entity_add_on_cursor error]"
            close_db
            close_log_file
            exit 51
         } else {
            if {[orafetch $acq_entity_add_on_cursor -dataarray acq_entity_add_on_query_results -indexbyname] != 1403 } {
               if {$acq_entity_add_on_query_results(TIER_IND) == ""} {
                  set tier_ind "*"
               } else {
                  set tier_ind $acq_entity_add_on_query_results(TIER_IND)
               }

               set sales_vol $acq_entity_add_on_query_results(SALES_VOL)
               set tot_sales $acq_entity_add_on_query_results(TOT_SALES)
               set volume_period $acq_entity_add_on_query_results(VOLUME_PERIOD)
            } else {
               set tier_ind "*"
               set sales_vol ""
               set tot_sales ""
               set volume_period ""
            }
         }

         #
         # Obtain card characteristics associated with the BIN;
         # the query first searches for the max card_scheme value, as the MasterCard debit BINs
         # are dual-listed as Visa
         #
         set bin_cursor [dict get $pin_debit_load_dict bin_cursor]

         set bin_cursor_query_1 "SELECT card_scheme as BIN_CARD_SCHEME,
                                     product_id as ISS_PRODUCT_ID,
                                     bin as ISS_BIN,
                                     ardef_cntry as ISS_CNTRY_CODE_A2,
                                     product_id as ISS_PRODUCT_ID,
                                     acct_fund_src as ACCT_FUND_SRC,
                                     regulated_ind as REGULATED_RATE_IND,
                                     nnss_ind as NNSS_IND,
                                     repow_part_ind as REPOW_PART_IND
                                   FROM bin
                                  WHERE bin_range_low <= :bin_range_var
                                    AND bin_range_high >= :bin_range_var
                                    AND bin_type = :bin_type_var"

        if {[oraparse $bin_cursor $bin_cursor_query_1
             orabind  $bin_cursor :bin_range_var $settlement_card_num :bin_type_var "I"
             oraexec  $bin_cursor ] != 0} {
            write_log_message "bin_cursor_query_1 bind failed with [oramsg $bin_cursor rc] [oramsg $bin_cursor error]"
            close_db
            close_log_file
            exit 51
         } else {
            if {[orafetch $bin_cursor -dataarray bin_cursor_query_1_results -indexbyname] != 1403 } {

               set card_scheme_var_value $bin_cursor_query_1_results(BIN_CARD_SCHEME)
               set iss_bin $bin_cursor_query_1_results(ISS_BIN)
               set iss_cntry_code_a2 $bin_cursor_query_1_results(ISS_CNTRY_CODE_A2)
               set iss_product_id $bin_cursor_query_1_results(ISS_PRODUCT_ID)
               set acct_fund_src $bin_cursor_query_1_results(ACCT_FUND_SRC)
               set nnss_ind $bin_cursor_query_1_results(NNSS_IND)
               set repow_part_ind $bin_cursor_query_1_results(REPOW_PART_IND)

               if {$iss_product_id == "VIS" || $iss_product_id == "CIR"} {
                  set bin_card_scheme "04"
               } else {
                  set bin_card_scheme $card_scheme_var_value
               }

               #
               # Regulated (Y):
               # 2 --> Non-exempt [Discover]
               # B --> Base regulated [MasterCard]
               # Y --> Regulated [Visa]
               #
               # Regulated wtih Fraud Adjustment (1):
               # 1 --> Non-exempt with fraud prevention adjustment [Discover]
               # 1 --> Regulated with Fraud Protected [MasterCard]
               #
               # Not Regulated (N):
               # 0 --> Exempt [Discover]
               # N --> Not regulated [MasterCard]
               # N --> Not regulated [Visa]
               #
               switch $bin_cursor_query_1_results(REGULATED_RATE_IND) {
                  "2"            {set regulated_rate_ind "Y"
                                 }
                  "B"            {set regulated_rate_ind "Y"
                                 }
                  "Y"            {set regulated_rate_ind "Y"
                                 }
                  "1"            {set regulated_rate_ind "F"
                                 }
                  "0"            {set regulated_rate_ind "N"
                                 }
                  "N"            {set regulated_rate_ind "N"
                                 }
                  default        {set regulated_rate_ind "N"
                                 }
               }
            } else {
               write_log_message "BIN information was not able to be obtained from bin_cursor_query_1 for BIN: [string range $settlement_select_query_results(CARDNUM) 0 5], OTHER_DATA4: $settlement_select_query_results(OTHER_DATA4)"
               write_log_message "bin_cursor_query_1 select failed with [oramsg $bin_cursor rc] [oramsg $bin_cursor error]"
               continue
            }
         }

         #
         # Examine the visa_reg_ardef table for regulated BINs
         #
         if {($bin_card_scheme == "04")} {
            set visa_reg_ardef_cursor [dict get $pin_debit_load_dict visa_reg_ardef_cursor]

            set visa_reg_ardef_query "SELECT bin_range_low as bin_range_low
                                        FROM visa_reg_ardef
                                       WHERE bin_range_low <= :bin_range_var
                                         AND bin_range_high >= :bin_range_var"

            if {[oraparse $visa_reg_ardef_cursor $visa_reg_ardef_query
                 orabind  $visa_reg_ardef_cursor :bin_range_var "$settlement_select_query_results(CARDNUM)"
                 oraexec  $visa_reg_ardef_cursor ] != 0} {
               write_log_message "visa_reg_ardef_query bind failed with [oramsg $visa_reg_ardef_cursor rc] [oramsg $visa_reg_ardef_cursor error]"
               close_db
               close_log_file
               exit 51
            } else {
               if {[orafetch $visa_reg_ardef_cursor -dataarray visa_reg_ardef_query_results -indexbyname] != 1403 } {
                  set regulated_rate_ind "Y"
               } else {
                  set regulated_rate_ind "N"
               }
            }
         }

         #
         # Determine the MAS TID for the transaction from the request type:
         #     0260 -> Sale
         #     0460 -> Refund
         #
         switch $settlement_select_query_results(REQUEST_TYPE) {
            "0260"      {set tid "010003005101"
                        }
            "0460"      {set tid "010003005102"
                        }
            default     {write_log_message "Invalid PIN debit request type: $settlement_select_query_results(REQUEST_TYPE), , OTHER_DATA4: $settlement_select_query_results(OTHER_DATA4)"
                         continue
                        }
         }

         #
         # Obtain the acquirer country information
         #
         set mbr_bin_cursor [dict get $pin_debit_load_dict mbr_bin_cursor]

         set mbr_bin_query "SELECT cntry_code_alpha2 as ACQ_CNTRY_CODE_A2
                              FROM mbr_bin
                             WHERE bin = :bin_var
                               AND card_scheme = :mbr_bin_card_scheme_var"

         if {[oraparse $mbr_bin_cursor $mbr_bin_query
              orabind  $mbr_bin_cursor :bin_var "$acq_bin" :mbr_bin_card_scheme_var "$mbr_bin_card_scheme"
              oraexec  $mbr_bin_cursor ] != 0} {
            write_log_message "mbr_bin_query bind failed with [oramsg $mbr_bin_cursor rc] [oramsg $mbr_bin_cursor error]"
            close_db
            close_log_file
            exit 51
         } else {
            if {[orafetch $mbr_bin_cursor -dataarray mbr_bin_query_results -indexbyname] != 1403 } {
               set acq_cntry_code_a2 $mbr_bin_query_results(ACQ_CNTRY_CODE_A2)
            } else {
               write_log_message "Acquirer information was not able to be obtained from mbr_bin"
               write_log_message "mbr_bin_query select failed with [oramsg $mbr_bin_cursor rc] [oramsg $mbr_bin_cursor error]"
               close_db
               close_log_file
               exit 54
            }
         }

         #
         # Locate the currency exponent associated with the BIN currency code
         #
         set currency_code_cursor [dict get $pin_debit_load_dict currency_code_cursor]

         set currency_code_query "SELECT curr_exponent as CURR_EXPONENT
                                    FROM currency_code
                                   WHERE curr_code = :cntry_code_var"

         if {[oraparse $currency_code_cursor $currency_code_query
              orabind  $currency_code_cursor :cntry_code_var "$settlement_select_query_results(CURRENCY_CODE)"
              oraexec  $currency_code_cursor ] != 0} {
            write_log_message "currency_code_query bind failed with [oramsg $currency_code_cursor rc] [oramsg $currency_code_cursor error]"
            close_db
            close_log_file
            exit 51
         } else {
            if {[orafetch $currency_code_cursor -dataarray currency_code_query_results -indexbyname] != 1403 } {
               set amt_trans    [expr int([expr $settlement_select_query_results(AMOUNT) * [expr pow(10, $currency_code_query_results(CURR_EXPONENT))]] + .5)]
               set amt_fees     [expr int([expr $settlement_select_query_results(FEE_AMOUNT) * [expr pow(10, $currency_code_query_results(CURR_EXPONENT))]] + .5)]
               set amt_tax      [expr int([expr $settlement_select_query_results(TAX_AMOUNT) * [expr pow(10, $currency_code_query_results(CURR_EXPONENT))]] + .5)]
               set amt_auth     [expr int([expr $settlement_select_query_results(ORIG_AMOUNT) * [expr pow(10, $currency_code_query_results(CURR_EXPONENT))]] + .5)]
               set amt_cashback [expr int([expr $settlement_select_query_results(INCR_AMOUNT) * [expr pow(10, $currency_code_query_results(CURR_EXPONENT))]] + .5)]
               set amt_fees     [expr int([expr $settlement_select_query_results(FEE_AMOUNT) * [expr pow(10, $currency_code_query_results(CURR_EXPONENT))]] + .5)]
               set amt_tax      [expr int([expr $settlement_select_query_results(TAX_AMOUNT) * [expr pow(10, $currency_code_query_results(CURR_EXPONENT))]] + .5)]
               set amt_tip      [expr int([expr $tip_amount * [expr pow(10, $currency_code_query_results(CURR_EXPONENT))]] + .5)]
            } else {
               write_log_message "Currency exponent information was not able to be obtained from entity_to_auth"
               write_log_message "currency_code_query select failed with [oramsg $currency_code_cursor rc] [oramsg $currency_code_cursor error]"
               close_db
               close_log_file
               exit 54
            }
         }

         #
         # Configure international indicator
         #
         if {$acq_cntry_code_a2 == $iss_cntry_code_a2} {
            set intl_ind "N"
         } else {
            set intl_ind "Y"
         }

         #
         # Configure processing dates
         #
         set arn_time "[clock format [clock seconds] -format "%H%M%S"]"
         set julian_date "[clock format [clock seconds] -format "%y%j"]"
         set julian_date_yddd [string range $julian_date 1 4]
         set settle_date "[clock format [clock seconds] -format "%Y%m%d%H%M%S"]"

         #
         # Generate the transaction ARN
         #
         set arn "F"
         append arn $acq_bin
         append arn $julian_date_yddd
         append arn $arn_time
         append arn [format "%06d" $pin_debit_tran_count]

         #
         # Determine network ID
         #
         switch $settlement_select_query_results(NETWORK_ID) {
            "20"        {set network_id "20" }
            "13"        {set network_id "13" }
            "24"        {set network_id "24" }
            "29"        {set network_id "29" }
            "02"        {set network_id "03" }
            "03"        {set network_id "03" }
            "16"        {set network_id "16" }
            "23"        {set network_id "23" }
            "18"        {set network_id "18" }
            "27"        {set network_id "18" }
            "09"        {set network_id "09" }
            "17"        {set network_id "09" }
            "19"        {set network_id "09" }
            "28"        {set network_id "28" }
            "08"        {set network_id "08" }
            "10"        {set network_id "08" }
            "11"        {set network_id "08" }
            "12"        {set network_id "08" }
            "15"        {set network_id "08" }
            "15"        {set network_id "08" }
            "29"        {set network_id "29" }
            "IN"        {set network_id "IN" }
            default     {set network_id ""   }
         }

         #
         # Determine MAS code by network
         #
         switch $network_id {
            "20"    {set mas_code [assign_accel_exchange_mas_code $network_id $tid $amt_trans $settlement_select_query_results(POS_ENTRY) $settlement_select_query_results(TRANSACTION_TYPE) $settlement_select_query_results(MARKET_TYPE) $settlement_select_query_results(CARD_PRESENT) $mcc $tier_ind $intl_ind $regulated_rate_ind $iss_product_id $acct_fund_src $pin_used $card_scheme_var_value]
                    }
            "13"    {set mas_code [assign_affn_mas_code           $network_id $tid $amt_trans $settlement_select_query_results(POS_ENTRY) $settlement_select_query_results(TRANSACTION_TYPE) $settlement_select_query_results(MARKET_TYPE) $settlement_select_query_results(CARD_PRESENT) $mcc $tier_ind $intl_ind $regulated_rate_ind $iss_product_id $acct_fund_src]
                    }
            "24"    {set mas_code [assign_cu24_mas_code           $network_id $tid $amt_trans $settlement_select_query_results(POS_ENTRY) $settlement_select_query_results(TRANSACTION_TYPE) $settlement_select_query_results(MARKET_TYPE) $settlement_select_query_results(CARD_PRESENT) $mcc $tier_ind $intl_ind $regulated_rate_ind $iss_product_id $acct_fund_src]
                    }
            "29"    {set mas_code [assign_ebt_mas_code            $network_id $tid $amt_trans $settlement_select_query_results(POS_ENTRY) $settlement_select_query_results(TRANSACTION_TYPE) $settlement_select_query_results(MARKET_TYPE) $settlement_select_query_results(CARD_PRESENT) $mcc $tier_ind $intl_ind $regulated_rate_ind $iss_product_id $acct_fund_src $settlement_select_query_results(EBT_TYPE)]
                    }
            "03"    {set mas_code [assign_interlink_mas_code      $network_id $tid $amt_trans $settlement_select_query_results(POS_ENTRY) $settlement_select_query_results(TRANSACTION_TYPE) $settlement_select_query_results(MARKET_TYPE) $settlement_select_query_results(CARD_PRESENT) $mcc $tier_ind $intl_ind $regulated_rate_ind $iss_product_id $acct_fund_src]
                    }
            "16"    {set mas_code [assign_maestro_mas_code        $network_id $tid $amt_trans $settlement_select_query_results(POS_ENTRY) $settlement_select_query_results(TRANSACTION_TYPE) $settlement_select_query_results(MARKET_TYPE) $settlement_select_query_results(CARD_PRESENT) $mcc $tier_ind $intl_ind $regulated_rate_ind $iss_product_id $acct_fund_src]
                    }
            "23"    {set mas_code [assign_nets_mas_code           $network_id $tid $amt_trans $settlement_select_query_results(POS_ENTRY) $settlement_select_query_results(TRANSACTION_TYPE) $settlement_select_query_results(MARKET_TYPE) $settlement_select_query_results(CARD_PRESENT) $mcc $tier_ind $intl_ind $regulated_rate_ind $iss_product_id $acct_fund_src]
                    }
            "18"    {set mas_code [assign_nyce_mas_code           $network_id $tid $amt_trans $settlement_select_query_results(POS_ENTRY) $settlement_select_query_results(TRANSACTION_TYPE) $settlement_select_query_results(MARKET_TYPE) $settlement_select_query_results(CARD_PRESENT) $mcc $tier_ind $intl_ind $regulated_rate_ind $iss_product_id $acct_fund_src]
                    }
            "09"    {set mas_code [assign_pulse_mas_code          $network_id $tid $amt_trans $settlement_select_query_results(POS_ENTRY) $settlement_select_query_results(TRANSACTION_TYPE) $settlement_select_query_results(MARKET_TYPE) $settlement_select_query_results(CARD_PRESENT) $mcc $tier_ind $intl_ind $regulated_rate_ind $iss_product_id $acct_fund_src]
                    }
            "28"    {set mas_code [assign_shazam_mas_code         $network_id $tid $amt_trans $settlement_select_query_results(POS_ENTRY) $settlement_select_query_results(TRANSACTION_TYPE) $settlement_select_query_results(MARKET_TYPE) $settlement_select_query_results(CARD_PRESENT) $mcc $tier_ind $intl_ind $regulated_rate_ind $iss_product_id $acct_fund_src]
                    }
            "08"    {set mas_code [assign_star_mas_code           $network_id $tid $amt_trans $settlement_select_query_results(POS_ENTRY) $settlement_select_query_results(TRANSACTION_TYPE) $settlement_select_query_results(MARKET_TYPE) $settlement_select_query_results(CARD_PRESENT) $mcc $tier_ind $intl_ind $regulated_rate_ind $iss_product_id $acct_fund_src]
                    }
            "IN"    {set mas_code [assign_interac_mas_code        $network_id $tid $amt_trans $settlement_select_query_results(POS_ENTRY) $settlement_select_query_results(TRANSACTION_TYPE) $settlement_select_query_results(MARKET_TYPE) $settlement_select_query_results(CARD_PRESENT) $mcc $tier_ind $intl_ind $regulated_rate_ind $iss_product_id $acct_fund_src]
                    }
            default {write_log_message "Invalid PIN debit network type:  $settlement_select_query_results(NETWORK_ID)"
                     exit 62
                    }
         }

         #
         # Insert the transaction into in_draft_pin_debit
         #
         set in_draft_pin_debit_cursor [dict get $pin_debit_load_dict in_draft_pin_debit_cursor]

         set in_draft_pin_debit_insert_query "INSERT into in_draft_pin_debit
                                              (PIN_DEBIT_TRANS_SEQ_NBR,
                                               MSG_TYPE,
                                               TID,
                                               CARD_SCHEME,
                                               MAS_CODE,
                                               CPS_TRAN_ID,
                                               SEC_DEST_INST_ID,
                                               SEC_DEST_FILE_TYPE,
                                               SEC_DEST_CLR_MODE,
                                               PAN,
                                               P_CD_TRANS_TYPE,
                                               P_CD_FROM_ACCT,
                                               P_CD_TO_ACCT,
                                               AMT_TRANS,
                                               TRANS_CCD,
                                               TRANS_EXP,
                                               SYSTEM_TRACE_NUMBER,
                                               TRANS_DT,
                                               EXPIRY_DATE,
                                               POS_ENTRY,
                                               CARD_ID_METHOD,
                                               AVS_RESPONSE,
                                               ACI,
                                               CPS_AUTH_ID,
                                               TRANSACTION_TYPE,
                                               MARKET_TYPE,
                                               VV_RESULT,
                                               CARD_PRESENT,
                                               MCC,
                                               ARN,
                                               RECEIVING_INST_ID,
                                               RETV_REF_NBR,
                                               AUTH_CD,
                                               ACTION_CD,
                                               MID,
                                               MERCH_ID,
                                               MERCH_NAME,
                                               MERCH_ADDRESS1,
                                               MERCH_ADDRESS2,
                                               MERCH_CITY,
                                               MERCH_PROV_STATE,
                                               MERCH_POST_CD_ZIP,
                                               AMT_AUTH,
                                               AMT_CASHBACK,
                                               AMT_FEES,
                                               AMT_TAX,
                                               AMT_TIP,
                                               CLR_DATE_J,
                                               EXTERNAL_FILE_ID,
                                               SRC_INST_ID,
                                               TIER_IND,
                                               ACTIVITY_DT,
                                               NETWORK_ID,
                                               INTL_IND,
                                               ISS_BIN,
                                               ISS_CNTRY_CODE_A2,
                                               ISS_PRODUCT_ID,
                                               ACQ_CNTRY_CODE_A2,
                                               ACCT_FUND_SRC,
                                               REGULATED_RATE_IND,
                                               NNSS_IND,
                                               REPOW_PART_IND,
                                               PIN_DEBIT_IMPORT_RUN_NBR,
                                               PIN_DEBIT_IMPORT_RUN_DATE,
                                               PIN_DEBIT_EXPORT_FILE_NBR,
                                               PIN_DEBIT_EXPORT_FILE_DATE
                                              )
                                              VALUES
                                              ('$pin_debit_import_trans_seq_nbr',
                                               '$settlement_select_query_results(REQUEST_TYPE)',
                                               '$tid',
                                               '$debit_card_scheme',
                                               '$mas_code',
                                               '$settlement_select_query_results(CPS_TRAN_ID)',
                                               '$inst_id',
                                               '$sec_dest_file_type',
                                               '$sec_dest_clr_mode',
                                               '$settlement_select_query_results(CARDNUM)',
                                               '[string range $settlement_select_query_results(PROCESS_CODE) 0 1]',
                                               '[string range $settlement_select_query_results(PROCESS_CODE) 2 3]',
                                               '[string range $settlement_select_query_results(PROCESS_CODE) 4 5]',
                                               '$amt_trans',
                                               '$settlement_select_query_results(CURRENCY_CODE)',
                                               '$currency_code_query_results(CURR_EXPONENT)',
                                               '$system_trace_number',
                                               to_date([string range $settlement_select_query_results(AUTHDATETIME) 0 13],'YYYYMMDDHH24MISS'),
                                               to_date([string range $settlement_select_query_results(EXP_DATE) 0 3],'YYMM'),
                                               '$settlement_select_query_results(POS_ENTRY)',
                                               '$settlement_select_query_results(CARD_ID_METHOD)',
                                               '$settlement_select_query_results(AVS_RESPONSE)',
                                               '$settlement_select_query_results(ACI)',
                                               '$settlement_select_query_results(CPS_AUTH_ID)',
                                               '$settlement_select_query_results(TRANSACTION_TYPE)',
                                               '$settlement_select_query_results(MARKET_TYPE)',
                                               '$settlement_select_query_results(VV_RESULT)',
                                               '$settlement_select_query_results(CARD_PRESENT)',
                                               '$mcc',
                                               '$arn',
                                               '$acq_bin',
                                               '$settlement_select_query_results(RETRIEVAL_NO)',
                                               '$settlement_select_query_results(AUTH_CODE)',
                                               '$settlement_select_query_results(ACTION_CODE)',
                                               '$settlement_select_query_results(MID)',
                                               '$merch_id',
                                               '$merch_name',
                                               '$merch_address1',
                                               '$merch_address2',
                                               '$merch_city',
                                               '$merch_prov_state',
                                               '$merch_post_cd_zip',
                                               '$amt_auth',
                                               '$amt_cashback',
                                               '$amt_fees',
                                               '$amt_tax',
                                               '$amt_tip',
                                               '$julian_date',
                                               '',
                                               '$inst_id',
                                               '$tier_ind',
                                               to_date($settle_date,'YYYYMMDDHH24MISS'),
                                               '$network_id',
                                               '$intl_ind',
                                               '$iss_bin',
                                               '$iss_cntry_code_a2',
                                               '$iss_product_id',
                                               '$acq_cntry_code_a2',
                                               '$acct_fund_src',
                                               '$regulated_rate_ind',
                                               '$nnss_ind',
                                               '$repow_part_ind',
                                               '$pin_debit_import_run_nbr',
                                               to_date($settle_date,'YYYYMMDDHH24MISS'),
                                               '',
                                               '')"
         if {[catch {orasql $in_draft_pin_debit_cursor $in_draft_pin_debit_insert_query } ora_err]} {
            oraroll $clr_db_logon_handle
            write_log_message "in_draft_pin_debit_insert_query table rollback for error $ora_err"
            write_log_message "[oramsg $in_draft_pin_debit_cursor all]"
            exit 55
         } else {
            #
            # Insert the transaction into tranhistory
            #
            set tranhistory_cursor [dict get $pin_debit_load_dict tranhistory_cursor]

            set tranhistory_insert_query "INSERT into tranhistory
                                          (MID,
                                           TID,
                                           TRANSACTION_ID,
                                           REQUEST_TYPE,
                                           TRANSACTION_TYPE,
                                           CARDNUM,
                                           EXP_DATE,
                                           AMOUNT,
                                           ORIG_AMOUNT,
                                           INCR_AMOUNT,
                                           FEE_AMOUNT,
                                           TAX_AMOUNT,
                                           PROCESS_CODE,
                                           STATUS,
                                           AUTHDATETIME,
                                           AUTH_TIMER,
                                           AUTH_CODE,
                                           AUTH_SOURCE,
                                           ACTION_CODE,
                                           SHIPDATETIME,
                                           TICKET_NO,
                                           NETWORK_ID,
                                           ADDENDUM_BITMAP,
                                           CAPTURE,
                                           POS_ENTRY,
                                           CARD_ID_METHOD,
                                           RETRIEVAL_NO,
                                           AVS_RESPONSE,
                                           ACI,
                                           CPS_AUTH_ID,
                                           CPS_TRAN_ID,
                                           CPS_VALIDATION_CODE,
                                           CURRENCY_CODE,
                                           CLERK_ID,
                                           SHIFT,
                                           HUB_FLAG,
                                           BILLING_TYPE,
                                           BATCH_NO,
                                           ITEM_NO,
                                           OTHER_DATA,
                                           SETTLE_DATE,
                                           CARD_TYPE,
                                           CVV,
                                           PC_TYPE,
                                           CURRENCY_RATE,
                                           OTHER_DATA2,
                                           OTHER_DATA3,
                                           OTHER_DATA4,
                                           ARN,
                                           MARKET_TYPE,
                                           VV_RESULT,
                                           CARD_PRESENT,
                                           CARD_PROGRAM,
                                           ADDENDA_PRESENT,
                                           AUTHORIZATION_AUTHORITY,
                                           ORIGINATION_IP,
                                           SUBSCRIBER,
                                           EXTERNAL_TRANSACTION_ID,
                                           CARDHOLDER_VERIF_METH,
                                           CARD_LEVEL_RESULTS,
                                           TOKEN_USED,
                                           TOKEN_REQUESTED,
                                           SYSTEM_TRACE_NUMBER,
                                           ACI_REQUESTED
                                          )
                                          VALUES
                                          ('$settlement_select_query_results(MID)',
                                           '$settlement_select_query_results(TID)',
                                           '$settlement_select_query_results(TRANSACTION_ID)',
                                           '$settlement_select_query_results(REQUEST_TYPE)',
                                           '$settlement_select_query_results(TRANSACTION_TYPE)',
                                           '$settlement_select_query_results(CARDNUM)',
                                           '$settlement_select_query_results(EXP_DATE)',
                                           '$settlement_select_query_results(AMOUNT)',
                                           '$settlement_select_query_results(ORIG_AMOUNT)',
                                           '$settlement_select_query_results(INCR_AMOUNT)',
                                           '$settlement_select_query_results(FEE_AMOUNT)',
                                           '$settlement_select_query_results(TAX_AMOUNT)',
                                           '$settlement_select_query_results(PROCESS_CODE)',
                                           '$updt_tran_status',
                                           '$settlement_select_query_results(AUTHDATETIME)',
                                           '$settlement_select_query_results(AUTH_TIMER)',
                                           '$settlement_select_query_results(AUTH_CODE)',
                                           '$settlement_select_query_results(AUTH_SOURCE)',
                                           '$settlement_select_query_results(ACTION_CODE)',
                                           '$settlement_select_query_results(SHIPDATETIME)',
                                           '$settlement_select_query_results(TICKET_NO)',
                                           '$settlement_select_query_results(NETWORK_ID)',
                                           '$settlement_select_query_results(ADDENDUM_BITMAP)',
                                           '$settlement_select_query_results(CAPTURE)',
                                           '$settlement_select_query_results(POS_ENTRY)',
                                           '$settlement_select_query_results(CARD_ID_METHOD)',
                                           '$settlement_select_query_results(RETRIEVAL_NO)',
                                           '$settlement_select_query_results(AVS_RESPONSE)',
                                           '$settlement_select_query_results(ACI)',
                                           '$settlement_select_query_results(CPS_AUTH_ID)',
                                           '$settlement_select_query_results(CPS_TRAN_ID)',
                                           '$settlement_select_query_results(CPS_VALIDATION_CODE)',
                                           '$settlement_select_query_results(CURRENCY_CODE)',
                                           '$settlement_select_query_results(CLERK_ID)',
                                           '$settlement_select_query_results(SHIFT)',
                                           '$settlement_select_query_results(HUB_FLAG)',
                                           '$settlement_select_query_results(BILLING_TYPE)',
                                           '$settlement_select_query_results(BATCH_NO)',
                                           '$settlement_select_query_results(ITEM_NO)',
                                           '$settlement_select_query_results(OTHER_DATA)',
                                           '[string range $settle_date 0 13]',
                                           '$settlement_select_query_results(CARD_TYPE)',
                                           '$settlement_select_query_results(CVV)',
                                           '$settlement_select_query_results(PC_TYPE)',
                                           '$settlement_select_query_results(CURRENCY_RATE)',
                                           '$settlement_select_query_results(OTHER_DATA2)',
                                           '$settlement_select_query_results(OTHER_DATA3)',
                                           '$settlement_select_query_results(OTHER_DATA4)',
                                           '$arn',
                                           '$settlement_select_query_results(MARKET_TYPE)',
                                           '$settlement_select_query_results(VV_RESULT)',
                                           '$settlement_select_query_results(CARD_PRESENT)',
                                           '$settlement_select_query_results(CARD_PROGRAM)',
                                           '$settlement_select_query_results(ADDENDA_PRESENT)',
                                           '$settlement_select_query_results(AUTHORIZATION_AUTHORITY)',
                                           '$settlement_select_query_results(ORIGINATION_IP)',
                                           '$settlement_select_query_results(SUBSCRIBER)',
                                           '$settlement_select_query_results(EXTERNAL_TRANSACTION_ID)',
                                           '$settlement_select_query_results(CARDHOLDER_VERIF_METH)',
                                           '$settlement_select_query_results(CARD_LEVEL_RESULTS)',
                                           '$settlement_select_query_results(TOKEN_USED)',
                                           '$settlement_select_query_results(TOKEN_REQUESTED)',
                                           '$settlement_select_query_results(SYSTEM_TRACE_NUMBER)',
                                           '$settlement_select_query_results(ACI_REQUESTED)'
                                          )"
            if {[catch {orasql $tranhistory_cursor $tranhistory_insert_query } ora_err]} {
               oraroll $ath_db_logon_handle
               write_log_message "tranhistory_insert_query table rollback for error $ora_err"
               write_log_message "[oramsg $tranhistory_cursor all]"
               exit 55
            } else {
               insert_tran_event $settlement_select_query_results(OTHER_DATA4)
               oracommit $ath_db_logon_handle
            }
            oracommit $clr_db_logon_handle
         }

         #
         # Delete the transaction from settlement
         #
         set settlement_delete_cursor [dict get $pin_debit_load_dict settlement_delete_cursor]

         set settlement_delete_query "DELETE from settlement
                                       WHERE other_data4 = '$settlement_select_query_results(OTHER_DATA4)'"

         if {[catch {orasql $settlement_delete_cursor $settlement_delete_query } ora_err]} {
            oraroll $ath_db_logon_handle
            write_log_message "settlement_delete_query table rollback for error $ora_err"
            write_log_message "[oramsg $settlement_delete_cursor all]"
            exit 57
         } else {
            oracommit $ath_db_logon_handle
         }
      }
   }

   write_log_message "PIN debit transaction count for $pin_debit_import_run_nbr:  $pin_debit_tran_count"

};# import_pin_debit_trans


################################################################################
#
# Procedure Name:  close_db
#
# Description:     Connect to the database and open tables used by the program
# Error Return:    52 [Database disconnect failed]
#
################################################################################
proc close_db {} {

   global ath_db
   global clr_db
   global pin_debit_load_dict

   #
   # Close auth_addenda table cursor
   #
   set auth_addenda_cursor [dict get $pin_debit_load_dict auth_addenda_cursor]
   oraclose $auth_addenda_cursor

   #
   # Close encryption_addenda table cursor
   #
   set encryption_addenda_cursor [dict get $pin_debit_load_dict encryption_addenda_cursor]
   oraclose $encryption_addenda_cursor

   #
   # Close merchant table cursor
   #
   set merchant_cursor [dict get $pin_debit_load_dict merchant_cursor]
   oraclose $merchant_cursor

   #
   # Close settlement table cursor
   #
   set settlement_cursor [dict get $pin_debit_load_dict settlement_cursor]
   oraclose $settlement_cursor

   #
   # Close settlement table deletion cursor
   #
   set settlement_delete_cursor [dict get $pin_debit_load_dict settlement_delete_cursor]
   oraclose $settlement_delete_cursor

   #
   # Close tranhistory table cursor
   #
   set tranhistory_cursor [dict get $pin_debit_load_dict tranhistory_cursor]
   oraclose $tranhistory_cursor

   #
   # Disconnect from the Auth database
   #
   set ath_db_logon_handle [dict get $pin_debit_load_dict ath_db_logon_handle]

   if {[catch {oralogoff $ath_db_logon_handle} ora_result]} {
      puts "Encountered error $ora_result while trying to disconnect from the $ath_db database"
      exit 52
   }

   #
   # Close acq_entity_add_on table cursor
   #
   set acq_entity_add_on_cursor [dict get $pin_debit_load_dict acq_entity_add_on_cursor]
   oraclose $acq_entity_add_on_cursor

   #
   # Close bin table cursor
   #
   set bin_cursor [dict get $pin_debit_load_dict bin_cursor]
   oraclose $bin_cursor

   #
   # Close currency_code table cursor
   #
   set currency_code_cursor [dict get $pin_debit_load_dict currency_code_cursor]
   oraclose $currency_code_cursor

   #
   # Close entity_to_auth table cursor
   #
   set entity_to_auth_cursor [dict get $pin_debit_load_dict entity_to_auth_cursor]
   oraclose $entity_to_auth_cursor

   #
   # Close global_seq_ctrl table cursor
   #
   set global_seq_ctrl_cursor [dict get $pin_debit_load_dict global_seq_ctrl_cursor]
   oraclose $global_seq_ctrl_cursor

   #
   # Close in_draft_pin_debit table cursor
   #
   set in_draft_pin_debit_cursor [dict get $pin_debit_load_dict in_draft_pin_debit_cursor]
   oraclose $in_draft_pin_debit_cursor

   #
   # Close mbr_bin table cursor
   #
   set mbr_bin_cursor [dict get $pin_debit_load_dict mbr_bin_cursor]
   oraclose $mbr_bin_cursor

   #
   # Close pin_debit_fee_qual table cursor
   #
   set pin_debit_fee_qual_cursor [dict get $pin_debit_load_dict pin_debit_fee_qual_cursor]
   oraclose $pin_debit_fee_qual_cursor

   #
   # Close pin_debit_fee_qual table cursor
   #
   set visa_reg_ardef_cursor [dict get $pin_debit_load_dict visa_reg_ardef_cursor]
   oraclose $visa_reg_ardef_cursor

   #
   # Disconnect from the Clearing database
   #
   set clr_db_logon_handle [dict get $pin_debit_load_dict clr_db_logon_handle]

   if {[catch {oralogoff $clr_db_logon_handle} ora_result]} {
      puts "Encountered error $ora_result while trying to disconnect from the $clr_db database"
      exit 52
   }

};# end close_db


################################################################################
#
# Procedure Name:  close_log_file
#
# Description:     Closes the log file used by the program
# Error Return:    23 [Log file cannot be closed]
#
################################################################################
proc close_log_file {} {

   global pin_debit_load_dict

   set log_file_ptr [dict get $pin_debit_load_dict log_file_ptr]

   if {[catch {close $log_file_ptr} response]} {
       write_log_message "Cannot close file [dict get $pin_debit_load_dict log_filename]."
       exit 23
   }

};# end close_log_file


# NPP-7450 ->


###############################################################################
# Procedure Name - generate_job_id
# Description    - Gets next job id from auth sequencer
###############################################################################
proc generate_job_id {} {
   global jte_job_id_crsr
   global job_id_seq_gen_name
   global job_id

   # set seq_name
   set seq_name $job_id_seq_gen_name
   
   set job_id_seq_query "select $seq_name.NEXTVAL from dual"

   if {[catch {orasql $jte_job_id_crsr $job_id_seq_query} result]} {
            puts "ERROR:- The sequence query did not run successfully. Please check the DB"
            puts "query - $job_id_seq_query, ERROR-$result"
   }
   if { [catch {orafetch $jte_job_id_crsr -datavariable result} failure] } {
      puts "Failed to get next Job ID using seqencer $seq_name, error: $failure"
   }
   set job_id $result
};# end generate_job_id


################################################################################
# Procedure Name - insert_tran_event
# Description    - Inserts Transaction Event Record into
#                  'Transaction_Events' Table
###############################################################################
proc insert_tran_event { other_data4 } {
   global jte_tran_insert_crsr
   global job_id
   global tran_id_seq_gen_name

   # set seq_name
   set seq_name $tran_id_seq_gen_name
   
   set insert_tran_event_sql "INSERT INTO TRANSACTION_EVENTS (
                    SEQ_ID, UNIQUE_ID, JOB_ID, 
                    TRANSACTION_TIMESTAMP
                    ) 
                  VALUES 
                    (
                    $seq_name.NEXTVAL, '$other_data4', 
                    '$job_id', CURRENT_TIMESTAMP
                    )"
    if { [catch {orasql $jte_tran_insert_crsr $insert_tran_event_sql} failure ] } {
       puts "Transaction Event Table SQL Insert Failure: $failure"
    }

};# insert_tran_event


################################################################################
# Procedure Name - insert_job_start_record
# Description    - performs sql insert to 'Transaction_Jobs' Table
###############################################################################
proc insert_job_record_start {} {
    global jte_job_insert_crsr
    global job_id
    global job_script_name
    global job_source
    global job_dest
   
    set insert_job_start_sql "INSERT INTO Transaction_Jobs (
                    Job_id, Job_Name, Source, Destination,
                    Start_time
                    ) 
                  VALUES 
                    (
                    '$job_id', '$job_script_name', 
                    '$job_source', '$job_dest', CURRENT_TIMESTAMP
                    )"
    if { [catch {orasql $jte_job_insert_crsr $insert_job_start_sql} failure ] } {
       puts "Job Start Event SQL Insert Failure: $failure"
    }

};# insert_job_start_record

################################################################################
# Procedure Name - update_job_start_record
# Description    - performs sql insert to 'Transaction_Jobs' Table
###############################################################################
proc update_job_record_end {} {
    global jte_job_update_crsr
    global job_id
    global pin_debit_load_dict
    global ath_db

   
    set update_job_end_sql "UPDATE Transaction_Jobs 
                            set End_Time = CURRENT_TIMESTAMP
                            where job_id = '$job_id'"

    if { [catch {orasql $jte_job_update_crsr $update_job_end_sql} failure ] } {
       puts "Job End Event SQL Update Failure: $failure"
    }

    set ath_db_logon_handle [dict get $pin_debit_load_dict ath_db_logon_handle]
    oracommit $ath_db_logon_handle

};# update_job_start_record
# NPP-7450 <-


##########
## MAIN ##
##########
init_program
open_log_file
read_cfg_file
write_log_message "_____________________________________________"
open_db

# NPP-7450 ->
generate_job_id
insert_job_record_start
# NPP-7450 <-

import_pin_debit_trans

# NPP-7450 ->
update_job_record_end
# NPP-7450 <-

close_db
write_log_message "Successfully ending PIN debit transaction load"
close_log_file
