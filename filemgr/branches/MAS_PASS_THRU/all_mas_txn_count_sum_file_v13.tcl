#!/usr/bin/env tclsh

# $Id: all_mas_txn_count_sum_file_v13.tcl 4022 2017-01-13 19:23:40Z skumar $

# Updated Aug 2014 by ECW to fix some holes in the date ranges
#       (Was missing the last day of the month for auth counts)

# Written By Rifat Khan
# Jetpay LLC
 # Changed the trans_ref_data from 25 spaces to 23 spaces and changed the line size
# for MSG detail to 200 bytes.
# revised 20060426 with internal version 1.1 , expected version of 36.0
#
# Changed the complete code reformated for perfomance issue.
# revised 20061201 with internal verion 2.0
#

package require Oratcl
package provide random 1.0

source $env(MASCLR_LIB)/masclr_tcl_lib
source $env(MASCLR_LIB)/mas_file_lib



# Types of counting types
#
# cnt_type      description                                   filename    mas_code
#
#FORCE         Visa Force Fee file for zero floor limit       ZEROFORC    VS_FORCE
#ZEROVERI      Visa & MC Zero Dollar Verification Fee File    ZEROVERI    VS_ZERO_VERI & MC_ZERO_VERI
#DBMONTHLY     PIN Debit Monthly Network fee                  DBMONTHL    DBT_ASSMT_MONTHLY



source [file join [file dirname $argv0 ] counting_procedures.tm]

############################################################################################################

#Environment variables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(CLR4_DB)
set authdb $env(TSP4_DB)

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
global MODE
set MODE "PROD"
set debug false
set MASCLR::DEBUG_LEVEL 0

set cmd_line "$argv0"
set i 0
foreach arg $argv {
    #puts "Arg $i: $arg"
    if {[string match *\ * $arg]} {
        append cmd_line  " " \"$arg\"
    } else {
        append cmd_line  " " $arg
    }
    incr i
}

set Id "Id"
set Rev "Rev"
set nihil ""

set id_var  "$Id: all_mas_txn_count_sum_file_v13.tcl 4022 2017-01-13 19:23:40Z skumar $nihil"
set rev_var "$Rev: 4022 $nihil"
set rev_nbr [lindex [split $rev_var] 1]
set fil_nam [lindex [split $id_var] 1]

############################################################################################################

#GLOBALS

global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year db_login_handle
global db_logon_handle box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c
global msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo cfg_pth
global log_pth arch_pth hold_pth upld_pth stop_pth tmp_pth currdate jdate sdate adate
global rightnow cmonth cdate cyear begindatetime enddatetime begintime endtime cutoff
global batchtime tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt
global tblnm_mf tblnm_e2a tblnm_tr data_jdate inst_curr_cd
global authbegindatetime
global authenddatetime
global inst_dictionary

#TABLE NAMES-----------------------------------------------------

set currdate    [clock format [clock seconds] -format "%Y%m%d"]
set sdate       [clock format [clock scan "$currdate"] -format "%Y%m%d"]
set adate       [clock format [clock scan "$currdate -1 day" ] -format "%Y%m%d"]
set lydate      [clock format [clock scan "$currdate" ] -format "%m"]
set rightnow    [clock format [clock seconds] -format "%Y%m%d000000"]
set cmonth      [clock format [clock scan "$currdate"] -format "%m"]
set cdate       [clock format [clock scan "$currdate"] -format "%d"]
set cyear       [clock format [clock scan "$currdate"] -format "%Y"]
#set rightnow [clock format $rightnow -format "%Y%m%d%H%M%S"]
set jdate       [clock scan "$currdate"  -base [clock seconds] ]
set jdate       [clock format $jdate -format "%y%j"]
set jdate       [string range $jdate 1 end]
set data_jdate ""

set begintime "000000"
set endtime "000000"

set dot "."

proc usage { f_type } {
    if {$f_type != ""} {
        puts stdout "Incorrect Count File Type: $f_type"
    }
    puts stdout "Please follow below instructions to run this code -->
        Code runs with minimum 2 to maximum 5 arguments.
        Arguments parameters:
        1) -i<Institution Id>   (Required Eg: 101, 105, 107 ... etc.)
        2) -c<Count File Type>  (Required Eg: AU, AUTH, ACH ... etc.)
        3) -m<Month>            (Optional Eg: 1-12 OR JAN-DEC <> Defualt Value: Current Month)
        4) -y<Year>             (Optional Eg: 2008, 2007 <> Format: YYYY <> Default Value: Current Year)
        5) -t<Cutoff Time>      (Optional Eg: 020000, 143000 <> Format: HH24MISS <> Default Value: 000000)
        Example:
        mas_txn_count_sum_file_v13.tcl -i101 -cAUTH -m9
        mas_txn_count_sum_file_v13.tcl -i107 -cAU -mJAN -y2007
        "

    puts stdout "\n Valid Count File Type values are:
         1) ACH          -- ACH transaction count file
         2) ASSESS       -- Assessment fee fix with transaction count file
         3) ASSOC        -- Association code fix fee transaction count file
         4) AU           -- Credit Card Account Updater transaction count file
                            This is now used for all card types, e.g., VAU and MBU.
         5) AUTH         -- Credit Card Authorization transaction count file
         6) AUTHDB       -- Debit Card transaction count file
         7) AVSAUTH      -- Credit Card AVS check transaction count file
         8) AVS          -- Credit Card AVS Block transaction count file
         9) BIN          -- Credit Card BIN Block transaction count file
        10) BTCH         -- Credit Card Batch Header count file
        11) CNP          -- Count Card Present (CP) and Card Not Present (CNP)
        12) CVV2         -- Credit Card CVV2 Block transaction count file
        13) CVVAUTH      -- Credit Card CVV2 check transaction count file
        14) DB_FIX       -- Debit card fix for transaction count file
        15) FRD          -- Credit Card Fraud count file
        16) PROGRAM_BLOCK
        17) RCYL         -- Credit Card Attempted Recycle transaction count file
        18) SEC          -- Credit Card Secure code transaction count file
        19) VBV          -- Credit Card VBV transaction count file
        20) VLCK         -- Velocity Check transaction count file
        21) VZEROFORCE   -- Visa Zero Dollar Floor Limit Fee File
        22) ZEROVERI     -- Visa & MC Zero Dollar Verification Fee File 
        23) DBMONTHLY    -- PIN Debit Monthly Network fee
        "
}

# internal routine that returns the last valid day of a given month and year
proc lastDay {month year} {
    set days [clock format [clock scan "+1 month -1 day" \
                  -base [clock scan "$month/01/$year"]] -format %d]
}


proc get_inst {} {
    global inst_dictionary, inst_id inst_curr_cd
    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year auth_get clr_get clr_get1 clr_get2
    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo cfg_pth log_pth arch_pth hold_pth
    global upld_pth stop_pth tmp_pth currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime
    global enddatetime begintime endtime cutoff batchtime tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg
    global tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a tblnm_tr

    ## *** BANK NAME ***
    set inst_query_string "
        select
          i.institution_id, i.inst_name, ma.cntry_code, ma.country,
          i.inst_curr_code curr_code, cc.curr_code_alpha3 curr_code_alpha, cc.curr_name,
          case when ma.cntry_code = '840' then 'N' else 'Y' end USE_MAS_DESC
        from institution i
        join inst_address ia
        on ia.institution_id = i.institution_id
        join master_address ma
        on ma.institution_id = ia.institution_id
        and ma.address_id = ia.address_id
        join currency_code cc
        on cc.curr_code = i.inst_curr_code
        where i.institution_id = '$inst_id'"
    MASCLR::log_message "inst_query_string: \n$inst_query_string\n\n" 3
    orasql $clr_get1 $inst_query_string
    set inst_list [oracols $clr_get1]

    while {[orafetch $clr_get1 -dataarray bank -indexbyname] != 1403} {
        foreach {col} $inst_list {
            dict set inst_dictionary $col $bank($col)
        }
    }

    set icurr_code "CURR_CODE"
    set inst_curr_cd [dict get $inst_dictionary $icurr_code]
    MASCLR::log_message "inst_dictionary: \n$inst_dictionary" 3
    MASCLR::log_message "inst_curr_cd: \n$inst_curr_cd" 3

}

