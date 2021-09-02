#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: mas_conv_charge_file.tcl 4920 2019-11-08 18:26:08Z skumar $
# $Rev: 4920 $
# $Author: skumar $
################################################################################
#
#     File Name - mas_conv_charge_file.tcl
#
#     Description - Generates MAS file for Convenience Charge
#
#     Arguments - i = institution ids = short name
#                 d = settle date (YYYYMMDD)
#                 f = input file with holds the MID
#                 c = Config file for this script
#                 l = log file
#                 v = debug level
#     Example - mas_conv_charge_file.tcl -i 107 -s OKDMV -c mas_conv_charge_file.cfg
#
#     Return - 0 = Success
#              1 = Fail
#
#     Exit - 1 - syntax error/Invalid argument
#            2 - Code logic
#            3 - DB error
#
################################################################################

#    c = Config file for this script
package require Oratcl
source $env(MASCLR_LIB)/masclr_tcl_lib

## Enviornment Variable ##
set box $env(SYS_BOX)
set prod_clr_db $env(IST_DB) 
set clr_db_username $env(IST_DB_USERNAME) 
set clr_db_password $env(IST_DB_PASSWORD)
set auth_db_username $env(ATH_DB_USERNAME) 
set auth_db_password $env(ATH_DB_PASSWORD) 
set prod_db $env(IST_DB)
set prod_auth_db $env(ATH_DB)
set sysinfo "System: $box \nLocation: $env(PWD) \n\n"

## Global Variable ##
set programName "[lindex [split [file tail $argv0] .] 0]"
set now [clock format [clock seconds] -format {%Y%m%d%H%M%S}]
set loc_path "/clearing/filemgr/MAS/CONV_CHARGE"
set dstn_path "/clearing/filemgr/MAS/MAS_FILES"
set archive_path "$loc_path/ARCHIVE"
set cfg_file "$loc_path/mas_conv_charge_file.cfg"
set out_file_mask "CONVCHRG"
set mas_code_mask "CONV_CHARGE" ;
set tid_sale    "010003005141"
set tid_refund "010003005143" ;

######################################
# Jobs Times Table Globals - NPP-7450
######################################
set job_script_name "mas_conv_charge_file.tcl"
set job_source "TRANHISTORY"
set job_dest ""
set job_id_seq_gen_name "SEQ_JOB_EVENT_REC_ID"
set tran_id_seq_gen_name "SEQ_TRAN_EVENT_REC_ID"


################################################################################
#
#     Procedure Name - usage
#
#     Description - Print the script usage
#
###############################################################################

proc usage {} {
    global programName

    puts "Usage: $programName -i <inst id> -s <short name> -d <settle_date> "
    puts "         -f <input file> -c <config file> -l <log file> -v <debug level>"
    puts "         "
    puts "         inst id - Institution ID"
    puts "         short name  - short name associated with the institution id to process"
    puts "         settle date - Transaction settle date (YYYYMMDD)"
    puts "                            Optional Default sysdate"
    puts "         input file  - File that holds the MMID for which Convenience file is generated"
    puts "         config file - Config file for this script, <path/filename>"
    puts "                            Optional, default mas_conv_charge_file.cfg"
    puts "         log file    - log file for tracing, Optional"
    puts "         verbosity   - level of debug information output, Optional"
}

proc log_msg {msg {verbosity 0}} {
  global log_fd

  set log_fd ""

  if {[info level] == 1} {
      set caller MAIN
  } else {
      set caller [lrange [info level -1] 0 0]
  }

  if {[info exists log_fd]} {
    puts  "[clock format [clock seconds] -format %Y/%m/%d-%H:%M:%S] $caller - $msg"
    #puts $log_fd "[clock format [clock seconds] -format %Y%m%d%H%M%S] $caller - $msg"
    #flush $log_fd
  }
}

################################################################################
#
#     Procedure Name - init
#
#     Description - Initialize program parameters
#
#     Return - exit 1 - error
#
###############################################################################

