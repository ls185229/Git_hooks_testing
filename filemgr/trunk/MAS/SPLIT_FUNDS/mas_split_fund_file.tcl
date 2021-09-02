#!/usr/bin/env tclsh

################################################################################
# $Id: mas_split_fund_file.tcl 4503 2018-03-23 16:02:00Z bjones $
################################################################################
#
#    File Name - mas_split_fund_file.tcl
#
#    Description - This code generates a MAS file to handle split funding
#                  based on a fixed amount. It uses a input file (101MerchList.txt)
#                  to get the merchant info and the amount to debit the merchant.
#                  Once the MAS file is successfully created, it moves it to MAS/MAS_FILES
#                  and saves a copy under SPLIT_FUNDS/ARCHVIE
#
#    Arguments - i = institution id
#                d = settle date (YYYYMMDD) , optional
#                f = input file with holds the merchant info and the amount to split
#                    Example - 101MerchList.txt has the following line:
#                    MERCHANT,101,447474200000204,2000
#                c = Config file for this script, reserved for future use.
#                t = test mode
#                v = increase verbosity (debug level)
#
#    Return - 0 = Success
#             1 = Fail
#
#    Exit - 1 - syntax error/Invalid argument, program error
#           3 - DB error
#
################################################################################

package require Oratcl

source $env(MASCLR_LIB)/masclr_tcl_lib
source $env(MASCLR_LIB)/mas_file_lib

## Environment Variable ##
set box $env(SYS_BOX)
set prod_db $env(IST_DB)
set prod_auth_db $env(ATH_DB)
set sysinfo "System: $box \nLocation: $env(PWD) \n\n"

## Global Variable ##
set programName "[lindex [split [file tail $argv0] .] 0]"
set now [clock format [clock seconds] -format {%Y%m%d%H%M%S}]
set loc_path "/clearing/filemgr/MAS/SPLIT_FUNDS"
set dstn_path "/clearing/filemgr/MAS/MAS_FILES"
set archive_path "$loc_path/ARCHIVE"
set cfg_file "$loc_path/mas_split_fund_file.cfg"
set out_file_mask "SPLITFND"
set split_mas_code "SPLITFUND" ;
set split_tid_D "010005090002"
set split_tid_C "010007090002"
set card_type "00"

global auth_db_logon_handle
global mode

