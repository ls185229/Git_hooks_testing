#!/usr/local/bin/tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: nxdy_funding_dd_cycle_5.tcl 4054 2017-02-06 23:16:14Z millig $
# $Rev: 4054 $
################################################################################
#
#  Usage: all-daily-detail.tcl -I nnn \[nnn\]... \[-D yyyymmdd\]"
#
#  eg.    all-daily-detail.tcl -i 101
#         all-daily-detail.tcl -i 101 -d 20120421
#         all-daily-detail.tcl -i 101 -i 107 -i 112 -i 113 -d 20120421
#
################################################################################

# Environment veriables.......

set clrdb $env(SEC_DB)
# set clrdb trnclr4

# Mode
# set mode "TEST"
set mode "PROD"

#===============================================================================

package require Oratcl

if {[catch {set handler [oralogon masclr/masclr@$clrdb]} result]} {
    puts ">>>$result<<<"
#   exec echo "daily-detail.tcl failed to run" | mutt -s "daily-detail.tcl failed to run" $mailtolist
    exit 1
}

set daily_cursor [oraopen $handler]

proc prev_day_SQLConstr {columnName} {
    global yesterday date
    return "$columnName >= '$yesterday' and $columnName < '$date'"
}

proc IS_cur_day {columnName} {
    global tomorrow date
    return "($columnName >= '$date' and $columnName < '$tomorrow')"
}


proc arg_parse {} {
    global argv institutions_arg date_arg

    #scan for Date
    if { [regexp -- {(-[dD])[ ]+([0-9]{8,8})} $argv dummy1 dummy2 arg_date] } {
        puts "Date argument: $arg_date"
        set date_arg $arg_date
    }

    #scan for Institutions. -i 101 -i 107 -i 112
    set numInst 0
    set numInst [regexp -all -- {-[iI][ ]+([0-9]{3})} $argv]

    if { $numInst > 0 } {

        set institutions_arg ""
        set res_lst [regexp -all -inline -- {-[iI][ ]+([0-9]{3})} $argv]

        for {set x 0} {$x<$numInst} {incr x} {
            set institutions_arg "$institutions_arg [lrange $res_lst [expr ($x * 2) + 1] [expr ($x * 2) + 1]]"
        }

        set institutions_arg [string trim $institutions_arg]
        puts "Institutions: $institutions_arg"
       }
}


#===============================================================================
#                          time settings and arguments
#===============================================================================
proc init_dates {val} {
    global date mydate filedate tomorrow yesterday report_ddate report_mdate report_mddate
    global report_yesterday_mddate CUR_JULIAN_DATEX report_DD

    set date      [string toupper [clock format [clock scan "$val"] -format %d-%b-%Y]]   ;# 21-MAR-08
    set mydate    [string toupper [clock format [clock scan "$date"] -format %b-%Y]]     ;# MAR-08
    set filedate  [clock format   [clock scan " $date -0 day"] -format %Y%m%d]           ;# 20080321

    set tomorrow  [string toupper [clock format [clock scan " $date +1 day"] -format %d-%b-%Y]]
    set yesterday [string toupper [clock format [clock scan " $date -1 day"] -format %d-%b-%Y]]

    set report_ddate            [clock format [clock scan " $date -0 day"] -format %m/%d/%y]  ;# 03/21/08
    set report_mdate            [clock format [clock scan " $date -0 day"] -format %m/%y]
    set report_mddate           [clock format [clock scan " $date -0 day"] -format %m/%d]
    set report_DD               [clock format [clock scan " $date -0 day"] -format %d]
    set report_yesterday_mddate [clock format [clock scan " $date -1 day"] -format %m/%d]

    set CUR_JULIAN_DATEX [string range [clock format [clock scan "$date"] -format "%y%j"] 1 4]
    puts " date is $date....tomorrow is $tomorrow.....mydate is $mydate "
    puts " To run this report on previous date: put date argument after script name (format like 20080320):  "
}

proc report {inst} {
    puts "running for $inst"

    global daily_cursor
    global yesterday report_DD mode
    global mydate report_ddate report_mdate test_cursor1 cur_file date
    global fetch_cursor tomorrow report_yesterday_mddate report_mddate

    puts $cur_file "DAILY DETAIL REPORT"
    puts $cur_file "DATE,FOR: $report_ddate,,,,, FOR: MONTH TO DATE $report_mdate,,"
    puts $cur_file "    "
    puts $cur_file "    "
    puts $cur_file "TRANSACTIONS,COUNT, AMOUNT,FEES,ACCOUNT EFFECT,,COUNT, AMOUNT,FEES,ACCOUNT EFFECT\r\n"

    set institution_lst [string map {, " "} $inst ]

    set sql_inst ""
    foreach x $institution_lst {
        set sql_inst "$sql_inst '$x',"
    }

    set sql_inst [string trimright $sql_inst ","]

#===============================================================================
    set    ACH_AMOUNT           0
    set    ACH_COUNT            0
    set    MACH_AMOUNT          0
    set    MACH_COUNT           0
    set    CHR_AMOUNT           0
    set    CHR_C_AMOUNT         0
    set    CHR_D_AMOUNT         0
    set    CHR_C_FEE            0
    set    CHR_D_FEE            0
    set    CHR_FEE              0
    set    CHR_COUNT            0
    set    MCHR_AMOUNT          0
    set    MCHR_C_AMOUNT        0
    set    MCHR_D_AMOUNT        0
    set    MCHR_D_FEE           0
    set    MCHR_C_FEE           0
    set    MCHR_COUNT           0
    set    MCHR_FEE             0
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
    set    MREP_AMOUNT          0
    set    MREP_C_AMOUNT        0
    set    MREP_D_AMOUNT        0
    set    MREP_COUNT           0
    set    MREP_FEE             0
    set    RESERVE              0
    set    TODAY_RESERVE        0
    set    TOTAL_RESERVE        0
    set    TODAY_RESERVE_PAID   0
    set    SUB_TODAY_RESERVE    0

    set JPC_LST "('402529413000010','402529413000011','402529213000012','402529213000013',
                  '402529213000014','402529213000015','402529213000017','402529213000018')" 