proc init {argc argv} {
    global inst_id
    global short_name
    global settle_date
    global end_date
    global cfg_file
    global input_file
    global programName
    global now

    log_msg "Here"

    set inst_id ""
    set short_name ""
    set settle_date ""
    set input_file ""
    #set cfg_file "mas_conv_charge_file.cfg"
    set end_date ""

    puts "##############################################"
    puts "Starting $programName $now"
    puts "##############################################"

  foreach {opt} [split $argv -] {
        switch -exact -- [lindex $opt 0] {
            "i" {
                set inst_id [lrange $opt 1 end]
            }
            "s" {
                set short_name [lrange $opt 1 end]
            }
            "d" {
                set settle_date [lrange $opt 1 end]
            }
            "f" {
                #-f : The -f option has been deprecated.
                # MMID/Card type are retrieved from DB instead of input file.
                set input_file [lrange $opt 1 end]
            }
            "c" {
                #-c : The -f option has been deprecated.
                # DB Params are retrieved from environment variable instead of config file.
            set cfg_file [lrange $opt 1 end]
            
            }
            "v" {
                set MASCLR::DEBUG_LEVEL [lrange $opt 1 end]
            }
        }
    }

    if {$inst_id== ""} {
        puts "ERROR:- Institution id missing"
        usage
        exit 1
    }

    #if {$short_name == ""} {
    #    puts "ERROR:- Short Name missing"
    #    usage
    #    exit 1
    #}

    # if {$input_file == ""} {
    #     puts "ERROR:-  Code requires input file that has the list of MMID"
    #     usage
    #     exit 1
    # }

    if {$settle_date == ""} {
        set settle_date [clock format [clock second] -format "%Y%m%d"]
        set end_date [clock format [ clock scan "$settle_date +1 day" ] -format "%Y%m%d%H%M%S"]
        puts "Settle Date = $settle_date ,  Ending settle date = $end_date "

    } else {
        set end_date [clock format [ clock scan "$settle_date +1 day" ] -format "%Y%m%d%H%M%S"]
        puts "Settle Date = $settle_date ,  Ending settle date = $end_date "
    }

    puts "Instituion ID = $inst_id, \nShort Name = $short_name, "
    #puts "Settle date = $settle_date, \nConfig File = $cfg_file, "
    puts "Settle date = $settle_date "
    #puts "Input File = $input_file"

    if {$MASCLR::DEBUG_LEVEL != 0} {
        puts "Verbosity (debug) level = $MASCLR::DEBUG_LEVEL"
    }
    
    # The readCfgFile method is deprecated as the
    # DB params are retreived from environment variables
    # instead of config files.
    ### Read the config file to get DB params
    #readCfgFile

    ### Intitalize database variables
    initDB

    ### Initialize the MAS file
    initOutFile

}; # end of init


################################################################################
#
#     Procedure Name - readCfgFile
#
#     Description - Read config file and intialize program parameters
#                        CARD_TYPE,DB
#
#     Return -
#
###############################################################################
proc readCfgFile {} {

   global cfg_file_ptr
   global cfg_file
#    global cfg_file_ptr
#    global cfg_file
#    global clr_db_logon
#    global auth_db_logon
#    global programName

#    log_msg "Here"

#    if {[catch {open $cfg_file r} cfg_file_ptr]} {
#        puts "$programName: Cannot open config file $cfg_file"
#        exit 1
#    }

#    while { [set line [gets $cfg_file_ptr]] != {} } {
#        set line_parms [split $line ,]
#        switch -exact -- [lindex $line_parms 0] {
#            "CLR_DB_LOGON" {
#                set clr_db_logon [lindex $line_parms 1]
#            }
#            "AUTH_DB_LOGON" {
#                set auth_db_logon [lindex $line_parms 1]
#            }
#            default {
#                puts "Unknown config parameter [lindex $line_parms 0]"
#            }
#        }
#    }

}

################################################################################
#
#     Procedure Name - readInputFile
#
#     Description - Read input file and intialize merchant parameters
#
#     Return -
#
###############################################################################

#proc readInputFile {line} {

#    global programName
#    global mmid
#    global card_type

#    set cnt 0
#    set line_parms [split $line ,]
#    set card_type ""