################################################################################
#
#    Procedure Name - usage
#
#    Description - Print the script usage
#
###############################################################################
proc usage {} {
   global programName

   puts "Usage: $programName -i <inst id> -d <settle_date> -f <input file> -c <config file>"
   puts "       inst id - Institution ID"
   puts "       settle date - Transaction settle date (YYYYMMDD)"
   puts "                     Optional Default sysdate"
   puts "                     Reserved for future use"
   puts "       input file  - File that holds the merchant information"
   puts "       config file - Config file for this script, <path/filename>"
   puts "                     Optional, default mas_split_fund_file.cfg"
   puts "    options -v (verbosity) & -t (test mode)"
   puts "Example - $programName.tcl -i 101 -f 101MerchList.txt"
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
   global settle_date
   global cfg_file
   global input_file
   global programName
   global now
   global mode

   set inst_id ""
   set settle_date ""
   set input_file ""

   puts ""
   puts "##############################################"
   puts "Starting $programName.tcl $now"
   puts "##############################################"
  set debug_level 0
  foreach {opt} [split $argv -] {
      switch -exact -- [lindex $opt 0] {
         "i" {
            set inst_id [lrange $opt 1 end]
         }
         "d" {
            set settle_date [lrange $opt 1 end]
         }
         "f" {
            set input_file [lrange $opt 1 end]
         }
         "c" {
            set cfg_file [lrange $opt 1 end]
         }
         "t" {
            set mode "TEST"
         }
         "v" {
            incr debug_level
         }
      }
   }
   set MASCLR::DEBUG_LEVEL $debug_level

   if {$inst_id== ""} {
      puts "ERROR:- Institution id missing"
      usage
      exit 1
   }

   if {$input_file == ""} {
      puts "ERROR:-  Code requires input file that has the list of Entity ID"
      usage
      exit 1
   }

   if {$settle_date == ""} {
      set settle_date [clock format [clock second] -format "%Y%m%d"]
      puts "Settle Date = $settle_date"
   }

   MASCLR::log_message "MASCLR::DEBUG_LEVEL $MASCLR::DEBUG_LEVEL " 1

   puts "Instituion ID = $inst_id,  \nSettle date = $settle_date, \nConfig File = $cfg_file, \nInput File = $input_file"
   puts ""

   ### Read the config file to get DB params
   readCfgFile

   ### Intitalize database variables
   initDB

   ### Read input file to get merchant info
   readInputFile

   ### Initialize the MAS file
   initOutFile

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
   global cfg_file
   global clr_db_logon
   global auth_db_logon
   global programName

   if {[catch {open $cfg_file r} cfg_file_ptr]} {
      puts "$programName: Cannot open config file $cfg_file"
      exit 1
   }

   while { [set line [gets $cfg_file_ptr]] != {} } {
      set line_parms [split $line ,]
      switch -exact -- [lindex $line_parms 0] {
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
   close $cfg_file_ptr

}

################################################################################
#
#    Procedure Name - readInputFile
#
#    Description - intialize merchant id and amount
#
#    Return -
#
###############################################################################
proc readInputFile {} {

   global input_file_ptr
   global input_file
   global programName
   global merch_count
   global merch_instID
   global merch_entityID
   global merch_split_amt
   global merch_split_pct

   set merch_count 0

   if {[catch {open $input_file r} input_file_ptr]} {
      puts "$programName: Cannot open input file $input_file"
      exit 1
   }

   while { [set line [gets $input_file_ptr]] != {} } {
      set line_parms [split $line ,]
      switch -exact -- [lindex $line_parms 0] {
         "MERCHANT" {
            set merch_count [incr merch_count]
            set merch_instID($merch_count) [lindex $line_parms 1]
            set merch_entityID($merch_count) [lindex $line_parms 2]
            set merch_split_amt($merch_count) [lindex $line_parms 3]
            set merch_split_pct($merch_count) [lindex $line_parms 4]
         }
         default {
            puts "Unknown input parameter [lindex $line_parms 0]"
         }
      }
   }

   close $input_file_ptr

}

################################################################################
#
#    Procedure Name - initOutFile
#
#    Description - initialize the output file
#
#    Return - exit 1 when error
#
###############################################################################
proc initOutFile {} {
   global inst_id
   global loc_path
   global archive_path
   global out_file_mask
   global out_file
   global out_file_ptr
   global j_date
   global file_seq_no
   global programName

   set file_seq_no [format %03d 1]
   set cur_time [clock seconds ]
   set j_date [string range [clock format $cur_time -format "%y%j"] 1 4]

   set out_file "$loc_path/$inst_id.$out_file_mask.01.$j_date.$file_seq_no"
   set check_seq_num "$archive_path/$inst_id.$out_file_mask.01.$j_date.$file_seq_no"

   ## check if the file already exist, if so then increment sequence no

   while {[file exists $check_seq_num] != 0} {
      set file_seq_no [format %03d [incr $file_seq_no]]
      set out_file "$loc_path/$inst_id.$out_file_mask.01.$j_date.$file_seq_no"
      set check_seq_num "$archive_path/$inst_id.$out_file_mask.01.$j_date.$file_seq_no"
   }

   if {[catch {open $out_file {WRONLY CREAT APPEND}} out_file_ptr]} {
      puts "Open Err: Cannot open $out_file"
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

   global clr_db_logon
   global clr_db_logon_handle
   global auth_db_logon
   global auth_db_logon_handle
   global prod_db
   global prod_auth_db
   global tranhistory_tb
   global merchant_tb
   global masclr_tb
   global pct_query
   global verify_handle
   global update_handle
   global programName

   ## MASCLR and TIEHOST connection ##
   if {[catch { set clr_db_logon_handle [oralogon $clr_db_logon@$prod_db] } result] } {
      puts "Encountered error $result while trying to connect to the $prod_db database "
      exit 3
   }

   ## if {[catch {set auth_db_logon_handle [oralogon $auth_db_logon@$prod_auth_db]} result ]  } {
   ##    puts "Encountered error $result while trying to connect to the $prod_auth_db database "
   ##    exit 3
   ## }

   if {[catch {
           ## set tranhistory_tb        [oraopen $auth_db_logon_handle]
           ## set merchant_tb           [oraopen $auth_db_logon_handle]
           set masclr_tb      [oraopen $clr_db_logon_handle]
           ## set verify_handle         [oraopen $auth_db_logon_handle]
           ## set update_handle         [oraopen $auth_db_logon_handle]
        } result ]} {
      puts "Encountered error $result while creating db handles"
      exit 3
   }

}

################################################################################
#
#    Procedure Name - process
#
#    Description -
#
#    Return - exit  when error
#
###############################################################################
proc process {} {

   global out_file
   global out_file_ptr
   global dstn_path
   global archive_path
   global settle_date
   global input_file
   global split_mas_code
   global split_tid_D
   global split_tid_C
   global card_type
   global merch_count
   global merch_instID
   global merch_entityID
   global merch_split_amt
   global merch_split_pct
   global programName

   set tot_file_amt   0
   set tot_file_item  0
   set tot_batch_amt  0
   set tot_batch_item 0
   set bt_tot_amt     0
   set batch_cnt      0

   ### Build file header
   buildFileHeader

   for {set count 1} {$count <= $merch_count} {incr count} {
     ### build batch header
     buildBatchHeader "FILEMGR" $merch_entityID($count)

     ####buildTxnMsg $merchant(VISA_ID) $tid $mas_code $txn(CARD_TYPE) $txn(FEE_AMOUNT) $txn(ARN)

     ###puts "T-1 $merch_entityID($count) $split_tid_D $split_mas_code $card_type $merch_split_amt($count)"
     if {[string is double $merch_split_pct($count)]} {
         set merch_split_amt($count) [calc_pct_split $merch_entityID($count) $merch_split_pct($count) $settle_date]
     }
     buildTxnMsg $merch_entityID($count) $split_tid_D $split_mas_code $card_type $merch_split_amt($count) ""

     # Get the batch trailer info
     set tot_batch_item [incr tot_batch_item]
     set tot_batch_amt  [expr $tot_batch_amt + $merch_split_amt($count)]

     ### Build Batch Trailer
     set bt_tot_amt [expr wide([expr round($tot_batch_amt * 100)])]
     buildBatchTrailer $bt_tot_amt $tot_batch_item

     ### Update counters
     set tot_file_amt  [expr $tot_file_amt + $tot_batch_amt]
     set tot_file_item [expr $tot_file_item + $tot_batch_item]
     set batch_cnt [incr batch_cnt]
     set tot_batch_item 0
     set tot_batch_amt 0
     set bt_tot_amt 0

   } ;# end of for loop

   ### Build File Trailer
   set tot_file_amt [expr wide([expr round($tot_file_amt * 100)])]
   set tot_file_item [expr wide($tot_file_item)]

   buildFileTrailer $tot_file_amt $tot_file_item

   close $out_file_ptr

   puts "Total Items Processed - $tot_file_item"
   puts "Total Amount - $tot_file_amt"

   return 1
}

################################################################################
#
#    Procedure Name - calc_pct_split
#
#    Description - Build the file header
#                  And writes to the file
#
#    Return -
#
# INST ENTITY_ID       GL_DATE   ITEMS  AMT R_ITEMS R_AMT S_ITEMS    S_AMT     AMT
# ---- --------------- --------- ----- ---- ------- ----- ------- -------- -------
# 121  418311274020054 17-MAR-18    11 7484       0     0      11 -1272.28 1272.28
#
# 06-mar-18
###############################################################################
proc calc_pct_split {entityID split_pct split_date} {
    global inst_id
    global clr_db_logon
    global clr_db_logon_handle
    global masclr_tb
    global pct_query

    set return_amt 0
    MASCLR::log_message "in calc_pct_split: $entityID $split_pct $split_date" 3

    if {![info exists pct_query]} {
        set pct_query "
            select
                mtl.institution_id inst,
                mtl.entity_id,
                mtl.gl_date,
                mtl.date_to_settle,
                sum(case when ta.major_cat in ('SALES')
                        then 1 else 0 end *
                    mtl.nbr_of_items)                               items,
                sum(case when ta.major_cat in ('SALES')
                        then 1 else 0 end *
                    case when mtl.tid_settl_method = 'C'
                        then 1 else -1 end *
                    mtl.amt_original)                               calc_amt,
                sum(case when ta.major_cat in ('SPLIT_FUNDING')
                        then 1 else 0 end *
                    mtl.nbr_of_items)                               s_items,
                sum(case when ta.major_cat in ('SPLIT_FUNDING')
                        then 1 else 0 end *
                    case when mtl.tid_settl_method = 'C'
                        then 1 else -1 end *
                    mtl.amt_original)                               s_calc_amt,
                :pct                                                s_pct,
                sum(:pct / 100 *
                    case when ta.major_cat in ('SALES')
                        then 1 else 0 end *
                    case when mtl.tid_settl_method = 'C'
                        then 1 else -1 end *
                    mtl.amt_original)                                amt
            from mas_trans_log mtl
            join tid_adn ta
            on ta.tid = mtl.tid
            where institution_id = :inst
            and entity_id = :entity_id
            and ta.major_cat in ('SALES', 'SPLIT_FUNDING')
            and mtl.gl_date = to_date(:run_date, 'YYYYMMDD')
            and (ta.minor_cat is null or ta.minor_cat in ('HELD'))
            group by
                mtl.institution_id, mtl.entity_id, mtl.gl_date, mtl.date_to_settle, :pct
            order by
                mtl.institution_id, mtl.entity_id, mtl.gl_date, mtl.date_to_settle
            "
        MASCLR::log_message "pct_query: \n $pct_query" 5
        oraparse $masclr_tb $pct_query
    }

    MASCLR::log_message "orabind  $masclr_tb :inst $inst_id :entity_id $entityID :run_date $split_date :pct $split_pct" 5
    orabind  $masclr_tb :inst $inst_id :entity_id $entityID :run_date $split_date :pct $split_pct
    oraexec  $masclr_tb
    while {[orafetch $masclr_tb -dataarray sales_split -indexbyname] == 0} {
        set return_amt [expr $return_amt + $sales_split(AMT)]
    }

    return $return_amt
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

   global now
   global programName

   set txn_type          [format %02s "FH"]
   set file_type         [format %-2s "01"]
   set file_date_time    [format %-016s $now]
   set activity_source   [format %-16s "CLEARING"]
   set activity_job_name [format %-8s "SPLITFND"]
   set suspend_level     [format %-1s "T"]

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
   global now

  ### T-1 check if we really need this batch num logic or not
   set batch_num_file [open "$loc_path/batch_num.txt" "r+"]
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
   set activity_date_time [format %-016s $now]
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
   set bh_capture_dt   [format %-016s $now]

   set batch_hdr ""
   append batch_hdr $txn_type $batch_curr $activity_date_time $merch_id
   append batch_hdr $in_batch_num $in_file_num $bill_ind $orig_batch_id
   append batch_hdr $orig_file_id $ext_batch_id $ext_file_id $sender_id
   append batch_hdr $micro_film_num $bh_inst_id $bh_capture_dt

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
proc buildTxnMsg {entityID tid mas_cd card_scheme amt arn} {

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

   set msg_details ""
   append msg_details $txn_type $txn_id $entity_id $card_schm $mas_code
   append msg_details $mas_code_dngrd $nbr_of_items $amt_org $add_cnt1 $add_amt1
   append msg_details $add_cnt2 $add_amt2 $ext_txn_id $txn_ref_data $suspend_rsn

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
   global programName
   global cfg_file_ptr
   global out_file_ptr
   global auth_db_logon_handle
   global clr_db_logon_handle
   global tranhistory_tb
   global merchant_tb
   global verify_handle
   global masclr_tb
   global update_handle

   puts "Shutdown $programName, exiting...."
   puts "##############################################"

   # close all the DB connections
   oraclose $tranhistory_tb
   oraclose $merchant_tb
   oraclose $verify_handle
   oraclose $masclr_tb
   oraclose $update_handle

   if {[catch {oralogoff $auth_db_logon_handle
               oralogoff $clr_db_logon_handle } result ]} {
      puts "Encountered error $result while trying to close DB handles"
   }

   close $cfg_file_ptr
   close $out_file_ptr
}

################################################################################
#
#    Procedure Name - moveFile
#
#    Description - move the file to MAS/MAS_FILE for import
#
#    Return -
#
###############################################################################
proc moveFile {} {
   global out_file
   global dstn_path
   global archive_path

    MASCLR::log_message "MASCLR::DEBUG_LEVEL $MASCLR::DEBUG_LEVEL "

   if {[catch {exec cp $out_file $dstn_path} result]} {
      puts "ERROR: Unable to copy file $out_file to $dstn_path, $result"
      exit 1
   }

   if {[catch {exec mv $out_file $archive_path} result]} {
      puts "ERROR: Unable to move $out_file to ARCHIVE $archive_path"
   }
}

##########
## MAIN ##
##########

init $argc $argv

if { [process] == 1} {
   moveFile
} else {
   puts "Error occured in the procedure - process "
   exit 1
}
puts "######################## END ###########################"
exit 0