###
# Daily Sales. We'll pull the entire month-to-date in order to retrieve m-t-d and
# the day in question using a single query
###

    set IS_SALES "tid in ('010003005102', '010003005101', '010003005201', '010003005202', 
                          '010003005104', '010003005204', '010003005103', '010003005203')"
    set IS_CHGBK "tid in ('010003015101','010003015102','010003015201','010003015210','010003015301')"
    set IS_REPR  "TID in ('010003005301', '010003005401', '010003010102','010003010101')"

    set daily_sales_str "
    SELECT TO_CHAR( gl_date, 'DD') dd,
      sum(CASE WHEN( $IS_SALES and card_scheme = '02') then 1 else 0 end ) as DB_COUNT,
      sum(CASE WHEN( $IS_SALES and card_scheme = '03') then 1 else 0 end ) as AMEX_COUNT,
      sum(CASE WHEN( $IS_SALES and card_scheme = '04') then 1 else 0 end ) as VS_COUNT,
      sum(CASE WHEN( $IS_SALES and card_scheme = '05') then 1 else 0 end ) as MC_COUNT,
      sum(CASE WHEN( $IS_SALES and card_scheme = '08') then 1 else 0 end ) as DISC_COUNT,
      sum(CASE WHEN( $IS_SALES and card_scheme = '09') then 1 else 0 end ) as JCB_COUNT,
      sum(CASE WHEN( $IS_REPR) then 1 else 0 end ) as REP_COUNT,
      sum(CASE WHEN( $IS_CHGBK ) then 1 else 0 end) as CHR_COUNT,
      sum(CASE WHEN( TID in ( '010123005102', '010123005101')) then 1 else 0 end) as MISC_COUNT,
      sum(CASE WHEN( $IS_SALES and TID_SETTL_METHOD = 'C' and card_scheme = '02') then AMT_ORIGINAL else 0 end ) as DB_AMOUNT,
      sum(CASE WHEN( $IS_SALES and TID_SETTL_METHOD = 'C' and card_scheme = '03') then AMT_ORIGINAL else 0 end ) as AMEX_AMOUNT,
      sum(CASE WHEN( $IS_SALES and TID_SETTL_METHOD = 'C' and card_scheme = '04') then AMT_ORIGINAL else 0 end ) as VS_AMOUNT,
      sum(CASE WHEN( $IS_SALES and TID_SETTL_METHOD = 'C' and card_scheme = '05') then AMT_ORIGINAL else 0 end ) as MC_AMOUNT,
      sum(CASE WHEN( $IS_SALES and TID_SETTL_METHOD = 'C' and card_scheme = '08') then AMT_ORIGINAL else 0 end ) as DISC_AMOUNT,
      sum(CASE WHEN( $IS_SALES and TID_SETTL_METHOD = 'C' and card_scheme = '09') then AMT_ORIGINAL else 0 end ) as JCB_AMOUNT,
      sum(CASE WHEN( $IS_REPR and TID_SETTL_METHOD = 'C' ) then AMT_ORIGINAL else 0 end ) as REP_C_AMOUNT,
      sum(CASE WHEN( $IS_REPR and TID_SETTL_METHOD <> 'C' ) then AMT_ORIGINAL else 0 end) as REP_D_AMOUNT,
      sum(CASE WHEN( $IS_CHGBK and TID_SETTL_METHOD = 'C' ) then AMT_ORIGINAL else 0 end) as CHR_C_AMOUNT,
      sum(CASE WHEN( $IS_CHGBK and TID_SETTL_METHOD <> 'C' ) then AMT_ORIGINAL else 0 end) as CHR_D_AMOUNT,
      sum(CASE WHEN( TID in ('010123005101', '010123005102') and TID_SETTL_METHOD = 'C' )
               then AMT_ORIGINAL else 0 end) as MISC_C_AMOUNT,
      sum(CASE WHEN( TID in ('010123005101', '010123005102') and TID_SETTL_METHOD <> 'C' )
               then AMT_ORIGINAL else 0 end) as MISC_D_AMOUNT,
      sum(CASE WHEN( $IS_SALES and TID_SETTL_METHOD <> 'C' and card_scheme = '02')
               then AMT_ORIGINAL else 0 end ) as DB_REFUND_AMOUNT,
      sum(CASE WHEN( $IS_SALES and TID_SETTL_METHOD <> 'C' and card_scheme = '03')
               then AMT_ORIGINAL else 0 end ) as AMEX_REFUND_AMOUNT,
      sum(CASE WHEN( $IS_SALES and TID_SETTL_METHOD <> 'C' and card_scheme = '04')
               then AMT_ORIGINAL else 0 end ) as VS_REFUND_AMOUNT,
      sum(CASE WHEN( $IS_SALES and TID_SETTL_METHOD <> 'C' and card_scheme = '05')
               then AMT_ORIGINAL else 0 end ) as MC_REFUND_AMOUNT,
      sum(CASE WHEN( $IS_SALES and TID_SETTL_METHOD <> 'C' and card_scheme = '08')
               then AMT_ORIGINAL else 0 end ) as DISC_REFUND_AMOUNT,
      sum(CASE WHEN( $IS_SALES and TID_SETTL_METHOD <> 'C' and card_scheme = '09')
               then AMT_ORIGINAL else 0 end ) as JCB_REFUND_AMOUNT
    FROM mas_trans_log
    WHERE institution_id in ($sql_inst)
      AND gl_date >= '01-$mydate'
      AND gl_date < '$tomorrow'
      AND settl_flag = 'Y'
    GROUP BY TO_CHAR( gl_date, 'DD')"

    orasql $daily_cursor $daily_sales_str