proc get_sql {f_type midlist} {

    global currdate jdate sdate adate rightnow cmonth cdate cyear
    global begindatetime enddatetime begintime endtime cutoff batchtime
    global tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf
    global tblnm_bt tblnm_mf tblnm_e2a tblnm_tr
    global inst_id run_month_year data_jdate
    global authbegindatetime
    global authenddatetime

    # skipping MID RIVER-RIDGE-CAMP on auth counts because this is an ACH only that
    # was put into 105.  This will eventually move to 808

    switch $f_type {
        # this is a hardcoded mess for Woot.

        "WOOT" {
            set nm "select mid, count(amount) as cnt, sum(amount) as amt, card_type, request_type,
                        'A' as status
                from tranhistory
                where card_type in ('MC', 'VS') and mid in
                    ('KIDWOOT', 'SELLOUT.WOOT.001', 'SHIRTWOOTCOM', 'WINEWOOTCOM', 'WOOTCOM')
                and status = '105'
                and settle_date >= $authbegindatetime
                AND settle_date < $authenddatetime
                group by mid, card_type, request_type, 'A'"
        }

        "DISC_DATA" {
            set nm "select entity_id as mid, count(*) as cnt, sum(amt_billing) as amt,
                        'DS' as card_type, decode (tid, '010003005101', '0200', '0420') as request_type,
                        'A' as status
                    from mas_trans_log
                    where to_char(gl_date, 'MON-YYYY') = $run_month_year
                    and card_scheme = '08'
                    and institution_id = '$inst_id'
                    and tid in ('010003005101', '010003005102')
                    and (institution_id, file_id) in (
                    select institution_id, file_id
                        from mas_file_log where to_char(receive_date_time, 'MON-YYYY') = $run_month_year
                        and institution_id = '$inst_id'
                    )
                    group by entity_id, 'DS', decode (tid, '010003005101', '0200', '0420'), 'A'
                    order by entity_id"
        }

        "AUTH" {
            set nm "select  /*+INDEX(t TRANSACTION_AUTHDATETIME)*/
                         mid,
                         count(amount) as cnt,
                         0 as amt,
                         sum(amount) as amt_sum,
                         card_type,
                         request_type,
                         decode (action_code, '000', 'A', 'D') as status,
                         case when request_type = '0250'
                                and other_data3 = other_data4
                           then 1 else 0 end od3_eq_od4
                    from teihost.transaction
                    where
                         mid in ($midlist)
                         and authdatetime >= $authbegindatetime
                         and authdatetime < $authenddatetime
                         and request_type in (
                             '0100', '0102', '0190', '0200', '0220', '0240', '0250',
                             '0252', '0260', '0352', '0354', '0356', '0358', '0420',
                             '0440', '0450', '0460', '0480', '0500', '0530')
                         and card_type not in ('DB')
                    group by
                         mid,
                         card_type,
                         request_type,
                         decode (action_code, '000', 'A', 'D'),
                         case when request_type = '0250'
                                and other_data3 = other_data4
                           then 1 else 0 end
                    order by mid"
        }

        "AUTH2" {
            set nm "select  /*+INDEX(t TRANSACTION_AUTHDATETIME)*/
                          mid,
                          count(amount) as cnt,
                          sum(amount) as amt,
                          card_type,
                          request_type,
                          decode (action_code, '000', 'A', 'D') as status
                    from teihost.transaction
                    where
                          mid in ($midlist)
                          and authdatetime >= $authbegindatetime
                          and authdatetime < $authenddatetime
                          and request_type in ('0100', '0200')
                          and card_type in ('VS', 'MC')
                    group by
                          mid,
                          card_type,
                          request_type,
                          decode (action_code, '000', 'A', 'D')
                    order by mid"
        }

        "AUTHDB" {
            set nm "select  /*+INDEX(t TRANSACTION_AUTHDATETIME)*/
                         mid,
                         count(amount) as cnt,
                         sum(amount) as amt,
                         card_type,
                         request_type,
                         decode (action_code, '000', 'A', 'D') as status
                    from teihost.transaction
                    where
                         mid in ($midlist)
                         and authdatetime >= $authbegindatetime
                         and authdatetime < $authenddatetime
                         and card_type in ('DB')
                    group by
                         mid,
                         card_type,
                         request_type,
                         decode (action_code, '000', 'A', 'D')
                    order by mid"
        }
        # another hardcoded mess for Woot

        "WOOT2" {
            set nm "select  /*+INDEX(t TRANSACTION_AUTHDATETIME)*/
                          mid,
                          count(amount) as cnt,
                          sum(amount) as amt,
                          '00' as card_type,
                          '0200' as request_type,
                          'A' as status
                    from teihost.transaction
                    where
                        mid in ('KIDWOOT',
                            'SELLOUT.WOOT.001',
                            'SHIRTWOOTCOM',
                            'WINEWOOTCOM',
                            'WOOTCOM')
                        and authdatetime >= $authbegindatetime
                        and authdatetime < $authenddatetime
                        and request_type in (
                            '0100', '0102', '0190', '0200', '0220', '0240',
                            '0250', '0252', '0260', '0352', '0354', '0356',
                            '0358', '0400', '0402', '0420', '0440', '0450',
                            '0460', '0480', '0500', '0530')
                    group by
                        mid,
                        '00',
                        '0200',
                        'A'
                    order by mid"
        }

        "AU" {
            # AU counts Visa Account Updater and MasterCard Billing Updater
            # transactions from the batch_file and batch_transaction tables
            # once other associations have working account updater programs,
            # these counts will be included.
            #
            set nm "
                SELECT
                    m.visa_id                    as mid,
                    COUNT(1)                     as cnt,
                    SUM(bt.amount)               AS amt,
                    '00'                         AS card_type,
                    '0200'                       AS request_type,
                    'A'                          AS status,
                    t.mid                        as auth_mid,
                    bf.mid                       as tid,
                    eta.institution_id           as institution_id,
                    sum(case
                        when bt.vau_reason IN
                            ('U', 'A', 'C', 'E')
                        then 1 else 0 end)       as cnt_update
                FROM teihost.batch_transaction bt
                join teihost.batch_file bf
                  on bf.job_id = bt.job_id
                join teihost.terminal t
                on bf.mid = t.tid
                join merchant m
                on m.mid = t.mid
                join merchant_addenda_rt eta
                on eta.mid = t.mid
                WHERE   bf.submission_datetime >= $authbegindatetime
                    AND bf.submission_datetime <  $authenddatetime
                    AND regexp_like(bt.orig_line, '^AU,', 'm')
                    and eta.institution_id  = '$inst_id'
                GROUP BY
                    m.visa_id, eta.institution_id, t.mid, bf.mid
                ORDER BY
                    m.visa_id, eta.institution_id, t.mid, bf.mid"
        }

        "RCYL" {
            set nm "SELECT
                         mid,
                         COUNT(amount) AS cnt,
                         SUM(amount) AS amt,
                         card_type,
                         request_type,
                         decode(action_code, '000', 'A', 'D') AS status,
                         SUBSTR(transaction_id, -3, 3) AS recyl_num
                    FROM teihost.transaction
                    WHERE mid IN ($midlist)
                    AND authdatetime >= $authbegindatetime
                    AND authdatetime < $authenddatetime
                    AND transaction_id LIKE 'B00000%'
                    AND transaction_id LIKE '%00_'
                    AND transaction_id LIKE '%002'
                    AND mid IN
                         (SELECT
                             (SELECT mid
                             FROM teihost.terminal
                             WHERE tid = f.mid)
                         FROM teihost.batch_watch f
                         WHERE retry_times > '1')
                    GROUP BY
                         mid,
                         card_type,
                         request_type,
                         decode(action_code, '000', 'A', 'D'),
                         SUBSTR(transaction_id, -3, 3)
                    ORDER BY mid"
        }

        "AVS" {
            # see https://sysnet.jetpay.com/wiki/AVS_Rejection
            set nm "select
                         mid,
                         count(amount) as cnt,
                         sum(amount) as amt,
                         card_type,
                         request_type,
                         decode (action_code, '000', 'A', 'D') as status
                    from teihost.transaction
                    where
                         mid in ($midlist)
                         and authdatetime >= $authbegindatetime
                         and authdatetime < $authenddatetime
                         and request_type in (
                             '0100', '0102', '0190', '0200', '0220', '0240',
                             '0250', '0252', '0260', '0352', '0354', '0356',
                             '0358', '0400', '0402', '0420', '0440', '0450',
                             '0460', '0480', '0500', '0530')
                         and action_code in ('930', '931', '932', '981')
                    group by
                         mid,
                         card_type,
                         request_type,
                         decode (action_code, '000', 'A', 'D')
                    order by mid"
        }

        "AVSAUTH" {
            # see https://sysnet.jetpay.com/wiki/AVS_Rejection
            # transaction.transaction_type shows whether a transaction is recurring
            # recurring is excluded from this fee
            # recurring types are U-Recurring, N-Installment, Y-Bill Payment
            #
            set nm "select
                    t.mid,
                    count(t.amount) as cnt,
                    sum(t.amount) as amt,
                    t.card_type,
                    t.request_type,
                    decode (t.action_code, '000', 'A', 'D') as status
                from teihost.transaction t
                where   t.mid in ($midlist)
                    and t.authdatetime >= $authbegindatetime
                    and t.authdatetime <  $authenddatetime
                    and t.avs_response not in (' ', 'U')
                    and t.transaction_type not in ('U', 'N', 'Y')
                group by
                    t.mid, t.card_type, t.request_type,
                    decode(t.action_code, '000', 'A', 'D')
                order by mid"
        }

        "PROGRAM_BLOCK" {
            set nm "select
                        mid,
                        count(amount) as cnt,
                        sum(amount) as amt,
                        card_type,
                        request_type,
                        decode (action_code, '000', 'A', 'D') as status
                    from teihost.transaction
                    where
                        mid in ($midlist)
                    and authdatetime >= $authbegindatetime
                    and authdatetime < $authenddatetime
                    and request_type in (
                        '0100', '0102', '0190', '0200', '0220', '0240',
                        '0250', '0252', '0260', '0352', '0354', '0356',
                        '0358', '0400', '0402', '0420', '0440', '0450',
                        '0460', '0480', '0500', '0530')
                        and action_code in ('934')
                    group by
                        mid,
                        card_type,
                        request_type,
                        decode (action_code, '000', 'A', 'D')
                    order by mid"
        }

        "ACH" {
            set nm "select  /*+INDEX(t TRANSACTION_AUTHDATETIME)*/
                        mid,
                        count(amount) as cnt,
                        sum(amount) as amt,
                        card_type,
                        request_type,
                        decode (action_code, '000', 'A', 'D')  as status
                    from teihost.transaction
                    where
                        mid in ($midlist)
                        and authdatetime >= $authbegindatetime
                        and authdatetime < $authenddatetime
                        and request_type in ('0660', '0662', '0668', '0679', '0680')
                    group by
                        mid,
                        card_type,
                        request_type,
                        decode (action_code, '000', 'A', 'D')
                    order by
                        mid,
                        card_type,
                        request_type,
                        decode (action_code, '000', 'A', 'D')"
        }

        "BTCH" {
            set nm "SELECT
                        mid,
                        COUNT(UNIQUE SUBSTR(authdatetime, 1, 8)) AS cnt,
                        SUM(amount) AS amt,
                        '00' AS card_type,
                        '0200' AS request_type,
                        'A' AS status
                    FROM teihost.transaction WHERE
                        mid IN($midlist)
                    and authdatetime >= $authbegindatetime
                    and authdatetime < $authenddatetime
                    AND request_type IN('0100', '0200', '0220', '0250', '0400', '0420')
                    GROUP BY mid
                    ORDER BY mid"
        }

        "CVV2" {
            set nm "select  /*+INDEX(t TRANSACTION_AUTHDATETIME)*/
                        mid,
                        count(amount) as cnt,
                        sum(amount) as amt,
                        card_type,
                        request_type,
                        decode (action_code, '000', 'A', 'D') as status
                    from teihost.transaction
                    where
                        mid in ($midlist)
                    and authdatetime >= $authbegindatetime
                    and authdatetime < $authenddatetime
                    and request_type in (
                        '0100', '0102', '0190', '0200', '0220', '0240',
                        '0250', '0252', '0260', '0352', '0354', '0356',
                        '0358', '0400', '0402', '0420', '0440', '0450',
                        '0460', '0480', '0500', '0530')
                        and action_code in ('933')
                    group by
                        mid,
                        card_type,
                        request_type,
                        decode (action_code, '000', 'A', 'D')
                    order by mid"
        }

        "CVVAUTH" {
            set nm "select  /*+INDEX(t TRANSACTION_AUTHDATETIME)*/
                        mid,
                        count(amount) as cnt,
                        sum(amount) as amt,
                        card_type,
                        request_type,
                        decode (action_code, '000', 'A', 'D') as status
                    from teihost.transaction
                    where
                        mid in ($midlist)
                    and authdatetime >= $authbegindatetime
                    and authdatetime < $authenddatetime
                    and cvv is not null
                    and cvv != ' '
                    and (card_present is null or card_present != '1')
                    and request_type between '0100' and '0499'
                    and request_type not in ('0250', '0262')
                    group by
                        mid,
                        card_type,
                        request_type,
                        decode (action_code, '000', 'A', 'D')
                    order by mid"
        }

        "BIN" {
            set nm "select
                        mid,
                        count(amount) as cnt,
                        sum(amount) as amt,
                        card_type,
                        request_type,
                        decode (action_code, '000', 'A', 'D') as status
                    from teihost.transaction
                    where
                        mid in ($midlist)
                    and authdatetime >= $authbegindatetime
                    and authdatetime < $authenddatetime
                    and request_type in (
                        '0100', '0102', '0190', '0200', '0220', '0240',
                        '0250', '0252', '0260', '0352', '0354', '0356',
                        '0358', '0400', '0402', '0420', '0440', '0450',
                        '0460', '0480', '0500', '0530')
                    and action_code in ('099')
                    group by
                        mid,
                        card_type,
                        request_type,
                        decode (action_code, '000', 'A', 'D')
                    order by mid"
        }

        "VLCK"          {set nm "Select 'VLCK NOT SUPPORTED YET' from DUAL"}
        "FRD"           {set nm "Select 'FRD NOT SUPPORTED YET' from DUAL"}
        "SEC"           {set nm "Select 'SEC NOT SUPPORTED YET' from DUAL"}
        "VBV"           {set nm "Select 'VBV NOT SUPPORTED YET' from DUAL"}

        "DB_FIX" {
            set nm "select entity_id as mid, count(*) as cnt, sum(amt_billing) as amt,
                        'DB' as card_type,
                        decode (tid, '010003005101', '0200', '0420') as request_type,
                        'A' as status
                    from mas_trans_log
                    where to_char(gl_date, 'MON-YYYY') = $run_month_year
                    and card_scheme = '02'
                    and institution_id = '$inst_id'
                    and tid in ('010003005101', '010003005102')
                    and (institution_id, file_id) in (
                        select institution_id, file_id
                        from mas_file_log
                        where to_char(receive_date_time, 'MON-YYYY') = $run_month_year
                        and institution_id = '$inst_id')
                    group by entity_id, 'DB', decode (tid, '010003005101', '0200', '0420'), 'A'
                    order by entity_id"
        }

        "ASSOC" {
            set nm "select entity_id as mid, count(*) as cnt, sum(amt_billing) as amt,
                        decode(card_scheme, '03', 'AX',
                                            '04', 'VS',
                                            '05', 'MC',
                                            '08', 'DS',
                                            '07', 'DC',
                                            '09', 'JC',
                                            '02', 'DB',
                                            'XX')       as card_type,
                        decode (tid, '010003005101', '0200', '0420') as request_type,
                        'A' as status
                    from mas_trans_log
                    where to_char(gl_date, 'MON-YYYY') = $run_month_year
                    and card_scheme in ('04', '05', '08')
                    and institution_id = '$inst_id'
                    and tid in ('010003005101', '010003005102')
                    and (institution_id, file_id) in (
                        select institution_id, file_id
                        from mas_file_log
                        where to_char(receive_date_time, 'MON-YYYY') = $run_month_year
                        and institution_id = '$inst_id'
                    )
                    group by entity_id,
                        decode(card_scheme, '03', 'AX',
                                            '04', 'VS',
                                            '05', 'MC',
                                            '08', 'DS',
                                            '07', 'DC',
                                            '09', 'JC',
                                            '02', 'DB',
                                            'XX'),
                        decode (tid, '010003005101', '0200', '0420'), 'A'
                    order by entity_id"
        }

        "ASSESS" {
            set nm "select entity_id as mid, count(*) as cnt, sum(amt_billing) as amt,
                        decode(card_scheme, '03', 'AX',
                                            '04', 'VS',
                                            '05', 'MC',
                                            '08', 'DS',
                                            '07', 'DC',
                                            '09', 'JC',
                                            '02', 'DB',
                                            'XX')       as card_type,
                        decode (tid, '010003005101', '0200', '0420') as request_type,
                        'A' as status
                    from mas_trans_log
                    where to_char(gl_date, 'MON-YYYY') = $run_month_year
                    and card_scheme in ('04', '05', '08')
                    and institution_id = '$inst_id'
                    and tid in ('010003005101', '010003005102')
                    and (institution_id, file_id) in (
                        select institution_id, file_id
                        from mas_file_log
                        where to_char(receive_date_time, 'MON-YYYY') = $run_month_year
                        and institution_id = '$inst_id'
                    )
                    group by entity_id,
                        decode(card_scheme, '03', 'AX',
                                            '04', 'VS',
                                            '05', 'MC',
                                            '08', 'DS',
                                            '07', 'DC',
                                            '09', 'JC',
                                            '02', 'DB',
                                            'XX'),
                        decode (tid, '010003005101', '0200', '0420'), 'A'
                    order by entity_id"
        }

        "CNP" {
            set nm "
                    select
                        t.mid                                               mid,
                        count( 1 )                                          cnt,
                        sum(amount)                                         amt,
                        t.card_type                                         card_type,
                        t.request_type                                      request_type,
                        case when  regexp_instr(t.other_data2, 'CP\:1') > 0
                                or t.card_present = '1'
                             then 'C' else 'N' end                          status
                    from teihost.tranhistory t
                    where
                        t.mid in ($midlist)
                    and t.settle_date >= $authbegindatetime
                    AND t.settle_date <  $authenddatetime
                    and t.card_type = 'MC'
                    group by t.mid, t.card_type, t.request_type,
                        case when regexp_instr(t.other_data2, 'CP\:1') > 0
                                or t.card_present = '1'
                             then 'C' else 'N' end"
        }
        "FORCE" {
            set nm "
                    select
                         mid                                                ,
                         count(amount)                                as cnt,
                         sum(amount)                                  as amt,
                         'VS_FORCE'                              as mas_code,
                         card_type                                          ,
                         t.request_type                                     ,
                         decode (t.action_code, '000', 'A', 'D')    as status
                    from teihost.transaction t
                    where
                         mid in ($midlist)
                         and authdatetime >= $authbegindatetime
                         and authdatetime < $authenddatetime
                         and request_type in ('220','240')
                         and card_type = 'VS'
                    group by
                         mid,
                         card_type,
                         t.request_type,
                         decode (t.action_code, '000', 'A', 'D')
                    order by mid"
        }
        "ZEROVERI" {
            set nm "
                    select
                         mid                                                ,
                         count(amount)                                as cnt,
                         sum(amount)                                  as amt,
                         card_type                                          ,
                         t.request_type                                     ,
                         decode (t.action_code, '000', 'A', 'D')    as status
                    from teihost.transaction t
                    where
                         mid in ($midlist)
                         and authdatetime >= $authbegindatetime
                         and authdatetime < $authenddatetime
                         and amount = 0
                         and card_type != ' '
                         and card_type in ('VS','MC')
                         and request_type != '0110'
                    group by
                         mid,
                         card_type,
                         t.request_type,
                         decode (t.action_code, '000', 'A', 'D')
                    order by mid"
        }
        "DBMONTHLY" {
            set nm "
                    select distinct
                         VISA_ID                                as mid,
                         1                                      as cnt,
                         0                                      as amt,
                         'DB'                             as card_type,
                         '0100'                        as request_type,
                         'DBT_ASSMT_MONTHLY'               as mas_code,
                         status
                    from teihost.merchant 
                    where
                         mid in ($midlist)
                         and debit_id is not null 
                         and debit_id != ' '
                         and VISA_ID is not null 
                         and visa_id != ' '
                         and status = 'A'
                    order by VISA_ID"
        }
        default {
            usage $f_type
            exit 1
        }

    }
    # puts $nm
    # MASCLR::log_message "get_sql nm: \n\n$nm ;\n" 4
    return $nm
}

