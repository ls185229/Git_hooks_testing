#!/usr/bin/env tclsh
# ###############################################################################
# $Id: pass_through_fees.tcl 4877 2019-07-30 19:44:48Z skumar $
# $Rev: 4877 $
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
# cnt_type      description                                       filename    mas_code
#
#VOUCHER       Visa Base II Credit & Debit Voucher File          VVOUCHER    VS_CR_VOUCHER & VS_DB_VOUCHER
#TXNINTGR      Visa Transaction Integrity                        TNINTEGR    VS_TXN_INTEGRITY
#AXBORDER      Amex Cross Border fees                            AXBORDER    AX_BORDER
#AXCNPRES      Amex Card not Present fee                         AXCNPRES    AX_CARD_NOT_PRESENT
#TRANSMIS      Visa Base II Transmission fee file                TRANSMIS    VS_BASE2_TRANS
#AVSASSOC      MC AVS fee for card present & card not present    AVSASSOC    MC_AVS_AUTH
#CVVASSOC      MC CVV fee for card present & card not present    CVVASSOC    MC_CVV_AUTH
#SEC           Credit Card Secure code transaction count fee     SECRCODE    MC_SECR_CODE
#MISAUTH       Visa & MC Misuse of auth transactions count fee   MISAUTH     VS_MISUSE_AUTH & MC_MISUSE_UNDEF_AUTH
#                                                                            MC_MISUSE_FINAL_AUTH & MC_MISUSE_PRE_AUTH
#MISCAPT       Visa & MC not settled transaction count fee       MISCAPT     VS_MISUSE_AUTH & MC_MISUSE_AUTH
#MCDWNGRD      MC Interchange Compliance Downgrade fee           MCDWNGRD    MC_INTCHG_DOWNGRADE
#DSNOQUAL      Discover Non Qualified fee                        DSNOQUAL    DS_NON_QUALIFIED
#DCLNAUTH      MC declines on same card number more than         DCLNAUTH    MC_MISUSE_EXCES_AUTH
#               20 times per day
#SMS_ITEM      SMS transactions                                  SMS_ITEM    STAR_DBT_MONTHLY & ACCEL_DBT_MONTHLY
#3DS_AUTH      3DS AUTH transactions                             3DS_AUTH    AX_3DS_PER_TRANS,VS_3DS_PER_TRANS,MC_3DS_PER_TRANS
#                                                                            DB_3DS_PER_TRANS,DS_3DS_PER_TRANS,OTHER_3DS_PER_TRANS
#ZEROVERI      Visa & MC Zero Dollar Verification Fee File       ZEROVERI    VS_ZERO_VERI_US_CR, VS_ZERO_VERI_US_DB &
#                                                                            VS_ZERO_VERI_INTL
#                                                                            MC_ZERO_VERI & MC_ZERO_VERI_INTER
#NWACQPRO      Network Acquirer Processing fee                   NWACQPRO    VISA_ASSMT_FLAT_US_CR,VISA_ASSMT_FLAT_US_DB
#

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
    while { [ set err [ getopt $argv "hi:e:m:y:c:tv" opt optarg ]] } {
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
               e {
                   set mailtolist $optarg
                 }
               t {
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
    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year auth_db_handle clr_db_handle
    global box clrpath maspath
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global db_userid db_pwd auth_db_userid auth_db_pwd authdb
    global port_db_userid port_db_pwd port_db_handle

    if {[catch {set clr_db_handle [oralogon $db_userid/$db_pwd@$clrdb]} result]} {
        set mbody "$clrdb failed to open database handle"
        MASCLR::log_message "$mbody"
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        MASCLR::close_all_and_exit_with_code 1
    }
    if {[catch {set auth_db_handle [oralogon $auth_db_userid/$auth_db_pwd@$authdb]} result]} {
        set mbody "$authdb failed to open database handle"
        MASCLR::log_message "$mbody"
        #   exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u"
        # $mailtolist
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        MASCLR::close_all_and_exit_with_code 1
    }
    if {[catch {set port_db_handle [oralogon $port_db_userid/$port_db_pwd@$clrdb]} result]} {
        set mbody "$clrdb on port user failed to open database handle"
        MASCLR::log_message "$mbody"
        #   exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u"
        # $mailtolist
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        MASCLR::close_all_and_exit_with_code 1
    }
};

#Procedure to open the masclr database connection handle
proc open_cursor_port {cursr} {
    global port_db_handle
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global $cursr

    if {[catch {set $cursr [oraopen $port_db_handle]} result]} {
        set mbody "$cursr failed to open statement handle"
        MASCLR::log_message "$mbody"
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        MASCLR::close_all_and_exit_with_code 1
    }
};

#Procedure to open the masclr database connection handle
proc open_cursor_masclr {cursr} {
    global clr_db_handle
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global $cursr

    if {[catch {set $cursr [oraopen $clr_db_handle]} result]} {
        set mbody "$cursr failed to open statement handle"
        MASCLR::log_message "$mbody"
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        MASCLR::close_all_and_exit_with_code 1
    }
};

#Procedure to open the teihost database connection handle
proc open_cursor_teihost {cursr} {
    global auth_db_handle
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global $cursr

    if {[catch {set $cursr [oraopen $auth_db_handle]} result]} {
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
    global cmonth cyear inst_id nm
    set nm ""

    # query needs currency code, entity ID, mas_code,mid ??, count, amount,
    # returning amount as a decimal number with decimal separator
    switch $f_type {

        "VOUCHER" {
            set nm "
                SELECT
                     mtl.institution_id                                    INST_ID,
                     mtl.entity_id                                        MERCH_ID,
                     mtl.card_scheme                                   CARD_SCHEME,
                     mtl.curr_cd_original                                  CURR_CD,
                     COUNT(mtl.trans_seq_nbr)                                COUNT,
                     SUM(mtl.amt_original)*100                              AMOUNT,
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

        "TXNINTGR" {
            set nm "
                SELECT
                    ae.institution_id                                 INST_ID,
                    idm.merch_id                                      MERCH_ID,
                    idm.card_scheme                                CARD_SCHEME,
                    idm.trans_ccd                                      CURR_CD,
                    COUNT(idm.trans_seq_nbr)                             COUNT,
                    SUM(idm.amt_trans)                                  AMOUNT,
                    'VS_TXN_INTEGRITY'                              as MAS_CODE
                FROM
                    masclr.in_draft_main idm
                JOIN masclr.in_draft_baseii idb
                    ON  idm.trans_seq_nbr = idb.trans_seq_nbr
                JOIN masclr.in_file_log ifl
                    ON  ifl.in_file_nbr = idm.in_file_nbr
                LEFT OUTER JOIN visa_adn va
                on idm.TRANS_SEQ_NBR = va.TRANS_SEQ_NBR
                LEFT OUTER JOIN VISA_RTN_RCLAS_ADN vrra
                on idm.TRANS_SEQ_NBR = vrra.TRANS_SEQ_NBR
                JOIN FLMGR_INTERCHANGE_RATES fir
                on fir.usage = 'INTERCHANGE' and fir.CARD_SCHEME = '04'
                and fir.region in ('ALL', 'USA')
                and (fir.FPI_IRD = va.FEE_PROG_IND  or fir.FPI_IRD = vrra.asses_fee_prog_ind)
                JOIN ACQ_ENTITY ae
                on idm.MERCH_ID = ae.ENTITY_ID and idm.SEC_DEST_INST_ID = ae.INSTITUTION_ID
                WHERE
                    ifl.incoming_dt >=              to_date(:year_var || :month_var, 'YYYYMM')
                    and ifl.incoming_dt <  last_day(to_date(:year_var || :month_var, 'YYYYMM'))+1
                    AND ae.institution_id in (:inst_id_var)
                    AND idm.card_scheme                  = '04'
                    AND fir.program in ('STD','EIRF')
                    AND idm.mas_code not in ('0104USCPSREG','0104UCPSDCRVO','0104UCVCSMOTO','0104UCVAIPT','0104UCVCSNPT')
                    AND idm.mas_code not in ('0104UCVCMNPT','0104UCVPGSA1','0104UCVPGSA2','0104UCVPGSA3','0104UCVPGSA4')
                    AND idm.mas_code not in ('0104UCVPGSA5','0104UCVPNGSA1','0104UCVPNGSA2','0104UCVPNGSA3','0104UCVPNGSA4','0104UCVPNGSA5')
                    AND idm.mas_code not in ('0104UCPSREGSMT','0104UREGCPSRTL2')
                    AND idm.tid not in ('010105001102','010105001202')
                GROUP BY
                    ae.institution_id ,
                    idm.merch_id ,
                    idm.card_scheme,
                    idm.TRANS_CCD
                ORDER BY
                    idm.merch_id"
        }

        "AXBORDER" {
            set nm "SELECT
                        ifl.institution_id INST_ID,
                        idm.merch_id MERCH_ID,
                        idm.TRANS_CCD CURR_CD ,
                        idm.card_scheme CARD_SCHEME,
                        COUNT(idm.trans_seq_nbr) COUNT,
                        SUM(idm.amt_trans) AMOUNT,
                        'AX_BORDER' MAS_CODE
                    FROM
                        masclr.in_draft_view idm
                    JOIN masclr.trans_enrichment te
                        ON idm.trans_seq_nbr = te.trans_seq_nbr
                    JOIN masclr.in_file_log ifl
                        ON ifl.in_file_nbr = idm.in_file_nbr
                    JOIN masclr.BIN b
                            ON idm.card_scheme = b.card_scheme
                        AND te.iss_bin = b.bin
                    WHERE
                        ifl.incoming_dt >= to_date(:year_var || :month_var, 'YYYYMM')
                        and ifl.incoming_dt < last_day(to_date(:year_var || :month_var, 'YYYYMM'))+1
                        AND ifl.institution_id = :inst_id_var
                        AND idm.card_scheme = '03'
                        AND idm.MAJOR_CAT IN ('SALES','REFUNDS')
                        AND b.region != '1'
                    GROUP BY
                        ifl.institution_id ,
                        idm.merch_id ,
                        idm.TRANS_CCD,
                        idm.card_scheme,
                        'AX_BORDER'
                    ORDER BY
                        idm.merch_id"
        }

        "AXCNPRES" {
            set nm "SELECT
                        ifl.institution_id INST_ID,
                        idm.merch_id MERCH_ID,
                        idm.TRANS_CCD CURR_CD ,
                        idm.card_scheme CARD_SCHEME,
                        COUNT(idm.trans_seq_nbr) COUNT,
                        SUM(idm.amt_trans) AMOUNT,
                        'AX_CARD_NOT_PRESENT' MAS_CODE
                    FROM
                        masclr.in_draft_view idm
                    JOIN masclr.trans_enrichment te
                        ON idm.trans_seq_nbr = te.trans_seq_nbr
                    JOIN masclr.in_file_log ifl
                        ON ifl.in_file_nbr = idm.in_file_nbr
                    JOIN masclr.BIN b
                            ON idm.card_scheme = b.card_scheme
                        AND te.iss_bin = b.bin
                    WHERE
                        ifl.incoming_dt >= to_date(:year_var || :month_var, 'YYYYMM')
                        and ifl.incoming_dt < last_day(to_date(:year_var || :month_var, 'YYYYMM'))+1
                        AND ifl.institution_id = :inst_id_var
                        AND idm.card_scheme = '03'
                        AND idm.MAJOR_CAT IN ('SALES','REFUNDS')
                        AND idm.pos_ch_present != '1'
                    GROUP BY
                        ifl.institution_id ,
                        idm.merch_id ,
                        idm.TRANS_CCD,
                        idm.card_scheme,
                        'AX_CARD_NOT_PRESENT'
                    ORDER BY
                        idm.merch_id"
        }

        "MCDWNGRD" {
            set nm "
                SELECT
                    ae.institution_id                                 INST_ID,
                    idm.merch_id                                     MERCH_ID,
                    idm.merch_name                                 MERCH_NAME,
                    idm.card_scheme                               CARD_SCHEME,
                    idm.trans_ccd                                     CURR_CD,
                    COUNT(idm.trans_seq_nbr)                            COUNT,
                    SUM(idm.amt_trans)                                 AMOUNT,
                    'MC_INTCHG_DOWNGRADE'                         as MAS_CODE
                FROM
                    masclr.in_draft_main idm
                JOIN masclr.in_file_log ifl
                    ON  ifl.in_file_nbr = idm.in_file_nbr
                JOIN FLMGR_INTERCHANGE_RATES fir
                    ON fir.usage = 'INTERCHANGE' and fir.CARD_SCHEME = '05'
                    and (fir.region in ('ALL','USA') or fir.region is null)
                    and (fir.MAS_CODE = idm.MAS_CODE or fir.MAS_CODE = idm.MAS_CODE_DOWNGRADE)
                join tid_adn ta
                    ON ta.usage = 'CLR'
                    and idm.tid = ta.tid
                JOIN ACQ_ENTITY ae
                    ON idm.MERCH_ID = ae.ENTITY_ID and idm.SEC_DEST_INST_ID = ae.INSTITUTION_ID
                WHERE
                    ifl.incoming_dt >=              to_date(:year_var || :month_var, 'YYYYMM')
                    and ifl.incoming_dt <  last_day(to_date(:year_var || :month_var, 'YYYYMM'))+1
                    AND ae.institution_id in (:inst_id_var)
                    AND idm.card_scheme = '05'
                    AND (idm.mas_code like '%STD%' or idm.MAS_CODE_DOWNGRADE like '%STD%' )
                    and ta.MAJOR_CAT = 'RECLASS'
                    and idm.ACTIVITY_DT >= '15-JUL-2019'
                GROUP BY
                    ae.institution_id ,
                    idm.merch_id,
                    idm.merch_name ,
                    idm.card_scheme,
                    idm.TRANS_CCD
                ORDER BY
                    idm.merch_id"
        }

        "DSNOQUAL" {
            set nm "
                SELECT
                    ae.institution_id                                 INST_ID,
                    idm.merch_id                                     MERCH_ID,
                    idm.merch_name                                 MERCH_NAME,
                    idm.card_scheme                               CARD_SCHEME,
                    idm.trans_ccd                                     CURR_CD,
                    COUNT(idm.trans_seq_nbr)                            COUNT,
                    SUM(idm.amt_trans)                                 AMOUNT,
                    'DS_NON_QUALIFIED'                            as MAS_CODE
                FROM
                    masclr.in_draft_main idm
                JOIN masclr.in_file_log ifl
                    ON  ifl.in_file_nbr = idm.in_file_nbr
                JOIN FLMGR_INTERCHANGE_RATES fir
                    ON fir.usage = 'INTERCHANGE' and fir.CARD_SCHEME = '08'
                    and (fir.region in ('ALL','USA') or fir.region is null)
                    and (fir.MAS_CODE = idm.MAS_CODE or fir.MAS_CODE = idm.MAS_CODE_DOWNGRADE)
                join tid_adn ta
                    ON ta.usage = 'CLR'
                    and idm.tid = ta.tid
                JOIN ACQ_ENTITY ae
                    ON idm.MERCH_ID = ae.ENTITY_ID and idm.SEC_DEST_INST_ID = ae.INSTITUTION_ID
                WHERE
                    ifl.incoming_dt >=              to_date(:year_var || :month_var, 'YYYYMM')
                    and ifl.incoming_dt <  last_day(to_date(:year_var || :month_var, 'YYYYMM'))+1
                    AND ae.institution_id in (:inst_id_var)
                    AND idm.card_scheme = '08'
                    AND (idm.mas_code like '%MID%' or idm.mas_code like '%BASE%'
                    or idm.mas_code like '%STD%'
                    or idm.MAS_CODE_DOWNGRADE like '%MID%'
                    or idm.MAS_CODE_DOWNGRADE like '%BASE%'
                    or idm.MAS_CODE_DOWNGRADE like '%STD%' )
                    and ta.MAJOR_CAT in ('SALES','REFUNDS','RECLASS')

                GROUP BY
                    ae.institution_id ,
                    idm.merch_id,
                    idm.merch_name ,
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
                    idm.card_scheme                                  CARD_SCHEME,
                    idm.TRANS_CCD                                        CURR_CD,
                    COUNT(idm.trans_seq_nbr)                               COUNT,
                    SUM(idm.amt_trans)                                    AMOUNT,
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

        "AVSASSOC" {
            set nm "select
                        mar.institution_id                   INST_ID,
                        m.visa_id                            MERCH_ID,
                        CASE t.card_type
                            when 'DB' then '02'
                            when 'AX' then '03'
                            when 'VS' then '04'
                            when 'MC' then '05'
                            when 'DS' then '08'
                            else '00'
                        END                                  CARD_SCHEME,
                        m.CURRENCY_CODE                      CURR_CD,
                        count(*)                             COUNT,
                        sum(t.amount)*100                    AMOUNT,
                        CASE t.card_type
                            when 'DB' then '02'
                            when 'AX' then '03'
                            when 'VS' then '04'
                            when 'MC' then '05'
                            when 'DS' then '08'
                            else '00'
                        END ||'AVS_AUTH'                     MAS_CODE
                    from teihost.transaction t
                    join teihost.merchant m
                        on t.mid = m.mid
                    join teihost.merchant_addenda_rt mar
                        on m.mid = mar.mid
                    where
                        mar.institution_id = :inst_id_var
                        and t.authdatetime >= to_char(to_date(:year_var || :month_var, 'YYYYMM')-1,'YYYYMMDD')
                        and t.authdatetime <  to_char(last_day(to_date(:year_var || :month_var, 'YYYYMM')),'YYYYMMDD')
                        and t.avs_response not in (' ', 'U')
                        and t.transaction_type not in ('U', 'N', 'Y')
                        and t.card_type = 'MC'
                        and m.visa_id is not null
                        and m.visa_id != ' '
                    group by
                        mar.institution_id,
                        m.visa_id,
                        CASE t.card_type
                            when 'DB' then '02'
                            when 'AX' then '03'
                            when 'VS' then '04'
                            when 'MC' then '05'
                            when 'DS' then '08'
                            else '00'
                        END,
                        m.CURRENCY_CODE,
                        CASE t.card_type
                            when 'VS' then '04'
                            when 'MC' then '05'
                            when 'DS' then '08'
                            when 'AX' then '03'
                            when 'DB' then '02'
                            else '00' END ||'_AVS_AUTH'
                    order by m.visa_id"
        }

        "CVVASSOC" {
            set nm "select
                        mar.institution_id                   INST_ID,
                        m.visa_id                            MERCH_ID,
                        CASE t.card_type
                            when 'DB' then '02'
                            when 'AX' then '03'
                            when 'VS' then '04'
                            when 'MC' then '05'
                            when 'DS' then '08'
                            else '00'
                        END                                  CARD_SCHEME,
                        m.CURRENCY_CODE                      CURR_CD,
                        count(*)                             COUNT,
                        sum(t.amount)*100                    AMOUNT,
                        CASE t.card_type
                            when 'DB' then '02'
                            when 'AX' then '03'
                            when 'VS' then '04'
                            when 'MC' then '05'
                            when 'DS' then '08'
                            else '00'
                        END ||'CVV_AUTH'                     MAS_CODE
                    from teihost.transaction t
                    join teihost.merchant m
                        on t.mid = m.mid
                    join teihost.merchant_addenda_rt mar
                        on m.mid = mar.mid
                    where
                        mar.institution_id = :inst_id_var
                        and t.authdatetime >= to_char(to_date(:year_var || :month_var, 'YYYYMM')-1,'YYYYMMDD')
                        and t.authdatetime <  to_char(last_day(to_date(:year_var || :month_var, 'YYYYMM')),'YYYYMMDD')
                        and t.cvv is not null
                        and t.cvv != ' '
                        and (t.card_present is null or t.card_present != '1')
                        and t.request_type between '0100' and '0499'
                        and t.request_type not in ('0250', '0262')
                        and t.card_type = 'MC'
                        and m.visa_id is not null
                        and m.visa_id != ' '
                    group by
                        mar.institution_id,
                        m.visa_id,
                        CASE t.card_type
                            when 'DB' then '02'
                            when 'AX' then '03'
                            when 'VS' then '04'
                            when 'MC' then '05'
                            when 'DS' then '08'
                            else '00'
                        END,
                        m.CURRENCY_CODE,
                        CASE t.card_type
                            when 'VS' then '04'
                            when 'MC' then '05'
                            when 'DS' then '08'
                            when 'AX' then '03'
                            when 'DB' then '02'
                            else '00' END ||'_CVV_AUTH'
                    order by m.visa_id"
        }

        "SEC" {
            set nm "select
                        mar.institution_id                   INST_ID,
                        m.visa_id                            MERCH_ID,
                        CASE t.card_type
                            when 'DB' then '02'
                            when 'AX' then '03'
                            when 'VS' then '04'
                            when 'MC' then '05'
                            when 'DS' then '08'
                            else '00'
                        END                                  CARD_SCHEME,
                        m.CURRENCY_CODE                      CURR_CD,
                        count(*)                             COUNT,
                        sum(t.amount)                        AMOUNT,
                        'MC_SECR_CODE'                     MAS_CODE
                    from teihost.transaction t
                    join teihost.ecomm_addendum_auth eaa
                        on eaa.unique_id = t.other_data4
                    join teihost.merchant m
                        on t.mid = m.mid
                    join teihost.merchant_addenda_rt mar
                        on m.mid = mar.mid
                    where
                        mar.institution_id = :inst_id_var
                        and t.authdatetime >= to_char(to_date(:year_var || :month_var, 'YYYYMM')-1,'YYYYMMDD')
                        and t.authdatetime <  to_char(last_day(to_date(:year_var || :month_var, 'YYYYMM')),'YYYYMMDD')
                        and length(eaa.cavv) > 1
                        and length(eaa.xid) > 1
                        and length(eaa.eci) > 1
                        and t.card_type = 'MC'
                        and m.visa_id is not null
                        and m.visa_id != ' '
                    group by
                        mar.institution_id,
                        m.visa_id,
                        CASE t.card_type
                            when 'DB' then '02'
                            when 'AX' then '03'
                            when 'VS' then '04'
                            when 'MC' then '05'
                            when 'DS' then '08'
                            else '00'
                        END,
                        m.CURRENCY_CODE,
                        'MC_SECR_CODE'
                    order by m.visa_id"
        }

        "MISAUTH" {
            set nm "select
                        mar.institution_id                                INST_ID,
                        m.visa_id                                         MERCH_ID,
                        CASE t.card_type
                            when 'DB' then '02'
                            when 'AX' then '03'
                            when 'VS' then '04'
                            when 'MC' then '05'
                            when 'DS' then '08'
                            else '00'
                        END                                               CARD_SCHEME,
                        m.currency_code                                   CURR_CD,
                        sum(
                            case
                            when t.request_type = '0100' then 1
                            else -1
                            end
                        )                                                 COUNT,
                        0                                                 AMOUNT,
                        case t.card_type
                          when 'VS' then  'VS_MISUSE_AUTH'
                          when 'MC' then
                            case aa.auth_type
                              when 'FINAL' then 'MC_MISUSE_FINAL_AUTH'
                              when 'UNDEFINED' then 'MC_MISUSE_UNDEF_AUTH'
                              when 'PRE' then 'MC_MISUSE_PRE_AUTH'
                            else 'MC_MISUSE_UNDEF_AUTH'
                            end
                        end                                               MAS_CODE
                    from transaction t
                    join teihost.merchant m
                        on t.mid = m.mid
                    join teihost.merchant_addenda_rt mar
                        on m.mid = mar.mid
                    left outer join auth_addenda aa
                    on aa.unique_id = t.other_data4
                    where
                        mar.institution_id = :inst_id_var
                        and t.authdatetime >= to_char(to_date(:year_var || :month_var, 'YYYYMM')-1,'YYYYMMDD')
                        and t.authdatetime <  to_char(last_day(to_date(:year_var || :month_var, 'YYYYMM')),'YYYYMMDD')
                        and t.card_type in ('VS','MC')
                        and t.status not in ('D')
                        and t.amount != 0
                        and t.request_type not in ('0490')
                        and t.request_type not in ('0200', '0110', '0220', '0420')
                        and m.visa_id is not null
                        and m.visa_id != ' '
                    group by
                        mar.institution_id,
                        m.visa_id,
                        CASE t.card_type
                            when 'DB' then '02'
                            when 'AX' then '03'
                            when 'VS' then '04'
                            when 'MC' then '05'
                            when 'DS' then '08'
                            else '00'
                        END,
                        m.currency_code,
                        case t.card_type
                          when 'VS' then  'VS_MISUSE_AUTH'
                          when 'MC' then
                            case aa.auth_type
                              when 'FINAL' then 'MC_MISUSE_FINAL_AUTH'
                              when 'UNDEFINED' then 'MC_MISUSE_UNDEF_AUTH'
                              when 'PRE' then 'MC_MISUSE_PRE_AUTH'
                            else 'MC_MISUSE_UNDEF_AUTH'
                            end
                        end
                    having sum(case when t.request_type = '0100' then 1 else -1 end) > 0
                    order by
                        mar.institution_id,
                        m.visa_id"
        }

        "MISCAPT" {
            set nm "select
                        mar.institution_id                          INST_ID,
                        m.visa_id                                   MERCH_ID,
                        CASE t.card_type
                            when 'DB' then '02'
                            when 'AX' then '03'
                            when 'VS' then '04'
                            when 'MC' then '05'
                            when 'DS' then '08'
                            else '00'
                        END                                         CARD_SCHEME,
                        m.currency_code                             CURR_CD,
                        count(*)                                    COUNT,
                        0                                           AMOUNT,
                        t.card_type || '_MISUSE_AUTH'             MAS_CODE,
                        m.SIC_CODE                                  MCC
                    from transaction t
                    join teihost.merchant m
                        on t.mid = m.mid
                    join teihost.merchant_addenda_rt mar
                        on m.mid = mar.mid
                    where
                        mar.institution_id = :inst_id_var
                        and t.authdatetime >= to_char(to_date(:year_var || :month_var, 'YYYYMM')-1,'YYYYMMDD')
                        and t.authdatetime <  to_char(last_day(to_date(:year_var || :month_var, 'YYYYMM')),'YYYYMMDD')
                        and t.card_type in ('VS','MC')
                        and t.status not in ('D')
                        and t.request_type in ('0250')
                        and t.amount != 0
                        and to_date(t.shipdatetime, 'YYYYMMDDHH24MISS') -
                            to_date(t.authdatetime, 'YYYYMMDDHH24MISS') > 10
                        and m.visa_id is not null
                        and m.visa_id != ' '
                    group by
                        mar.institution_id,
                        m.visa_id,
                        CASE t.card_type
                            when 'DB' then '02'
                            when 'AX' then '03'
                            when 'VS' then '04'
                            when 'MC' then '05'
                            when 'DS' then '08'
                            else '00'
                        END,
                        m.currency_code,
                        t.card_type || '_MISUSE_AUTH',
                        m.SIC_CODE
                    order by
                        mar.institution_id,
                        m.visa_id"
        }

        "DCLNAUTH" {
            set nm "select
                institution_id                   INST_ID,
                visa_id                          MERCH_ID,
                CASE card_type
                     when 'DB' then '02'
                     when 'AX' then '03'
                     when 'VS' then '04'
                     when 'MC' then '05'
                     when 'DS' then '08'
                     else '00'
                END                              CARD_SCHEME,
                currency_code                    CURR_CD,
                sum(cnt)                         COUNT,
                0                                AMOUNT,
                mas_code
                from (
            select                       
                mar.institution_id,
                m.visa_id,
                t.card_type,
                t.cardnum,
                case
                when t.card_type = 'VS' and afc.cntry_code_alpha2 = 'US'
                      then 'VS_MISUSE_EXCES_AUTH_US'
                when t.card_type = 'VS' and afc.cntry_code_alpha2 != 'US'
                      then 'VS_MISUSE_EXCES_AUTH_INTL'
                when  t.card_type = 'MC' then 'MC_MISUSE_EXCES_AUTH'   
                when t.card_type = 'VS' then 'VS_MISUSE_EXCES_AUTH_US'
                end mas_code,
                m.currency_code,
                case
                when t.card_type = 'VS' then substr(t.authdatetime,1,6)
                when t.card_type = 'MC' then substr(t.authdatetime,1,8)
                end decline_time,
                case
                when t.card_type = 'VS' then count(*)-15
                when t.card_type = 'MC' then count(*)-20
                end cnt
            from transaction t
            join merchant m
                 on t.mid = m.mid
            join tei_merchant_addenda_rt mar
                 on m.mid = mar.mid
            left join auth_fund_cntry afc
                on t.other_data4 = afc.other_data4
            where
                 mar.institution_id = :inst_id_var
                 and t.shipdatetime >= to_char(to_date(:year_var || :month_var, 'YYYYMM')-1,'YYYYMMDD')
                 and t.shipdatetime <  to_char(last_day(to_date(:year_var || :month_var, 'YYYYMM')),'YYYYMMDD')
                 and t.card_type in ('VS','MC')
                 and t.request_type in ('0100', '0200', '0250') and t.action_code != '000'
                 and m.visa_id is not null
                 and m.visa_id != ' '
             group by mar.institution_id,
                 m.visa_id,
                 t.card_type,
                 t.cardnum,
                 m.currency_code,
                 case
                 when t.card_type = 'VS' then substr(t.authdatetime,1,6)
                 when t.card_type = 'MC' then substr(t.authdatetime,1,8)
                 end ,
                 case
                 when t.card_type = 'VS' and afc.cntry_code_alpha2 = 'US'
                       then 'VS_MISUSE_EXCES_AUTH_US'
                 when t.card_type = 'VS' and afc.cntry_code_alpha2 != 'US'
                       then 'VS_MISUSE_EXCES_AUTH_INTL'  
                 when  t.card_type = 'MC' then 'MC_MISUSE_EXCES_AUTH'
                 when t.card_type = 'VS' then 'VS_MISUSE_EXCES_AUTH_US'    
                 end
            having (t.card_type = 'VS'  and count(*) > 15 )
                   or (t.card_type = 'MC'  and count(*) > 20 )                  
            order by mar.institution_id,
                 m.visa_id,
                 t.cardnum,
                 t.card_type,
                 m.currency_code,
                 case
                 when t.card_type = 'VS' and afc.cntry_code_alpha2 = 'US'
                       then 'VS_MISUSE_EXCES_AUTH_US'
                 when t.card_type = 'VS' and afc.cntry_code_alpha2 != 'US'
                       then 'VS_MISUSE_EXCES_AUTH_INTL'    
                 when  t.card_type = 'MC' then 'MC_MISUSE_EXCES_AUTH'
                 when t.card_type = 'VS' then 'VS_MISUSE_EXCES_AUTH_US'
                 end
                 )
        group by     institution_id,
                    visa_id,
                    card_type,
                    currency_code,
                    mas_code
        order by     institution_id,
                   visa_id,
                   card_type,
                   currency_code"
        }

        "SMS_ITEM" {
            set nm "select
                        mar.institution_id INST_ID,
                        CASE m.debit_id
                            when ' ' then m.visa_id
                            else m.debit_id
                        END MERCH_ID,
                        CASE t.card_type
                            when 'DB' then '02'
                        END CARD_SCHEME,
                        m.CURRENCY_CODE CURR_CD,
                        count(*) COUNT,
                        sum(t.amount)*100 AMOUNT,
                        CASE t.network_id
                            when '08' then 'STAR'
                            when '20' then 'ACCEL'
                        END ||'_DBT_MONTHLY' MAS_CODE
                    from teihost.tranhistory t
                    join teihost.merchant m
                        on t.mid = m.mid
                    join teihost.merchant_addenda_rt mar
                        on m.mid = mar.mid
                    where
                        mar.institution_id = :inst_id_var
                        and t.authdatetime >= to_char(to_date(:year_var || :month_var, 'YYYYMM')-1,'YYYYMMDD')
                        and t.authdatetime < to_char(last_day(to_date(:year_var || :month_var, 'YYYYMM')),'YYYYMMDD')
                        and t.card_type = 'DB'
                        and t.network_id in ('08','20')
                    group by
                        mar.institution_id,
                        CASE m.debit_id
                            when ' ' then m.visa_id
                            else m.debit_id
                        END ,
                        CASE t.card_type
                            when 'DB' then '02'
                        END,
                        m.CURRENCY_CODE,
                        CASE t.network_id
                            when '08' then 'STAR'
                            when '20' then 'ACCEL'
                        END ||'_DBT_MONTHLY'
                    order by
                        CASE m.debit_id
                            when ' ' then m.visa_id
                            else m.debit_id
                        END
                        "
        }

        "3DS_AUTH" {
            set nm "select
                        mar.institution_id INST_ID,
                        m.visa_id MERCH_ID,
                        m.CURRENCY_CODE CURR_CD,
                        CASE card_type
                            when 'DB' then '02'
                            when 'AX' then '03'
                            when 'VS' then '04'
                            when 'MC' then '05'
                            when 'DS' then '08'
                        else '00'
                        END CARD_SCHEME,
                        count(*) COUNT,
                        sum(t.amount)*100 AMOUNT,
                        CASE t.card_type
                            when 'DB' then 'DB'
                            when 'AX' then 'AX'
                            when 'VS' then 'VS'
                            when 'MC' then 'MC'
                            when 'DS' then 'DS'
                            else 'OTHER'
                        END ||'_3DS_PER_TRANS' MAS_CODE
                    from teihost.transaction t
                    join teihost.merchant m
                        on t.mid = m.mid
                    join teihost.merchant_addenda_rt mar
                        on m.mid = mar.mid
                    join teihost.auth_addenda aa
                        on aa.unique_id = t.other_data4
                    where
                        mar.institution_id = :inst_id_var
                        and t.authdatetime >= to_char(to_date(:year_var || :month_var, 'YYYYMM')-1,'YYYYMMDD')
                        and t.authdatetime < to_char(last_day(to_date(:year_var || :month_var, 'YYYYMM')),'YYYYMMDD')
                        and (t.card_present is null or t.card_present != '1')
                        and t.request_type between '0100' and '0499'
                        and t.request_type not in ('0250','0262')
                        and aa.v3ds_type in ('VBV','SC','PB','SK','') 
                        and m.visa_id is not null
                        and m.visa_id != ' '
                    group by
                        mar.institution_id,
                        m.visa_id,
                        CASE card_type
                            when 'DB' then '02'
                            when 'AX' then '03'
                            when 'VS' then '04'
                            when 'MC' then '05'
                            when 'DS' then '08'
                        else '00'
                        END,
                        m.CURRENCY_CODE,
                        CASE t.card_type
                            when 'DB' then 'DB'
                            when 'AX' then 'AX'
                            when 'VS' then 'VS'
                            when 'MC' then 'MC'
                            when 'DS' then 'DS'
                            else 'OTHER'
                        END ||'_3DS_PER_TRANS'
                    order by m.visa_id"
        }

        "ZEROVERI" {
            #Use to retrieve the intraregional Account status inquiry service transactions
            set nm "
            select
                mar.institution_id                                             INST_ID,
                m.visa_id                                                      MERCH_ID,
                CASE t.card_type
                    when 'DB' then '02'
                    when 'AX' then '03'
                    when 'VS' then '04'
                    when 'MC' then '05'
                    when 'DS' then '08'
                    else '00'
                END                                                            CARD_SCHEME,
                m.currency_code                                                CURR_CD,
                case
                    when t.card_type = 'VS' and afc.acct_fund_src = 'C'
                         and afc.cntry_code_alpha2 = 'US' then 'VS_ZERO_VERI_US_CR'
                    when t.card_type = 'VS' and afc.acct_fund_src in ('D','P')
                         and afc.cntry_code_alpha2 = 'US' then 'VS_ZERO_VERI_US_DB'
                    when t.card_type = 'VS' and afc.acct_fund_src in ('C','D','P')
                         and afc.cntry_code_alpha2 != 'US' then 'VS_ZERO_VERI_INTL'
                    when t.card_type = 'MC' and afc.cntry_code_alpha2 = 'US'
                        then 'MC_ZERO_VERI'
                    when t.card_type = 'MC' and afc.cntry_code_alpha2 != 'US'
                        then 'MC_ZERO_VERI_INTER'
                end                                                         MAS_CODE,
                count(*)                                                    COUNT,
                0                                               AMOUNT
            from transaction t
            join merchant m
                on t.mid = m.mid          
            join tei_merchant_addenda_rt mar
                on mar.mid = m.mid
            join auth_fund_cntry afc
                on t.other_data4 = afc.other_data4
            where
                mar.institution_id = :inst_id_var
                and t.authdatetime >= to_char(to_date(:year_var || :month_var, 'YYYYMM')-1,'YYYYMMDD')
                and t.authdatetime < to_char(last_day(to_date(:year_var || :month_var, 'YYYYMM')),'YYYYMMDD')
                and t.amount = 0
                and t.card_type in ('VS','MC')
                and t.request_type in ('0100','0102','0106','0200','0220','0250','0254','0270','0400','0420','0440','0490','0602' ) 
                and m.visa_id is not null
                and m.visa_id != ' '
           group by
                mar.institution_id,
                m.visa_id,
                CASE t.card_type
                    when 'DB' then '02'
                    when 'AX' then '03'
                    when 'VS' then '04'
                    when 'MC' then '05'
                    when 'DS' then '08'
                    else '00'
                END,
                m.currency_code,
                case
                    when t.card_type = 'VS' and afc.acct_fund_src = 'C'
                         and afc.cntry_code_alpha2 = 'US' then 'VS_ZERO_VERI_US_CR'
                    when t.card_type = 'VS' and afc.acct_fund_src in ('D','P')
                         and afc.cntry_code_alpha2 = 'US' then 'VS_ZERO_VERI_US_DB'
                    when t.card_type = 'VS' and afc.acct_fund_src in ('C','D','P')
                         and afc.cntry_code_alpha2 != 'US' then 'VS_ZERO_VERI_INTL'
                    when t.card_type = 'MC' and afc.cntry_code_alpha2 = 'US'
                        then 'MC_ZERO_VERI'
                    when t.card_type = 'MC' and afc.cntry_code_alpha2 != 'US'
                        then 'MC_ZERO_VERI_INTER'
                end
            order by
                mar.institution_id,
                m.visa_id"
        }

        "NWACQPRO" {
            set nm "
            select
                mar.institution_id                                             INST_ID,
                m.visa_id                                                      MERCH_ID,
                CASE t.card_type
                    when 'DB' then '02'
                    when 'AX' then '03'
                    when 'VS' then '04'
                    when 'MC' then '05'
                    when 'DS' then '08'
                    else '00'
                END                                                            CARD_SCHEME,
                m.currency_code                                                CURR_CD,
                case
                    when afc.acct_fund_src = 'C' and afc.cntry_code_alpha2 = 'US'
                        then 'VISA_ASSMT_FLAT_US_CR'
                    when afc.acct_fund_src in ('D','P') and afc.cntry_code_alpha2 = 'US'
                        then 'VISA_ASSMT_FLAT_US_DB'
                    when afc.acct_fund_src = 'C' and afc.cntry_code_alpha2 != 'US'
                        then 'VISA_ASSMT_FLAT_INTL_CR'
                    when afc.acct_fund_src in ('D','P') and afc.cntry_code_alpha2 != 'US'
                        then 'VISA_ASSMT_FLAT_INTL_DB'
                        else 'VISA_ASSMT_FLAT_US_CR'
                end                                                         MAS_CODE,
                count(*)                                                    COUNT,
                sum(t.amount)*100                                                 AMOUNT
            from transaction t
            join merchant m
                on t.mid = m.mid          
            join tei_merchant_addenda_rt mar
                on mar.mid = m.mid
            join auth_fund_cntry afc
            on t.other_data4 = afc.other_data4
            where
                mar.institution_id = :inst_id_var
                and t.authdatetime >= to_char(to_date(:year_var || :month_var, 'YYYYMM')-1,'YYYYMMDD')
                and t.authdatetime < to_char(last_day(to_date(:year_var || :month_var, 'YYYYMM')),'YYYYMMDD')
                and t.request_type in (
                    '0100', '0200', '0220', '0420', '0440', '0480')
                and t.card_type not in ('DB')
                and t.card_type = 'VS'
                and m.visa_id is not null
                and m.visa_id != ' '
            group by
                mar.institution_id,
                m.visa_id,
                CASE t.card_type
                    when 'DB' then '02'
                    when 'AX' then '03'
                    when 'VS' then '04'
                    when 'MC' then '05'
                    when 'DS' then '08'
                    else '00'
                END,
                m.currency_code,
                case
                    when afc.acct_fund_src = 'C' and afc.cntry_code_alpha2 = 'US'
                        then 'VISA_ASSMT_FLAT_US_CR'
                    when afc.acct_fund_src in ('D','P') and afc.cntry_code_alpha2 = 'US'
                        then 'VISA_ASSMT_FLAT_US_DB'
                    when afc.acct_fund_src = 'C' and afc.cntry_code_alpha2 != 'US'
                        then 'VISA_ASSMT_FLAT_INTL_CR'
                    when afc.acct_fund_src in ('D','P') and afc.cntry_code_alpha2 != 'US'
                        then 'VISA_ASSMT_FLAT_INTL_DB'
                        else 'VISA_ASSMT_FLAT_US_CR'
                end
            order by
                mar.institution_id,
                m.visa_id
            "
        }

        default {
            usage $f_type
            free_db_handle
            exit 1
        }

    }
    # puts $nm
    MASCLR::log_message "get_sql nm: \n\n$nm ;\n" 3
    return $nm
};

proc get_tid {f_type} {
    global nm
    set nm ""
    switch $f_type {
        "VOUCHER"           {set nm "010070020001"}
        "TXNINTGR"          {set nm "010070020001"}
        "AXBORDER"          {set nm "010070020001"}
        "AXCNPRES"          {set nm "010070020001"}
        "TRANSMIS"          {set nm "010070020001"}
        "AVSASSOC"          {set nm "010070020001"}
        "CVVASSOC"          {set nm "010070020001"}
        "SEC"               {set nm "010070020001"}
        "MISAUTH"           {set nm "010070020001"}
        "MISCAPT"           {set nm "010070020001"}
        "MCDWNGRD"          {set nm "010070020001"}
        "DSNOQUAL"          {set nm "010070020001"}
        "DCLNAUTH"          {set nm "010070020001"}
        "SMS_ITEM"          {set nm "010070020001"}
        "3DS_AUTH"          {set nm "010070020001"}
        "ZEROVERI"          {set nm "010070020001"}
        "NWACQPRO"          {set nm "010070020001"}
        default {
            usage
            free_db_handle
            exit 1
        }
    }
    return $nm
};

proc get_fname {f_type} {
    global nm
    set nm ""
    switch $f_type {
        "VOUCHER"     {set nm "VVOUCHER"}
        "TXNINTGR"    {set nm "TXINTEGR"}
        "AXBORDER"    {set nm "AXBORDER"}
        "AXCNPRES"    {set nm "AXCNPRES"}
        "TRANSMIS"    {set nm "TRANSMIS"}
        "AVSASSOC"    {set nm "AVSASSOC"}
        "CVVASSOC"    {set nm "CVVASSOC"}
        "SEC"         {set nm "SECRCODE"}
        "MISAUTH"     {set nm "MISUAUTH"}
        "MISCAPT"     {set nm "MISUCAPT"}
        "MCDWNGRD"    {set nm "MCDWNGRD"}
        "DSNOQUAL"    {set nm "DSNOQUAL"}
        "DCLNAUTH"    {set nm "DCLNAUTH"}
        "SMS_ITEM"    {set nm "SMS_ITEM"}
        "3DS_AUTH"    {set nm "3DS_AUTH"}
        "ZEROVERI"    {set nm "ZEROVERI"}
        "NWACQPRO"    {set nm "NWACQPRO"}
        default {
            usage
            free_db_handle
            exit 1
        }

    }

    return $nm

};

proc free_db_handle {} {
    global clr_get auth_get port_get
    global clr_db_handle auth_db_handle port_db_handle
    # close all the DB connections
    oraclose $clr_get
    oraclose $auth_get
    oraclose $port_get

    if { [catch {oralogoff $clr_db_handle } result ] } {
       puts "Encountered error $result while trying to close CLR DB handle"
    }
    if { [catch {oralogoff $auth_db_handle } result ] } {
       puts "Encountered error $result while trying to close AUTH DB handle"
    }
    if { [catch {oralogoff $port_db_handle } result ] } {
       puts "Encountered error $result while trying to close PORT DB handle"
    }
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
set authdb $env(TSP4_DB)
set db_userid $env(IST_DB_USERNAME)
set db_pwd $env(IST_DB_PASSWORD)
set auth_db_userid $env(ATH_DB_USERNAME)
set auth_db_pwd $env(ATH_DB_PASSWORD)
set port_db_userid $env(PORT_DB_USERNAME)
set port_db_pwd $env(PORT_DB_PASSWORD)
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
    open_cursor_teihost auth_get
    open_cursor_port port_get


    #Opening Output file to write to
    global outfile MODE env programName inst_id
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo mbody

    set outfile [get_outfile]

    if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
        set mbody "Cannot open /create : $fileid in $programName"
        MASCLR::log_message $mbody
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        free_db_handle
        MASCLR::close_all_and_exit_with_code 1
    }

    global rightnow batchtime get_ent clr_get auth_get cnt_type cursor
    global run_year run_mnth get_info port_get

    set cursor ""
    if { $cnt_type == "VOUCHER" || $cnt_type == "TXNINTGR" || $cnt_type == "AXBORDER" ||
         $cnt_type == "AXCNPRES" || $cnt_type ==  "MCDWNGRD" || $cnt_type ==  "DSNOQUAL" ||
         $cnt_type == "TRANSMIS"} {
        set cursor $clr_get
    } elseif {$cnt_type == "ZEROVERI" || $cnt_type == "NWACQPRO" || $cnt_type == "DCLNAUTH"} {
        set cursor $port_get
    } else {
        set cursor $auth_get
    }
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
        oraparse $cursor $get_info
        orabind $cursor :month_var $run_mnth :year_var $run_year :inst_id_var $inst_id
        oraexec $cursor
    } failure] } {
        set mbody "Error parsing, binding or executing get_info sql: $failure \n $get_info"
        MASCLR::log_message "$mbody"
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u - inside $programName" $mailtolist
        exec rm $outfile
        free_db_handle
        MASCLR::close_all_and_exit_with_code 1
    }

    ###### Declaring Variables and initializing
    if { [catch {
        set chkmid " "
        set chkmidt " "
        set totcnt 0
        set totamt 0
        set ftotcnt 0
        set ftotamt 0
        set trlcnt 0
        set loop 1

        ###### While Loop for to fetch records gathered by Sql Select get_info

        while {[set loop [orafetch $cursor -dataarray a -indexbyname]] == 0} {
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
            set rec(amt_original) $a(AMOUNT)
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
    free_db_handle
    MASCLR::close_all_and_exit_with_code 0
    } failure] } {
        set mbody "Error while fetching data from the database or file creation: $failure"
        MASCLR::log_message "$mbody"
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u - inside $programName" $mailtolist
        exec rm $outfile
        free_db_handle
        MASCLR::close_all_and_exit_with_code 1
    }
};

puts "========================================================================================"
set cmd_line "$argv0"
set itr 0
foreach arg $argv {
    #puts "Arg $itr: $arg"
    if {[string match *\ * $arg]} {
        append cmd_line  " " \"$arg\"
    } else {
        append cmd_line  " " $arg
    }
    incr itr
}

set Id "Id"
set Rev "Rev"
set nihil ""

set id_var  "$Id: pass_through_fees.tcl 4877 2019-07-30 19:44:48Z skumar $nihil"
set rev_var "$Rev: 4877 $nihil"
set rev_nbr [lindex [split $rev_var] 1]
set fil_nam [lindex [split $id_var] 1]

MASCLR::log_message "Command line was: $cmd_line"
MASCLR::log_message "Filename and svn revision from svn: $fil_nam, $rev_nbr"
main

puts "==============================================END OF FILE============================================"
