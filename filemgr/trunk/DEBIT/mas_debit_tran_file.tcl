#!/usr/bin/env tclsh
#/clearing/filemgr/.profile


################################################################################
#
#    File Name - mas_debit_tran_file.tcl
#
#    Description - 
#
#    Arguments - $1 = institution id
#                $2 = short name
#                $3 = run date (YYYYMMDD)
#                $4 = Config file for this script
#                $5 = log file
#                $6 = mail file
#                    
#
#    Return - 0 = Success
#             1 = Fail
#
################################################################################# 
# $Id: mas_debit_tran_file.tcl 3512 2015-09-22 21:33:12Z bjones $
# $Rev: 3512 $
# $Author: bjones $
################################################################################

package require Oratcl

## Enviornment Variable ##
set box $env(SYS_BOX)
set prod_db $env(IST_DB)
set prod_auth_db $env(ATH_DB)
set sysinfo "System: $box \nLocation: $env(PWD) \n\n"

## Global Variable ##
set file_name "mas_debit_tran_file.tcl"
set loc_path "/clearing/filemgr/DEBIT"
set dstn_path "/clearing/filemgr/MAS/MAS_FILES"
set archive_path "$loc_path/ARCHIVE"

################################################################################
#
#    Procedure Name - usage
#
#    Description - Print the script usage
#
###############################################################################
proc usage {} {
   global file_name

   puts "Usage: $file_name <inst id> <short name> <run_date> <config file> <log file> <mailfile>"
   puts "       inst id - Institution ID"
   puts "       short name - short name associated with the institution id to process"
   puts "       run date - Transaction Processing date (YYYYMMDD)"
   puts "       config file - Config file for this script"
   puts "       log file - log file for tracing"
   puts "       mail file - Message to report"
}


################################################################################
#
#    Procedure Name - init
#
#    Description - Initialize program parameters
#
#    Return - exit 1 - error
#
###############################################################################

proc init {argc argv} {
   global inst_id
   global short_name
   global run_date
   global cfg_file
   global cfg_file_ptr
   global log_file
   global log_file_ptr
   global mail_file
   global mail_file_ptr
   global file_name
   global req_type

   set now [clock format [clock seconds] -format {%Y-%m-%d %H:%M:%S}]

   if {$argc < 6} {
      puts "Usage Err: Wrong number of arguments passed\n"
      usage
      exit 1
   }

   set inst_id    [lindex $argv 0]
   set short_name [lindex $argv 1]
   set run_date   [lindex $argv 2]
   set cfg_file   [lindex $argv 3]
   set log_file   [lindex $argv 4]
   set mail_file  [lindex $argv 5]
   set req_type {0260 0262} 
   # sale and refund supported for Acculynk

   if {[catch {open $cfg_file r} cfg_file_ptr]} {
      puts "$file_name: Cannot open config file $cfg_file"
      exit 1
   }

   if {[catch {open $log_file a} log_file_ptr]} {
      puts "$file_name: Cannot open log file $log_file"
      puts "Re-directing logs to stderr"
      set log_file_ptr stderr
   } 
   
   if {[catch {open $mail_file a} mail_file_ptr]} {
      puts "$file_name: Cannot open mail file $mail_file"
   }

   puts $log_file_ptr "##############################################"
   puts $log_file_ptr "Starting $file_name $now"
   puts $log_file_ptr "##############################################"
   puts $log_file_ptr "Instituion ID = $inst_id, \nShort Name = $short_name, \nRun date = $run_date, \nConfig File = $cfg_file, \nLog File = $log_file, \nMail File = $mail_file" 
}; # end of init


################################################################################
#
#    Procedure Name - readCfgFile
#
#    Description - Read config file and intialize program parameters
#                  CARD_TYPE,DB
#
#    Return -
#
###############################################################################
proc readCfgFile {} {
 
   global cfg_file_ptr
   global log_file_ptr
   global card_type
   global card_scheme
   global clr_db_logon
   global auth_db_logon
   global out_file_mask

   while { [set line [gets $cfg_file_ptr]] != {} } {
      set line_parms [split $line ,]
      switch -exact -- [lindex $line_parms 0] {
         "CARD_TYPE" {
            set card_type [lindex $line_parms 1]
         }
         "CARD_SCHEME" {
            set card_scheme [lindex $line_parms 1]
         }
         "CLR_DB_LOGON" {
            set clr_db_logon [lindex $line_parms 1]
         }
         "AUTH_DB_LOGON" {
            set auth_db_logon [lindex $line_parms 1]
         }
         "OUT_FILE_MASK" {
            set out_file_mask [lindex $line_parms 1]
         }
         "MAIL_FILE_MASK" {
            #add TBD
         }
         default {
            puts $log_file_ptr "Unknown config parameter [lindex $line_parms 0]"
         }
      } 
   }

}

