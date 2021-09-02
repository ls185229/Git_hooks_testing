#!/usr/bin/env tclsh

################################################################################
# $Id: financial_position.tcl 4826 2019-03-11 16:57:22Z bjones $
# $Rev: 4649 $
################################################################################
#
#    File Name   -  payables_report_pl.tcl
#
#    Description -  This script generates payables or delayed funding reports
#                   by institution.
#
#    Arguments   -i  institution id
#                -f  config file
#                -d Date to run the report, optional  e.g. 20140521
#                   This scripts can run with or without a date. If no date
#                   provided it will use sysdate to run the report.
#                   With a date argument, the script will run the report for a
#                   given date.
#                -s  Toggle summmary mode. Default on. Optional.
#                -t  Test mode.  Optional.
#                -v  Verbose mode. Increases debug level each usage.
#
#    Usage       -  payables_report_pl.tcl -D yyyymmdd -F config_file.cfg
#
#                   e.g.  payables_report_pl.tcl -d 20150315 -f test.cfg
#
################################################################################

package require Oratcl
source $env(MASCLR_LIB)/masclr_tcl_lib

lappend auto_path $env(MASCLR_LIB)
package require GetOpts

package require Oratcl

set cfg_file_name [exec basename $argv0 .tcl].cfg
################################################################################

