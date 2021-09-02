#!/usr/bin/env tclsh
# ###############################################################################
# $Id: mas_chgbck_file.tcl 3941 2016-11-03 18:22:52Z skumar $
# $Rev: 3941 $
# ###############################################################################
#
# File Name:  mas_chgbck_file.tcl
#
# Description:  This script creaes the chargeback file 
#
# Running options:
#
#    Arguments - i = institution id (Required)
#                d = date in YYYYMMDD format (optional)
#                v = debug level
#    Example - mas_chgbck_file.tcl -i 107 -d 20161026
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
    puts stderr "Usage: $programName -i inst_id -t "
    puts stderr "Usage: $programName -i <inst id> -l <log file> -v <debug level>"
    puts stderr "       inst id - Institution ID"
    puts stderr "       verbosity   - level of debug information output, Optional"
    exit 1
}

# Procedure to Parse the command line arguments
proc arg_parse {} {
    global argv argv0 MODE
    global opt_type mailtolist inst_id currdate
    set inst_id ""
    set currdate "[clock format [clock seconds] -format "%Y%m%d"]"
    while { [ set err [ getopt $argv "hi:d:tv" opt optarg ]] } {
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
               h {
                    usage
                    exit 1
                }
            }
        }
    }
}

#Procedure to create database login handle
proc connect_to_dbs {} {
    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year db_logon_handle db_login_handle
    global box clrpath maspath 
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo

    if {[catch {set db_login_handle [oralogon masclr/masclr@$clrdb]} result]} {
        set mbody "$clrdb failed to open database handle"
        MASCLR::log_message "$mbody"
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        MASCLR::close_all_and_exit_with_code 1
    }
}

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
}

#Procedure to initialize the variables during the startup
proc init {} {
    global fname dot jdate begintime endtime batchtime currdate
    global sdate adate e_date n_date lydate
    global rightnow
    set sdate [clock format [ clock scan "$currdate 0 day"] -format %Y%m%d]
    set adate [clock format [ clock scan "$currdate -1 day" ] -format %Y%m%d]
    set e_date [string toupper [clock format [ clock scan "$currdate -1 day" ] -format %d-%b-%y]]
    set n_date [string toupper [clock format [ clock scan "$currdate -0 day" ] -format %d-%b-%y]]
    set lydate [clock format [ clock scan "$currdate" ] -format %m]

    set begint "000000"
    set endt "000000"
    set rightnow [clock seconds]
    set rightnow [clock format $rightnow -format "%Y%m%d%H%M%S"]

    
    set jdate [ clock scan "$currdate"  -base [clock seconds] ]
    set jdate [clock format $jdate -format "%y%j"]
    set jdate [string range $jdate 1 end]
    MASCLR::log_message "Julian date $jdate" 3
    
    set begintime "000000"
    set endtime "000000"
    
    append batchtime $sdate $begint
    MASCLR::log_message "Transaction count between $begintime :: $endtime"  3
}

#Procedure to create the output file name
proc get_outfile {} {
    global inst_id inst_dir subroot locpth env
    global fname dot jdate begintime endtime batchtime currdate
    global MODE subdir

    set inst_dir "INST_$inst_id"
    set subroot "MAS"
    set locpth "/clearing/filemgr/$subroot/$inst_dir"
    set fname "CHARGEBK"
    set dot "."
    #Temp variable for output file name
    set f_seq 15
    set fileno $f_seq
    set fileno [format %03s $f_seq]
    set one "01"
    set pth ""
    set hk 1
    #Creating output file name----------------------
    append outfile $pth $inst_id $dot $fname $dot $one $dot $jdate $dot $fileno
    MASCLR::log_message "File name: $outfile" 3
    #puts $hk
    
    while {$hk == 1} {
        #puts $hk
        if {$MODE == "TEST"} {
            set subdir "ON_HOLD_FILES"
        } elseif {$MODE == "PROD"} {
            set subdir "MAS_FILES"
        }        
        if {[set ex [file exists $env(PWD)/$subdir/$outfile]] == 1} {
            MASCLR::log_message "File name: $outfile already exists" 3
            set f_seq [expr $f_seq + 1]
            set fileno $f_seq
            set fileno [format %03s $f_seq]
            set one "01"
            set pth ""
            #exec mv $outfile $env(PWD)/TEMP/.
            set outfile ""
            append outfile $pth $inst_id $dot $fname $dot $one $dot $jdate $dot $fileno
            MASCLR::log_message "New File name: $outfile" 3
            set hk 1
        } else {
            set hk 0
        }
    }
    return $outfile
}

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
}

