#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: ach_report.tcl 4028 2017-01-19 17:24:05Z skumar $
# $Rev: 4028 $
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
#
#    Output          ACH statements by institution.
#                    Using a date will deterimine which day to run for. Default is today.
#                    Cycle will run just the ach report for that cycle.
#                    All times mode will build a report for each time that an ach was run on this date.
#                    Summary mode on will have one line per merchant.  Summary mode off will be one
#                      line per payment_seq_nbr in acct_accum_det.
#                    Test mode will send the reports just to the user running the scrip.
#
#    Usage       -   ach_report.tcl -I nnn ... \[-D yyyymmdd\]...
#
#                    e.g.   ach_report.tcl -i 101
#                           ach_report.tcl -i 101 -d 20120421
#                           ach_report.tcl -i 101 -c 2 -d 20120421
#
################################################################################

source $env(MASCLR_LIB)/masclr_tcl_lib

lappend auto_path $env(MASCLR_LIB)
package require GetOpts 1.1

package require Oratcl

################################################################################
proc readCfgFile {} {
   global clr_db_logon
   global clr_db
   global argv mail_to mail_err

   set clr_db_logon ""
   set clr_db ""

   if { [regexp {(-[fF])[ ]+([A-Za-z_-]+\.[A-Za-z]+)} $argv dummy1 dummy2 cfg_file_name] } {
         puts " Config file argument: $cfg_file_name"
   } else {
          set cfg_file_name ach_report.cfg
          puts " Default Config File: $cfg_file_name"
   }

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

proc arg_parse {} {
    global argv sql_inst date_arg mode debug_level arg_cycle cycle time_mode
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
          puts " Date argument: $arg_date"
          set date_arg $arg_date
    }

   #scan for Institution
   if { [regexp -- {(-[iI])[ ]+([0-9]{3})} $argv dummy1 dummy2 institution_arg] } {
         set sql_inst $institution_arg
         puts " Inst: $sql_inst"
   }

   if {![info exists institution_arg]} {
         puts "At least one Institution ID needs to be passed."
         exit 1
   }

    #scan for Cycle
    if { [regexp -- {(-[cC])[ ]+([0-9]{1})} $argv dummy1 dummy2 arg_cycle] } {
          set cycle $arg_cycle
    }

    if { [info exists arg_cycle] } {
          puts " Cycle passed:    $arg_cycle "
          set cycle  "$arg_cycle"
    } else {
          set cycle "1"
          puts " Default Cycle: $cycle"
    }
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
              and entity_acct_id not in (select entity_acct_id
                                         from  entity_acct
                                         where institution_id = '$sql_inst'
                                           and stop_pay_flag = 'Y')"

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
    global mode env arg_cycle cycle date_stamp time_mode summ_mode filedate curdate cur_file

    set    log_msg "ach_single_report"
    append log_msg " {inst=$sql_inst cycle=$cycle time_stamp=$time_stamp}"

    MASCLR::log_message  log_msg 2

    set old_date_stamp $date_stamp

    if {$time_stamp != "" } {
        append date_stamp "-$time_stamp"
        set date_clause  "PAYMENT_PROC_DT = to_date('$date_stamp', 'DD-MM-YYYY-HH24MISS')"
    } else {
        set date_clause "PAYMENT_PROC_DT >= '$today' and PAYMENT_PROC_DT < '$tommorrow'"
    }

    if {$summ_mode !="Y"} {
         set summ_clause ", PAYMENT_SEQ_NBR"
    } else {
         set summ_clause ""
    }

    if { $cycle != {} } {
        set cycle_name ".$cycle"
    } else {
        set cycle_name ""
    }

    if {$mode == "TEST"} {
         set file_name     "$sql_inst.Ach_Report.$date_stamp$cycle_name.TEST.csv"
    } elseif {$mode == "PROD"} {
          if { [info exists arg_cycle] } {
               if { $arg_cycle == 5 } {
                    set file_name  "$sql_inst.Ach_Report_nxdy.$filedate.csv"
               } else {
                    set file_name  "$sql_inst.Ach_Report_cycle.$cycle.$filedate.csv"
               }
          } else {
                    set file_name  "$sql_inst.Ach_Report.$filedate.csv"
         }
    }

    set cur_file  [open "$file_name" w]

    set date_stamp $old_date_stamp

    set columns    "   Institution:, $sql_inst \n "
    append columns "  Date Generated:, $curdate \n "
    append columns "  Requested Date:, $requested_date \n\n"

    append columns "ISO#,Merchant ID,Merchant Name,Settle Bankcards,Settle NonBankcards,"
    append columns "Chargeback Amount,Representment,Refunds,Misc Adj.,ACH Resub.,"
    append columns "Reserves,Fees,Net Deposit,,Detail Check,Difference\r"

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

    set IS_SALES "mtl.tid in ( '010003005101', '010123005101', '010123005102', '010003005201', '010003005202', '010003005104',
                               '010003005204', '010003005141', '010003005142', '010003005143', '010003005144', '010003005103',
                               '010003005203')"

    set IS_CHGBK "mtl.tid in ( '010003015101', '010003015102', '010003015201', '010003015210', '010003015301')"

    set IS_REPR  "mtl.tid in ('010003005301', '010003005401', '010003010102', '010003010101')"

    set IS_FEE "(substr(mtl.tid, 1,8) = '01000507' OR substr(mtl.tid, 1,6) in ('010004','010040','010050','010080','010014'))"

    set query_string "
        select unique mtl.posting_entity_id as ENTITY_ID,
               acq.parent_entity_id                                                              as PARENT_ENTITY_ID,
               replace(acq.entity_dba_name, ',', '')                                             as ENTITY_DBA_NAME,
               acq.actual_start_date                                                             as ACTUAL_START_DATE $summ_clause,
               sum(case when(mtl.tid_settl_method =  'C' and mtl.CARD_SCHEME <> '12')
                        then mtl.amt_original else 0 end)                                        as TOTAL_C_BC,
               sum(case when(mtl.tid_settl_method <> 'C' and mtl.CARD_SCHEME <> '12')
                        then mtl.amt_original else 0 end)                                        as TOTAL_D_BC,
               sum(case when(mtl.tid_settl_method =  'C' AND mtl.CARD_SCHEME in ('04','05','08')
                        AND $IS_SALES)
                        then mtl.amt_original else 0 end)                                        as SETTLED_C_BC,
               sum(case when(mtl.tid_settl_method <> 'C' AND mtl.CARD_SCHEME in ('04','05','08')
                        AND $IS_SALES)
                        then mtl.amt_original else 0 end)                                        as SETTLED_D_BC,
               sum(case when(mtl.tid_settl_method =  'C'
                        AND (substr(mtl.tid,1,8) in ('01000505','01000705')))
                        then mtl.amt_original else 0 end)                                        as RESERVES_C,
               sum(case when(mtl.tid_settl_method <> 'C'
                        AND (substr(mtl.tid,1,8) in ('01000505','01000705')))
                        then mtl.amt_original * -1 else 0 end)                                   as RESERVES_D,
               sum(case when(mtl.tid_settl_method =  'C' AND $IS_CHGBK)
                        then mtl.amt_original else 0 end)                                        as CHARGEBACK_C,
               sum(case when(mtl.tid_settl_method <> 'C' AND $IS_CHGBK)
                        then mtl.amt_original else 0 end)                                        as CHARGEBACK_D,
               sum(case when(mtl.tid_settl_method =  'C' AND $IS_REPR)
                        then mtl.amt_original else 0 end)                                        as REPR_C,
               sum(case when(mtl.tid_settl_method <> 'C' AND $IS_REPR)
                        then mtl.amt_original else 0 end)                                        as REPR_D,
               sum(case when(mtl.tid_settl_method =  'C' AND mtl.tid in ('010003005102'))
                        then mtl.amt_original else 0 end)                                        as REFUNDS_C,
               sum(case when(mtl.tid_settl_method <> 'C' AND mtl.tid in ('010003005102'))
                        then mtl.amt_original else 0 end)                                        as REFUNDS_D,
               sum(case when(mtl.tid_settl_method =  'C' AND $IS_SALES
                        AND mtl.CARD_SCHEME not in ('04','05','08','12'))
                        then mtl.amt_original else 0 end)                                        as SETTLED_NONBC_C,
               sum(case when(mtl.tid_settl_method <> 'C' AND $IS_SALES
                        AND mtl.CARD_SCHEME not in ('04','05','08','12'))
                        then mtl.amt_original else 0 end)                                        as SETTLED_NONBC_D,
               sum(case when(mtl.tid_settl_method = 'C'
                        AND ((substr(mtl.tid, 1,6) in ('010042','010051'))
                        or tid in ('010005090001','010007090001','010007090000','010007090002')))
                        then mtl.amt_original else 0 end)                                        as MISC_ADJS_C,
               sum(case when(mtl.tid_settl_method <> 'C'
                        AND ((substr(mtl.tid, 1,6) in ('010042','010051'))
                        or tid in ('010005090000','010007090000','010007090001','010005090002')))
                        then mtl.amt_original else 0 end)                                        as MISC_ADJS_D,
               sum(case when(mtl.tid_settl_method = 'C'  AND $IS_FEE)
                        then mtl.amt_original else 0 end)                                        as DISCOUNT_C,
               sum(case when(mtl.tid_settl_method <> 'C' AND $IS_FEE)
                        then mtl.amt_original else 0 end)                                        as DISCOUNT_D,
               sum(case when(mtl.tid_settl_method = 'C'
                        AND mtl.tid in ('010007150000','010007150001'))
                        then mtl.amt_original else 0 end)                                        as ACH_RESUB_C,
               sum(case when(mtl.tid_settl_method <> 'C'
                        AND mtl.tid in ('010007150000','010007150001'))
                        then mtl.amt_original else 0 end)                                        as ACH_RESUB_D
    from  mas_trans_log mtl, acq_entity acq
    where mtl.posting_entity_id = acq.entity_id
      and acq.institution_id = mtl.institution_id
      and mtl.institution_id = '$sql_inst'
      and mtl.SETTL_FLAG = 'Y'
      and mtl.PAYMENT_SEQ_NBR in (select PAYMENT_SEQ_NBR
                                  from  ACCT_ACCUM_DET
                                  where $date_clause
                                    and institution_id = '$sql_inst'
                                    and payment_cycle = '$cycle'
                                    and payment_status = 'P'
                                    and entity_acct_id not in (select entity_acct_id
                                                               from  entity_acct
                                                               where institution_id = '$sql_inst'
                                                                 and stop_pay_flag = 'Y'))
    group by mtl.posting_entity_id, acq.parent_entity_id, acq.entity_dba_name, acq.actual_start_date $summ_clause
    order by mtl.posting_entity_id  "

    MASCLR::log_message  "query_string:\n\n$query_string\n\n" 3

    orasql $ach_cursor1 $query_string

    while {[orafetch $ach_cursor1 -dataarray t -indexbyname] != 1403} {
        set ISO                   $t(PARENT_ENTITY_ID)
        set NAME                  $t(ENTITY_DBA_NAME)
        set CONTRACT_DATE         $t(ACTUAL_START_DATE)
        set ENTITY_ID             $t(ENTITY_ID)
        set SETTLED_BC          [ expr $t(SETTLED_C_BC)     - $t(SETTLED_D_BC)]
        set NETDEPOSIT          [ expr $t(TOTAL_C_BC)       - $t(TOTAL_D_BC)]
        set RESERVES            [ expr $t(RESERVES_C)       + $t(RESERVES_D)]
        set CHGBCK_AMT          [ expr $t(CHARGEBACK_C)     - $t(CHARGEBACK_D)]
        set REPR_AMOUNT         [ expr $t(REPR_C)           - $t(REPR_D)]
        set REFUNDS             [ expr $t(REFUNDS_C)        - $t(REFUNDS_D)]
        set SETTLED_NONBC       [ expr $t(SETTLED_NONBC_C)  - $t(SETTLED_NONBC_D)]
        set MISC_ADJS           [ expr $t(MISC_ADJS_C)      - $t(MISC_ADJS_D)]
        set DISCOUNT            [ expr $t(DISCOUNT_C)       - $t(DISCOUNT_D)]
        set ACH_RESUB           [ expr $t(ACH_RESUB_C)      - $t(ACH_RESUB_D)]
        set GRAND_SETTLED_BC    [ expr $GRAND_SETTLED_BC    + $SETTLED_BC]
        set GRAND_NETDEPOSIT    [ expr $GRAND_NETDEPOSIT    +  $NETDEPOSIT]
        set GRAND_RESERVES      [ expr $GRAND_RESERVES      + $RESERVES]
        set GRAND_CHGBCK_AMT    [ expr $GRAND_CHGBCK_AMT    + $CHGBCK_AMT]
        set GRAND_REPR_AMOUNT   [ expr $GRAND_REPR_AMOUNT   + $REPR_AMOUNT]
        set GRAND_REFUNDS       [ expr $GRAND_REFUNDS       + $REFUNDS]
        set GRAND_SETTLED_NONBC [ expr $GRAND_SETTLED_NONBC + $SETTLED_NONBC]
        set GRAND_MISC_ADJS     [ expr $GRAND_MISC_ADJS     + $MISC_ADJS]
        set GRAND_DISCOUNT      [ expr $GRAND_DISCOUNT      + $DISCOUNT]
        set GRAND_ACH_RESUB     [ expr $GRAND_ACH_RESUB     + $ACH_RESUB]

        set CALCULATED_NET  [expr $SETTLED_BC  + $SETTLED_NONBC + $CHGBCK_AMT + \
                                  $REPR_AMOUNT + $REFUNDS       + $MISC_ADJS  + \
                                  $ACH_RESUB   + $RESERVES      + $DISCOUNT]

        set REP_DISCREPANCY [expr $NETDEPOSIT  - $CALCULATED_NET]

        set GRND_CALCULATED_NET  [expr $GRND_CALCULATED_NET   + $CALCULATED_NET]

        set GRND_REP_DISCREPANCY [expr $GRND_REP_DISCREPANCY  + $REP_DISCREPANCY]

        if {$CHGBCK_AMT == 0 && $SETTLED_BC == 0 && $SETTLED_NONBC == 0 && \
            $REFUNDS    == 0 && $MISC_ADJS  == 0 && $DISCOUNT      == 0 && \
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

}

#######
# MAIN
#######

readCfgFile

connect_to_db

set ach_cursor1  [oraopen $clr_logon_handle]
set ach_cursor2  [oraopen $clr_logon_handle]

#Environment veriables.......

global  cycle time_mode sql_inst mail_to mail_err
global  ach_cursor1 ach_cursor2 today tomorrow file_name
global  date_stamp time_stamp summ_mode mode env

#Mode....
#set mode "TEST"
set mode "PROD"

# Verbose
set debug_level 0
set MASCLR::DEBUG_LEVEL 0

arg_parse

if {![info exists date_arg]} {
      init_dates [clock format [clock scan "-0 day"] -format %d-%b-%Y]
} else {
      init_dates [clock format [clock scan $date_arg -format %Y%m%d ] -format %d-%b-%Y]
}

do_report

close $cur_file

if {$mode == "TEST"} {
     if { [catch { exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" -- "$env(SCRIPT_USER)@jetpay.com" } result] != 0 } {
           if { [string range $result 0 21] == "Waiting for fcntl lock" } {
              puts "Ignore mutt file control lock $result"
           } else {
              error "mutt error message: $result"
           }
    }
} elseif {$mode == "PROD"} {
     if { [catch { exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" -- "$mail_to" } result] != 0 } {
           if { [string range $result 0 21] == "Waiting for fcntl lock" } {
              puts "Ignore mutt file control lock $result"
           } else {
              error "mutt error message: $result"
           }
    }
}


exec cp $file_name ../INST_$sql_inst/UPLOAD/

exec mv $file_name ./ARCHIVE

oraclose $ach_cursor1

oraclose $ach_cursor2

oralogoff $clr_logon_handle
