#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: daily_detail_settled.tcl 4840 2019-04-15 18:54:23Z skumar $
# $Rev: 4840 $
################################################################################
#
#    File Name   -  daily_detail_settled.tcl
#
#    Description -  This is a custom report to aid balancing the daily
#                   transactions processed and settled by JetPay.
#                   This report pulls mainly from MAS, the settlement
#                   system. The transaction information comes from
#                   mas_trans_log and the payment information comes from
#                   acct_accum_det.
#
#    Arguments   -i institution id
#                -f config file
#                -c cycle
#                -d Date to run the report, optional  e.g. 20140521
#                   This scripts can run with or without a date. If no date
#                   provided it will use sysdate to run the report.
#                   With a date argument, the script will run the report for a
#                   given date.
#
#    Usage       -  daily_detail_settled.tcl -I nnn ... \[-D yyyymmdd\]...
#
#                   e.g.   daily_detail_settled.tcl -i 101
#                          daily_detail_settled.tcl -i 101 -d 20120421
#                          daily_detail_settled.tcl -i 101 -c 2 -d 20120421
#
################################################################################

package require Oratcl
package provide random 1.0
lappend auto_path $env(MASCLR_LIB)
package require GetOpts 1.1
source $env(MASCLR_LIB)/masclr_tcl_lib

global MODE
set MODE "PROD"

################################################################################
set box $env(SYS_BOX)
proc readCfgFile {} {
   global clr_db_logon
   global clr_db
   global argv mail_to mail_err

   set clr_db_logon ""
   set clr_db ""

   if { [regexp {(-[fF])[ ]+([A-Za-z_-]+\.[A-Za-z]+)} $argv dummy1 dummy2 cfg_file_name] } {
         puts "Config file argument: $cfg_file_name"
   } else {
          set cfg_file_name daily_detail_settled.cfg
          puts "Default Config File: $cfg_file_name"
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
        MASCLR::log_message "Encountered error $result while trying to connect to CLR_DB"
        exit 1
   } else {
        MASCLR::log_message " Connected to $clr_db" 3
   }
}


proc prev_day_SQLConstr {columnName} {
   global yesterday date
   return "$columnName >= '$yesterday' and $columnName < '$date'"
}

proc IS_cur_day {columnName} {
   global tomorrow date
   return "($columnName >= '$date' and $columnName < '$tomorrow')"
}


proc arg_parse {} {
   global argv sql_inst date_arg arg_cycle cycle cycle_passed
   global cfg_file_name mail_to MODE argv0

    while { [ set err [ getopt $argv "i:c:d:f:t:v" opt optarg ]] } {
        if { $err < 0 } then {
            MASCLR::log_message "error: $argv0 : opt $opt, optarg: $optarg "
            usage
            exit 1
        } else {
            MASCLR::log_message "opt: $opt, optarg: $optarg" 1
            switch -exact $opt {
               i {set sql_inst $optarg}
               c {set arg_cycle $optarg}
               d {set date_arg $optarg}
               t {
                   set mail_to $optarg
                   set MODE "TEST"
                 }
               v {incr MASCLR::DEBUG_LEVEL}
               f {set cfg_file_name $optarg}
            }
        }
    }
    if { [info exists arg_cycle] } {
          MASCLR::log_message  " Cycle passed:    $arg_cycle " 2
          set cycle " = $arg_cycle"
          set cycle_passed "Y"
    } else {
          set cycle "  = 1"
          MASCLR::log_message  " Default Cycle: $cycle" 2
          set cycle_passed "N"
    }
}


proc init_dates {val} {
     global date mydate filedate tomorrow yesterday report_ddate report_mdate report_mddate
     global report_yesterday_mddate report_DD curdate requested_date

     set curdate        [clock format [clock seconds] -format %b-%d-%Y]
     set requested_date [clock format [clock scan "$val"] -format %b-%d-%Y]

     set date      [string toupper [clock format [clock scan "$val"] -format %d-%b-%Y]]   ;# 21-MAR-08
     set mydate    [string toupper [clock format [clock scan "$date"] -format %b-%Y]]     ;# MAR-08
     set filedate  [clock format   [clock scan " $date -0 day"] -format %Y%m%d]           ;# 20080321

     set yesterday [string toupper [clock format [clock scan " $date -1 day"] -format %d-%b-%Y]]
     set tomorrow  [string toupper [clock format [clock scan " $date +1 day"] -format %d-%b-%Y]]

     set report_ddate            [clock format [clock scan " $date -0 day"] -format %m/%d/%y]  ;# 03/21/08
     set report_mdate            [clock format [clock scan " $date -0 day"] -format %m/%y]
     set report_mddate           [clock format [clock scan " $date -0 day"] -format %m/%d]
     set report_DD               [clock format [clock scan " $date -0 day"] -format %d]
     set report_yesterday_mddate [clock format [clock scan " $date -1 day"] -format %m/%d]

     MASCLR::log_message " Generated Date:  $curdate" 3
     MASCLR::log_message " Requested Date:  $requested_date" 3
     MASCLR::log_message " Month_Year Date: $mydate" 3
     MASCLR::log_message " Start Date:      $yesterday" 3
     MASCLR::log_message " End Date:        $tomorrow" 3
}

