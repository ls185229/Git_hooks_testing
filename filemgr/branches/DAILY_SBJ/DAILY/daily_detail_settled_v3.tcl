#!/usr/local/bin/tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: daily_detail_settled_v3.tcl 4777 2018-11-30 17:46:57Z bjones $
# $Rev: 4777 $
################################################################################
#
#    File Name   -  daily_detail_settled_v3.tcl
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
   global clr_db cfg_file_name
   global argv mail_to mail_err

   set clr_db_logon ""
   set clr_db ""

   if { [info exists cfg_file_name] } {
         puts  " Config file argument: $cfg_file_name"
   } else {
          set cfg_file_name daily_detail_settled_v3.cfg
          puts  " Default Config File: $cfg_file_name"
   }

   if {[catch {open $cfg_file_name r} file_ptr]} {
        puts  " *** File Open Err: Cannot open config file $cfg_file_name"
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
            puts  " mail_to: $mail_to"
         }
         default {
            puts  "Unknown config parameter [lindex $line_parms 0]"
         }
      }
   }
   close $file_ptr

   if {$clr_db_logon == ""} {
       puts  "Unable to find CLR_DB_LOGON params in $cfg_file_name, exiting..."
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
        MASCLR::log_message  "Encountered error $result while trying to connect to CLR_DB"
        exit 1
   } else {
        MASCLR::log_message  " Connected to clr_db" 3
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
            MASCLR::log_message "opt: $opt, optarg: $optarg " 1
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
          set cycle "  != 2"
          MASCLR::log_message  " Default Cycle: $cycle" 2
          set cycle_passed "N"
    }
}

proc init_dates {val} {
     global date mydate filedate tomorrow yesterday report_ddate report_mdate report_mddate
     global report_yesterday_mddate report_DD curdate requested_date
     global reportDateDisp reportDateDispMTD
     global reportStartDateNetwork reportEndDateNetwork
     global clrDate clrDateMTD
     global masDate masDateMTD

     #~ val = 07-Jun-2017       --clock format [clock scan "-0 day"] -format %d-%b-%Y

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

     set reportDateDisp $filedate
     set reportDateDispMTD [clock format   [clock scan " $date -0 day"] -format %Y%m]01
     set reportStartDateNetwork [clock format [clock scan " $date -1 day"] -format %Y%m%d]170000
     set reportEndDateNetwork  [clock format [clock scan " $date -0 day"] -format %Y%m%d]165959

     set masDate $filedate
     set masDateMTD [clock format   [clock scan " $date -0 day"] -format %Y%m]01
     set clrDate [clock format [clock scan " $masDate -1 day"] -format %Y%m%d]
     set clrDateMTD [clock format [clock scan " $masDateMTD -1 day"] -format %Y%m%d]

     MASCLR::log_message " Generated Date:          $curdate" 3
     MASCLR::log_message " Requested Date:          $requested_date" 3
     MASCLR::log_message " Month_Year Date:         $mydate" 3
     MASCLR::log_message " Start Date:              $yesterday" 3
     MASCLR::log_message " End Date:                $tomorrow" 3
     MASCLR::log_message " reportDateDisp:          $reportDateDisp" 3
     MASCLR::log_message " reportDateDispMTD:       $reportDateDispMTD" 3
     MASCLR::log_message " reportStartDateNetwork:  $reportStartDateNetwork" 3
     MASCLR::log_message " reportEndDateNetwork:    $reportEndDateNetwork" 3
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

    # TODO use tid_adn table *** (daily sales returns & disputes)
    set IS_SALES "tid in ('010003005102', '010003005101', '010003005201', '010003005202',
                          '010003005104', '010003005204', '010003005103', '010003005203')"
    set IS_CHGBK "tid in ('010003015101', '010003015102', '010003015201', '010003015210', '010003015301',
                          '010003015511','010003015512')"
    set IS_REPR  "TID in ('010003005301', '010003005401','010003015521','010003015522')"
    set IS_ARB   "TID in ('010003010102', '010003010101')"
    set IS_OTHER "TID in ('010123005101', '010123005102')"

    set daily_sales_str "
    SELECT TO_CHAR( gl_date, 'DD') dd,
      nvl(sum(CASE WHEN( $IS_SALES and card_scheme = '02') then 1 end ), 0)                                       as DB_COUNT,
      nvl(sum(CASE WHEN( $IS_SALES and card_scheme = '03') then 1 end ), 0)                                       as AMEX_COUNT,
      nvl(sum(CASE WHEN( $IS_SALES and card_scheme = '04') then 1 end ), 0)                                       as VS_COUNT,
      nvl(sum(CASE WHEN( $IS_SALES and card_scheme = '05') then 1 end ), 0)                                       as MC_COUNT,
      nvl(sum(CASE WHEN( $IS_SALES and card_scheme = '08') then 1 end ), 0)                                       as DISC_COUNT,
      nvl(sum(CASE WHEN( $IS_SALES and card_scheme = '09') then 1 end ), 0)                                       as JCB_COUNT,

      nvl(sum(CASE WHEN( $IS_CHGBK                       ) then 1 end ), 0)                                       as CHR_COUNT,
      nvl(sum(CASE WHEN( $IS_CHGBK and card_scheme = '04') then 1 end ), 0)                                       as CHR_VS_COUNT,
      nvl(sum(CASE WHEN( $IS_CHGBK and card_scheme = '05') then 1 end ), 0)                                       as CHR_MC_COUNT,
      nvl(sum(CASE WHEN( $IS_CHGBK and card_scheme = '03') then 1 end ), 0)                                       as CHR_AX_COUNT,
      nvl(sum(CASE WHEN( $IS_CHGBK and card_scheme = '08') then 1 end ), 0)                                       as CHR_DS_COUNT,

      nvl(sum(CASE WHEN( $IS_REPR                        ) then 1 end ), 0)                                       as REP_COUNT,
      nvl(sum(CASE WHEN( $IS_REPR and card_scheme = '04' ) then 1 end ), 0)                                       as REP_VS_COUNT,
      nvl(sum(CASE WHEN( $IS_REPR and card_scheme = '05' ) then 1 end ), 0)                                       as REP_MC_COUNT,
      nvl(sum(CASE WHEN( $IS_REPR and card_scheme = '03' ) then 1 end ), 0)                                       as REP_AX_COUNT,
      nvl(sum(CASE WHEN( $IS_REPR and card_scheme = '08' ) then 1 end ), 0)                                       as REP_DS_COUNT,

      nvl(sum(CASE WHEN( $IS_ARB                         ) then 1 end ), 0)                                       as ARB_COUNT,
      nvl(sum(CASE WHEN( $IS_ARB and card_scheme = '04'  ) then 1 end ), 0)                                       as ARB_VS_COUNT,
      nvl(sum(CASE WHEN( $IS_ARB and card_scheme = '05'  ) then 1 end ), 0)                                       as ARB_MC_COUNT,
      nvl(sum(CASE WHEN( $IS_ARB and card_scheme = '03'  ) then 1 end ), 0)                                       as ARB_AX_COUNT,
      nvl(sum(CASE WHEN( $IS_ARB and card_scheme = '08'  ) then 1 end ), 0)                                       as ARB_DS_COUNT,

      nvl(sum(CASE WHEN( $IS_OTHER                       ) then 1 end ), 0)                                       as MISC_COUNT,

      nvl(sum(CASE WHEN( $IS_SALES and TID_SETTL_METHOD = 'C'  and card_scheme = '02') then AMT_ORIGINAL end), 0) as DB_AMOUNT,
      nvl(sum(CASE WHEN( $IS_SALES and TID_SETTL_METHOD = 'C'  and card_scheme = '03') then AMT_ORIGINAL end), 0) as AMEX_AMOUNT,
      nvl(sum(CASE WHEN( $IS_SALES and TID_SETTL_METHOD = 'C'  and card_scheme = '04') then AMT_ORIGINAL end), 0) as VS_AMOUNT,
      nvl(sum(CASE WHEN( $IS_SALES and TID_SETTL_METHOD = 'C'  and card_scheme = '05') then AMT_ORIGINAL end), 0) as MC_AMOUNT,
      nvl(sum(CASE WHEN( $IS_SALES and TID_SETTL_METHOD = 'C'  and card_scheme = '08') then AMT_ORIGINAL end), 0) as DISC_AMOUNT,
      nvl(sum(CASE WHEN( $IS_SALES and TID_SETTL_METHOD = 'C'  and card_scheme = '09') then AMT_ORIGINAL end), 0) as JCB_AMOUNT,

      nvl(sum(CASE WHEN( $IS_CHGBK and TID_SETTL_METHOD =  'C' )                       then AMT_ORIGINAL end), 0) as CHR_C_AMOUNT,
      nvl(sum(CASE WHEN( $IS_CHGBK and TID_SETTL_METHOD <> 'C' )                       then AMT_ORIGINAL end), 0) as CHR_D_AMOUNT,
      nvl(sum(CASE WHEN( $IS_CHGBK and TID_SETTL_METHOD =  'C' and card_scheme = '04') then AMT_ORIGINAL end), 0) as CHR_VS_C_AMOUNT,
      nvl(sum(CASE WHEN( $IS_CHGBK and TID_SETTL_METHOD <> 'C' and card_scheme = '04') then AMT_ORIGINAL end), 0) as CHR_VS_D_AMOUNT,
      nvl(sum(CASE WHEN( $IS_CHGBK and TID_SETTL_METHOD =  'C' and card_scheme = '05') then AMT_ORIGINAL end), 0) as CHR_MC_C_AMOUNT,
      nvl(sum(CASE WHEN( $IS_CHGBK and TID_SETTL_METHOD <> 'C' and card_scheme = '05') then AMT_ORIGINAL end), 0) as CHR_MC_D_AMOUNT,
      nvl(sum(CASE WHEN( $IS_CHGBK and TID_SETTL_METHOD =  'C' and card_scheme = '03') then AMT_ORIGINAL end), 0) as CHR_AX_C_AMOUNT,
      nvl(sum(CASE WHEN( $IS_CHGBK and TID_SETTL_METHOD <> 'C' and card_scheme = '03') then AMT_ORIGINAL end), 0) as CHR_AX_D_AMOUNT,
      nvl(sum(CASE WHEN( $IS_CHGBK and TID_SETTL_METHOD =  'C' and card_scheme = '08') then AMT_ORIGINAL end), 0) as CHR_DS_C_AMOUNT,
      nvl(sum(CASE WHEN( $IS_CHGBK and TID_SETTL_METHOD <> 'C' and card_scheme = '08') then AMT_ORIGINAL end), 0) as CHR_DS_D_AMOUNT,

      nvl(sum(CASE WHEN( $IS_REPR  and TID_SETTL_METHOD =  'C' )                       then AMT_ORIGINAL end), 0) as REP_C_AMOUNT,
      nvl(sum(CASE WHEN( $IS_REPR  and TID_SETTL_METHOD <> 'C' )                       then AMT_ORIGINAL end), 0) as REP_D_AMOUNT,
      nvl(sum(CASE WHEN( $IS_REPR  and TID_SETTL_METHOD =  'C' and card_scheme = '04') then AMT_ORIGINAL end), 0) as REP_VS_C_AMOUNT,
      nvl(sum(CASE WHEN( $IS_REPR  and TID_SETTL_METHOD <> 'C' and card_scheme = '04') then AMT_ORIGINAL end), 0) as REP_VS_D_AMOUNT,
      nvl(sum(CASE WHEN( $IS_REPR  and TID_SETTL_METHOD =  'C' and card_scheme = '05') then AMT_ORIGINAL end), 0) as REP_MC_C_AMOUNT,
      nvl(sum(CASE WHEN( $IS_REPR  and TID_SETTL_METHOD <> 'C' and card_scheme = '05') then AMT_ORIGINAL end), 0) as REP_MC_D_AMOUNT,
      nvl(sum(CASE WHEN( $IS_REPR  and TID_SETTL_METHOD =  'C' and card_scheme = '03') then AMT_ORIGINAL end), 0) as REP_AX_C_AMOUNT,
      nvl(sum(CASE WHEN( $IS_REPR  and TID_SETTL_METHOD <> 'C' and card_scheme = '03') then AMT_ORIGINAL end), 0) as REP_AX_D_AMOUNT,
      nvl(sum(CASE WHEN( $IS_REPR  and TID_SETTL_METHOD =  'C' and card_scheme = '08') then AMT_ORIGINAL end), 0) as REP_DS_C_AMOUNT,
      nvl(sum(CASE WHEN( $IS_REPR  and TID_SETTL_METHOD <> 'C' and card_scheme = '08') then AMT_ORIGINAL end), 0) as REP_DS_D_AMOUNT,

      nvl(sum(CASE WHEN( $IS_ARB   and TID_SETTL_METHOD =  'C' )                       then AMT_ORIGINAL end), 0) as ARB_C_AMOUNT,
      nvl(sum(CASE WHEN( $IS_ARB   and TID_SETTL_METHOD <> 'C' )                       then AMT_ORIGINAL end), 0) as ARB_D_AMOUNT,
      nvl(sum(CASE WHEN( $IS_ARB   and TID_SETTL_METHOD =  'C' and card_scheme = '04') then AMT_ORIGINAL end), 0) as ARB_VS_C_AMOUNT,
      nvl(sum(CASE WHEN( $IS_ARB   and TID_SETTL_METHOD <> 'C' and card_scheme = '04') then AMT_ORIGINAL end), 0) as ARB_VS_D_AMOUNT,
      nvl(sum(CASE WHEN( $IS_ARB   and TID_SETTL_METHOD =  'C' and card_scheme = '05') then AMT_ORIGINAL end), 0) as ARB_MC_C_AMOUNT,
      nvl(sum(CASE WHEN( $IS_ARB   and TID_SETTL_METHOD <> 'C' and card_scheme = '05') then AMT_ORIGINAL end), 0) as ARB_MC_D_AMOUNT,
      nvl(sum(CASE WHEN( $IS_ARB   and TID_SETTL_METHOD =  'C' and card_scheme = '03') then AMT_ORIGINAL end), 0) as ARB_AX_C_AMOUNT,
      nvl(sum(CASE WHEN( $IS_ARB   and TID_SETTL_METHOD <> 'C' and card_scheme = '03') then AMT_ORIGINAL end), 0) as ARB_AX_D_AMOUNT,
      nvl(sum(CASE WHEN( $IS_ARB   and TID_SETTL_METHOD =  'C' and card_scheme = '08') then AMT_ORIGINAL end), 0) as ARB_DS_C_AMOUNT,
      nvl(sum(CASE WHEN( $IS_ARB   and TID_SETTL_METHOD <> 'C' and card_scheme = '08') then AMT_ORIGINAL end), 0) as ARB_DS_D_AMOUNT,

      nvl(sum(CASE WHEN( $IS_OTHER and TID_SETTL_METHOD =  'C' )                       then AMT_ORIGINAL end), 0) as MISC_C_AMOUNT,
      nvl(sum(CASE WHEN( $IS_OTHER and TID_SETTL_METHOD <> 'C' )                       then AMT_ORIGINAL end), 0) as MISC_D_AMOUNT,
      nvl(sum(CASE WHEN( $IS_SALES and TID_SETTL_METHOD <> 'C' and card_scheme = '02') then AMT_ORIGINAL end), 0) as DB_REFUND_AMOUNT,
      nvl(sum(CASE WHEN( $IS_SALES and TID_SETTL_METHOD <> 'C' and card_scheme = '03') then AMT_ORIGINAL end), 0) as AMEX_REFUND_AMOUNT,
      nvl(sum(CASE WHEN( $IS_SALES and TID_SETTL_METHOD <> 'C' and card_scheme = '04') then AMT_ORIGINAL end), 0) as VS_REFUND_AMOUNT,
      nvl(sum(CASE WHEN( $IS_SALES and TID_SETTL_METHOD <> 'C' and card_scheme = '05') then AMT_ORIGINAL end), 0) as MC_REFUND_AMOUNT,
      nvl(sum(CASE WHEN( $IS_SALES and TID_SETTL_METHOD <> 'C' and card_scheme = '08') then AMT_ORIGINAL end), 0) as DISC_REFUND_AMOUNT,
      nvl(sum(CASE WHEN( $IS_SALES and TID_SETTL_METHOD <> 'C' and card_scheme = '09') then AMT_ORIGINAL end), 0) as JCB_REFUND_AMOUNT
    FROM mas_trans_log
    -- # TODO use tid_adn table *** (daily sales & disputes)
    WHERE institution_id in ($sql_inst)
      AND gl_date >= '01-$mydate'
      AND gl_date < '$tomorrow'
      AND settl_flag = 'Y'
    GROUP BY TO_CHAR( gl_date, 'DD')"

    orasql $daily_cursor $daily_sales_str

    MASCLR::log_message  "Daily Sales Query: \n*/\n\n$daily_sales_str;\n\n/*" 4

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

    MASCLR::log_message  "sales_str is done at [clock format [clock seconds]]" 3