#    log_msg "Here"

#    foreach line_parms [split $line ,] {
#        switch -exact -- [lindex $line_parms 0] {
#            "MMID" {
#                 set mmid [lindex $line_parms 1]
#            }
#            "CARD" {
#                 foreach type [lrange $line_parms 1 end] {
#                     append card_type "\'$type\',"
#                 }
#                 set card_type [string trimright $card_type ,]
#            }
#        }
#    }
# }

################################################################################
#
#     Procedure Name - initOutFile
#
#     Description - initialize the output file
#
#     Return - exit 1 when error
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
    global settle_date
    global file_seq_no
    global programName

    log_msg "Here"

    set file_seq_no [format %03d 1]
    set cur_time [clock seconds ]
    set j_date [string range [clock format $cur_time -format "%y%j"] 1 4]
    set this_date [clock format [clock second] -format "%Y%m%d"]

    set data_jdate ""
    if {$this_date != $settle_date } {
        set temp_jdate [clock scan $settle_date -format "%Y%m%d" ]
        set data_jdate [clock format $temp_jdate -format "%y%j"]
        set data_jdate [string range $data_jdate 1 end]
        append  data_jdate "."
    }

    set out_file "$loc_path/$inst_id.$out_file_mask.01.$j_date.$data_jdate$file_seq_no"
    set check_seq_num "$archive_path/$inst_id.$out_file_mask.01.$j_date.$data_jdate$file_seq_no"

    ## check if the file already exist, if so then increment sequence no

    while {[file exists $check_seq_num] != 0} {
        set file_seq_no [format %03d [incr $file_seq_no]]
        set out_file "$loc_path/$inst_id.$out_file_mask.01.$j_date.$data_jdate$file_seq_no"
        set check_seq_num "$archive_path/$inst_id.$out_file_mask.01.$j_date.$data_jdate$file_seq_no"
    }

    if {[catch {open $out_file {WRONLY CREAT APPEND}} out_file_ptr]} {
        puts "Open Err: Cannot open $out_file"
        exit 1
    }

}

################################################################################
#
#     Procedure Name - initDB
#
#     Description - Initialize DB connection and handles
#
#     Return - exit 1 when error
#
###############################################################################

proc initDB {} {

    global clr_db_username
    global clr_db_password
    global clr_db_logon_handle
   global auth_db_logon
    global auth_db_username
    global auth_db_password
    global auth_db_logon_handle
    global prod_clr_db
    global prod_auth_db
    global tranhistory_tb
    global merchant_tb
    global in_draft_main_tb
    global verify_handle
    global update_handle
    global programName
   # Database Handles - NPP-7450
   global jte_job_id_crsr
   global jte_job_insert_crsr
   global jte_job_update_crsr 
   global jte_tran_insert_crsr
   global jte_trans_other4_crsr

    log_msg "Here"

    ## MASCLR and TEIHOST connection ##
    # DB Params are retrieved from environment variables instead of config file.

    if {[catch {set clr_db_logon_handle [oralogon $clr_db_username/$clr_db_password@$prod_clr_db]} ora_result] } {
        puts "Encountered error $result while trying to connect to the $prod_db database "
        exit 3
    }

    if {[catch {set auth_db_logon_handle [oralogon $auth_db_username/$auth_db_password@$prod_auth_db]} result ]  } {
        puts "Encountered error $result while trying to connect to the $prod_auth_db database "
        exit 3
    }

    if {[catch {
                set tranhistory_tb      [oraopen $auth_db_logon_handle]
                set merchant_tb         [oraopen $auth_db_logon_handle]
                set in_draft_main_tb    [oraopen $clr_db_logon_handle]
                set verify_handle       [oraopen $auth_db_logon_handle]
                set update_handle       [oraopen $auth_db_logon_handle]
           set jte_job_id_crsr        [oraopen $auth_db_logon_handle]
           set jte_job_insert_crsr    [oraopen $auth_db_logon_handle]
           set jte_job_update_crsr    [oraopen $auth_db_logon_handle]
           set jte_tran_insert_crsr   [oraopen $auth_db_logon_handle]
           set jte_trans_other4_crsr  [oraopen $auth_db_logon_handle]
            } result ]} {
        puts "Encountered error $result while creating db handles"
        exit 3
    }
   # Jobs Times Table Cursors - NPP-7450
   set jte_job_id_crsr        [oraopen $auth_db_logon_handle]
   set jte_job_insert_crsr    [oraopen $auth_db_logon_handle]
   set jte_job_update_crsr    [oraopen $auth_db_logon_handle]
   set jte_tran_insert_crsr   [oraopen $auth_db_logon_handle]
   set jte_trans_other4_crsr  [oraopen $auth_db_logon_handle]

}

