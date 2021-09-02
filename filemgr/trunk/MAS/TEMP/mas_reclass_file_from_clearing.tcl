#!/usr/bin/env tclsh
# ###############################################################################
# $Id: mas_file_from_clearing.tcl 4868 2019-06-25 21:49:37Z skumar $
# $Rev: 4868 $
# ###############################################################################
#
# File Name:  mas_reclass_file_from_clearing.tcl
#
# Description:  This script creates the reclass file from clearing
#
# Running options:
#
#    Arguments - i = institution id (Required)
#                d = date in YYYYMMDD format (optional)
#                f = Missed in_file_nbr list file name (optional)
#                v = debug level (optional)
#    Example - mas_reclass_file_from_clearing.tcl -i 107 -d 20161026
#
#    Return - 0 = Success
#             1 = Fail
#
#    Exit - 1 - syntax error/Invalid argument
#           2 - Code logic
#           3 - DB error
#
# ###############################################################################

package require Oratcl
package provide random 1.0
lappend auto_path $env(MASCLR_LIB)
package require GetOpts 1.1

source $env(MASCLR_LIB)/masclr_tcl_lib
source $env(MASCLR_LIB)/mas_file_lib
global MODE
set MODE "PROD"

proc usage {} {
    global programName
    puts stderr "Usage: $programName -i inst_id -d <YYYYMMDD> -t -v"
    puts stderr "       i - Institution ID"
    puts stderr "       d - date"
    puts stderr "       v - verbosity level of debug information output"
    exit 1
};

# Procedure to Parse the command line arguments
proc arg_parse {} {
    global argv argv0 MODE cfgname
    global opt_type mailtolist inst_id currdate
    set inst_id ""
    set currdate "[clock format [clock seconds] -format "%Y%m%d"]"
    while { [ set err [ getopt $argv "hi:d:f:tv" opt optarg ]] } {
        if { $err < 0 } then {
            MASCLR::log_message "error: $argv0 : opt $opt, optarg: $optarg "
            usage
            exit 1
        } else {
            MASCLR::log_message "opt: $opt, optarg: $optarg" 1
            switch -exact $opt {
               i {set inst_id $optarg}
               d {set currdate $optarg}
               t {
                   set mailtolist "clearing@jetpay.com"
                   set MODE "TEST"
                 }
               v {incr MASCLR::DEBUG_LEVEL}
               f {set cfgname $optarg}
               h {
                    usage
                    exit 1
                }
            }
        }
    }
};

#Procedure to read the file
proc readFile {} {
    global file_list programName cfgname

    if {[catch {open $cfgname} filePtr]} {
        puts "File Open Err in : $programName Cannot open the config file $cfgname"
        exit 2
    }
    set file_list [gets $filePtr]
    while { [set line [gets $filePtr]] != {}} {
        append file_list "," $line
    }

    close $filePtr
};

#Procedure to create database login handle
proc connect_to_dbs {} {
    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year db_logon_handle db_login_handle
    global box clrpath maspath
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global db_userid db_pwd

    if {[catch {set db_login_handle [oralogon $db_userid/$db_pwd@$clrdb]} result]} {
        set mbody "$clrdb failed to open database handle"
        MASCLR::log_message "$mbody"
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        MASCLR::close_all_and_exit_with_code 1
    }
};

#Procedure to open the database connection handle
proc open_cursor_masclr {cursr} {
    global db_login_handle
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global $cursr

    if {[catch {set $cursr [oraopen $db_login_handle]} result]} {
        set mbody "$cursr failed to open statement handle"
        MASCLR::log_message "$mbody"
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        MASCLR::close_all_and_exit_with_code 1
    }
};

#Procedure to initialize the variables during the startup
proc init {} {
    global fname dot jdate batchtime currdate
    global e_date n_date lydate
    global rightnow
    set e_date [string toupper [clock format [ clock scan "$currdate -1 day" ] -format %d-%b-%y]]
    set n_date [string toupper [clock format [ clock scan "$currdate -0 day" ] -format %d-%b-%y]]
    set lydate [clock format [ clock scan "$currdate" ] -format %m]
    set rightnow [clock seconds]
    set rightnow [clock format $rightnow -format "%Y%m%d%H%M%S"]
    set jdate [ clock scan "$currdate"  -base [clock seconds] ]
    set jdate [clock format $jdate -format "%y%j"]
    set jdate [string range $jdate 1 end]
    MASCLR::log_message "Julian date $jdate" 3

    set batchtime $rightnow
    MASCLR::log_message "Transaction count between $e_date :: $n_date"  3
};