proc get_mff {f_type} {
    switch $f_type {
        "AUTH"          {set nm "Y"}
        "AUTH2"         {set nm "Y"}
        "AUTHDB"        {set nm "Y"}
        "WOOT"          {set nm "Y"}
        "WOOT2"         {set nm "Y"}
        "AU"            {set nm "Y"}
        "RCYL"          {set nm "Y"}
        "AVS"           {set nm "Y"}
        "ACH"           {set nm "Y"}
        "BTCH"          {set nm "Y"}
        "CVV2"          {set nm "Y"}
        "CVVAUTH"       {set nm "Y"}
        "BIN"           {set nm "Y"}
        "VLCK"          {set nm "Y"}
        "FRD"           {set nm "Y"}
        "SEC"           {set nm "Y"}
        "VBV"           {set nm "Y"}
        "PROGRAM_BLOCK" {set nm "Y"}
        "DB_FIX"        {set nm "Y"}
        "ASSOC"         {set nm "Y"}
        "ASSESS"        {set nm "Y"}
        "DISC_DATA"     {set nm "Y"}
        "AVSAUTH"       {set nm "Y"}
        "CNP"           {set nm "Y"}
        "FORCE"         {set nm "Y"}
        "ZEROVERI"      {set nm "Y"}
        "DBMONTHLY"     {set nm "Y"}
        default {
            usage $f_type
            exit 1
        }

    }
    return $nm
}