#Procedure to create SQL query
proc get_sql {} {
    global get_ent inst_id e_date n_date
    set get_ent "
        select 
            m.SRC_INST_ID                , 
            m.MERCH_ID                   ,
            m.MERCH_NAME                 ,
            nvl(m.AMT_TRANS, 0) AMT_TRANS,
            m.TRANS_CCD                  ,
            m.CARD_SCHEME                ,
            nvl(c.AMT_RECON, 0) AMT_RECON,
            m.ARN                        ,
            m.TRANS_SEQ_NBR              ,
            c.TID                        ,
            c.EMS_ITEM_TYPE
        from masclr.in_draft_main m 
        join 
        (
            select 
                idm.arn, idm.tid, idm.trans_seq_nbr,
                idm.amt_recon,epl.ems_item_type
            from masclr.ep_event_log epl
            join masclr.in_draft_main idm
                on idm.trans_seq_nbr = epl.trans_seq_nbr
            where
                (  ems_item_type in ('CB1','CB2','RR1','RR2')
                   or (ems_item_type in ('CR2')
                    and epl.card_scheme = '08')
                )
            and event_log_date >= '$e_date'
            and event_log_date <  '$n_date'
            and event_status in ('NEW', 'NOTIFY', 'PROGRESS')
            and (idm.pri_dest_inst_id = '$inst_id'  or idm.SEC_DEST_INST_ID = '$inst_id')
        )c
        on m.ARN = c.ARN and (m.MSG_TYPE = '500' or m.MSG_TYPE = '600')
        order by m.MERCH_ID"
}

# ######################################################################################################################