#Procedure to create the output file name
proc get_outfile {} {
    global inst_id
    global fname jdate 

    #set fname "REVERSAL"
    set fname "VSMCRCLS"
    set outfile [exec build_filename.py -i $inst_id -f $fname -j $jdate ]
    #Opening Output file to write to
    MASCLR::log_message "File name: $outfile" 3
    return $outfile
};

#Procedure to control Batch numbers for Mas file
proc pbchnum {} {
    global env
    # get and bump the file number
    set batch_num_file [open "$env(PWD)/mas_batch_num.txt" "r+"]
    gets $batch_num_file bchnum
    seek $batch_num_file 0 start
    if {$bchnum >= 999999999} {
        MASCLR::log_message "Batch no: $batch_num_file 1"
    } else {
        MASCLR::log_message "Batch no: $batch_num_file [expr $bchnum + 1]" 3

    }
    close $batch_num_file
    MASCLR::log_message "Using batch seq num: $bchnum" 3
    return $bchnum
};

proc set_inst_curr_code {} {
    global inst_cur_sql inst_id clr_get inst_cur_cd
    set inst_cur_sql "
    select INST_CURR_CODE from INSTITUTION where INSTITUTION_ID = '$inst_id'"
    orasql $clr_get $inst_cur_sql
    while {[set loop [orafetch $clr_get -dataarray i -indexbyname]] == 0} {
        set inst_cur_cd $i(INST_CURR_CODE)
    }
    MASCLR::log_message "INSTITUTION : $inst_id Currency code : $inst_cur_cd" 3
};

#Procedure to create SQL query
proc get_missed_txn_sql {} {
    global get_ent inst_id file_list
    set get_ent "
       select 
            SEC_DEST_INST_ID        SRC_INST_ID,
            MERCH_ID,
            MERCH_NAME,
            AMT_TRANS,
            TRANS_CCD,
            CARD_SCHEME,
            ARN,
            case tid 
            when '010103005101' then '010033005101'
            when '010103005102' then '010033005102'
            end tid,
            TRANS_SEQ_NBR,
            MAS_CODE as MAS_CODE_DOWNGRADE,
            '0103AX' as MAS_CODE
        from in_draft_main 
        where
        card_scheme = '03' 
        and in_file_nbr in ($file_list)
		and src_inst_id = '$inst_id'
        order by in_file_nbr
;"
};
# ######################################################################################################################

#Environment variables.......
global db_userid db_pwd
set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(IST_DB)
set authdb $env(ATH_DB)
set db_userid $env(IST_DB_USERNAME)
set db_pwd $env(IST_DB_PASSWORD)
global programName

set programName [file tail $argv0]
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