proc do_report {inst} {
    global daily_cursor cycle yesterday report_DD curdate requested_date sql_inst
    global mydate report_ddate report_mdate test_cursor1 cur_file date cycle_passed
    global fetch_cursor tomorrow report_yesterday_mddate report_mddate arg_cycle

    puts $cur_file "  Institution:,$sql_inst"
    puts $cur_file "  Date Generated:,$curdate"
    puts $cur_file "  Requested Date:,$requested_date"
    puts $cur_file "    "
    puts $cur_file ",Daily: $report_ddate,,,,, Month to Date: $report_mdate,,"
    puts $cur_file "    "
    puts $cur_file "TRANSACTIONS,COUNT,AMOUNT,FEES,ACCOUNT EFFECT,,COUNT,AMOUNT,FEES,ACCOUNT EFFECT\r"

	
#========================================================================================================

    set    ACH_AMOUNT           0
    set    ACH_COUNT            0
    set    MACH_AMOUNT          0
    set    MACH_COUNT           0
    set    CHR_AMOUNT           0
    set    CHR_VS_AMOUNT        0
    set    CHR_MC_AMOUNT        0
    set    CHR_AX_AMOUNT        0
    set    CHR_DS_AMOUNT        0

    set    CHR_C_AMOUNT         0
    set    CHR_D_AMOUNT         0
    set    CHR_VS_C_AMOUNT      0
    set    CHR_VS_D_AMOUNT      0
    set    CHR_MC_C_AMOUNT      0
    set    CHR_MC_D_AMOUNT      0
    set    CHR_AX_C_AMOUNT      0
    set    CHR_AX_D_AMOUNT      0
    set    CHR_DS_C_AMOUNT      0
    set    CHR_DS_D_AMOUNT      0

    set    CHR_C_FEE            0
    set    CHR_D_FEE            0
    set    CHR_FEE              0

    set    CHR_VS_C_FEE         0
    set    CHR_VS_D_FEE         0
    set    CHR_VS_FEE           0
    set    CHR_MC_C_FEE         0
    set    CHR_MC_D_FEE         0
    set    CHR_MC_FEE           0
    set    CHR_AX_C_FEE         0
    set    CHR_AX_D_FEE         0
    set    CHR_AX_FEE           0
    set    CHR_DS_C_FEE         0
    set    CHR_DS_D_FEE         0
    set    CHR_DS_FEE           0

    set    CHR_COUNT            0
    set    CHR_VS_COUNT         0
    set    CHR_MC_COUNT         0
    set    CHR_AX_COUNT         0
    set    CHR_DS_COUNT         0

    set    MCHR_AMOUNT          0
    set    MCHR_C_AMOUNT        0
    set    MCHR_D_AMOUNT        0
    set    MCHR_D_FEE           0
    set    MCHR_C_FEE           0
    set    MCHR_COUNT           0
    set    MCHR_FEE             0

    set    MCHR_VS_AMOUNT       0
    set    MCHR_VS_C_AMOUNT     0
    set    MCHR_VS_D_AMOUNT     0
    set    MCHR_VS_D_FEE        0
    set    MCHR_VS_C_FEE        0
    set    MCHR_VS_COUNT        0
    set    MCHR_VS_FEE          0
    set    MCHR_MC_AMOUNT       0
    set    MCHR_MC_C_AMOUNT     0
    set    MCHR_MC_D_AMOUNT     0
    set    MCHR_MC_D_FEE        0
    set    MCHR_MC_C_FEE        0
    set    MCHR_MC_COUNT        0
    set    MCHR_MC_FEE          0
    set    MCHR_AX_AMOUNT       0
    set    MCHR_AX_C_AMOUNT     0
    set    MCHR_AX_D_AMOUNT     0
    set    MCHR_AX_D_FEE        0
    set    MCHR_AX_C_FEE        0
    set    MCHR_AX_COUNT        0
    set    MCHR_AX_FEE          0
    set    MCHR_DS_AMOUNT       0
    set    MCHR_DS_C_AMOUNT     0
    set    MCHR_DS_D_AMOUNT     0
    set    MCHR_DS_D_FEE        0
    set    MCHR_DS_C_FEE        0
    set    MCHR_DS_COUNT        0
    set    MCHR_DS_FEE          0

    set    AMEX_AMOUNT          0
    set    AMEX_COUNT           0
    set    AMEX_FEE             0
    set    AMEX_REFUND_AMOUNT   0
    set    MAMEX_AMOUNT         0
    set    MAMEX_COUNT          0
    set    MAMEX_FEE            0
    set    MAMEX_REFUND_AMOUNT  0
    set    DB_AMOUNT            0
    set    DB_C_FEE             0
    set    DB_D_FEE             0
    set    DB_COUNT             0
    set    DB_FEE               0
    set    DB_REFUND_AMOUNT     0
    set    MDB_AMOUNT           0
    set    MDB_C_FEE            0
    set    MDB_D_FEE            0
    set    MDB_COUNT            0
    set    MDB_FEE              0
    set    MDB_REFUND_AMOUNT    0
    set    MDB_TOTAL            0
    set    JCB_AMOUNT           0
    set    JCB_COUNT            0
    set    JCB_FEE              0
    set    JCB_REFUND_AMOUNT    0
    set    MJCB_AMOUNT          0
    set    MJCB_COUNT           0
    set    MJCB_FEE             0
    set    MJCB_REFUND_AMOUNT   0
    set    EBT_AMOUNT           0
    set    EBT_COUNT            0
    set    EBT_FEE              0
    set    EBT_TOTAL            0
    set    MEBT_TOTAL           0
    set    MEBT_AMOUNT          0
    set    MEBT_COUNT           0
    set    MEBT_FEE             0
    set    MC_AMOUNT            0
    set    MC_C_FEE             0
    set    MC_D_FEE             0
    set    MC_FEE               0
    set    MC_COUNT             0
    set    MC_REFUND_AMOUNT     0
    set    MMC_AMOUNT           0
    set    MMC_C_FEE            0
    set    MMC_D_FEE            0
    set    MMC_FEE              0
    set    MMC_COUNT            0
    set    MMC_REFUND_AMOUNT    0
    set    VISA_AMOUNT          0
    set    VISA_C_FEE           0
    set    VISA_D_FEE           0
    set    VISA_COUNT           0
    set    VISA_FEE             0
    set    VS_REFUND_AMOUNT     0
    set    MVISA_AMOUNT         0
    set    MVISA_C_FEE          0
    set    MVISA_D_FEE          0
    set    MVISA_COUNT          0
    set    MVISA_FEE            0
    set    MVS_REFUND_AMOUNT    0
    set    OTHER_C_FEE          0
    set    OTHER_D_FEE          0
    set    OTHER_COUNT          0
    set    OTHER_FEE            0
    set    OTHER_AMOUNT         0
    set    MOTHER_AMOUNT        0
    set    MOTHER_C_FEE         0
    set    MOTHER_D_FEE         0
    set    MOTHER_FEE           0
    set    MOTHER_COUNT         0
    set    DISC_AMOUNT          0
    set    DISC_COUNT           0
    set    DISC_FEE             0
    set    DISC_REFUND_AMOUNT   0
    set    MDISC_AMOUNT         0
    set    MDISC_COUNT          0
    set    MDISC_FEE            0
    set    MDISC_REFUND_AMOUNT  0
    set    REPROCESSED_REJECT   0
    set    REJECT_COUNT         0
    set    V_ASSOCIATION_REJECT 0
    set    V_REJECT_COUNT       0
    set    M_ASSOCIATION_REJECT 0
    set    M_REJECT_COUNT       0
    set    X_ASSOCIATION_REJECT 0
    set    X_REJECT_COUNT       0
    set    D_ASSOCIATION_REJECT 0
    set    D_REJECT_COUNT       0
    set    MISC_ADJUSTMENTS     0
    set    MISC_AMOUNT          0
    set    MISC_AMOUNT          0
    set    MISC_C_AMOUNT        0
    set    MISC_D_AMOUNT        0
    set    MISC_COUNT           0
    set    MISC_FEE             0
    set    MISC_TOTAL           0
    set    MMISC_TOTAL          0
    set    MMISC_AMOUNT         0
    set    MMISC_C_AMOUNT       0
    set    MMISC_D_AMOUNT       0
    set    MMISC_COUNT          0
    set    MMISC_FEE            0

    set    REP_AMOUNT           0
    set    REP_C_AMOUNT         0
    set    REP_D_AMOUNT         0
    set    REP_COUNT            0
    set    REP_FEE              0

    set    REP_VS_AMOUNT        0
    set    REP_VS_C_AMOUNT      0
    set    REP_VS_D_AMOUNT      0
    set    REP_VS_COUNT         0
    set    REP_VS_FEE           0

    set    REP_MC_AMOUNT        0
    set    REP_MC_C_AMOUNT      0
    set    REP_MC_D_AMOUNT      0
    set    REP_MC_COUNT         0
    set    REP_MC_FEE           0

    set    REP_AX_AMOUNT        0
    set    REP_AX_C_AMOUNT      0
    set    REP_AX_D_AMOUNT      0
    set    REP_AX_COUNT         0
    set    REP_AX_FEE           0

    set    REP_DS_AMOUNT        0
    set    REP_DS_C_AMOUNT      0
    set    REP_DS_D_AMOUNT      0
    set    REP_DS_COUNT         0
    set    REP_DS_FEE           0

    set    MREP_AMOUNT          0
    set    MREP_C_AMOUNT        0
    set    MREP_D_AMOUNT        0
    set    MREP_COUNT           0
    set    MREP_FEE             0

    set    MREP_VS_AMOUNT       0
    set    MREP_VS_C_AMOUNT     0
    set    MREP_VS_D_AMOUNT     0
    set    MREP_VS_COUNT        0
    set    MREP_VS_FEE          0

    set    MREP_MC_AMOUNT       0
    set    MREP_MC_C_AMOUNT     0
    set    MREP_MC_D_AMOUNT     0
    set    MREP_MC_COUNT        0
    set    MREP_MC_FEE          0

    set    MREP_AX_AMOUNT       0
    set    MREP_AX_C_AMOUNT     0
    set    MREP_AX_D_AMOUNT     0
    set    MREP_AX_COUNT        0
    set    MREP_AX_FEE          0

    set    MREP_DS_AMOUNT       0
    set    MREP_DS_C_AMOUNT     0
    set    MREP_DS_D_AMOUNT     0
    set    MREP_DS_COUNT        0
    set    MREP_DS_FEE          0

    set    ARB_AMOUNT           0
    set    ARB_C_AMOUNT         0
    set    ARB_D_AMOUNT         0
    set    ARB_COUNT            0
    set    ARB_FEE              0

    set    ARB_VS_AMOUNT        0
    set    ARB_VS_C_AMOUNT      0
    set    ARB_VS_D_AMOUNT      0
    set    ARB_VS_COUNT         0
    set    ARB_VS_FEE           0

    set    ARB_MC_AMOUNT        0
    set    ARB_MC_C_AMOUNT      0
    set    ARB_MC_D_AMOUNT      0
    set    ARB_MC_COUNT         0
    set    ARB_MC_FEE           0

    set    ARB_AX_AMOUNT        0
    set    ARB_AX_C_AMOUNT      0
    set    ARB_AX_D_AMOUNT      0
    set    ARB_AX_COUNT         0
    set    ARB_AX_FEE           0

    set    ARB_DS_AMOUNT        0
    set    ARB_DS_C_AMOUNT      0
    set    ARB_DS_D_AMOUNT      0
    set    ARB_DS_COUNT         0
    set    ARB_DS_FEE           0

    set    MARB_AMOUNT          0
    set    MARB_C_AMOUNT        0
    set    MARB_D_AMOUNT        0
    set    MARB_COUNT           0
    set    MARB_FEE             0

    set    MARB_VS_AMOUNT       0
    set    MARB_VS_C_AMOUNT     0
    set    MARB_VS_D_AMOUNT     0
    set    MARB_VS_COUNT        0
    set    MARB_VS_FEE          0

    set    MARB_MC_AMOUNT       0
    set    MARB_MC_C_AMOUNT     0
    set    MARB_MC_D_AMOUNT     0
    set    MARB_MC_COUNT        0
    set    MARB_MC_FEE          0

    set    MARB_AX_AMOUNT       0
    set    MARB_AX_C_AMOUNT     0
    set    MARB_AX_D_AMOUNT     0
    set    MARB_AX_COUNT        0
    set    MARB_AX_FEE          0

    set    MARB_DS_AMOUNT       0
    set    MARB_DS_C_AMOUNT     0
    set    MARB_DS_D_AMOUNT     0
    set    MARB_DS_COUNT        0
    set    MARB_DS_FEE          0

    set    RESERVE              0
    set    TODAY_RESERVE        0
    set    TOTAL_RESERVE        0
    set    TODAY_RESERVE_PAID   0
    set    SUB_TODAY_RESERVE    0


###
# Daily Sales. We'll pull the entire month-to-date in order to retrieve m-t-d and
# the day in question using a single query
###

    set IS_SALES "tid in ('010003005102', '010003005101', '010003005201', '010003005202',
                          '010003005104', '010003005204', '010003005103', '010003005203')"
    set IS_CHGBK "tid in ('010003015101', '010003015102', '010003015201', '010003015210', '010003015301',
                          '010003015511','010003015512')"
    set IS_REPR  "TID in ('010003005301', '010003005401','010003015521','010003015522')"
    set IS_ARB   "TID in ('010003010102', '010003010101')"
    set IS_OTHER "TID in ('010123005101', '010123005102')"

    set daily_sales_str "
    SELECT TO_CHAR( gl_date, 'DD') dd,
      nvl(sum(CASE WHEN( mtl.major_cat in ('SALES','REFUNDS') and mtl.minor_cat is null and card_scheme = '02') then 1 end ), 0)                                       as DB_COUNT,
      nvl(sum(CASE WHEN( mtl.major_cat in ('SALES','REFUNDS') and mtl.minor_cat is null and card_scheme = '03') then 1 end ), 0)                                       as AMEX_COUNT,
      nvl(sum(CASE WHEN( mtl.major_cat in ('SALES','REFUNDS') and mtl.minor_cat is null and card_scheme = '04') then 1 end ), 0)                                       as VS_COUNT,
      nvl(sum(CASE WHEN( mtl.major_cat in ('SALES','REFUNDS') and mtl.minor_cat is null and card_scheme = '05') then 1 end ), 0)                                       as MC_COUNT,
      nvl(sum(CASE WHEN( mtl.major_cat in ('SALES','REFUNDS') and mtl.minor_cat is null and card_scheme = '08') then 1 end ), 0)                                       as DISC_COUNT,
      nvl(sum(CASE WHEN( mtl.major_cat in ('SALES','REFUNDS') and mtl.minor_cat is null and card_scheme = '09') then 1 end ), 0)                                       as JCB_COUNT,

      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'CHARGEBACK'                       ) then 1 end ), 0)                                       as CHR_COUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'CHARGEBACK' and card_scheme = '04') then 1 end ), 0)                                       as CHR_VS_COUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'CHARGEBACK' and card_scheme = '05') then 1 end ), 0)                                       as CHR_MC_COUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'CHARGEBACK' and card_scheme = '03') then 1 end ), 0)                                       as CHR_AX_COUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'CHARGEBACK' and card_scheme = '08') then 1 end ), 0)                                       as CHR_DS_COUNT,

      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'REPRESENTMENT'                        ) then 1 end ), 0)                                       as REP_COUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'REPRESENTMENT' and card_scheme = '04' ) then 1 end ), 0)                                       as REP_VS_COUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'REPRESENTMENT' and card_scheme = '05' ) then 1 end ), 0)                                       as REP_MC_COUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'REPRESENTMENT' and card_scheme = '03' ) then 1 end ), 0)                                       as REP_AX_COUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'REPRESENTMENT' and card_scheme = '08' ) then 1 end ), 0)                                       as REP_DS_COUNT,

      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'ARBITRATION'                         ) then 1 end ), 0)                                       as ARB_COUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'ARBITRATION' and card_scheme = '04'  ) then 1 end ), 0)                                       as ARB_VS_COUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'ARBITRATION' and card_scheme = '05'  ) then 1 end ), 0)                                       as ARB_MC_COUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'ARBITRATION' and card_scheme = '03'  ) then 1 end ), 0)                                       as ARB_AX_COUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'ARBITRATION' and card_scheme = '08'  ) then 1 end ), 0)                                       as ARB_DS_COUNT,

      nvl(sum(CASE WHEN( mtl.tid in ('010123005101', '010123005102')                       ) then 1 end ), 0)                                       as MISC_COUNT,

      nvl(sum(CASE WHEN( mtl.major_cat in ('SALES','REFUNDS') and mtl.minor_cat is null and mtl.tid_SETTL_METHOD = 'C'  and card_scheme = '02') then AMT_ORIGINAL end), 0) as DB_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat in ('SALES','REFUNDS') and mtl.minor_cat is null and mtl.tid_SETTL_METHOD = 'C'  and card_scheme = '03') then AMT_ORIGINAL end), 0) as AMEX_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat in ('SALES','REFUNDS') and mtl.minor_cat is null and mtl.tid_SETTL_METHOD = 'C'  and card_scheme = '04') then AMT_ORIGINAL end), 0) as VS_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat in ('SALES','REFUNDS') and mtl.minor_cat is null and mtl.tid_SETTL_METHOD = 'C'  and card_scheme = '05') then AMT_ORIGINAL end), 0) as MC_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat in ('SALES','REFUNDS') and mtl.minor_cat is null and mtl.tid_SETTL_METHOD = 'C'  and card_scheme = '08') then AMT_ORIGINAL end), 0) as DISC_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat in ('SALES','REFUNDS') and mtl.minor_cat is null and mtl.tid_SETTL_METHOD = 'C'  and card_scheme = '09') then AMT_ORIGINAL end), 0) as JCB_AMOUNT,

      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'CHARGEBACK' and mtl.tid_SETTL_METHOD =  'C' )                       then AMT_ORIGINAL end), 0) as CHR_C_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'CHARGEBACK' and mtl.tid_SETTL_METHOD <> 'C' )                       then AMT_ORIGINAL end), 0) as CHR_D_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'CHARGEBACK' and mtl.tid_SETTL_METHOD =  'C' and card_scheme = '04') then AMT_ORIGINAL end), 0) as CHR_VS_C_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'CHARGEBACK' and mtl.tid_SETTL_METHOD <> 'C' and card_scheme = '04') then AMT_ORIGINAL end), 0) as CHR_VS_D_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'CHARGEBACK' and mtl.tid_SETTL_METHOD =  'C' and card_scheme = '05') then AMT_ORIGINAL end), 0) as CHR_MC_C_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'CHARGEBACK' and mtl.tid_SETTL_METHOD <> 'C' and card_scheme = '05') then AMT_ORIGINAL end), 0) as CHR_MC_D_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'CHARGEBACK' and mtl.tid_SETTL_METHOD =  'C' and card_scheme = '03') then AMT_ORIGINAL end), 0) as CHR_AX_C_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'CHARGEBACK' and mtl.tid_SETTL_METHOD <> 'C' and card_scheme = '03') then AMT_ORIGINAL end), 0) as CHR_AX_D_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'CHARGEBACK' and mtl.tid_SETTL_METHOD =  'C' and card_scheme = '08') then AMT_ORIGINAL end), 0) as CHR_DS_C_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'CHARGEBACK' and mtl.tid_SETTL_METHOD <> 'C' and card_scheme = '08') then AMT_ORIGINAL end), 0) as CHR_DS_D_AMOUNT,

      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'REPRESENTMENT'  and mtl.tid_SETTL_METHOD =  'C' )                       then AMT_ORIGINAL end), 0) as REP_C_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'REPRESENTMENT'  and mtl.tid_SETTL_METHOD <> 'C' )                       then AMT_ORIGINAL end), 0) as REP_D_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'REPRESENTMENT'  and mtl.tid_SETTL_METHOD =  'C' and card_scheme = '04') then AMT_ORIGINAL end), 0) as REP_VS_C_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'REPRESENTMENT'  and mtl.tid_SETTL_METHOD <> 'C' and card_scheme = '04') then AMT_ORIGINAL end), 0) as REP_VS_D_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'REPRESENTMENT'  and mtl.tid_SETTL_METHOD =  'C' and card_scheme = '05') then AMT_ORIGINAL end), 0) as REP_MC_C_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'REPRESENTMENT'  and mtl.tid_SETTL_METHOD <> 'C' and card_scheme = '05') then AMT_ORIGINAL end), 0) as REP_MC_D_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'REPRESENTMENT'  and mtl.tid_SETTL_METHOD =  'C' and card_scheme = '03') then AMT_ORIGINAL end), 0) as REP_AX_C_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'REPRESENTMENT'  and mtl.tid_SETTL_METHOD <> 'C' and card_scheme = '03') then AMT_ORIGINAL end), 0) as REP_AX_D_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'REPRESENTMENT'  and mtl.tid_SETTL_METHOD =  'C' and card_scheme = '08') then AMT_ORIGINAL end), 0) as REP_DS_C_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'REPRESENTMENT'  and mtl.tid_SETTL_METHOD <> 'C' and card_scheme = '08') then AMT_ORIGINAL end), 0) as REP_DS_D_AMOUNT,

      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'ARBITRATION'   and mtl.tid_SETTL_METHOD =  'C' )                       then AMT_ORIGINAL end), 0) as ARB_C_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'ARBITRATION'   and mtl.tid_SETTL_METHOD <> 'C' )                       then AMT_ORIGINAL end), 0) as ARB_D_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'ARBITRATION'   and mtl.tid_SETTL_METHOD =  'C' and card_scheme = '04') then AMT_ORIGINAL end), 0) as ARB_VS_C_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'ARBITRATION'   and mtl.tid_SETTL_METHOD <> 'C' and card_scheme = '04') then AMT_ORIGINAL end), 0) as ARB_VS_D_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'ARBITRATION'   and mtl.tid_SETTL_METHOD =  'C' and card_scheme = '05') then AMT_ORIGINAL end), 0) as ARB_MC_C_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'ARBITRATION'   and mtl.tid_SETTL_METHOD <> 'C' and card_scheme = '05') then AMT_ORIGINAL end), 0) as ARB_MC_D_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'ARBITRATION'   and mtl.tid_SETTL_METHOD =  'C' and card_scheme = '03') then AMT_ORIGINAL end), 0) as ARB_AX_C_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'ARBITRATION'   and mtl.tid_SETTL_METHOD <> 'C' and card_scheme = '03') then AMT_ORIGINAL end), 0) as ARB_AX_D_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'ARBITRATION'   and mtl.tid_SETTL_METHOD =  'C' and card_scheme = '08') then AMT_ORIGINAL end), 0) as ARB_DS_C_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat = 'DISPUTES' and mtl.minor_cat = 'ARBITRATION'   and mtl.tid_SETTL_METHOD <> 'C' and card_scheme = '08') then AMT_ORIGINAL end), 0) as ARB_DS_D_AMOUNT,

      nvl(sum(CASE WHEN( mtl.tid in ('010123005101', '010123005102') and mtl.tid_SETTL_METHOD =  'C' )                       then AMT_ORIGINAL end), 0) as MISC_C_AMOUNT,
      nvl(sum(CASE WHEN( mtl.tid in ('010123005101', '010123005102') and mtl.tid_SETTL_METHOD <> 'C' )                       then AMT_ORIGINAL end), 0) as MISC_D_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat in ('SALES','REFUNDS') and mtl.minor_cat is null and mtl.tid_SETTL_METHOD <> 'C' and card_scheme = '02') then AMT_ORIGINAL end), 0) as DB_REFUND_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat in ('SALES','REFUNDS') and mtl.minor_cat is null and mtl.tid_SETTL_METHOD <> 'C' and card_scheme = '03') then AMT_ORIGINAL end), 0) as AMEX_REFUND_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat in ('SALES','REFUNDS') and mtl.minor_cat is null and mtl.tid_SETTL_METHOD <> 'C' and card_scheme = '04') then AMT_ORIGINAL end), 0) as VS_REFUND_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat in ('SALES','REFUNDS') and mtl.minor_cat is null and mtl.tid_SETTL_METHOD <> 'C' and card_scheme = '05') then AMT_ORIGINAL end), 0) as MC_REFUND_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat in ('SALES','REFUNDS') and mtl.minor_cat is null and mtl.tid_SETTL_METHOD <> 'C' and card_scheme = '08') then AMT_ORIGINAL end), 0) as DISC_REFUND_AMOUNT,
      nvl(sum(CASE WHEN( mtl.major_cat in ('SALES','REFUNDS') and mtl.minor_cat is null and TID_SETTL_METHOD <> 'C' and card_scheme = '09') then AMT_ORIGINAL end), 0) as JCB_REFUND_AMOUNT
    FROM mas_trans_view mtl
    WHERE institution_id in ($sql_inst)
      AND gl_date >= '01-$mydate'
      AND gl_date < '$tomorrow'
      AND settl_flag = 'Y'
    GROUP BY TO_CHAR( gl_date, 'DD')"

    orasql $daily_cursor $daily_sales_str

    MASCLR::log_message "Daily Sales Query: $daily_sales_str" 3

    while {[orafetch $daily_cursor -dataarray s -indexbyname] != 1403} {

    if {$report_DD == $s(DD)} {
        set CHR_COUNT           [expr $CHR_COUNT    + $s(CHR_COUNT)]
        set CHR_VS_COUNT        [expr $CHR_VS_COUNT + $s(CHR_VS_COUNT)]
        set CHR_MC_COUNT        [expr $CHR_MC_COUNT + $s(CHR_MC_COUNT)]
        set CHR_AX_COUNT        [expr $CHR_AX_COUNT + $s(CHR_AX_COUNT)]
        set CHR_DS_COUNT        [expr $CHR_DS_COUNT + $s(CHR_DS_COUNT)]

        set REP_COUNT           [expr $REP_COUNT    + $s(REP_COUNT)]
        set REP_VS_COUNT        [expr $REP_VS_COUNT + $s(REP_VS_COUNT)]
        set REP_MC_COUNT        [expr $REP_MC_COUNT + $s(REP_MC_COUNT)]
        set REP_AX_COUNT        [expr $REP_AX_COUNT + $s(REP_AX_COUNT)]
        set REP_DS_COUNT        [expr $REP_DS_COUNT + $s(REP_DS_COUNT)]

        set ARB_COUNT           [expr $ARB_COUNT    + $s(ARB_COUNT)]
        set ARB_VS_COUNT        [expr $ARB_VS_COUNT + $s(ARB_VS_COUNT)]
        set ARB_MC_COUNT        [expr $ARB_MC_COUNT + $s(ARB_MC_COUNT)]
        set ARB_AX_COUNT        [expr $ARB_AX_COUNT + $s(ARB_AX_COUNT)]
        set ARB_DS_COUNT        [expr $ARB_DS_COUNT + $s(ARB_DS_COUNT)]

        set MISC_COUNT          [expr $MISC_COUNT  + $s(MISC_COUNT)]
        set VISA_COUNT          [expr $VISA_COUNT  + $s(VS_COUNT)]
        set MC_COUNT            [expr $MC_COUNT    + $s(MC_COUNT)]
        set AMEX_COUNT          [expr $AMEX_COUNT  + $s(AMEX_COUNT)]
        set DISC_COUNT          [expr $DISC_COUNT  + $s(DISC_COUNT)]
        set DB_COUNT            [expr $DB_COUNT    + $s(DB_COUNT)]
        set JCB_COUNT           [expr $JCB_COUNT   + $s(JCB_COUNT)]
        set VISA_AMOUNT         [expr $VISA_AMOUNT + $s(VS_AMOUNT)]
        set MC_AMOUNT           [expr $MC_AMOUNT   + $s(MC_AMOUNT)]
        set AMEX_AMOUNT         [expr $AMEX_AMOUNT + $s(AMEX_AMOUNT)]
        set DISC_AMOUNT         [expr $DISC_AMOUNT + $s(DISC_AMOUNT)]
        set DB_AMOUNT           [expr $DB_AMOUNT   + $s(DB_AMOUNT)]
        set JCB_AMOUNT          [expr $JCB_AMOUNT  + $s(JCB_AMOUNT)]

        set CHR_AMOUNT          [expr $CHR_AMOUNT    + [expr $s(CHR_C_AMOUNT)    - $s(CHR_D_AMOUNT)]]
        set CHR_VS_AMOUNT       [expr $CHR_VS_AMOUNT + [expr $s(CHR_VS_C_AMOUNT) - $s(CHR_VS_D_AMOUNT)]]
        set CHR_MC_AMOUNT       [expr $CHR_MC_AMOUNT + [expr $s(CHR_MC_C_AMOUNT) - $s(CHR_MC_D_AMOUNT)]]
        set CHR_AX_AMOUNT       [expr $CHR_AX_AMOUNT + [expr $s(CHR_AX_C_AMOUNT) - $s(CHR_AX_D_AMOUNT)]]
        set CHR_DS_AMOUNT       [expr $CHR_DS_AMOUNT + [expr $s(CHR_DS_C_AMOUNT) - $s(CHR_DS_D_AMOUNT)]]

        set REP_AMOUNT          [expr $REP_AMOUNT    + [expr $s(REP_C_AMOUNT)    - $s(REP_D_AMOUNT)]]
        set REP_VS_AMOUNT       [expr $REP_VS_AMOUNT + [expr $s(REP_VS_C_AMOUNT) - $s(REP_VS_D_AMOUNT)]]
        set REP_MC_AMOUNT       [expr $REP_MC_AMOUNT + [expr $s(REP_MC_C_AMOUNT) - $s(REP_MC_D_AMOUNT)]]
        set REP_AX_AMOUNT       [expr $REP_AX_AMOUNT + [expr $s(REP_AX_C_AMOUNT) - $s(REP_AX_D_AMOUNT)]]
        set REP_DS_AMOUNT       [expr $REP_DS_AMOUNT + [expr $s(REP_DS_C_AMOUNT) - $s(REP_DS_D_AMOUNT)]]

        set ARB_AMOUNT          [expr $ARB_AMOUNT    + [expr $s(ARB_C_AMOUNT)    - $s(ARB_D_AMOUNT)]]
        set ARB_VS_AMOUNT       [expr $ARB_VS_AMOUNT + [expr $s(ARB_VS_C_AMOUNT) - $s(ARB_VS_D_AMOUNT)]]
        set ARB_MC_AMOUNT       [expr $ARB_MC_AMOUNT + [expr $s(ARB_MC_C_AMOUNT) - $s(ARB_MC_D_AMOUNT)]]
        set ARB_AX_AMOUNT       [expr $ARB_AX_AMOUNT + [expr $s(ARB_AX_C_AMOUNT) - $s(ARB_AX_D_AMOUNT)]]
        set ARB_DS_AMOUNT       [expr $ARB_DS_AMOUNT + [expr $s(ARB_DS_C_AMOUNT) - $s(ARB_DS_D_AMOUNT)]]

        set MISC_AMOUNT         [expr $MISC_AMOUNT        + [expr $s(MISC_C_AMOUNT) - $s(MISC_D_AMOUNT)]]
        set VS_REFUND_AMOUNT    [expr $VS_REFUND_AMOUNT   + $s(VS_REFUND_AMOUNT)]
        set MC_REFUND_AMOUNT    [expr $MC_REFUND_AMOUNT   + $s(MC_REFUND_AMOUNT)]
        set AMEX_REFUND_AMOUNT  [expr $AMEX_REFUND_AMOUNT + $s(AMEX_REFUND_AMOUNT)]
        set DISC_REFUND_AMOUNT  [expr $DISC_REFUND_AMOUNT + $s(DISC_REFUND_AMOUNT)]
        set DB_REFUND_AMOUNT    [expr $DB_REFUND_AMOUNT   + $s(DB_REFUND_AMOUNT)]
        set JCB_REFUND_AMOUNT   [expr $JCB_REFUND_AMOUNT  + $s(JCB_REFUND_AMOUNT)]
    }

        set MCHR_COUNT          [expr $MCHR_COUNT    + $s(CHR_COUNT)]
        set MCHR_VS_COUNT       [expr $MCHR_VS_COUNT + $s(CHR_VS_COUNT)]
        set MCHR_MC_COUNT       [expr $MCHR_MC_COUNT + $s(CHR_MC_COUNT)]
        set MCHR_AX_COUNT       [expr $MCHR_AX_COUNT + $s(CHR_AX_COUNT)]
        set MCHR_DS_COUNT       [expr $MCHR_DS_COUNT + $s(CHR_DS_COUNT)]

        set MREP_COUNT          [expr $MREP_COUNT    + $s(REP_COUNT)]
        set MREP_VS_COUNT       [expr $MREP_VS_COUNT + $s(REP_VS_COUNT)]
        set MREP_MC_COUNT       [expr $MREP_MC_COUNT + $s(REP_MC_COUNT)]
        set MREP_AX_COUNT       [expr $MREP_AX_COUNT + $s(REP_AX_COUNT)]
        set MREP_DS_COUNT       [expr $MREP_DS_COUNT + $s(REP_DS_COUNT)]

        set MARB_COUNT          [expr $MARB_COUNT    + $s(ARB_COUNT)]
        set MARB_VS_COUNT       [expr $MARB_VS_COUNT + $s(ARB_VS_COUNT)]
        set MARB_MC_COUNT       [expr $MARB_MC_COUNT + $s(ARB_MC_COUNT)]
        set MARB_AX_COUNT       [expr $MARB_AX_COUNT + $s(ARB_AX_COUNT)]
        set MARB_DS_COUNT       [expr $MARB_DS_COUNT + $s(ARB_DS_COUNT)]

        set MMISC_COUNT         [expr $MMISC_COUNT  + $s(MISC_COUNT)]
        set MVISA_COUNT         [expr $MVISA_COUNT  + $s(VS_COUNT)]
        set MMC_COUNT           [expr $MMC_COUNT    + $s(MC_COUNT)]
        set MAMEX_COUNT         [expr $MAMEX_COUNT  + $s(AMEX_COUNT)]
        set MDISC_COUNT         [expr $MDISC_COUNT  + $s(DISC_COUNT)]
        set MDB_COUNT           [expr $MDB_COUNT    + $s(DB_COUNT)]
        set MJCB_COUNT          [expr $MJCB_COUNT   + $s(JCB_COUNT)]
        set MVISA_AMOUNT        [expr $MVISA_AMOUNT + $s(VS_AMOUNT)]
        set MMC_AMOUNT          [expr $MMC_AMOUNT   + $s(MC_AMOUNT)]
        set MAMEX_AMOUNT        [expr $MAMEX_AMOUNT + $s(AMEX_AMOUNT)]
        set MDISC_AMOUNT        [expr $MDISC_AMOUNT + $s(DISC_AMOUNT)]
        set MDB_AMOUNT          [expr $MDB_AMOUNT   + $s(DB_AMOUNT)]
        set MJCB_AMOUNT         [expr $MJCB_AMOUNT  + $s(JCB_AMOUNT)]

        set MCHR_AMOUNT         [expr $MCHR_AMOUNT    + [expr $s(CHR_C_AMOUNT)    - $s(CHR_D_AMOUNT)]]
        set MCHR_VS_AMOUNT      [expr $MCHR_VS_AMOUNT + [expr $s(CHR_VS_C_AMOUNT) - $s(CHR_VS_D_AMOUNT)]]
        set MCHR_MC_AMOUNT      [expr $MCHR_MC_AMOUNT + [expr $s(CHR_MC_C_AMOUNT) - $s(CHR_MC_D_AMOUNT)]]
        set MCHR_AX_AMOUNT      [expr $MCHR_AX_AMOUNT + [expr $s(CHR_AX_C_AMOUNT) - $s(CHR_AX_D_AMOUNT)]]
        set MCHR_DS_AMOUNT      [expr $MCHR_DS_AMOUNT + [expr $s(CHR_DS_C_AMOUNT) - $s(CHR_DS_D_AMOUNT)]]

        set MREP_AMOUNT         [expr $MREP_AMOUNT    + [expr $s(REP_C_AMOUNT)    - $s(REP_D_AMOUNT)]]
        set MREP_VS_AMOUNT      [expr $MREP_VS_AMOUNT + [expr $s(REP_VS_C_AMOUNT) - $s(REP_VS_D_AMOUNT)]]
        set MREP_MC_AMOUNT      [expr $MREP_MC_AMOUNT + [expr $s(REP_MC_C_AMOUNT) - $s(REP_MC_D_AMOUNT)]]
        set MREP_AX_AMOUNT      [expr $MREP_AX_AMOUNT + [expr $s(REP_AX_C_AMOUNT) - $s(REP_AX_D_AMOUNT)]]
        set MREP_DS_AMOUNT      [expr $MREP_DS_AMOUNT + [expr $s(REP_DS_C_AMOUNT) - $s(REP_DS_D_AMOUNT)]]

        set MARB_AMOUNT         [expr $MARB_AMOUNT    + [expr $s(ARB_C_AMOUNT)    - $s(ARB_D_AMOUNT)]]
        set MARB_VS_AMOUNT      [expr $MARB_VS_AMOUNT + [expr $s(ARB_VS_C_AMOUNT) - $s(ARB_VS_D_AMOUNT)]]
        set MARB_MC_AMOUNT      [expr $MARB_MC_AMOUNT + [expr $s(ARB_MC_C_AMOUNT) - $s(ARB_MC_D_AMOUNT)]]
        set MARB_AX_AMOUNT      [expr $MARB_AX_AMOUNT + [expr $s(ARB_AX_C_AMOUNT) - $s(ARB_AX_D_AMOUNT)]]
        set MARB_DS_AMOUNT      [expr $MARB_DS_AMOUNT + [expr $s(ARB_DS_C_AMOUNT) - $s(ARB_DS_D_AMOUNT)]]

        set MMISC_AMOUNT        [expr $MMISC_AMOUNT        + [expr $s(MISC_C_AMOUNT) - $s(MISC_D_AMOUNT)]]
        set MVS_REFUND_AMOUNT   [expr $MVS_REFUND_AMOUNT   +  $s(VS_REFUND_AMOUNT)]
        set MMC_REFUND_AMOUNT   [expr $MMC_REFUND_AMOUNT   +  $s(MC_REFUND_AMOUNT)]
        set MAMEX_REFUND_AMOUNT [expr $MAMEX_REFUND_AMOUNT +  $s(AMEX_REFUND_AMOUNT)]
        set MDISC_REFUND_AMOUNT [expr $MDISC_REFUND_AMOUNT +  $s(DISC_REFUND_AMOUNT)]
        set MDB_REFUND_AMOUNT   [expr $MDB_REFUND_AMOUNT   +  $s(DB_REFUND_AMOUNT)]
        set MJCB_REFUND_AMOUNT  [expr $MJCB_REFUND_AMOUNT  +  $s(JCB_REFUND_AMOUNT)]

    }

    MASCLR::log_message "sales_str is done at [clock format [clock seconds]]" 3

