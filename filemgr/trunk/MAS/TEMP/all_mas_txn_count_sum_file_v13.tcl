#!/usr/bin/env tclsh


# $Id: all_mas_txn_count_sum_file_v13.tcl 3016 2015-06-25 19:27:17Z jkruse $

#Written By Rifat Khan
#Jetpay LLC
#Older internal vertion 1.0 , Older version 35.0
#Changed the trans_ref_data from 25 spaces to 23 spaces and changed the line size
# for MSG detail to 200 bytes.
#revised 20060426 with internal version 1.1 , expected version of 36.0
#
#Changed the complete code reformated for perfomance issue.
#revised 20061201 with internal verion 2.0
#

package require Oratcl
package provide random 1.0

source $env(MASCLR_LIB)/masclr_tcl_lib

############################################################################################################

#Environment veriables.......

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

set id_var  "$Id: all_mas_txn_count_sum_file_v13.tcl 3016 2015-06-25 19:27:17Z jkruse $nihil"
set rev_var "$Rev: 3016 $nihil"
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
global tblnm_mf tblnm_e2a tblnm_tr data_jdate

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
        2) -c<Count File Type>  (Required Eg: VAU, AUTH, ACH ... etc.)
        3) -m<Month>            (Optional Eg: 1-12 OR JAN-DEC <> Defualt Value: Current Month)
        4) -y<Year>             (Optional Eg: 2008, 2007 <> Format: YYYY <> Default Value: Current Year)
        5) -t<Cutoff Time>      (Optional Eg: 020000, 143000 <> Format: HH24MISS <> Default Value: 000000)
        Example:
        mas_txn_count_sum_file_v13.tcl -i101 -cAUTH -m9
        mas_txn_count_sum_file_v13.tcl -i107 -cVAU -mJAN -y2007
        Note:
        You can not run this code for future Months. It will autometically set it to Above Defualt Values.
        "

    puts stdout "\n Valid Count File Type values are:
         1) AUTH         -- Credit Card Authorization transaction count file
         2) VAU          -- Credit Card Visa Account Updater transaction count file
         3) RCYL         -- Credit Card Attempted Recycle transaction count file
         4) AVS          -- Credit Card AVS Block transaction count file
         5) ACH          -- ACH transaction count file
         6) BTCH         -- Credit Card Batch Header count file
         7) CVV2         -- Credit Card CVV2 Block transaction count file
         8) BIN          -- Credit Card BIN Block transaction count file
         9) VLCK         -- Velocity Check transaction count file
        10) FRD          -- Credit Card Fraud count file
        11) SEC          -- Credit Card Secure code transaction count file
        12) VBV          -- Credit Card VBV transaction count file
        13) MBU          -- Credit Card MC Account Updater transaction count file
        14) PROGRAM_BLOCK
        15) DB_FIX       -- Debit card fix for transaction count file
        16) ASSOC        -- Association code fix fee transaction count file
        17) ASSESS       -- Assessment fee fix with transaction count file
        18) AUTHDB       -- Debit Card transaction count file
        19) AVSAUTH      -- Credit Card AVS check transaction count file
        20) FANF         -- Visa FANF (Fixed Acquirer Network Fee)
        "
}

proc show_direction {} {
    # TODO - show direction is deprecaded and should no longer be used

    set run_instruction "Please follow below instructions to run this code -->
        Code runs with minimum 2 to maximum 5 arguments.
        Arguments parameters:
        1) -i<Institution Id>   (Required Eg: 101, 105, 107 ... etc.)
        2) -c<Count File Type>  (Required Eg: VAU, AUTH, ACH ... etc.)
        3) -m<Month>            (Optional Eg: 1-12 OR JAN-DEC <> Defualt Value: Current Month)
        4) -y<Year>             (Optional Eg: 2008, 2007 <> Format: YYYY <> Default Value: Current Year)
        5) -t<Cutoff Time>      (Optional Eg: 020000, 143000 <> Format: HH24MISS <> Default Value: 000000)
        Example:
        mas_txn_count_sum_file_v13.tcl -i101 -cAUTH -m9
        mas_txn_count_sum_file_v13.tcl -i107 -cVAU -mJAN -y2007
        Note:
        You can not run this code for future Months. It will autometically set it to Above Defualt Values.
        "
    return $run_instruction
}

# internal routine that returns the last valid day of a given month and year
proc lastDay {month year} {
    set days [clock format [clock scan "+1 month -1 day" \
                  -base [clock scan "$month/01/$year"]] -format %d]
}