################################################################################
#
#    Procedure Name - initOutFile
#
#    Description - initialize the output file 
#                 
#
#    Return - exit 1 when error
#
###############################################################################
proc initOutFile {} {
   global inst_id
   global loc_path
   global log_file_ptr
   global out_file_mask
   global out_file
   global out_file_ptr
   global j_date
   global file_seq_no

   set file_seq_no [format %03d 1]
   set cur_time [clock seconds ]
   set j_date [string range [clock format $cur_time -format "%y%j"] 1 4]

   set out_file "$loc_path/$inst_id.$out_file_mask.01.$j_date.$file_seq_no"

   ## check if the file already exist, if so then increment sequence no
 
   while {[file exists $out_file] != 0} {
      set file_seq_no [format %03d [incr $file_seq_no]] 
      set out_file "$loc_path/$inst_id.$out_file_mask.01.$j_date.$file_seq_no"
   }

   if {[catch {open $out_file {WRONLY CREAT APPEND}} out_file_ptr]} {
      puts $log_file_ptr "Open Err: Cannot open $out_file"
      exit 1
   }
    
}

################################################################################
#
#    Procedure Name - initDB
#
#    Description - Initialize DB connection and handles
#
#    Return - exit 1 when error
#
###############################################################################
proc initDB {} {

   global log_file_ptr
   global clr_db_logon
   global clr_db_logon_handle
   global auth_db_logon
   global auth_db_logon_handle
   global prod_db
   global prod_auth_db
   global tranhistory_tb
   global acq_entity_add_on_tb
   global mas_ntw_tier_fee_tb
   global merchant_tb
   global verify_handle

   ## MASCLR and TIEHOST connection ##
   if {[catch { set clr_db_logon_handle [oralogon $clr_db_logon@$prod_db] } result] } {
      puts $log_file_ptr "Encountered error $result while trying to connect to the $prod_db database "
      exit 1
   }

   if {[catch {set auth_db_logon_handle [oralogon $auth_db_logon@$prod_auth_db]} result ]  } {
      puts $log_file_ptr "Encountered error $result while trying to connect to the $prod_auth_db database "
      exit 1
   }

   if {[catch {
           set tranhistory_tb        [oraopen $auth_db_logon_handle]
           set merchant_tb           [oraopen $auth_db_logon_handle]
           set verify_handle         [oraopen $auth_db_logon_handle]
           set acq_entity_add_on_tb  [oraopen $clr_db_logon_handle]
           set mas_ntw_tier_fee_tb   [oraopen $clr_db_logon_handle]
        } result ]} {
      puts $log_file_ptr "Encountered error $result while creating db handles"
      exit 1
   }

}

