#!/usr/bin/env tclsh
# ###############################################################################
# $Id: pass_through_fees.tcl 4022 2017-01-13 19:23:40Z skumar $
# $Rev: 4022 $
# ###############################################################################
#
# File Name:  pass_through_fees.tcl
#
# Description:  This script creates the fee mas file
#
# Running options:
#
#    Arguments - i = institution id (Required)
#                c = count type (Required)
#                m = month in MM format (optional)
#                y = year in YYYY format (optional)
#                v = debug level (optional)
#    Example - pass_through_fees.tcl -i 107 -c VOUCHER
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

# Types of counting types
#
# cnt_type      description                                   filename    mas_code
#
#VOUCHER      Visa Base II Credit & Debit Voucher File       VOUCHER    VS_CR_VOUCHER & VS_DB_VOUCHER
#DBINTGR       Visa Debit Integrity                          DBINTEGR   VS_DB_INTEGRITY
#TRANSMIS      Visa Base II Transmission fee file            TRANSMIS   VS_BASE2_TRANS

proc usage {} {
    global programName
    puts stderr "Usage: $programName -i inst_id -c cnt_type -y <YYYY> -m <MM> -t -v"
    puts stderr "       i - Institution ID"
    puts stderr "       c - cnt_type"
    puts stderr "       m - month"
    puts stderr "       y - year"
    puts stderr "       v - verbosity level"
    exit 1
};

