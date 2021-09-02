#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: ach_report.tcl 2492 2014-01-07 19:04:45Z mitra $
# $Rev: 2492 $
################################################################################
#
# File Name:  ach_report.tcl
#
# Description:  This program generates ACH statements by institution.
#
# Arguments:  -i inst      = Institution ID. (e.g., 101)  Required.
#               
#             -d YYYYMMDD  = Run date (e.g., YYYYMMDD).  Optional.
#                            Defaults to current date.
#             -c cycle     = Cycle mode.  Default 1. Optional.
#             -a           = All times mode.  Optional.
#             -s           = Toggle summmary mode. Default on. Optional.
#
#             -t           = Test mode.  Optional.
#             -v           = Verbose mode. Increases debug level each usage.
#
# Output:  ACH statements by institution.
#          Using a date will deterimine which day to run for. Default is today.
#          Cycle will run just the ach report for that cycle.
#          All times mode will build a report for each time that
#               an ach was run on this date.
#          Summary mode on will have one line per merchant.  Summary mode off
#               will be one line per payment_seq_nbr in acct_accum_det. 
#          Test mode will send the reports just to the user running the scrip.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

#Environment veriables.......
global  mode env cycle_list time_mode mailfromlist mailtolist
global  ach_cursor1 ach_cursor2 report_date name_date CUR_JULIAN_DATEX
global  report_nxt_day mode env cycle_list time_mode summ_mode

source $env(MASCLR_LIB)/masclr_tcl_lib

#set box $env(SYS_BOX)
#set clrpath $env(CLR_OSITE_ROOT)
#set maspath $env(MAS_OSITE_ROOT)

#set mailtolist Reports-clearing@jetpay.com
#set mailfromlist Reports-clearing@jetpay.com

set    mailtolist "reports-clearing@jetpay.com,operations@jetpay.com"
append mailtolist ",ACH-Reports@jetpay.com"
set mailtofailure $env(MAIL_TO_FAILURE)
set mailfromlist "Reports-clearing@jetpay.com"

#set clrdb trnclr1
#set clrdb $env(CLR4_DB)
#set authdb $env(TSP4_DB)
set clrdb $env(IST_DB)


#Fail message....
set fail_msg "$argv0 failed to run"

#Mode....
#set mode "TEST"
set mode "PROD"

# Verbose
set debug_level 0
set MASCLR::DEBUG_LEVEL 0

proc arg_parse {} {
    global argv insts_arg date_arg mode debug_level cycle_list time_mode
    global summ_mode

    set summ_mode "Y"
    set time_mode "N"

    #scan for Test mode
    if { [regexp -- {(-[tT])} $argv dummy1 dummy2] } {
        puts "Test mode on"
        set mode "TEST"
    }

    #scan for Time mode
    if { [regexp -- {(-[a])} $argv dummy1 dummy2] } {
        puts "All (time) mode on"
        set time_mode "Y"
    }

    #scan for Summary mode
    if { [regexp -- {(-[s])} $argv dummy1 dummy2] } {
        if { $summ_mode == "Y"} {
            set summ_mode "N"
        } else {
            set summ_mode "Y"
        }
        puts "Summary mode toggle to: $summ_mode"
    }

    #scan for Verbose mode
    if { [regexp -- {(-[vV])} $argv dummy1 dummy2] } {
        set debug_level [regexp -all -- {(-[vV])} $argv dummy1 dummy2]
        set MASCLR::DEBUG_LEVEL debug_level
        puts "Verbose level: $MASCLR::DEBUG_LEVEL"
    }

    #scan for Date
    if { [regexp -- {(-[dD])[ ]+([0-9]{8})} $argv dummy1 dummy2 arg_date] } {
        puts "Date argument: $arg_date"
        set date_arg $arg_date
    }

    #scan for Institutions. -i 107 -i 101
    set numInst 0
    set numInst [regexp -all -- {-[iI][ ]+([0-9]{3})} $argv]

    if { $numInst > 0 } {

        set location {0 0}
        set insts_arg {}
        while {[regexp -start \
                [lindex $location 1] -indices -- {-[iI][ ]+([0-9]{3})} \
                $argv location]} {
            # puts "argv: $argv ; location $location"
            set thisarg [string range $argv [lindex $location 0] [lindex $location 1]]
            # puts "thisarg: $thisarg"
            lappend insts_arg [lindex $thisarg 1]
        }
        puts "Institutions: $insts_arg"
    }

    #default cycle
    set cycle_list {1}

    #scan for cycless. -c 1 -c 5 
    set numCycle 0
    set numCycle [regexp -all -- {-[cC][ ]+([0-9]{1})} $argv]

    if { $numCycle > 0 } {
        set location {0 0}
        set cycle_list {}
        while {[regexp -start \
                [lindex $location 1] -indices -- {-[cC][ ]+([0-9]{1})} \
                $argv location]} {
            # puts "argv: $argv ; location $location"
            set thisarg [string range $argv [lindex $location 0] [lindex $location 1]]
            # puts "thisarg: $thisarg"
            lappend cycle_list [lindex $thisarg 1]
        }

        puts "Cycles: $cycle_list"
    }

}

