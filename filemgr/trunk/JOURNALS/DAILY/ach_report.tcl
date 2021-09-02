#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: ach_report.tcl 4354 2017-09-22 16:45:00Z bjones $
# $Rev: 4354 $
################################################################################
#
#    File Name   -   ach_report.tcl
#
#    Description -   This program generates ACH statements by institution.
#
#    Arguments   -i  institution id
#                -f  config file
#                -c  cycle mode, Default 1.  Optional.
#                -d  Date to run the report, optional  e.g. 20140521
#                    This scripts can run with or without a date. If no date
#                    provided it will use sysdate to run the report.
#                    With a date argument, the script will run the report for a
#                    given date.
#                -a  All times mode.  Optional.
#                -s  Toggle summmary mode. Default on. Optional.
#                -t  Test mode.  Optional.
#                -v  Verbose mode. Increases debug level each usage.
#                -g  Generate transaction based on the settl_date. Optional
#
#    Output          ACH statements by institution.
#                    Using a date will deterimine which day to run for. Default is today.
#                    Cycle will run just the ach report for that cycle.
#                    All times mode will build a report for each time that an ach was run on this date.
#                    Summary mode on will have one line per merchant.  Summary mode off will be one
#                      line per payment_seq_nbr in acct_accum_det.
#                    Test mode will send the reports just to the user running the script.
#
#    Usage       -   ach_report.tcl -I nnn ... \[-D yyyymmdd\]...
#
#                    e.g.   ach_report.tcl -i 101
#                           ach_report.tcl -i 101 -d 20120421
#                           ach_report.tcl -i 101 -c 2 -d 20120421
#                           ach_report.tcl -i 107 -d 20191203 -c 5 -g 20191130
#
################################################################################

source $env(MASCLR_LIB)/masclr_tcl_lib

lappend auto_path $env(MASCLR_LIB)
package require GetOpts

package require Oratcl

set cfg_file_name ach_report.cfg

################################################################################
proc readCfgFile {} {
    global clr_db_logon
    global clr_db cfg_file_name
    global argv mail_to mail_err

    set clr_db_logon ""
    set clr_db ""

    if {[catch {open $cfg_file_name r} file_ptr]} {
            puts " *** File Open Err: Cannot open config file $cfg_file_name"
            exit 1
    }

    while { [set line [gets $file_ptr]] != {}} {
        set line_parms [split $line ~]
        switch -exact -- [lindex  $line_parms 0] {
            "CLR_DB_LOGON" {
                set clr_db_logon [lindex $line_parms 1]
            }
            "CLR_DB" {
                set clr_db [lindex $line_parms 1]
            }
            "MAIL_ERR" {
                set mail_err [lindex $line_parms 1]
            }
            "MAIL_TO" {
                set mail_to [lindex $line_parms 1]
                puts " mail_to: $mail_to"
            }
            default {
                puts "Unknown config parameter [lindex $line_parms 0]"
            }
        }
    }
    close $file_ptr

    if {$clr_db_logon == ""} {
        puts "Unable to find CLR_DB_LOGON params in $cfg_file_name, exiting..."
        exit 2
    }
}

##########################################
# connect_to_db
# handles connections to the database
##########################################

proc connect_to_db {} {
    global clr_logon_handle
    global clr_db_logon
    global clr_db

    if {[catch {set clr_logon_handle [oralogon $clr_db_logon@$clr_db]} result] } {
        puts "Encountered error $result while trying to connect to CLR_DB"
        exit 1
    } else {
        puts " Connected to clr_db"
    }
}