# Procedure to Parse the command line arguments
proc arg_parse {} {
    global argv argv0 MODE cfgname
    global opt_type mailtolist inst_id cnt_type run_year
    global mnth year run_mnth cmonth cyear
    set inst_id ""
    set mnth ""
    set year ""
    set cnt_type ""
    while { [ set err [ getopt $argv "hi:m:y:c:tv" opt optarg ]] } {
        if { $err < 0 } then {
            MASCLR::log_message "error: $argv0 : opt $opt, optarg: $optarg "
            usage
            exit 1
        } else {
            MASCLR::log_message "opt: $opt, optarg: $optarg" 1
            switch -exact $opt {
               i {set inst_id $optarg}
               m {set mnth $optarg}
               y {set year $optarg}
               t {
                   set mailtolist "sangeetha.kumar@jetpay.com"
                   set MODE "TEST"
                 }
               v {incr MASCLR::DEBUG_LEVEL}
               c {set cnt_type $optarg}
               h {
                    usage
                    exit 1
                }
            }
        }
    }
    if {$mnth == ""} {
        set run_mnth $cmonth
    } else {
        set run_mnth $mnth
    }
    if {$year == ""} {
        set run_year $cyear
    } else {
        set run_year $year
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
    global sdate adate e_date n_date lydate cmonth cdate cyear
    global rightnow
    set currdate [clock format [clock seconds] -format "%Y%m%d"]
    set sdate [clock format [ clock scan "$currdate" ] -format "%Y%m%d"]
    set adate [clock format [ clock scan "$currdate -1 day" ] -format "%Y%m%d"]
    set lydate [clock format [ clock scan "$currdate" ] -format "%m"]
    set rightnow [clock seconds]
    set cmonth [clock format $rightnow -format "%m"]
    set cdate [clock format $rightnow -format "%d"]
    set cyear [clock format $rightnow -format "%Y"]
    set rightnow [clock format $rightnow -format "%Y%m%d%H%M%S"]
    set jdate [ clock scan "$currdate"  -base [clock seconds] ]
    set jdate [clock format $jdate -format "%y%j"]
    set jdate [string range $jdate 1 end]

    set begintime "000000"
    set endtime "000000"
    MASCLR::log_message "Julian date $jdate" 3

    append batchtime $sdate $begintime
    MASCLR::log_message "Transaction count between $begintime :: $endtime"  3
};

#Procedure to create the output file name
proc get_outfile {} {
    global inst_id env cnt_type
    global fname dot jdate begintime endtime batchtime currdate
    global MODE subdir f_seq

    set fname [get_fname $cnt_type]
    set dot "."
    set f_seq ""
    #Temp variable for output file name
    if {$f_seq == ""} {
        set f_seq 1
    }
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
proc get_sql {f_type} {
    global cmonth cyear inst_id

    # query needs currency code, entity ID, mas_code,mid ??, count, amount,
    # returning amount as a decimal number with decimal separator
    switch $f_type {
        "VOUCHER" {
            set nm "
                SELECT
                     mtl.institution_id                                    INST_ID,
                     mtl.entity_id                                        MERCH_ID,
                     mtl.card_scheme                                              ,
                     mtl.curr_cd_original                                  CURR_CD,
                     COUNT(mtl.trans_seq_nbr)                                COUNT,
                     SUM(mtl.amt_original)                                  AMOUNT,
                     CASE
                          when mtl.mas_code = '0104UCPSDCRVO' then 'VS_DB_VOUCHER'
                          when mtl.mas_code = '0104UCVMOTODB' then 'VS_DB_VOUCHER'
                          when mtl.mas_code = '0104UCVNPTDB' then 'VS_DB_VOUCHER'
                          when mtl.mas_code = '0104UCVPTDB' then 'VS_DB_VOUCHER'
                          else 'VS_CR_VOUCHER' END                         MAS_CODE
                 FROM
                     masclr.mas_trans_log mtl
                 WHERE
                     mtl.institution_id = :inst_id_var
                     and mtl.card_scheme = '04'
                     and mtl.gl_date >=          to_date(:year_var || :month_var, 'YYYYMM')
                     and mtl.gl_date <  last_day(to_date(:year_var || :month_var, 'YYYYMM'))+1
                     and mtl.tid = '010003005102'
                     and mtl.TRANS_SUB_SEQ = 0
                GROUP BY
                     mtl.institution_id ,
                     mtl.entity_id,
                     mtl.card_scheme,
                     mtl.curr_cd_original,
                     CASE
                     when mtl.mas_code = '0104UCPSDCRVO' then 'VS_DB_VOUCHER'
                     when mtl.mas_code = '0104UCVMOTODB' then 'VS_DB_VOUCHER'
                     when mtl.mas_code = '0104UCVNPTDB' then 'VS_DB_VOUCHER'
                     when mtl.mas_code = '0104UCVPTDB' then 'VS_DB_VOUCHER'
                     else 'VS_CR_VOUCHER' END
                 ORDER BY
                     mtl.entity_id"
        }
        "DBINTGR" {
            set nm "
                SELECT
                    ifl.institution_id                                 INST_ID,
                    idm.merch_id                                      MERCH_ID,
                    idm.card_scheme                                           ,
                    idm.TRANS_CCD                                      CURR_CD,
                    COUNT(idm.trans_seq_nbr)                             COUNT,
                    TO_CHAR(SUM(idm.amt_trans)/100, '9999999.00')       AMOUNT,
                    'VS_DB_INTEGRITY'                              as MAS_CODE
                FROM
                    masclr.in_draft_main idm
                JOIN masclr.in_draft_baseii idb
                    ON  idm.trans_seq_nbr = idb.trans_seq_nbr
                JOIN masclr.in_file_log ifl
                    ON  ifl.in_file_nbr = idm.in_file_nbr
                WHERE
                    ifl.incoming_dt >=              to_date(:year_var || :month_var, 'YYYYMM')
                    and ifl.incoming_dt <  last_day(to_date(:year_var || :month_var, 'YYYYMM'))+1
                    AND ifl.institution_id               = :inst_id_var
                    AND idb.REIMB_ATTRIB not in ('A','4')
                    AND idm.card_scheme                  = '04'
                GROUP BY
                    ifl.institution_id ,
                    idm.merch_id ,
                    idm.card_scheme,
                    idm.TRANS_CCD
                ORDER BY
                    idm.merch_id"
        }
        "TRANSMIS" {
            set nm "
                SELECT
                    ifl.institution_id                                   INST_ID,
                    idm.merch_id                                        MERCH_ID,
                    idm.card_scheme                                             ,
                    idm.TRANS_CCD                                        CURR_CD,
                    COUNT(idm.trans_seq_nbr)                               COUNT,
                    TO_CHAR(SUM(idm.amt_trans)/100, '9999999.00')         AMOUNT,
                    'VS_BASE2_TRANS'                                 as MAS_CODE
                FROM
                    masclr.in_draft_main idm
                JOIN masclr.in_draft_baseii idb
                    ON  idm.trans_seq_nbr = idb.trans_seq_nbr
                JOIN masclr.in_file_log ifl
                    ON  ifl.in_file_nbr = idm.in_file_nbr
                WHERE
                    ifl.incoming_dt >=              to_date(:year_var || :month_var, 'YYYYMM')
                    and ifl.incoming_dt <  last_day(to_date(:year_var || :month_var, 'YYYYMM'))+1
                    AND ifl.institution_id               = :inst_id_var
                    AND idm.card_scheme                  = '04'
                GROUP BY
                    ifl.institution_id ,
                    idm.merch_id ,
                    idm.card_scheme,
                    idm.TRANS_CCD
                ORDER BY
                    idm.merch_id"
        }
        default {
            usage $f_type
            exit 1
        }

    }
    # puts $nm
    # MASCLR::log_message "get_sql nm: \n\n$nm ;\n" 4
    return $nm
};

proc get_tid {f_type} {

    switch $f_type {
        "VOUCHER"           {set nm "010070020001"}
        "DBINTGR"           {set nm "010070020001"}
        "TRANSMIS"          {set nm "010070020001"}
    }
    return $nm
};

proc get_fname {f_type} {

    switch $f_type {
        "VOUCHER"     {set nm "VVOUCHER"}
        "DBINTGR"     {set nm "DBINTEGR"}
        "TRANSMIS"    {set nm "TRANSMIS"}
        default {
            usage
            exit 1
        }

    }

    return $nm

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
    global cfgname txn_list
    set cfgname ""
    set txn_list ""
    init
    arg_parse
    #sql logon handles #################################################

    connect_to_dbs
    open_cursor_masclr clr_get
    open_cursor_masclr clr_get1

    #Initialisation############################

    set y 0
    #Opening Output file to write to
    global outfile MODE env programName inst_id
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo

    set outfile [get_outfile]

    if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
        set mbody "Cannot open /create : $fileid in $programName"
        MASCLR::log_message $mbody
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        MASCLR::close_all_and_exit_with_code 1
    }

    global rightnow batchtime get_ent clr_get clr_get1 cnt_type
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo mbody
    global run_year run_mnth get_info
    ###### Writing File Header into the Mas file
    set rec(file_date_time) $rightnow
    set rec(activity_source) "JETPAYLLC"
    set rec(activity_job_name) "MAS"

    write_fh_record $fileid rec

    if { [catch {
        set get_info "[get_sql $cnt_type ]"
        MASCLR::log_message "get_info: $get_info" 3
        MASCLR::log_message "month:  $run_mnth" 3
        MASCLR::log_message "year:   $run_year" 3
        MASCLR::log_message "inst_id: $inst_id" 3
        oraparse $clr_get $get_info
        orabind $clr_get :month_var $run_mnth :year_var $run_year :inst_id_var $inst_id
        oraexec $clr_get
    } failure] } {
        set mbody "Error parsing, binding or executing get_info sql: $failure \n $get_info"
        MASCLR::log_message "$mbody"
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u - inside $programName" $mailtolist
        exec rm $outfile
        MASCLR::close_all_and_exit_with_code 1
    }

    ###### Declaring Variables and intializing

        set chkmid " "
        set chkmidt " "
        set totcnt 0
        set totamt 0
        set ftotcnt 0
        set ftotamt 0
        set trlcnt 0
        set loop 1

        ###### While Loop for to fetch records gathered by Sql Select get_info

        while {[set loop [orafetch $clr_get -dataarray a -indexbyname]] == 0} {
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

                set rec(batch_curr) $a(CURR_CD)
                set rec(activity_date_time_bh) $batchtime
                set rec(merchantid) $a(MERCH_ID)
                set rec(inbatchnbr) [pbchnum]
                set rec(infilenbr)  1
                set rec(batch_capture_dt) $batchtime
                set rec(sender_id) $a(MERCH_ID)
                set rec(institution_id) $a(INST_ID)

                write_bh_record $fileid rec
                set chkmid $a(MERCH_ID)
            }

            ###### Writing Message Detail records

            set rec(entity_id) $a(MERCH_ID)
            set rec(card_scheme) $a(CARD_SCHEME)
            set rec(nbr_of_items) $a(COUNT)
            set rec(amt_original) [expr wide([expr $a(AMOUNT) * 100])]
            set rec(external_trans_id) " "
            set rec(mas_code) $a(MAS_CODE)
            MASCLR::log_message "Card Scheme : $a(CARD_SCHEME)" 3
            set mas_tid [get_tid $cnt_type]
            set rec(trans_id) $mas_tid
            MASCLR::log_message "MERCH_ID : $a(MERCH_ID), MAS_CODE : $a(MAS_CODE), AMOUNT : $a(AMOUNT), COUNT : $a(COUNT)" 3

            write_md_record $fileid rec
            set totcnt [expr $totcnt + $a(COUNT)]
            set totamt [expr $totamt + $rec(amt_original)]

            set ftotcnt [expr $ftotcnt + $a(COUNT)]
            set ftotamt [expr $ftotamt + $rec(amt_original)]
            MASCLR::log_message "batch_amt : $totamt ,file_amt : $ftotamt,batch_cnt : $totcnt, file_cnt : $ftotcnt" 2

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