################################################################################
#
#     Procedure Name - process
#
#     Description -
#
#     Return - exit  when error
#
###############################################################################

proc process {} {

    global out_file
    global out_file_ptr
    global dstn_path
    global archive_path
    global tranhistory_tb
    global merchant_tb
    global in_draft_main_tb
    global verify_handle
    global update_handle
    global short_name
    global settle_date
    global end_date
    global input_file
    global mas_code_mask
    global tid_sale
    global tid_refund
    global mmid
    global card_type
    global programName
    global auth_db_logon_handle
    global select_query 

    log_msg "Here"
    append settle_date "000000"
    set tot_file_amt   0
    set tot_file_item  0
    set tot_batch_amt  0
    set tot_batch_item 0
    set bt_tot_amt     0
    set batch_cnt      0

    set card  "00"

    buildFileHeader

    set select_query "
        select
            m.MMID, m.MID, m.VISA_ID, t.REQUEST_TYPE, t.CARD_TYPE, t.AMOUNT,
            t.FEE_AMOUNT, t.ARN, t.OTHER_DATA4, t.CURRENCY_CODE
        from merchant m
        join master_merchant mm
        on mm.mmid = m.mmid
        join tranhistory t
        on t.mid = m.mid
        where m.status = 'A'
        and t.status <> 'CNV'
        and t.status <> 'CNA'
        and t.status is not null
        and mm.shortname = '$short_name'
        and t.settle_date between '$settle_date' and '$end_date'
        order by m.visa_id, t.shipdatetime"

    MASCLR::log_message "query:\n\n$select_query\n\n" 3

    orasql $merchant_tb $select_query

    set curr_mid ""
    
    while {[orafetch $merchant_tb -dataarray merchant_txn -indexbyname] != 1403} {

        if {$curr_mid != $merchant_txn(MID)} {
            closeBatch $bt_tot_amt $tot_batch_amt $tot_batch_item
            set curr_mid $merchant_txn(MID)
            set batch_cnt [incr batch_cnt]
            set bt_tot_amt      0
            set tot_batch_amt   0
            set tot_batch_item  0

            ### Build Batch Header
            buildBatchHeader $merchant_txn(VISA_ID) $merchant_txn(MID) $merchant_txn(CURRENCY_CODE)
        }

        switch -exact -- $merchant_txn(CARD_TYPE) {
            "VS"        {set card "04" }
            "MC"        {set card "05" }
            "DS"        {set card "08" }
            "DB"        {set card "02" }
            "AX"        {set card "03" }
            default     {set card "00" }
        } ; # End of switch card type
        set mas_code "$card$mas_code_mask"

        switch -exact -- [string range $merchant_txn(REQUEST_TYPE) 0 1] {
            "02"        {set tid $tid_sale }
            "04"        {set tid $tid_refund }
            default     {set tid $tid_sale }
        } ; # End of switch request type

        ### built the message detail
        buildTxnMsg $merchant_txn(VISA_ID) $tid $mas_code $card $merchant_txn(FEE_AMOUNT) $merchant_txn(ARN)

        # Get the batch trailer info
        incr tot_batch_item
        set tot_batch_amt  [expr $tot_batch_amt + $merchant_txn(FEE_AMOUNT)]

        ### Update counters
        incr tot_file_item
        set tot_file_amt  [expr $tot_file_amt + $merchant_txn(FEE_AMOUNT)]

        # NPP-7450 ->
        insert_tran_event $merchant_txn(OTHER_DATA4)
        # NPP-7450 <-

    } ; #end of while for all MID from merchant
    closeBatch $bt_tot_amt $tot_batch_amt $tot_batch_item

    updateStatus

    ### Build File Trailer
    set tot_file_amt [expr wide([expr round($tot_file_amt * 100)])]
    set tot_file_item [expr wide($tot_file_item)]

    buildFileTrailer $tot_file_amt $tot_file_item

    puts "Total Items Processed - $tot_file_item"
    puts "Total Amount - $tot_file_amt"

    return 1
}