proc usage {} {
    global argv0
    set programName $argv0
    puts stderr "Usage: $programName -i institution_id \[-d yyyymmdd\] "
    puts stderr "       where -i is an Institution_Id (Eg: 101, 105, 107 ... etc.)"
    puts stderr "             -d is a date in YYYYMMDD format (Eg: 20160919 - September 19 2016)"
    puts stderr "Argument: -i  institution id"
    puts stderr "          -f  config file (defaults to ach_report.cfg)"
    puts stderr "          -c  cycle mode, default 1.  Optional."
    puts stderr "          -d  Date to run the report, optional  e.g. 20140521"
    puts stderr "              This scripts can run with or without a date. If no date"
    puts stderr "              provided it will use sysdate to run the report."
    puts stderr "              With a date argument, the script will run the report for a"
    puts stderr "              given date."
    puts stderr "          -a  All times mode.  Optional."
    puts stderr "          -s  Toggle summmary mode. Default on. Optional."
    puts stderr "          -t  Test mode.  Optional."
    puts stderr "          -v  Verbose mode. Increases debug level each usage."
    puts stderr "          -g  Generate transaction based on the settl_date."
    puts stderr "          -m  Generates eom report based on last day of previous month."
    puts stderr "              If script is run with this only the mandatory args and this flag,"
    puts stderr "              (e.g. $programName -i 101 -m) then script will use sysdate for date"  
    puts stderr "              and settle date will be the last day of the previous month. "
    puts stderr ""
    puts stderr "Example:  $programName -i101 -d 20160919"
    puts stderr "          $programName -i 101 -c 2 -d 20120421"
    exit 1

}

proc arg_parse {} {
    global argv sql_inst date_arg mode cycle time_mode
    global summ_mode cfg_file_name settl_date_flag settl_date month_end_flag

    set summ_mode "Y"
    set time_mode "N"
    set cycle 1
    set settl_date_flag "N"
    set settl_date ""
    set month_end_flag "N"

    while { [ set err [ getopt $argv "ac:d:f:hi:g:mstv" opt optarg ]] } {
        if { $err < 0 } then {
            MASCLR::log_message "error: $argv0 : opt $opt, optarg: $optarg "
            usage
            exit 1
        } else {
            MASCLR::log_message "opt: $opt, optarg: $optarg" 1
            switch -exact $opt {
                a {set time_mode "Y"}
                c {set cycle $optarg}
                d {set date_arg $optarg}
                f {set cfg_file_name $optarg}
                i {set sql_inst $optarg}
                g {
                    set settl_date_flag "Y"
                    set settl_date $optarg
                  }
                m {set month_end_flag "Y"}
                s {set summ_mode "N"}
                t {set mode "TEST"}
                v {incr MASCLR::DEBUG_LEVEL 1}
                h {
                    usage
                    exit 1
                }
            }
        }
    }

    if {![info exists sql_inst]} {
        puts "Institution ID needs to be passed."
        usage
        exit 1
    }
    #set default values for month end flag. 
    if {$month_end_flag == "Y"} {
        # if no date set, then set the date as the current day and last day of previous month is used as settle date
        if {![info exists date_arg] && $settl_date_flag == "N"} {
            set systime [clock seconds]
            set month [clock format $systime -format %m] 
            set year [clock format $systime -format %Y] 
            
            if { $month == 1} {
                set eom_month 12
                set eom_year  [$year - 1]
            } else {
                set eom_month [expr $month-1]
                set eom_year $year
            } 
            
            set eom_day  [clock format [clock add [clock scan "$eom_month-01-$eom_year" -format %m-%d-%Y]  1 month -1 day] -format %d]
            
            set eom_month [format %02s $eom_month]
            set settl_date $eom_year$eom_month$eom_day
            set date_arg [clock format $systime -format %Y%m%d] 
            set settl_date_flag "Y" 
        }
    }
}

proc last_day {month year} {
   clock format [clock scan "$month/1/$year + 1 month - 1 day"] -format %d
   }