proc get_flag_val {f_type} {
    switch $f_type {
        "AUTH"          {set nm "AUTHCOUNT"}
        "AUTH2"         {set nm "AUTH2CNT2"}
        "AUTHDB"        {set nm "AUTHDBCNT"}
        "WOOT"          {set nm "AUTHCOUNT"}
        "WOOT2"         {set nm "AUTHCOUNT"}
        "AU"            {set nm "AU"}
        "RCYL"          {set nm "TRANSACTION_RECYCLING"}
        "AVS"           {set nm "AVS_REJECT"}
        "CVV2"          {set nm "CVV2"}
        "CVVAUTH"       {set nm "CVV_AUTH"}
        "BIN"           {set nm "BIN_BLOCK"}
        "ACH"           {set nm "ACH_PROC"}
        "BTCH"          {set nm "BATCH_HEADER"}
        "VLCK"          {set nm "VELOCITY_CHECK"}
        "FRD"           {set nm "FRAUD_CHECK"}
        "SEC"           {set nm "SECURE_CODE"}
        "VBV"           {set nm "VBV"}
        "DISC_DATA"     {set nm "DISC_DATA"}
        "PROGRAM_BLOCK" {set nm "PROGRAM_BLOCK"}
        "DB_FIX"        {set nm "DEBITFIX"}
        "ASSOC"         {set nm "ASSOC_CD"}
        "ASSESS"        {set nm "ASSESSMNT"}
        "AVSAUTH"       {set nm "AVS_AUTH"}
        "CNP"           {set nm "CNP"}
        "FORCE"         {set nm "FORCE"}
        "ZEROVERI"      {set nm "ZERO_VERI"}
        "DBMONTHLY"     {set nm "DB_MONTHLY"}
        default {
            usage $f_type
            exit 1
        }

    }

    return $nm

}

proc get_fname {f_type} {

    switch $f_type {
        "AUTH"          {set nm "COUNTING"}
        "AUTH2"         {set nm "COUNT002"}
        "AUTHDB"        {set nm "COUNTDBT"}
        "WOOT"          {set nm "WOOTSETT"}
        "WOOT2"         {set nm "WOOTRULE"}
        "AU"            {set nm "ACCTUPDT"}
        "RCYL"          {set nm "RECYLING"}
        "AVS"           {set nm "AVSCOUNT"}
        "CVV2"          {set nm "CVVCOUNT"}
        "CVVAUTH"       {set nm "CVVCHECK"}
        "BIN"           {set nm "BINBLOCK"}
        "ACH"           {set nm "ACHCOUNT"}
        "BTCH"          {set nm "BTCHHEDR"}
        "VLCK"          {set nm "VELCHECK"}
        "FRD"           {set nm "FRDCHECK"}
        "SEC"           {set nm "SECRCODE"}
        "VBV"           {set nm "VBVCHECK"}
        "DISC_DATA"     {set nm "DISCDATA"}
        "PROGRAM_BLOCK" {set nm "PRGBLOCK"}
        "DB_FIX"        {set nm "DEBITFIX"}
        "ASSOC"         {set nm "ASSOC_CD"}
        "ASSESS"        {set nm "ASSESSMT"}
        "AVSAUTH"       {set nm "AVSCHECK"}
        "CNP"           {set nm "CPCNPCNT"}
        "FORCE"         {set nm "ZERFORCE"}
        "ZEROVERI"      {set nm "ZEROVERI"}
        "DBMONTHLY"     {set nm "DBMONTHL"}
        default {
            usage $f_type
            exit 1
        }

    }

    return $nm

}

proc get_tid {f_type tid_idntfr} {

    switch $f_type {
        "AUTH"          {set nm "010070010000"}
        "AUTH2"         {set nm "010070010017"}
        "AUTHDB"        {set nm "010070010009"}
        "WOOT"          {set nm "010070010016"}
        "WOOT2"         {set nm "010070010018"}
        "AU"            {set nm "010070010008"}
        "RCYL"          {set nm "010070010001"}
        "AVS"           {set nm "010070010003"}
        "CVV2"          {set nm "010070010004"}
        "CVVAUTH"       {set nm "010070010006"}
        "BIN"           {set nm "010070010002"}
        "ACH"           {
            uplevel "set mas_tid(0660) \"010070010010\""
            uplevel "set mas_tid(0662) \"010070010010\""
            uplevel "set mas_tid(0668) \"010070010010\""
            uplevel "set mas_tid(0679) \"010070010011\""
            uplevel "set mas_tid(0680) \"010070010011\""
            set nm 0
        }
        "BTCH"          {set nm "010070010005"}
        "VLCK"          {set nm "VELCHECK"; puts "TODO, TID FOR VELOCITY CHECK";  exit 1 }
        "FRD"           {set nm "FRDCHECK"; puts "TODO, TID FOR FRAUD CHECK";     exit 1 }
        "SEC"           {set nm "SECRCODE"; puts "TODO, TID FOR SECURE CODE CHK"; exit 1 }
        "VBV"           {set nm "VBVCHECK"; puts "TODO, TID FOR VBV CHECK";       exit 1 }
        "PROGRAM_BLOCK" {set nm "010070010019"}
        "DISC_DATA"     {set nm "010070010017"}
        "DB_FIX"        {set nm "010070010022"}
        "ASSOC"         {set nm "010070010023"}
        "ASSESS"        {set nm "010070010024"}
        "AVSAUTH"       {set nm "010070010025"}
        "CNP"           {set nm "010070020001"}
        "FORCE"         {set nm "010070020001"}
        "ZEROVERI"      {set nm "010070020001"}
        "DBMONTHLY"     {set nm "010070020001"}        
        default {
            usage $f_type
            exit 1
        }

    }

    return $nm

}