proc init_dates {dt} {
    global report_date name_date CUR_JULIAN_DATEX report_nxt_day cycle_list time_mode summ_mode

    set report_date      [string toupper [clock format [clock scan "$dt -0 day"] -format %d-%b-%Y]]  ;# 20-MAR-08
    set name_date        [string toupper [clock format [clock scan "$dt -0 day"] -format %d-%b-%Y]]  ;# 20-MAR-08
    set CUR_JULIAN_DATEX [string range   [clock format [clock scan "$dt" ] -format "%y%j"] 1 4]
    set report_nxt_day   [string toupper [clock format [clock scan "$dt +1 day"] -format %d-%b-%Y]]
}

package require Oratcl
if {[catch {set handler [oralogon masclr/masclr@$clrdb]} result]} {
    # append fail_msg
    puts "$fail_msg (mailx -r $mailfromlist -s $fail_msg $mailtofailure)"
    exec echo $fail_msg " \n run from [pwd] \n" | mutt -s "$fail_msg" $mailtofailure
    exit
}

set ach_cursor1          [oraopen $handler]
set ach_cursor2          [oraopen $handler]

proc ach_report { inst_num } {
    global mailfromlist mailtolist  ach_cursor1 ach_cursor2 report_date name_date
    global CUR_JULIAN_DATEX report_nxt_day mode env cycle_list time_mode summ_mode

    if { $time_mode == "Y" } {

        set query_string_times "select
                unique to_char(payment_proc_dt, 'HH24MISS') payment_time
            from ACCT_ACCUM_DET
            where PAYMENT_PROC_DT >= '$report_date'
            and   PAYMENT_PROC_DT < '$report_nxt_day'
            and   institution_id  = '$inst_num'
            and   payment_status  = 'P'
            and   entity_acct_id not in
                (select entity_acct_id
                from entity_acct
                where institution_id = '$inst_num'
                and stop_pay_flag = 'Y')"
        orasql $ach_cursor2 $query_string_times
        puts $query_string_times
        puts ""
        while {[orafetch $ach_cursor2 -dataarray times -indexbyname] != 1403} {
          set pmt_time $times(PAYMENT_TIME)
          ach_single_report $inst_num {} $pmt_time
        }
    } else {
        foreach cycle $cycle_list {
            ach_single_report $inst_num $cycle {}
        }
    }
}