###
#  Daily fees. We'll pull the entire month-to-date in order to retrieve m-t-d and
#  the day in question using a single query
###

    # TODO use tid_adn table (daily fees)
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
      nvl(sum(CASE WHEN( mtl.tid_settl_method =  'C' and card_scheme not in ('02', '03', '04', '05', '08', '12'))
               then AMT_ORIGINAL else 0 end), 0)                                                                  as OTHER_C_FEE,
      nvl(sum(CASE WHEN( mtl.tid_settl_method <> 'C' and card_scheme not in ('02', '03', '04', '05', '08', '12'))
               then AMT_ORIGINAL else 0 end), 0)                                                                  as OTHER_D_FEE,

      nvl(sum(CASE WHEN( mtl.TID_SETTL_METHOD =  'C' and $IS_CHGBK_FEES)
               then AMT_ORIGINAL else 0 end), 0)                                                                  as CHR_C_FEE,
      nvl(sum(CASE WHEN( mtl.TID_SETTL_METHOD <> 'C' and $IS_CHGBK_FEES)
               then AMT_ORIGINAL else 0 end), 0)                                                                  as CHR_D_FEE,

      nvl(sum(CASE WHEN(mtl.card_scheme = '04' and mtl.TID_SETTL_METHOD =  'C' and $IS_CHGBK_FEES)
               then AMT_ORIGINAL else  0 end), 0)                                                                 as CHR_VS_C_FEE,
      nvl(sum(CASE WHEN(mtl.card_scheme = '04' and mtl.TID_SETTL_METHOD <> 'C' and $IS_CHGBK_FEES)
               then AMT_ORIGINAL else  0 end), 0)                                                                 as CHR_VS_D_FEE,

      nvl(sum(CASE WHEN(mtl.card_scheme = '05' and mtl.TID_SETTL_METHOD =  'C' and $IS_CHGBK_FEES)
               then AMT_ORIGINAL else  0 end), 0)                                                                 as CHR_MC_C_FEE,
      nvl(sum(CASE WHEN(mtl.card_scheme = '05' and mtl.TID_SETTL_METHOD <> 'C' and $IS_CHGBK_FEES)
               then AMT_ORIGINAL else  0 end), 0)                                                                 as CHR_MC_D_FEE,

      nvl(sum(CASE WHEN(mtl.card_scheme = '03' and mtl.TID_SETTL_METHOD =  'C' and $IS_CHGBK_FEES)
               then AMT_ORIGINAL else  0 end), 0)                                                                 as CHR_AX_C_FEE,
      nvl(sum(CASE WHEN(mtl.card_scheme = '03' and mtl.TID_SETTL_METHOD <> 'C' and $IS_CHGBK_FEES)
               then AMT_ORIGINAL else  0 end), 0)                                                                 as CHR_AX_D_FEE,

      nvl(sum(CASE WHEN(mtl.card_scheme = '08' and mtl.TID_SETTL_METHOD =  'C' and $IS_CHGBK_FEES)
               then AMT_ORIGINAL else  0 end), 0)                                                                 as CHR_DS_C_FEE,
      nvl(sum(CASE WHEN(mtl.card_scheme = '08' and mtl.TID_SETTL_METHOD <> 'C' and $IS_CHGBK_FEES)
               then AMT_ORIGINAL else  0 end), 0)                                                                 as CHR_DS_D_FEE
        -- # TODO use tid_adn table
    FROM mas_trans_log mtl, (select PAYMENT_SEQ_NBR, PAYMENT_PROC_DT, institution_id
                             from  ACCT_ACCUM_DET
                             where PAYMENT_PROC_DT >= '01-$mydate' AND PAYMENT_PROC_DT < '$tomorrow'
                                 and institution_id in ($sql_inst)
                                 and payment_cycle $cycle
                                 and payment_status = 'P') aad
    WHERE (mtl.PAYMENT_SEQ_NBR = aad.PAYMENT_SEQ_NBR AND mtl.institution_id = aad.institution_id)
       AND mtl.institution_id in ($sql_inst)
       AND (substr(mtl.tid, 1,8) = '01000507' OR substr(mtl.tid, 1,6) in ('010004','010040','010050','010080','010014'))
       AND mtl.settl_flag = 'Y'
    GROUP BY TO_CHAR( aad.PAYMENT_PROC_DT, 'DD')"

    MASCLR::log_message  "Daily Fees Query: \n*/\n\n$daily_fees_str;\n\n/*" 3

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

    MASCLR::log_message  "daily_fees_str is done at [clock format [clock seconds]]" 3

###
# Beginning and end balance.
# NOTE: [ m.gl_date < '$tomorrow' ] used here to capture a snapshot of this report (as if
#       it was actually ran on the historical date). It Excludes data that came in after the date in question.
###

    # TODO use tid_adn table (payables)
    set IS_C "m.tid_settl_method  = 'C'"
    set IS_D "m.tid_settl_method <> 'C'"
    set NOT_PAID_YESTERDAY "(m.gl_date < '$date' and (aad.payment_status is null or trunc(aad.payment_proc_dt) > '$yesterday'))"
    set NOT_PAID_TODAY     "(m.gl_date < '$tomorrow' and (aad.payment_status is null or trunc(aad.payment_proc_dt) > '$date'))"

    set payables_qry "
    SELECT
      nvl(sum(CASE WHEN( $NOT_PAID_YESTERDAY and $IS_C ) then m.AMT_ORIGINAL end), 0) as BEGIN_PAYBL_BAL_C,
      nvl(sum(CASE WHEN( $NOT_PAID_YESTERDAY and $IS_D ) then m.AMT_ORIGINAL end), 0) as BEGIN_PAYBL_BAL_D,
      nvl(sum(CASE WHEN( $NOT_PAID_YESTERDAY )           then 1 else 0 end)      , 0) as BEGIN_PAYBL_BAL_COUNT,
      nvl(sum(CASE WHEN( $NOT_PAID_TODAY and $IS_C )     then m.AMT_ORIGINAL end), 0) as END_PAYBL_BAL_C,
      nvl(sum(CASE WHEN( $NOT_PAID_TODAY and $IS_D )     then m.AMT_ORIGINAL end), 0) as END_PAYBL_BAL_D,
      nvl(sum(CASE WHEN( $NOT_PAID_TODAY )               then 1 else 0 end)      , 0) as END_PAYBL_BAL_COUNT
    FROM mas_trans_log m, (select payment_seq_nbr, payment_proc_dt, payment_status, institution_id
                           from acct_accum_det
                           where  institution_id in ($sql_inst)
                                  and (payment_status is null
                                        or trunc(payment_proc_dt) > '$yesterday')
                        ) aad
    WHERE (m.payment_seq_nbr = aad.payment_seq_nbr AND m.institution_id = aad.institution_id)
      AND m.institution_id in ($sql_inst)
      AND m.SETTL_FLAG = 'Y'
      AND (m.tid in (
              '010003005101', '010003005102', '010003005301', '010003010102',
              '010003010101', '010003005103', '010003005203'
            )
        )
      AND m.gl_date < '$tomorrow'"

    MASCLR::log_message  "Payable Query: \n*/\n\n$payables_qry;\n\n/*" 3

    set skip_payables "Y"

    if { $skip_payables == "Y" } {
        set BEGIN_PAYBL_BAL       0
        set BEGIN_PAYBL_BAL_COUNT 0
        set END_PAYBL_BAL         0
        set END_PAYBL_BAL_COUNT   0
        MASCLR::log_message  "Payables query skipped" 3
    } else {

        orasql $daily_cursor $payables_qry

        while {[orafetch $daily_cursor -dataarray dscnt -indexbyname] != 1403} {
          set BEGIN_PAYBL_BAL       [expr $dscnt(BEGIN_PAYBL_BAL_D) - $dscnt(BEGIN_PAYBL_BAL_C) ]
          set BEGIN_PAYBL_BAL_COUNT       $dscnt(BEGIN_PAYBL_BAL_COUNT)
          set END_PAYBL_BAL         [expr $dscnt(END_PAYBL_BAL_D)   -  $dscnt(END_PAYBL_BAL_C) ]
          set END_PAYBL_BAL_COUNT         $dscnt(END_PAYBL_BAL_COUNT)
        }
        MASCLR::log_message  "Begin and end payables balance is done at [clock format [clock seconds]]" 3
    }

###
#   Reserves
###

    # TODO use tid_adn table (reserves)
    set IS_ADDED_RES "substr(mtl.tid,1,8) = '01000505'"