proc closeBatch {bt_tot_amt tot_batch_amt tot_batch_item} {

     if {$tot_batch_amt != 0 || $tot_batch_item != 0} {
        ### Build Batch Trailer
        puts "bt_tot_amt=$bt_tot_amt, tot_batch_amt=$tot_batch_amt, tot_batch_item=$tot_batch_item"
        set bt_tot_amt [expr wide([expr round($tot_batch_amt * 100)])]
        
        buildBatchTrailer $bt_tot_amt $tot_batch_item
     }

}

################################################################################
#
#     Procedure Name - updateStatus
#
#     Description - updates status of teihost.tranhistory in database to prevent duplicate entries
#
#     Return -
#
###############################################################################

proc updateStatus {} {
    global update_handle
    global merchant_tb
    global select_query
    global auth_db_logon_handle
    
    #log to log file 
    log_msg "Here"
     
    # Query to update status in DB 
    set update_query "
        UPDATE tranhistory
        SET status = 
            CASE
                WHEN status = 'AMX' THEN 'CNA'
                ELSE 'CNV'
            END
        WHERE arn = :arn
        AND other_data4 = :other_data4"
        
    # Send the update query statement to the DB to be parsed. 
    if { [catch {oraparse $update_handle $update_query} result]} {
        puts "ERROR: - Unsuccessful parsing of the update query."
        puts "ERROR: $result"
        exit 3
    }
    
    orasql $merchant_tb $select_query
    
    # Update status in teihost.tranhistory. Return code 1403 means there are no more rows to fetch
    while {[orafetch $merchant_tb -dataarray arr -indexbyname] != 1403} {
        # Bind relevant variables to update query statement  
        if { [catch {orabind $update_handle :arn $arr(ARN) :other_data4 $arr(OTHER_DATA4)} result]} {
            switch $result {
                "1003" {
                    puts "ERROR: orabind command unsuccessful."
                    puts "Return code 1003: Binding placeholders do not match 
                        the parsed SQL or the SQL statement has not been parsed."
                }
                "1008" {
                    puts "ERROR: orabind command unsuccessful."
                    puts "Return code 1008: Not all SQL bind variables have been specified."
                }
                default {
                    puts "ERROR: orabind command unsuccessful."
                    puts "ERROR: $result"
                }
            }
            exit 3
        }
        
        # print to log full text of update query (with bind variables replaced)
        set stmt [string map [list :arn $arr(ARN) :other_data4 $arr(OTHER_DATA4)] $update_query]
        puts "\nupdate query: $stmt"
        
        # execute query 
        if { [catch {oraexec $update_handle } result] } {
            puts "ERROR:- oraexec command unsuccessful. Query did not alter DB."
            puts "query - $query_text, ERROR:- $result"
            exit 3
        }
     }
    #commit status changes to database 
    log_msg "Commit changes to database"
    oracommit $auth_db_logon_handle

}

################################################################################
#
#     Procedure Name - buildFileHeader
#
#     Description - Build the file header
#                        And writes to the file
#
#     Return -
#
###############################################################################

proc buildFileHeader {} {

    global now
    global programName

    log_msg "Here"

    set txn_type           [format %02s "FH"]
    set file_type          [format %-2s "01"]
    set file_date_time     [format %-016s $now]
    set activity_source    [format %-16s "TTLCSYSTEM"]
    set activity_job_name  [format %-8s "CONVCHRG"]
    set suspend_level      [format %-1s "T"]

    append file_hdr $txn_type $file_type $file_date_time $activity_source $activity_job_name $suspend_level

    writeToOutputFile $file_hdr
}