proc init_dates {dt} {
    global curdate requested_date today tommorrow date_stamp filedate

    set curdate          [clock format [clock seconds] -format %b-%d-%Y]
    set requested_date   [clock format [clock scan "$dt"] -format %b-%d-%Y]
    set filedate         [clock format [clock scan " $dt -0 day"] -format %Y%m%d]              ;# 20080321

    set today      [string toupper [clock format [clock scan "$dt -0 day"] -format %d-%b-%Y]]  ;# 12-FEB-2015
    set tommorrow  [string toupper [clock format [clock scan "$dt +1 day"] -format %d-%b-%Y]]  ;# 13-FEB-2015
    set date_stamp [string toupper [clock format [clock scan "$dt -0 day"] -format %d-%b-%Y]]  ;# 12-FEB-2015

    puts " Generated Date:  $curdate"
    puts " Requested Date:  $requested_date"
    puts " Start date:      >= $today "
    puts " End date:         < $tommorrow "
}

proc do_report {} {

    global ach_cursor1 ach_cursor2 today tommorrow sql_inst
    global mode env cycle date_stamp time_mode summ_mode

    if { $time_mode == "Y" } {

        set query_string_times "
            select unique to_char(payment_proc_dt, 'HH24MISS') payment_time
            from  ACCT_ACCUM_DET
            where PAYMENT_PROC_DT >= '$today'
              and PAYMENT_PROC_DT < '$tommorrow'
              and institution_id  = '$sql_inst'
              and payment_status  = 'P'
              and entity_acct_id not in (
                select entity_acct_id
                from  entity_acct
                where institution_id = '$sql_inst'
                  and stop_pay_flag = 'Y')"

        MASCLR::log_message  "query_string_times:\n\n$query_string_times\n\n" 3

        orasql $ach_cursor2 $query_string_times

#       puts $query_string_times

        while {[orafetch $ach_cursor2 -dataarray times -indexbyname] != 1403} {
                set pmt_time $times(PAYMENT_TIME)
                ach_report $pmt_time
        }
    } else {
        ach_report {}
    }
}