#   puts "daily_sales_str: $daily_sales_str"
    while {[orafetch $daily_cursor -dataarray s -indexbyname] != 1403} {

    if {$report_DD == $s(DD)} {
	set REP_COUNT		[expr $REP_COUNT + $s(REP_COUNT)]    
	set CHR_COUNT		[expr $CHR_COUNT + $s(CHR_COUNT)]
	set MISC_COUNT		[expr $MISC_COUNT + $s(MISC_COUNT)]
	set VISA_COUNT		[expr $VISA_COUNT + $s(VS_COUNT)]
	set MC_COUNT		[expr $MC_COUNT + $s(MC_COUNT)]
	set AMEX_COUNT		[expr $AMEX_COUNT + $s(AMEX_COUNT)]
	set DISC_COUNT		[expr $DISC_COUNT + $s(DISC_COUNT)]
	set DB_COUNT		[expr $DB_COUNT + $s(DB_COUNT)]
	set JCB_COUNT		[expr $JCB_COUNT + $s(JCB_COUNT)]
	set VISA_AMOUNT		[expr $VISA_AMOUNT + $s(VS_AMOUNT)]
	set MC_AMOUNT		[expr $MC_AMOUNT + $s(MC_AMOUNT)]
	set AMEX_AMOUNT		[expr $AMEX_AMOUNT + $s(AMEX_AMOUNT)]
	set DISC_AMOUNT		[expr $DISC_AMOUNT + $s(DISC_AMOUNT)]
	set DB_AMOUNT		[expr $DB_AMOUNT + $s(DB_AMOUNT)]
	set JCB_AMOUNT		[expr $JCB_AMOUNT + $s(JCB_AMOUNT)]
	set REP_AMOUNT		[expr $REP_AMOUNT + [expr $s(REP_C_AMOUNT) - $s(REP_D_AMOUNT)]]
	set CHR_AMOUNT		[expr $CHR_AMOUNT + [expr $s(CHR_C_AMOUNT) - $s(CHR_D_AMOUNT)]]
	set MISC_AMOUNT		[expr $MISC_AMOUNT + [expr $s(MISC_C_AMOUNT) - $s(MISC_D_AMOUNT)]]
	set VS_REFUND_AMOUNT	[expr $VS_REFUND_AMOUNT + $s(VS_REFUND_AMOUNT)]
	set MC_REFUND_AMOUNT	[expr $MC_REFUND_AMOUNT + $s(MC_REFUND_AMOUNT)]
	set AMEX_REFUND_AMOUNT	[expr $AMEX_REFUND_AMOUNT + $s(AMEX_REFUND_AMOUNT)] 
	set DISC_REFUND_AMOUNT	[expr $DISC_REFUND_AMOUNT + $s(DISC_REFUND_AMOUNT)]  
	set DB_REFUND_AMOUNT	[expr $DB_REFUND_AMOUNT + $s(DB_REFUND_AMOUNT)]
	set JCB_REFUND_AMOUNT	[expr $JCB_REFUND_AMOUNT + $s(JCB_REFUND_AMOUNT)]
    }
		
	set MREP_COUNT		[expr $MREP_COUNT + $s(REP_COUNT)]
	set MCHR_COUNT		[expr $MCHR_COUNT + $s(CHR_COUNT)] 
	set MMISC_COUNT		[expr $MMISC_COUNT + $s(MISC_COUNT)]
	set MVISA_COUNT		[expr $MVISA_COUNT + $s(VS_COUNT)]
	set MMC_COUNT		[expr $MMC_COUNT + $s(MC_COUNT)]
	set MAMEX_COUNT		[expr $MAMEX_COUNT + $s(AMEX_COUNT)]
	set MDISC_COUNT		[expr $MDISC_COUNT + $s(DISC_COUNT)]
	set MDB_COUNT		[expr $MDB_COUNT + $s(DB_COUNT)]
	set MJCB_COUNT		[expr $MJCB_COUNT + $s(JCB_COUNT)]
	set MVISA_AMOUNT	[expr $MVISA_AMOUNT + $s(VS_AMOUNT)]
	set MMC_AMOUNT		[expr $MMC_AMOUNT + $s(MC_AMOUNT)]
	set MAMEX_AMOUNT	[expr $MAMEX_AMOUNT + $s(AMEX_AMOUNT)]
	set MDISC_AMOUNT	[expr $MDISC_AMOUNT + $s(DISC_AMOUNT)]
	set MDB_AMOUNT		[expr $MDB_AMOUNT + $s(DB_AMOUNT)]
	set MJCB_AMOUNT		[expr $MJCB_AMOUNT + $s(JCB_AMOUNT)]
	set MREP_AMOUNT		[expr $MREP_AMOUNT + [expr $s(REP_C_AMOUNT) - $s(REP_D_AMOUNT)]]
	set MCHR_AMOUNT		[expr $MCHR_AMOUNT + [expr $s(CHR_C_AMOUNT) - $s(CHR_D_AMOUNT)]]
	set MMISC_AMOUNT	[expr $MMISC_AMOUNT + [expr $s(MISC_C_AMOUNT) - $s(MISC_D_AMOUNT)]]
	set MVS_REFUND_AMOUNT	[expr $MVS_REFUND_AMOUNT + $s(VS_REFUND_AMOUNT)]
	set MMC_REFUND_AMOUNT	[expr $MMC_REFUND_AMOUNT + $s(MC_REFUND_AMOUNT)]
	set MAMEX_REFUND_AMOUNT	[expr $MAMEX_REFUND_AMOUNT + $s(AMEX_REFUND_AMOUNT)]
	set MDISC_REFUND_AMOUNT	[expr $MDISC_REFUND_AMOUNT + $s(DISC_REFUND_AMOUNT)]
	set MDB_REFUND_AMOUNT	[expr $MDB_REFUND_AMOUNT + $s(DB_REFUND_AMOUNT)]
	set MJCB_REFUND_AMOUNT	[expr $MJCB_REFUND_AMOUNT + $s(JCB_REFUND_AMOUNT)]

	}
	
	puts "sales_str is done at [clock format [clock seconds]]"