################################################################################
#
#    Procedure Name - process
#
#    Description - Fetch mas codes and build the MAS file
#
#    Return - exit 1 when error
#
###############################################################################
proc process {} {

   global log_file_ptr
   global mail_file_ptr
   global out_file
   global out_file_ptr
   global dstn_path
   global archive_path
   global tranhistory_tb
   global merchant_tb
   global acq_entity_add_on_tb
   global mas_ntw_tier_fee_tb
   global verify_handle
   global card_type
   global card_scheme
   global short_name
   global run_date
   global req_type

   set tot_file_amt   0
   set tot_file_item  0
   set tot_batch_amt  0
   set tot_batch_item 0
   set bt_tot_amt     0

   set Accel_ntw    "20"
   set mcc_al       "4511"
   set tier_id_al   "AL"
   set default_tier "0"

   set query "select MMID,
                     MID,
                     VISA_ID,
                     DEBIT_ID
              from merchant
              where mmid in (select mmid from master_merchant
                             where shortname = '$short_name') and
                    debit_id not like ' ' and
                    settle_debit = 'JACC'"

   buildFileHeader

   orasql $merchant_tb $query
   
   while {[orafetch $merchant_tb -dataarray merchant -indexbyname] != 1403} {
      set query "select count(amount) count,
                        sum(amount) sum
                 from tranhistory
                 where mid = '$merchant(MID)' and
                       request_type in (0260,0262) and
                       status is not null and
                       settle_date like '$run_date%' "

      orasql $verify_handle $query

      orafetch $verify_handle -dataarray total -indexbyname

      if {$total(COUNT) != 0} {

         ###
         ### Add the logic for BATCH HEADER
         ###
         buildBatchHeader $merchant(DEBIT_ID) $merchant(MID)

         ### Logic for acq_entitity_add_on

         set query "select acqEntAddon.user_defined_2,
                           acqEntAddon.entity_id,
                           acqEnt.default_mcc
                    from acq_entity acqEnt join acq_entity_add_on acqEntAddon
                         on acqEnt.entity_id = acqEntAddon.entity_id
                    where acqEnt.entity_id in (select entity_id 
                                               from entity_to_auth
                                               where mid = '$merchant(MID)' and
                                               status = 'A')"

         orasql $acq_entity_add_on_tb $query

         orafetch $acq_entity_add_on_tb -dataarray entity -indexbyname


         foreach req $req_type {
            set query "select mid,
                              request_type,
                              amount,
                              ticket_no,
                              other_data2,
                              arn
                       from tranhistory
                       where mid = '$merchant(MID)' and
                             request_type='$req' and
                             card_type='$card_type' and
                             settle_date like '$run_date%' "


            orasql $tranhistory_tb $query

            while {[orafetch $tranhistory_tb -dataarray txn -indexbyname] != 1403} {

               #### fetch the network id from other data2 "CP:1;CL:B ;NI:02;"
               set lcl_rc [regexp {NI:[0-9][0-9]\;} $txn(OTHER_DATA2) match]
               if {$lcl_rc != 0} {
                  set ntw_id [string range $match 3 4]
               } else {
                   set ntw_id "00"
                  puts $log_file_ptr "Could not find network Id, using the default network_id = 00" 
               }

               ##
               ## This logic is specifically for Airline Merchants (MCC) on 
               ## Accel/Exchange network, the mas fees differs for this
               ## category
               ##
               if {$ntw_id == $Accel_ntw} {
                  if {$entity(DEFAULT_MCC) == $mcc_al} {
                     set default_tier $tier_id_al
                  }
               } else {
                  set default_tier $entity(USER_DEFINED_2)
               }

               ## get the mas_code

               set query "select tid_activity,
                                 tid_fee,
                                 mas_code
                          from mas_network_tier_fees
                          where network_id = '$ntw_id' and
                                msg_type = '$req' and
                                tier_id = '$default_tier' "

               orasql $mas_ntw_tier_fee_tb $query

               if {[orafetch $mas_ntw_tier_fee_tb -dataarray mas -indexbyname] 
                   != 0} {
                  set err_msg "Error: Unable to find MAS code from mas_network_tier_fees table for,\n"
                  append err_msg "network=$ntw_id \nrequest=$req \n tierID = $default_tier \nMID = $merchant(MID) ."
                  puts $log_file_ptr $err_msg
                  puts $mail_file_ptr $err_msg

                  exit 1
               }



               # build the message detail
               buildTxnMsg $mas(TID_ACTIVITY) $entity(ENTITY_ID) $mas(MAS_CODE) $txn(AMOUNT) $txn(ARN)
              
               # Get the batch trailer info
               set tot_batch_item [incr tot_batch_item] 
               set tot_batch_amt  [expr $tot_batch_amt + $txn(AMOUNT)]

            }; #endof while loop for each txn
         }; #endof for request type
         set bt_tot_amt [expr wide([expr round($tot_batch_amt * 100)])]
         buildBatchTrailer $bt_tot_amt $tot_batch_item

         ### 
         ### Make sure all the transaction from tranhistory are pushed into 
         ### the MAS file
         ###

         if {$tot_batch_amt != $total(SUM)} {
            set err_msg "Error: Total Batch Amount does not match the Total transaction amount for the merchant\n"
            append err_msg "MID = $merchant(MID) \nTxn Total = $total(SUM) \nBatch Total = $tot_batch_amt ."

            puts $log_file_ptr $err_msg
            puts $mail_file_ptr $err_msg
 
            exit 1
         }

         set tot_file_amt  [expr $tot_file_amt + $tot_batch_amt]
         set tot_file_item [expr $tot_file_item + $tot_batch_item]
         set tot_batch_item 0
         set tot_batch_amt 0
         set bt_tot_amt 0
           
      }; #end of if count != 0

   }; #endof while loop for each merchant ID

   set tot_file_amt [expr wide([expr round($tot_file_amt * 100)])]
   set tot_file_item [expr wide($tot_file_item)]

   buildFileTrailer $tot_file_amt $tot_file_item

   ### Close the file
   close $out_file_ptr

   ###
   ### Copy the file to the location from where its picked up for processing
   ###
   if {[catch {exec cp $out_file $dstn_path} result]} {
      set err_msg "File Copy Error: $out_file $result"
      puts $log_file_ptr $err_msg
      puts $mail_file_ptr $err_msg
      exit 1
   }

   if {[catch {exec mv $out_file $archive_path} result]} {
      puts $log_file_ptr "Unable to move $out_file to ARCHIVE $archive_path"
   } 

   puts $mail_file_ptr "Total Items Processed - $tot_file_item"
   puts $mail_file_ptr "Total Amount - $tot_file_amt"
}