proc ach_report {time_stamp} {
    global ach_cursor1 ach_cursor2 today tommorrow file_name sql_inst requested_date
    global mode env cycle date_stamp time_mode summ_mode filedate curdate
    global cur_file mail_to settl_date_flag settl_date month_end_flag

    set    log_msg "ach_single_report"
    append log_msg " {inst=$sql_inst cycle=$cycle time_stamp=$time_stamp}"

    MASCLR::log_message  log_msg 2

    set old_date_stamp $date_stamp

    if { $cycle != 1 } {
        set cycle_name ".$cycle"
        set cycle_clause "and payment_cycle = '$cycle'"
    } else {
        set cycle_name ""
        set cycle_clause "and payment_cycle = '$cycle'"
    }

    if {$time_stamp != "" } {
        append date_stamp "-$time_stamp"
        set date_clause  "aad.payment_proc_dt = to_date('$date_stamp', 'DD-MM-YYYY-HH24MISS')"
        set cycle_clause ""
    } else {
        set date_clause "aad.payment_proc_dt >= '$today' and aad.payment_proc_dt < '$tommorrow'"
    }

    if {$settl_date_flag == "Y"} {
        set settl_date_name "-$settl_date"
    } else {
        set settl_date_name ""
    }

    if {$summ_mode !="Y"} {
        set summ_name ".dtl"
        set summ_clause ""
        set select_prefix ""
        set select_suffix ""
    } else {
        set summ_name ""
        set summ_clause ""
        set select_prefix "
            select
                    \"ENTITY_ID\"         ,
                    \"PARENT_ENTITY_ID\"  ,
                    \"ENTITY_DBA_NAME\"   ,
                    --\"ACTUAL_START_DATE\" ,
                    --\"PAYMENT_SEQ_NBR\"   ,

                    sum(\"PAYMENT_AMT\"      )  \"PAYMENT_AMT\"       ,
                    sum(\"AMT_PAY\"          )  \"AMT_PAY\"           ,
                    sum(\"AMT_FEE\"          )  \"AMT_FEE\"           ,
                    sum(\"AAD_AMT\"          )  \"AAD_AMT\"           ,

                    sum(\"OLD_TOTAL_BC\"     )  \"OLD_TOTAL_BC\"      ,
                    sum(\"OLD_SETTLED_BC\"   )  \"OLD_SETTLED_BC\"    ,
                    sum(\"OLD_SETTLED_NONBC\")  \"OLD_SETTLED_NONBC\" ,
                    sum(\"OLD_REFUNDS\"      )  \"OLD_REFUNDS\"       ,
                    sum(\"OLD_RESERVES\"     )  \"OLD_RESERVES\"      ,
                    sum(\"OLD_CHARGEBACK\"   )  \"OLD_CHARGEBACK\"    ,
                    sum(\"OLD_REPR\"         )  \"OLD_REPR\"          ,
                    sum(\"OLD_DISCOUNT\"     )  \"OLD_DISCOUNT\"      ,
                    sum(\"OLD_MISC_ADJS\"    )  \"OLD_MISC_ADJS\"     ,
                    sum(\"OLD_ACH_RESUB\"    )  \"OLD_ACH_RESUB\"     ,
                    sum(\"OLD_OTHER\"        )  \"OLD_OTHER\"         ,

                    sum(\"TOTAL_BC\"         )  \"TOTAL_BC\"          ,
                    sum(\"SETTLED_BC\"       )  \"SETTLED_BC\"        ,
                    sum(\"SETTLED_NONBC\"    )  \"SETTLED_NONBC\"     ,
                    sum(\"REFUNDS\"          )  \"REFUNDS\"           ,
                    sum(\"RESERVES\"         )  \"RESERVES\"          ,
                    sum(\"CHARGEBACK\"       )  \"CHARGEBACK\"        ,
                    sum(\"REPR\"             )  \"REPR\"              ,
                    sum(\"DISCOUNT\"         )  \"DISCOUNT\"          ,
                    sum(\"MISC_ADJS\"        )  \"MISC_ADJS\"         ,
                    sum(\"ACH_RESUB\"        )  \"ACH_RESUB\"         ,
                    sum(\"OTHER\"            )  \"OTHER\"

            from (
        "
        set select_suffix "
            )
            group by
                    \"ENTITY_ID\"         ,
                    \"PARENT_ENTITY_ID\"  ,
                    \"ENTITY_DBA_NAME\"
        "
    }

    if { $settl_date_flag != "Y" } {
        set settl_date_clause ""
    } else {
        set st_date [clock format [clock scan $settl_date -format %Y%m%d ] -format %d-%m-%Y]
        set settl_date_clause " and trunc(aad.settl_date) = to_date('$st_date', 'DD-MM-YYYY')"
        MASCLR::log_message  "st_date : $st_date settl_date_clause: $settl_date_clause" 3
    }

    if {$mode == "TEST"} {
        if {$month_end_flag == "Y" } {
            set file_name  "$sql_inst.Ach_Report_eom.$filedate$settl_date_name$summ_name.TEST.csv"
        } else {
            set file_name     "$sql_inst.Ach_Report.$filedate$settl_date_name$cycle_name$summ_name.TEST.csv"
        }
    } elseif {$mode == "PROD"} {
        if { $cycle == 5 } {
            set file_name  "$sql_inst.Ach_Report_nxdy.$filedate$settl_date_name$summ_name.csv"
        } elseif { $cycle != 1 } {
            set file_name  "$sql_inst.Ach_Report_cycle.$cycle.$filedate$settl_date_name$summ_name.csv"
        } elseif { $month_end_flag == "Y"} {
            set file_name  "$sql_inst.Ach_Report_eom.$filedate$settl_date_name$summ_name.csv"
        } else {
            set file_name  "$sql_inst.Ach_Report.$filedate$settl_date_name$summ_name.csv"
        }
    }

    set cur_file  [open "$file_name" w]

    set date_stamp $old_date_stamp

    set columns    "   Institution:, $sql_inst \n "
    append columns "  Date Generated:,$curdate \n "
    append columns "  Requested Date:,$requested_date"
    if { $settl_date_flag == "Y" } {
        append columns ",Settle date,$settl_date"
    }
    append columns "\n\n"

    append columns "ISO#,Merchant ID,Merchant Name,Settle Bankcards,Settle NonBankcards,"
    append columns "Chargeback Amount,Representment,Refunds,Misc Adj,ACH Resub,"
    append columns "Reserves,Fees,Net Deposit,,Detail Check,Diff\r"

    puts $cur_file $columns

    set SETTLED_BC           0
    set SETTLED_NONBC        0
    set CHGBCK_AMT           0
    set REPR_AMOUNT          0
    set REFUNDS              0
    set MISC_ADJS            0
    set ACH_RESUB            0
    set RESERVES             0
    set DISCOUNT             0
    set NETDEPOSIT           0

    set CALCULATED_NET       0
    set REP_DISCREPANCY      0
    set GRND_CALCULATED_NET  0
    set GRND_REP_DISCREPANCY 0

    set GRAND_SETTLED_BC     0
    set GRAND_SETTLED_NONBC  0
    set GRAND_CHGBCK_AMT     0
    set GRAND_REPR_AMOUNT    0
    set GRAND_REFUNDS        0
    set GRAND_MISC_ADJS      0
    set GRAND_ACH_RESUB      0
    set GRAND_RESERVES       0
    set GRAND_DISCOUNT       0
    set GRAND_NETDEPOSIT     0
    set GRAND_OTHER          0

    set query_string "
        $select_prefix

        select distinct
            mtl.posting_entity_id                               as ENTITY_ID,
            acq.parent_entity_id                                as PARENT_ENTITY_ID,
            replace(acq.entity_dba_name, ', ', '')              as ENTITY_DBA_NAME,
            acq.actual_start_date                               as ACTUAL_START_DATE,
            aad.actual_payment_seq                              as PAYMENT_SEQ_NBR,
            pl.payment_amt                                      as payment_amt,
            sum(distinct aad.amt_pay)                           as amt_pay,
            sum(distinct aad.amt_fee)                           as amt_fee,
            sum(distinct aad.amt_pay) -
                sum(distinct aad.amt_fee)                       as aad_amt,
            -- previous columns
            nvl(sum(mtl.amount), 0)                             as old_TOTAL_BC,
            nvl(sum(case when mtl.major_cat = 'SALES'
                    and mtl.card_scheme in ('04', '05', '08')
                    and aad.orig_settl_date = '01-JAN-1980'
                then mtl.amount end), 0)                        as old_SETTLED_BC,
            nvl(sum(case when mtl.major_cat = 'SALES'
                    and mtl.card_scheme not in ('04', '05', '08')
                    and aad.orig_settl_date = '01-JAN-1980'
                then mtl.amount end), 0)                        as old_SETTLED_NONBC,
            nvl(sum(case when mtl.major_cat ='REFUNDS'
                    and aad.orig_settl_date = '01-JAN-1980'
                then mtl.amount end), 0)                        as old_REFUNDS,
            nvl(sum(case when mtl.major_cat = 'RESERVE'
                    and aad.orig_settl_date = '01-JAN-1980'
                then mtl.amount end), 0)                        as old_RESERVES,
            nvl(sum(case when mtl.minor_cat ='CHARGEBACK'
                    and aad.orig_settl_date = '01-JAN-1980'
                then mtl.amount end), 0)                        as old_CHARGEBACK,
            nvl(sum(case when mtl.minor_cat in (
                    'REPRESENTMENT', 'ARBITRATION')
                    and aad.orig_settl_date = '01-JAN-1980'
                then mtl.amount end), 0)                        as old_REPR,
            nvl(sum(case when mtl.major_cat in ('FEES')
                    and aad.orig_settl_date = '01-JAN-1980'
                then mtl.amount end), 0)                        as old_DISCOUNT,
            nvl(sum(case when mtl.major_cat in (
                    'ADJUSTMENT', 'SPLIT_FUNDING')
                    and aad.orig_settl_date = '01-JAN-1980'
                then mtl.amount end), 0)                        as old_MISC_ADJS,
            nvl(sum(case when
                    aad.orig_settl_date != '01-JAN-1980'
                or mtl.major_cat = 'ACH_REBUBMIT'
                then mtl.amount end), 0)                        as old_ACH_RESUB,
            nvl(sum(case when ((
                        mtl.major_cat not in (
                            'SALES', 'REFUNDS', 'RESERVE',
                            'FEES', 'ADJUSTMENT',
                            'SPLIT_FUNDING', 'ACH_RESUBMIT')
                        or mtl.major_cat is null)
                    and  mtl.minor_cat not in (
                        'CHARGEBACK', 'REPRESENTMENT',
                        'ARBITRATION'))
                and aad.orig_settl_date = '01-JAN-1980'
                then mtl.amount end), 0)                        as old_OTHER,

            -- new columns
            round(nvl(sum(mtl.amount), 0), 2)                   as TOTAL_BC,
            round(nvl(sum(case when mtl.major_cat = 'SALES'
                    and mtl.card_scheme in ('04', '05', '08')
                    and aad.orig_settl_date = '01-JAN-1980'
                then mtl.amount end), 0), 2)                    as SETTLED_BC,
            round(nvl(sum(case when mtl.major_cat = 'SALES'
                    and mtl.card_scheme not in ('04', '05', '08')
                    and aad.orig_settl_date = '01-JAN-1980'
                then mtl.amount end), 0), 2)                    as SETTLED_NONBC,
            round(nvl(sum(case when mtl.major_cat ='REFUNDS'
                    and aad.orig_settl_date = '01-JAN-1980'
                then mtl.amount end), 0), 2)                    as REFUNDS,
            round(nvl(sum(case when mtl.major_cat = 'RESERVE'
                    and aad.orig_settl_date = '01-JAN-1980'
                then mtl.amount end), 0), 2)                    as RESERVES,
            round(nvl(sum(case when mtl.minor_cat ='CHARGEBACK'
                    and aad.orig_settl_date = '01-JAN-1980'
                then mtl.amount end), 0), 2)                    as CHARGEBACK,
            round(nvl(sum(case when mtl.minor_cat in (
                    'REPRESENTMENT', 'ARBITRATION')
                    and aad.orig_settl_date = '01-JAN-1980'
                then mtl.amount end), 0), 2)                    as REPR,
            round(nvl(sum(case when mtl.major_cat in ('FEES')
                    and aad.orig_settl_date = '01-JAN-1980'
                then mtl.amount end), 0), 2)                    as DISCOUNT,
            round(nvl(sum(case when mtl.major_cat in (
                    'ADJUSTMENT', 'SPLIT_FUNDING')
                    and aad.orig_settl_date = '01-JAN-1980'
                then mtl.amount end), 0), 2)                    as MISC_ADJS,
            round(nvl(sum(case when
                    aad.orig_settl_date != '01-JAN-1980'
                or mtl.major_cat = 'ACH_REBUBMIT'
                then mtl.amount end), 0), 2)                    as ACH_RESUB,
            round(nvl(sum(case when ((
                        mtl.major_cat not in (
                            'SALES', 'REFUNDS', 'RESERVE',
                            'FEES', 'ADJUSTMENT',
                            'SPLIT_FUNDING', 'ACH_RESUBMIT')
                        or mtl.major_cat is null)
                    and  mtl.minor_cat not in (
                        'CHARGEBACK', 'REPRESENTMENT',
                        'ARBITRATION'))
                and aad.orig_settl_date = '01-JAN-1980'
                then mtl.amount end), 0), 2)                    as OTHER

            --, mtl.major_cat
            --, mtl.minor_cat
        from  mas_trans_view mtl
        join acq_entity acq
        on  acq.entity_id = mtl.posting_entity_id
        and acq.institution_id = mtl.institution_id
        join acct_accum_det aad
        on aad.institution_id = mtl.institution_id
        and mtl.payment_seq_nbr = aad.payment_seq_nbr
        join payment_log pl
        on pl.institution_id = aad.institution_id
        and pl.payment_seq_nbr = aad.actual_payment_seq
        where
            $date_clause
        and mtl.institution_id = '$sql_inst'
        $cycle_clause
        and aad.payment_status = 'P'
        $settl_date_clause
        group by
            mtl.posting_entity_id, acq.parent_entity_id, acq.entity_dba_name,
            acq.actual_start_date
            --, aad.payment_seq_nbr
            , aad.actual_payment_seq
            , pl.payment_amt

        $select_suffix

        order by 1, 2, 3

    "

    MASCLR::log_message  "query_string:\n\n$query_string\n;\n\n" 3

    orasql $ach_cursor1 $query_string

    while {[orafetch $ach_cursor1 -dataarray t -indexbyname] != 1403} {
        set ISO                   $t(PARENT_ENTITY_ID)
        set NAME                  $t(ENTITY_DBA_NAME)
        ## set CONTRACT_DATE      $t(ACTUAL_START_DATE)
        set ENTITY_ID             $t(ENTITY_ID)
        set SETTLED_BC            $t(SETTLED_BC)
        set NETDEPOSIT            $t(TOTAL_BC)
        set RESERVES              $t(RESERVES)
        set CHGBCK_AMT            $t(CHARGEBACK)
        set REPR_AMOUNT           $t(REPR)
        set REFUNDS               $t(REFUNDS)
        set SETTLED_NONBC         $t(SETTLED_NONBC)
        set MISC_ADJS             $t(MISC_ADJS)
        set DISCOUNT              $t(DISCOUNT)
        set ACH_RESUB             $t(ACH_RESUB)
        set OTHER                 $t(OTHER)
        set GRAND_SETTLED_BC    [ expr $GRAND_SETTLED_BC    + $SETTLED_BC]
        set GRAND_NETDEPOSIT    [ expr $GRAND_NETDEPOSIT    + $NETDEPOSIT]
        set GRAND_RESERVES      [ expr $GRAND_RESERVES      + $RESERVES]
        set GRAND_CHGBCK_AMT    [ expr $GRAND_CHGBCK_AMT    + $CHGBCK_AMT]
        set GRAND_REPR_AMOUNT   [ expr $GRAND_REPR_AMOUNT   + $REPR_AMOUNT]
        set GRAND_REFUNDS       [ expr $GRAND_REFUNDS       + $REFUNDS]
        set GRAND_SETTLED_NONBC [ expr $GRAND_SETTLED_NONBC + $SETTLED_NONBC]
        set GRAND_MISC_ADJS     [ expr $GRAND_MISC_ADJS     + $MISC_ADJS]
        set GRAND_DISCOUNT      [ expr $GRAND_DISCOUNT      + $DISCOUNT]
        set GRAND_ACH_RESUB     [ expr $GRAND_ACH_RESUB     + $ACH_RESUB]
        set GRAND_OTHER         [ expr $GRAND_OTHER         + $OTHER    ]

        set CALCULATED_NET  [expr $SETTLED_BC  + $SETTLED_NONBC + $CHGBCK_AMT + \
                                  $REPR_AMOUNT + $REFUNDS       + $MISC_ADJS  + \
                                  $ACH_RESUB   + $RESERVES      + $DISCOUNT]

        set REP_DISCREPANCY [expr $NETDEPOSIT  - $CALCULATED_NET]
        set REP_DISCREPANCY [expr round($REP_DISCREPANCY * 100) / 100]

        set GRND_CALCULATED_NET  [expr $GRND_CALCULATED_NET   + $CALCULATED_NET]

        set GRND_REP_DISCREPANCY [expr $GRND_REP_DISCREPANCY  + $REP_DISCREPANCY]

        if {$SETTLED_BC     == 0 && $SETTLED_NONBC  == 0 && $CHGBCK_AMT     == 0 && \
            $REPR_AMOUNT    == 0 && $REFUNDS        == 0 && $MISC_ADJS      == 0 && \
            $ACH_RESUB      == 0 && $RESERVES       == 0 && $DISCOUNT       == 0 && \
            $NETDEPOSIT     == 0} {
            puts "skipping merchant - columns zero, $t(ENTITY_ID)"
        } else {
            set output "$ISO,$t(ENTITY_ID),$NAME,[format "%0.2f" $SETTLED_BC],[format "%0.2f" $SETTLED_NONBC]"
            set output "$output,[format "%0.2f" $CHGBCK_AMT],[format "%0.2f" $REPR_AMOUNT]"
            set output "$output,[format "%0.2f" $REFUNDS],[format "%0.2f" $MISC_ADJS],[format "%0.2f" $ACH_RESUB]"
            set output "$output,[format "%0.2f" $RESERVES],[format "%0.2f" $DISCOUNT],[format "%0.2f" $NETDEPOSIT]"
            set output "$output,,[format "%0.2f" $CALCULATED_NET],[format "%0.2f" $REP_DISCREPANCY]\r"
            puts $cur_file $output
        }
    }
    set allout " ,,TOTAL:,[format "%0.2f" $GRAND_SETTLED_BC],[format "%0.2f" $GRAND_SETTLED_NONBC]"
    set allout "$allout,[format "%0.2f" $GRAND_CHGBCK_AMT],[format "%0.2f" $GRAND_REPR_AMOUNT]"
    set allout "$allout,[format "%0.2f" $GRAND_REFUNDS],[format "%0.2f" $GRAND_MISC_ADJS]"
    set allout "$allout,[format "%0.2f" $GRAND_ACH_RESUB],[format "%0.2f" $GRAND_RESERVES]"
    set allout "$allout,[format "%0.2f" $GRAND_DISCOUNT],[format "%0.2f" $GRAND_NETDEPOSIT]"
    set allout "$allout,,[format "%0.2f" $GRND_CALCULATED_NET],[format "%0.2f" $GRND_REP_DISCREPANCY]\r"

    puts $cur_file "$allout"

    close $cur_file

    if {$mode == "TEST"} {
        if { [catch { exec echo "Please see attached." | \
                mutt -a "$file_name" -s "$file_name" -- "$env(SCRIPT_USER)@jetpay.com" } result] != 0 } {
            if { [string range $result 0 21] == "Waiting for fcntl lock" } {
                puts "Ignore mutt file control lock $result"
            } else {
                error "mutt error message: $result"
            }
        }
    } elseif {$mode == "PROD"} {
        if { [catch { exec echo "Please see attached." | \
                mutt -a "$file_name" -s "$file_name" -- "$mail_to" } result] != 0 } {
            if { [string range $result 0 21] == "Waiting for fcntl lock" } {
                puts "Ignore mutt file control lock $result"
            } else {
                error "mutt error message: $result"
            }
        }
    }


    exec cp $file_name ../INST_$sql_inst/UPLOAD/

    exec mv $file_name ./ARCHIVE

}

#######
# MAIN
#######

#Environment variables.......

global  cycle time_mode sql_inst mail_to mail_err
global  ach_cursor1 ach_cursor2 today tomorrow file_name
global  date_stamp time_stamp summ_mode mode env

#Mode....
#set mode "TEST"
set mode "PROD"

# Verbose
set MASCLR::DEBUG_LEVEL 0

arg_parse

readCfgFile

connect_to_db

set ach_cursor1  [oraopen $clr_logon_handle]
set ach_cursor2  [oraopen $clr_logon_handle]

if {![info exists date_arg]} {
    init_dates [clock format [clock scan "-0 day"] -format %d-%b-%Y]
} else {
    init_dates [clock format [clock scan $date_arg -format %Y%m%d ] -format %d-%b-%Y]
}

do_report

oraclose $ach_cursor1

oraclose $ach_cursor2

oralogoff $clr_logon_handle