###
#  Daily fees. We'll pull the entire month-to-date in order to retrieve m-t-d and
#  the day in question using a single query
###
    set daily_fees_str "
    SELECT TO_CHAR( aad.PAYMENT_PROC_DT, 'DD') dd,
      sum(CASE WHEN( mtl.card_scheme = '02' and tid_settl_method = 'C')  then AMT_ORIGINAL else 0 end) as DB_C_FEE,
      sum(CASE WHEN( mtl.card_scheme = '02' and tid_settl_method <> 'C') then AMT_ORIGINAL else 0 end) as DB_D_FEE,
      sum(CASE WHEN( mtl.card_scheme = '03' and tid_settl_method = 'C')  then AMT_ORIGINAL else 0 end) as AMEX_C_FEE,
      sum(CASE WHEN( mtl.card_scheme = '03' and tid_settl_method <> 'C') then AMT_ORIGINAL else 0 end) as AMEX_D_FEE,
      sum(CASE WHEN( mtl.card_scheme = '04' and tid_settl_method = 'C')  then AMT_ORIGINAL else 0 end) as VISA_C_FEE,
      sum(CASE WHEN( mtl.card_scheme = '04' and tid_settl_method <> 'C') then AMT_ORIGINAL else 0 end) as VISA_D_FEE,
      sum(CASE WHEN( mtl.card_scheme = '05' and tid_settl_method = 'C')  then AMT_ORIGINAL else 0 end) as MC_C_FEE,
      sum(CASE WHEN( mtl.card_scheme = '05' and tid_settl_method <> 'C') then AMT_ORIGINAL else 0 end) as MC_D_FEE,
      sum(CASE WHEN( mtl.card_scheme = '08' and tid_settl_method = 'C')  then AMT_ORIGINAL else 0 end) as DISC_C_FEE,
      sum(CASE WHEN( mtl.card_scheme = '08' and tid_settl_method <> 'C') then AMT_ORIGINAL else 0 end) as DISC_D_FEE,
      sum(CASE WHEN( mtl.card_scheme = '09' and tid_settl_method = 'C')  then AMT_ORIGINAL else 0 end) as JCB_C_FEE,
      sum(CASE WHEN( mtl.card_scheme = '09' and tid_settl_method <> 'C') then AMT_ORIGINAL else 0 end) as JCB_D_FEE,
      sum(CASE WHEN( mtl.tid_settl_method =  'C' and card_scheme not in ('02', '03', '04', '05', '08', '12'))
               then AMT_ORIGINAL else 0 end) as OTHER_C_FEE,
      sum(CASE WHEN( mtl.tid_settl_method <> 'C' and card_scheme not in ('02', '03', '04', '05', '08', '12'))
               then AMT_ORIGINAL else 0 end) as OTHER_D_FEE,
      sum(CASE WHEN( mtl.TID_SETTL_METHOD = 'C' and TID in ('010004160000', '010004160001'))
               then AMT_ORIGINAL else 0 end) as CHR_C_FEE,
      sum(CASE WHEN( mtl.TID_SETTL_METHOD <> 'C' and TID in ('010004160000', '010004160001'))
               then AMT_ORIGINAL else 0 end) as CHR_D_FEE
    FROM mas_trans_log mtl, (select PAYMENT_SEQ_NBR, PAYMENT_PROC_DT, institution_id
                             from ACCT_ACCUM_DET
                             where PAYMENT_PROC_DT >= '01-$mydate' AND PAYMENT_PROC_DT < '$tomorrow'
                                 and institution_id in ($sql_inst)
                                 and payment_cycle = '5'
                                 and payment_status = 'P'
                                 and (institution_id,entity_acct_id) not in (select institution_id,entity_acct_id
                                                                             from entity_acct
                                                                             where institution_id in ($sql_inst)
                                                                                and stop_pay_flag = 'Y')) aad
    WHERE (mtl.PAYMENT_SEQ_NBR = aad.PAYMENT_SEQ_NBR AND mtl.institution_id = aad.institution_id)
       AND mtl.institution_id in ($sql_inst)
       AND (substr(mtl.tid, 1,8) = '01000507' OR substr(mtl.tid, 1,6) in ('010004','010040','010050','010080','010014'))
       AND mtl.settl_flag = 'Y'
    GROUP BY TO_CHAR( aad.PAYMENT_PROC_DT, 'DD')"

    puts "daily_fees_str: $daily_fees_str"

    orasql $daily_cursor $daily_fees_str

    while {[orafetch $daily_cursor -dataarray f -indexbyname] != 1403} {
       if {$report_DD == $f(DD)} {
    	    set MC_FEE            [expr $MC_FEE    + [expr $f(MC_C_FEE)    - $f(MC_D_FEE)]]
	    set VISA_FEE          [expr $VISA_FEE  + [expr $f(VISA_C_FEE)  - $f(VISA_D_FEE)]] 
	    set DB_FEE            [expr $DB_FEE    + [expr $f(DB_C_FEE)    - $f(DB_D_FEE)]]
	    set AMEX_FEE          [expr $AMEX_FEE  + [expr $f(AMEX_C_FEE)  - $f(AMEX_D_FEE)]]
	    set DISC_FEE          [expr $DISC_FEE  + [expr $f(DISC_C_FEE)  - $f(DISC_D_FEE)]] 
	    set JCB_FEE           [expr $JCB_FEE   + [expr $f(JCB_C_FEE)   - $f(JCB_D_FEE)]]
	    set OTHER_FEE         [expr $OTHER_FEE + [expr $f(OTHER_C_FEE) - $f(OTHER_D_FEE)]]
	    set CHR_FEE           [expr $CHR_FEE   + [expr $f(CHR_C_FEE)   - $f(CHR_D_FEE)]] 
      }

      set MMC_FEE		[expr $MMC_FEE    + [expr $f(MC_C_FEE)    - $f(MC_D_FEE)]]
      set MVISA_FEE		[expr $MVISA_FEE  + [expr $f(VISA_C_FEE)  - $f(VISA_D_FEE)]]
      set MDB_FEE		[expr $MDB_FEE    + [expr $f(DB_C_FEE)    - $f(DB_D_FEE) ]]
      set MAMEX_FEE		[expr $MAMEX_FEE  + [expr $f(AMEX_C_FEE)  - $f(AMEX_D_FEE)]] 
      set MDISC_FEE		[expr $MDISC_FEE  + [expr $f(DISC_C_FEE)  - $f(DISC_D_FEE)]]
      set MJCB_FEE		[expr $MJCB_FEE   + [expr $f(JCB_C_FEE)   - $f(JCB_D_FEE)  ]]
      set MOTHER_FEE		[expr $MOTHER_FEE + [expr $f(OTHER_C_FEE) - $f(OTHER_D_FEE)]]
      set MCHR_FEE		[expr $MCHR_FEE   + [expr $f(CHR_C_FEE)   - $f(CHR_D_FEE)]]
    }

    puts "daily_fees_str is done at [clock format [clock seconds]]"
      
###
# Beginning and end balance. 
# NOTE: [ m.gl_date < '$tomorrow' ] used here to capture a snapshot of this report (as if 
#       it was actually ran on the historical date). It Excludes data that came in after the date in question.
###
	
    set IS_C "m.tid_settl_method = 'C'"
    set IS_D "m.tid_settl_method <> 'C'"
    set NOT_PAID_YESTERDAY "(m.gl_date < '$date' and (aad.payment_status is null or trunc(aad.payment_proc_dt) > '$yesterday'))"
    set NOT_PAID_TODAY 	   "(m.gl_date < '$tomorrow' and (aad.payment_status is null or trunc(aad.payment_proc_dt) > '$date'))"
	
    set payables_qry "
    SELECT
      sum(CASE WHEN( $NOT_PAID_YESTERDAY and $IS_C ) then m.AMT_ORIGINAL else 0 end) as BEGIN_PAYBL_BAL_C,
      sum(CASE WHEN( $NOT_PAID_YESTERDAY and $IS_D ) then m.AMT_ORIGINAL else 0 end) as BEGIN_PAYBL_BAL_D,
      sum(CASE WHEN( $NOT_PAID_YESTERDAY ) then 1 else 0 end) as BEGIN_PAYBL_BAL_COUNT,
      sum(CASE WHEN( $NOT_PAID_TODAY and $IS_C ) then m.AMT_ORIGINAL else 0 end) as END_PAYBL_BAL_C,
      sum(CASE WHEN( $NOT_PAID_TODAY and $IS_D ) then m.AMT_ORIGINAL else 0 end) as END_PAYBL_BAL_D,
      sum(CASE WHEN( $NOT_PAID_TODAY ) then 1 else 0 end) as END_PAYBL_BAL_COUNT  
    FROM mas_trans_log m, (select payment_seq_nbr, payment_proc_dt, payment_status, institution_id
			   from acct_accum_det
			   where institution_id in ($sql_inst)
		       	     and (institution_id,entity_acct_id) not in (select institution_id,entity_acct_id
									 from entity_acct
									 where institution_id in ($sql_inst)
									   and stop_pay_flag = 'Y')
									   and (payment_status is null or 
                                                                                trunc(payment_proc_dt) > '$yesterday')) aad
    WHERE (m.payment_seq_nbr = aad.payment_seq_nbr AND m.institution_id = aad.institution_id)
      AND m.institution_id in ($sql_inst)
      AND m.SETTL_FLAG = 'Y'
      AND (m.tid in ('010003005101','010003005102','010003005301','010003010102',
                     '010003010101','010003005103', '010003005203'))
      AND m.gl_date < '$tomorrow'"