################################################################################
#
#     Procedure Name - buildFileTrailer
#
#     Description - Build the file trailer
#                        And writes to the file
#
#     Return -
#
###############################################################################

proc buildFileTrailer {amt cnt} {

    set txn_type        [format %02s "FT"]
    set file_amt        [format %012d $amt]
    set file_cnt        [format %010d $cnt]
    set file_add_amt1   [format %012d "0"]
    set file_add_cnt1   [format %010d "0"]
    set file_add_amt2   [format %012d "0"]
    set file_add_cnt2   [format %010d "0"]

    log_msg "Here"

    append file_trl  $txn_type $file_amt $file_cnt $file_add_amt1 $file_add_cnt1 $file_add_amt2 $file_add_cnt2

    writeToOutputFile $file_trl
}

################################################################################
#
#     Procedure Name - buildBatchHeader
#
#     Description - Build the batch header
#                        And writes to the file
#
#     Return -
#
###############################################################################

proc buildBatchHeader {senderId mid curr_code} {
    global loc_path
    global file_seq_no
    global inst_id
    global now

    log_msg "Here"

    set batch_num_file [open "$loc_path/mas_conv_charge_batch_num.txt" "r+"]
    gets $batch_num_file bchnum
    seek $batch_num_file 0 start
    if {$bchnum >= 999999999} {
        puts $batch_num_file 1
    } else {
        puts $batch_num_file [expr $bchnum + 1]
    }
    close $batch_num_file

    set txn_type             [format %02s "BH"]
    set batch_curr           [format %-3s "$curr_code"]
    set activity_date_time   [format %-016s $now]
    set merch_id             [format %-30s $mid]
    set in_batch_num         [format %09s $bchnum]
    set in_file_num          [format %09s $file_seq_no]
    set bill_ind             [format %1s "N"]
    set orig_batch_id        [format %-9s " "]
    set orig_file_id         [format %-9s " "]
    set ext_batch_id         [format %-25s " "]
    set ext_file_id          [format %-25s " "]
    set sender_id            [format %-25s $senderId]
    set micro_film_num       [format %-30s " "]
    set bh_inst_id           [format %-10s "$inst_id"]
    set bh_capture_dt        [format %-016s $now]

    append batch_hdr $txn_type $batch_curr $activity_date_time $merch_id $in_batch_num
    append batch_hdr $in_file_num $bill_ind $orig_batch_id $orig_file_id $ext_batch_id
    append batch_hdr $ext_file_id $sender_id $micro_film_num $bh_inst_id $bh_capture_dt

    writeToOutputFile $batch_hdr
}

################################################################################
#
#     Procedure Name - buildBatchTrailer
#
#     Description - Build the batch trailer
#                        And writes to the file
#
#     Return -
#
###############################################################################

proc buildBatchTrailer {tot_amt tot_item} {

    set txn_type         [format %-2s "BT"]
    set batch_amt        [format %012d $tot_amt]
    set batch_cnt        [format %010d $tot_item]
    set batch_add_amt1   [format %012d "0"]
    set batch_add_cnt1   [format %010d "0"]
    set batch_add_amt2   [format %012d "0"]
    set batch_add_cnt2   [format %010d "0"]

    log_msg "Here"

    append batch_trailer $txn_type $batch_amt $batch_cnt $batch_add_amt1 $batch_add_cnt1 $batch_add_amt2 $batch_add_cnt2

    writeToOutputFile $batch_trailer
}

################################################################################
#
#     Procedure Name - buildTxnMsg
#
#     Description - Build the Message Detail section of the file
#                        And writes to the file
#
#     Return -
#
###############################################################################