###
#  Daily fees. We'll pull the entire month-to-date in order to retrieve m-t-d and
#  the day in question using a single query
###

    set IS_CHGBK_FEES "TID in ('010004160000', '010004160001')"

    set daily_fees_str "
    SELECT TO_CHAR( aad.PAYMENT_PROC_DT, 'DD') dd,
      nvl(sum(CASE WHEN( mtl.card_scheme = '02' and tid_settl_method =  'C')  then AMT_ORIGINAL else 0 end), 0)   as DB_C_FEE,
      nvl(sum(CASE WHEN( mtl.card_scheme = '02' and tid_settl_method <> 'C')  then AMT_ORIGINAL else 0 end), 0)   as DB_D_FEE,
      nvl(sum(CASE WHEN( mtl.card_scheme = '03' and tid_settl_method =  'C')  then AMT_ORIGINAL else 0 end), 0)   as AMEX_C_FEE,
      nvl(sum(CASE WHEN( mtl.card_scheme = '03' and tid_settl_method <> 'C')  then AMT_ORIGINAL else 0 end), 0)   as AMEX_D_FEE,
      nvl(sum(CASE WHEN( mtl.card_scheme = '04' and tid_settl_method =  'C')  then AMT_ORIGINAL else 0 end), 0)   as VISA_C_FEE,
      nvl(sum(CASE WHEN( mtl.card_scheme = '04' and tid_settl_method <> 'C')  then AMT_ORIGINAL else 0 end), 0)   as VISA_D_FEE,
      nvl(sum(CASE WHEN( mtl.card_scheme = '05' and tid_settl_method =  'C')  then AMT_ORIGINAL else 0 end), 0)   as MC_C_FEE,
      nvl(sum(CASE WHEN( mtl.card_scheme = '05' and tid_settl_method <> 'C')  then AMT_ORIGINAL else 0 end), 0)   as MC_D_FEE,
      nvl(sum(CASE WHEN( mtl.card_scheme = '08' and tid_settl_method =  'C')  then AMT_ORIGINAL else 0 end), 0)   as DISC_C_FEE,
      nvl(sum(CASE WHEN( mtl.card_scheme = '08' and tid_settl_method <> 'C')  then AMT_ORIGINAL else 0 end), 0)   as DISC_D_FEE,
      nvl(sum(CASE WHEN( mtl.card_scheme = '09' and tid_settl_method =  'C')  then AMT_ORIGINAL else 0 end), 0)   as JCB_C_FEE,
      nvl(sum(CASE WHEN( mtl.card_scheme = '09' and tid_settl_method <> 'C')  then AMT_ORIGINAL else 0 end), 0)   as JCB_D_FEE,
      nvl(sum(CASE WHEN( mtl.tid_settl_method =  'C' and mtl.card_scheme not in ('02', '03', '04', '05', '08', '12'))
               then AMT_ORIGINAL else 0 end), 0)                                                                  as OTHER_C_FEE,
      nvl(sum(CASE WHEN( mtl.tid_settl_method <> 'C' and mtl.card_scheme not in ('02', '03', '04', '05', '08', '12'))
               then AMT_ORIGINAL else 0 end), 0)                                                                  as OTHER_D_FEE,

      nvl(sum(CASE WHEN( mtl.TID_SETTL_METHOD =  'C' and mtl.major_cat = 'FEES' and mtl.minor_cat = 'DISPUTES')
               then AMT_ORIGINAL else 0 end), 0)                                                                  as CHR_C_FEE,
      nvl(sum(CASE WHEN( mtl.TID_SETTL_METHOD <> 'C' and mtl.major_cat = 'FEES' and mtl.minor_cat = 'DISPUTES')
               then AMT_ORIGINAL else 0 end), 0)                                                                  as CHR_D_FEE,

      nvl(sum(CASE WHEN(mtl.card_scheme = '04' and mtl.TID_SETTL_METHOD =  'C' and mtl.major_cat = 'FEES' and mtl.minor_cat = 'DISPUTES')
               then AMT_ORIGINAL else  0 end), 0)                                                                 as CHR_VS_C_FEE,
      nvl(sum(CASE WHEN(mtl.card_scheme = '04' and mtl.TID_SETTL_METHOD <> 'C' and mtl.major_cat = 'FEES' and mtl.minor_cat = 'DISPUTES')
               then AMT_ORIGINAL else  0 end), 0)                                                                 as CHR_VS_D_FEE,

      nvl(sum(CASE WHEN(mtl.card_scheme = '05' and mtl.TID_SETTL_METHOD =  'C' and mtl.major_cat = 'FEES' and mtl.minor_cat = 'DISPUTES')
               then AMT_ORIGINAL else  0 end), 0)                                                                 as CHR_MC_C_FEE,
      nvl(sum(CASE WHEN(mtl.card_scheme = '05' and mtl.TID_SETTL_METHOD <> 'C' and mtl.major_cat = 'FEES' and mtl.minor_cat = 'DISPUTES')
               then AMT_ORIGINAL else  0 end), 0)                                                                 as CHR_MC_D_FEE,

      nvl(sum(CASE WHEN(mtl.card_scheme = '03' and mtl.TID_SETTL_METHOD =  'C' and mtl.major_cat = 'FEES' and mtl.minor_cat = 'DISPUTES')
               then AMT_ORIGINAL else  0 end), 0)                                                                 as CHR_AX_C_FEE,
      nvl(sum(CASE WHEN(mtl.card_scheme = '03' and mtl.TID_SETTL_METHOD <> 'C' and mtl.major_cat = 'FEES' and mtl.minor_cat = 'DISPUTES')
               then AMT_ORIGINAL else  0 end), 0)                                                                 as CHR_AX_D_FEE,

      nvl(sum(CASE WHEN(mtl.card_scheme = '08' and mtl.TID_SETTL_METHOD =  'C' and mtl.major_cat = 'FEES' and mtl.minor_cat = 'DISPUTES')
               then AMT_ORIGINAL else  0 end), 0)                                                                 as CHR_DS_C_FEE,
      nvl(sum(CASE WHEN(mtl.card_scheme = '08' and mtl.TID_SETTL_METHOD <> 'C' and mtl.major_cat = 'FEES' and mtl.minor_cat = 'DISPUTES')
               then AMT_ORIGINAL else  0 end), 0)                                                                 as CHR_DS_D_FEE

    FROM mas_trans_view mtl
    join ACCT_ACCUM_DET aad
    on mtl.PAYMENT_SEQ_NBR = aad.PAYMENT_SEQ_NBR AND mtl.institution_id = aad.institution_id
    join ENTITY_ACCT ea
    on ea.INSTITUTION_ID = aad.institution_id and ea.ENTITY_ACCT_ID = aad.entity_acct_id
    WHERE  mtl.institution_id in ($sql_inst)
       and aad.PAYMENT_PROC_DT  >= '01-$mydate' AND PAYMENT_PROC_DT < '$tomorrow'
       and aad.payment_cycle $cycle
       and aad.payment_status = 'P'
       and ea.stop_pay_flag is null
       AND (substr(mtl.tid, 1,8) = '01000507' OR substr(mtl.tid, 1,6) in ('010004','010040','010050','010080','010014'))
       AND mtl.settl_flag = 'Y'
    GROUP BY TO_CHAR( aad.PAYMENT_PROC_DT, 'DD')"

    MASCLR::log_message "Daily Fees Query: $daily_fees_str" 3
    #MASCLR::log_message "OTHER_FEE: $OTHER_FEE" 3
    orasql $daily_cursor $daily_fees_str

    while {[orafetch $daily_cursor -dataarray f -indexbyname] != 1403} {
       if {$report_DD == $f(DD)} {
            set MC_FEE            [expr $MC_FEE       + [expr $f(MC_C_FEE)     - $f(MC_D_FEE)]]
            set VISA_FEE          [expr $VISA_FEE     + [expr $f(VISA_C_FEE)   - $f(VISA_D_FEE)]]
            set DB_FEE            [expr $DB_FEE       + [expr $f(DB_C_FEE)     - $f(DB_D_FEE)]]
            set AMEX_FEE          [expr $AMEX_FEE     + [expr $f(AMEX_C_FEE)   - $f(AMEX_D_FEE)]]
            set DISC_FEE          [expr $DISC_FEE     + [expr $f(DISC_C_FEE)   - $f(DISC_D_FEE)]]
            set JCB_FEE           [expr $JCB_FEE      + [expr $f(JCB_C_FEE)    - $f(JCB_D_FEE)]]
            set OTHER_FEE         [expr $OTHER_FEE    + [expr $f(OTHER_C_FEE)  - $f(OTHER_D_FEE)]]
            #MASCLR::log_message "OTHER_FEE: $OTHER_FEE, OTHER_C_FEE: $f(OTHER_C_FEE), OTHER_D_FEE: $f(OTHER_D_FEE)" 3
            set CHR_FEE           [expr $CHR_FEE      + [expr $f(CHR_C_FEE)    - $f(CHR_D_FEE)]]
            set CHR_VS_FEE        [expr $CHR_VS_FEE   + [expr $f(CHR_VS_C_FEE) - $f(CHR_VS_D_FEE)]]
            set CHR_MC_FEE        [expr $CHR_MC_FEE   + [expr $f(CHR_MC_C_FEE) - $f(CHR_MC_D_FEE)]]
            set CHR_AX_FEE        [expr $CHR_AX_FEE   + [expr $f(CHR_AX_C_FEE) - $f(CHR_AX_D_FEE)]]
            set CHR_DS_FEE        [expr $CHR_DS_FEE   + [expr $f(CHR_DS_C_FEE) - $f(CHR_DS_D_FEE)]]
      }

      set MMC_FEE               [expr $MMC_FEE     + [expr $f(MC_C_FEE)     - $f(MC_D_FEE)]]
      set MVISA_FEE             [expr $MVISA_FEE   + [expr $f(VISA_C_FEE)   - $f(VISA_D_FEE)]]
      set MDB_FEE               [expr $MDB_FEE     + [expr $f(DB_C_FEE)     - $f(DB_D_FEE) ]]
      set MAMEX_FEE             [expr $MAMEX_FEE   + [expr $f(AMEX_C_FEE)   - $f(AMEX_D_FEE)]]
      set MDISC_FEE             [expr $MDISC_FEE   + [expr $f(DISC_C_FEE)   - $f(DISC_D_FEE)]]
      set MJCB_FEE              [expr $MJCB_FEE    + [expr $f(JCB_C_FEE)    - $f(JCB_D_FEE)  ]]
      set MOTHER_FEE            [expr $MOTHER_FEE  + [expr $f(OTHER_C_FEE)  - $f(OTHER_D_FEE)]]
      set MCHR_FEE              [expr $MCHR_FEE    + [expr $f(CHR_C_FEE)    - $f(CHR_D_FEE)]]
      set MCHR_VS_FEE           [expr $MCHR_VS_FEE + [expr $f(CHR_VS_C_FEE) - $f(CHR_VS_D_FEE)]]
      set MCHR_MC_FEE           [expr $MCHR_MC_FEE + [expr $f(CHR_MC_C_FEE) - $f(CHR_MC_D_FEE)]]
      set MCHR_AX_FEE           [expr $MCHR_AX_FEE + [expr $f(CHR_AX_C_FEE) - $f(CHR_AX_D_FEE)]]
      set MCHR_DS_FEE           [expr $MCHR_DS_FEE + [expr $f(CHR_DS_C_FEE) - $f(CHR_DS_D_FEE)]]
    }

    MASCLR::log_message "daily_fees_str is done at [clock format [clock seconds]]" 3