# puts $payables_qry
    orasql $daily_cursor $payables_qry
     
    while {[orafetch $daily_cursor -dataarray dscnt -indexbyname] != 1403} {
#     to manipulate the data to the format bank wants
      set BEGIN_PAYBL_BAL [expr $dscnt(BEGIN_PAYBL_BAL_D) - $dscnt(BEGIN_PAYBL_BAL_C) ] 
      set BEGIN_PAYBL_BAL_COUNT $dscnt(BEGIN_PAYBL_BAL_COUNT)
      set END_PAYBL_BAL [expr  $dscnt(END_PAYBL_BAL_D) -  $dscnt(END_PAYBL_BAL_C) ]
      set END_PAYBL_BAL_COUNT $dscnt(END_PAYBL_BAL_COUNT)
		
    }

    puts "Begin and end payables balance is done at [clock format [clock seconds]]"		

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
		
    set IS_C "mtl.tid_settl_method = 'C'"
    set IS_D "mtl.tid_settl_method <> 'C'"
	
    set NOT_PAID_YESTERDAY "(mtl.gl_date < '$date' and (aad.payment_status is null or aad.payment_status = 'C' \
			     or (aad.payment_status = 'P' and trunc(aad.payment_proc_dt) > '$yesterday')))"
														
    set NOT_PAID_TODAY "(mtl.gl_date < '$tomorrow' and (aad.payment_status is null or aad.payment_status = 'C' \
			 or (aad.payment_status = 'P' and trunc(aad.payment_proc_dt) > '$date')))"
		
    set res_qry "
    SELECT 
      sum(CASE WHEN( [IS_cur_day aad.payment_proc_dt] and $IS_C and $IS_RES_RELEASE) then mtl.AMT_ORIGINAL else 0 end) as RELEASE_C,
      sum(CASE WHEN( [IS_cur_day aad.payment_proc_dt] and $IS_D and $IS_RES_RELEASE) then mtl.AMT_ORIGINAL else 0 end) as RELEASE_D,
      sum(CASE WHEN( [IS_cur_day aad.payment_proc_dt] and $IS_C and $IS_ADDED_RES) then mtl.AMT_ORIGINAL else 0 end) as ADDITION_C,
      sum(CASE WHEN( [IS_cur_day aad.payment_proc_dt] and $IS_D and $IS_ADDED_RES) then mtl.AMT_ORIGINAL else 0 end) as ADDITION_D,
      sum(CASE WHEN( $IS_RES_NOT_PAID AND $NOT_PAID_YESTERDAY and $IS_C) then mtl.AMT_ORIGINAL else 0 end) as YEST_END_C,
      sum(CASE WHEN( $IS_RES_NOT_PAID AND $NOT_PAID_YESTERDAY and $IS_D) then mtl.AMT_ORIGINAL else 0 end) as YEST_END_D,
      sum(CASE WHEN( $IS_RES_NOT_PAID AND $NOT_PAID_TODAY and $IS_C) then mtl.AMT_ORIGINAL else 0 end) as TODAY_END_C,
      sum(CASE WHEN( $IS_RES_NOT_PAID AND $NOT_PAID_TODAY and $IS_D) then mtl.AMT_ORIGINAL else 0 end) as TODAY_END_D
    FROM mas_trans_log mtl, (select payment_seq_nbr, payment_proc_dt, payment_status, institution_id
			     from acct_accum_det
			     where institution_id in ($sql_inst)
			       and (institution_id,entity_acct_id) in (select institution_id,entity_acct_id
								       from entity_acct
			       					       where OWNER_ENTITY_ID in ($HAS_RESERVES))
									 and (payment_status is null or payment_status = 'C' 
                                                                              or trunc(payment_proc_dt)  > '$yesterday')) aad
    WHERE (mtl.payment_seq_nbr = aad.payment_seq_nbr AND mtl.institution_id = aad.institution_id)
      AND mtl.institution_id in ($sql_inst)
      AND mtl.gl_date < '$tomorrow'
      AND (substr(mtl.tid,1,8) = '01000705' or substr(mtl.tid,1,8) = '01000505')"

    puts $res_qry

    orasql $daily_cursor $res_qry
	
    while {[orafetch $daily_cursor -dataarray res -indexbyname] != 1403} {
	    set RESERVE_ADDED_TODAY [expr $res(ADDITION_C) - $res(ADDITION_D)]
	    set TODAY_RESERVE_PAID  [expr $res(RELEASE_C) - $res(RELEASE_D)]
	    set SUB_TODAY_RESERVE   [expr $RESERVE_ADDED_TODAY + $TODAY_RESERVE_PAID]		
	    set BEGIN_RESERVE	    [expr $res(YEST_END_D) - $res(YEST_END_C)]
	    set ENDING_RESERVE	    [expr $res(TODAY_END_D) - $res(TODAY_END_C)]
    }


    set VISA_AMOUNT	[expr $VISA_AMOUNT - $VS_REFUND_AMOUNT]
    set MC_AMOUNT	[expr $MC_AMOUNT - $MC_REFUND_AMOUNT]
    set AMEX_AMOUNT	[expr $AMEX_AMOUNT - $AMEX_REFUND_AMOUNT]
    set DISC_AMOUNT	[expr $DISC_AMOUNT - $DISC_REFUND_AMOUNT]
    set DB_AMOUNT	[expr $DB_AMOUNT - $DB_REFUND_AMOUNT]
    set JCB_AMOUNT	[expr $JCB_AMOUNT - $JCB_REFUND_AMOUNT]
    set MMC_AMOUNT	[expr $MMC_AMOUNT - $MMC_REFUND_AMOUNT]
    set MVISA_AMOUNT	[expr $MVISA_AMOUNT - $MVS_REFUND_AMOUNT]
    set MAMEX_AMOUNT	[expr $MAMEX_AMOUNT - $MAMEX_REFUND_AMOUNT]
    set MDISC_AMOUNT	[expr $MDISC_AMOUNT - $MDISC_REFUND_AMOUNT ]
    set MDB_AMOUNT	[expr $MDB_AMOUNT - $MDB_REFUND_AMOUNT ]
    set MJCB_AMOUNT	[expr $MJCB_AMOUNT - $MJCB_REFUND_AMOUNT]

	