# this needs to be specified because the new 010007050100 are accompanied by
# an added negative 010007050000 record so we leave the 010007050100 out cause its already considered

    # TODO use tid_adn table (reserves)
    set IS_RES_NOT_PAID "mtl.tid = '010007050000'"

# this is different because the old releases were the existing 010007050000 records
# and the new releases are added 010007050100 records. They can both appear on the ACH as paid out.

    # TODO use tid_adn table (reserves)
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
    -- # TODO use tid_adn table (reserves)
    WHERE (mtl.payment_seq_nbr = aad.payment_seq_nbr AND mtl.institution_id = aad.institution_id)
      AND mtl.institution_id in ($sql_inst)
      AND mtl.gl_date < '$tomorrow'
      AND (substr(mtl.tid,1,8) = '01000705' or substr(mtl.tid,1,8) = '01000505')"

    MASCLR::log_message  "Reserve Query: \n*/\n\n$res_qry;\n\n/*" 3

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
        select nvl(sum(amt_fee), 0) as FEE, nvl(sum(amt_pay), 0) as PAYMENT, count(1) as ACH_COUNT
        from ACCT_ACCUM_DET
        where [IS_cur_day PAYMENT_PROC_DT]
          and institution_id in ($sql_inst)
          and payment_cycle $cycle "

    orasql $daily_cursor $query_string_ach

    while {[orafetch $daily_cursor -dataarray ach -indexbyname] != 1403} {
            set ACH_AMOUNT [expr $ach(FEE) - $ach(PAYMENT)]
            set ACH_COUNT        $ach(ACH_COUNT)
    }

    MASCLR::log_message  "ACH Query: \n*/\n\n$query_string_ach;\n\n/*" 3

    MASCLR::log_message  "query_string_ach is done at [clock format [clock seconds]]" 3

    set query_string "
        select nvl(sum(amt_fee), 0) as MFEE,
               nvl(sum(amt_pay), 0) as MPAYMENT,
               count(1)     as MACH_COUNT
        from  ACCT_ACCUM_DET
        where PAYMENT_PROC_DT >= trunc(TO_DATE( '$date', 'DD-MON-YY' ),'MM')
          and PAYMENT_PROC_DT < '$tomorrow'
          and institution_id in ($sql_inst)
          and payment_cycle $cycle"

    orasql $daily_cursor $query_string

    while {[orafetch $daily_cursor -dataarray mach -indexbyname] != 1403} {
            set MACH_AMOUNT [expr $mach(MFEE) - $mach(MPAYMENT)]
            set MACH_COUNT        $mach(MACH_COUNT)
    }

    MASCLR::log_message  "query_string is done at [clock format [clock seconds]]" 3

#*******    Pull the reject counts and amounts  *******#

    # TODO use tid_adn table (rejects)
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

    set skip_rejects "Y"

    if { $skip_rejects == "Y" } {
    } else {
        orasql $daily_cursor $query_string

        MASCLR::log_message "Rejects Query: \n*/\n\n$query_string;\n\n/*" 3

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
    }

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

    # TODO use tid_adn table (rejects)
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

    if { $skip_rejects == "Y" } {

    } else {
        orasql $daily_cursor $reject_mtd

        MASCLR::log_message  "Rejects Query: \n*/\n\n$reject_mtd;\n\n/*" 3

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
    }

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
#       puts $cur_file "TE,0.00,0.00,0.00,0.00,,0.00,0.00,0.00,0.00"
        puts $cur_file "JCB,$JCB_COUNT,$[roundOff $JCB_AMOUNT],$[roundOff $JCB_FEE],$[roundOff $JCB_TOTAL],,$MJCB_COUNT,$[roundOff $MJCB_AMOUNT],$[roundOff $MJCB_FEE],$[roundOff $MJCB_TOTAL]"
        puts $cur_file "DBT,$DB_COUNT,$[roundOff $DB_AMOUNT],$[roundOff $DB_FEE],$[roundOff $DB_TOTAL],,$MDB_COUNT,$[roundOff $MDB_AMOUNT],$[roundOff $MDB_FEE],$[roundOff $MDB_TOTAL]"
        #~ puts $cur_file "EBT,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
        getDbtByNetwork
        puts $cur_file "MISC ADJ ,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
        puts $cur_file "OTHER,$OTHER_COUNT,\$0,$[roundOff $OTHER_FEE],$[roundOff $OTHER_FEE],,$MOTHER_COUNT,\$0,$[roundOff $MOTHER_FEE],$[roundOff $MOTHER_FEE]"
        puts $cur_file "SUBTOTAL,$D_SUB_SCNT,$[roundOff $D_SUB_SAMT],$[roundOff $D_SUB_FAMT],$[roundOff $D_SUB_ACCTEFFECT],,$M_SUB_SCNT,$[roundOff $M_SUB_SAMT],\
                        $[roundOff $M_SUB_FAMT],$[roundOff $M_SUB_ACCTEFFECT]"
        puts $cur_file " "
        puts $cur_file "REJECTS:"

        getRejects "Today"
        getRejects "MTD"
        #~ puts $cur_file "SUBTOTAL,$REJECT_COUNT,$[roundOff $REPROCESSED_REJECT],0.00,$[roundOff $REPROCESSED_REJECT],,$MTD_REJECT_COUNT,\
                                $[roundOff $MTD_REPROCESSED_REJECT],0.00,$[roundOff $MTD_REPROCESSED_REJECT]"
        puts $cur_file " "
        puts $cur_file "MISC ADJ: "
        puts $cur_file "SUBTOTAL,$MISC_COUNT,$[roundOff $MISC_AMOUNT],0.00,$[roundOff $MISC_AMOUNT],,$MMISC_COUNT,$[roundOff $MMISC_AMOUNT],$MMISC_COUNT,$[roundOff $MMISC_AMOUNT]"
        puts $cur_file " "

        puts $cur_file " "

        puts $cur_file "Disputes processed into Clearing yesterday:"
        puts $cur_file "Chargebacks:"
        getChargebacksFromClearing "Today"
        getChargebacksFromClearing "MTD"
        puts $cur_file " "

        puts $cur_file "Representments:"
        getRepresentmentsFromClearing "Today"
        getRepresentmentsFromClearing "MTD"
        puts $cur_file " "

        puts $cur_file "Arbitrations:"
        getArbitrationsFromClearing "Today"
        getArbitrationsFromClearing "MTD"
        puts $cur_file " "

        puts $cur_file "Disputes processed into MAS today:"
        puts $cur_file "Chargebacks:"
        getChargebacksFromMAS "Today"
        #~ puts "#####################################Chargebacks today done#####################################"
        getChargebacksFromMAS "MTD"
        #~ puts "#####################################Chargebacks MTD done#####################################"
        puts $cur_file " "

        puts $cur_file "Representments:"
        getRepresentmentsFromMAS "Today"
        #~ puts "#####################################Representments today done#####################################"
        getRepresentmentsFromMAS "MTD"
        #~ puts "#####################################Representments MTD done#####################################"
        puts $cur_file " "

        puts $cur_file "Arbitrations:"
        getArbitrationsFromMAS "Today"
        #~ puts "#####################################Arbitrations today done#####################################"
        getArbitrationsFromMAS "MTD"
        #~ puts "#####################################Arbitrations MTD done#####################################"
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
         puts $cur_file "Begining Payable Balance,$report_yesterday_mddate,,,$[roundOff $BEGIN_PAYBL_BAL]"
         puts $cur_file "Account Effect:,,,,$[roundOff [expr $END_PAYBL_BAL - $BEGIN_PAYBL_BAL]]"
         puts $cur_file "Ending Payable Balance,$report_mddate,,,$[roundOff $END_PAYBL_BAL]"

         puts $cur_file " "
         puts $cur_file "Begining Reserve Balance,$report_yesterday_mddate,,,$[roundOff $BEGIN_RESERVE]"
         puts $cur_file "Account Effect:,,,,$[roundOff [expr $ENDING_RESERVE - $BEGIN_RESERVE]]"
         puts $cur_file "Ending Reserve Balance,$report_mddate,,,$[roundOff $ENDING_RESERVE]"
    }
}

proc roundOff {number} {
    return "[expr {double(round(100*$number))/100}]"
}

proc getRejects {dateID} {
    global daily_cursor
    global sql_inst
    global cur_file
    global REJECT_COUNT REJECT_AMOUNT REJECT_FEE MREJECT_COUNT MREJECT_AMOUNT MREJECT_FEE
    #~ DISP_FEE DISP_VS_COUNT DISP_MC_COUNT DISP_AX_COUNT DISP_DS_COUNT DISP_VS_AMOUNT DISP_MC_AMOUNT DISP_AX_AMOUNT DISP_DS_AMOUNT DISP_VS_FEE DISP_MC_FEE DISP_AX_FEE DISP_DS_FEE MDISP_COUNT MDISP_AMOUNT MDISP_FEE MDISP_VS_COUNT MDISP_MC_COUNT MDISP_AX_COUNT MDISP_DS_COUNT MDISP_VS_AMOUNT MDISP_MC_AMOUNT MDISP_AX_AMOUNT MDISP_DS_AMOUNT MDISP_VS_FEE MDISP_MC_FEE MDISP_AX_FEE MDISP_DS_FEE
    global reportDateDisp reportDateDispMTD

    set reportStartDate $reportDateDisp
    set reportEndDate $reportDateDisp

    if { ( $dateID == "MTD" ) } {
        set reportStartDate $reportDateDispMTD
    } else {
        set    REJECT_COUNT            0
        set    REJECT_AMOUNT           0
        set    REJECT_FEE              0

        set    MREJECT_COUNT            0
        set    MREJECT_AMOUNT           0
        set    MREJECT_FEE              0
    }
    # TODO use tid_adn table (rejects)
    set rejectsQuery "select count(*) as count,
                        in_draft_main.pri_dest_inst_id as inst,
                        in_draft_main.tid as tid,
                        tid.TID_SETTL_METHOD as D_C,
                        --in_draft_main.card_scheme as CARD_TYPE,
                        sum(in_draft_main.amt_trans)/100 as amount
                      from in_draft_main, card_scheme, tid
                      where in_draft_main.card_scheme = card_scheme.card_scheme AND
                        in_draft_main.tid = tid.tid AND
                        in_draft_main.tid like '010123005%' AND
                        in_draft_main.pri_dest_inst_id = '$sql_inst' AND
                        in_draft_main.in_file_nbr in (
                            select in_file_nbr from in_file_log
                            where
                                incoming_dt >= to_date($reportStartDate,'YYYYMMDD') and
                                incoming_dt <  to_date($reportEndDate,'YYYYMMDD') + 1 AND
                                institution_id in ('04','05','03','08'))
                      group by in_draft_main.pri_dest_inst_id,
                        in_draft_main.tid,
                        --in_draft_main.card_scheme,
                        tid.TID_SETTL_METHOD"

    orasql $daily_cursor $rejectsQuery

    MASCLR::log_message "Rejects Query: \n*/\n\n$rejectsQuery;\n\n/*" 3

    while {[orafetch $daily_cursor -dataarray row -indexbyname] != 1403} {
        if { ( $dateID != "MTD" ) } {
                set REJECT_COUNT [expr $REJECT_COUNT + $row(COUNT)]
                if { ( $row(D_C) == "C" ) } {
                    set REJECT_AMOUNT [expr $REJECT_AMOUNT + $row(AMOUNT)]
                } else {
                    set REJECT_AMOUNT [expr $REJECT_AMOUNT - $row(AMOUNT)]
                }
            } else {
                set MREJECT_COUNT [expr $MREJECT_COUNT + $row(COUNT)]
                if { ( $row(D_C) == "C" ) } {
                    set MREJECT_AMOUNT [expr $MREJECT_AMOUNT + $row(AMOUNT)]
                } else {
                    set MREJECT_AMOUNT [expr $MREJECT_AMOUNT - $row(AMOUNT)]
                }
            }
    }

    if { ( $dateID == "MTD" ) } {
         puts $cur_file "Subtotal,$REJECT_COUNT,$[roundOff $REJECT_AMOUNT],$[roundOff $REJECT_FEE],$[roundOff $REJECT_AMOUNT],,\
                            $MREJECT_COUNT,$[roundOff $MREJECT_AMOUNT],$[roundOff $MREJECT_FEE],$[roundOff $MREJECT_AMOUNT]"
    }
}

