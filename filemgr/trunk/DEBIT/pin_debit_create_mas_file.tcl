#!/usr/bin/tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: pin_debit_create_mas_file.tcl 3669 2016-01-31 04:08:24Z bjones $
# $Rev: 3669 $
################################################################################
#
# File Name:  pin_debit_create_mas_file.tcl
#
# Description:  This script creates an institution PIN debit MAS import file.
#
# Script Arguments:  -c = Configuration file name.  Required.  No default.
#                    -d = Run date (e.g., YYYYMMDD).  Required.  No default.
#                         Defaults to current date.
#                    -i = Institution ID (e.g., ALL, 101, 105, 107, 117, 121).
#                         Required.  No default.
#                    -l = Log file name.  Required.  No default.
#                    -o = Output file name.  Required.  No default.
#                    -v = Verbose logging flag.  Optional.  Default to OFF.
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
set clr_db $env(IST_DB)
set clr_db_username $env(IST_DB_USERNAME)
set clr_db_password $env(IST_DB_PASSWORD)
set sysinfo "System: $box\n Location: $env(PWD) \n\n"

#Global variables
global argv
global debug_level

################################################################################
#
# Procedure Name:  unoct
#
# Description:     removes leading zeros from number so TCL sees it as decimal
# Return:          number w/o leading zeros
#
################################################################################
proc unoct {s} {
    set u [string trimleft $s 0]
    if {$u == ""} {
        return 0
    } else {
        return $u
    }
};# end unoct

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
   global debug_level
   global pin_debit_create_mas_file_dict
   set debug_level 0

   set pin_debit_create_mas_file_dict [dict create]
   set num_script_args [lindex $argv 0]
   set i 1

   while {$i < $num_script_args} {
      set script_arg [string range [string trim [lindex $argv $i]] 1 1]
      set script_arg_val [string range [lindex $argv $i] 2 end]

      switch $script_arg {
         "c"     {if {[string length $script_arg_val] != 0} {
                     set cfg_filename "cfg_filename"
                     dict set pin_debit_create_mas_file_dict $cfg_filename $script_arg_val
                  } else {
                     puts stdout "Configuration file full path name must be specified with the -c option"
                     exit 1
                  }}
         "d"     {if {[string length $script_arg_val] != 0} {
                     set current_date $script_arg_val
                     set run_file_date "run_file_date"
                     dict set pin_debit_create_mas_file_dict $run_file_date $script_arg_val
                  } else {
                     set current_date "[clock format [clock seconds] -format "%Y%m%d"]"
                     set run_file_date "run_file_date"
                     dict set pin_debit_create_mas_file_dict $run_file_date $current_date
                  }}
         "i"     {if {[string length $script_arg_val] != 0} {
                     set inst_id "inst_id"
                     dict set pin_debit_create_mas_file_dict $inst_id $script_arg_val
                  } else {
                     puts stdout "Institution ID must be specified with the -i option"
                     exit 1
                  }}
         "l"     {if {[string length $script_arg_val] != 0} {
                     set log_filename "log_filename"
                     dict set pin_debit_create_mas_file_dict $log_filename $script_arg_val
                  } else {
                     puts stdout "Log file full path name must be specified with the -l option"
                     exit 1
                  }}
         "o"     {if {[string length $script_arg_val] != 0} {
                     set output_filename "output_filename"
                     dict set pin_debit_create_mas_file_dict $output_filename $script_arg_val
                  } else {
                     puts stdout "Output file full path name must be specified with the -0 option"
                     exit 1
                  }}
         "v"     {
                     incr $debug_level
                  }
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

   global pin_debit_create_mas_file_dict

   set log_filename [dict get $pin_debit_create_mas_file_dict log_filename]

   if {[catch {open $log_filename a} file_ptr]} {
      write_log_message "Cannot open file $log_filename for logging."
      exit 21
   }

   set log_file_ptr "log_file_ptr"
   dict set pin_debit_create_mas_file_dict $log_file_ptr $file_ptr

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

   global pin_debit_create_mas_file_dict

   set cfg_filename [dict get $pin_debit_create_mas_file_dict cfg_filename]

   if {[catch {open $cfg_filename r} file_ptr]} {
       write_log_message "Cannot open file $cfg_filename for configurations."
       exit 11
   }

   while {[set line_in [gets $file_ptr]] != {} } {
      set cfg_element [lindex [split $line_in ,] 0]

      switch $cfg_element {
         "ACTIVITY_JOB_NAME"              {set activity_job_name "activity_job_name"
                                           set cfg_element_value [lindex [split $line_in ,] 1]
                                           dict set pin_debit_create_mas_file_dict $activity_job_name $cfg_element_value
                                          }
         "ACTIVITY_SOURCE"                {set activity_source "activity_source"
                                           set cfg_element_value [lindex [split $line_in ,] 1]
                                           dict set pin_debit_create_mas_file_dict $activity_source $cfg_element_value
                                          }
         "BATCH_HEADER_TYPE"              {set batch_header_type "batch_header_type"
                                           set cfg_element_value [lindex [split $line_in ,] 1]
                                           dict set pin_debit_create_mas_file_dict $batch_header_type $cfg_element_value
                                          }
         "BATCH_TRAILER_TYPE"             {set batch_trailer_type "batch_trailer_type"
                                           set cfg_element_value [lindex [split $line_in ,] 1]
                                           dict set pin_debit_create_mas_file_dict $batch_trailer_type $cfg_element_value
                                          }
         "BILLING_IND"                    {set billing_ind "billing_ind"
                                           set cfg_element_value [lindex [split $line_in ,] 1]
                                           dict set pin_debit_create_mas_file_dict $billing_ind $cfg_element_value
                                          }
         "DETAIL_REC_TYPE"                {set detail_rec_type "detail_rec_type"
                                           set cfg_element_value [lindex [split $line_in ,] 1]
                                           dict set pin_debit_create_mas_file_dict $detail_rec_type $cfg_element_value
                                          }
         "FILE_HEADER_TYPE"               {set file_header_type "file_header_type"
                                           set cfg_element_value [lindex [split $line_in ,] 1]
                                           dict set pin_debit_create_mas_file_dict $file_header_type $cfg_element_value
                                          }
         "FILE_TRAILER_TYPE"              {set file_trailer_type "file_trailer_type"
                                           set cfg_element_value [lindex [split $line_in ,] 1]
                                           dict set pin_debit_create_mas_file_dict $file_trailer_type $cfg_element_value
                                          }
         "FILE_TYPE"                      {set file_type "file_type"
                                           set cfg_element_value [lindex [split $line_in ,] 1]
                                           dict set pin_debit_create_mas_file_dict $file_type $cfg_element_value
                                          }
         "SUSPEND_LEVEL"                  {set suspend_level "suspend_level"
                                           set cfg_element_value [lindex [split $line_in ,] 1]
                                           dict set pin_debit_create_mas_file_dict $suspend_level $cfg_element_value
                                          }
         default                          {}
      }
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

   global pin_debit_create_mas_file_dict

   set log_file_ptr [dict get $pin_debit_create_mas_file_dict log_file_ptr]

   if { [catch {puts $log_file_ptr "[clock format [clock seconds] -format "%D %T"] $log_msg_text"} ]} {
      write_log_message "[clock format [clock seconds] -format "%D %T"] $log_msg_text"
   }

};# end write_log_message


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

   global clr_db
   global clr_db_username
   global clr_db_password
   global pin_debit_create_mas_file_dict

   #
   # Connect to the Clearing database
   #
   if {[catch {set db_logon_handle [oralogon $clr_db_username/$clr_db_password@$clr_db]} ora_result] } {
      puts "Encountered error $ora_result while trying to connect to the $clr_db database"
      exit 50
   }
   set clr_db_logon_handle "clr_db_logon_handle"
   dict set pin_debit_create_mas_file_dict $clr_db_logon_handle $db_logon_handle

   #
   # Open global_seq_ctrl table cursor
   #
   if {[catch {set table_cursor [oraopen $db_logon_handle]} ora_result]} {
      puts "Encountered error $ora_result while trying to create global_seq_ctrl cursor handle"
      exit 51
   }
   set global_seq_ctrl_cursor "global_seq_ctrl_cursor"
   dict set pin_debit_create_mas_file_dict $global_seq_ctrl_cursor $table_cursor

   #
   # Open in_draft_pin_debit table merchant cursor
   #
   if {[catch {set table_cursor [oraopen $db_logon_handle]} ora_result]} {
      puts "Encountered error $ora_result while trying to create in_draft_pin_debit merchant cursor handle"
      exit 51
   }
   set in_draft_pin_debit_merch_cursor "in_draft_pin_debit_merch_cursor"
   dict set pin_debit_create_mas_file_dict $in_draft_pin_debit_merch_cursor $table_cursor

   #
   # Open in_draft_pin_debit table transaction cursor
   #
   if {[catch {set table_cursor [oraopen $db_logon_handle]} ora_result]} {
      puts "Encountered error $ora_result while trying to create in_draft_pin_debit transacction cursor handle"
      exit 51
   }
   set in_draft_pin_debit_tran_cursor "in_draft_pin_debit_tran_cursor"
   dict set pin_debit_create_mas_file_dict $in_draft_pin_debit_tran_cursor $table_cursor

   #
   # Open in_draft_pin_debit table transaction update cursor
   #
   if {[catch {set table_cursor [oraopen $db_logon_handle]} ora_result]} {
      puts "Encountered error $ora_result while trying to create in_draft_pin_debit transacction cursor handle"
      exit 51
   }
   set in_draft_pin_debit_tran_update_cursor "in_draft_pin_debit_tran_update_cursor"
   dict set pin_debit_create_mas_file_dict $in_draft_pin_debit_tran_update_cursor $table_cursor

};# end open_db


################################################################################
#
# Procedure Name:  open_output_file
#
# Description:     Opens the output file for writes by the program
# Error Return:    41 [Output file cannot be opened]
#
################################################################################
proc open_output_file {} {

   global pin_debit_create_mas_file_dict

   set output_filename [dict get $pin_debit_create_mas_file_dict output_filename]

   if {[catch {open $output_filename w} file_ptr]} {
       puts stderr "Cannot open file $output_filename for writes by this program."
       exit 41
   }

   set output_file_ptr "output_file_ptr"
   dict set pin_debit_create_mas_file_dict $output_file_ptr $file_ptr

};# end open_output_file


##############################################################################
#
# Procedure Name:  create_mas_file
#
# Description:     Create a MAS file from PIN debit transactions in the
#                  in_draft_pin_debit table.
# Error Return:    54 [Database select operation failed]
#                  62 [Invalid value]
#
################################################################################
proc create_mas_file {} {

   global pin_debit_create_mas_file_dict

   set pin_debit_file_amount 0
   set pin_debit_file_count 0
   set pin_debit_batch_nbr 0
   set run_date_time "[clock format [clock seconds] -format "%Y%m%d%H%M%S"]"

   #
   # Obtain the next pin_debit_export_file_nbr value
   #
   set clr_db_logon_handle [dict get $pin_debit_create_mas_file_dict clr_db_logon_handle]
   set global_seq_ctrl_cursor [dict get $pin_debit_create_mas_file_dict global_seq_ctrl_cursor]
   set global_seq_ctrl_query_seq_name "pin_debit_export_file_nbr"

   set global_seq_ctrl_query "SELECT last_seq_nbr as PIN_DEBIT_EXPORT_FILE_NBR
                                FROM global_seq_ctrl
                               WHERE seq_name = :seq_name_var"

   if {[oraparse $global_seq_ctrl_cursor $global_seq_ctrl_query
        orabind  $global_seq_ctrl_cursor :seq_name_var "$global_seq_ctrl_query_seq_name"
        oraexec  $global_seq_ctrl_cursor ] != 0} {
      write_log_message "global_seq_ctrl_query bind failed with [oramsg $global_seq_ctrl_cursor rc] [oramsg $global_seq_ctrl_cursor error]"
      close_db
      close_log_file
      exit 51
   } else {
      if {[orafetch $global_seq_ctrl_cursor -dataarray global_seq_ctrl_query_1_results -indexbyname] != 1403 } {
         set pin_debit_export_file_nbr [expr $global_seq_ctrl_query_1_results(PIN_DEBIT_EXPORT_FILE_NBR) + 1]

         set global_seq_ctrl_update_query "UPDATE global_seq_ctrl
                                              SET last_seq_nbr = '$pin_debit_export_file_nbr'
                                            WHERE seq_name = '$global_seq_ctrl_query_seq_name'"

         if {[catch {orasql $global_seq_ctrl_cursor $global_seq_ctrl_update_query } ora_err]} {
            oraroll $clr_db_logon_handle
            write_log_message "global_seq_ctrl_update_query update rollback for error $ora_err"
            write_log_message "[oramsg $global_seq_ctrl_cursor all]"
            exit 1
         } else {
            oracommit $clr_db_logon_handle
         }
      } else {
         write_log_message "pin_debit_export_file_nbr was not able to be obtained from global_seq_ctrl_query"
         write_log_message "global_seq_ctrl_query select failed with [oramsg $global_seq_ctrl_cursor rc] [oramsg $global_seq_ctrl_cursor error]"
         close_db
         close_log_file
         exit 54
      }
   }

   #
   # Write the file header record
   #
   set rec_line [format "%2s" [dict get $pin_debit_create_mas_file_dict file_header_type]]
   append rec_line [format "%-2s" [dict get $pin_debit_create_mas_file_dict file_type]]
   append rec_line [format "%-016s" $run_date_time]
   append rec_line [format "%-16s" [dict get $pin_debit_create_mas_file_dict activity_source]]
   append rec_line [format "%-8s" [dict get $pin_debit_create_mas_file_dict activity_job_name]]
   append rec_line [format "%-1s" [dict get $pin_debit_create_mas_file_dict suspend_level]]
   puts [dict get $pin_debit_create_mas_file_dict output_file_ptr] $rec_line

   #
   # Obtain a listing of merchants with PIN debit transactions for processing
   #
   set inst_id [dict get $pin_debit_create_mas_file_dict inst_id]

   set in_draft_pin_debit_select_merch_query "SELECT merch_id as MERCH_ID,
                                                     mid as MID,
                                                     trans_ccd as TRANS_CCD
                                                FROM in_draft_pin_debit
                                               WHERE sec_dest_inst_id = :inst_id_var
                                                 AND pin_debit_export_file_nbr is null
                                                 AND pin_debit_export_file_date is null
                                                 AND mas_file_name is null
                                               GROUP BY merch_id,
                                                        mid,
                                                        trans_ccd
                                               ORDER BY merch_id,
                                                        mid,
                                                        trans_ccd"

   set in_draft_pin_debit_merch_cursor [dict get $pin_debit_create_mas_file_dict in_draft_pin_debit_merch_cursor]

   if {[oraparse $in_draft_pin_debit_merch_cursor $in_draft_pin_debit_select_merch_query
        orabind  $in_draft_pin_debit_merch_cursor :inst_id_var "$inst_id"
        oraexec  $in_draft_pin_debit_merch_cursor ] != 0} {
      write_log_message "in_draft_pin_debit table merchant row not able to be obtained."
      write_log_message "in_draft_pin_debit_select_merch_query bind failed with [oramsg $in_draft_pin_debit_merch_cursor rc] [oramsg $in_draft_pin_debit_merch_cursor error]."
      close_db
      close_log_file
      exit 51
   } else {
      while {[orafetch $in_draft_pin_debit_merch_cursor -dataarray in_draft_pin_debit_select_merch_query_results -indexbyname] != 1403} {
         incr pin_debit_batch_nbr

         #
         # Write the batch header record
         #
         set current_date_time "[clock format [clock seconds] -format "%Y%m%d%H%M%S"]"
         set rec_line [format "%02s" [dict get $pin_debit_create_mas_file_dict batch_header_type]]
         append rec_line [format "%-3s" $in_draft_pin_debit_select_merch_query_results(TRANS_CCD)]
         append rec_line [format "%-016s" $run_date_time]
         append rec_line [format "%-30s" $in_draft_pin_debit_select_merch_query_results(MERCH_ID)]
         append rec_line [format "%09d" $pin_debit_batch_nbr]
         append rec_line [format "%09d" $pin_debit_export_file_nbr]
         append rec_line [format "%1s" [dict get $pin_debit_create_mas_file_dict billing_ind]]
         append rec_line [format "%-9s" " "]
         append rec_line [format "%-9s" " "]
         append rec_line [format "%-25s" " "]
         append rec_line [format "%-25s" " "]
         append rec_line [format "%-25s" $in_draft_pin_debit_select_merch_query_results(MID)]
         append rec_line [format "%-30s" " "]
         append rec_line [format "%-10s" " "]
         append rec_line [format "%-016s" $current_date_time]
         puts [dict get $pin_debit_create_mas_file_dict output_file_ptr] $rec_line

         #
         # Cycle through each set of transactions for the merchant
         #
         set pin_debit_batch_amount 0
         set pin_debit_batch_count 0

         set in_draft_pin_debit_select_tran_query "SELECT amt_trans as AMT_TRANS,
                                                          arn as ARN,
                                                          card_scheme as CARD_SCHEME,
                                                          mas_code as MAS_CODE,
                                                          merch_id as MERCH_ID,
                                                          pin_debit_trans_seq_nbr as EXTERNAL_TRANS_ID,
                                                          tid as TID
                                                     FROM in_draft_pin_debit
                                                    WHERE sec_dest_inst_id = :inst_id_var
                                                      AND pin_debit_export_file_nbr is null
                                                      AND pin_debit_export_file_date is null
                                                      AND mas_file_name is null
                                                      AND merch_id = :merch_id_var
                                                    ORDER BY merch_id,
                                                             pin_debit_trans_seq_nbr"

         set in_draft_pin_debit_tran_cursor [dict get $pin_debit_create_mas_file_dict in_draft_pin_debit_tran_cursor]

         if {[oraparse $in_draft_pin_debit_tran_cursor $in_draft_pin_debit_select_tran_query
              orabind  $in_draft_pin_debit_tran_cursor :inst_id_var "$inst_id" :merch_id_var "$in_draft_pin_debit_select_merch_query_results(MERCH_ID)"
              oraexec  $in_draft_pin_debit_tran_cursor ] != 0} {
            write_log_message "in_draft_pin_debit table tran row not able to be obtained."
            write_log_message "in_draft_pin_debit_select_merch_query bind failed with [oramsg $in_draft_pin_debit_tran_cursor rc] [oramsg $in_draft_pin_debit_tran_cursor error]."
            close_db
            close_log_file
            exit 51
         } else {
            while {[orafetch $in_draft_pin_debit_tran_cursor -dataarray in_draft_pin_debit_select_tran_query_results -indexbyname] != 1403} {
               set pin_debit_batch_amount [expr $pin_debit_batch_amount + $in_draft_pin_debit_select_tran_query_results(AMT_TRANS)]
               set pin_debit_file_amount [expr $pin_debit_file_amount + $in_draft_pin_debit_select_tran_query_results(AMT_TRANS)]
               incr pin_debit_batch_count
               incr pin_debit_file_count

               #
               # Write the transaction detail record
               #
               set rec_line [format "%02s" [dict get $pin_debit_create_mas_file_dict detail_rec_type]]
               append rec_line [format "%-12s" $in_draft_pin_debit_select_tran_query_results(TID)]
               append rec_line [format "%-18s" $in_draft_pin_debit_select_tran_query_results(MERCH_ID)]
               append rec_line [format "%-2s" $in_draft_pin_debit_select_tran_query_results(CARD_SCHEME)]
               append rec_line [format "%-25s" $in_draft_pin_debit_select_tran_query_results(MAS_CODE)]
               append rec_line [format "%-25s" " "]
               append rec_line [format "%010s" 1]
               append rec_line [format "%012d" $in_draft_pin_debit_select_tran_query_results(AMT_TRANS)]
               append rec_line [format "%010d" 0]
               append rec_line [format "%012d" 0]
               append rec_line [format "%010d" 0]
               append rec_line [format "%012d" 0]
               append rec_line [format "%-25s" $in_draft_pin_debit_select_tran_query_results(EXTERNAL_TRANS_ID)]
               append rec_line [format "%-23s" $in_draft_pin_debit_select_tran_query_results(ARN)]
               append rec_line [format "%-2s" " "]
               puts [dict get $pin_debit_create_mas_file_dict output_file_ptr] $rec_line

               #
               # Update the transaction detail record
               #
               set output_filename [dict get $pin_debit_create_mas_file_dict output_filename]
               set in_draft_pin_debit_tran_update_cursor [dict get $pin_debit_create_mas_file_dict in_draft_pin_debit_tran_update_cursor]

               set in_draft_pin_debit_update_query "UPDATE in_draft_pin_debit
                                                       SET pin_debit_export_file_nbr = '$pin_debit_export_file_nbr',
                                                           pin_debit_export_file_date = to_date($run_date_time,'YYYYMMDDHH24MISS'),
                                                           mas_file_name = '$output_filename'
                                                     WHERE pin_debit_trans_seq_nbr = '$in_draft_pin_debit_select_tran_query_results(EXTERNAL_TRANS_ID)'"

               if {[catch {orasql $in_draft_pin_debit_tran_update_cursor $in_draft_pin_debit_update_query } ora_err]} {
                  oraroll $clr_db_logon_handle
                  write_log_message "in_draft_pin_debit_update_query table rollback for error $ora_err"
                  write_log_message "[oramsg $in_draft_pin_debit_tran_update_cursor all]"
                  exit 1
               }
            }
         }

         #
         # Write the batch trailer record
         #
         set rec_line [format "%02s" [dict get $pin_debit_create_mas_file_dict batch_trailer_type]]
         append rec_line [format "%012d" $pin_debit_batch_amount]
         append rec_line [format "%010d" $pin_debit_batch_count]
         append rec_line [format "%010d" 0]
         append rec_line [format "%012d" 0]
         append rec_line [format "%010d" 0]
         append rec_line [format "%012d" 0]
         puts [dict get $pin_debit_create_mas_file_dict output_file_ptr] $rec_line
      }
   }

   #
   # Write the file trailer record
   #
   set rec_line [format "%2s" [dict get $pin_debit_create_mas_file_dict file_trailer_type]]
   append rec_line [format "%012d" $pin_debit_file_amount]
   append rec_line [format "%010d" $pin_debit_file_count]
   append rec_line [format "%010d" 0]
   append rec_line [format "%012d" 0]
   append rec_line [format "%010d" 0]
   append rec_line [format "%012d" 0]
   puts [dict get $pin_debit_create_mas_file_dict output_file_ptr] $rec_line

   oracommit $clr_db_logon_handle

   write_log_message "PIN debit transaction count for $pin_debit_export_file_nbr:  $pin_debit_file_count"

};# create_mas_file


################################################################################
#
# Procedure Name:  close_output_file
#
# Description:     Closes the output file written by the program
# Error Return:    43 [Output file cannot be closed]
#
################################################################################
proc close_output_file {} {

   global pin_debit_create_mas_file_dict

   set output_file_ptr [dict get $pin_debit_create_mas_file_dict output_file_ptr]

   if {[catch {close $output_file_ptr} response]} {
       puts stderr "Cannot close file [dict get $pin_debit_create_mas_file_dict output_filename]."
       exit 43
   }

};# end close_output_file


################################################################################
#
# Procedure Name:  close_db
#
# Description:     Connect to the database and open tables used by the program
# Error Return:    52 [Database disconnect failed]
#
################################################################################
proc close_db {} {

   global clr_db
   global pin_debit_create_mas_file_dict

   #
   # Close global_seq_ctrl table cursor
   #
   set global_seq_ctrl_cursor [dict get $pin_debit_create_mas_file_dict global_seq_ctrl_cursor]
   oraclose $global_seq_ctrl_cursor

   #
   # Close in_draft_pin_debit table merchant cursor
   #
   set in_draft_pin_debit_merch_cursor [dict get $pin_debit_create_mas_file_dict in_draft_pin_debit_merch_cursor]
   oraclose $in_draft_pin_debit_merch_cursor

   #
   # Close in_draft_pin_debit table transaction cursor
   #
   set in_draft_pin_debit_tran_cursor [dict get $pin_debit_create_mas_file_dict in_draft_pin_debit_tran_cursor]
   oraclose $in_draft_pin_debit_tran_cursor

   #
   # Close in_draft_pin_debit table transaction update cursor
   #
   set in_draft_pin_debit_tran_update_cursor [dict get $pin_debit_create_mas_file_dict in_draft_pin_debit_tran_update_cursor]
   oraclose $in_draft_pin_debit_tran_update_cursor

   #
   # Disconnect from the Clearing database
   #
   set clr_db_logon_handle [dict get $pin_debit_create_mas_file_dict clr_db_logon_handle]

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

   global pin_debit_create_mas_file_dict

   set log_file_ptr [dict get $pin_debit_create_mas_file_dict log_file_ptr]

   if {[catch {close $log_file_ptr} response]} {
       write_log_message "Cannot close file [dict get $pin_debit_create_mas_file_dict log_filename]."
       exit 23
   }

};# end close_log_file



##########
## MAIN ##
##########
init_program
open_log_file
read_cfg_file
write_log_message "_____________________________________________"
open_db
open_output_file

create_mas_file

close_output_file
close_db
write_log_message "Successfully ending PIN debit transaction load"
close_log_file