#********    Pull ACH counts and amounts   **********#
    
    set query_string_ach " 
        select sum(amt_fee) as FEE, sum(amt_pay) as PAYMENT, count(1) as ACH_COUNT
        from ACCT_ACCUM_DET
        where [IS_cur_day PAYMENT_PROC_DT] 
          and institution_id in ($sql_inst)
          and payment_cycle = '5' "
	
    orasql $daily_cursor $query_string_ach

    while {[orafetch $daily_cursor -dataarray ach -indexbyname] != 1403} {
	    set ACH_AMOUNT [expr $ach(FEE) - $ach(PAYMENT)]
	    set ACH_COUNT  $ach(ACH_COUNT)
    }

    puts "query_string_ach is done at [clock format [clock seconds]]"

    set query_string "
        select sum(amt_fee) as MFEE, sum(amt_pay) as MPAYMENT, count(1) as MACH_COUNT
        from ACCT_ACCUM_DET
        where PAYMENT_PROC_DT >= trunc(TO_DATE( '$date', 'DD-MON-YY' ),'MM') 
          and PAYMENT_PROC_DT < '$tomorrow' 
          and institution_id in ($sql_inst)
          and payment_cycle = '5'"

	orasql $daily_cursor $query_string
	while {[orafetch $daily_cursor -dataarray mach -indexbyname] != 1403} {
		set MACH_AMOUNT [expr $mach(MFEE) - $mach(MPAYMENT)]
		set MACH_COUNT  $mach(MACH_COUNT)
	}

    puts "query_string is done at [clock format [clock seconds]]"

#*******    Pull the reject counts and amounts  *******#
 
    set query_string "                       
        select idm.activity_dt, t.tid, 
               sum(idm.amt_trans * decode(t.tid_settl_method, 'D', 1, -1))  as amt_trans,
               count(idm.pan) as count, idm.card_scheme
        from in_draft_main idm join tid t
             on (idm.tid = t.tid)
        where t.tid in ('010103005101', '010103005102', '010103005201', '010103005202')
          and idm.msg_text_block like '%JPREJECT%'
          and [prev_day_SQLConstr idm.activity_dt] 
          and idm.SEC_DEST_INST_ID in ($sql_inst)
        group by idm.activity_dt, t.tid, idm.card_scheme"

    orasql $daily_cursor $query_string

    while {[orafetch $daily_cursor -dataarray w -indexbyname] != 1403} {
        switch $w(CARD_SCHEME) {
            "03" {
                set X_ASSOCIATION_REJECT [expr $X_ASSOCIATION_REJECT + $w(AMT_TRANS)]
                set X_REJECT_COUNT       [expr $X_REJECT_COUNT + $w(COUNT)]
                }
            "04" {
                set V_ASSOCIATION_REJECT [expr $V_ASSOCIATION_REJECT + $w(AMT_TRANS)]
                set V_REJECT_COUNT       [expr $V_REJECT_COUNT + $w(COUNT)]
                }
            "05" {
                set M_ASSOCIATION_REJECT [expr $M_ASSOCIATION_REJECT + $w(AMT_TRANS)]
                set M_REJECT_COUNT       [expr $M_REJECT_COUNT + $w(COUNT)]
                }
            "08" {
                set D_ASSOCIATION_REJECT [expr $D_ASSOCIATION_REJECT + $w(AMT_TRANS)]
                set D_REJECT_COUNT       [expr $D_REJECT_COUNT + $w(COUNT)]
            }
        }
    }

    puts "Pull Reject is done at [clock format [clock seconds]]"     
 
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