proc resetDispVariables {} {
    global DISP_COUNT DISP_AMOUNT DISP_FEE DISP_VS_COUNT DISP_MC_COUNT DISP_AX_COUNT DISP_DS_COUNT DISP_VS_AMOUNT DISP_MC_AMOUNT DISP_AX_AMOUNT DISP_DS_AMOUNT DISP_VS_FEE DISP_MC_FEE DISP_AX_FEE DISP_DS_FEE MDISP_COUNT MDISP_AMOUNT MDISP_FEE MDISP_VS_COUNT MDISP_MC_COUNT MDISP_AX_COUNT MDISP_DS_COUNT MDISP_VS_AMOUNT MDISP_MC_AMOUNT MDISP_AX_AMOUNT MDISP_DS_AMOUNT MDISP_VS_FEE MDISP_MC_FEE MDISP_AX_FEE MDISP_DS_FEE

    set    DISP_COUNT            0
    set    DISP_AMOUNT           0
    set    DISP_FEE              0

    set    DISP_VS_COUNT         0
    set    DISP_MC_COUNT         0
    set    DISP_AX_COUNT         0
    set    DISP_DS_COUNT         0

    set    DISP_VS_AMOUNT        0
    set    DISP_MC_AMOUNT        0
    set    DISP_AX_AMOUNT        0
    set    DISP_DS_AMOUNT        0

    set    DISP_VS_FEE           0
    set    DISP_MC_FEE           0
    set    DISP_AX_FEE           0
    set    DISP_DS_FEE           0

    set    MDISP_COUNT           0
    set    MDISP_AMOUNT          0
    set    MDISP_FEE             0

    set    MDISP_VS_COUNT        0
    set    MDISP_MC_COUNT        0
    set    MDISP_AX_COUNT        0
    set    MDISP_DS_COUNT        0

    set    MDISP_VS_AMOUNT       0
    set    MDISP_MC_AMOUNT       0
    set    MDISP_AX_AMOUNT       0
    set    MDISP_DS_AMOUNT       0

    set    MDISP_VS_FEE          0
    set    MDISP_MC_FEE          0
    set    MDISP_AX_FEE          0
    set    MDISP_DS_FEE          0
}

proc writeDisputesToFile {} {
    global DISP_COUNT DISP_AMOUNT DISP_FEE DISP_VS_COUNT DISP_MC_COUNT DISP_AX_COUNT DISP_DS_COUNT DISP_VS_AMOUNT DISP_MC_AMOUNT DISP_AX_AMOUNT DISP_DS_AMOUNT DISP_VS_FEE DISP_MC_FEE DISP_AX_FEE DISP_DS_FEE MDISP_COUNT MDISP_AMOUNT MDISP_FEE MDISP_VS_COUNT MDISP_MC_COUNT MDISP_AX_COUNT MDISP_DS_COUNT MDISP_VS_AMOUNT MDISP_MC_AMOUNT MDISP_AX_AMOUNT MDISP_DS_AMOUNT MDISP_VS_FEE MDISP_MC_FEE MDISP_AX_FEE MDISP_DS_FEE
    global cur_file

    puts $cur_file "Visa,$DISP_VS_COUNT,$[roundOff $DISP_VS_AMOUNT],$[roundOff $DISP_VS_FEE],$[roundOff $DISP_VS_AMOUNT],,\
                            $MDISP_VS_COUNT,$[roundOff $MDISP_VS_AMOUNT],$[roundOff $MDISP_VS_FEE],$[roundOff $MDISP_VS_AMOUNT]"

    puts $cur_file "MC,$DISP_MC_COUNT,$[roundOff $DISP_MC_AMOUNT],$[roundOff $DISP_MC_FEE],$[roundOff $DISP_MC_AMOUNT],,\
                        $MDISP_MC_COUNT,$[roundOff $MDISP_MC_AMOUNT],$[roundOff $MDISP_MC_FEE],$[roundOff $MDISP_MC_AMOUNT]"

    puts $cur_file "Amex,$DISP_AX_COUNT,$[roundOff $DISP_AX_AMOUNT],$[roundOff $DISP_AX_FEE],$[roundOff $DISP_AX_AMOUNT],,\
                        $MDISP_AX_COUNT,$[roundOff $MDISP_AX_AMOUNT],$[roundOff $MDISP_AX_FEE],$[roundOff $MDISP_AX_AMOUNT]"

    puts $cur_file "Disc,$DISP_DS_COUNT,$[roundOff $DISP_DS_AMOUNT],$[roundOff $DISP_DS_FEE],$[roundOff $DISP_DS_AMOUNT],,\
                        $MDISP_DS_COUNT,$[roundOff $MDISP_DS_AMOUNT],$[roundOff $MDISP_DS_FEE],$[roundOff $MDISP_DS_AMOUNT]"

    puts $cur_file "Subtotal,$DISP_COUNT,$[roundOff $DISP_AMOUNT],$[roundOff $DISP_FEE],$[roundOff $DISP_AMOUNT],,\
                        $MDISP_COUNT,$[roundOff $MDISP_AMOUNT],$[roundOff $MDISP_FEE],$[roundOff $MDISP_AMOUNT]"
}

proc getChargebacksFromClearing {dateID} {
    global daily_cursor
    global sql_inst
    global cur_file
    global DISP_COUNT DISP_AMOUNT DISP_FEE DISP_VS_COUNT DISP_MC_COUNT DISP_AX_COUNT DISP_DS_COUNT DISP_VS_AMOUNT DISP_MC_AMOUNT DISP_AX_AMOUNT DISP_DS_AMOUNT DISP_VS_FEE DISP_MC_FEE DISP_AX_FEE DISP_DS_FEE MDISP_COUNT MDISP_AMOUNT MDISP_FEE MDISP_VS_COUNT MDISP_MC_COUNT MDISP_AX_COUNT MDISP_DS_COUNT MDISP_VS_AMOUNT MDISP_MC_AMOUNT MDISP_AX_AMOUNT MDISP_DS_AMOUNT MDISP_VS_FEE MDISP_MC_FEE MDISP_AX_FEE MDISP_DS_FEE
    global reportDateDisp reportDateDispMTD
    global clrDate clrDateMTD

    set reportStartDate $clrDate
    set reportEndDate $clrDate

    if { ( $dateID == "MTD" ) } {
        set reportStartDate $clrDateMTD
    } else {
        resetDispVariables
    }

    set chargebackQuery "
        select substr(idm.sec_dest_inst_id,1,4) as Inst,
               substr(cs.card_scheme_name,1,10) as Card_Type,
               count(idm.trans_seq_nbr) as Count,
               sum(idm.amt_recon)/100 as Amount,
               idm.recon_ccd as Currency,
               ta.minor_cat as Dispute_Type,
               substr(t.description,1,30) as description,
               t.TID_SETTL_METHOD as D_C
        from in_draft_main idm
             join in_file_log ifl
             on ifl.in_file_nbr = idm.in_file_nbr
             join card_scheme cs
             ON idm.CARD_SCHEME    = cs.CARD_SCHEME
             join tid t
             on idm.tid = t.tid
             left outer join tid_adn ta
             on idm.tid = ta.tid and ta.usage = 'CLR'
        where (idm.sec_dest_inst_id = '$sql_inst' OR
              idm.pri_dest_inst_id = '$sql_inst' ) AND
              ta.major_cat = 'DISPUTES' AND
              ta.minor_cat = 'CHARGEBACK' AND
              (substr(idm.pan,1,1) not in ('x','0','') OR idm.pan is not NULL) AND
              incoming_dt >= to_date($reportStartDate,'YYYYMMDD') and
              incoming_dt <  to_date($reportEndDate,'YYYYMMDD') + 1
              and ifl.institution_id in ('04','05','03','08')
        group by substr(idm.sec_dest_inst_id,1,4),
                 substr(cs.card_scheme_name,1,10),
                 idm.recon_ccd,
                 ta.minor_cat,
                 substr(t.description,1,30),
                 t.TID_SETTL_METHOD
        order by substr(idm.sec_dest_inst_id,1,4),
                 substr(cs.card_scheme_name,1,10),
                 idm.recon_ccd,
                 ta.minor_cat,
                 substr(t.description,1,30)"

    orasql $daily_cursor $chargebackQuery

    MASCLR::log_message "Chargebacks Query: \n*/\n\n$chargebackQuery;\n\n/*" 3

    while {[orafetch $daily_cursor -dataarray row -indexbyname] != 1403} {
        set cardType $row(CARD_TYPE)
        if { ( $cardType == "VISA" ) } {
            if { ( $dateID != "MTD" ) } {
                set DISP_VS_COUNT [expr $DISP_VS_COUNT + $row(COUNT)]
                set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) != "C" ) } {
                    set DISP_VS_AMOUNT [expr $DISP_VS_AMOUNT + $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set DISP_VS_AMOUNT [expr $DISP_VS_AMOUNT - $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT - $row(AMOUNT)]
                }
            } else {
                set MDISP_VS_COUNT [expr $MDISP_VS_COUNT + $row(COUNT)]
                set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) != "C" ) } {
                    set MDISP_VS_AMOUNT [expr $MDISP_VS_AMOUNT + $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set MDISP_VS_AMOUNT [expr $MDISP_VS_AMOUNT - $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT - $row(AMOUNT)]
                }
            }
        }
        if { ( $cardType == "MasterCard" ) } {
            if { ( $dateID != "MTD" ) } {
                set DISP_MC_COUNT [expr $DISP_MC_COUNT + $row(COUNT)]
                set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) != "C" ) } {
                    set DISP_MC_AMOUNT [expr $DISP_MC_AMOUNT + $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set DISP_MC_AMOUNT [expr $DISP_MC_AMOUNT - $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT - $row(AMOUNT)]
                }
            } else {
                set MDISP_MC_COUNT [expr $MDISP_MC_COUNT + $row(COUNT)]
                set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) != "C" ) } {
                    set MDISP_MC_AMOUNT [expr $MDISP_MC_AMOUNT + $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set MDISP_MC_AMOUNT [expr $MDISP_MC_AMOUNT - $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT - $row(AMOUNT)]
                }
            }
        }
        if { ( $cardType == "AMEX" ) } {
            if { ( $dateID != "MTD" ) } {
                set DISP_AX_COUNT [expr $DISP_AX_COUNT + $row(COUNT)]
                set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) != "C" ) } {
                    set DISP_AX_AMOUNT [expr $DISP_AX_AMOUNT + $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set DISP_AX_AMOUNT [expr $DISP_AX_AMOUNT - $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT - $row(AMOUNT)]
                }
            } else {
                set MDISP_AX_COUNT [expr $MDISP_AX_COUNT + $row(COUNT)]
                set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) != "C" ) } {
                    set MDISP_AX_AMOUNT [expr $MDISP_AX_AMOUNT + $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set MDISP_AX_AMOUNT [expr $MDISP_AX_AMOUNT - $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT - $row(AMOUNT)]
                }
            }
        }
        if { ( $cardType == "Discover" ) } {
            if { ( $dateID != "MTD" ) } {
                set DISP_DS_COUNT [expr $DISP_DS_COUNT + $row(COUNT)]
                set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) != "C" ) } {
                    set DISP_DS_AMOUNT [expr $DISP_DS_AMOUNT + $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set DISP_DS_AMOUNT [expr $DISP_DS_AMOUNT - $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT - $row(AMOUNT)]
                }
            } else {
                set MDISP_DS_COUNT [expr $MDISP_DS_COUNT + $row(COUNT)]
                set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) != "C" ) } {
                    set MDISP_DS_AMOUNT [expr $MDISP_DS_AMOUNT + $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set MDISP_DS_AMOUNT [expr $MDISP_DS_AMOUNT - $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT - $row(AMOUNT)]
                }
            }
        }
    }
    if { ( $dateID == "MTD" ) } {
         writeDisputesToFile
    }
}