proc buildTxnMsg {entityID tid mas_cd card_scheme fee_amt arn} {

    set txn_type         [format %02s "01"]
    set txn_id           [format %-12s $tid]
    set entity_id        [format %-18s $entityID]
    set card_schm        $card_scheme
    set mas_code         [format %-25s $mas_cd]
    set mas_code_dngrd   [format %-25s " "]
    set nbr_of_items     [format %010d 1]
    set amt_org          [format %012d [expr wide(round($fee_amt * 100))]]
    set add_cnt1         [format %010d 0]
    set add_amt1         [format %012d 0]
    set add_cnt2         [format %010d 0]
    set add_amt2         [format %012d 0]
    set ext_txn_id       [format %-25s " "]
    set txn_ref_data     [format %-25s $arn]
    set suspend_rsn      [format %-2s " "]

    log_msg "Here"

    set msg_details ""
    append msg_details $txn_type $txn_id $entity_id $card_schm $mas_code $mas_code_dngrd
    append msg_details $nbr_of_items $amt_org $add_cnt1 $add_amt1 $add_cnt2 $add_amt2
    append msg_details $ext_txn_id $txn_ref_data $suspend_rsn

    writeToOutputFile $msg_details
}

################################################################################
#
#     Procedure Name - writeToOutputFile
#
#     Description - write the data to the output file
#
#     Return -
#
###############################################################################

proc writeToOutputFile {data} {
    global out_file
    global out_file_ptr

    log_msg "Here <$out_file>"

    puts $out_file_ptr $data
}

################################################################################
#
#     Procedure Name - shutdown
#
#     Description - close all the open files and DB handles
#
#     Return -
#
###############################################################################

proc shutdown {} {
    global programName
    #global cfg_file_ptr
    global out_file_ptr
    global auth_db_logon_handle
    global clr_db_logon_handle
    global tranhistory_tb
    global merchant_tb
    global verify_handle
    global in_draft_main_tb
    global update_handle

    log_msg "Here"

    puts "Shutdown $programName, exiting...."
    puts "##############################################"

    # close all the DB connections
    oraclose $tranhistory_tb
    oraclose $merchant_tb
    oraclose $verify_handle
    oraclose $in_draft_main_tb
    oraclose $update_handle

    if {[catch {oralogoff $auth_db_logon_handle oralogoff $clr_db_logon_handle } result ]} {
        puts "Encountered error $result while trying to close DB handles"
    }

    #close $cfg_file_ptr
}

################################################################################
#
#     Procedure Name - moveFile
#
#     Description - move the file to MAS/MAS_FILE for import
#
#     Return -
#
###############################################################################

proc moveFile {} {
    global out_file
    global out_file_ptr
    global dstn_path
    global archive_path

    log_msg "Here"

    close $out_file_ptr
    if {[catch {exec cp $out_file $dstn_path} result]} {
        puts "ERROR: Unable to copy file $out_file to $dstn_path, $result"
        exit 1
    }

    if {[catch {exec mv $out_file $archive_path} result]} {
        puts "ERROR: Unable to move $out_file to ARCHIVE $archive_path"
    }
}

################################################################################
#
#     Procedure Name - cleanup
#
#     Description - Cleanup the output file
#
#     Return -
#
###############################################################################

proc cleanup {} {
    global out_file
    global out_file_ptr
    global dstn_path
    global archive_path
    global auth_db_logon_handle

    log_msg "Here"

    oraroll $auth_db_logon_handle

    close $out_file_ptr

    if {[catch {exec mv $out_file $archive_path} result]} {
        puts "ERROR: Unable to move $out_file to ARCHIVE $archive_path"
    }

}


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
   
    set update_job_end_sql "UPDATE Transaction_Jobs 
                            set End_Time = CURRENT_TIMESTAMP
                            where job_id = '$job_id'"

    if { [catch {orasql $jte_job_update_crsr $update_job_end_sql} failure ] } {
       puts "Job End Event SQL Update Failure: $failure"
    }

};# update_job_start_record
# NPP-7450 <-

##########
## MAIN ##
##########

init $argc $argv

# NPP-7450 ->
generate_job_id
insert_job_record_start
# NPP-7450 <-

if { [process] == 1} {
    oracommit $auth_db_logon_handle
    moveFile
} else {
    cleanup
}

# NPP-7450 ->
update_job_record_end
oracommit $auth_db_logon_handle
# NPP-7450 <-

shutdown
exit 0