# puts "date...$date"

    if {[string range $date 0 1] == "01" } {        
         set reject_mtd "
            select t.tid,
                   sum(idm.amt_trans * decode(t.tid_settl_method, 'D', 1, -1))  as amt_trans,
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
                   sum(idm.amt_trans * decode(t.tid_settl_method, 'D', 1, -1))  as amt_trans,
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
    puts "reject mtd....$reject_mtd"

    while {[orafetch $daily_cursor -dataarray mtdw -indexbyname] != 1403} {
        switch $mtdw(CARD_SCHEME) {
            "03" {
                set MTDX_ASSOCIATION_REJECT [expr $MTDX_ASSOCIATION_REJECT + $mtdw(AMT_TRANS)]
                set MTDX_REJECT_COUNT       [expr $MTDX_REJECT_COUNT + $mtdw(COUNT)]
                }
            "04" {
                set MTDV_ASSOCIATION_REJECT [expr $MTDV_ASSOCIATION_REJECT + $mtdw(AMT_TRANS)]
                set MTDV_REJECT_COUNT       [expr $MTDV_REJECT_COUNT + $mtdw(COUNT)]
                }
            "05" {
                set MTDM_ASSOCIATION_REJECT [expr $MTDM_ASSOCIATION_REJECT + $mtdw(AMT_TRANS)]
                set MTDM_REJECT_COUNT       [expr $MTDM_REJECT_COUNT + $mtdw(COUNT)]
                }
            "08" {
                set MTDD_ASSOCIATION_REJECT [expr $MTDD_ASSOCIATION_REJECT + $mtdw(AMT_TRANS)]
                set MTDD_REJECT_COUNT       [expr $MTDD_REJECT_COUNT + $mtdw(COUNT)]
            }
        }
    }

# puts $query_string

    set REJECT_COUNT        [expr $V_REJECT_COUNT + $M_REJECT_COUNT + $X_REJECT_COUNT + $D_REJECT_COUNT] 
      
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

    set REJECT_COUNT        [expr $V_REJECT_COUNT + $M_REJECT_COUNT + $X_REJECT_COUNT + $D_REJECT_COUNT]

    set MTD_REPROCESSED_REJECT [expr $MTD_REPROCESSED_REJECT - $MTDV_ASSOCIATION_REJECT - $MTDM_ASSOCIATION_REJECT \
                                                             - $MTDX_ASSOCIATION_REJECT - $MTDD_ASSOCIATION_REJECT]

    set MTD_REJECT_COUNT    [expr $MTDV_REJECT_COUNT + $MTDM_REJECT_COUNT + $MTDX_REJECT_COUNT + $MTDD_REJECT_COUNT]

    set VISA_AMOUNT         [expr $VISA_AMOUNT + $V_ASSOCIATION_REJECT]
    set MC_AMOUNT           [expr $MC_AMOUNT   + $M_ASSOCIATION_REJECT] 
    set AMEX_AMOUNT         [expr $AMEX_AMOUNT + $X_ASSOCIATION_REJECT]
    set DISC_AMOUNT         [expr $DISC_AMOUNT + $D_ASSOCIATION_REJECT] 

    set MMC_AMOUNT          [expr $MMC_AMOUNT   + $MTDM_ASSOCIATION_REJECT]   
    set MVISA_AMOUNT        [expr $MVISA_AMOUNT + $MTDV_ASSOCIATION_REJECT]
    set MAMEX_AMOUNT        [expr $MAMEX_AMOUNT + $MTDX_ASSOCIATION_REJECT]
    set MDISC_AMOUNT        [expr $MDISC_AMOUNT + $MTDD_ASSOCIATION_REJECT]

    set VISA_TOTAL          [expr $VISA_AMOUNT + $VISA_FEE]
    set MC_TOTAL            [expr $MC_AMOUNT   + $MC_FEE]
    set AMEX_TOTAL          [expr $AMEX_AMOUNT + $AMEX_FEE]  
    set DISC_TOTAL          [expr $DISC_AMOUNT + $DISC_FEE]
    set DB_TOTAL            [expr $DB_AMOUNT   + $DB_FEE]
    set JCB_TOTAL           [expr $JCB_AMOUNT  + $JCB_FEE] 

    set MVISA_TOTAL         [expr $MVISA_AMOUNT + $MVISA_FEE]
    set MMC_TOTAL           [expr $MMC_AMOUNT   + $MMC_FEE]
    set MDB_TOTAL           [expr $MDB_AMOUNT   + $MDB_FEE]
    set MAMEX_TOTAL         [expr $MAMEX_AMOUNT + $MAMEX_FEE]
    set MDISC_TOTAL         [expr $MDISC_AMOUNT + $MDISC_FEE]
    set MJCB_TOTAL          [expr $MJCB_AMOUNT  + $MJCB_FEE]

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
    set D_SUB_SCNT       [expr $VISA_COUNT + $MC_COUNT + $AMEX_COUNT + $DISC_COUNT + $JCB_COUNT + $DB_COUNT + $EBT_COUNT]
    set D_SUB_SAMT       [expr $VISA_AMOUNT + $MC_AMOUNT + $AMEX_AMOUNT + $DISC_AMOUNT + $DB_AMOUNT + $JCB_AMOUNT + $EBT_AMOUNT ]
    set D_SUB_FAMT       [expr $VISA_FEE + $MC_FEE + $AMEX_FEE + $DISC_FEE + $DB_FEE + $JCB_FEE + $EBT_FEE + $OTHER_FEE]
    set D_SUB_ACCTEFFECT [expr $VISA_TOTAL + $MC_TOTAL + $AMEX_TOTAL + $DISC_TOTAL + $JCB_TOTAL + $DB_TOTAL + $EBT_TOTAL + $OTHER_FEE]

#   Monthly:
    set M_SUB_SCNT       [expr $MVISA_COUNT + $MMC_COUNT + $MAMEX_COUNT + $MDISC_COUNT + $MJCB_COUNT + $MDB_COUNT + $MEBT_COUNT]
    set M_SUB_SAMT     [expr $MVISA_AMOUNT + $MMC_AMOUNT + $MAMEX_AMOUNT + $MDISC_AMOUNT + $MJCB_AMOUNT + $MDB_AMOUNT + $MEBT_AMOUNT]
    set M_SUB_FAMT       [expr $MVISA_FEE  + $MMC_FEE + $MAMEX_FEE + $MDISC_FEE + $MJCB_FEE + $MDB_FEE + $MEBT_FEE + $MOTHER_FEE]
    set M_SUB_ACCTEFFECT [expr $M_SUB_SAMT + $M_SUB_FAMT ] 

###############################################################################
##### unblock the following section to populate the report again.  ############
###############################################################################

#   puts $cur_file "VISA,$VISA_COUNT,$$VISA_AMOUNT,$$VISA_FEE,$$VISA_TOTAL,,$MVISA_COUNT,$$MVISA_AMOUNT,$$MVISA_FEE,\
#                   $[expr $MVISA_AMOUNT + $MVISA_FEE]"
#   puts $cur_file "MC,$MC_COUNT,$$MC_AMOUNT,$$MC_FEE,$$MC_TOTAL,,$MMC_COUNT,$$MMC_AMOUNT,$$MMC_FEE,$[expr $MMC_AMOUNT + $MMC_FEE]"
#   puts $cur_file "AMEX,$AMEX_COUNT,$$AMEX_AMOUNT,$$AMEX_FEE,$$AMEX_TOTAL,,$MAMEX_COUNT,$$MAMEX_AMOUNT,$$MAMEX_FEE,$$MAMEX_TOTAL"
#   puts $cur_file "DISC,$DISC_COUNT,$$DISC_AMOUNT,$$DISC_FEE,$$DISC_TOTAL,,$MDISC_COUNT,$$MDISC_AMOUNT,$$MDISC_FEE,$$MDISC_TOTAL"
##  puts $cur_file "TE,0.00,0.00,0.00,0.00,,0.00,0.00,0.00,0.00"
#   puts $cur_file "JCB,$JCB_COUNT,$$JCB_AMOUNT,$$JCB_FEE,$$JCB_TOTAL,,$MJCB_COUNT,$$MJCB_AMOUNT,$$MJCB_FEE,$$MJCB_TOTAL"
#   puts $cur_file "DBT,$DB_COUNT,$$DB_AMOUNT,$$DB_FEE,$$DB_TOTAL,,$MDB_COUNT,$$MDB_AMOUNT,$$MDB_FEE,$$MDB_TOTAL"
#   puts $cur_file "EBT,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
#   puts $cur_file "MISC ADJ ,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
#   puts $cur_file "OTHER,$OTHER_COUNT, ,$$OTHER_FEE,$$OTHER_FEE,,$MOTHER_COUNT, ,$$MOTHER_FEE,$$MOTHER_FEE"
#   puts $cur_file "SUBTOTAL,$D_SUB_SCNT,$$D_SUB_SAMT,$$D_SUB_FAMT,$$D_SUB_ACCTEFFECT,,$M_SUB_SCNT,$$M_SUB_SAMT,\
#                   $$M_SUB_FAMT,$$M_SUB_ACCTEFFECT"
#   puts $cur_file " "
#   puts $cur_file "REJECTS:"
#   puts $cur_file "SUBTOTAL,$REJECT_COUNT,$$REPROCESSED_REJECT,0.00,$$REPROCESSED_REJECT,,$MTD_REJECT_COUNT,\
#                            $$MTD_REPROCESSED_REJECT,0.00,$$MTD_REPROCESSED_REJECT"
#   puts $cur_file " "
#   puts $cur_file "MISC ADJ: "
#   puts $cur_file "SUBTOTAL,$MISC_COUNT,$$MISC_AMOUNT,0.00,$$MISC_AMOUNT,,$MMISC_COUNT,$$MMISC_AMOUNT,$MMISC_COUNT,$$MMISC_AMOUNT"
#   puts $cur_file " "
#   puts $cur_file "CHARGEBACKS:"
#   puts $cur_file "CGB,$CHR_COUNT,$$CHR_AMOUNT,$$CHR_FEE,$$CHR_AMOUNT,,$MCHR_COUNT,$$MCHR_AMOUNT,$$MCHR_FEE,$$MCHR_AMOUNT"
#   puts $cur_file "REP,$REP_COUNT,$$REP_AMOUNT,$$REP_FEE,$$REP_AMOUNT,,$MREP_COUNT,$$MREP_AMOUNT,$$MREP_FEE,$$MREP_AMOUNT"
#   puts $cur_file "SUBTOTAL:,[expr $CHR_COUNT + $REP_COUNT],$[expr $CHR_AMOUNT + $REP_AMOUNT],$[expr $CHR_FEE + $REP_FEE],\
#                   $[expr $CHR_AMOUNT + $REP_AMOUNT],,[expr $MCHR_COUNT + $MREP_COUNT],$[expr $MCHR_AMOUNT + $MREP_AMOUNT],\
#                   $[expr $MCHR_FEE + $MREP_FEE],$[expr $MCHR_AMOUNT + $MREP_AMOUNT]"
#   puts $cur_file " "
#   puts $cur_file "RESERVES:"
#   puts $cur_file "Res Addition,,,,$$RESERVE_ADDED_TODAY"
#   puts $cur_file "Res Release,,,,$$TODAY_RESERVE_PAID"
#   puts $cur_file "SUBTOTAL:,,,,$$SUB_TODAY_RESERVE"

###############################################################
#########  the above block needs to be unblocked.  ############
#          and the below block needs to be removed:
###############################################################

    puts $cur_file "VISA,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
    puts $cur_file "MC,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
    puts $cur_file "AMEX,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
    puts $cur_file "DISC,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
    puts $cur_file "JCB,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
    puts $cur_file "DBT,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
    puts $cur_file "EBT,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
    puts $cur_file "MISC ADJ ,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
    puts $cur_file "OTHER,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
    puts $cur_file "SUBTOTAL,0.00,\$0,$$D_SUB_FAMT,\$0,,0.00,\$0,\$0,\$0"
    puts $cur_file " "
    puts $cur_file "REJECTS:"
    puts $cur_file "SUBTOTAL,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
    puts $cur_file " "
    puts $cur_file "MISC ADJ: "
    puts $cur_file "SUBTOTAL,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
    puts $cur_file " "
    puts $cur_file "CHARGEBACKS:"
    puts $cur_file "CGB,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
    puts $cur_file "REP,0.00,\$0,\$0,\$0,,0.00,\$0,\$0,\$0"
    puts $cur_file "SUBTOTAL:"
    puts $cur_file " "
    puts $cur_file "RESERVES:"
    puts $cur_file "Res Addition,,,,\$0"
    puts $cur_file "Res Release,,,,\$0"
    puts $cur_file "SUBTOTAL:,,,,\$0"

#################################################################
#################################################################
#################################################################

    puts $cur_file " "
    puts $cur_file "DEPOSITS:"
    puts $cur_file "ACH:,$ACH_COUNT, , ,$$ACH_AMOUNT,,$MACH_COUNT, , ,$$MACH_AMOUNT"
    puts $cur_file "ARJ:,0, , , 0.00,,0, , ,0.00"
    puts $cur_file "SUBTOTAL:,$ACH_COUNT, , ,$$ACH_AMOUNT,,$MACH_COUNT, , ,$$MACH_AMOUNT"

##### unblock the following section too: ##################

#   puts $cur_file " "
#   puts $cur_file "Begining Payable Balance,$report_yesterday_mddate,,,$$BEGIN_PAYBL_BAL"
#   puts $cur_file "Account Effect:,,,,$[expr $END_PAYBL_BAL - $BEGIN_PAYBL_BAL]"
#   puts $cur_file "Ending Payable Balance,$report_mddate,,,$$END_PAYBL_BAL"
#   puts $cur_file " "
#   puts $cur_file "Begining Reserve Balance,$report_yesterday_mddate,,,$$BEGIN_RESERVE"
#   puts $cur_file "Account Effect:,,,,$[expr $ENDING_RESERVE - $BEGIN_RESERVE]"
#   puts $cur_file "Ending Reserve Balance,$report_mddate,,,$$ENDING_RESERVE"

##### unblock the above section too: ##################

}