proc getRepresentmentsFromClearing {dateID} {
    global daily_cursor
    global sql_inst
    global cur_file
    global DISP_COUNT DISP_AMOUNT DISP_FEE DISP_VS_COUNT DISP_MC_COUNT DISP_AX_COUNT DISP_DS_COUNT DISP_VS_AMOUNT DISP_MC_AMOUNT DISP_AX_AMOUNT DISP_DS_AMOUNT DISP_VS_FEE DISP_MC_FEE DISP_AX_FEE DISP_DS_FEE MDISP_COUNT MDISP_AMOUNT MDISP_FEE MDISP_VS_COUNT MDISP_MC_COUNT MDISP_AX_COUNT MDISP_DS_COUNT MDISP_VS_AMOUNT MDISP_MC_AMOUNT MDISP_AX_AMOUNT MDISP_DS_AMOUNT MDISP_VS_FEE MDISP_MC_FEE MDISP_AX_FEE MDISP_DS_FEE
    global reportDateDisp reportDateDispMTD
    global clrDate clrDateMTD

    set reportStartDate $clrDate
    set reportEndDate $clrDate

    if { ( $dateID == "MTD" ) } {
        set reportStartDate $clrDateMTD
    } else {
        resetDispVariables
    }

    set representmentQuery "select substr(in_draft_main.sec_dest_inst_id,1,4) as Inst,
       substr(card_scheme.card_scheme_name,1,10) as Card_Type,
       count(in_draft_main.trans_seq_nbr) as Count,
       sum(in_draft_main.amt_trans)/100 as Amount,
       in_draft_main.trans_ccd as Currency,
       tid_adn.minor_cat as Dispute_Type,
       substr(tid.description,1,30) as description,
       tid.TID_SETTL_METHOD as D_C
    from card_scheme,
        tid,
        tid_adn,
        in_draft_main
    where in_draft_main.card_scheme = card_scheme.card_scheme AND
        in_draft_main.tid = tid.tid AND
        in_draft_main.tid = tid_adn.tid AND
        tid_adn.major_cat = 'DISPUTES' AND
        tid_adn.minor_cat = 'REPRESENTMENT' AND
        (substr(in_draft_main.pan,1,1) not in ('x','0','') OR
        in_draft_main.pan is not NULL) AND
        (in_draft_main.sec_dest_inst_id = '$sql_inst' OR
        in_draft_main.pri_dest_inst_id = '$sql_inst' )  AND
        in_draft_main.in_file_nbr in (
        select in_file_nbr from in_file_log
        where
        incoming_dt >= to_date($reportStartDate,'YYYYMMDD') and
        incoming_dt <  to_date($reportEndDate,'YYYYMMDD') + 1
        and institution_id in ('02','03','08'))
    group by substr(in_draft_main.sec_dest_inst_id,1,4),
            substr(card_scheme.card_scheme_name,1,10),
            in_draft_main.trans_ccd,
            tid_adn.minor_cat,
            substr(tid.description,1,30),
        tid.TID_SETTL_METHOD
    order by substr(in_draft_main.sec_dest_inst_id,1,4),
            substr(card_scheme.card_scheme_name,1,10),
            in_draft_main.trans_ccd,
            tid_adn.minor_cat,
            substr(tid.description,1,30)"

    orasql $daily_cursor $representmentQuery

    MASCLR::log_message  "Representment Query Clearing($dateID): \n*/\n\n$representmentQuery" 3

    while {[orafetch $daily_cursor -dataarray row -indexbyname] != 1403} {
        set cardType $row(CARD_TYPE)
        if { ( $cardType == "VISA" ) } {
            if { ( $dateID != "MTD" ) } {
                set DISP_VS_COUNT [expr $DISP_VS_COUNT + $row(COUNT)]
                set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) != "C" ) } {
                    set DISP_VS_AMOUNT [expr $DISP_VS_AMOUNT + $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set DISP_VS_AMOUNT [expr $DISP_VS_AMOUNT - $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT - $row(AMOUNT)]
                }
            } else {
                set MDISP_VS_COUNT [expr $MDISP_VS_COUNT + $row(COUNT)]
                set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) != "C" ) } {
                    set MDISP_VS_AMOUNT [expr $MDISP_VS_AMOUNT + $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set MDISP_VS_AMOUNT [expr $MDISP_VS_AMOUNT - $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT - $row(AMOUNT)]
                }
            }
        }
        if { ( $cardType == "MasterCard" ) } {
            if { ( $dateID != "MTD" ) } {
                set DISP_MC_COUNT [expr $DISP_MC_COUNT + $row(COUNT)]
                set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) != "C" ) } {
                    set DISP_MC_AMOUNT [expr $DISP_MC_AMOUNT + $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set DISP_MC_AMOUNT [expr $DISP_MC_AMOUNT - $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT - $row(AMOUNT)]
                }
            } else {
                set MDISP_MC_COUNT [expr $MDISP_MC_COUNT + $row(COUNT)]
                set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) != "C" ) } {
                    set MDISP_MC_AMOUNT [expr $MDISP_MC_AMOUNT + $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set MDISP_MC_AMOUNT [expr $MDISP_MC_AMOUNT - $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT - $row(AMOUNT)]
                }
            }
        }
        if { ( $cardType == "AMEX" ) } {
            if { ( $dateID != "MTD" ) } {
                set DISP_AX_COUNT [expr $DISP_AX_COUNT + $row(COUNT)]
                set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) != "C" ) } {
                    set DISP_AX_AMOUNT [expr $DISP_AX_AMOUNT + $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set DISP_AX_AMOUNT [expr $DISP_AX_AMOUNT - $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT - $row(AMOUNT)]
                }
            } else {
                set MDISP_AX_COUNT [expr $MDISP_AX_COUNT + $row(COUNT)]
                set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) != "C" ) } {
                    set MDISP_AX_AMOUNT [expr $MDISP_AX_AMOUNT + $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set MDISP_AX_AMOUNT [expr $MDISP_AX_AMOUNT - $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT - $row(AMOUNT)]
                }
            }
        }
        if { ( $cardType == "Discover" ) } {
            if { ( $dateID != "MTD" ) } {
                set DISP_DS_COUNT [expr $DISP_DS_COUNT + $row(COUNT)]
                set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) != "C" ) } {
                    set DISP_DS_AMOUNT [expr $DISP_DS_AMOUNT + $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set DISP_DS_AMOUNT [expr $DISP_DS_AMOUNT - $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT - $row(AMOUNT)]
                }
            } else {
                set MDISP_DS_COUNT [expr $MDISP_DS_COUNT + $row(COUNT)]
                set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) != "C" ) } {
                    set MDISP_DS_AMOUNT [expr $MDISP_DS_AMOUNT + $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set MDISP_DS_AMOUNT [expr $MDISP_DS_AMOUNT - $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT - $row(AMOUNT)]
                }
            }
        }
    }
    if { ( $dateID == "MTD" ) } {
         writeDisputesToFile
    }
}

proc getArbitrationsFromClearing {dateID} {
    global daily_cursor
    global sql_inst
    global cur_file
    global DISP_COUNT DISP_AMOUNT DISP_FEE DISP_VS_COUNT DISP_MC_COUNT DISP_AX_COUNT DISP_DS_COUNT DISP_VS_AMOUNT DISP_MC_AMOUNT DISP_AX_AMOUNT DISP_DS_AMOUNT DISP_VS_FEE DISP_MC_FEE DISP_AX_FEE DISP_DS_FEE MDISP_COUNT MDISP_AMOUNT MDISP_FEE MDISP_VS_COUNT MDISP_MC_COUNT MDISP_AX_COUNT MDISP_DS_COUNT MDISP_VS_AMOUNT MDISP_MC_AMOUNT MDISP_AX_AMOUNT MDISP_DS_AMOUNT MDISP_VS_FEE MDISP_MC_FEE MDISP_AX_FEE MDISP_DS_FEE
    global reportDateDisp reportDateDispMTD
    global clrDate clrDateMTD

    set reportStartDate $clrDate
    set reportEndDate $clrDate

    if { ( $dateID == "MTD" ) } {
        set reportStartDate $clrDateMTD
    } else {
        resetDispVariables
    }

    set arbitrationQuery "select substr(in_draft_main.sec_dest_inst_id,1,4) as Inst,
       substr(card_scheme.card_scheme_name,1,10) as Card_Type,
       count(in_draft_main.trans_seq_nbr) as Count,
       sum(in_draft_main.amt_recon)/100 as Amount,
       in_draft_main.recon_ccd as Currency,
       tid_adn.minor_cat as Dispute_Type,
       substr(tid.description,1,30) as description,
       tid.TID_SETTL_METHOD as D_C
from card_scheme,
     tid,
     tid_adn,
     in_draft_main
where in_draft_main.card_scheme = card_scheme.card_scheme AND
      in_draft_main.tid = tid.tid AND
      in_draft_main.tid = tid_adn.tid AND
      tid_adn.major_cat = 'DISPUTES' AND
      tid_adn.minor_cat = 'ARBITRATION' AND
      substr(pan,1,1) not in ('x','0') AND
      (in_draft_main.sec_dest_inst_id = '$sql_inst' OR
      in_draft_main.pri_dest_inst_id = '$sql_inst' ) AND
      in_draft_main.in_file_nbr in (
      select in_file_nbr from in_file_log
      where
      incoming_dt >= to_date($reportStartDate,'YYYYMMDD') and
      incoming_dt <  to_date($reportEndDate,'YYYYMMDD') + 1
      and institution_id in ('04','05','03','08'))
group by substr(in_draft_main.sec_dest_inst_id,1,4),
         substr(card_scheme.card_scheme_name,1,10),
         in_draft_main.recon_ccd,
         tid_adn.minor_cat,
         substr(tid.description,1,30),
         tid.TID_SETTL_METHOD
order by substr(in_draft_main.sec_dest_inst_id,1,4),
         substr(card_scheme.card_scheme_name,1,10),
         in_draft_main.recon_ccd,
         tid_adn.minor_cat,
         substr(tid.description,1,30)"

    orasql $daily_cursor $arbitrationQuery

    MASCLR::log_message  "Arbitrations Query Clearing ($dateID):\n*/\n\n$arbitrationQuery;\n\n/*" 3

    while {[orafetch $daily_cursor -dataarray row -indexbyname] != 1403} {
        set cardType $row(CARD_TYPE)
        if { ( $cardType == "VISA" ) } {
            if { ( $dateID != "MTD" ) } {
                set DISP_VS_COUNT [expr $DISP_VS_COUNT + $row(COUNT)]
                set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) != "C" ) } {
                    set DISP_VS_AMOUNT [expr $DISP_VS_AMOUNT + $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set DISP_VS_AMOUNT [expr $DISP_VS_AMOUNT - $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT - $row(AMOUNT)]
                }
            } else {
                set MDISP_VS_COUNT [expr $MDISP_VS_COUNT + $row(COUNT)]
                set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) != "C" ) } {
                    set MDISP_VS_AMOUNT [expr $MDISP_VS_AMOUNT + $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set MDISP_VS_AMOUNT [expr $MDISP_VS_AMOUNT - $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT - $row(AMOUNT)]
                }
            }
        }
        if { ( $cardType == "MasterCard" ) } {
            if { ( $dateID != "MTD" ) } {
                set DISP_MC_COUNT [expr $DISP_MC_COUNT + $row(COUNT)]
                set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) != "C" ) } {
                    set DISP_MC_AMOUNT [expr $DISP_MC_AMOUNT + $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set DISP_MC_AMOUNT [expr $DISP_MC_AMOUNT - $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT - $row(AMOUNT)]
                }
            } else {
                set MDISP_MC_COUNT [expr $MDISP_MC_COUNT + $row(COUNT)]
                set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) != "C" ) } {
                    set MDISP_MC_AMOUNT [expr $MDISP_MC_AMOUNT + $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set MDISP_MC_AMOUNT [expr $MDISP_MC_AMOUNT - $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT - $row(AMOUNT)]
                }
            }
        }
        if { ( $cardType == "AMEX" ) } {
            if { ( $dateID != "MTD" ) } {
                set DISP_AX_COUNT [expr $DISP_AX_COUNT + $row(COUNT)]
                set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) != "C" ) } {
                    set DISP_AX_AMOUNT [expr $DISP_AX_AMOUNT + $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set DISP_AX_AMOUNT [expr $DISP_AX_AMOUNT - $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT - $row(AMOUNT)]
                }
            } else {
                set MDISP_AX_COUNT [expr $MDISP_AX_COUNT + $row(COUNT)]
                set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) != "C" ) } {
                    set MDISP_AX_AMOUNT [expr $MDISP_AX_AMOUNT + $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set MDISP_AX_AMOUNT [expr $MDISP_AX_AMOUNT - $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT - $row(AMOUNT)]
                }
            }
        }
        if { ( $cardType == "Discover" ) } {
            if { ( $dateID != "MTD" ) } {
                set DISP_DS_COUNT [expr $DISP_DS_COUNT + $row(COUNT)]
                set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) != "C" ) } {
                    set DISP_DS_AMOUNT [expr $DISP_DS_AMOUNT + $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set DISP_DS_AMOUNT [expr $DISP_DS_AMOUNT - $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT - $row(AMOUNT)]
                }
            } else {
                set MDISP_DS_COUNT [expr $MDISP_DS_COUNT + $row(COUNT)]
                set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) != "C" ) } {
                    set MDISP_DS_AMOUNT [expr $MDISP_DS_AMOUNT + $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set MDISP_DS_AMOUNT [expr $MDISP_DS_AMOUNT - $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT - $row(AMOUNT)]
                }
            }
        }
    }
    if { ( $dateID == "MTD" ) } {
         writeDisputesToFile
    }

}

