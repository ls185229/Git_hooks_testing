#!/usr/bin/env tclsh
# ###############################################################################
# $Id: vs_mc_mas_dwngrde_file.tcl 4111 2017-03-28 17:54:40Z skumar $
# $Rev: 4111 $
# ###############################################################################
#
# File Name:  vs_mc_mas_dwngrde_file.tcl
#
# Description:  This script creates the Visa & Mastercard
#               downgrade file
#
# Running options:
#
#    Arguments - i = institution id (Required)
#                d = date in YYYYMMDD format (optional)
#                v = debug level (optional)
#    Example - vs_mc_mas_dwngrde_file.tcl -i 107 -d 20161026
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

#Environment variables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(IST_DB)
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
    global fname dot jdate begintime endtime batchtime currdate
    global sdate adate e_date n_date lydate
    global rightnow last_day_month cur_month
    set sdate [clock format [ clock scan "$currdate 0 day"] -format %Y%m%d]
    set adate [clock format [ clock scan "$currdate -1 day" ] -format %Y%m%d]
    set e_date [string toupper [clock format [ clock scan "$currdate -1 day" ] -format %d-%b-%y]]
    set n_date [string toupper [clock format [ clock scan "$currdate -0 day" ] -format %d-%b-%y]]
    set lydate [clock format [ clock scan "$currdate" ] -format %m]

    set rightnow [clock seconds]
    set rightnow [clock format $rightnow -format "%Y%m%d%H%M%S"]
    set cur_month [clock format [clock seconds] -format %Y-%m]
    set last_day_month [clock format [clock scan "$cur_month-01 + 1 month - 1 day"]  -format %Y%m%d000000]


    set jdate [ clock scan "$currdate"  -base [clock seconds] ]
    set jdate [clock format $jdate -format "%y%j"]
    set jdate [string range $jdate 1 end]
    MASCLR::log_message "Julian date $jdate" 3

    set begintime "000000"
    set endtime "000000"
    append batchtime $sdate $begintime
    set begintime "to_char(last_day(sysdate - (to_char(sysdate, 'DD') + 2)), 'DD-MON-YYYY')"
    set endtime "to_char(last_day(sysdate), 'DD-MON-YYYY')"
    MASCLR::log_message  "Transaction count between $begintime :: $endtime" 3
};