###
# Beginning and end balance.
# NOTE: [ m.gl_date < '$tomorrow' ] used here to capture a snapshot of this report (as if
#       it was actually ran on the historical date). It Excludes data that came in after the date in question.
###

    set IS_C "m.tid_settl_method  = 'C'"
    set IS_D "m.tid_settl_method <> 'C'"
    set NOT_PAID_YESTERDAY "(m.gl_date < '$date' and (aad.payment_status is null or trunc(aad.payment_proc_dt) > '$yesterday'))"
    set NOT_PAID_TODAY     "(m.gl_date < '$tomorrow' and (aad.payment_status is null or trunc(aad.payment_proc_dt) > '$date'))"

      
    set payables_qry "
    SELECT
      0 as BEGIN_PAYBL_BAL_C,
      nvl(sum(CASE WHEN( (aag.gl_date < '$date' and (aad.payment_status is null or aad.payment_status != 'P' or trunc(aad.payment_proc_dt) > '$yesterday')) ) then aag.amt_pay end), 0) as BEGIN_PAYBL_BAL_D,
      nvl(sum(CASE WHEN( (aag.gl_date < '$date' and (aad.payment_status is null or aad.payment_status != 'P' or trunc(aad.payment_proc_dt) > '$yesterday')) )           then 1 else 0 end)      , 0) as BEGIN_PAYBL_BAL_COUNT,
      0 as END_PAYBL_BAL_C,
      nvl(sum(CASE WHEN( (aag.gl_date < '$tomorrow' and (aad.payment_status is null or aad.payment_status != 'P' or trunc(aad.payment_proc_dt) > '$date')) )     then aag.amt_pay end), 0) as END_PAYBL_BAL_D,
      nvl(sum(CASE WHEN( (aag.gl_date < '$tomorrow' and (aad.payment_status is null or aad.payment_status != 'P' or trunc(aad.payment_proc_dt) > '$date')) )               then 1 else 0 end)      , 0) as END_PAYBL_BAL_COUNT
    FROM acct_accum_gldate  aag
    join acct_accum_det aad
    on aag.INSTITUTION_ID = aad.INSTITUTION_ID
       AND aag.ENTITY_ACCT_ID = aad.ENTITY_ACCT_ID 
       and aag.PAYMENT_SEQ_NBR = aad.PAYMENT_SEQ_NBR
    join entity_acct ea
    on ea.institution_id = aag.INSTITUTION_ID
       and ea.ENTITY_ACCT_ID = aag.ENTITY_ACCT_ID
    WHERE 
      aad.institution_id in ($sql_inst)
      and ea.acct_posting_type in ('A', 'C', 'D')
      AND aag.gl_date < '$tomorrow'
      and (aad.payment_status is null or aad.payment_status != 'P' or trunc(payment_proc_dt) > '$yesterday')
      having sum(aag.amt_pay) != 0
    "

    MASCLR::log_message "Payable Query: $payables_qry" 3

    orasql $daily_cursor $payables_qry

    set BEGIN_PAYBL_BAL 0
    set BEGIN_PAYBL_BAL_COUNT 0
    set END_PAYBL_BAL 0
    set END_PAYBL_BAL_COUNT 0
    
    while {[orafetch $daily_cursor -dataarray dscnt -indexbyname] != 1403} {
      set BEGIN_PAYBL_BAL       [expr $dscnt(BEGIN_PAYBL_BAL_D) - $dscnt(BEGIN_PAYBL_BAL_C) ]
      set BEGIN_PAYBL_BAL_COUNT       $dscnt(BEGIN_PAYBL_BAL_COUNT)
      set END_PAYBL_BAL         [expr $dscnt(END_PAYBL_BAL_D)   -  $dscnt(END_PAYBL_BAL_C) ]
      set END_PAYBL_BAL_COUNT         $dscnt(END_PAYBL_BAL_COUNT)
    }

    MASCLR::log_message "Begin and end payables balance is done at [clock format [clock seconds]]" 3