proc getChargebacksFromMAS {dateID} {
    global daily_cursor
    global sql_inst
    global cur_file
    global DISP_COUNT DISP_AMOUNT DISP_FEE DISP_VS_COUNT DISP_MC_COUNT DISP_AX_COUNT DISP_DS_COUNT DISP_VS_AMOUNT DISP_MC_AMOUNT DISP_AX_AMOUNT DISP_DS_AMOUNT DISP_VS_FEE DISP_MC_FEE DISP_AX_FEE DISP_DS_FEE MDISP_COUNT MDISP_AMOUNT MDISP_FEE MDISP_VS_COUNT MDISP_MC_COUNT MDISP_AX_COUNT MDISP_DS_COUNT MDISP_VS_AMOUNT MDISP_MC_AMOUNT MDISP_AX_AMOUNT MDISP_DS_AMOUNT MDISP_VS_FEE MDISP_MC_FEE MDISP_AX_FEE MDISP_DS_FEE
    global reportDateDisp reportDateDispMTD
    global clrDate clrDateMTD
    global masDate masDateMTD

    set clrStartDate $clrDate
    set clrEndDate $clrDate
    set masStartDate $masDate
    set masEndDate $masDate

    if { ( $dateID == "MTD" ) } {
        set clrStartDate $clrDateMTD
        set masStartDate $masDateMTD
    } else {
        resetDispVariables
    }
    MASCLR::log_message  "Chargebacks Query - MAS start date : $masStartDate, end date : $masEndDate" 3
    set chargebackQuery "
        SELECT
            mtl.institution_id                                        AS Inst,
            cs.card_scheme_name                                       AS Card_Type,
            COUNT(DISTINCT mtl.TRANS_SEQ_NBR)                         AS COUNT,
            SUM(
            CASE WHEN mtl.trans_sub_seq = '0'
            THEN
            case when mtl.tid_settl_method = 'C'
            then 1 else -1  end
            ELSE 0 END*mtl.amt_original)                       AS Amount,
            SUM(
            CASE WHEN mtl.trans_sub_seq <> '0'
            THEN
            case when mtl.tid_settl_method = 'C'
            then 1 else -1  end
            ELSE 0 END*mtl.amt_original)                       AS Fee
        FROM mas_trans_log mtl
        JOIN mas_file_log mfl
            ON mfl.INSTITUTION_ID = mtl.INSTITUTION_ID
            AND mfl.FILE_ID       = mtl.FILE_ID
        JOIN card_scheme cs
            ON mtl.CARD_SCHEME    = cs.CARD_SCHEME
        JOIN tid_adn ta
            ON mtl.tid = ta.tid and ta.usage = 'MAS'
        WHERE mfl.INSTITUTION_ID = '$sql_inst'
            AND mtl.settl_flag    = 'Y'
            AND mfl.file_name LIKE '%CHARGEBK%'
            AND mfl.receive_date_time >= to_date($masStartDate,'YYYYMMDD')
            and mfl.receive_date_time <  to_date($masEndDate,'YYYYMMDD') + 1
            AND ta.major_cat in ('DISPUTES', 'FEES')
            AND ta.minor_cat in ('CHARGEBACK','DISPUTES')
        GROUP BY mtl.institution_id,
            cs.card_scheme_name
        ORDER BY
            cs.card_scheme_name,
            mtl.institution_id
    "

    MASCLR::log_message  "Chargebacks Query - MAS:\n*/\n\n$chargebackQuery;\n\n/*" 3
    orasql $daily_cursor $chargebackQuery

    while {[orafetch $daily_cursor -dataarray row -indexbyname] != 1403} {
        set cardType $row(CARD_TYPE)
        if { ( $cardType == "VISA" ) } {
            if { ( $dateID != "MTD" ) } {
                set DISP_VS_FEE [expr $DISP_VS_FEE - $row(FEE)]
                set DISP_FEE [expr $DISP_FEE - $row(FEE)]
                set DISP_VS_COUNT [expr $DISP_VS_COUNT + $row(COUNT)]
                set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                set DISP_VS_AMOUNT [expr $DISP_VS_AMOUNT + $row(AMOUNT)]
                set DISP_AMOUNT [expr $DISP_AMOUNT + $row(AMOUNT)]
            } else {
                set MDISP_VS_FEE [expr $MDISP_VS_FEE - $row(FEE)]
                set MDISP_FEE [expr $MDISP_FEE - $row(FEE)]
                set MDISP_VS_COUNT [expr $MDISP_VS_COUNT + $row(COUNT)]
                set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                set MDISP_VS_AMOUNT [expr $MDISP_VS_AMOUNT + $row(AMOUNT)]
                set MDISP_AMOUNT [expr $MDISP_AMOUNT + $row(AMOUNT)]
            }
        }
        if { ( $cardType == "MasterCard" ) } {
            if { ( $dateID != "MTD" ) } {
                set DISP_MC_FEE [expr $DISP_MC_FEE - $row(FEE)]
                set DISP_FEE [expr $DISP_FEE - $row(FEE)]
                set DISP_MC_COUNT [expr $DISP_MC_COUNT + $row(COUNT)]
                set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                set DISP_MC_AMOUNT [expr $DISP_MC_AMOUNT + $row(AMOUNT)]
                set DISP_AMOUNT [expr $DISP_AMOUNT + $row(AMOUNT)]
            } else {
                set MDISP_MC_FEE [expr $MDISP_MC_FEE - $row(FEE)]
                set MDISP_FEE [expr $MDISP_FEE - $row(FEE)]
                set MDISP_MC_COUNT [expr $MDISP_MC_COUNT + $row(COUNT)]
                set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                set MDISP_MC_AMOUNT [expr $MDISP_MC_AMOUNT + $row(AMOUNT)]
                set MDISP_AMOUNT [expr $MDISP_AMOUNT + $row(AMOUNT)]
            }
        }
        if { ( $cardType == "AMEX" ) } {
            if { ( $dateID != "MTD" ) } {
                set DISP_AX_FEE [expr $DISP_AX_FEE - $row(FEE)]
                set DISP_FEE [expr $DISP_FEE - $row(FEE)]
                set DISP_AX_COUNT [expr $DISP_AX_COUNT + $row(COUNT)]
                set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                set DISP_AX_AMOUNT [expr $DISP_AX_AMOUNT + $row(AMOUNT)]
                set DISP_AMOUNT [expr $DISP_AMOUNT + $row(AMOUNT)]
            } else {
                set MDISP_AX_FEE [expr $MDISP_AX_FEE - $row(FEE)]
                set MDISP_FEE [expr $MDISP_FEE - $row(FEE)]
                set MDISP_AX_COUNT [expr $MDISP_AX_COUNT + $row(COUNT)]
                set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                set MDISP_AX_AMOUNT [expr $MDISP_AX_AMOUNT + $row(AMOUNT)]
                set MDISP_AMOUNT [expr $MDISP_AMOUNT + $row(AMOUNT)]
            }
        }
        if { ( $cardType == "Discover" ) } {
            if { ( $dateID != "MTD" ) } {
                set DISP_DS_FEE [expr $DISP_DS_FEE - $row(FEE)]
                set DISP_FEE [expr $DISP_FEE - $row(FEE)]
                set DISP_DS_COUNT [expr $DISP_DS_COUNT + $row(COUNT)]
                set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                set DISP_DS_AMOUNT [expr $DISP_DS_AMOUNT + $row(AMOUNT)]
                set DISP_AMOUNT [expr $DISP_AMOUNT + $row(AMOUNT)]
            } else {
                set MDISP_DS_FEE [expr $MDISP_DS_FEE - $row(FEE)]
                set MDISP_FEE [expr $MDISP_FEE - $row(FEE)]
                set MDISP_DS_COUNT [expr $MDISP_DS_COUNT + $row(COUNT)]
                set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                set MDISP_DS_AMOUNT [expr $MDISP_DS_AMOUNT + $row(AMOUNT)]
                set MDISP_AMOUNT [expr $MDISP_AMOUNT + $row(AMOUNT)]
            }
        }
    }
    if { ( $dateID == "MTD" ) } {
         writeDisputesToFile
    }
}