proc set_args {} {

    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year argc argv box clrpath maspath
    global mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u
    global mbody_h mbody_m mbody_l sysinfo cfg_pth log_pth arch_pth hold_pth upld_pth stop_pth tmp_pth
    global currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime
    global endtime cutoff tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt
    global tblnm_mf tblnm_e2a tblnm_tr MODE data_jdate

    set inst_id ""
    set cnt_type ""
    set run_mnth ""
    set run_year ""
    set cutoff ""

    if {$argc >= 2} {
        set i 0
        while {$i < $argc} {
            set pind [string range [string trim [lindex $argv $i]] 1 1]
            set pval [string range [lindex $argv $i] 2 end]
            switch $pind {
                "i" {set inst_id $pval}
                "e" {set mailtolist $pval}
                "c" {set cnt_type $pval}
                "m" {set run_mnth $pval}
                "y" {set run_year $pval}
                "t" {set cutoff $pval}
                "v" {set debug true
                     incr MASCLR::DEBUG_LEVEL}
                "T" {set MODE "TEST"}
                default {
                    puts stdout "$pind is an invalid parameter indicator $i\n"
                    usage
                    exit 1
                    }
            }
            set i [expr $i + 1]
        }
        if {$inst_id == "" || $cnt_type == ""} {
            puts stdout "inst_id = $inst_id, cnt_type = $cnt_type\n\n"
            usage
            exit 1
        }
        if {$run_mnth == "" || $run_mnth <= 0} {
            set run_mnth $cmonth
        }
        if {$run_year == "" || $run_year <= 0} {
            set run_year $cyear
        }
        if {$cutoff == "" || $cutoff <= 0} {
            set cutoff "000000"
        }
        puts stdout "Run Arguments:
        -i = >$inst_id<
        -c = >$cnt_type<
        -m = >$run_mnth<
        -y = >$run_year<
        -t = >$cutoff<
        "

    } elseif {$argc < 2} {
        puts stdout "less than 2 arguments ($argc)\n\n"
        usage
        exit 1
    }

    MASCLR::log_message "MODE: $MODE, DEBUG_LEVEL $MASCLR::DEBUG_LEVEL"

    set cfg_pth "./CFG"
    set log_pth "./LOGS"
    set arch_pth "./INST_$inst_id/ARCHIVE"
    set hold_pth "./INST_$inst_id/HOLD_FILES"
    set upld_pth "./INST_$inst_id/UPLOAD"
    set stop_pth "./INST_$inst_id/STOP"
    set tmp_pth "./INST_$inst_id/TEMP"

}

proc set_dir_paths {inst_id pth_varname gbl_pth_ext} {
    switch $pth_varname {
        "cfg_pth"   {set pth "$gbl_pth_ext/CFG"}
        "log_pth"   {set pth "$gbl_pth_ext/LOGS"}
        "arch_pth"  {set pth "$gbl_pth_ext/ARCHIVE"}
        "hold_pth"  {set pth "$gbl_pth_ext/HOLD_FILES"}
        "upld_pth"  {set pth "$gbl_pth_ext/UPLOAD"}
        "stop_pth"  {set pth "$gbl_pth_ext/STOP"}
        "tmp_pth"   {set pth "$gbl_pth_ext/TEMP"}
        defualt {}
    }
    return $pth
}

puts "========================================================================================"

MASCLR::log_message "Command line was: $cmd_line"
MASCLR::log_message "Filename and svn revision from svn: $fil_nam, $rev_nbr"

# Set Dates for the run
proc get_run_mnth {rmnth} {
    global rightnow cmonth cdate cyear jdate

    if {[string is digit $rmnth]} {
        switch $rmnth {
            "01" {set rmnth "01"}
            "02" {set rmnth "02"}
            "03" {set rmnth "03"}
            "04" {set rmnth "04"}
            "05" {set rmnth "05"}
            "06" {set rmnth "06"}
            "07" {set rmnth "07"}
            "08" {set rmnth "08"}
            "09" {set rmnth "09"}
            "10" {set rmnth "10"}
            "11" {set rmnth "11"}
            "12" {set rmnth "12"}
            "1"  {set rmnth "01"}
            "2"  {set rmnth "02"}
            "3"  {set rmnth "03"}
            "4"  {set rmnth "04"}
            "5"  {set rmnth "05"}
            "6"  {set rmnth "06"}
            "7"  {set rmnth "07"}
            "8"  {set rmnth "08"}
            "9"  {set rmnth "09"}
            default {set rmnth "00"}
        }
    } else {
        set rmnth [string range $rmnth 0 2]
        switch $rmnth {
            "JAN" {set rmnth "01"}
            "FEB" {set rmnth "02"}
            "MAR" {set rmnth "03"}
            "APR" {set rmnth "04"}
            "MAY" {set rmnth "05"}
            "JUN" {set rmnth "06"}
            "JUL" {set rmnth "07"}
            "AUG" {set rmnth "08"}
            "SEP" {set rmnth "09"}
            "OCT" {set rmnth "10"}
            "NOV" {set rmnth "11"}
            "DEC" {set rmnth "12"}
            default {set rmnth "00"}
        }
    }

    if {$rmnth > "12" || $rmnth < "01"} {
        puts "Invalid Month provided $rmnth. It should be either 1 - 12 OR JAN - DEC"
        usage
        exit 1
    } else {
        #set dfmnth [expr $cmonth - $rmnth]
        set dfmnth $rmnth
    }

    return $dfmnth
}

proc get_run_year {ryear} {
    global rightnow cmonth cdate cyear jdate
    if {$ryear <= $cyear} {
        #set yr [expr $cyear - $ryear]
        set yr $ryear
    } else {
        puts "Cannot run code for future Month or Year."
        exit 1
    }
    return $yr
}

# setting run dates
proc set_run_dates {} {

    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year argc argv get_run_year box clrpath
    global maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c
    global mbody_u mbody_h mbody_m mbody_l sysinfo cfg_pth log_pth arch_pth hold_pth upld_pth stop_pth
    global tmp_pth currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime
    global begintime endtime cutoff batchtime tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw
    global tblnm_bf tblnm_bt tblnm_mf tblnm_e2a tblnm_tr run_month_year data_jdate
    global authbegindatetime cday
    global authenddatetime

    # if {$argc == 5} {
    #     set yeartomnth [expr [get_run_year $run_year] * 12]
    #     # set mnth [expr [get_run_mnth $run_mnth] + $yeartomnth]
    #     set mnth [get_run_mnth $run_mnth]
    # } elseif {$argc == 4} {
    #     set yeartomnth [expr [get_run_year $run_year] * 12]
    #     # set mnth [expr [get_run_mnth $run_mnth] + $yeartomnth]
    #     set mnth [get_run_mnth $run_mnth]
    # } elseif {$argc == 3} {
    #     set mnth [get_run_mnth $run_mnth]
    # } elseif {$argc == 2} {
    #     set mnth $cmonth
    # } else {
    #     set mnth $cmonth
    # }
    set mnth [get_run_mnth $run_mnth]
    set last_day [lastDay $run_mnth $run_year]

    set data_jdate ""
    if {$run_year != $cyear || $run_mnth != $cmonth } {
        append  data_jdate $run_year $run_mnth $last_day
        set     data_jdate [clock scan $data_jdate -base [clock seconds] ]
        set     data_jdate [clock format $data_jdate -format "%y%j"]
        set     data_jdate [string range $data_jdate 1 end]
        append  data_jdate "."
    }
    if { [string length $run_mnth] != 0 && [string length $run_year] != 0 } {
        set cday [format "01-%02d-%d" $run_mnth $run_year]
    } elseif { [string length $run_mnth] != 0 } {
        set cday [format "01-%02d-%d" $run_mnth $cyear]
    } else {
        set cday [format "01-%02d-%d" $cmonth $cyear]    
    }
    #set begindatetime "to_char(last_day(add_months(SYSDATE, -[expr 1 + $mnth])), 'YYYYMMDD') || '$cutoff'"
    set run_month_year "to_char(to_date('$run_year$mnth$last_day', 'YYYYMMDD'), 'MON-YYYY')"
    #set enddatetime "to_char(last_day(add_months(SYSDATE, -[expr 0 + $mnth])), 'YYYYMMDD') || '$cutoff'"
    #set enddatetime "to_char(SYSDATE, 'YYYYMMDD') || '$cutoff'"
    set begindatetime "'$run_year$mnth' '01' || '$cutoff'"
    set begindatetime ""
    append begindatetime "'" $run_year $mnth 01 $cutoff "'"
    set enddatetime ""
    append enddatetime   "'" $run_year $mnth $last_day $cutoff "'"
    # The 'auth' date times are for running against the authorization database
    # Due to the timing of the run of this script (on the last day of the month)
    # the previous version of this script was running with a date range of
    # (for instance) >= July 1st, 2014 00:00:00 (2014070100000) to
    # less than < July 31st, 2014 00:00:00 (20140731000000)
    # The new version will use a date range of:
    # >= June 30th, 2014 (20140630000000) to < July 31st, 2014 (20140731000000)
    # Basically, last date of the previous month plus current month minus last day
    set authbegindatetime "'[clock format [clock scan "$mnth/1/$run_year - 1 day"] -format %Y%m%d]000000'"
    set authenddatetime   "'[clock format [clock scan "$mnth/1/$run_year + 1 month - 1 day"] -format %Y%m%d]000000'"
    MASCLR::log_message "Authorization date range: >= $authbegindatetime and < $authenddatetime" 1
    append batchtime $sdate $cutoff
    MASCLR::log_message "Transaction count between $begindatetime :: $enddatetime :: $batchtime"
}