###
#   Reserves
###

    set IS_ADDED_RES "substr(mtl.tid,1,8) = '01000505'"

# this needs to be specified because the new 010007050100 are accompanied by
# an added negative 010007050000 record so we leave the 010007050100 out cause its already considered

    set IS_RES_NOT_PAID "mtl.tid = '010007050000'"

# this is different because the old releases were the existing 010007050000 records
# and the new releases are added 010007050100 records. They can both appear on the ACH as paid out.

    set IS_RES_RELEASE "substr(mtl.tid,1,8) = '01000705' and aad.payment_status = 'P'"

    set HAS_RESERVES "
    select entity_id
    from ACQ_ENTITY_ADD_ON
    where institution_id in ($sql_inst)
      and substr(user_defined_1,1,7) in ('ROLLING','RESERVE')"

    set IS_C "mtl.tid_settl_method =  'C'"
    set IS_D "mtl.tid_settl_method <> 'C'"

    set NOT_PAID_YESTERDAY "(mtl.gl_date < '$date' and (aad.payment_status is null or aad.payment_status = 'C' \
                             or (aad.payment_status = 'P' and trunc(aad.payment_proc_dt) > '$yesterday')))"

    set NOT_PAID_TODAY "(mtl.gl_date < '$tomorrow' and (aad.payment_status is null or aad.payment_status = 'C' \
                         or (aad.payment_status = 'P' and trunc(aad.payment_proc_dt) > '$date')))"

    set res_qry "
    SELECT
      nvl(sum(CASE WHEN( [IS_cur_day aad.payment_proc_dt] and $IS_C and $IS_RES_RELEASE) then mtl.AMT_ORIGINAL end), 0) as RELEASE_C,
      nvl(sum(CASE WHEN( [IS_cur_day aad.payment_proc_dt] and $IS_D and $IS_RES_RELEASE) then mtl.AMT_ORIGINAL end), 0) as RELEASE_D,
      nvl(sum(CASE WHEN( [IS_cur_day aad.payment_proc_dt] and $IS_C and $IS_ADDED_RES)   then mtl.AMT_ORIGINAL end), 0) as ADDITION_C,
      nvl(sum(CASE WHEN( [IS_cur_day aad.payment_proc_dt] and $IS_D and $IS_ADDED_RES)   then mtl.AMT_ORIGINAL end), 0) as ADDITION_D,
      nvl(sum(CASE WHEN( $IS_RES_NOT_PAID AND $NOT_PAID_YESTERDAY and $IS_C)             then mtl.AMT_ORIGINAL end), 0) as YEST_END_C,
      nvl(sum(CASE WHEN( $IS_RES_NOT_PAID AND $NOT_PAID_YESTERDAY and $IS_D)             then mtl.AMT_ORIGINAL end), 0) as YEST_END_D,
      nvl(sum(CASE WHEN( $IS_RES_NOT_PAID AND $NOT_PAID_TODAY and $IS_C)                 then mtl.AMT_ORIGINAL end), 0) as TODAY_END_C,
      nvl(sum(CASE WHEN( $IS_RES_NOT_PAID AND $NOT_PAID_TODAY and $IS_D)                 then mtl.AMT_ORIGINAL end), 0) as TODAY_END_D
    FROM mas_trans_log mtl, (select payment_seq_nbr, payment_proc_dt, payment_status, institution_id
                             from acct_accum_det
                             where  institution_id in ($sql_inst)
                               and (institution_id,entity_acct_id) in (select institution_id,entity_acct_id
                                                                       from entity_acct
                                                                       where  OWNER_ENTITY_ID in ($HAS_RESERVES))
                                                                         and (payment_status is null or payment_status = 'C'
                                                                         or   trunc(payment_proc_dt)  > '$yesterday')) aad
    WHERE (mtl.payment_seq_nbr = aad.payment_seq_nbr AND mtl.institution_id = aad.institution_id)
      AND mtl.institution_id in ($sql_inst)
      AND mtl.gl_date < '$tomorrow'
      AND (substr(mtl.tid,1,8) = '01000705' or substr(mtl.tid,1,8) = '01000505')"

    MASCLR::log_message "Reserve Query: $res_qry" 3

    orasql $daily_cursor $res_qry

    while {[orafetch $daily_cursor -dataarray res -indexbyname] != 1403} {
            set RESERVE_ADDED_TODAY [expr $res(ADDITION_C)     - $res(ADDITION_D)]
            set TODAY_RESERVE_PAID  [expr $res(RELEASE_C)      - $res(RELEASE_D)]
            set SUB_TODAY_RESERVE   [expr $RESERVE_ADDED_TODAY + $TODAY_RESERVE_PAID]
            set BEGIN_RESERVE       [expr $res(YEST_END_D)     - $res(YEST_END_C)]
            set ENDING_RESERVE      [expr $res(TODAY_END_D)    - $res(TODAY_END_C)]
    }


    set VISA_AMOUNT     [expr $VISA_AMOUNT  - $VS_REFUND_AMOUNT]
    set MC_AMOUNT       [expr $MC_AMOUNT    - $MC_REFUND_AMOUNT]
    set AMEX_AMOUNT     [expr $AMEX_AMOUNT  - $AMEX_REFUND_AMOUNT]
    set DISC_AMOUNT     [expr $DISC_AMOUNT  - $DISC_REFUND_AMOUNT]
    set DB_AMOUNT       [expr $DB_AMOUNT    - $DB_REFUND_AMOUNT]
    set JCB_AMOUNT      [expr $JCB_AMOUNT   - $JCB_REFUND_AMOUNT]
    set MMC_AMOUNT      [expr $MMC_AMOUNT   - $MMC_REFUND_AMOUNT]
    set MVISA_AMOUNT    [expr $MVISA_AMOUNT - $MVS_REFUND_AMOUNT]
    set MAMEX_AMOUNT    [expr $MAMEX_AMOUNT - $MAMEX_REFUND_AMOUNT]
    set MDISC_AMOUNT    [expr $MDISC_AMOUNT - $MDISC_REFUND_AMOUNT]
    set MDB_AMOUNT      [expr $MDB_AMOUNT   - $MDB_REFUND_AMOUNT]
    set MJCB_AMOUNT     [expr $MJCB_AMOUNT  - $MJCB_REFUND_AMOUNT]