proc getRepresentmentsFromMAS {dateID} {
    global daily_cursor
    global sql_inst
    global cur_file
    global DISP_COUNT DISP_AMOUNT DISP_FEE DISP_VS_COUNT DISP_MC_COUNT DISP_AX_COUNT DISP_DS_COUNT DISP_VS_AMOUNT DISP_MC_AMOUNT DISP_AX_AMOUNT DISP_DS_AMOUNT DISP_VS_FEE DISP_MC_FEE DISP_AX_FEE DISP_DS_FEE MDISP_COUNT MDISP_AMOUNT MDISP_FEE MDISP_VS_COUNT MDISP_MC_COUNT MDISP_AX_COUNT MDISP_DS_COUNT MDISP_VS_AMOUNT MDISP_MC_AMOUNT MDISP_AX_AMOUNT MDISP_DS_AMOUNT MDISP_VS_FEE MDISP_MC_FEE MDISP_AX_FEE MDISP_DS_FEE
    global reportDateDisp reportDateDispMTD
    global clrDate clrDateMTD
    global masDate masDateMTD

    set clrStartDate $clrDate
    set clrEndDate $clrDate
    set masStartDate $masDate
    set masEndDate $masDate

    if { ( $dateID == "MTD" ) } {
        set clrStartDate $clrDateMTD
        set masStartDate $masDateMTD
    } else {
        resetDispVariables
    }

    set representmentQuery "
         SELECT substr(mtl.institution_id,1,4)                as Inst,
                substr(mtl.gl_date,1,8)                       as GL_Date,
                substr(cs.card_scheme_name,1,10)              as Card_Type,
                count(
                CASE WHEN mtl.trans_sub_seq = '0'
                then 1 else 0 end)                            as Count,
                sum(
                CASE WHEN mtl.trans_sub_seq = '0'
                then (mtl.amt_original) else 0 end)           as Amount,
                sum(
                CASE WHEN mtl.trans_sub_seq <> '0'
                then (mtl.amt_original) else 0 end)           as Fee,
                mtl.trans_sub_seq                             as sub_seq,
                mtl.TRANS_SEQ_NBR                             as trans_seq,
                mtl.tid_settl_method                          as D_C
         FROM mas_trans_log mtl
         JOIN mas_file_log mfl
         ON mfl.INSTITUTION_ID = mtl.INSTITUTION_ID
         AND mfl.FILE_ID       = mtl.FILE_ID
         JOIN card_scheme cs
         ON mtl.CARD_SCHEME    = cs.CARD_SCHEME
         JOIN tid_adn ta
         ON mtl.tid = ta.tid and ta.usage = 'MAS'
         WHERE mfl.INSTITUTION_ID = '$sql_inst'
         AND mtl.settl_flag    = 'Y'
         AND mfl.file_name LIKE '%CHARGEBK%'
         AND mfl.receive_date_time >= to_date($masStartDate,'YYYYMMDD')
         and mfl.receive_date_time <  to_date($masEndDate,'YYYYMMDD') + 1
         AND (ta.major_cat in ('DISPUTES') and ta.minor_cat = 'REPRESENTMENT'
            or (ta.MAJOR_CAT = 'FEES' and ta.MINOR_CAT not in ('DISPUTES','MISC')))
         GROUP BY substr(mtl.institution_id,1,4),
                  substr(mtl.gl_date,1,8),
                  substr(cs.card_scheme_name,1,10),
                  mtl.tid_settl_method,
                  mtl.trans_sub_seq,
                  mtl.TRANS_SEQ_NBR
         ORDER BY substr(cs.card_scheme_name,1,10),
                  substr(mtl.institution_id,1,4),
                  substr(mtl.gl_date,1,8),
                  mtl.tid_settl_method"

    orasql $daily_cursor $representmentQuery

    MASCLR::log_message "Representment Query MAS ($dateID):\n*/\n\n$representmentQuery;\n\n/*" 3

    while {[orafetch $daily_cursor -dataarray row -indexbyname] != 1403} {
        set cardType $row(CARD_TYPE)
        if { ( $cardType == "VISA" ) } {
            if { ( $dateID != "MTD" ) } {
                if { ( $row(D_C) == "C" ) } {
                    if { ( $row(SUB_SEQ) == 0 ) } {
                        set DISP_VS_COUNT [expr $DISP_VS_COUNT + $row(COUNT)]
                        set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                        set DISP_VS_AMOUNT [expr $DISP_VS_AMOUNT + $row(AMOUNT)]
                        set DISP_AMOUNT [expr $DISP_AMOUNT + $row(AMOUNT)]
                    } else {
                        set DISP_VS_FEE [expr $DISP_VS_FEE + $row(FEE)]
                        set DISP_FEE [expr $DISP_FEE + $row(FEE)]
                    }
                } else {
                    if { ( $row(SUB_SEQ) == 0 ) } {
                        set DISP_VS_AMOUNT [expr $DISP_VS_AMOUNT - $row(AMOUNT)]
                        set DISP_AMOUNT [expr $DISP_AMOUNT - $row(AMOUNT)]
                        set DISP_VS_COUNT [expr $DISP_VS_COUNT + $row(COUNT)]
                        set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                    } else {
                        set DISP_VS_FEE [expr $DISP_VS_FEE - $row(FEE)]
                        set DISP_FEE [expr $DISP_FEE - $row(FEE)]
                    }
                }
            } else {
                if { ( $row(D_C) == "C" ) } {
                    if { ( $row(SUB_SEQ) == 0 ) } {
                        set MDISP_VS_AMOUNT [expr $MDISP_VS_AMOUNT + $row(AMOUNT)]
                        set MDISP_AMOUNT [expr $MDISP_AMOUNT + $row(AMOUNT)]
                        set MDISP_VS_COUNT [expr $MDISP_VS_COUNT + $row(COUNT)]
                        set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                    } else {
                        set MDISP_VS_FEE [expr $MDISP_VS_FEE + $row(FEE)]
                        set MDISP_FEE [expr $MDISP_FEE + $row(FEE)]
                    }
                } else {
                    if { ( $row(SUB_SEQ) == 0 ) } {
                        set MDISP_VS_AMOUNT [expr $MDISP_VS_AMOUNT - $row(AMOUNT)]
                        set MDISP_AMOUNT [expr $MDISP_AMOUNT - $row(AMOUNT)]
                        set MDISP_VS_COUNT [expr $MDISP_VS_COUNT + $row(COUNT)]
                        set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                    } else {
                        set MDISP_VS_FEE [expr $MDISP_VS_FEE - $row(FEE)]
                        set MDISP_FEE [expr $MDISP_FEE - $row(FEE)]
                    }
                }
            }
        }
        if { ( $cardType == "MasterCard" ) } {
            if { ( $dateID != "MTD" ) } {
                if { ( $row(D_C) == "C" ) } {
                    if { ( $row(SUB_SEQ) == 0 ) } {
                        set DISP_MC_AMOUNT [expr $DISP_MC_AMOUNT + $row(AMOUNT)]
                        set DISP_AMOUNT [expr $DISP_AMOUNT + $row(AMOUNT)]
                        set DISP_MC_COUNT [expr $DISP_MC_COUNT + $row(COUNT)]
                        set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                    } else {
                        set DISP_MC_FEE [expr $DISP_MC_FEE + $row(FEE)]
                        set DISP_FEE [expr $DISP_FEE + $row(FEE)]
                    }
                } else {
                    if { ( $row(SUB_SEQ) == 0 ) } {
                        set DISP_MC_AMOUNT [expr $DISP_MC_AMOUNT - $row(AMOUNT)]
                        set DISP_AMOUNT [expr $DISP_AMOUNT - $row(AMOUNT)]
                        set DISP_MC_COUNT [expr $DISP_MC_COUNT + $row(COUNT)]
                        set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                    } else {
                        set DISP_MC_FEE [expr $DISP_MC_FEE - $row(FEE)]
                        set DISP_FEE [expr $DISP_FEE - $row(FEE)]
                    }
                }
            } else {
                if { ( $row(D_C) == "C" ) } {
                    if { ( $row(SUB_SEQ) == 0 ) } {
                        set MDISP_MC_AMOUNT [expr $MDISP_MC_AMOUNT + $row(AMOUNT)]
                        set MDISP_AMOUNT [expr $MDISP_AMOUNT + $row(AMOUNT)]
                        set MDISP_MC_COUNT [expr $MDISP_MC_COUNT + $row(COUNT)]
                        set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                    } else {
                        set MDISP_MC_FEE [expr $MDISP_MC_FEE + $row(FEE)]
                        set MDISP_FEE [expr $MDISP_FEE + $row(FEE)]
                    }
                } else {
                    if { ( $row(SUB_SEQ) == 0 ) } {
                        set MDISP_MC_AMOUNT [expr $MDISP_MC_AMOUNT - $row(AMOUNT)]
                        set MDISP_AMOUNT [expr $MDISP_AMOUNT - $row(AMOUNT)]
                        set MDISP_MC_COUNT [expr $MDISP_MC_COUNT + $row(COUNT)]
                        set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                    } else {
                        set MDISP_MC_FEE [expr $MDISP_MC_FEE - $row(FEE)]
                        set MDISP_FEE [expr $MDISP_FEE - $row(FEE)]
                    }
                }
            }
        }
        if { ( $cardType == "AMEX" ) } {
            if { ( $dateID != "MTD" ) } {
                if { ( $row(D_C) == "C" ) } {
                    if { ( $row(SUB_SEQ) == 0 ) } {
                        set DISP_AX_AMOUNT [expr $DISP_AX_AMOUNT + $row(AMOUNT)]
                        set DISP_AMOUNT [expr $DISP_AMOUNT + $row(AMOUNT)]
                        set DISP_AX_COUNT [expr $DISP_AX_COUNT + $row(COUNT)]
                        set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                    } else {
                        set DISP_AX_FEE [expr $DISP_AX_FEE + $row(FEE)]
                        set DISP_FEE [expr $DISP_FEE + $row(FEE)]
                    }
                } else {
                    if { ( $row(SUB_SEQ) == 0 ) } {
                        set DISP_AX_AMOUNT [expr $DISP_AX_AMOUNT - $row(AMOUNT)]
                        set DISP_AMOUNT [expr $DISP_AMOUNT - $row(AMOUNT)]
                        set DISP_AX_COUNT [expr $DISP_AX_COUNT + $row(COUNT)]
                        set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                    } else {
                        set DISP_AX_FEE [expr $DISP_AX_FEE - $row(FEE)]
                        set DISP_FEE [expr $DISP_FEE - $row(FEE)]
                    }
                }
            } else {
                if { ( $row(D_C) == "C" ) } {
                    if { ( $row(SUB_SEQ) == 0 ) } {
                        set MDISP_AX_AMOUNT [expr $MDISP_AX_AMOUNT + $row(AMOUNT)]
                        set MDISP_AMOUNT [expr $MDISP_AMOUNT + $row(AMOUNT)]
                        set MDISP_AX_COUNT [expr $MDISP_AX_COUNT + $row(COUNT)]
                        set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                    } else {
                        set MDISP_AX_FEE [expr $MDISP_AX_FEE + $row(FEE)]
                        set MDISP_FEE [expr $MDISP_FEE + $row(FEE)]
                    }
                } else {
                    if { ( $row(SUB_SEQ) == 0 ) } {
                        set MDISP_AX_AMOUNT [expr $MDISP_AX_AMOUNT - $row(AMOUNT)]
                        set MDISP_AMOUNT [expr $MDISP_AMOUNT - $row(AMOUNT)]
                        set MDISP_AX_COUNT [expr $MDISP_AX_COUNT + $row(COUNT)]
                        set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                    } else {
                        set MDISP_AX_FEE [expr $MDISP_AX_FEE - $row(FEE)]
                        set MDISP_FEE [expr $MDISP_FEE - $row(FEE)]
                    }
                }
            }
        }
        if { ( $cardType == "Discover" ) } {
            if { ( $dateID != "MTD" ) } {
                if { ( $row(D_C) == "C" ) } {
                    if { ( $row(SUB_SEQ) == 0 ) } {
                        set DISP_DS_AMOUNT [expr $DISP_DS_AMOUNT + $row(AMOUNT)]
                        set DISP_AMOUNT [expr $DISP_AMOUNT + $row(AMOUNT)]
                        set DISP_DS_COUNT [expr $DISP_DS_COUNT + $row(COUNT)]
                        set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                    } else {
                        set DISP_DS_FEE [expr $DISP_DS_FEE + $row(FEE)]
                        set DISP_FEE [expr $DISP_FEE + $row(FEE)]
                    }
                } else {
                    if { ( $row(SUB_SEQ) == 0 ) } {
                        set DISP_DS_AMOUNT [expr $DISP_DS_AMOUNT - $row(AMOUNT)]
                        set DISP_AMOUNT [expr $DISP_AMOUNT - $row(AMOUNT)]
                        set DISP_DS_COUNT [expr $DISP_DS_COUNT + $row(COUNT)]
                        set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                    } else {
                        set DISP_DS_FEE [expr $DISP_DS_FEE - $row(FEE)]
                        set DISP_FEE [expr $DISP_FEE - $row(FEE)]
                    }
                }
            } else {
                if { ( $row(D_C) == "C" ) } {
                    if { ( $row(SUB_SEQ) == 0 ) } {
                        set MDISP_DS_AMOUNT [expr $MDISP_DS_AMOUNT + $row(AMOUNT)]
                        set MDISP_AMOUNT [expr $MDISP_AMOUNT + $row(AMOUNT)]
                        set MDISP_DS_COUNT [expr $MDISP_DS_COUNT + $row(COUNT)]
                        set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                    } else {
                        set MDISP_DS_FEE [expr $MDISP_DS_FEE + $row(FEE)]
                        set MDISP_FEE [expr $MDISP_FEE + $row(FEE)]
                    }
                } else {
                    if { ( $row(SUB_SEQ) == 0 ) } {
                        set MDISP_DS_AMOUNT [expr $MDISP_DS_AMOUNT - $row(AMOUNT)]
                        set MDISP_AMOUNT [expr $MDISP_AMOUNT - $row(AMOUNT)]
                        set MDISP_DS_COUNT [expr $MDISP_DS_COUNT + $row(COUNT)]
                        set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                    } else {
                        set MDISP_DS_FEE [expr $MDISP_DS_FEE - $row(FEE)]
                        set MDISP_FEE [expr $MDISP_FEE - $row(FEE)]
                    }
                }
            }
        }
    }
    if { ( $dateID == "MTD" ) } {
         writeDisputesToFile
    }
}