#Proc for array---------------------------------------------------------

proc load_array {aname str lst} {
    upvar $aname a

    for {set i 0} {$i < [llength $str]} { incr i} {
        set a([string touppe [lindex $lst $i]]) [lindex $str $i]
    }
};# end load_array

proc connect_to_dbs {} {

    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year db_logon_handle db_login_handle
    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo cfg_pth log_pth arch_pth hold_pth
    global upld_pth stop_pth tmp_pth currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime
    global enddatetime begintime endtime cutoff batchtime tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg
    global tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a  tblnm_tr env data_jdate

    #Opening connection to db--------------------------------------------------
    # this will normally use $env(TSP4_DB) but I am using transp1 directly for speed
    # concerns on Jan 31 2010
    if {[catch {set db_logon_handle [oralogon teihost/quikdraw@$authdb]} result]} {
        puts "$authdb efund boarding failed to run"
        set mbody "$authdb efund boarding failed to run"
        #   exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u"
        # $mailtolist
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        exit 1
    }

    if {[catch {set db_login_handle [oralogon masclr/masclr@$clrdb]} result]} {
        puts "$clrdb efund boarding failed to run"
        set mbody "$clrdb efund boarding failed to run"
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        exit 1
    }

}

proc open_cursor_masclr {cursr} {
    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year db_logon_handle db_login_handle
    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo cfg_pth log_pth arch_pth hold_pth
    global upld_pth stop_pth tmp_pth currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime
    global enddatetime begintime endtime cutoff batchtime tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg
    global tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a tblnm_tr data_jdate

    global $cursr
    set $cursr [oraopen $db_login_handle]
}

proc open_cursor_teihost {cursr} {
    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year db_logon_handle db_login_handle
    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo cfg_pth log_pth arch_pth hold_pth
    global upld_pth stop_pth tmp_pth currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime
    global enddatetime begintime endtime cutoff batchtime tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg
    global tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a  tblnm_tr

    global $cursr
    set $cursr [oraopen $db_logon_handle]

}

proc get_outfile {f_seq} {
    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year box clrpath maspath mailtolist
    global mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h
    global mbody_m mbody_l sysinfo cfg_pth log_pth arch_pth hold_pth upld_pth stop_pth tmp_pth env
    global currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime
    global endtime cutoff batchtime tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf
    global tblnm_bt tblnm_mf tblnm_e2a tblnm_tr data_jdate

    #Temp variable for output file name
    set fname [get_fname $cnt_type]
    if {$f_seq == ""} {
        set f_seq 1
    }
    set fileno $f_seq
    set fileno [format %03s $f_seq]
    set one "01"
    set pth ""
    set hk 1

    #Creating output file name----------------------
    append outfile $pth $inst_id $dot $fname $dot $one $dot $jdate $dot $data_jdate $fileno

    while {$hk == 1} {
        if {[set ex [file exists $env(PWD)/$outfile]] == 1 || [set ux [file exists $env(PWD)/ON_HOLD_FILES/$outfile]] == 1} {
            set fname [get_fname $cnt_type]
            set f_seq [expr $f_seq + 1]
            set fileno $f_seq
            set fileno [format %03s $f_seq]
            set one "01"
            set pth ""
            set outfile ""
            append outfile $pth $inst_id $dot $fname $dot $one $dot $jdate $dot $data_jdate $fileno
            set hk 1
        } else {
            set hk 0
        }

    }
    return $outfile
}

proc pbchnum {} {
    global env inst_id
    # get and bump the file number
    set batch_num_file [open "$env(PWD)/mas_batch_num.txt" "r+"]
    gets $batch_num_file bchnum
    seek $batch_num_file 0 start
    if {$bchnum >= 999999999} {
        puts $batch_num_file 1
    } else {
        puts $batch_num_file [expr $bchnum + 1]
    }
    close $batch_num_file
    return $bchnum
}

###### Loading Visa/MC id as entity_id into an array with index of MID from the
# Database

proc get_curr_cd {f_type midlist} {

    #--GLOBAL LIST
    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year auth_get clr_get clr_get1 clr_get2
    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo cfg_pth log_pth arch_pth hold_pth
    global upld_pth stop_pth tmp_pth currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime
    global enddatetime begintime endtime cutoff batchtime tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg
    global tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a tblnm_tr

    ###### Loading Visa/MC id as entity_id into an array with index of MID from the
    # Database
    if { $f_type == "DISC_DATA" } {
        set get_ent "select entity_id
                    from masclr.entity_to_auth
                    where entity_id in ($midlist)
                    and status in ('A', 'H')
                    and institution_id = '$inst_id'"
        MASCLR::log_message "get_ent: $get_ent" 3
        orasql $clr_get2 $get_ent

        while {[set x [orafetch $clr_get2 -dataarray ent -indexbyname]] == 0} {
            set amid $ent(ENTITY_ID)
            set entt_id $ent(ENTITY_ID)
            uplevel "set entity_id($amid) $entt_id"
        }

    } else {
        set get_ent "select mid, entity_id
                    from masclr.entity_to_auth
                    where mid in ($midlist) and status in ('A', 'H') and institution_id = '$inst_id'"
        MASCLR::log_message "get_ent: $get_ent" 3
        orasql $clr_get2 $get_ent

        while {[set x [orafetch $clr_get2 -dataarray ent -indexbyname]] == 0} {
            set amid $ent(MID)
            set entt_id $ent(ENTITY_ID)
            uplevel "set entity_id($amid) $entt_id"

        }
        set get_ent "select mid, currency_code from teihost.merchant where mid in ($midlist)"
        orasql $auth_get $get_ent
        MASCLR::log_message "get_ent: $get_ent" 3
        while {[set x [orafetch $auth_get -dataarray curr -indexbyname]] == 0} {
            set amid $curr(MID)
            set cur_cd $curr(CURRENCY_CODE)
            uplevel "set curr_cd($amid) $curr(CURRENCY_CODE)"

        }
    }

}

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#--GLOBAL LIST
#global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year
#global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u
# msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
#global cfg_pth log_pth arch_pth hold_pth upld_pth stop_pth tmp_pth
#global currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime
# enddatetime begintime endtime cutoff batchtime
#global tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf
# tblnm_bt tblnm_mf tblnm_e2a tblnm_tr
#--PROC LIST
#proc get_fname {f_type}
#proc set_args {}
#proc get_cfg {inst_id cfg_pth}
#proc set_dir_paths {inst_id pth_varname gbl_pth_ext}
#proc get_run_mnth {rmnth}
#proc get_run_year {ryear}
#proc set_run_dates {}
#proc load_array {aname str lst}
#proc connect_to_dbs {}
#proc open_cursor_masclr {cursr}
#proc open_cursor_teihost {cursr}
#proc get_outfile {}
#proc pbchnum {}
#proc get_mff {f_type}
#proc get_fname {f_type tid_idntfr}
#proc get_curr_cd {f_type midlist}
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

#Initializing for count file run -------------------------------------------

set_args
connect_to_dbs
get_cfg $inst_id $cfg_pth
set_run_dates

set pth ""
set fn [get_fname $cnt_type]
set fchk $pth$inst_id$dot$fn$dot
catch {exec find $env(PWD)/ON_HOLD_FILES -name "$fchk*"} result

if {$result != ""} {
    foreach flcknm $result {
        catch {exec mv $flcknm $env(PWD)/TEMP/} err
    }
    puts "$result files are move to $env(PWD)/TEMP/"
}