#********    Pull ACH counts and amounts   **********#

    set query_string_ach "
        select
            nvl(sum(payment_amt), 0) * -1 as PAYMENT,
            count(1) as ACH_COUNT
        from (
            select
                distinct
                pl.*,
                aad.payment_cycle
            from PAYMENT_LOG pl
            join ACCT_ACCUM_DET aad
            on pl.institution_id = aad.institution_id
            and pl.payment_seq_nbr = aad.actual_payment_seq
            where [IS_cur_day pl.PAYMENT_PROC_DT]
             and pl.institution_id in ($sql_inst)
             and aad.payment_cycle $cycle
        )
        group by institution_id, payment_cycle
        order by institution_id, payment_cycle
        "
        
    orasql $daily_cursor $query_string_ach

    while {[orafetch $daily_cursor -dataarray ach -indexbyname] != 1403} {
            set ACH_AMOUNT       $ach(PAYMENT)
            set ACH_COUNT        $ach(ACH_COUNT)
    }

    MASCLR::log_message "ACH Query: $query_string_ach" 3

    MASCLR::log_message "query_string_ach is done at [clock format [clock seconds]]" 3

    set query_string "
        select 
            nvl(sum(payment_amt), 0) * -1 as MPAYMENT,
            count(1) as MACH_COUNT
        from PAYMENT_LOG pl 
        join ACCT_ACCUM_DET aad
        on pl.institution_id = aad.institution_id
        and pl.payment_seq_nbr = aad.actual_payment_seq 
        where pl.PAYMENT_PROC_DT >= trunc(TO_DATE( '$date', 'DD-MON-YY' ),'MM')
          and pl.PAYMENT_PROC_DT < '$tomorrow'
          and pl.institution_id in ($sql_inst)
          and aad.payment_cycle $cycle
        "

    orasql $daily_cursor $query_string

    while {[orafetch $daily_cursor -dataarray mach -indexbyname] != 1403} {
            set MACH_AMOUNT       $mach(MPAYMENT)
            set MACH_COUNT        $mach(MACH_COUNT)
    }

    MASCLR::log_message "query_string is done at [clock format [clock seconds]]" 3