proc get_sql {f_type midlist} {

    global currdate jdate sdate adate rightnow cmonth cdate cyear
    global begindatetime enddatetime begintime endtime cutoff batchtime
    global tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf
    global tblnm_bt tblnm_mf tblnm_e2a tblnm_tr
    global inst_id run_month_year data_jdate

    # skipping MID RIVER-RIDGE-CAMP on auth counts because this is an ACH only that
    # was put into 105.  This will eventually move to 808

    switch $f_type {
        # this is a hardcoded mess for Woot.
        "WOOT" {
            set nm "select mid, count(amount) as cnt, sum(amount) as amt, card_type, request_type, 'A'
                from tranhistory
                where card_type in ('MC','VS') and mid in
                    ('KIDWOOT', 'SELLOUT.WOOT.001', 'SHIRTWOOTCOM', 'WINEWOOTCOM', 'WOOTCOM')
                and status = '105'
                and settle_date >= $begindatetime
                AND settle_date < $enddatetime
                group by mid, card_type, request_type, 'A'"
        }
        "DISC_DATA" {
            set nm "select entity_id as mid, count(*) as cnt, sum(amt_billing) as amt,
                        'DS' as card_type,decode (tid,'010003005101','0200','0420') as request_type,
                        'A' as status
                    from mas_trans_log
                    where to_char(gl_date,'MON-YYYY') = $run_month_year
                    and card_scheme = '08'
                    and institution_id = '$inst_id'
                    and tid in ('010003005101','010003005102')
                    and (institution_id, file_id) in (
                    select institution_id, file_id
                        from mas_file_log where to_char(receive_date_time,'MON-YYYY') = $run_month_year
                        and institution_id = '$inst_id'
                    )
                    group by entity_id,  'DS', decode (tid,'010003005101','0200','0420'),'A'
                    order by entity_id"
        }
        "AUTH" {
            set nm "select  /*+INDEX(t TRANSACTION_AUTHDATETIME)*/
                         mid,
                         count(amount) as cnt,
                         sum(amount) as amt,
                         card_type,
                         /* a capture without an authorization */
                         /*
                         case when request_type = '0250'
                                and other_data3 = other_data4
                         then
                            '0200'
                         else
                            request_type
                         end
                         */
                         request_type,
                         decode (action_code,'000','A','D') as status,
                         case when request_type = '0250'
                                and other_data3 = other_data4
                           then 1 else 0 end od3_eq_od4
                    from teihost.transaction
                    where
                         mid in ($midlist)
                         and mid not in ('RIVER-RIDGE-CAMP')
                         and authdatetime >= $begindatetime
                         and authdatetime < $enddatetime
                         and shipdatetime < $enddatetime
                         and request_type in (
                             '0100', '0102', '0190', '0200', '0220', '0240', '0250',
                             '0252', '0260', '0352', '0354', '0356', '0358', '0420',
                             '0440', '0450', '0460', '0480', '0500', '0530')
                         and card_type not in ('DB')
                    group by
                         mid,
                         card_type,
                         /*
                         case when request_type = '0250'
                                and other_data3 = other_data4
                         then
                            '0200'
                         else
                            request_type
                         end,
                         */
                         request_type,
                         decode (action_code,'000','A','D'),
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
                          decode (action_code,'000','A','D') as status
                    from teihost.transaction
                    where
                          mid in ($midlist)
                          and mid not in ('RIVER-RIDGE-CAMP')
                          and authdatetime >= $begindatetime
                          and authdatetime < $enddatetime
                          and shipdatetime < $enddatetime
                          and request_type in ('0100','0200')
                          and card_type in ('VS','MC')
                    group by
                          mid,
                          card_type,
                          request_type,
                          decode (action_code,'000','A','D')
                    order by mid"
        }
        "AUTHDB" {
            set nm "select  /*+INDEX(t TRANSACTION_AUTHDATETIME)*/
                         mid,
                         count(amount) as cnt,
                         sum(amount) as amt,
                         card_type,
                         request_type,
                         decode (action_code,'000','A','D') as status
                    from teihost.transaction
                    where
                         mid in ($midlist)
                         and authdatetime >= $begindatetime
                         and authdatetime < $enddatetime
                         and shipdatetime < $enddatetime
                         and card_type in ('DB')
                    group by
                         mid,
                         card_type,
                         request_type,
                         decode (action_code,'000','A','D')
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
                        and authdatetime >= $begindatetime
                        and authdatetime < $enddatetime
                        and shipdatetime < $enddatetime
                        and request_type in ('0100','0102','0190','0200','0220','0240',
                        '0250','0252','0260','0352','0354','0356',
                        '0358','0400','0402','0420','0440','0450',
                        '0460','0480','0500','0530')
                    group by
                        mid,
                        '00',
                        '0200',
                        'A'
                    order by mid"
        }
        "VAU" {
            set nm "SELECT
                        (SELECT mid FROM teihost.terminal WHERE tid = f.mid) AS mid,
                         COUNT(1) AS cnt,
                         SUM(amount) AS amt,
                         '00' AS card_type,
                         '0200' AS request_type,
                         'A' AS status
                    FROM teihost.batch_transaction b,
                         teihost.batch_file f
                    WHERE b.job_id = f.job_id
                    AND b.job_id IN
                         (SELECT UNIQUE job_id
                         FROM teihost.batch_transaction
                         WHERE vau_reason <> ' '
                         AND job_id IN
                             (SELECT job_id
                             FROM teihost.batch_file
                             WHERE submission_datetime >= $begindatetime
                             AND submission_datetime < $enddatetime)
                         )
                    AND b.vau_reason IN('V', 'A', 'C', 'E', 'Q')
                    AND f.mid IN ($midlist)
                    GROUP BY mid
                    ORDER BY mid"
        }
        "MBU" {
            set nm "SELECT
                        (SELECT mid FROM teihost.terminal WHERE tid = f.mid) AS mid,
                        COUNT(1) AS cnt,
                        SUM(amount) AS amt,
                        '00' AS card_type,
                        '0200' AS request_type,
                        'A' AS status
                    FROM teihost.batch_transaction b,
                        teihost.batch_file f
                    WHERE b.job_id = f.job_id
                    AND b.job_id IN
                        (SELECT UNIQUE job_id
                        FROM teihost.batch_transaction
                        WHERE vau_reason <> ' '
                        AND job_id IN
                            (SELECT job_id
                            FROM teihost.batch_file
                            WHERE submission_datetime >= $begindatetime
                            AND submission_datetime < $enddatetime)
                        )
                    AND b.vau_reason IN('U','0')
                    AND substr(b.new_cardnum,1,1) = '5'
                    AND f.mid IN ($midlist)
                    GROUP BY mid
                    ORDER BY mid"
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
                    AND authdatetime >= $begindatetime
                    AND authdatetime < $enddatetime
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
            set nm "select
                         mid,
                         count(amount) as cnt,
                         sum(amount) as amt,
                         card_type,
                         request_type,
                         decode (action_code,'000','A','D') as status
                    from teihost.transaction
                    where
                         mid in ($midlist)
                         and authdatetime >= $begindatetime
                         and authdatetime < $enddatetime
                         and shipdatetime < $enddatetime
                         and request_type in ('0100','0102','0190','0200','0220','0240',
                         '0250','0252','0260','0352','0354','0356',
                         '0358','0400','0402','0420','0440','0450',
                         '0460','0480','0500','0530')
                         and action_code in ('930','931','932','981')
                    group by
                         mid,
                         card_type,
                         request_type,
                         decode (action_code,'000','A','D')
                    order by mid"
        }
        "AVSAUTH" {
            set nm "select
                    t.mid,
                    count(t.amount) as cnt,
                    sum(t.amount) as amt,
                    t.card_type,
                    t.request_type,
                    decode (t.action_code,'000','A','D') as status
                from teihost.transaction t join teihost.ecomm_addendum_auth eaa
                ON t.other_data3 = eaa.unique_id
                where   t.mid in ($midlist)
                    and t.authdatetime >= $begindatetime
                    and t.authdatetime <  $enddatetime
                    and t.shipdatetime <  $enddatetime
                    and t.request_type in ('0100', '0200', '0260')
                group by
                    t.mid, t.card_type, t.request_type,
                    decode(t.action_code, '000', 'A', 'D')
                order by mid"
        }

        "FANF" {
            set nm "
                    select
                        term_cnt.mid                              as mid,
                        sum(term_cnt.loc)                         as cnt,
                        sum(fanf_tbl.amt)                         as amt,
                        fanf_tbl.card_type                        as card_type,
                        'FANF_' || fanf_tbl.tbl_1                 as mas_code,
                        fanf_tbl.cp_cnt_pct                       as cp_cnt_pct,
                        fanf_tbl.cp_vol_pct                       as cp_vol_pct,
                        fanf_tbl.tbl_2                            as tbl_2
                    from
                        (
                        select
                            mer.fed_tax_id                                                  as fed_tax_id,
                            mer.sic_code                                                    as mcc,
                            th.card_type                                                    as card_type,
                            sum(decode(nvl(trim(th.transaction_type), 'R'), 'R', 1, 0)) /
                                    count(*) * 100                                          as cp_cnt_pct,
                            sum(th.amount
                                *decode(nvl(trim(th.transaction_type), 'R'), 'R', 1, 0)) /
                                    sum(th.amount) * 100                                    as cp_vol_pct,
                            case
                            when sum(decode(nvl(trim(th.transaction_type), 'R'), 'R', 1, 0)) > 10 then
                                case
                                when
                                        (mer.sic_code between '3000' and '3999'
                                        or mer.sic_code in (
                                            '4411', '4511', '4829', '5200', '5300',
                                            '5309', '5310', '5311', '5411', '5511',
                                            '5532', '5541', '5542', '5651', '5655',
                                            '5712', '5732', '5912', '5943', '7011',
                                            '7012', '7512', '7832'))
                                    and
                                        (sum(decode(nvl(trim(th.transaction_type), 'R'), 'R', 1, 0)) /
                                            count(*) * 100) > 50
                                then '1A'
                                else
                                    case when mer.sic_code != '5814'
                                        and
                                        (sum(decode(nvl(trim(th.transaction_type), 'R'), 'R', 1, 0)) /
                                            count(*) * 100) > 10
                                    then '1B'
                                    else '2'
                                    end
                                end
                            else '2'
                            end                                                             as tbl_1,
                            case
                            when (sum(decode(nvl(trim(th.transaction_type), 'R'), 'R', 0, 1)) /
                                        count(*) * 100) > 10
                                or mer.sic_code = '5814'
                            then '2'
                            end                                                             as tbl_2,
                            count(*)                                                        as cnt,
                            sum(decode(nvl(trim(th.transaction_type), 'R'), 'R', 0, 1))     as cnp_cnt,
                            sum(decode(nvl(trim(th.transaction_type), 'R'), 'R', 1, 0))     as cp_cnt,
                            sum(th.amount*decode(substr(th.request_type, 1, 2), '04',-1,1)
                                *decode(nvl(trim(th.transaction_type), 'R'), 'R', 0, 1))    as cnp_amt,
                            sum(th.amount*decode(substr(th.request_type, 1, 2), '04',-1,1)
                                *decode(nvl(trim(th.transaction_type), 'R'), 'R', 1, 0))    as cp_amt,
                            sum(th.amount*decode(substr(th.request_type, 1, 2), '04',-1,1)) as amt

                        from tranhistory th, merchant mer
                        where mer.mid in ($midlist)
                        and th.authdatetime >= $begindatetime
                        and th.authdatetime < $enddatetime
                        and th.mid = mer.mid
                        and th.card_type ='VS'
                        and (th.request_type like '02%' /* or th.request_type like '04%' */)
                        and length(mer.fed_tax_id) = 9
                        group by mer.fed_tax_id, mer.sic_code, th.card_type
                        order by mer.fed_tax_id, tbl_1, sic_code
                        ) fanf_tbl

                    join

                        /* grabbing active merchants and terminals
                            with a count of unique address, zip pairs */
                        (select
                            mer.fed_tax_id ,
                            count(distinct ter.address_1 || ter.zip)            as Loc,
                            min(mer.visa_id)                                    as mid

                        from terminal ter, merchant mer
                        where mer.mid in ($midlist)
                        and ter.mid = mer.mid
                        and (mer.status = 'A' or mer.active = 'A')
                        and (ter.status = 'A' or ter.active = 'A')
                        and mer.visa_id is not null
                        and length(mer.visa_id) = 15
                        and length(fed_tax_id) = 9
                        group by mer.fed_tax_id
                        order by mer.fed_tax_id) term_cnt
                    on fanf_tbl.fed_tax_id = term_cnt.fed_tax_id
                    group by
                        term_cnt.mid                              ,
                        fanf_tbl.card_type                        ,
                        'FANF_' || fanf_tbl.tbl_1                 ,
                        fanf_tbl.cp_cnt_pct                       ,
                        fanf_tbl.cp_vol_pct                       ,
                        fanf_tbl.tbl_2
                    order by mid"
        }

        "PROGRAM_BLOCK" {
            set nm "select
                        mid,
                        count(amount) as cnt,
                        sum(amount) as amt,
                        card_type,
                        request_type,
                        decode (action_code,'000','A','D') as status
                    from teihost.transaction
                    where
                        mid in ($midlist)
                    and authdatetime >= $begindatetime
                    and authdatetime < $enddatetime
                    and shipdatetime < $enddatetime
                    and request_type in ('0100','0102','0190','0200','0220','0240',
                        '0250','0252','0260','0352','0354','0356',
                        '0358','0400','0402','0420','0440','0450',
                        '0460','0480','0500','0530')
                        and action_code in ('934')
                    group by
                        mid,
                        card_type,
                        request_type,
                        decode (action_code,'000','A','D')
                    order by mid"
        }
        "ACH" {
            set nm "select  /*+INDEX(t TRANSACTION_AUTHDATETIME)*/
                        mid,
                        count(amount) as cnt,
                        sum(amount) as amt,
                        card_type,
                        request_type,
                        decode (action_code,'000','A','D')  as status
                    from teihost.transaction
                    where
                        mid in ($midlist)
                        and authdatetime >= $begindatetime
                        and authdatetime < $enddatetime
                        and request_type in ('0660','0662','0668','0679','0680')
                    group by
                        mid,
                        card_type,
                        request_type,
                        decode (action_code,'000','A','D')
                    order by
                        mid,
                        card_type,
                        request_type,
                        decode (action_code,'000','A','D')"
        }
        "BTCH" {
            set nm "SELECT
                        mid,
                        COUNT(UNIQUE SUBSTR(authdatetime,   1,   8)) AS cnt,
                        SUM(amount) AS amt,
                        '00' AS card_type,
                        '0200' AS request_type,
                        'A' AS status
                    FROM teihost.transaction WHERE
                        mid IN($midlist)
                    and authdatetime >= $begindatetime
                    and authdatetime < $enddatetime
                    and shipdatetime < $enddatetime
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
                        decode (action_code,'000','A','D') as status
                    from teihost.transaction
                    where
                        mid in ($midlist)
                    and authdatetime >= $begindatetime
                    and authdatetime < $enddatetime
                    and shipdatetime < $enddatetime
                    and request_type in ('0100','0102','0190','0200','0220','0240',
                        '0250','0252','0260','0352','0354','0356',
                        '0358','0400','0402','0420','0440','0450',
                        '0460','0480','0500','0530')
                        and action_code in ('933')
                    group by
                        mid,
                        card_type,
                        request_type,
                        decode (action_code,'000','A','D')
                    order by mid"
        }
        "BIN" {
            set nm "select
                        mid,
                        count(amount) as cnt,
                        sum(amount) as amt,
                        card_type,
                        request_type,
                        decode (action_code,'000','A','D') as status
                    from teihost.transaction
                    where
                        mid in ($midlist)
                    and authdatetime >= $begindatetime
                    and authdatetime < $enddatetime
                    and shipdatetime < $enddatetime
                    and request_type in ('0100','0102','0190','0200','0220','0240',
                        '0250','0252','0260','0352','0354','0356',
                        '0358','0400','0402','0420','0440','0450',
                        '0460','0480','0500','0530')
                    and action_code in ('099')
                    group by
                        mid,
                        card_type,
                        request_type,
                        decode (action_code,'000','A','D')
                    order by mid"
        }
        "VLCK"          {set nm "Select 'NOT SUPPORTED YET' from DUAL"}
        "FRD"           {set nm "Select 'NOT SUPPORTED YET' from DUAL"}
        "SEC"           {set nm "Select 'NOT SUPPORTED YET' from DUAL"}
        "VBV"           {set nm "Select 'NOT SUPPORTED YET' from DUAL"}
        "DB_FIX" {
            set nm "select entity_id as mid, count(*) as cnt, sum(amt_billing) as amt,
                        'DB' as card_type,
                        decode (tid,'010003005101','0200','0420') as request_type,
                        'A' as status
                    from mas_trans_log
                    where to_char(gl_date,'MON-YYYY') = $run_month_year
                    and card_scheme = '02'
                    and institution_id = '$inst_id'
                    and tid in ('010003005101','010003005102')
                    and (institution_id, file_id) in (
                        select institution_id, file_id
                        from mas_file_log
                        where to_char(receive_date_time,'MON-YYYY') = $run_month_year
                        and institution_id = '$inst_id')
                    group by entity_id,  'DB', decode (tid,'010003005101','0200','0420'),'A'
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
                        decode (tid,'010003005101','0200','0420') as request_type,
                        'A' as status
                    from mas_trans_log
                    where to_char(gl_date,'MON-YYYY') = $run_month_year
                    and card_scheme in ('04', '05', '08')
                    and institution_id = '$inst_id'
                    and tid in ('010003005101','010003005102')
                    and (institution_id, file_id) in (
                        select institution_id, file_id
                        from mas_file_log where to_char(receive_date_time,'MON-YYYY') = $run_month_year
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
                        decode (tid,'010003005101','0200','0420'),'A'
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
                        decode (tid,'010003005101','0200','0420') as request_type,
                        'A' as status
                    from mas_trans_log
                    where to_char(gl_date,'MON-YYYY') = $run_month_year
                    and card_scheme in ('04', '05', '08')
                    and institution_id = '$inst_id'
                    and tid in ('010003005101','010003005102')
                    and (institution_id, file_id) in (
                        select institution_id, file_id
                        from mas_file_log where to_char(receive_date_time,'MON-YYYY') = $run_month_year
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
                        decode (tid,'010003005101','0200','0420'),'A'
                    order by entity_id"
        }
        default {
            usage $f_type
            exit 1
        }

    }
    puts $nm
    return $nm
}

proc get_mff {f_type} {
    switch $f_type {
        "AUTH"          {set nm "Y"}
        "AUTH2"         {set nm "Y"}
        "AUTHDB"        {set nm "Y"}
        "WOOT"          {set nm "Y"}
        "WOOT2"         {set nm "Y"}
        "VAU"           {set nm "Y"}
        "MBU"           {set nm "Y"}
        "RCYL"          {set nm "Y"}
        "AVS"           {set nm "Y"}
        "ACH"           {set nm "Y"}
        "BTCH"          {set nm "Y"}
        "CVV2"          {set nm "Y"}
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
        "FANF"          {set nm "Y"}
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
        "VAU"           {set nm "VAU"}
        "MBU"           {set nm "MBU"}
        "RCYL"          {set nm "TRANSACTION_RECYCLING"}
        "AVS"           {set nm "AVS_REJECT"}
        "CVV2"          {set nm "CVV2"}
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
        "FANF"          {set nm "FANF"}
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
        "VAU"           {set nm "VAUCOUNT"}
        "MBU"           {set nm "MBUCOUNT"}
        "RCYL"          {set nm "RECYLING"}
        "AVS"           {set nm "AVSCOUNT"}
        "CVV2"          {set nm "CVVCOUNT"}
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
        "FANF"          {set nm "VISAFANF"}
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
        "VAU"           {set nm "010070010008"}
        "MBU"           {set nm "010070010008"}
        "RCYL"          {set nm "010070010001"}
        "AVS"           {set nm "010070010003"}
        "CVV2"          {set nm "010070010004"}
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
        "VLCK"          {set nm "VELCHECK"; puts "UPDATE CODE HERE, ADD TID FOR VELOCITY CHECK"; exit 1 }
        "FRD"           {set nm "FRDCHECK"; puts "UPDATE CODE HERE, ADD TID FOR FRAUD CHECK"; exit 1 }
        "SEC"           {set nm "SECRCODE"; puts "UPDATE CODE HERE, ADD TID FOR SECURE CODE CHECK"; exit 1 }
        "VBV"           {set nm "VBVCHECK"; puts "UPDATE CODE HERE, ADD TID FOR VBV CHECK"; exit 1 }
        "PROGRAM_BLOCK" {set nm "010070010019"}
        "DISC_DATA"     {set nm "010070010017"}
        "DB_FIX"        {set nm "010070010022"}
        "ASSOC"         {set nm "010070010023"}
        "ASSESS"        {set nm "010070010024"}
        "AVSAUTH"       {set nm "010070010025"}
        "FANF"          {set nm "010070010026"}
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

proc get_cfg {inst_id cfg_pth} {
    global arr_cfg
    set cfg_file "$inst_id.inst.cfg"
    set in_cfg [open $cfg_pth/$cfg_file r]
    set cur_line  [split [set orig_line [gets $in_cfg] ] ,]
    while {$cur_line != ""} {
        if {[string toupper [string trim [lindex $cur_line 0]]] != ""} {
            set arr_cfg([string toupper [string trim [lindex $cur_line 0]]]) [string trim [lindex $cur_line 1]]
        }
        puts "arr_cfg([string toupper [string trim [lindex $cur_line 0]]]) [string trim [lindex $cur_line 1]]"
        set cur_line  [split [set orig_line [gets $in_cfg] ] ,]
    }
    return arr_cfg
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

    global  arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year argc argv get_run_year box clrpath
    global  maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c
    global  mbody_u mbody_h mbody_m mbody_l sysinfo cfg_pth log_pth arch_pth hold_pth upld_pth stop_pth
    global  tmp_pth currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime
    global  begintime endtime cutoff batchtime tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw
    global  tblnm_bf tblnm_bt tblnm_mf tblnm_e2a tblnm_tr run_month_year data_jdate

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

    #set begindatetime "to_char(last_day(add_months(SYSDATE, -[expr 1 + $mnth])), 'YYYYMMDD') || '$cutoff'"
    set run_month_year "to_char(to_date('$run_year$mnth$last_day', 'YYYYMMDD'),'MON-YYYY')"
    #set enddatetime "to_char(last_day(add_months(SYSDATE, -[expr 0 + $mnth])), 'YYYYMMDD') || '$cutoff'"
    #set enddatetime "to_char(SYSDATE, 'YYYYMMDD') || '$cutoff'"
    set begindatetime "'$run_year$mnth' '01' || '$cutoff'"
    set begindatetime ""
    append begindatetime "'" $run_year $mnth 01 $cutoff "'"
    set enddatetime ""
    append enddatetime   "'" $run_year $mnth $last_day $cutoff "'"
    append batchtime $sdate $cutoff
    puts "Transaction count between $begindatetime :: $enddatetime :: $batchtime"
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
        #	exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u"
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
    global  arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year db_logon_handle db_login_handle
    global  box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m
    global  msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo cfg_pth log_pth arch_pth hold_pth
    global  upld_pth stop_pth tmp_pth currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime
    global  enddatetime begintime endtime cutoff batchtime tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg
    global  tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a tblnm_tr data_jdate

    global $cursr
    set $cursr [oraopen $db_login_handle]
}

proc open_cursor_teihost {cursr} {
    global  arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year db_logon_handle db_login_handle
    global  box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m
    global  msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo cfg_pth log_pth arch_pth hold_pth
    global  upld_pth stop_pth tmp_pth currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime
    global  enddatetime begintime endtime cutoff batchtime tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg
    global  tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a  tblnm_tr

    global $cursr
    set $cursr [oraopen $db_logon_handle]

}

proc get_outfile {f_seq} {
    global  arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year box clrpath maspath mailtolist
    global  mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h
    global  mbody_m mbody_l sysinfo cfg_pth log_pth arch_pth hold_pth upld_pth stop_pth tmp_pth env
    global  currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime
    global  endtime cutoff batchtime tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf
    global  tblnm_bt tblnm_mf tblnm_e2a tblnm_tr data_jdate

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

#Defining tcr records type , lenght and description below

#Mas file Header Record

set tcr(FH) {
    fhtrans_type             2 a {File Header Transmission Type}
    file_type                2 a {File Type}
    file_date_time          16 x {File Date and Time}
    activity_source         16 a {Activity Source}
    activity_job_name        8 a {Activity Job name}
    suspend_level            1 a {Suspend Level}
}

#Mas Batch Header Record

set tcr(BH) {
    bhtrans_type             2 a {Batch Header Transmission Type}
    batch_curr               3 a {Currency of the batch}
    activity_date_time_bh   16 x {System date and time}
    merchantid              30 a {ID of the merchant}
    inbatchnbr               9 n {Batch number}
    infilenbr                9 n {File number}
    billind                  1 a {Non Activity Batch Header Fee}
    orig_batch_id            9 a {Original Batch ID}
    orig_file_id             9 a {Original File ID}
    ext_batch_id            25 a {External Batch ID}
    ext_file_id             25 a {External File ID}
    sender_id               25 a {Merchant ID for the batch}
    microfilm_nbr           30 a {Microfilm Locator number}
    institution_id          10 a {Institution ID}
    batch_capture_dt        16 a {Batch Capture Date and Time}
}

#Mas Batch Trailer Record

set tcr(BT) {
    bttrans_type             2 a {Batch Trailer Transmission Type}
    batch_amt               12 n {Total Transaction Amount in a Batch}
    batch_cnt               10 n {Total Transaction count in a Batch}
    batch_add_amt1          12 n {Total additional1 amount in a Batch}
    batch_add_cnt1          10 n {Total additional1 count in a Batch}
    batch_add_amt2          12 n {Total additional2 amount in a Batch}
    batch_add_cnt2          10 n {Total additional2 count in a Batch}
}

#Mas File Trailer Record

set tcr(FT) {
    fttrans_type             2 a {File Trailer Transmission Type}
    file_amt                12 n {Total Transaction Amount in a File}
    file_cnt                10 n {Total Transaction count in a File}
    file_add_amt1           12 n {Total additional1 amount in a File}
    file_add_cnt1           10 n {Total additional1 count in a File}
    file_add_amt2           12 n {Total additional2 amount in a File}
    file_add_cnt2           10 n {Total additional2 count in a File}
}

#Mas Massage Detail Record

set tcr(01) {
    mgtrans_type             2 a {Message Deatail Transmission Type}
    trans_id                12 a {Unique Transmission identifier}
    entity_id               18 a {Internal entity id}
    card_scheme              2 a {Card Scheme identifier}
    mas_code                25 a {Mas Code}
    mas_code_downgrade      25 a {Mas codes for Downgraded Transaction}
    nbr_of_items            10 n {Number of items in the transaction record}
    amt_original            12 n {Original amount of a Transaction}
    add_cnt1                10 n {Number of items included in add_amt1}
    add_amt1                12 n {Additional Amount 1}
    add_cnt2                10 n {Number of items included in add_amt2}
    add_amt2                12 n {Additional Amount 2}
    external_trans_id       25 a {The extarnal transaction id}
    trans_ref_data          23 a {Reference Data}
    suspend_reason           2 a {The Suspend reason code}
}

#Procedure for construct tcr records according to above definitions.

proc write_tcr {aname} {
    global tcr
    upvar $aname a
    set l_tcr $a(tcr)
    set result {}

    foreach {fname flength ftype fdesc} $tcr(${l_tcr}) {

        switch -- $ftype {
            a {
                if {![info exists  a($fname)]} {
                    set  a($fname) {}
                }
                set t [format "%-${flength}.${flength}s" $a($fname)]
                set result "$result$t"
            }
            n {
                if {![info exists  a($fname)] || ($fname == "filler")} {
                    set  a($fname) 0
                }
                set t [format "%0${flength}.${flength}s" $a($fname)]
                set result "$result$t"
            }
            x {
                if {![info exists  a($fname)]} {
                    set  a($fname) {}
                }
                set t [format "%-0${flength}.${flength}s" $a($fname)]
                set result "$result$t"
            }

        }

    }
    return $result
}

#Procedure read_tcr Not use at the moment

proc read_tcr {inrec aname } {
    global tcr
    upvar $aname a
    set l_tcr [string range $inrec 0 1]
    set cur_pos 0
    foreach {fname flength ftype fdesc} $tcr(${l_tcr}) {
        set a [string range $cur_pos [expr $cur_pos + $flength - 1] ]
        set cur_pos [expr $cur_pos + $flength ]
    }
}

#Precedure print_tcr Not used at the moment

proc print_tcr {fd aname}  {
    global tcr
    upvar $aname a
    set l_tcr $a(tcr)
    set result {}
    foreach {fname flength ftype fdesc} $trc(${l_tcr}) {
        puts $fd [format "%25.25s >%s<" $fdesc $a($fname) ]
    }
}

#Below all Procedures write_??_record to assign values to the tcr fields and call
# write_tcr to constuct the tcr records

proc write_fh_record {fd aname} {
    global tcr
    upvar $aname a
    set rec(tcr) "FH"
    set rec(fhtrans_type) "FH"
    set rec(file_type) "01"
    set rec(file_date_time) $a(file_date_time)
    set rec(activity_source) $a(activity_source)
    set rec(activity_job_name) $a(activity_job_name)
    set rec(suspend_level) "T"
    puts $fd [write_tcr rec]
}

proc write_bh_record {fd aname} {
    global tcr
    upvar $aname a
    set 25spcs [format %-25s " "]
    set 23spcs [format %-23s " "]
    set rec(tcr) "BH"
    set rec(bhtrans_type) "BH"
    set rec(batch_curr) $a(batch_curr)
    set rec(activity_date_time_bh) $a(activity_date_time_bh)
    set rec(merchantid) $a(merchantid)
    set rec(inbatchnbr) $a(inbatchnbr)
    set rec(infilenbr) $a(infilenbr)
    set rec(billind) "N"
    set rec(orig_batch_id) "         "
    set rec(orig_file_id) "         "
    set rec(ext_batch_id) $25spcs
    set rec(ext_file_id) $25spcs
    set rec(sender_id) $a(sender_id)
    set rec(microfilm_nbr) [format %-30s " "]
    set rec(institution_id) [format %-10s " "]
    set rec(batch_capture_dt) $a(batch_capture_dt)

    puts $fd [write_tcr rec]
}

proc write_md_record {fd aname} {
    global tcr
    upvar $aname a
    set 25spcs [format %-25s " "]
    set 23spcs [format %-23s " "]
    set rec(tcr) "01"
    set rec(mgtrans_type) "01"
    set rec(trans_id) $a(trans_id)
    set rec(entity_id) $a(entity_id)
    set rec(card_scheme) $a(card_scheme)
    set rec(mas_code) $a(mas_code)
    set rec(mas_code_downgrade) $25spcs
    set rec(nbr_of_items) $a(nbr_of_items)
    set rec(amt_original) $a(amt_original)
    set rec(add_cnt1) "0000000000"
    set rec(add_amt1) "000000000000"
    set rec(add_cnt2) "0000000000"
    set rec(add_amt2) "000000000000"
    set rec(trans_ref_data) $23spcs
    set rec(suspend_reason) [format %-2s " "]
    set rec(external_trans_id) $25spcs

    puts $fd [write_tcr rec]
}

proc write_bt_record {fd aname} {
    global tcr
    upvar $aname a
    set rec(tcr) "BT"
    set rec(bttrans_type) "BT"
    set rec(batch_amt) $a(batch_amt)
    set rec(batch_cnt) $a(batch_cnt)
    set rec(batch_add_amt1) [format %012d "0"]
    set rec(batch_add_cnt1) [format %010d "0"]
    set rec(batch_add_amt2) [format %012d "0"]
    set rec(batch_add_cnt2) [format %010d "0"]

    puts $fd [write_tcr rec]
}

proc write_ft_record {fd aname} {
    global tcr
    upvar $aname a
    set rec(tcr) "FT"
    set rec(fttrans_type) "FT"
    set rec(file_amt) $a(file_amt)
    set rec(file_cnt) $a(file_cnt)
    set rec(file_add_amt1) [format %012d "0"]
    set rec(file_add_cnt1) [format %010d "0"]
    set rec(file_add_amt2) [format %012d "0"]
    set rec(file_add_cnt2) [format %010d "0"]

    puts $fd [write_tcr rec]
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

###### Loading Visa/MC id as exntity_id into an array with index of MID from the
# Database

proc get_curr_cd {f_type midlist} {

    #--GLOBAL LIST
    global  arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year auth_get clr_get clr_get1 clr_get2
    global  box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m
    global  msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo cfg_pth log_pth arch_pth hold_pth
    global  upld_pth stop_pth tmp_pth currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime
    global  enddatetime begintime endtime cutoff batchtime tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg
    global  tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a tblnm_tr

    ###### Loading Visa/MC id as exntity_id into an array with index of MID from the
    # Database
    if {$f_type == "VAU" || $f_type == "MBU"} {
        set get_ent "select mid, visa_id, mastercard_id, currency_code
                    from teihost.merchant
                    where mid in (select mid from teihost.terminal where tid in ($midlist))
                    and visa_id != ' '
                    and mastercard_id != ' '"
        MASCLR::log_message "get_ent: $get_ent" 3
        orasql $auth_get $get_ent

        while {[set x [orafetch $auth_get -dataarray  ent -indexbyname]] == 0} {
            set amid $ent(MID)
            set vs_id $ent(VISA_ID)
            set mc_id $ent(MASTERCARD_ID)
            set cur_cd $ent(CURRENCY_CODE)
            uplevel "set entity_id($amid) $vs_id "
            uplevel "set curr_cd($amid) $ent(CURRENCY_CODE)"

        }

    } elseif { $f_type == "DISC_DATA" || $f_type == "FANF" } {
        set get_ent "select entity_id
                    from masclr.entity_to_auth
                    where entity_id in ($midlist) and status in ('A','H') and institution_id = '$inst_id'"
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
                    where mid in ($midlist) and status in ('A','H') and institution_id = '$inst_id'"
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
#global   tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf
# tblnm_bt tblnm_mf tblnm_e2a tblnm_tr
#--PROC LIST
#proc get_fname {f_type}
#proc set_args {}
#proc show_direction {}
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
#proc write_tcr {aname}
#proc read_tcr {inrec aname }
#proc print_tcr {fd aname}
#proc write_fh_record {fd aname}
#proc write_bh_record {fd aname}
#proc write_md_record {fd aname}
#proc write_bt_record {fd aname}
#proc write_ft_record {fd aname}
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

set s "select * from masclr.MAS_FILE_CODE_GRP order by CARD_SCHEME, REQUEST_TYPE, ACTION"
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

if {$cnt_type == "AUTH" || $cnt_type == "WOOT" || $cnt_type == "WOOT2" ||
    $cnt_type == "AUTH2" || $cnt_type == "DISC_DATA" || $cnt_type == "AUTHDB" ||
    $cnt_type == "FANF"} {

    ##### Getting mid list from entity_to_auth.

    set get_ent_mid "select mid
                    from masclr.entity_to_auth
                    where institution_id = '$arr_cfg(INST_ID)'
                    and FILE_GROUP_ID = '$arr_cfg(SETTLE_SHORTNAME)'
                    and STATUS in ( 'A','H' )
                    and mas_file_flag = '[get_mff $cnt_type]'"
    MASCLR::log_message "get_ent_mid: $get_ent_mid" 3
    orasql $clr_get1 $get_ent_mid

    set mid_count 0
    set mid_list_count 0
    set list_of_mid_lists [list midlist$mid_list_count]
    set list_name "midlist$mid_list_count"
    set $list_name ""

    if {$cnt_type == "WOOT" || $cnt_type == "WOOT2" } {
        set $list_name "'KIDWOOT', 'SELLOUT.WOOT.001', 'SHIRTWOOTCOM', 'WINEWOOTCOM', 'WOOTCOM'"
    } else {
        while {[set x1 [orafetch $clr_get1 -dataarray e2a -indexbyname]] == 0} {
            if {$mid_count == 0} {
                puts "appending '$e2a(MID)' to $list_name"
                append $list_name "'$e2a(MID)'"
                set mid_count [expr $mid_count + 1]
            } else {
                puts "appending '$e2a(MID)' to $list_name"
                append $list_name ",'$e2a(MID)'"
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
                    where institution_id = '$arr_cfg(INST_ID)'
                    and FLAG_TYPE = '[get_flag_val $cnt_type]'
                    and STATUS in ( 'A','H' )
                    and FLAG_TYPE_VALUE = 'Y'
                    and mid in (select mid
                                from masclr.entity_to_auth
                                where institution_id = '$arr_cfg(INST_ID)'
                                and STATUS in ( 'A','H' )
                                and FILE_GROUP_ID = '$arr_cfg(SETTLE_SHORTNAME)')"
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
                    append $list_name ",'$e2a(MID)'"
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
            set    msg_text "No merchants found with institution_id = '$arr_cfg(INST_ID)' "
            append msg_text "and FLAG_TYPE = '[get_flag_val $cnt_type]' "
            append msg_text "and STATUS in ( 'A','H' ) and FLAG_TYPE_VALUE = 'Y'"
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
                append $list_name ",'$ltid'"
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
                set    msg_text "No merchants found with institution_id = '$arr_cfg(INST_ID)' "
                append msg_text "and FLAG_TYPE = '[get_flag_val $cnt_type]' "
                append msg_text "and STATUS in ( 'A','H' ) and FLAG_TYPE_VALUE = 'Y'"
                puts $msg_text
                set    msg_text ""
                exit 0
        } else {
                #puts "$midlist: [set $midlist]"
                #exit 0
        }

        if {$cnt_type == "DISC_DATA" && $fileseq > 1} {
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

    set rec(file_date_time) $rightnow
    set rec(activity_source) "JETPAYLLC"
    set rec(activity_job_name) "AUTHCNT"

    write_fh_record $fileid rec

    #Checking if merchant processes vs mc
    #foreach midlist $list_of_mid_lists {
    get_curr_cd $cnt_type [set $midlist]
    #}

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
        if { $cnt_type == "VAU" } {
            set rec(mas_code) "00VAUCHK"
        } elseif { $cnt_type == "MBU" } {
            set rec(mas_code) "00MBUCHK"
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
        } elseif { $cnt_type == "FANF" } {
            set rec(mas_code) $a(MAS_CODE)
        } elseif {[info exists mas_cd($c_sch-$a(REQUEST_TYPE)-$a(STATUS))]} {
            if {[set mcdchk $mas_cd($c_sch-$a(REQUEST_TYPE)-$a(STATUS))] != "IGNORE"} {
                set rec(mas_code) $mas_cd($c_sch-$a(REQUEST_TYPE)-$a(STATUS))
            } else {
                continue
            }
        } else {
            set    msg_text "New request type mas_cd($c_sch-$a(REQUEST_TYPE)-$a(STATUS) "
            append msg_text "not found in MAS_FILE_CODE_GRP table"
            puts $msg_text
            set    msg_text ""

        }
        ###### Writing Batch Header Or Batch Trailer

        if {$chkmid != $a(MID)} {
            set trlcnt 1
            if {$chkmid != " "} {
                # added by SNS to fix integer overflow
                #	puts "position 1: totamt = $totamt"
                set rec(batch_amt)  $totamt
                set rec(batch_cnt) $totcnt
                write_bt_record $fileid rec
                set chkmidt $a(MID)
                set totcnt 0
                set totamt 0
                #	set trlcnt 1
            }

            set rec(batch_curr) "840"

            #set rec(batch_curr) "$curr_cd($a(MID))"
            set rec(activity_date_time_bh) $batchtime
            if { $cnt_type == "DISC_DATA" || $cnt_type == "FANF"} {
                set rec(merchantid) "$a(MID)"
            } else {
                set rec(merchantid) "$entity_id($a(MID))"
            }
            set rec(inbatchnbr) [pbchnum]
            set rec(infilenbr)  1
            set rec(batch_capture_dt) $batchtime
            set rec(sender_id) $a(MID)

            write_bh_record $fileid rec

            set chkmid $a(MID)
        }

        ###### Writing Massage Detail records
        set tid_idntfr "" ; #<tid_idntfr> can be needed for multiple tid option""
        if {$cnt_type != "ACH"} {
            set mas_tid [get_tid $cnt_type $tid_idntfr]
            set rec(trans_id) $mas_tid
        } else {
            get_tid $cnt_type $tid_idntfr
            set rec(trans_id) $mas_tid($a(REQUEST_TYPE))
        }

        if { $cnt_type == "DISC_DATA" || $cnt_type == "FANF" } {
            set rec(entity_id) $a(MID)
        } else {
            set rec(entity_id) $entity_id($a(MID))
        }
        if { $cnt_type == "FANF" && $a(MAS_CODE) == "FANF_2"} {
            set a(CNT) 1
        }

        #A switch to convert card types----------------

        set rec(nbr_of_items) $a(CNT)
        set rec(amt_original) [expr wide(round([expr $a(AMT) * 100]))]

        write_md_record $fileid rec

        set totcnt [expr $totcnt + $a(CNT)]
        set totamt [expr $totamt + $rec(amt_original)]

        set ftotcnt [expr $ftotcnt + $a(CNT)]
        set ftotamt [expr $ftotamt + $rec(amt_original)]

        MASCLR::log_message "a(MID): $a(MID), cnt_type: $cnt_type, a(CNT): $a(CNT) " 3
        if { $cnt_type == "FANF" && $a(MAS_CODE) != "FANF_2"} {
            MASCLR::log_message "a(MAS_CODE): $a(MAS_CODE), a(CP_VOL_PCT): $a(CP_VOL_PCT) " 3
            if { $a(CP_VOL_PCT) < 90 } {
                set rec(mas_code) "FANF_2"
                set a(CNT) 1
                set rec(nbr_of_items) $a(CNT)
                MASCLR::log_message "a(MID): $a(MID), cnt_type: $cnt_type, rec(mas_code): $rec(mas_code) " 3
                write_md_record $fileid rec

                set totcnt [expr $totcnt + $a(CNT)]
                set totamt [expr $totamt + $rec(amt_original)]

                set ftotcnt [expr $ftotcnt + $a(CNT)]
                set ftotamt [expr $ftotamt + $rec(amt_original)]

            }
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