#Environment variables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(IST_DB)
set authdb $env(ATH_DB)
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
    
    global rightnow batchtime get_ent clr_get clr_get1
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo mbody
    ###### Writing File Header into the Mas file
    set rec(file_date_time) $rightnow
    set rec(activity_source) "JETPAYLLC"
    set rec(activity_job_name) "MAS"
    
    write_fh_record $fileid rec
    if { [catch {
        get_sql
        MASCLR::log_message "query $get_ent" 3
        orasql $clr_get1 $get_ent
        
        ###### Declaring Variables and intializing
        
        set chkmid " "
        set chkmidt " "
        set totcnt 0
        set totamt 0
        set ftotcnt 0
        set ftotamt 0
        set trlcnt 0
        set loop 1
        set chk 0
        set sendemail 1
        set script_error 0
        
        ###### While Loop for to fetch records gathered by Sql Select get_info

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
            set chk 0
            
            ###### Writing Batch Header Or Batch Trailer
            
            if {$chkmid != $a(MERCH_ID)} {
                set trlcnt 1
                if {$chkmid != " "} {
                    set rec(batch_amt)  $totamt
                    set rec(batch_cnt) $totcnt
                    write_bt_record $fileid rec
                    set chkmidt $a(MERCH_ID)
                    set totcnt 0
                    set totamt 0
                }

                set rec(batch_curr) $a(TRANS_CCD)
                set rec(activity_date_time_bh) $batchtime
                set rec(merchantid) $a(MERCH_ID)
                set rec(inbatchnbr) [pbchnum]
                set rec(infilenbr)  1
                set rec(batch_capture_dt) $batchtime
                set rec(sender_id) $a(MERCH_NAME)
                set rec(institution_id) $a(SRC_INST_ID)

                write_bh_record $fileid rec
                set chkmid $a(MERCH_ID)
            }

            ###### Writing Message Detail records
            
            set rec(entity_id) $a(MERCH_ID)
            set rec(card_scheme) $a(CARD_SCHEME)
            set rec(external_trans_id) $a(TRANS_SEQ_NBR)
            set rec(trans_ref_data) $a(ARN)
            MASCLR::log_message "Card Scheme : $a(CARD_SCHEME)" 3
            
            switch $a(EMS_ITEM_TYPE) {
                "CB1"   {
                    switch $a(TID) {
                        "010103015201" {set mas_tid "010003015201"}
                        "010103015202" {set mas_tid "010003015101"}
                        "010103015107" -
                        "010103015101" {set mas_tid "010003015101"}
                        "010103015102" {set mas_tid "010003015102"}
                        "010103015401" {set mas_tid "010003015201"}
                        default {
                            set mbody "unknown TID $a(TID) in transaction ARN $a(ARN) for merchant $a(MERCH_ID) "
                            set chk 1
                        }
                    }
                    set ms_cd "$a(CARD_SCHEME)CHGBCK"
                }
                "CB2"   {
                    switch $a(TID) {
                        "010103015301" {set mas_tid "010003015101"}
                        "010103015302" {set mas_tid "010003015102"}
                        "010103015401" {set mas_tid "010003015201"}
                        default {
                            set mbody "unknown TID $a(TID) in transaction ARN $a(ARN) for merchant $a(MERCH_ID)"
                            set chk 1
                        }
                    }
                    set ms_cd "$a(CARD_SCHEME)CHGBCK"
                }
                "RR1" -
                "RR2"    {
                    set ms_cd "02$a(CARD_SCHEME)RREQ"
                    set mas_tid "010103020102"
                }
                "CR2" {
                    switch $a(CARD_SCHEME) {
                        "08" {
                            set ms_cd $a(MAS_CODE)
                            switch $a(TID) {
                                "010103005301" {set mas_tid "010003005301"}
                                "010103005302" {set mas_tid "010003005302"}
                                "010103015401" {set mas_tid "010003015201"}
                                default {
                                    set mbody "unsupported tid for CR2: $a(TID) in transaction ARN $a(ARN) for merchant $a(MERCH_ID)"
                                    set chk 1
                                }
                            }
                        }
                        default {
                            set mbody "unsupported card scheme for CR2: $a(CARD_SCHEME) in transaction ARN $a(ARN) for merchant $a(MERCH_ID)"
                        }
                    }
                }
                default {
                    set mbody "EMS_ITEM_TYPE not found :$a(EMS_ITEM_TYPE) in transaction ARN $a(ARN) for merchant $a(MERCH_ID)"
                    set chk 1
                }
            }
            if { $chk == 1} {
                error $mbody
                MASCLR::log_message "$mbody"
                exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
                exec rm $outfile
                MASCLR::close_all_and_exit_with_code 1
            }
            MASCLR::log_message "EMS_ITEM_TYPE : $a(EMS_ITEM_TYPE), TRANS_CCD : $a(TRANS_CCD), AMT_TRANS : $a(AMT_TRANS), AMT_RECON : $a(AMT_RECON)" 3

            if {$a(AMT_RECON) == ""} { 
                set rec(amt_original) $a(AMT_TRANS)
                set ftotamt [expr $ftotamt + $a(AMT_TRANS)]
                set totamt [expr $ftotamt + $a(AMT_TRANS)]
            } else {
                set rec(amt_original) $a(AMT_RECON)
                set totamt [expr $totamt + $a(AMT_RECON)]
                set ftotamt [expr $ftotamt + $a(AMT_RECON)]
            }                    
            set rec(trans_id) $mas_tid
            set rec(mas_code) $ms_cd
            set rec(nbr_of_items) "1"
            set totcnt [expr $totcnt + 1]
            set ftotcnt [expr $ftotcnt + 1]
            write_md_record $fileid rec
            MASCLR::log_message "batch_amt : $totamt ,file_amt : $ftotamt,batch_cnt : $totcnt, file_cnt : $ftotcnt"
            
        }
    } failure] } {
        set mbody "Error parsing, binding or executing get_ent sql: $failure \n $get_ent"
        MASCLR::log_message "$mbody"
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
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
        exec  mv $outfile $env(PWD)/MAS_FILES/.
    }
    MASCLR::close_all_and_exit_with_code 0
}

main