#All the sql logon handles -------------------------------------------------

open_cursor_masclr m_code_sql
open_cursor_masclr clr_get
open_cursor_masclr clr_get1
open_cursor_masclr clr_get2
open_cursor_masclr clr_get3
open_cursor_teihost auth_get
open_cursor_teihost auth_get1

#Pulling Mas codes and building an array for later use.

set s "select mas_code, card_scheme, request_type, action
        from masclr.MAS_FILE_CODE_GRP
        order by CARD_SCHEME, REQUEST_TYPE, ACTION"
MASCLR::log_message "s: $s" 3

orasql $m_code_sql $s

while {[set y [orafetch $m_code_sql -datavariable mscd]] == 0} {
    set ms_cd [lindex $mscd 0]
    set ind_cs [lindex $mscd 1]
    set ind_rt [lindex $mscd 2]
    set ind_ac [lindex $mscd 3]
    set mas_cd($ind_cs-$ind_rt-$ind_ac) $ms_cd
}

############################################################################################################
### MAIN
# ##########################################################################################################
############################################################################################################

set midlist ""
set y 0

if {$cnt_type == "AUTH"  || $cnt_type == "WOOT"      || $cnt_type == "WOOT2" ||
    $cnt_type == "AUTH2" || $cnt_type == "DISC_DATA" || $cnt_type == "AUTHDB" ||
    $cnt_type == "FORCE" || $cnt_type == "ZEROVERI" || $cnt_type == "DBMONTHLY" ||
    $cnt_type == "AU"   } {

    ##### Getting mid list from entity_to_auth.

    set get_ent_mid "select mid
                    from masclr.entity_to_auth
                    where institution_id in ($arr_cfg(INST_ID))
                    and FILE_GROUP_ID in ($arr_cfg(SETTLE_SHORTNAME))
                    and STATUS in ( 'A', 'H' )
                    and mas_file_flag = '[get_mff $cnt_type]'"
    MASCLR::log_message "get_ent_mid: $get_ent_mid" 3
    orasql $clr_get1 $get_ent_mid

    set mid_count 0
    set mid_list_count 0
    set list_of_mid_lists [list midlist$mid_list_count]
    set list_name "midlist$mid_list_count"
    set $list_name ""

    if {$cnt_type == "WOOT" || $cnt_type == "WOOT2" } {
        set    $list_name "'HOMEWOOTCOM00001', 'KIDWOOT', 'SELLOUT.WOOT.001', "
        append $list_name "'SHIRTWOOTCOM', 'SPORTSWOOTCOM001', "
        append $list_name "'TECHWOOTCOM00001', 'WINEWOOTCOM', "
        append $list_name "'WINEWOOTCOM00001', 'WOOTCOM'"

    } else {
        while {[set x1 [orafetch $clr_get1 -dataarray e2a -indexbyname]] == 0} {
            if {$mid_count == 0} {
                puts "appending '$e2a(MID)' to $list_name"
                append $list_name "'$e2a(MID)'"
                set mid_count [expr $mid_count + 1]
            } else {
                puts "appending '$e2a(MID)' to $list_name"
                append $list_name ", '$e2a(MID)'"
                set mid_count [expr $mid_count + 1]
            }
            if {$mid_count > 999} {

                #puts "$list_name"
                set mid_list_count [expr $mid_list_count + 1]
                set list_name "midlist$mid_list_count"
                lappend list_of_mid_lists $list_name
                puts "Switching to list name $list_name after reaching mid count $mid_count"
                set mid_count 0
            }
        }
    }

} else {

    set get_ent_mid "select mid, flag_use
                    from masclr.merchant_flag
                    where institution_id in ($arr_cfg(INST_ID))
                    and FLAG_TYPE = '[get_flag_val $cnt_type]'
                    and STATUS in ( 'A', 'H' )
                    and FLAG_TYPE_VALUE = 'Y'
                    and mid in (select mid
                                from masclr.entity_to_auth
                                where institution_id in ($arr_cfg(INST_ID))
                                and STATUS in ( 'A', 'H' )
                                and FILE_GROUP_ID in ($arr_cfg(SETTLE_SHORTNAME)))"
    #puts $get_ent_mid
    MASCLR::log_message "get_ent_mid: $get_ent_mid" 3

    orasql $clr_get1 $get_ent_mid

    set mid_count 0
    set mid_list_count 0
    set list_of_mid_lists [list midlist$mid_list_count]
    set list_name "midlist$mid_list_count"
    set $list_name ""
    if {$cnt_type == "WOOT" || $cnt_type == "WOOT2" } {
        set $list_name [list "'KIDWOOT' " ", 'SELLOUT.WOOT.001'" ", 'SHIRTWOOTCOM'" ", 'WINEWOOTCOM'" ", 'WOOTCOM'"]
    } else {
        while {[set x1 [orafetch $clr_get1 -dataarray e2a -indexbyname]] == 0} {
            if {$e2a(FLAG_USE) == ""} {
                if {$mid_count == 0} {
                    append $list_name "'$e2a(MID)'"
                    set mid_count [expr $mid_count + 1]
                } else {
                    append $list_name ", '$e2a(MID)'"
                    set mid_count [expr $mid_count + 1]
                }
            }
            if {$mid_count > 999} {
                #puts "$list_name"
                set mid_list_count [expr $mid_list_count + 1]
                set list_name "midlist$mid_list_count"
                lappend list_of_mid_lists $list_name
                set mid_count 0
            }
        }
    }
    foreach midlist $list_of_mid_lists {
        if {[set $midlist] == ""} {
            set    msg_text "No merchants found with institution_id in ($arr_cfg(INST_ID)) "
            append msg_text "and FLAG_TYPE = '[get_flag_val $cnt_type]' "
            append msg_text "and STATUS in ( 'A', 'H' ) and FLAG_TYPE_VALUE = 'Y'"
            puts $msg_text
            set  msg_text ""
            #exit 0
        }
    }
    if {$cnt_type == "VAU" || $cnt_type == "MBU"} {
        set i2 0
        set tid_list [list]
        foreach midlist $list_of_mid_lists {
            if {[set $midlist] != ""} {
                set get_tids "select tid from teihost.terminal where mid in ([set $midlist])"
                #puts $get_tids
                MASCLR::log_message "get_tids: $get_tids" 3
                catch {orasql $auth_get1 $get_tids} result
                MASCLR::log_message "result: $result"
                while {[set q [orafetch $auth_get1 -dataarray tid1 -indexbyname]] == 0} {
                    lappend tid_list "$tid1(TID)"
                    set i2 [expr $i2 + 1]
                }
            }
        }
        set mid_count 0
        set mid_list_count 0
        set list_of_mid_lists [list midlist$mid_list_count]
        set list_name "midlist$mid_list_count"
        set $list_name ""
        foreach ltid $tid_list {
            if {$mid_count == 0} {
                append $list_name "'$ltid'"
                set mid_count [expr $mid_count + 1]
            } else {
                append $list_name ", '$ltid'"
                set mid_count [expr $mid_count + 1]
            }
            if {$mid_count > 999} {
                #puts "$list_name"
                set mid_list_count [expr $mid_list_count + 1]
                set list_name "midlist$mid_list_count"
                lappend list_of_mid_lists $list_name
                set mid_count 0
            }
        }
    }

}