#*******    Pull the reject counts and amounts  *******#

    set query_string "
        select idm.activity_dt, t.tid,
               nvl(sum(idm.amt_trans * decode(t.tid_settl_method, 'D', 1, -1)), 0)  as amt_trans,
               count(idm.pan) as count, idm.card_scheme
        from in_draft_main idm join tid t
             on (idm.tid = t.tid)
        where t.tid in ('010103005101', '010103005102', '010103005201', '010103005202')
          and idm.msg_text_block like '%JPREJECT%'
          and [prev_day_SQLConstr idm.activity_dt]
          and idm.SEC_DEST_INST_ID in ($sql_inst)
        group by idm.activity_dt, t.tid, idm.card_scheme"

    orasql $daily_cursor $query_string

    MASCLR::log_message "Rejects Query: $query_string" 3

    while {[orafetch $daily_cursor -dataarray w -indexbyname] != 1403} {
        switch $w(CARD_SCHEME) {
            "03" {
                set X_ASSOCIATION_REJECT [expr $X_ASSOCIATION_REJECT + $w(AMT_TRANS)]
                set X_REJECT_COUNT       [expr $X_REJECT_COUNT       + $w(COUNT)]
                }
            "04" {
                set V_ASSOCIATION_REJECT [expr $V_ASSOCIATION_REJECT + $w(AMT_TRANS)]
                set V_REJECT_COUNT       [expr $V_REJECT_COUNT       + $w(COUNT)]
                }
            "05" {
                set M_ASSOCIATION_REJECT [expr $M_ASSOCIATION_REJECT + $w(AMT_TRANS)]
                set M_REJECT_COUNT       [expr $M_REJECT_COUNT       + $w(COUNT)]
                }
            "08" {
                set D_ASSOCIATION_REJECT [expr $D_ASSOCIATION_REJECT + $w(AMT_TRANS)]
                set D_REJECT_COUNT       [expr $D_REJECT_COUNT       + $w(COUNT)]
            }
        }
    }

    MASCLR::log_message "Pull Reject is done at [clock format [clock seconds]]" 3

    set MTD_REPROCESSED_REJECT  0
    set MTD_REJECT_COUNT        0

    set MTDV_ASSOCIATION_REJECT 0
    set MTDV_REJECT_COUNT       0

    set MTDM_ASSOCIATION_REJECT 0
    set MTDM_REJECT_COUNT       0

    set MTDX_ASSOCIATION_REJECT 0
    set MTDX_REJECT_COUNT       0

    set MTDD_ASSOCIATION_REJECT 0
    set MTDD_REJECT_COUNT       0

    if {[string range $date 0 1] == "01" } {
         set reject_mtd "
            select t.tid,
                   nvl(sum(idm.amt_trans * decode(t.tid_settl_method, 'D', 1, -1)), 0)  as amt_trans,
                   count(idm.pan) as count, idm.card_scheme
            from in_draft_main idm join tid t
              on (idm.tid = t.tid)
            where (SUBSTR(t.tid,0,11) = '01010300510' OR SUBSTR(t.tid,0,11) = '01010300520')
              and idm.msg_text_block like '%JPREJECT%'
              and [prev_day_SQLConstr idm.activity_dt]
              and idm.SEC_DEST_INST_ID in ($sql_inst)
            group by  t.tid, idm.card_scheme"
    } else {
         set reject_mtd "
            select t.tid,
                   nvl(sum(idm.amt_trans * decode(t.tid_settl_method, 'D', 1, -1)), 0)  as amt_trans,
                   count(idm.pan) as count, idm.card_scheme
            from in_draft_main idm join tid t
              on (idm.tid = t.tid)
            where (SUBSTR(t.tid,0,11) = '01010300510' OR SUBSTR(t.tid,0,11) = '01010300520')
              and idm.msg_text_block like '%JPREJECT%'
              and (idm.activity_dt >= '01-$mydate' and idm.activity_dt < '$date')
              and idm.SEC_DEST_INST_ID in ($sql_inst)
            group by t.tid, idm.card_scheme"
    }

    orasql $daily_cursor $reject_mtd

    MASCLR::log_message "Rejects Query: $reject_mtd" 3

    while {[orafetch $daily_cursor -dataarray mtdw -indexbyname] != 1403} {
        switch $mtdw(CARD_SCHEME) {
            "03" {
                set MTDX_ASSOCIATION_REJECT [expr $MTDX_ASSOCIATION_REJECT + $mtdw(AMT_TRANS)]
                set MTDX_REJECT_COUNT       [expr $MTDX_REJECT_COUNT       + $mtdw(COUNT)]
                }
            "04" {
                set MTDV_ASSOCIATION_REJECT [expr $MTDV_ASSOCIATION_REJECT + $mtdw(AMT_TRANS)]
                set MTDV_REJECT_COUNT       [expr $MTDV_REJECT_COUNT       + $mtdw(COUNT)]
                }
            "05" {
                set MTDM_ASSOCIATION_REJECT [expr $MTDM_ASSOCIATION_REJECT + $mtdw(AMT_TRANS)]
                set MTDM_REJECT_COUNT       [expr $MTDM_REJECT_COUNT       + $mtdw(COUNT)]
                }
            "08" {
                set MTDD_ASSOCIATION_REJECT [expr $MTDD_ASSOCIATION_REJECT + $mtdw(AMT_TRANS)]
                set MTDD_REJECT_COUNT       [expr $MTDD_REJECT_COUNT       + $mtdw(COUNT)]
            }
        }
    }


    if {$V_ASSOCIATION_REJECT != 0 } {
        set V_ASSOCIATION_REJECT [expr $V_ASSOCIATION_REJECT / 100.00]
    }

    if {$M_ASSOCIATION_REJECT != 0 } {
        set M_ASSOCIATION_REJECT [expr $M_ASSOCIATION_REJECT / 100.00]
    }

    if {$X_ASSOCIATION_REJECT != 0 } {
        set X_ASSOCIATION_REJECT [expr $X_ASSOCIATION_REJECT / 100.00]
    }

    if {$D_ASSOCIATION_REJECT != 0 } {
        set D_ASSOCIATION_REJECT [expr $D_ASSOCIATION_REJECT / 100.00]
    }

    if {$REPROCESSED_REJECT != 0 } {
        set REPROCESSED_REJECT [expr $REPROCESSED_REJECT / 100.00]
    }

    if {$MTDV_ASSOCIATION_REJECT != 0 } {
        set MTDV_ASSOCIATION_REJECT [expr $MTDV_ASSOCIATION_REJECT / 100.00]
    }

    if {$MTDM_ASSOCIATION_REJECT != 0 } {
        set MTDM_ASSOCIATION_REJECT [expr $MTDM_ASSOCIATION_REJECT / 100.00]
    }

    if {$MTDX_ASSOCIATION_REJECT != 0 } {
        set MTDX_ASSOCIATION_REJECT [expr $MTDX_ASSOCIATION_REJECT / 100.00]
    }

    if {$MTDD_ASSOCIATION_REJECT != 0 } {
        set MTDD_ASSOCIATION_REJECT [expr $MTDD_ASSOCIATION_REJECT / 100.00]
    }

    if {$MTD_REPROCESSED_REJECT != 0 } {
        set MTD_REPROCESSED_REJECT [expr $MTD_REPROCESSED_REJECT / 100.00]
    }

    set REPROCESSED_REJECT     [expr $REPROCESSED_REJECT - $V_ASSOCIATION_REJECT - $M_ASSOCIATION_REJECT \
                                                         - $X_ASSOCIATION_REJECT - $D_ASSOCIATION_REJECT]

    set REJECT_COUNT           [expr $V_REJECT_COUNT     + $M_REJECT_COUNT       + $X_REJECT_COUNT    + $D_REJECT_COUNT]

    set MTD_REPROCESSED_REJECT [expr $MTD_REPROCESSED_REJECT - $MTDV_ASSOCIATION_REJECT - $MTDM_ASSOCIATION_REJECT \
                                                             - $MTDX_ASSOCIATION_REJECT - $MTDD_ASSOCIATION_REJECT]

    set MTD_REJECT_COUNT       [expr $MTDV_REJECT_COUNT  + $MTDM_REJECT_COUNT    + $MTDX_REJECT_COUNT + $MTDD_REJECT_COUNT]

    set VISA_AMOUNT            [expr $VISA_AMOUNT + $V_ASSOCIATION_REJECT]
    set MC_AMOUNT              [expr $MC_AMOUNT   + $M_ASSOCIATION_REJECT]
    set AMEX_AMOUNT            [expr $AMEX_AMOUNT + $X_ASSOCIATION_REJECT]
    set DISC_AMOUNT            [expr $DISC_AMOUNT + $D_ASSOCIATION_REJECT]

    set MMC_AMOUNT             [expr $MMC_AMOUNT   + $MTDM_ASSOCIATION_REJECT]
    set MVISA_AMOUNT           [expr $MVISA_AMOUNT + $MTDV_ASSOCIATION_REJECT]
    set MAMEX_AMOUNT           [expr $MAMEX_AMOUNT + $MTDX_ASSOCIATION_REJECT]
    set MDISC_AMOUNT           [expr $MDISC_AMOUNT + $MTDD_ASSOCIATION_REJECT]

    set VISA_TOTAL             [expr $VISA_AMOUNT + $VISA_FEE]
    set MC_TOTAL               [expr $MC_AMOUNT   + $MC_FEE]
    set AMEX_TOTAL             [expr $AMEX_AMOUNT + $AMEX_FEE]
    set DISC_TOTAL             [expr $DISC_AMOUNT + $DISC_FEE]
    set DB_TOTAL               [expr $DB_AMOUNT   + $DB_FEE]
    set JCB_TOTAL              [expr $JCB_AMOUNT  + $JCB_FEE]

    set MVISA_TOTAL            [expr $MVISA_AMOUNT + $MVISA_FEE]
    set MMC_TOTAL              [expr $MMC_AMOUNT   + $MMC_FEE]
    set MDB_TOTAL              [expr $MDB_AMOUNT   + $MDB_FEE]
    set MAMEX_TOTAL            [expr $MAMEX_AMOUNT + $MAMEX_FEE]
    set MDISC_TOTAL            [expr $MDISC_AMOUNT + $MDISC_FEE]
    set MJCB_TOTAL             [expr $MJCB_AMOUNT  + $MJCB_FEE]

# *** assign subtotal of first section ***

    set JCB_COUNT     0
    set EBT_COUNT     0
    set JCB_AMOUNT    0
    set EBT_AMOUNT    0
    set JCB_FEE       0
    set EBT_FEE       0
    set JCB_TOTAL     0
    set EBT_TOTAL     0
    set MJCB_FEE      0
    set MEBT_FEE      0
    set MJCB_COUNT    0
    set MEBT_COUNT    0
    set MJCB_AMOUNT   0
    set MEBT_AMOUNT   0
    set MJCB_TOTAL    0
    set MEBT_TOTAL    0

#   Daily:
    set D_SUB_SCNT       [expr $VISA_COUNT  + $MC_COUNT  + $AMEX_COUNT  + $DISC_COUNT  + $JCB_COUNT + $DB_COUNT   + $EBT_COUNT]
    set D_SUB_SAMT       [expr $VISA_AMOUNT + $MC_AMOUNT + $AMEX_AMOUNT + $DISC_AMOUNT + $DB_AMOUNT + $JCB_AMOUNT + $EBT_AMOUNT ]
    set D_SUB_FAMT       [expr $VISA_FEE    + $MC_FEE    + $AMEX_FEE    + $DISC_FEE    + $DB_FEE    + $JCB_FEE    + $EBT_FEE   + $OTHER_FEE]
    set D_SUB_ACCTEFFECT [expr $VISA_TOTAL  + $MC_TOTAL  + $AMEX_TOTAL  + $DISC_TOTAL  + $JCB_TOTAL + $DB_TOTAL   + $EBT_TOTAL + $OTHER_FEE]