proc ach_single_report { inst_num cycle time_val} {
    global mailfromlist mailtolist  ach_cursor1 ach_cursor2 report_date name_date
    global CUR_JULIAN_DATEX report_nxt_day mode env cycle_list time_mode summ_mode

    set    log_msg "ach_single_report"
    append log_msg " {inst=$inst_num cycle=$cycle time_val=$time_val}"
    MASCLR::log_message  log_msg 2
    if { $cycle != {} } {
        set cycle_name ".$cycle"
    } else {
        set cycle_name ""
    }
    set old_name_date $name_date
    if {$time_val != "" } {
        append name_date "-$time_val"
        set date_clause  "PAYMENT_PROC_DT = to_date('$name_date', 'DD-MM-YYYY-HH24MISS')"
        set cycle_clause ""
    } else {
        set date_clause "PAYMENT_PROC_DT >= '$report_date' and PAYMENT_PROC_DT < '$report_nxt_day'"
        set cycle_clause "and payment_cycle in ($cycle)"
    }

    puts "Summary mode: $summ_mode"
    if {$summ_mode !="Y"} {
        set summ_clause ", PAYMENT_SEQ_NBR"
    } else {
        set summ_clause ""
    }

    if {$mode == "TEST"} {
        set cur_file_name "$inst_num.REPORT.ACH.$CUR_JULIAN_DATEX.$name_date$cycle_name.TEST.csv"
        set file_name     "$inst_num.REPORT.ACH.$CUR_JULIAN_DATEX.$name_date$cycle_name.TEST.csv"
    } elseif {$mode == "PROD"} {
        set cur_file_name "./INST_$inst_num/UPLOAD/$inst_num.REPORT.ACH.$CUR_JULIAN_DATEX.$name_date$cycle_name.001.csv"
        set file_name                                    "$inst_num.REPORT.ACH.$CUR_JULIAN_DATEX.$name_date$cycle_name.001.csv"
    }
    set cur_file         [open "$cur_file_name" w]
    set name_date $old_name_date

    puts $cur_file "ACH REPORT,$inst_num"
    puts $cur_file "DATE:,$report_date\n"
    set    columns "ISO#,Merchant ID,Merchant Name,Settle Bankcards,Settle NonBankcards,"
    append columns "Chargeback Amount,Representment,Refunds,Misc Adj.,ACH Resub.,"
    append columns "Reserves,Fees,Net Deposit,,Detail Check,Difference\r\n"
    puts $cur_file $columns

    set SETTLED_BC 0
    set SETTLED_NONBC 0
    set CHGBCK_AMT 0
    set REPR_AMOUNT 0
    set REFUNDS 0
    set MISC_ADJS 0
    set ACH_RESUB 0
    set RESERVES 0
    set DISCOUNT 0
    set NETDEPOSIT 0

    set CALCULATED_NET 0
    set REP_DISCREPANCY 0
    set GRND_CALCULATED_NET 0
    set GRND_REP_DISCREPANCY 0

    set GRAND_SETTLED_BC 0
    set GRAND_SETTLED_NONBC 0
    set GRAND_CHGBCK_AMT 0
    set GRAND_REPR_AMOUNT 0
    set GRAND_REFUNDS 0
    set GRAND_MISC_ADJS 0
    set GRAND_ACH_RESUB 0
    set GRAND_RESERVES 0
    set GRAND_DISCOUNT 0
    set GRAND_NETDEPOSIT 0

    set IS_SALES "mtl.tid in (
                '010003005101', '010123005101', '010123005102', '010003005201',
                '010003005202', '010003005104', '010003005204',
                '010003005141', '010003005142', '010003005143', '010003005144',
                '010003005103', '010003005203')"
    set IS_CHGBK "mtl.tid in (
                '010003015101', '010003015102', '010003015201', '010003015210',
                '010003015301')"
    set IS_REPR  "mtl.tid in ('010003005301', '010003005401', '010003010102',
                '010003010101')"
    set IS_FEE "(substr(mtl.tid, 1,8) = '01000507'
                OR substr(mtl.tid, 1,6) in
                    ('010004','010040','010050','010080','010014'))"

    set query_string " select
        unique mtl.posting_entity_id as ENTITY_ID,
        acq.parent_entity_id as PARENT_ENTITY_ID,
        replace(acq.entity_dba_name, ',', '') as ENTITY_DBA_NAME,
        acq.actual_start_date as ACTUAL_START_DATE $summ_clause,
        sum(case when(mtl.tid_settl_method =  'C' and mtl.CARD_SCHEME <> '12')
                 then mtl.amt_original else 0 end) as TOTAL_C_BC,
        sum(case when(mtl.tid_settl_method <> 'C' and mtl.CARD_SCHEME <> '12')
                 then mtl.amt_original else 0 end) as TOTAL_D_BC,
        sum(case when(mtl.tid_settl_method =  'C' AND mtl.CARD_SCHEME in ('04','05','08') AND $IS_SALES)
                 then mtl.amt_original else 0 end) as SETTLED_C_BC,
        sum(case when(mtl.tid_settl_method <> 'C' AND mtl.CARD_SCHEME in ('04','05','08') AND $IS_SALES)
                 then mtl.amt_original else 0 end) as SETTLED_D_BC,
        sum(case when(mtl.tid_settl_method =  'C' AND (substr(mtl.tid,1,8) in ('01000505','01000705')))
                 then mtl.amt_original else 0 end) as RESERVES_C,
        sum(case when(mtl.tid_settl_method <> 'C' AND (substr(mtl.tid,1,8) in ('01000505','01000705')))
                 then mtl.amt_original * -1 else 0 end) as RESERVES_D,
        sum(case when(mtl.tid_settl_method =  'C' AND $IS_CHGBK)
                 then mtl.amt_original else 0 end) as CHARGEBACK_C,
        sum(case when(mtl.tid_settl_method <> 'C' AND $IS_CHGBK)
                 then mtl.amt_original else 0 end) as CHARGEBACK_D,
        sum(case when(mtl.tid_settl_method =  'C' AND $IS_REPR)
                 then mtl.amt_original else 0 end) as REPR_C,
        sum(case when(mtl.tid_settl_method <> 'C' AND $IS_REPR)
                 then mtl.amt_original else 0 end) as REPR_D,
        sum(case when(mtl.tid_settl_method =  'C' AND mtl.tid in ('010003005102'))
                 then mtl.amt_original else 0 end) as REFUNDS_C,
        sum(case when(mtl.tid_settl_method <> 'C' AND mtl.tid in ('010003005102'))
                 then mtl.amt_original else 0 end) as REFUNDS_D,
        sum(case when(mtl.tid_settl_method =  'C' AND $IS_SALES AND mtl.CARD_SCHEME not in ('04','05','08','12'))
                 then mtl.amt_original else 0 end) as SETTLED_NONBC_C,
        sum(case when(mtl.tid_settl_method <> 'C' AND $IS_SALES AND mtl.CARD_SCHEME not in ('04','05','08','12'))
                 then mtl.amt_original else 0 end) as SETTLED_NONBC_D,
        sum(case when(mtl.tid_settl_method = 'C'
                    AND ((substr(mtl.tid, 1,6) in ('010042','010051'))
                        or tid in ('010005090001','010007090001','010007090000','010007090002')))
                then mtl.amt_original else 0 end) as MISC_ADJS_C,
        sum(case when(mtl.tid_settl_method <> 'C'
                    AND ((substr(mtl.tid, 1,6) in ('010042','010051'))
                        or tid in ('010005090000','010007090000','010007090001','010005090002')))
                then mtl.amt_original else 0 end) as MISC_ADJS_D,
        sum(case when(mtl.tid_settl_method = 'C'  AND $IS_FEE)
                 then mtl.amt_original else 0 end) as DISCOUNT_C,
        sum(case when(mtl.tid_settl_method <> 'C' AND $IS_FEE)
                 then mtl.amt_original else 0 end) as DISCOUNT_D,
        sum(case when(mtl.tid_settl_method = 'C'  AND mtl.tid in ('010007150000','010007150001'))
                 then mtl.amt_original else 0 end) as ACH_RESUB_C,
        sum(case when(mtl.tid_settl_method <> 'C' AND mtl.tid in ('010007150000','010007150001'))
                 then mtl.amt_original else 0 end) as ACH_RESUB_D
    from mas_trans_log mtl, acq_entity acq
    where mtl.posting_entity_id = acq.entity_id
        and acq.institution_id = mtl.institution_id
        and mtl.institution_id = '$inst_num'
        and mtl.SETTL_FLAG = 'Y'
        and mtl.PAYMENT_SEQ_NBR in
            (select PAYMENT_SEQ_NBR
            from ACCT_ACCUM_DET
            where $date_clause
            and institution_id = '$inst_num'
            $cycle_clause
            and payment_status = 'P'
            and entity_acct_id not in
                (select entity_acct_id
                from entity_acct
                where institution_id = '$inst_num'
                and stop_pay_flag = 'Y'))
     group by mtl.posting_entity_id, acq.parent_entity_id, acq.entity_dba_name, acq.actual_start_date $summ_clause
     order by mtl.posting_entity_id  "

    MASCLR::log_message  "query_string:\n\n$query_string\n\n" 3
    orasql $ach_cursor1 $query_string
    while {[orafetch $ach_cursor1 -dataarray t -indexbyname] != 1403} {
        set ISO $t(PARENT_ENTITY_ID)
        set NAME $t(ENTITY_DBA_NAME)
        set CONTRACT_DATE $t(ACTUAL_START_DATE)
        set ENTITY_ID $t(ENTITY_ID)
        set SETTLED_BC          [ expr $t(SETTLED_C_BC) - $t(SETTLED_D_BC)]
        set NETDEPOSIT          [ expr $t(TOTAL_C_BC) - $t(TOTAL_D_BC)]
        set RESERVES            [ expr $t(RESERVES_C) + $t(RESERVES_D)]
        set CHGBCK_AMT          [ expr $t(CHARGEBACK_C) - $t(CHARGEBACK_D) ]
        set REPR_AMOUNT         [ expr $t(REPR_C) - $t(REPR_D)]
        set REFUNDS             [ expr $t(REFUNDS_C) - $t(REFUNDS_D) ]
        set SETTLED_NONBC       [ expr $t(SETTLED_NONBC_C) - $t(SETTLED_NONBC_D) ]
        set MISC_ADJS           [ expr $t(MISC_ADJS_C) - $t(MISC_ADJS_D)]
        set DISCOUNT            [ expr $t(DISCOUNT_C) - $t(DISCOUNT_D) ]
        set ACH_RESUB           [ expr $t(ACH_RESUB_C) - $t(ACH_RESUB_D)]
        set GRAND_SETTLED_BC    [ expr $GRAND_SETTLED_BC + $SETTLED_BC ]
        set GRAND_NETDEPOSIT    [ expr $GRAND_NETDEPOSIT +  $NETDEPOSIT ]
        set GRAND_RESERVES      [ expr $GRAND_RESERVES + $RESERVES ]
        set GRAND_CHGBCK_AMT    [ expr $GRAND_CHGBCK_AMT + $CHGBCK_AMT ]
        set GRAND_REPR_AMOUNT   [ expr $GRAND_REPR_AMOUNT + $REPR_AMOUNT ]
        set GRAND_REFUNDS       [ expr $GRAND_REFUNDS + $REFUNDS ]
        set GRAND_SETTLED_NONBC [ expr $GRAND_SETTLED_NONBC + $SETTLED_NONBC ]
        set GRAND_MISC_ADJS     [ expr $GRAND_MISC_ADJS + $MISC_ADJS ]
        set GRAND_DISCOUNT      [ expr $GRAND_DISCOUNT + $DISCOUNT ]
        set GRAND_ACH_RESUB     [ expr $GRAND_ACH_RESUB + $ACH_RESUB ]

        set CALCULATED_NET [expr  \
            $SETTLED_BC + $SETTLED_NONBC + $CHGBCK_AMT + \
            $REPR_AMOUNT + $REFUNDS + $MISC_ADJS + \
            $ACH_RESUB + $RESERVES + $DISCOUNT]

        set REP_DISCREPANCY [expr $NETDEPOSIT - $CALCULATED_NET]

        set GRND_CALCULATED_NET [expr $GRND_CALCULATED_NET + $CALCULATED_NET]
        set GRND_REP_DISCREPANCY [expr $GRND_REP_DISCREPANCY + $REP_DISCREPANCY]

        if {$CHGBCK_AMT == 0 && $SETTLED_BC == 0 && $SETTLED_NONBC == 0 && \
                $REFUNDS == 0 && $MISC_ADJS == 0 && $DISCOUNT == 0 && \
                $NETDEPOSIT == 0 } {
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
        exec echo "Please see attached." | \
            mutt -a "$cur_file_name" -s "$file_name" "$env(SCRIPT_USER)@jetpay.com"
    } elseif {$mode == "PROD"} {
        exec echo "Please see attached." | \
            mutt -a "$cur_file_name" -s "$file_name" "$mailtolist"
    }
}

##
# MAIN
###

puts "mode: $mode"
set insts_arg {}
arg_parse

if {![info exists insts_arg]} {
    puts "An institution ID needs to be passed.\nUsage: $argv0 -I nnn \[-D yyyymmdd\] \[-T\]"
    exit 1
}

if {![info exists date_arg]} {
    init_dates [clock format [clock scan "-0 day"] -format %d-%b-%Y]
} else {
    init_dates [clock format [clock scan $date_arg -format %Y%m%d ] -format %d-%b-%Y]
}


#===============================================================================
puts "*** Running report(s) for: $report_date ***"
#===============================================================================

puts "mode: $mode"

puts "INSTITUTION $insts_arg "
foreach inst_id $insts_arg {
    ach_report $inst_id
}

oraclose $ach_cursor1
oraclose $ach_cursor2
oralogoff $handler