################################################################################
#
#    Procedure Name - buildFileHeader
#
#    Description - Build the file header
#                  And writes to the file
#
#    Return -
#
###############################################################################
proc buildFileHeader {} {

   set now [clock format [clock seconds] -format {%Y%m%d%H%M%S}]

   set txn_type          [format %02s "FH"]
   set file_type         [format %-2s "01"]
   set file_date_time    [format %-016s $now]
   set activity_source   [format %-16s "TTLCSYSTEM"]
   set activity_job_name [format %-8s "ACCULYNK"]
   set suspend_level     [format %-1s "B"]

   append file_hdr $txn_type $file_type $file_date_time $activity_source $activity_job_name $suspend_level

   writeToOutputFile $file_hdr 
}

################################################################################
#
#    Procedure Name - buildFileTrailer
#
#    Description - Build the file trailer
#                  And writes to the file
#
#    Return -
#
###############################################################################
proc buildFileTrailer {amt cnt} {

   set txn_type      [format %02s "FT"]
   set file_amt      [format %012d $amt]
   set file_cnt      [format %010d $cnt]
   set file_add_amt1 [format %012d "0"]
   set file_add_cnt1 [format %010d "0"]
   set file_add_amt2 [format %012d "0"]
   set file_add_cnt2 [format %010d "0"]

   append file_trl  $txn_type $file_amt $file_cnt $file_add_amt1 $file_add_cnt1 $file_add_amt2 $file_add_cnt2

   writeToOutputFile $file_trl 
}


################################################################################
#
#    Procedure Name - buildBatchHeader
#
#    Description - Build the batch header 
#                  And writes to the file
#
#    Return -
#
###############################################################################
proc buildBatchHeader {senderId mid} {
   global loc_path
   global file_seq_no
   global inst_id

   set datetime [clock format [clock seconds] -format {%Y%m%d%H%M%S}]

   set batch_num_file [open "$loc_path/mas_acculynk_batch_num.txt" "r+"]
   gets $batch_num_file bchnum
   seek $batch_num_file 0 start
   if {$bchnum >= 999999999} {
       puts $batch_num_file 1
   } else {
       puts $batch_num_file [expr $bchnum + 1]
   }
   close $batch_num_file

   set txn_type           [format %02s "BH"]
   set batch_curr         [format %-3s "840"] 
   set activity_date_time [format %-016s $datetime]
   set merch_id           [format %-30s $mid] 
   set in_batch_num       [format %09s $bchnum]
   set in_file_num        [format %09s $file_seq_no]
   set bill_ind           [format %1s "N"]
   set orig_batch_id      [format %-9s " "]
   set orig_file_id       [format %-9s " "]
   set ext_batch_id       [format %-25s " "]
   set ext_file_id        [format %-25s " "]
   set sender_id          [format %-25s $senderId] 
   set micro_film_num     [format %-30s " "]
   set bh_inst_id         [format %-10s "$inst_id"] 
   set bh_capture_dt   [format %-016s $datetime] 

   append batch_hdr $txn_type $batch_curr $activity_date_time $merch_id $in_batch_num $in_file_num $bill_ind $orig_batch_id $orig_file_id $ext_batch_id $ext_file_id $sender_id $micro_film_num $bh_inst_id $bh_capture_dt

   writeToOutputFile $batch_hdr
}