set fileseq 1
foreach midlist $list_of_mid_lists {
        if {[set $midlist] == ""} {
                set    msg_text "No merchants found with institution_id in ($arr_cfg(INST_ID)) "
                append msg_text "and FLAG_TYPE = '[get_flag_val $cnt_type]' "
                append msg_text "and STATUS in ( 'A', 'H' ) and FLAG_TYPE_VALUE = 'Y'"
                puts $msg_text
                set    msg_text ""
                exit 0
        } else {
                #puts "$midlist: [set $midlist]"
                #exit 0
        }

        if {($cnt_type == "DISC_DATA" || $cnt_type == "AU" ) && $fileseq > 1} {
                exit 0
        }

    #Opening Output file to write to

    set outfile [get_outfile $fileseq]
    puts "using $outfile for midlist $midlist"

    set fileseq [expr $fileseq + 1]

    if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
        puts stderr "Cannot open /duplog : $fileid"
        exit 1
    }

    ###### Writing File Header into the Mas file
    global inst_curr_cd
    set rec(file_date_time) $rightnow
    set rec(activity_source) "JETPAYLLC"
    set rec(activity_job_name) "AUTHCNT"
    set inst_curr_cd ""
    write_fh_record $fileid rec

    #Checking if merchant processes vs mc
    #foreach midlist $list_of_mid_lists {
    get_curr_cd $cnt_type [set $midlist]
    #}
    get_inst
    #puts "$midlist: [set $midlist]"
    ###### Sql Select to get all merchants daily transations count and sum amount

    set get_info "[get_sql $cnt_type [set $midlist]]"

    #puts $get_info

    set cursor ""
    if { $cnt_type == "DISC_DATA" } {
        set cursor $clr_get3
    } else {
        set cursor $auth_get
    }
    MASCLR::log_message "get_info: \n\t$get_info" 3
    orasql $cursor $get_info

    ###### Writing File Header into the Mas file

    ###### Declearing Variables and intializing

    set chkmid " "
    set chkmidt " "
    set totcnt 0
    set totamt 0
    set ftotcnt 0
    set ftotamt 0
    set trlcnt 0
    ###### While Loop for to fetch records gathered by Sql Select get_info

    while {[set loop [orafetch $cursor -dataarray a -indexbyname]] == 0} {
        ### clear variables
        set rec(mas_code) ""
        set rec(trans_id) ""
        set    msg_text "a(MID): $a(MID), cnt_type: $cnt_type, "
        append msg_text "$a(CARD_TYPE), $a(STATUS), "
        append msg_text "a(CNT): $a(CNT), a(AMT): $a(AMT) "
        MASCLR::log_message $msg_text 3
        switch $a(CARD_TYPE) {
            "VS" {set c_sch "04"}
            "04" {set c_sch "04"}
            "MC" {set c_sch "05"}
            "AX" {set c_sch "03"}
            "DS" {set c_sch "08"}
            "DC" {set c_sch "07"}
            "JC" {set c_sch "09"}
            "DB" {set c_sch "02"}
            default  {set c_sch "00"}
        }
        set rec(card_scheme) $c_sch

        ### set the mas_code
        ### do this early so the trans type can skip if needed
        if { $cnt_type == "AU" } {
            set rec(mas_code) "00AU_CHK"
        } elseif { $cnt_type == "WOOT" } {
            switch $c_sch {
                "04" { set rec(mas_code) "VISA_BANK_SPONSOR" }
                "05" { set rec(mas_code) "MC_BANK_SPONSOR" }
            }
        } elseif { $cnt_type == "WOOT2" } {
            set rec(mas_code) "00BUSRULE"
        } elseif { $cnt_type == "DBT_FIX" } {
            set rec(mas_code) "DBT_T1"
        } elseif { $cnt_type == "ASSOC" } {
            switch $c_sch {
                "04" { set rec(mas_code) "VISA_ASSMT_FLAT" }
                "05" { set rec(mas_code) "MC_ASSMT_FLAT" }
                "08" { set rec(mas_code) "DISC_DATA_USAGE" }
            }
        } elseif { $cnt_type == "ASSESS" } {
            switch $c_sch {
                "04" { set rec(mas_code) "VISA_ASSMT" }
                "05" { set rec(mas_code) "MC_ASSMT" }
                "08" { set rec(mas_code) "DISC_ASSMT" }
            }
        } elseif { $cnt_type == "ZEROVERI" } {
            switch $c_sch {
                "04" { set rec(mas_code) "VS_ZERO_VERI" }
                "05" { set rec(mas_code) "MC_ZERO_VERI" }
            }
        } elseif { $cnt_type == "FORCE" } {
             set rec(mas_code) "VS_FORCE"
        } elseif { $cnt_type == "DBMONTHLY" } {
             set rec(mas_code) "DBT_ASSMT_MONTHLY"
        } elseif {[info exists mas_cd($c_sch-$a(REQUEST_TYPE)-$a(STATUS))]} {
            if {[set mcdchk $mas_cd($c_sch-$a(REQUEST_TYPE)-$a(STATUS))] != "IGNORE"} {
                set rec(mas_code) $mas_cd($c_sch-$a(REQUEST_TYPE)-$a(STATUS))
            } else {
                continue
            }
        } else {
            set    msg_text "New request type mas_cd($c_sch-$a(REQUEST_TYPE)-$a(STATUS)) "
            append msg_text "not found in MAS_FILE_CODE_GRP table"
            MASCLR::log_message $msg_text
            set    msg_text ""

        }
        ###### Writing Batch Header Or Batch Trailer

        if {$chkmid != $a(MID)} {
            set trlcnt 1
            if {$chkmid != " "} {
                # added by SNS to fix integer overflow
                #   puts "position 1: totamt = $totamt"
                set rec(batch_amt)  $totamt
                set rec(batch_cnt) $totcnt
                write_bt_record $fileid rec
                set chkmidt $a(MID)
                set totcnt 0
                set totamt 0
                #   set trlcnt 1
            }

            if { [array exists curr_cd($a(MID))] } {
                set set rec(batch_curr) $curr_cd($a(MID))
            } else {
                set rec(batch_curr) "$inst_curr_cd"
            }

            #set rec(batch_curr) "$curr_cd($a(MID))"
            set rec(activity_date_time_bh) $batchtime
            if { $cnt_type == "AU" || $cnt_type == "DISC_DATA" || $cnt_type == "DBMONTHLY" } {
                set rec(merchantid) "$a(MID)"
            } else {
                set rec(merchantid) "$entity_id($a(MID))"
            }
            set rec(inbatchnbr) [pbchnum]
            set rec(infilenbr)  1
            set rec(batch_capture_dt) $batchtime
            set rec(sender_id) $a(MID)
            set rec(institution_id) [format %-10s "$inst_id"]

            write_bh_record $fileid rec

            set chkmid $a(MID)
        }

        ###### Writing Message Detail records
        set tid_idntfr "" ; #<tid_idntfr> can be needed for multiple tid option""
        if {$cnt_type != "ACH"} {
            set mas_tid [get_tid $cnt_type $tid_idntfr]
            set rec(trans_id) $mas_tid
        } else {
            get_tid $cnt_type $tid_idntfr
            set rec(trans_id) $mas_tid($a(REQUEST_TYPE))
        }

        if { $cnt_type == "AU" || $cnt_type == "DISC_DATA" || $cnt_type == "DBMONTHLY" } {
            set rec(entity_id) $a(MID)
        } else {
            set rec(entity_id) $entity_id($a(MID))
        }

        #A switch to convert card types----------------

        set rec(nbr_of_items) $a(CNT)
        set rec(amt_original) [expr wide(round([expr $a(AMT) * 100]))]
        set rec(external_trans_id) ""
        set rec(trans_ref_data)    ""

        write_md_record $fileid rec

        if {$MASCLR::DEBUG_LEVEL > 0} {
            flush $fileid
        }

        set totcnt [expr $totcnt + $a(CNT)]
        set totamt [expr $totamt + $rec(amt_original)]

        set ftotcnt [expr $ftotcnt + $a(CNT)]
        set ftotamt [expr $ftotamt + $rec(amt_original)]

        # MASCLR::log_message "a(MID): $a(MID), cnt_type: $cnt_type, a(CNT): $a(CNT) " 3

        # if { $cnt_type == "CNP"} {
        #     set    tmp_msg "a(CNT_CNP): $a(CNT_CNP), "
        #     append tmp_msg "a(AMT_CNP): $a(AMT_CNP) "
        #     MASCLR::log_message $tmp_msg 3
        #     set rec(mas_code)  "${c_sch}_CNP"
        #
        #     set rec(nbr_of_items) $a(CNT_CNP)
        #     set rec(amt_original) [expr wide(round([expr $a(AMT_CNP) * 100]))]
        #     write_md_record $fileid rec
        #
        #     set totcnt [expr $totcnt + $a(CNT_CNP)]
        #     set totamt [expr $totamt + $rec(amt_original)]
        #
        #     set ftotcnt [expr $ftotcnt + $a(CNT_CNP)]
        #     set ftotamt [expr $ftotamt + $rec(amt_original)]
        # }

        if { $cnt_type == "AU"} {
            set    tmp_msg "a(CNT_UPDATE): $a(CNT_UPDATE), "
            append tmp_msg "a(AUTH_MID): $a(AUTH_MID), a(TID): $a(TID) "
            MASCLR::log_message $tmp_msg 3
            set rec(mas_code) "00AU_UPDATE"
            set a(CNT) 1
            set rec(nbr_of_items) $a(CNT_UPDATE)
            write_md_record $fileid rec

            set totcnt [expr $totcnt + $a(CNT_UPDATE)]
            set totamt [expr $totamt + $rec(amt_original)]

            set ftotcnt [expr $ftotcnt + $a(CNT_UPDATE)]
            set ftotamt [expr $ftotamt + $rec(amt_original)]
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
    ###### Writing File Trailer Record
    set rec(file_amt) $ftotamt
    set rec(file_cnt) $ftotcnt

    write_ft_record $fileid rec

    ###### Closing Output file

    close $fileid
    if {$MODE == "TEST"} {
        catch {exec  mv $outfile $env(PWD)/ON_HOLD_FILES/.} result
    } elseif {$MODE == "PROD"} {
        catch {exec  mv $outfile $env(PWD)/MAS_FILES/.} result
    }
}
puts "==============================================END OF FILE============================================"
     #==============================================END PROGRAM============================================