proc readCfgFile {} {
   global clr_db_logon
    global clr_db cfg_file_name
    global argv mail_to mail_err
   global clr_db
   global argv mail_to mail_err inst_list

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
         "INST_LIST" {
            set inst_list [lindex $line_parms 1]
            puts " inst_list: $inst_list"
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
    puts stderr "          -d  Date to run the report, optional  e.g. 20140521"
    puts stderr "              This scripts can run with or without a date. If no date"
    puts stderr "              provided it will use sysdate to run the report."
    puts stderr "              With a date argument, the script will run the report for a"
    puts stderr "              given date."
    puts stderr "          -s  Toggle summmary mode. Default on. Optional."
    puts stderr "          -t  Test mode.  Optional."
    puts stderr "          -v  Verbose mode. Increases debug level each usage."
    puts stderr ""
    puts stderr "Example:  $programName -i101 -d 20160919"
    puts stderr "          $programName -i 101 -c 2 -d 20120421"
    exit 1

}
proc arg_parse {} {
    global argv sql_inst date_arg mode time_mode
    global summ_mode cfg_file_name mode

    set summ_mode "Y"
    set time_mode "N"


    while { [ set err [ getopt $argv "d:f:hi:stv" opt optarg ]] } {
        if { $err < 0 } then {
            MASCLR::log_message "error: $argv0 : opt $opt, optarg: $optarg "
            usage
            exit 1
        } else {
            MASCLR::log_message "opt: $opt, optarg: $optarg" 1
            switch -exact $opt {
                d {set date_arg $optarg}
                f {set set cfg_file_name $optarg}
                i {set sql_inst $optarg}
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
}

proc init_dates {dt} {
    global curdate requested_date today tomorrow filedate date_stamp

    set curdate        [clock format   [clock seconds] -format %b-%d-%Y]
    set requested_date   [clock format [clock scan "$dt"] -format %b-%d-%Y]
    set filedate         [clock format [clock scan " $dt -0 day"] -format %Y%m%d]              ;# 20080321

    set today      [string toupper [clock format [clock scan "$dt -0 day"] -format %d-%b-%Y]]  ;# 12-FEB-2015
    set tomorrow   [string toupper [clock format [clock scan "$dt +1 day"] -format %d-%b-%Y]]  ;# 13-FEB-2015
    set date_stamp [string toupper [clock format [clock scan "$dt -0 day"] -format %d-%b-%Y]]  ;# 12-FEB-2015

    puts " Generated Date:  $curdate"
    puts " Requested Date:  $requested_date"
    puts " Start date:      >= $today "
    puts " End date:         < $tomorrow "
}

proc do_report {value} {

    global curdate requested_date today tomorrow filedate mode date_stamp
    global fetch_cursor1 fetch_cursor2 cur_file sql_inst mail_to

    set file_name     "$sql_inst.payables_report_pl.$filedate.csv"

    if {$mode == "TEST"} {
        set file_name     "$sql_inst.Ach_Report.$date_stamp.TEST.csv"
    } elseif {$mode == "PROD"} {
        set file_name  "$sql_inst.Ach_Report.$filedate.csv"
    }

    set cur_file      [open "$file_name" w]

    set columns    "  Institution:,$sql_inst\n "
    append columns "  Date Generated:,$curdate\n "
    append columns "  Requested Date:,$requested_date\n\n"

    # append columns "ISO#,Merchant ID,Merchant Name,Settle Bankcards,Settle NonBankcards,"
    # append columns "Chargeback Amount,Representment,Refunds,Misc Adj.,ACH Resub.,"
    # append columns "Reserves,Fees,Net Deposit,,Detail Check,Difference\r"

    puts $cur_file $columns

    set SETTLED_BC              0
    set SETTLED_NONBC           0
    set CHARGEBACK_AMOUNT       0
    set REJECTS                 0
    set REFUNDS                 0
    set SALE_REVERSALS          0
    set MISC_ADJUSTMENTS        0
    set ACH_RESUB               0
    set RESERVES                0
    set DISCOUNT                0
    set NETDEPOSIT              0

    set GRAND_NON_C             0
    set GRAND_NON_D             0
    set GRAND_BCC               0
    set GRAND_BCD               0
    set GRAND_SETTLED_BC        0
    set GRAND_SETTLED_NONBC     0
    set GRAND_CHARGEBACK_AMOUNT 0
    set GRAND_REJECTS           0
    set GRAND_REFUNDS           0
    set GRAND_SALE_REVERSALS    0
    set GRAND_MISC_ADJUSTMENTS  0
    set GRAND_ACH_RESUB         0
    set GRAND_RESERVES          0
    set GRAND_DISCOUNT          0
    set GRAND_NETDEPOSIT        0
    set SUB_SETTLED_BC          0
    set SUB_SETTLED_NONBC       0
    set SUB_CHARGEBACK_AMOUNT   0
    set SUB_REJECTS             0
    set SUB_REFUNDS             0
    set SUB_SALE_REVERSALS      0
    set SUB_MISC_ADJUSTMENTS    0
    set SUB_ACH_RESUB           0
    set SUB_RESERVES            0
    set SUB_DISCOUNT            0
    set SUB_NETDEPOSIT          0
    set SUB_CHARGBACK           0

    set ENTITY_ID               0
    set SETTLED_C_BC            0
    set SETTLED_D_BC            0

    set dtroll   {}
    set eroll()  {}

    puts $cur_file "  Institution:, $sql_inst"
    puts $cur_file "  Date Generated:, $curdate"
    puts $cur_file "  Requested Date:, $requested_date"
    puts $cur_file "       "
    puts $cur_file "       "

    set  header    "Settle Date,Parent Merchant ID,Merchant ID,Merchant Name,Settle Bankcards,Settle NonBankcards"
    puts $cur_file "$header,Chargeback Amount,Rejects,Refunds,Misc Adj.,ACH Resub.,Reserves,\
                    Discount( Misc. Fees),Net Deposit\r\n"

    set merinfo "
        select institution_id, entity_dba_name, parent_entity_id, entity_id
        from  acq_entity
        where institution_id in ('$sql_inst')
          and entity_level = '70'  "

    orasql $fetch_cursor1 $merinfo

    while {[orafetch $fetch_cursor1 -dataarray mer -indexbyname] != 1403} {
            set dbaname($mer(ENTITY_ID)) $mer(ENTITY_DBA_NAME)
            set peid($mer(ENTITY_ID))    $mer(PARENT_ENTITY_ID)
            set inst($mer(ENTITY_ID))    $mer(INSTITUTION_ID)
    }

    #set chabk "'010003010102', '010003010101', '010003015201', '010003015102', '010003015101', '010003015210', '010003015301'"

    set query_str_cur "
        SELECT
            m.institution_id,
            m.date_to_settle,
            m.posting_entity_id entity_id,

               SUM(
                   CASE WHEN m.tid_settl_method = 'D' then -1 else 1 end *
                   CASE WHEN ta.major_cat = 'SALES'
                         and m.card_scheme not in ('02', '03', '12')
                        THEN m.amt_billing ELSE 0 END )                   AS SETTLED_BC,
               SUM(
                   CASE WHEN m.tid_settl_method = 'D' then -1 else 1 end *
                   CASE WHEN ta.major_cat = 'SALES'
                         and m.card_scheme in ('02', '03')
                        THEN m.amt_billing ELSE 0 END )                   AS SETTLED_NBC,
               SUM(
                   CASE WHEN m.tid_settl_method = 'D' then -1 else 1 end *
                   CASE WHEN ta.major_cat = 'REFUNDS'
                        THEN m.amt_billing ELSE 0 END )                   AS REFUNDS,
               SUM(
                   CASE WHEN m.tid_settl_method = 'D' then -1 else 1 end *
                   CASE WHEN ta.major_cat = 'DISPUTES'
                        THEN m.amt_billing else 0 end )                   AS DISPUTES,
               SUM(
                   CASE WHEN m.tid_settl_method = 'D' then -1 else 1 end *
                   CASE WHEN ta.major_cat = 'DISPUTES'
                         and ta.minor_cat = 'CHARGEBACK'
                        THEN m.amt_billing else 0 end )                   AS chargebacks,
               SUM(
                   CASE WHEN m.tid_settl_method = 'D' then -1 else 1 end *
                   CASE WHEN ta.major_cat = 'DISPUTES'
                         and ta.minor_cat = 'REPRESENTMENT'
                        THEN m.amt_billing else 0 end )                   AS representments,
               SUM(
                   CASE WHEN m.tid_settl_method = 'D' then -1 else 1 end *
                   CASE WHEN ta.major_cat = 'DISPUTES'
                         and ta.minor_cat = 'ARBITRATION'
                        THEN m.amt_billing else 0 end )                   AS arbitrations,
               SUM(
                   CASE WHEN m.tid_settl_method = 'D' then -1 else 1 end *
                   CASE WHEN ta.major_cat = 'SPLIT_FUNDING'
                         and ta.minor_cat = 'PAID'
                        THEN m.amt_billing else 0 end )                   AS SPLIT_PAID,
               SUM(
                   CASE WHEN m.tid_settl_method = 'D' then -1 else 1 end *
                   CASE WHEN ta.major_cat = 'SPLIT_FUNDING'
                         and ta.minor_cat = 'HELD'
                        THEN m.amt_billing else 0 end )                   AS SPLIT_HELD,
               SUM(
                   CASE WHEN m.tid_settl_method = 'D' then -1 else 1 end *
                   CASE WHEN ta.major_cat not in (
                        'SALES', 'REFUNDS', 'DISPUTES', 'FEES', 'RESERVE', 'ADJUSTMENT', 'SPLIT_FUNDING'
                    )
                        THEN m.amt_billing else 0 end )                   AS other,
               min(m.gl_date)                                               min_gl_dt,
               max(m.gl_date)                                               max_gl_dt ,
               count(*)                                                     cnt,
               min(aad.payment_proc_dt)                                     min_pmt_dt,
               max(aad.payment_proc_dt)                                     max_pmt_dt
        FROM mas_trans_log m
        join tid_adn ta
        on ta.tid = m.tid
        join acct_accum_det aad
        on aad.INSTITUTION_ID = m.INSTITUTION_ID
        and aad.PAYMENT_SEQ_NBR = m.PAYMENT_SEQ_NBR
        WHERE m.institution_id in ('$sql_inst')
          AND (
                m.date_to_settle > to_date('$today', 'DD-MON-YYYY')
                or
                trunc(aad.PAYMENT_PROC_DT) > to_date('$today', 'DD-MON-YYYY')
                or
                aad.PAYMENT_PROC_DT = to_date('01-JAN-1980', 'DD-MON-YYYY')
              )
          AND m.gl_date < to_date('$tomorrow', 'DD-MON-YYYY')
          and m.amt_billing != 0
        GROUP BY m.institution_id, rollup(m.date_to_settle), rollup(m.posting_entity_id)
        ORDER BY m.institution_id, m.date_to_settle   "

    MASCLR::log_message "Query1: $query_str_cur" 3

    orasql $fetch_cursor2 $query_str_cur

    while {[orafetch $fetch_cursor2 -dataarray clr -indexbyname] != 1403} {
        set eid    $clr(ENTITY_ID)
        set instid $clr(INSTITUTION_ID)
        set setdt  $clr(DATE_TO_SETTLE)

        # declare institution array eg. e101()
        if {![info exists [subst e$instid] ]} {
            set "[subst e$instid]()" {}
        }

        if {![info exists [subst dt$instid]]} {
            set "[subst dt$instid]" {}
        }

        if {[string length $instid] == "3" && [string length $eid] == "15" &&
            [string length $setdt] > "1"} {

            set eeid($instid.$setdt)            $clr(ENTITY_ID)
            set enid($instid.$setdt.$eid)       $clr(ENTITY_ID)
            set refund($instid.$setdt.$eid)     $clr(REFUNDS)
            #set salerev($instid.$setdt.$eid)    $clr(SALES_REVERSAL)
            set chgbk($instid.$setdt.$eid)      $clr(DISPUTES)
            set set_c_bc($instid.$setdt.$eid)   $clr(SETTLED_BC)
            set set_c_nbc($instid.$setdt.$eid)  $clr(SETTLED_NBC)
            set netdeposit($instid.$setdt.$eid) [expr $clr(SETTLED_BC) + $clr(SETTLED_NBC) \
                                                    + $clr(REFUNDS) + $clr(DISPUTES)]
            set set_bc($instid.$setdt.$eid)     [expr $clr(SETTLED_BC) + $clr(SETTLED_NBC) \
                                                    + $clr(REFUNDS) + $clr(DISPUTES)]
            lappend "e${instid}($setdt)" $eeid($instid.$setdt)
            lappend  eroll($setdt)       $eeid($instid.$setdt)
        } elseif {[string length $instid] == "3" &&  [string length $eid] == "0" &&
            [string length $setdt] > "1"} {
            set subrefund($instid.$setdt)     $clr(REFUNDS)
            #set subsalerev($instid.$setdt)    $clr(SALES_REVERSAL)
            set subchgbk($instid.$setdt)      $clr(DISPUTES)
            set subset_c_bc($instid.$setdt)   $clr(SETTLED_BC)
            set subset_c_nbc($instid.$setdt)  $clr(SETTLED_NBC)
            set subnetdeposit($instid.$setdt) [expr $clr(SETTLED_BC) + $clr(SETTLED_NBC) \
                                                  + $clr(REFUNDS) + $clr(DISPUTES)]
            set subset_bc($instid.$setdt)     [expr $clr(SETTLED_BC) + $clr(SETTLED_NBC) \
                                                  + $clr(REFUNDS) + $clr(DISPUTES)]
            set [subst dt${instid}] "[subst $[subst dt${instid}]] $setdt"
            lappend dtroll $setdt
        } elseif {[string length $instid] == "3" && [string length $eid] == "0" &&
            [string length $setdt] == "0"} {
            set grandrefund($instid)       $clr(REFUNDS)
            #set grandsalerev($instid)     $clr(SALES_REVERSAL)
            set grandchgbk($instid)        $clr(DISPUTES)
            #set grandset_c_bc($instid)    $clr(SETTLED_C_BC)
            #set grandset_d_bc($instid)    $clr(SETTLED_D_BC)
            set grandnetdeposit($instid)   [expr $clr(SETTLED_BC) + $clr(SETTLED_NBC) \
                                                 + $clr(REFUNDS)  + $clr(DISPUTES)]
            set grandset_bc($instid)       [expr $clr(SETTLED_BC) + $clr(SETTLED_NBC) \
                                                 + $clr(REFUNDS) + $clr(DISPUTES)]
        }
    }

    foreach institution $value {
        if {![info exists [subst dt${institution}]]} {
            puts "NO DATA FOR [subst dt${institution}]].."
            puts $cur_file " "
            puts $cur_file "Total:,,,,0,0,0,0,0,0,0,0,0,0\r"
            puts $cur_file " "
            continue
        }

        set dt1 [subst "$[subst dt${institution}]"]

        if {[string length $dt1] != "0"} {
            foreach dt $dt1 {
                foreach eid [subst "$[subst e${institution}($dt)]"] {
                        if {![info exists dbaname($eid)]} {
                            set dbaname($eid)     " "
                        }
                        if {![info exists peid($eid)]} {
                            set peid($eid)     " "
                        }
                        if {![info exists enid($institution.$dt.$eid)]} {
                            set peid($eid)     " "
                        } else {
                            puts $cur_file "$dt,$peid($eid),$enid($institution.$dt.$eid),$dbaname($eid),\
                                            $set_c_bc($institution.$dt.$eid),$set_c_nbc($institution.$dt.$eid),\
                                            $chgbk($institution.$dt.$eid),\
                                            $REJECTS,$refund($institution.$dt.$eid),$MISC_ADJUSTMENTS,$ACH_RESUB,$RESERVES,\
                                            $DISCOUNT,$netdeposit($institution.$dt.$eid)\r"
                        }
                }
            puts $cur_file " "
            puts $cur_file "Subtotal:,,,$subset_c_bc($institution.$dt),$subset_c_nbc($institution.$dt),\
                            $subchgbk($institution.$dt),$SUB_REJECTS,$subrefund($institution.$dt),\
                            $SUB_MISC_ADJUSTMENTS,$SUB_ACH_RESUB,$SUB_RESERVES,$SUB_DISCOUNT,\
                            $subnetdeposit($institution.$dt)\r"
            puts $cur_file " "

            }
        }

        if {![info exists grandset_bc($institution)]} {
            set grandset_bc($institution) 0
        }

        if {![info exists grandchgbk($institution)]} {
            set grandchgbk($institution) 0
        }

        if {![info exists grandrefund($institution)]} {
            set grandrefund($institution) 0
        }

        if {![info exists grandnetdeposit($institution)]} {
            set grandnetdeposit($institution) 0
        }

        puts $cur_file "Total:,,,$grandset_bc($institution),$GRAND_SETTLED_NONBC,$grandchgbk($institution),\
                        $GRAND_REJECTS,$grandrefund($institution),$GRAND_MISC_ADJUSTMENTS,$GRAND_ACH_RESUB,\
                        $GRAND_RESERVES,$GRAND_DISCOUNT,$grandnetdeposit($institution)\r"
        puts $cur_file " "
    }


    close $cur_file

    exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" -- "$mail_to"

    exec mv $file_name ./ARCHIVE
}


##########
# MAIN
##########

global  time_mode sql_inst mail_to mail_err
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

set fetch_cursor1 [oraopen $clr_logon_handle]
set fetch_cursor2 [oraopen $clr_logon_handle]


if {![info exists date_arg]} {
      init_dates [clock format [clock seconds] -format %Y%m%d]
} else {
      init_dates $date_arg
}

foreach sql_inst $inst_list {
     do_report $sql_inst
}

oraclose $fetch_cursor1

oraclose $fetch_cursor2

oralogoff $clr_logon_handle