##########
# MAIN
##########

arg_parse

if {![info exists institutions_arg]} {
     puts "At least one institution ID needs to be passed.\nUsage: $argv0 -I nnn \[nnn\]... \[-D yyyymmdd\]"
     exit 1
} else {
     if { [llength $institutions_arg] > 1} {
       set instit_description "ALL"
       set rollup "ROLLUP 101 107"
    } else {
       set instit_description $institutions_arg
       set rollup $institutions_arg
    }
}

if {![info exists date_arg]} {
     init_dates [clock format [clock scan "-0 day"] -format %d-%b-%Y]
} else {
     init_dates [clock format [clock scan $date_arg -format %Y%m%d ] -format %d-%b-%Y]
}

puts "date: $date.. mydate: $mydate..filedate:$filedate..tomorrow:$tomorrow..yesterday:$yesterday "
puts "report_ddate:$report_ddate..report_mdate: $report_mdate.. report_mddate: $report_mddate"
puts "now it starts from [clock format [clock seconds]]"

#===============================================================================
#===============================================================================
# if {$mode == "PROD"} {
#     set cur_file_name    "/clearing/filemgr/JOURNALS/ROLLUP/UPLOAD/ROLLUP.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.001.csv"
#     set cur_file_name    "./UPLOAD/ROLLUP.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.001.csv"
#     set file_name        "ROLLUP.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.001.csv"
# } elseif {$mode == "TEST"} {

set cur_file_name    "ROLLUP.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.$instit_description.csv"
set file_name        "ROLLUP.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.$instit_description.csv"

#}

set cur_file         [open "$cur_file_name" w]
  

puts $cur_file "INSTITUTION:,$rollup"
report $institutions_arg
puts "$instit_description DONE"
puts $cur_file " "
puts $cur_file " "
 
close $cur_file
  
oraclose $daily_cursor

oralogoff $handler