################################################################################
#
#    Procedure Name - buildBatchTrailer
#
#    Description - Build the batch trailer
#                  And writes to the file
#
#    Return -
#
###############################################################################
proc buildBatchTrailer {tot_amt tot_item} {

   set txn_type       [format %-2s "BT"]
   set batch_amt      [format %012d $tot_amt]
   set batch_cnt      [format %010d $tot_item]
   set batch_add_amt1 [format %012d "0"]
   set batch_add_cnt1 [format %010d "0"]
   set batch_add_amt2 [format %012d "0"]
   set batch_add_cnt2 [format %010d "0"]

   append batch_trailer $txn_type $batch_amt $batch_cnt $batch_add_amt1 $batch_add_cnt1 $batch_add_amt2 $batch_add_cnt2

   writeToOutputFile $batch_trailer
}

################################################################################
#
#    Procedure Name - buildTxnMsg
#
#    Description - Build the Message Detail section of the file
#                  And writes to the file
#
#    Return -
#
###############################################################################
proc buildTxnMsg {tid entityID mas_cd amt arn} {
   global card_scheme

   set txn_type       [format %02s "01"]  
   set txn_id         [format %-12s $tid]
   set entity_id      [format %-18s $entityID] 
   set card_schm      $card_scheme
   set mas_code       [format %-25s $mas_cd]
   set mas_code_dngrd [format %-25s " "]
   set nbr_of_items   [format %010d 1]
   set amt_org        [format %012d [expr wide(round($amt * 100))]]
   set add_cnt1       [format %010d 0]
   set add_amt1       [format %012d 0]
   set add_cnt2       [format %010d 0]
   set add_amt2       [format %012d 0]
   set ext_txn_id     [format %-25s " "]
   set txn_ref_data   [format %-25s $arn]
   set suspend_rsn    [format %-2s " "]

   append msg_details $txn_type $txn_id $entity_id $card_schm $mas_code $mas_code_dngrd $nbr_of_items $amt_org $add_cnt1 $add_amt1 $add_cnt2 $add_amt2 $ext_txn_id $txn_ref_data $suspend_rsn

   writeToOutputFile $msg_details
}

################################################################################
#
#    Procedure Name - writeToOutputFile
#
#    Description - write the data to the output file
#
#    Return -
#
###############################################################################
proc writeToOutputFile {data} {
   global out_file_ptr

   puts $out_file_ptr $data
}


################################################################################
#
#    Procedure Name - shutdown
#
#    Description - close all the open files and DB handles 
#
#    Return -
#
###############################################################################
proc shutdown {} {
   global file_name
   global cfg_file_ptr
   global log_file_ptr
   global mail_file_ptr
   global out_file_ptr
   global auth_db_logon_handle
   global clr_db_logon_handle
   global tranhistory_tb
   global acq_entity_add_on_tb
   global mas_ntw_tier_fee_tb
   global merchant_tb
   global verify_handle

   puts $log_file_ptr "Shutdown $file_name, exiting...."
   puts $log_file_ptr "##############################################"
 
   # close all the DB connections
   oraclose $tranhistory_tb
   oraclose $acq_entity_add_on_tb
   oraclose $mas_ntw_tier_fee_tb
   oraclose $merchant_tb
   oraclose $verify_handle

   if {[catch {oralogoff $auth_db_logon_handle
               oralogoff $clr_db_logon_handle } result ]} {
      puts $log_file_ptr "Encountered error $result while trying to close DB handles"
   }

   close $cfg_file_ptr
   close $mail_file_ptr
   close $log_file_ptr
}

##########
## MAIN ##
##########
init $argc $argv
readCfgFile
initOutFile
initDB
process
shutdown
exit 0