#   Monthly:
    set M_SUB_SCNT       [expr $MVISA_COUNT  + $MMC_COUNT  + $MAMEX_COUNT  + $MDISC_COUNT  + $MJCB_COUNT  + $MDB_COUNT  + $MEBT_COUNT]
    set M_SUB_SAMT       [expr $MVISA_AMOUNT + $MMC_AMOUNT + $MAMEX_AMOUNT + $MDISC_AMOUNT + $MJCB_AMOUNT + $MDB_AMOUNT + $MEBT_AMOUNT]
    set M_SUB_FAMT       [expr $MVISA_FEE    + $MMC_FEE    + $MAMEX_FEE    + $MDISC_FEE    + $MJCB_FEE    + $MDB_FEE    + $MEBT_FEE + $MOTHER_FEE]
    set M_SUB_ACCTEFFECT [expr $M_SUB_SAMT   + $M_SUB_FAMT ]

    if { ( $cycle_passed == "N" ) || ( $cycle_passed == "Y" && $arg_cycle != "5" ) } {

         puts $cur_file "VISA,$VISA_COUNT,$[roundOff $VISA_AMOUNT],$[roundOff $VISA_FEE],$[roundOff $VISA_TOTAL],,$MVISA_COUNT,$[roundOff $MVISA_AMOUNT],$[roundOff $MVISA_FEE],\
                         $[roundOff [expr $MVISA_AMOUNT + $MVISA_FEE]]"
         puts $cur_file "MC,$MC_COUNT,$[roundOff $MC_AMOUNT],$[roundOff $MC_FEE],$[roundOff $MC_TOTAL],,$MMC_COUNT,$[roundOff $MMC_AMOUNT],$[roundOff $MMC_FEE],$[roundOff [expr $MMC_AMOUNT + $MMC_FEE]]"
         puts $cur_file "AMEX,$AMEX_COUNT,$[roundOff $AMEX_AMOUNT],$[roundOff $AMEX_FEE],$[roundOff $AMEX_TOTAL],,$MAMEX_COUNT,$[roundOff $MAMEX_AMOUNT],$[roundOff $MAMEX_FEE],$[roundOff $MAMEX_TOTAL]"
         puts $cur_file "DISC,$DISC_COUNT,$[roundOff $DISC_AMOUNT],$[roundOff $DISC_FEE],$[roundOff $DISC_TOTAL],,$MDISC_COUNT,$[roundOff $MDISC_AMOUNT],$[roundOff $MDISC_FEE],$[roundOff $MDISC_TOTAL]"
#        puts $cur_file "TE,0.00,0.00,0.00,0.00,,0.00,0.00,0.00,0.00"
         puts $cur_file "JCB,$JCB_COUNT,$[roundOff $JCB_AMOUNT],$[roundOff $JCB_FEE],$[roundOff $JCB_TOTAL],,$MJCB_COUNT,$[roundOff $MJCB_AMOUNT],$[roundOff $MJCB_FEE],$[roundOff $MJCB_TOTAL]"
         puts $cur_file "DBT,$DB_COUNT,$[roundOff $DB_AMOUNT],$[roundOff $DB_FEE],$[roundOff $DB_TOTAL],,$MDB_COUNT,$[roundOff $MDB_AMOUNT],$[roundOff $MDB_FEE],$[roundOff $MDB_TOTAL]"
         puts $cur_file "EBT,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file "MISC ADJ ,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file "OTHER,$OTHER_COUNT,\$0,$[roundOff $OTHER_FEE],$[roundOff $OTHER_FEE],,$MOTHER_COUNT,\$0,$[roundOff $MOTHER_FEE],$[roundOff $MOTHER_FEE]"
         puts $cur_file "SUBTOTAL,$D_SUB_SCNT,$[roundOff $D_SUB_SAMT],$[roundOff $D_SUB_FAMT],$[roundOff $D_SUB_ACCTEFFECT],,$M_SUB_SCNT,$[roundOff $M_SUB_SAMT],\
                         $[roundOff $M_SUB_FAMT],$[roundOff $M_SUB_ACCTEFFECT]"
         puts $cur_file " "
         puts $cur_file "REJECTS:"
         puts $cur_file "SUBTOTAL,$REJECT_COUNT,$[roundOff $REPROCESSED_REJECT],0.00,$[roundOff $REPROCESSED_REJECT],,$MTD_REJECT_COUNT,\
                                  $[roundOff $MTD_REPROCESSED_REJECT],0.00,$[roundOff $MTD_REPROCESSED_REJECT]"
         puts $cur_file " "
         puts $cur_file "MISC ADJ: "
         puts $cur_file "SUBTOTAL,$MISC_COUNT,$[roundOff $MISC_AMOUNT],0.00,$[roundOff $MISC_AMOUNT],,$MMISC_COUNT,$[roundOff $MMISC_AMOUNT],$MMISC_COUNT,$[roundOff $MMISC_AMOUNT]"
         puts $cur_file " "

         puts $cur_file "Disputes:"
         puts $cur_file "Chargebacks:"

         puts $cur_file "Visa,$CHR_VS_COUNT,$[roundOff $CHR_VS_AMOUNT],$[roundOff $CHR_VS_FEE],$[roundOff $CHR_VS_AMOUNT],,\
							$MCHR_VS_COUNT,$[roundOff $MCHR_VS_AMOUNT],$[roundOff $MCHR_VS_FEE],$[roundOff $MCHR_VS_AMOUNT]"

         puts $cur_file "MC,$CHR_MC_COUNT,$[roundOff $CHR_MC_AMOUNT],$[roundOff $CHR_MC_FEE],$[roundOff $CHR_MC_AMOUNT],,\
							$MCHR_MC_COUNT,$[roundOff $MCHR_MC_AMOUNT],$[roundOff $MCHR_MC_FEE],$[roundOff $MCHR_MC_AMOUNT]"

         puts $cur_file "Amex,$CHR_AX_COUNT,$[roundOff $CHR_AX_AMOUNT],$[roundOff $CHR_AX_FEE],$[roundOff $CHR_AX_AMOUNT],,\
							$MCHR_AX_COUNT,$[roundOff $MCHR_AX_AMOUNT],$[roundOff $MCHR_AX_FEE],$[roundOff $MCHR_AX_AMOUNT]"

         puts $cur_file "Disc,$CHR_DS_COUNT,$[roundOff $CHR_DS_AMOUNT],$[roundOff $CHR_DS_FEE],$[roundOff $CHR_DS_AMOUNT],,\
							$MCHR_DS_COUNT,$[roundOff $MCHR_DS_AMOUNT],$[roundOff $MCHR_DS_FEE],$[roundOff $MCHR_DS_AMOUNT]"

         puts $cur_file "Subtotal,$CHR_COUNT,$[roundOff $CHR_AMOUNT],$[roundOff $CHR_FEE],$[roundOff $CHR_AMOUNT],,\
							$MCHR_COUNT,$[roundOff $MCHR_AMOUNT],$[roundOff $MCHR_FEE],$[roundOff $MCHR_AMOUNT]"

         puts $cur_file " "

         puts $cur_file "Representments:"

         puts $cur_file "Visa,$REP_VS_COUNT,$[roundOff $REP_VS_AMOUNT],$[roundOff $REP_VS_FEE],$[roundOff $REP_VS_AMOUNT],,\
                              $MREP_VS_COUNT,$[roundOff $MREP_VS_AMOUNT],$[roundOff $MREP_VS_FEE],$[roundOff $MREP_VS_AMOUNT]"

         puts $cur_file "MC,$REP_MC_COUNT,$[roundOff $REP_MC_AMOUNT],$[roundOff $REP_MC_FEE],$[roundOff $REP_MC_AMOUNT],,\
                            $MREP_MC_COUNT,$[roundOff $MREP_MC_AMOUNT],$[roundOff $MREP_MC_FEE],$[roundOff $MREP_MC_AMOUNT]"

         puts $cur_file "Amex,$REP_AX_COUNT,$[roundOff $REP_AX_AMOUNT],$[roundOff $REP_AX_FEE],$[roundOff $REP_AX_AMOUNT],,\
                              $MREP_AX_COUNT,$[roundOff $MREP_AX_AMOUNT],$[roundOff $MREP_AX_FEE],$[roundOff $MREP_AX_AMOUNT]"

         puts $cur_file "Disc,$REP_DS_COUNT,$[roundOff $REP_DS_AMOUNT],$[roundOff $REP_DS_FEE],$[roundOff $REP_DS_AMOUNT],,\
                              $MREP_DS_COUNT,$[roundOff $MREP_DS_AMOUNT],$[roundOff $MREP_DS_FEE],$[roundOff $MREP_DS_AMOUNT]"

         puts $cur_file "Subtotal,$REP_COUNT,$[roundOff $REP_AMOUNT],$[roundOff $REP_FEE],$[roundOff $REP_AMOUNT],,\
                              $MREP_COUNT,$[roundOff $MREP_AMOUNT],$[roundOff $MREP_FEE],$[roundOff $MREP_AMOUNT]"

         puts $cur_file " "

         puts $cur_file "Arbitrations:"

         puts $cur_file "Visa,$ARB_VS_COUNT,$[roundOff $ARB_VS_AMOUNT],$[roundOff $ARB_VS_FEE],$[roundOff $ARB_VS_AMOUNT],,\
                              $MARB_VS_COUNT,$[roundOff $MARB_VS_AMOUNT],$[roundOff $MARB_VS_FEE],$[roundOff $MARB_VS_AMOUNT]"

         puts $cur_file "MC,$ARB_MC_COUNT,$[roundOff $ARB_MC_AMOUNT],$[roundOff $ARB_MC_FEE],$[roundOff $ARB_MC_AMOUNT],,\
                            $MARB_MC_COUNT,$[roundOff $MARB_MC_AMOUNT],$[roundOff $MARB_MC_FEE],$[roundOff $MARB_MC_AMOUNT]"

         puts $cur_file "Amex,$ARB_AX_COUNT,$[roundOff $ARB_AX_AMOUNT],$[roundOff $ARB_AX_FEE],$[roundOff $ARB_AX_AMOUNT],,\
                              $MARB_AX_COUNT,$[roundOff $MARB_AX_AMOUNT],$[roundOff $MARB_AX_FEE],$[roundOff $MARB_AX_AMOUNT]"

         puts $cur_file "Disc,$ARB_DS_COUNT,$[roundOff $ARB_DS_AMOUNT],$[roundOff $ARB_DS_FEE],$[roundOff $ARB_DS_AMOUNT],,\
                              $MARB_DS_COUNT,$[roundOff $MARB_DS_AMOUNT],$[roundOff $MARB_DS_FEE],$[roundOff $MARB_DS_AMOUNT]"

         puts $cur_file "Subtotal,$ARB_COUNT,$[roundOff $ARB_AMOUNT],$[roundOff $ARB_FEE],$[roundOff $ARB_AMOUNT],,\
                              $MARB_COUNT,$[roundOff $MARB_AMOUNT],$[roundOff $MARB_FEE],$[roundOff $MARB_AMOUNT]"

         puts $cur_file " "
         puts $cur_file "RESERVES:"
         puts $cur_file "Res Addition,,,,$[roundOff $RESERVE_ADDED_TODAY]"
         puts $cur_file "Res Release,,,,$[roundOff $TODAY_RESERVE_PAID]"
         puts $cur_file "SUBTOTAL:,,,,$[roundOff $SUB_TODAY_RESERVE]"
         puts $cur_file " "

    } elseif { ( $cycle_passed == "Y" && $arg_cycle == "5" ) } {
         puts $cur_file "VISA,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file "MC,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file "AMEX,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file "DISC,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
#        puts $cur_file "TE,0.00,0.00,0.00,0.00,,0.00,0.00,0.00,0.00"
         puts $cur_file "JCB,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file "DBT,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file "EBT,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file "MISC ADJ,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file "OTHER,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file "SUBTOTAL,0.00,\$0,$[roundOff $D_SUB_FAMT],\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file " "
         puts $cur_file "REJECTS:"
         puts $cur_file "SUBTOTAL,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file " "
         puts $cur_file "MISC ADJ: "
         puts $cur_file "SUBTOTAL,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file " "
         puts $cur_file "Disputes:"
         puts $cur_file "Chargebacks:"
         puts $cur_file "Visa,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file "MC,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file "Amex,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file "Disc,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file "Subtotal,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file " "
         puts $cur_file "Representments:"
         puts $cur_file "Visa,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file "MC,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file "Amex,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file "Disc,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file "Subtotal,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file " "
         puts $cur_file "Arbitrations:"
         puts $cur_file "Visa,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file "MC,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file "Amex,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file "Disc,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file "Subtotal,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
         puts $cur_file " "
         puts $cur_file "RESERVES:"
         puts $cur_file "Res Addition,,,,\$0"
         puts $cur_file "Res Release,,,,\$0"
         puts $cur_file "SUBTOTAL:,,,,\$0"
         puts $cur_file " "
    }

    puts $cur_file "DEPOSITS:"
    puts $cur_file "ACH:,$ACH_COUNT, , ,$[roundOff $ACH_AMOUNT],,$MACH_COUNT, , ,$[roundOff $MACH_AMOUNT]"
    puts $cur_file "SUBTOTAL:,$ACH_COUNT, , ,$[roundOff $ACH_AMOUNT],,$MACH_COUNT, , ,$[roundOff $MACH_AMOUNT]"

    if { ( $cycle_passed == "N" ) || ( $cycle_passed == "Y" && $arg_cycle != "5" ) } {
         puts $cur_file " "
         puts $cur_file "Beginning Payable Balance,$report_yesterday_mddate,,,$[roundOff $BEGIN_PAYBL_BAL]"
         puts $cur_file "Account Effect:,,,,$[roundOff [expr $END_PAYBL_BAL - $BEGIN_PAYBL_BAL]]"
         puts $cur_file "Ending Payable Balance,$report_mddate,,,$[roundOff $END_PAYBL_BAL]"

         puts $cur_file " "
         puts $cur_file "Beginning Reserve Balance,$report_yesterday_mddate,,,$[roundOff $BEGIN_RESERVE]"
         puts $cur_file "Account Effect:,,,,$[roundOff [expr $ENDING_RESERVE - $BEGIN_RESERVE]]"
         puts $cur_file "Ending Reserve Balance,$report_mddate,,,$[roundOff $ENDING_RESERVE]"
    }
}

proc roundOff {number} {
	return "[expr {double(round(100*$number))/100}]"
}

# MAIN
##########

readCfgFile
arg_parse
connect_to_db

set daily_cursor [oraopen $clr_logon_handle]

if {![info exists date_arg]} {
      init_dates [clock format [clock scan "-0 day"] -format %d-%b-%Y]
} else {
      init_dates [clock format [clock scan $date_arg -format %Y%m%d ] -format %d-%b-%Y]
}

if { [info exists arg_cycle] } {
      if { $arg_cycle == 5 } {
           set file_name  "$sql_inst.Daily_Detail_Report_nxdy.$filedate.csv"
      } else {
           set file_name  "$sql_inst.Daily_Detail_Report_Cycle.$arg_cycle.$filedate.csv"
      }
} else {
       set file_name  "$sql_inst.Daily_Detail_Report.$filedate.csv"
}

set cur_file      [open "$file_name" w]

do_report $sql_inst

close $cur_file


MASCLR::mutt_send_mail $mail_to  "$box:$file_name" "Please see attached." "$file_name"

exec mv $file_name ./ARCHIVE

oraclose $daily_cursor

oralogoff $clr_logon_handle