################################################################################
### MAIN
################################################################################
proc main {} {
    global cfgname file_list
    set cfgname ""
    set file_list ""
    arg_parse
    #sql logon handles #################################################

    connect_to_dbs
    open_cursor_masclr clr_get
    open_cursor_masclr clr_get1

    #Initialisation############################
    init
    set y 0
    #Opening Output file to write to
    global outfile MODE env programName
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo

    set outfile [get_outfile]

    if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
        set mbody "Cannot open /create : $fileid in $programName"
        MASCLR::log_message $mbody
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        MASCLR::close_all_and_exit_with_code 1
    }

    global rightnow batchtime get_ent clr_get clr_get1 inst_cur_cd
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo mbody
    global anomaly_list val inst_id

    set anomaly_list [dict create]

    ###### Writing File Header into the Mas file
    set rec(file_date_time) $rightnow
    set rec(activity_source) "JETPAYLLC"
    set rec(activity_job_name) "MAS"

    global cfgname file_list
    if { [ string length $cfgname] != 0 } {
        readFile
    }

    write_fh_record $fileid rec
    if { [catch {

        set_inst_curr_code

        get_missed_txn_sql
        MASCLR::log_message "query $get_ent" 3
        orasql $clr_get1 $get_ent

        ###### Declaring Variables and intializing

        set chkmid " "
        set chkmidt " "
        set chkcurr " "
        set totcnt 0
        set totamt 0
        set ftotcnt 0
        set ftotamt 0
        set trlcnt 0
        set loop 1
        set sendemail 1
        set script_error 0

        ###### While Loop to fetch records gathered by Sql Select get_info

        while {[set loop [orafetch $clr_get1 -dataarray a -indexbyname]] == 0} {
            # reset all variables in global array
            set rec(batch_curr) ""
            set rec(merchantid) ""
            set rec(sender_id) ""
            set rec(institution_id) ""
            set rec(entity_id) ""
            set rec(card_scheme) ""
            set rec(external_trans_id) ""
            set rec(trans_ref_data) ""
            set rec(trans_id) ""
            set rec(mas_code) ""
            set txn_curr $a(TRANS_CCD)

            ###### Writing Batch Header Or Batch Trailer

            if {$chkmid != $a(MERCH_ID) || $chkcurr != $txn_curr } {
                set trlcnt 1
                if { $chkmid != " " && $chkcurr != " " } {
                    set rec(batch_amt)  $totamt
                    set rec(batch_cnt) $totcnt
                    write_bt_record $fileid rec
                    set chkmid $a(MERCH_ID)
                    set chkcurr $txn_curr
                    set totcnt 0
                    set totamt 0
                }
                set rec(batch_curr) $txn_curr
                set rec(activity_date_time_bh) $batchtime
                set rec(merchantid) $a(MERCH_ID)
                set rec(inbatchnbr) [pbchnum]
                set rec(infilenbr)  1
                set rec(batch_capture_dt) $batchtime
                set rec(sender_id) $a(MERCH_NAME)
                set rec(institution_id) $a(SRC_INST_ID)

                write_bh_record $fileid rec
                set chkmid $a(MERCH_ID)
                set chkcurr $txn_curr
            }

            ###### Writing Message Detail records

            set rec(entity_id) $a(MERCH_ID)
            set rec(card_scheme) $a(CARD_SCHEME)
            set rec(external_trans_id) $a(TRANS_SEQ_NBR)
            set rec(trans_ref_data) $a(ARN)
            MASCLR::log_message "Card Scheme : $a(CARD_SCHEME)" 3
            set mas_tid $a(TID)
            set ms_cd $a(MAS_CODE)
			set rec(mas_code_downgrade) $a(MAS_CODE_DOWNGRADE)
            MASCLR::log_message "TRANS_REF_DATA : $a(ARN), AMT_TRANS : $a(AMT_TRANS)" 3


            set rec(amt_original) $a(AMT_TRANS)
            set ftotamt [expr $ftotamt + $a(AMT_TRANS)]
            set totamt [expr $totamt + $a(AMT_TRANS)]

            set rec(trans_id) $mas_tid
            set rec(mas_code) $ms_cd
            set rec(nbr_of_items) "1"
            set totcnt [expr $totcnt + 1]
            set ftotcnt [expr $ftotcnt + 1]
            write_md_record $fileid rec
            MASCLR::log_message "batch_amt : $totamt ,file_amt : $ftotamt,batch_cnt : $totcnt, file_cnt : $ftotcnt" 2

        }
    } failure] } {
        set mbody "Error parsing, binding or executing get_ent sql: $failure \n $get_ent"
        MASCLR::log_message "$mbody"
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u - inside $programName" $mailtolist
        exec rm $outfile
        MASCLR::close_all_and_exit_with_code 1
    }
    ###### Writing last batch Trailer Record
    if {$trlcnt == 1} {
        set rec(batch_amt) $totamt
        set rec(batch_cnt) $totcnt
        write_bt_record $fileid rec
        set totcnt 0
        set totamt 0
    }
    # ##### Writing File Trailer Record

    set rec(file_amt) $ftotamt
    set rec(file_cnt) $ftotcnt

    write_ft_record $fileid rec

    ###### Closing Output file

    close $fileid
    exec chmod 775 $outfile
    if {$MODE == "TEST"} {
        exec mv $outfile $env(PWD)/ON_HOLD_FILES/.
    } elseif {$MODE == "PROD"} {
        exec mv $outfile $env(PWD)/MAS_FILES/.
    }

    MASCLR::close_all_and_exit_with_code 0
};

main