proc getArbitrationsFromMAS {dateID} {
    global daily_cursor
    global sql_inst
    global cur_file
    global DISP_COUNT DISP_AMOUNT DISP_FEE DISP_VS_COUNT DISP_MC_COUNT DISP_AX_COUNT DISP_DS_COUNT DISP_VS_AMOUNT DISP_MC_AMOUNT DISP_AX_AMOUNT DISP_DS_AMOUNT DISP_VS_FEE DISP_MC_FEE DISP_AX_FEE DISP_DS_FEE MDISP_COUNT MDISP_AMOUNT MDISP_FEE MDISP_VS_COUNT MDISP_MC_COUNT MDISP_AX_COUNT MDISP_DS_COUNT MDISP_VS_AMOUNT MDISP_MC_AMOUNT MDISP_AX_AMOUNT MDISP_DS_AMOUNT MDISP_VS_FEE MDISP_MC_FEE MDISP_AX_FEE MDISP_DS_FEE
    global reportDateDisp reportDateDispMTD
    global clrDate clrDateMTD
    global masDate masDateMTD

    set clrStartDate $clrDate
    set clrEndDate $clrDate
    set masStartDate $masDate
    set masEndDate $masDate

    if { ( $dateID == "MTD" ) } {
        set clrStartDate $clrDateMTD
        set masStartDate $masDateMTD
    } else {
        resetDispVariables
    }

    set arbitrationQuery "
        select substr(mtl.institution_id,1,4)              as Inst,
               substr(mtl.gl_date,1,8)                     as GL_Date,
               substr(cs.card_scheme_name,1,10)            as Card_Type,
               count(distinct mtl.trans_seq_nbr )          as Count,
               sum(CASE WHEN mtl.trans_sub_seq = '0'
               then (mtl.amt_original) else 0 end)         as Amount,
               sum(CASE WHEN mtl.trans_sub_seq <> '0'
               then (mtl.amt_original) else 0 end)         as Fee,
               mtl.tid_settl_method                        as D_C
        FROM mas_trans_log mtl
        JOIN mas_file_log mfl
        ON mfl.INSTITUTION_ID = mtl.INSTITUTION_ID
        AND mfl.FILE_ID       = mtl.FILE_ID
        JOIN card_scheme cs
        ON mtl.CARD_SCHEME    = cs.CARD_SCHEME
        JOIN tid_adn ta
        ON mtl.tid = ta.tid and ta.major_cat = 'DISPUTES'
        and ta.minor_cat = 'ARBITRATION' and ta.usage = 'MAS'
        WHERE mfl.INSTITUTION_ID = '$sql_inst'
        AND mtl.settl_flag    = 'Y'
        AND mfl.file_name LIKE '%CHARGEBK%'
        AND mfl.receive_date_time >= to_date($masStartDate,'YYYYMMDD')
        and mfl.receive_date_time <  to_date($masEndDate,'YYYYMMDD') + 1
        GROUP BY substr(mtl.institution_id,1,4),
                 substr(mtl.gl_date,1,8),
                 substr(cs.card_scheme_name,1,10),
                 mtl.tid_settl_method
        ORDER BY substr(cs.card_scheme_name,1,10),
                 substr(mtl.institution_id,1,4),
                 substr(mtl.gl_date,1,8),
                 mtl.tid_settl_method"

    orasql $daily_cursor $arbitrationQuery

    MASCLR::log_message "Arbitrations Query - MAS ($dateID):\n*/\n\n$arbitrationQuery;\n\n/*" 3

    while {[orafetch $daily_cursor -dataarray row -indexbyname] != 1403} {
        set cardType $row(CARD_TYPE)
        if { ( $cardType == "VISA" ) } {
            if { ( $dateID != "MTD" ) } {
                set DISP_VS_COUNT [expr $DISP_VS_COUNT + $row(COUNT)]
                set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) == "C" ) } {
                    set DISP_VS_AMOUNT [expr $DISP_VS_AMOUNT + $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set DISP_VS_AMOUNT [expr $DISP_VS_AMOUNT - $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT - $row(AMOUNT)]
                }
            } else {
                set MDISP_VS_COUNT [expr $MDISP_VS_COUNT + $row(COUNT)]
                set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) == "C" ) } {
                    set MDISP_VS_AMOUNT [expr $MDISP_VS_AMOUNT + $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set MDISP_VS_AMOUNT [expr $MDISP_VS_AMOUNT - $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT - $row(AMOUNT)]
                }
            }
        }
        if { ( $cardType == "MasterCard" ) } {
            if { ( $dateID != "MTD" ) } {
                set DISP_MC_COUNT [expr $DISP_MC_COUNT + $row(COUNT)]
                set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) == "C" ) } {
                    set DISP_MC_AMOUNT [expr $DISP_MC_AMOUNT + $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set DISP_MC_AMOUNT [expr $DISP_MC_AMOUNT - $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT - $row(AMOUNT)]
                }
            } else {
                set MDISP_MC_COUNT [expr $MDISP_MC_COUNT + $row(COUNT)]
                set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) == "C" ) } {
                    set MDISP_MC_AMOUNT [expr $MDISP_MC_AMOUNT + $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set MDISP_MC_AMOUNT [expr $MDISP_MC_AMOUNT - $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT - $row(AMOUNT)]
                }
            }
        }
        if { ( $cardType == "AMEX" ) } {
            if { ( $dateID != "MTD" ) } {
                set DISP_AX_COUNT [expr $DISP_AX_COUNT + $row(COUNT)]
                set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) == "C" ) } {
                    set DISP_AX_AMOUNT [expr $DISP_AX_AMOUNT + $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set DISP_AX_AMOUNT [expr $DISP_AX_AMOUNT - $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT - $row(AMOUNT)]
                }
            } else {
                set MDISP_AX_COUNT [expr $MDISP_AX_COUNT + $row(COUNT)]
                set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) == "C" ) } {
                    set MDISP_AX_AMOUNT [expr $MDISP_AX_AMOUNT + $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set MDISP_AX_AMOUNT [expr $MDISP_AX_AMOUNT - $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT - $row(AMOUNT)]
                }
            }
        }
        if { ( $cardType == "Discover" ) } {
            if { ( $dateID != "MTD" ) } {
                set DISP_DS_COUNT [expr $DISP_DS_COUNT + $row(COUNT)]
                set DISP_COUNT [expr $DISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) == "C" ) } {
                    set DISP_DS_AMOUNT [expr $DISP_DS_AMOUNT + $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set DISP_DS_AMOUNT [expr $DISP_DS_AMOUNT - $row(AMOUNT)]
                    set DISP_AMOUNT [expr $DISP_AMOUNT - $row(AMOUNT)]
                }
            } else {
                set MDISP_DS_COUNT [expr $MDISP_DS_COUNT + $row(COUNT)]
                set MDISP_COUNT [expr $MDISP_COUNT + $row(COUNT)]
                if { ( $row(D_C) == "C" ) } {
                    set MDISP_DS_AMOUNT [expr $MDISP_DS_AMOUNT + $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT + $row(AMOUNT)]
                } else {
                    set MDISP_DS_AMOUNT [expr $MDISP_DS_AMOUNT - $row(AMOUNT)]
                    set MDISP_AMOUNT [expr $MDISP_AMOUNT - $row(AMOUNT)]
                }
            }
        }
    }
    if { ( $dateID == "MTD" ) } {
        writeDisputesToFile
    }
}

proc getDbtByNetwork {} {

    global daily_cursor
    global sql_inst
    global cur_file
    global reportStartDateNetwork reportEndDateNetwork
    set report_date_start $reportStartDateNetwork
    set report_date_end $reportEndDateNetwork

    set ACCEL_COUNT 0
    set AFFN_COUNT 0
    set ALASKA_OPTION_COUNT 0
    set CU24_COUNT 0
    set EBT_COUNT 0
    set INTERAC_COUNT 0
    set INTERLINK_COUNT 0
    set MAESTRO_COUNT 0
    set NETS_COUNT 0
    set NYCE_COUNT 0
    set PULSE_COUNT 0
    set SHAZAM_COUNT 0
    set STAR_COUNT 0

    set ACCEL_AMOUNT 0
    set AFFN_AMOUNT 0
    set ALASKA_OPTION_AMOUNT 0
    set CU24_AMOUNT 0
    set EBT_AMOUNT 0
    set INTERAC_AMOUNT 0
    set INTERLINK_AMOUNT 0
    set MAESTRO_AMOUNT 0
    set NETS_AMOUNT 0
    set NYCE_AMOUNT 0
    set PULSE_AMOUNT 0
    set SHAZAM_AMOUNT 0
    set STAR_AMOUNT 0
    set dbtNetworkQuery "select decode(in_draft_pin_debit.network_id,
              '20', 'ACCEL',
              '13', 'AFFN',
              '25', 'ALASKA_OPTION',
              '24', 'CU24',
              '29', 'EBT',
              'IN', 'INTERAC',
              '02', 'INTERLINK',
              '03', 'INTERLINK',
              '16', 'MAESTRO',
              '23', 'NETS',
              '18', 'NYCE',
              '27', 'NYCE',
              '09', 'PULSE',
              '17', 'PULSE',
              '19', 'PULSE',
              '28', 'SHAZAM',
              '08', 'STAR',
              '10', 'STAR',
              '11', 'STAR',
              '12', 'STAR',
              '15', 'STAR'
             ) as Network,
           count(in_draft_pin_debit.pin_debit_trans_seq_nbr) as Count,
           sum(in_draft_pin_debit.amt_trans)/100 as Amount,
           trans_ccd as Currency,
           substr(tid.description,1,30) as Tran_Type
        from in_draft_pin_debit,
         tid
        where in_draft_pin_debit.tid = tid.tid AND
          in_draft_pin_debit.pin_debit_export_file_date BETWEEN to_date($report_date_start,'YYYYMMDDHH24MISS') AND to_date($report_date_end,'YYYYMMDDHH24MISS') AND
          in_draft_pin_debit.sec_dest_inst_id in ($sql_inst)
        group by decode(in_draft_pin_debit.network_id,
                '20', 'ACCEL',
                '13', 'AFFN',
                '25', 'ALASKA_OPTION',
                '24', 'CU24',
                '29', 'EBT',
                'IN', 'INTERAC',
                '02', 'INTERLINK',
                '03', 'INTERLINK',
                '16', 'MAESTRO',
                '23', 'NETS',
                '18', 'NYCE',
                '27', 'NYCE',
                '09', 'PULSE',
                '17', 'PULSE',
                '19', 'PULSE',
                '28', 'SHAZAM',
                '08', 'STAR',
                '10', 'STAR',
                '11', 'STAR',
                '12', 'STAR',
                '15', 'STAR'
               ),
         trans_ccd,
         substr(tid.description,1,30)
        order by decode(in_draft_pin_debit.network_id,
                '20', 'ACCEL',
                '13', 'AFFN',
                '25', 'ALASKA_OPTION',
                '24', 'CU24',
                '29', 'EBT',
                'IN', 'INTERAC',
                '02', 'INTERLINK',
                '03', 'INTERLINK',
                '16', 'MAESTRO',
                '23', 'NETS',
                '18', 'NYCE',
                '27', 'NYCE',
                '09', 'PULSE',
                '17', 'PULSE',
                '19', 'PULSE',
                '28', 'SHAZAM',
                '08', 'STAR',
                '10', 'STAR',
                '11', 'STAR',
                '12', 'STAR',
                '15', 'STAR'
               ),
         trans_ccd,
         substr(tid.description,1,30)"

    orasql $daily_cursor $dbtNetworkQuery

    MASCLR::log_message  "DBT Network Query:\n*/\n\n$dbtNetworkQuery;\n\n/*" 3

    while {[orafetch $daily_cursor -dataarray row -indexbyname] != 1403} {
        set network $row(NETWORK)
        switch $network {
            "ACCEL" {
                set ACCEL_COUNT $row(COUNT)
                set ACCEL_AMOUNT $row(AMOUNT)
            }
            "AFFN" {
                set AFFN_COUNT $row(COUNT)
                set AFFN_AMOUNT $row(AMOUNT)
            }
            "ALASKA_OPTION" {
                set ALASKA_OPTION_COUNT $row(COUNT)
                set ALASKA_OPTION_AMOUNT $row(AMOUNT)
            }
            "CU24" {
                set CU24_COUNT $row(COUNT)
                set CU24_AMOUNT $row(AMOUNT)
            }
            "EBT" {
                set EBT_COUNT $row(COUNT)
                set EBT_AMOUNT $row(AMOUNT)
            }
            "INTERAC" {
                set INTERAC_COUNT $row(COUNT)
                set INTERAC_AMOUNT $row(AMOUNT)
            }
            "INTERLINK" {
                set INTERLINK_COUNT $row(COUNT)
                set INTERLINK_AMOUNT $row(AMOUNT)
            }
            "MAESTRO" {
                set MAESTRO_COUNT $row(COUNT)
                set MAESTRO_AMOUNT $row(AMOUNT)
            }
            "NETS" {
                set NETS_COUNT $row(COUNT)
                set NETS_AMOUNT $row(AMOUNT)
            }
            "NYCE" {
                set NYCE_COUNT $row(COUNT)
                set NYCE_AMOUNT $row(AMOUNT)
            }
            "PULSE" {
                set PULSE_COUNT $row(COUNT)
                set PULSE_AMOUNT $row(AMOUNT)
            }
            "SHAZAM" {
                set SHAZAM_COUNT $row(COUNT)
                set SHAZAM_AMOUNT $row(AMOUNT)
            }
            "STAR" {
                set STAR_COUNT $row(COUNT)
                set STAR_AMOUNT $row(AMOUNT)
            }
        }
    }
    puts $cur_file "             ACCEL,$ACCEL_COUNT ,\$$ACCEL_AMOUNT"
    puts $cur_file "             AFFN,$AFFN_COUNT,\$$AFFN_AMOUNT"
    puts $cur_file "             ALASKA OPTION,$ALASKA_OPTION_COUNT,\$$ALASKA_OPTION_AMOUNT"
    puts $cur_file "             CU24,$CU24_COUNT,\$$CU24_AMOUNT"
    puts $cur_file "             EBT,$EBT_COUNT,\$$EBT_AMOUNT"
    puts $cur_file "             INTERAC,$INTERAC_COUNT,\$$INTERAC_AMOUNT"
    puts $cur_file "             INTERLINK,$INTERLINK_COUNT,\$$INTERLINK_AMOUNT"
    puts $cur_file "             MAESTRO,$MAESTRO_COUNT,\$$MAESTRO_AMOUNT"
    puts $cur_file "             NETS,$NETS_COUNT,\$$NETS_AMOUNT"
    puts $cur_file "             NYCE,$NYCE_COUNT,\$$NYCE_AMOUNT"
    puts $cur_file "             PULSE,$PULSE_COUNT,\$$PULSE_AMOUNT"
    puts $cur_file "             SHAZAM,$SHAZAM_COUNT,\$$SHAZAM_AMOUNT"
    puts $cur_file "             STAR,$STAR_COUNT,\$$STAR_AMOUNT"
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
           set file_name  "$sql_inst.Daily_Detail_v3_nxdy.$filedate.csv"
      } else {
           set file_name  "$sql_inst.Daily_Detail_v3_Cycle.$arg_cycle.$filedate.csv"
      }
} else {
       set file_name  "$sql_inst.Daily_Detail_v3.$filedate.csv"
}

set cur_file      [open "$file_name" w]

do_report $sql_inst

close $cur_file

exec echo "Please see attached." | mutt -a "$file_name" -s "$box:$file_name" -- "$mail_to"

exec mv $file_name ./ARCHIVE

oraclose $daily_cursor

oralogoff $clr_logon_handle