#Procedure to create the output file name
proc get_outfile {} {
    global inst_id inst_dir subroot locpth env
    global fname dot jdate begintime endtime batchtime currdate
    global MODE subdir

    set inst_dir "INST_$inst_id"
    set subroot "MAS"
    set locpth "/clearing/filemgr/$subroot/$inst_dir"
    set fname "VSMCRCLS"
    set dot "."
    #Temp variable for output file name
    set f_seq 5
    set fileno $f_seq
    set fileno [format %03s $f_seq]
    set one "01"
    set pth ""
    set hk 1
    #Creating output file name
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

#Procedure to create SQL query
proc get_sql {} {
    global get_ent inst_id begintime endtime
    set get_ent "
        select
            TRANS_SEQ_NBR                                        ,
            MERCH_ID                                             ,
            MERCH_NAME                                           ,
            CARD_SCHEME                                          ,
            ARN                                                  ,
            TID                                                  ,
            SEC_DEST_INST_ID                                     ,
            MAS_CODE                                             ,
            MAS_CODE_DOWNGRADE                                   ,
            nvl(AMT_TRANS, 0)                         AMT_TRANS,
            TRANS_CCD
        from in_draft_main
        where
            (tid = '010133005101' or tid = '010133005102')
            and activity_dt >= $begintime
            and activity_dt < $endtime
            and merch_id not like '461084%'
            and sec_dest_inst_id = '$inst_id'
        order by MERCH_ID"
};

proc repair_txn {} {
    global clr_get1
    global db_login_handle mas_code_repair_sql inst_id
    global mailtolist mailfromlist msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo mbody
    global repair_plblock

    set repair_plblock "
        declare
            cursor mas_code_repair is
                select
                    vrra.trans_seq_nbr,
                    min(fir_1.mas_code) mc_1,
                    min(fir_2.mas_code) mc_2
                from masclr.visa_rtn_rclas_adn vrra
                join masclr.flmgr_interchange_rates fir_1
                on vrra.submt_fee_prog_ind = fir_1.fpi_ird
                join masclr.flmgr_interchange_rates fir_2
                on vrra.asses_fee_prog_ind = fir_2.fpi_ird
                where trans_seq_nbr in (
                    select trans_seq_nbr from in_draft_main
                    where (tid = '010133005101' or tid = '010133005102')
                    and activity_dt >= trunc(sysdate,'MM')-1
                    and activity_dt < trunc(last_day(sysdate))
                    and sec_dest_inst_id = '$inst_id'
                    and ( mas_code = 'MAS001' or mas_code_downgrade = 'MAS001')
                ) and trim(vrra.asses_fee_prog_ind) is not null
            and fir_2.region is not null
            and fir_2.usage = 'INTERCHANGE'
                group by vrra.trans_seq_nbr, vrra.submt_fee_prog_ind, vrra.asses_fee_prog_ind
                order by 2,3,1;

        idx         number := 0;

        begin

            for mcr in mas_code_repair
            loop
                idx := idx + 1;
                update masclr.in_draft_main
                set
                    mas_code                    =  case
                        when mas_code           != 'MAS001'
                        then mas_code
                        else                    mcr.mc_1
                        end,
                    mas_code_downgrade          =  case
                        when mas_code_downgrade != 'MAS001'
                        then mas_code_downgrade
                        else                    mcr.mc_2
                        end
                where trans_seq_nbr =           mcr.trans_seq_nbr
                and	(
                    mas_code            =   'MAS001'
                    or
                    mas_code_downgrade  =   'MAS001'
                    );


            end loop;
        end;
        "

    MASCLR::log_message "repair_plblock:\n$repair_plblock" 3
    if { [catch {
        oraplexec $clr_get1 $repair_plblock
        oracommit $db_login_handle
        MASCLR::log_message "Repaired reclass tranasactions" 3
    } failure] } {
        set mbody "Error parsing, binding or executing or during the commit of repair_plblock sql: $failure \n $repair_plblock"
        error $mbody
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        MASCLR::close_all_and_exit_with_code 1
    }
    return 0

};

# #######################################################################################################################
# ## MAIN ###############################################################################################################
# #######################################################################################################################
proc main {} {
    global get_ent
    arg_parse
    #sql logon handles #################################################

    connect_to_dbs
    open_cursor_masclr clr_get1
    #Initialisation############################
    init
    set y 0

    #repair reclass tranasactions
    repair_txn

    #Opening Output file to write to
    global outfile MODE env programName
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global rightnow batchtime get_ent clr_get clr_get1 last_day_month

    set outfile [get_outfile]
    if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
        set mbody "Cannot open /create : $fileid in $programName"
        MASCLR::log_message $mbody
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        MASCLR::close_all_and_exit_with_code 1
    }

    # ##### Writing File Header into the Mas file

    set rec(file_date_time) $batchtime
    set rec(activity_source) "JETPAYLLC"
    set rec(activity_job_name) "MAS"

    write_fh_record $fileid rec

    get_sql

    MASCLR::log_message "get_ent:\n$get_ent" 3
    orasql $clr_get1 $get_ent
    # ##### Declaring Variables and intializing

    set chkmid " "
    set chkmidt " "
    set totcnt 0
    set totamt 0
    set ftotcnt 0
    set ftotamt 0
    set trlcnt 0
    set loop 1
    set chk 0
    # ##### While Loop for to fetch records gathered by Sql Select get_info

    while {[set loop [orafetch $clr_get1 -dataarray a -indexbyname]] == 0} {
        set chk 1
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
            set rec(activity_date_time_bh) $last_day_month
            set rec(merchantid) $a(MERCH_ID)
            set rec(inbatchnbr) [pbchnum]
            set rec(infilenbr)  1
            set rec(batch_capture_dt) $batchtime
            set rec(sender_id) $a(MERCH_NAME)
            set rec(institution_id) $a(SEC_DEST_INST_ID)

            write_bh_record $fileid rec
            set chkmid $a(MERCH_ID)
        }
        if {$a(MAS_CODE) != "MAS001" || $a(MAS_CODE_DOWNGRADE) != "MAS001"} {
            ###### Writing Message Detail records
            set rec(entity_id) $a(MERCH_ID)
            set rec(card_scheme) $a(CARD_SCHEME)
            set rec(external_trans_id) $a(TRANS_SEQ_NBR)
            set rec(trans_ref_data) $a(ARN)

            if {$a(TID) == "010133005101"} {
                set mas_tid "010033005101"
            } elseif {$a(TID) == "010133005102"} {
                set mas_tid "010033005102"
            }
            set rec(trans_id) $mas_tid
            set rec(mas_code) $a(MAS_CODE)
            set rec(mas_code_downgrade) $a(MAS_CODE_DOWNGRADE)
            set rec(nbr_of_items) "1"
            set rec(amt_original) $a(AMT_TRANS)

            write_md_record $fileid rec

            set totcnt [expr $totcnt + 1]
            set totamt [expr $totamt + $a(AMT_TRANS)]

            set ftotcnt [expr $ftotcnt + 1]
            set ftotamt [expr $ftotamt + $a(AMT_TRANS)]
            MASCLR::log_message "$a(MERCH_ID) $totamt $ftotamt $totcnt $ftotcnt" 3
        } else {
            MASCLR::log_message "TRANS_SEQ_NBR = $a(TRANS_SEQ_NBR) MAS_CODE = $a(MAS_CODE) MAS_CODE_DOWNGRADE = $a(MAS_CODE_DOWNGRADE)"
        }
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
};

main