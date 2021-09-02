#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: 117-daily-detail.tcl 2492 2014-01-07 19:04:45Z mitra $
# $Rev: 2492 $
################################################################################

#===============================================================================
#==========================  Environment veriables  ============================
#===============================================================================

set box $env(SYS_BOX)
#set clrpath $env(CLR_OSITE_ROOT)
#set maspath $env(MAS_OSITE_ROOT)
#set mailtolist $env(MAIL_TO)
#set mailfromlist $env(MAIL_FROM)

set clrdb $env(CLR4_DB)

#Mode....
     #set mode "TEST"
     set mode "PROD"

#===============================================================================
set fail_msg "$argv0 failed to run"
package require Oratcl
if {[catch {set handler [oralogon masclr/masclr@$clrdb]} result]} {
    puts ">>>$result<<<"
    exec echo $fail_mag | mutt -s $fail_mag $mailtolist
    exit 1
}

set daily_cursor [oraopen $handler]

#===============================================================================
#                          time settings and arguments         
#===============================================================================

proc arg_parse {} {
    global argv institutions_arg date_arg

    #scan for Date
    if { [regexp -- {(-[dD])[ ]+([0-9]{8,8})} $argv dummy1 dummy2 arg_date] } {
        puts "Date argument: $arg_date"
        set date_arg $arg_date
    }
}

proc init_dates {val} {
    global date_my date filedate tomorrow yesterday CUR_JULIAN_DATEX

    set date		[string toupper [clock format [clock scan "$val" -format %Y%m%d] -format %d-%b-%Y]]  ;# 21-MAR-08
    set date_my		[string toupper [clock format [clock scan "$date"] -format %b-%Y]]     ;# MAR-08

    set filedate  [clock format   [clock scan "$date"] -format %Y%m%d]                     ;# 20080321
    set tomorrow  [string toupper [clock format [clock scan "$date +1 day"] -format %d-%b-%Y]]
    set yesterday [string toupper [clock format [clock scan "$date -1 day"] -format %d-%b-%Y]]

    set CUR_SET_TIME     [clock seconds]
    set CUR_JULIAN_DATEX [string range [clock format [clock scan "$date"] -format "%y%j"] 1 4]
    puts " date is $date....tomorrow is $tomorrow....."
}


proc do_report {instID} {
    global daily_cursor mode
    global date CUR_JULIAN_DATEX filedate tomorrow

    puts "now it starts from [clock format [clock seconds]]"

    set INST_ID       0

    set VS_CNT        0
    set VS_AMT        0
    set VS_RCNT       0
    set VS_RAMT       0
    set VS_CASH_CNT   0
    set VS_CASH_AMT   0
    set VS_REV_CNT    0
    set VS_REV_AMT    0

    set MC_CNT        0
    set MC_AMT        0
    set MC_RCNT       0
    set MC_RAMT       0
    set MC_CASH_CNT   0
    set MC_CASH_AMT   0
    set MC_REV_CNT    0
    set MC_REV_AMT    0

    set AX_CNT        0
    set AX_AMT        0
    set AX_RCNT       0
    set AX_RAMT       0
    set AX_CASH_CNT   0
    set AX_CASH_AMT   0
    set AX_REV_CNT    0
    set AX_REV_AMT    0

    set DS_CNT        0
    set DS_AMT        0
    set DS_RCNT       0
    set DS_RAMT       0
    set DS_CASH_CNT   0
    set DS_CASH_AMT   0
    set DS_REV_CNT    0
    set DS_REV_AMT    0

    set O_CNT        0
    set O_AMT        0
    set O_RCNT       0
    set O_RAMT       0
    set O_CASH_CNT   0
    set O_CASH_AMT   0
    set O_REV_CNT    0
    set O_REV_AMT    0

    set NETVSCNT      0
    set NETMCCNT      0
    set NETAXCNT      0
    set NETDSCNT      0
    set NETOCNT       0

    set NETVSAMT      0
    set NETMCAMT      0
    set NETAXAMT      0
    set NETDSAMT      0

    set NETOAMT       0

    set SUB_S_CNT     0
    set SUB_S_AMT     0
    set SUB_R_CNT     0
    set SUB_R_AMT     0
    set SUB_REV_AMT   0
    set SUB_CASH_AMT  0
    set SUBNETAMT     0

    set SUSPEND_CNT        0
    set SUSPEND_AMT        0

    set V_REPROCESS_AMT    0
    set V_REPROCESS_CNT    0
    set M_REPROCESS_AMT    0
    set M_REPROCESS_CNT    0
    set X_REPROCESS_AMT    0
    set X_REPROCESS_CNT    0
    set D_REPROCESS_AMT    0
    set D_REPROCESS_CNT    0

    set SUB_REPROCESS_AMT    0
    set SUB_REPROCESS_CNT    0

    set ING_VS       0
    set ING_VR       0
    set ING_VCB      0
    set ING_VCBRV    0
    set ING_VCASH    0
    set ING_VREV     0
    set ING_VF       0
    set ING_VICADJ   0

    set ING_MS       0
    set ING_MR       0
    set ING_MCB      0
    set ING_MCBRV    0
    set ING_MCASH    0
    set ING_MREV     0
    set ING_MF       0
    set ING_MICADJ   0

    set ING_XS       0
    set ING_XR       0
    set ING_XCB      0
    set ING_XCBRV    0
    set ING_XCASH    0
    set ING_XREV     0
    set ING_XF       0
    set ING_XICADJ   0

    set ING_DS       0
    set ING_DR       0
    set ING_DCB      0
    set ING_DCBRV    0
    set ING_DCASH    0
    set ING_DREV     0
    set ING_DF       0
    set ING_DICADJ   0

    set ING_OS       0
    set ING_OR       0
    set ING_OCB      0
    set ING_OCBRV    0
    set ING_OCASH    0
    set ING_OREV     0
    set ING_OF       0
    set ING_OICADJ   0

    set SUSP_CNT     0
    set SUSP_AMT     0

    set V_1D_REJ_CNT  0
    set V_1D_REJ_AMT  0
    set V_1C_REJ_CNT  0
    set V_1C_REJ_AMT  0
    set V_2D_REJ_CNT  0
    set V_2D_REJ_AMT  0
    set V_2C_REJ_CNT  0
    set V_2C_REJ_AMT  0

    set M_1D_REJ_CNT  0
    set M_1D_REJ_AMT  0
    set M_1C_REJ_CNT  0
    set M_1C_REJ_AMT  0
    set M_2D_REJ_CNT  0
    set M_2D_REJ_AMT  0
    set M_2C_REJ_CNT  0
    set M_2C_REJ_AMT  0

    set X_1D_REJ_CNT  0
    set X_1D_REJ_AMT  0
    set X_1C_REJ_CNT  0
    set X_1C_REJ_AMT  0
    set X_2D_REJ_CNT  0
    set X_2D_REJ_AMT  0
    set X_2C_REJ_CNT  0
    set X_2C_REJ_AMT  0

    set D_1D_REJ_CNT  0
    set D_1D_REJ_AMT  0
    set D_1C_REJ_CNT  0
    set D_1C_REJ_AMT  0
    set D_2D_REJ_CNT  0
    set D_2D_REJ_AMT  0
    set D_2C_REJ_CNT  0
    set D_2C_REJ_AMT  0

    set NET_V1_REJ_CNT  0
    set NET_V1_REJ_AMT  0
    set NET_V2_REJ_CNT  0
    set NET_V2_REJ_AMT  0

    set NET_M1_REJ_CNT  0
    set NET_M1_REJ_AMT  0
    set NET_M2_REJ_CNT  0
    set NET_M2_REJ_AMT  0

    set NET_X1_REJ_CNT  0
    set NET_X1_REJ_AMT  0
    set NET_X2_REJ_CNT  0
    set NET_X2_REJ_AMT  0

    set NET_D1_REJ_CNT  0
    set NET_D1_REJ_AMT  0
    set NET_D2_REJ_CNT  0
    set NET_D2_REJ_AMT  0

    set VCHG_CNT    0
    set VCHG_AMT    0
    set VCHG_R_CNT  0
    set VCHG_R_AMT  0

    set MCHG_CNT    0
    set MCHG_AMT    0
    set MCHG_R_CNT  0
    set MCHG_R_AMT  0

    set XCHG_CNT    0
    set XCHG_AMT    0
    set XCHG_R_CNT  0
    set XCHG_R_AMT  0

    set DCHG_CNT    0
    set DCHG_AMT    0
    set DCHG_R_CNT  0
    set DCHG_R_AMT  0

    set VARB_C_CNT   0
    set VARB_C_AMT   0
    set VARB_D_CNT   0
    set VARB_D_AMT   0

    set MARB_C_CNT   0
    set MARB_C_AMT   0
    set MARB_D_CNT   0
    set MARB_D_AMT   0

    set XARB_C_CNT   0
    set XARB_C_AMT   0
    set XARB_D_CNT   0
    set XARB_D_AMT   0

    set DARB_C_CNT   0
    set DARB_C_AMT   0
    set DARB_D_CNT   0
    set DARB_D_AMT   0

    set VREP_C_CNT   0
    set VREP_C_AMT   0
    set VREP_R_CNT   0
    set VREP_R_AMT   0

    set MREP_C_CNT   0
    set MREP_C_AMT   0
    set MREP_R_CNT   0
    set MREP_R_AMT   0

    set XREP_C_CNT   0
    set XREP_C_AMT   0
    set XREP_R_CNT   0
    set XREP_R_AMT   0

    set DREP_C_CNT   0
    set DREP_C_AMT   0
    set DREP_R_CNT   0
    set DREP_R_AMT   0

#===============================================================================
#===============================================================================

    if {$mode == "PROD"} {
        ##
        # They insist on using the 106 folder for 117 uploads
        ###------------------------------------------------------
        set upath "/clearing/filemgr/JOURNALS/INST_106/UPLOAD"
        ###------------------------------------------------------
        
        
        set apath "/clearing/filemgr/JOURNALS/INST_117/ARCHIVE"
        set cur_file_name     "./117.DAILY.DETAIL.REPORT.$CUR_JULIAN_DATEX.$filedate.001.csv"
        set file_name         "117.DAILY.DETAIL.REPORT.$CUR_JULIAN_DATEX.$filedate.001.csv"
        set cur_file          [open "$cur_file_name" w]
    } elseif {$mode == "TEST"} {
        set upath "./UPLOAD"
        set apath "./ARCHIVE"   
        set cur_file_name     "./117.DAILY.DETAIL.REPORT.$CUR_JULIAN_DATEX.$filedate.TEST.csv"
        set file_name         "117.DAILY.DETAIL.REPORT.$CUR_JULIAN_DATEX.$filedate.TEST.csv"
        set cur_file          [open "$cur_file_name" w]
    }

    puts $cur_file "INSTITUTION:,$instID \n"
    puts $cur_file "$instID DAILY DETAIL REPORT \n"
    puts $cur_file ",FOR: $date "
    puts $cur_file " "
    puts $cur_file "DAILY TRANSACTIONS:"
    puts $cur_file ",SALES COUNT,SALES AMOUNT,RETURN COUNT,RETURN AMOUNT,REVERSAL COUNT,REVERSALS,MANUAL CASH,NET AMOUNT"


    set reptid "'010103005301', '010103005302', '010103005303', '010103005401', '010103005402', '010103005403'"

    set sales_str "
        SELECT sum(case when(ind.tid in ('010103005101') and card_scheme = '04') 
                        then 1 else 0 end ) as VS_CNT,
               sum(case when(ind.tid in ('010103005101') and card_scheme = '04') 
                        then ind.amt_trans/100 else 0 end ) as VS_AMT,
               sum(case when(ind.tid in ('010103005102') and card_scheme = '04') 
                        then 1 else 0 end ) as VS_RCNT,
               sum(case when(ind.tid in ('010103005102') and card_scheme = '04') 
                        then ind.amt_trans/100 else 0 end ) as VS_RAMT,
               sum(case when(ind.tid in ('010103005103') and card_scheme = '04') 
                        then 1 else 0 end ) as VS_CASH_CNT,
               sum(case when(ind.tid in ('010103005103') and card_scheme = '04') 
                        then ind.amt_trans/100 else 0 end ) as VS_CASH_AMT,
               sum(case when(ind.tid in ('010103005201','010103005202') and card_scheme = '04') 
                        then 1 else 0 end ) as VS_REV_CNT,
               sum(case when(ind.tid in ('010103005202') and card_scheme = '04') 
                        then ind.amt_trans/100 
                        when(ind.tid in ('010103005201') and card_scheme = '04') 
                        then -1*ind.amt_trans/100 else 0 end ) as VS_REV_AMT,

               sum(case when(ind.tid in ('010103005101') and card_scheme = '05') 
                        then 1 else 0 end ) as MC_CNT,
               sum(case when(ind.tid in ('010103005101') and card_scheme = '05') 
                        then ind.amt_trans/100 else 0 end ) as MC_AMT,
               sum(case when(ind.tid in ('010103005102') and card_scheme = '05') 
                        then 1 else 0 end ) as MC_RCNT,
               sum(case when(ind.tid in ('010103005102') and card_scheme = '05') 
                        then ind.amt_trans/100 else 0 end ) as MC_RAMT,
               sum(case when(ind.tid in ('010103005103') and card_scheme = '05') 
                        then 1 else 0 end ) as MC_CASH_CNT,
               sum(case when(ind.tid in ('010103005103') and card_scheme = '05') 
                        then ind.amt_trans/100 else 0 end ) as MC_CASH_AMT,
               sum(case when(ind.tid in ('010103005201','010103005202') and card_scheme = '05') 
                        then 1 else 0 end ) as MC_REV_CNT,
               sum(case when(ind.tid in ('010103005202') and card_scheme = '05') 
                        then ind.amt_trans/100 
                        when(ind.tid in ('010103005201') and card_scheme = '05') 
                        then -1*ind.amt_trans/100 else 0 end ) as MC_REV_AMT,

               sum(case when(ind.tid in ('010103005101') and card_scheme = '03') 
                        then 1 else 0 end ) as AX_CNT,
               sum(case when(ind.tid in ('010103005101') and card_scheme = '03') 
                        then ind.amt_trans/100 else 0 end ) as AX_AMT,
               sum(case when(ind.tid in ('010103005102') and card_scheme = '03') 
                        then 1 else 0 end ) as AX_RCNT,
               sum(case when(ind.tid in ('010103005102') and card_scheme = '03') 
                        then ind.amt_trans/100 else 0 end ) as AX_RAMT,
               sum(case when(ind.tid in ('010103005103') and card_scheme = '03') 
                        then 1 else 0 end ) as AX_CASH_CNT,
               sum(case when(ind.tid in ('010103005103') and card_scheme = '03') 
                        then ind.amt_trans/100 else 0 end ) as AX_CASH_AMT,
               sum(case when(ind.tid in ('010103005201','010103005202') and card_scheme = '03') 
                        then 1 else 0 end ) as AX_REV_CNT,
               sum(case when(ind.tid in ('010103005202') and card_scheme = '03') 
                        then ind.amt_trans/100 
                        when(ind.tid in ('010103005201') and card_scheme = '03') 
                        then -1*ind.amt_trans/100 else 0 end ) as AX_REV_AMT,

               sum(case when(ind.tid in ('010103005101') and card_scheme = '08') 
                        then 1 else 0 end ) as DS_CNT,
               sum(case when(ind.tid in ('010103005101') and card_scheme = '08') 
                        then ind.amt_trans/100 else 0 end ) as DS_AMT,
               sum(case when(ind.tid in ('010103005102') and card_scheme = '08') 
                        then 1 else 0 end ) as DS_RCNT,
               sum(case when(ind.tid in ('010103005102') and card_scheme = '08') 
                        then ind.amt_trans/100 else 0 end ) as DS_RAMT,
               sum(case when(ind.tid in ('010103005103') and card_scheme = '08') 
                        then 1 else 0 end ) as DS_CASH_CNT,
               sum(case when(ind.tid in ('010103005103') and card_scheme = '08') 
                        then ind.amt_trans/100 else 0 end ) as DS_CASH_AMT,
               sum(case when(ind.tid in ('010103005201','010103005202') and card_scheme = '08') 
                        then 1 else 0 end ) as DS_REV_CNT,
               sum(case when(ind.tid in ('010103005202') and card_scheme = '08') 
                        then ind.amt_trans/100 
                        when(ind.tid in ('010103005201') and card_scheme = '08') 
                        then -1*ind.amt_trans/100 else 0 end ) as DS_REV_AMT, 

               sum(case when (ind.card_scheme = '04' and t.tid in ($reptid) and t.tid_settl_method = 'D') 
                        then 1 else 0 end) as VREP_C_CNT,
               sum(case when (ind.card_scheme = '04' and t.tid in ($reptid) and t.tid_settl_method = 'D') 
                        then ind.amt_trans/100 else 0 end) as VREP_C_AMT,
               sum(case when (ind.card_scheme = '04' and t.tid in ($reptid) and t.tid_settl_method = 'C') 
                        then 1 else 0 end) as VREP_R_CNT,
               sum(case when (ind.card_scheme = '04' and t.tid in ($reptid) and t.tid_settl_method = 'C') 
                        then  ind.amt_trans/-100 else 0 end) as VREP_R_AMT,

               sum(case when (ind.card_scheme = '05' and t.tid in ($reptid) and t.tid_settl_method = 'D') 
                        then 1 else 0 end) as MREP_C_CNT,
               sum(case when (ind.card_scheme = '05' and t.tid in ($reptid) and t.tid_settl_method = 'D' ) 
                        then ind.amt_trans/100 else 0 end) as MREP_C_AMT,
               sum(case when (ind.card_scheme = '05' and t.tid in ($reptid) and t.tid_settl_method = 'C') 
                        then 1 else 0 end) as MREP_R_CNT,
               sum(case when (ind.card_scheme = '05' and t.tid in ($reptid) and t.tid_settl_method = 'C' ) 
                        then ind.amt_trans/-100 else 0 end) as MREP_R_AMT,

               sum(case when (ind.card_scheme = '03' and t.tid in ($reptid) and t.tid_settl_method = 'D') 
                        then 1 else 0 end) as XREP_C_CNT,
               sum(case when (ind.card_scheme = '03' and t.tid in ($reptid) and t.tid_settl_method = 'D' ) 
                        then ind.amt_trans/100 else 0 end) as XREP_C_AMT,
               sum(case when (ind.card_scheme = '03' and t.tid in ($reptid) and t.tid_settl_method = 'C') 
                        then 1 else 0 end) as XREP_R_CNT,
               sum(case when (ind.card_scheme = '03' and t.tid in ($reptid) and t.tid_settl_method = 'C' ) 
                        then ind.amt_trans/-100 else 0 end) as XREP_R_AMT,

               sum(case when (ind.card_scheme = '08' and t.tid in ($reptid) and t.tid_settl_method = 'D') 
                        then 1 else 0 end) as DREP_C_CNT,
               sum(case when (ind.card_scheme = '08' and t.tid in ($reptid) and t.tid_settl_method = 'D') 
                        then ind.amt_trans/100 else 0 end) as DREP_C_AMT,
               sum(case when (ind.card_scheme = '08' and t.tid in ($reptid) and t.tid_settl_method = 'C') 
                        then 1 else 0 end) as DREP_R_CNT,
               sum(case when (ind.card_scheme = '08' and t.tid in ($reptid) and t.tid_settl_method = 'C' ) 
                        then  ind.amt_trans/-100 else 0 end) as DREP_R_AMT

        FROM in_draft_main ind, tid t, in_file_log ifl
        WHERE ind.in_file_nbr = ifl.in_file_nbr
          AND ind.tid = t.tid
          AND ifl.end_dt >= '$date' and ifl.end_dt < '$tomorrow'
          AND sec_dest_inst_id = '$instID'"

    # puts "sales_str: $sales_str"
    
    orasql $daily_cursor $sales_str
    
    while {[orafetch $daily_cursor -dataarray s -indexbyname] != 1403} {
        set VS_CNT $s(VS_CNT)
        set VS_AMT $s(VS_AMT)
        set VS_RCNT $s(VS_RCNT)
        set VS_RAMT $s(VS_RAMT)   
        set VS_CASH_CNT $s(VS_CASH_CNT)
        set VS_CASH_AMT $s(VS_CASH_AMT)
        set VS_REV_CNT $s(VS_REV_CNT)
        set VS_REV_AMT $s(VS_REV_AMT)

        set MC_CNT $s(MC_CNT)
        set MC_AMT $s(MC_AMT)
        set MC_RCNT $s(MC_RCNT)
        set MC_RAMT $s(MC_RAMT)   
        set MC_CASH_CNT $s(MC_CASH_CNT)
        set MC_CASH_AMT $s(MC_CASH_AMT)
        set MC_REV_CNT $s(MC_REV_CNT)
        set MC_REV_AMT $s(MC_REV_AMT)

        set AX_CNT $s(AX_CNT)
        set AX_AMT $s(AX_AMT)
        set AX_RCNT $s(AX_RCNT)
        set AX_RAMT $s(AX_RAMT)   
        set AX_CASH_CNT $s(AX_CASH_CNT)
        set AX_CASH_AMT $s(AX_CASH_AMT)
        set AX_REV_CNT $s(AX_REV_CNT)
        set AX_REV_AMT $s(AX_REV_AMT)

        set DS_CNT $s(DS_CNT)
        set DS_AMT $s(DS_AMT)
        set DS_RCNT $s(DS_RCNT)
        set DS_RAMT $s(DS_RAMT)   
        set DS_CASH_CNT $s(DS_CASH_CNT)
        set DS_CASH_AMT $s(DS_CASH_AMT)
        set DS_REV_CNT $s(DS_REV_CNT)
        set DS_REV_AMT $s(DS_REV_AMT)

        set VREP_C_CNT   $s(VREP_C_CNT)
        set VREP_C_AMT   $s(VREP_C_AMT)
        set VREP_R_CNT   $s(VREP_R_CNT)
        set VREP_R_AMT   $s(VREP_R_AMT)

        set MREP_C_CNT   $s(MREP_C_CNT)
        set MREP_C_AMT   $s(MREP_C_AMT)
        set MREP_R_CNT   $s(MREP_R_CNT)
        set MREP_R_AMT   $s(MREP_R_AMT)

        set XREP_C_CNT   $s(XREP_C_CNT)
        set XREP_C_AMT   $s(XREP_C_AMT)
        set XREP_R_CNT   $s(XREP_R_CNT)
        set XREP_R_AMT   $s(XREP_R_AMT)      

        set DREP_C_CNT   $s(DREP_C_CNT)
        set DREP_C_AMT   $s(DREP_C_AMT)
        set DREP_R_CNT   $s(DREP_R_CNT)
        set DREP_R_AMT   $s(DREP_R_AMT)        
    }

    set NETVSAMT [expr $VS_AMT - $VS_RAMT + $VS_REV_AMT + $VS_CASH_AMT]
    set NETMCAMT [expr $MC_AMT - $MC_RAMT + $MC_REV_AMT + $MC_CASH_AMT]
    set NETAXAMT [expr $AX_AMT - $AX_RAMT + $AX_REV_AMT + $AX_CASH_AMT]
    set NETDSAMT [expr $DS_AMT - $DS_RAMT + $DS_REV_AMT + $DS_CASH_AMT]

    
    set SUB_S_CNT    [expr $MC_CNT      + $VS_CNT      + $AX_CNT      + $DS_CNT]
    set SUB_S_AMT    [expr $MC_AMT      + $VS_AMT      + $AX_AMT      + $DS_AMT]
    set SUB_R_CNT    [expr $MC_RCNT     + $VS_RCNT     + $AX_RCNT     + $DS_RCNT]
    set SUB_R_AMT    [expr $MC_RAMT     + $VS_RAMT     + $AX_RAMT     + $DS_RAMT]
    set SUB_REV_CNT  [expr $MC_REV_CNT  + $VS_REV_CNT  + $AX_REV_CNT  + $DS_REV_CNT]
    set SUB_REV_AMT  [expr $MC_REV_AMT  + $VS_REV_AMT  + $AX_REV_AMT  + $DS_REV_AMT]
    set SUB_CASH_AMT [expr $MC_CASH_AMT + $VS_CASH_AMT + $AX_CASH_AMT + $DS_CASH_AMT]
    set SUBNETAMT    [expr $NETMCAMT    + $NETVSAMT    + $NETAXAMT    + $NETDSAMT]

    puts $cur_file "VISA,$VS_CNT,$$VS_AMT,$VS_RCNT,$$VS_RAMT,$VS_REV_CNT,$$VS_REV_AMT,$$VS_CASH_AMT,$$NETVSAMT"
    puts $cur_file "MC,$MC_CNT,$$MC_AMT,$MC_RCNT,$$MC_RAMT,$MC_REV_CNT,$$MC_REV_AMT,$$MC_CASH_AMT,$$NETMCAMT"  
    puts $cur_file "AMEX,$AX_CNT,$$AX_AMT,$AX_RCNT,$$AX_RAMT,$AX_REV_CNT,$$AX_REV_AMT,$$AX_CASH_AMT,$$NETAXAMT"    
    puts $cur_file "DISCOVER,$DS_CNT,$$DS_AMT,$DS_RCNT,$$DS_RAMT,$DS_REV_CNT,$$DS_REV_AMT,$$DS_CASH_AMT,$$NETDSAMT"
    puts $cur_file "OTHER,$O_CNT,$$O_AMT,$O_RCNT,$$O_RAMT,$O_REV_CNT,$$O_REV_AMT,$$O_CASH_AMT,$$NETOAMT"
    puts $cur_file "SUBTOTAL,$SUB_S_CNT,$$SUB_S_AMT,$SUB_R_CNT,$$SUB_R_AMT,$SUB_REV_CNT,$$SUB_REV_AMT,$$SUB_CASH_AMT,$$SUBNETAMT"

    puts "daily_sales_str is done at [clock format [clock seconds]]"

##========  INTERCHANGE ==========

    puts $cur_file " "
    puts $cur_file "INTERCHANGE:"
    puts $cur_file ",SALES,RETURN,CB,CBRV,MAN CASH,REVERSAL,FOREIN,IC ADJ"

#VS interchange:

#      set vs_inchg "  select DEST_BIN, 
#                                  sum(AMT_FIRST) as SALES_AMT,
#                                  first_amt_sign as SALES_IND, 
#                                  sum(AMT_SECOND) as INCH_C,
#                                   second_amt_sign as INCH_C_IND,
#                                  sum(AMT_THIRD) as INCH_D,
#                                   third_amt_sign as INCH_D_IND
#                           from visa_recon_msg
#                           where settl_date like '$date%'
#                             and RPT_id = '130'
#                             and FUND_TFR_SRE_ID = '1000064351'
#                             and summary_level = '10'
#                             and dest_bin = '461084'
#                           group by DEST_BIN, first_amt_sign,second_amt_sign, third_amt_sign
#                           order by dest_bin, first_amt_sign,second_amt_sign, third_amt_sign"
#      orasql $daily_cursor $vs_inchg
#      while {[orafetch $daily_cursor -dataarray vinchg -indexbyname] != 1403} 
#
#puts "vs_inchg is done at [clock format [clock seconds]]"

    set mc_inchg "
        select sum(case when(ipm.DEBIT_CREDIT_IND6 = 'C') 
                        then ipm.AMT_NET_FEE_R/100 else -ipm.AMT_NET_FEE_R/100 end) as AMT
        from ipm_recon_msg ipm, recon_msg r, in_file_log i
        where ipm.RECON_MSG_SEQ_NBR= r.RECON_MSG_SEQ_NBR
          and r.in_file_nbr= i.in_file_nbr
          and i.institution_id = '05'
          and i.end_dt >= '$date' and i.end_dt < '$tomorrow'
          and r.pri_dest_inst_id = '$instID'
          and ( ipm.R_ICHG_RATE_DESIG <> ' ' and ipm.R_ICHG_RATE_DESIG is not null)"

    # puts "mc_inchg: $mc_inchg"
   
    orasql $daily_cursor $mc_inchg

    while {[orafetch $daily_cursor -dataarray mi -indexbyname] != 1403} {
        puts "today's total MC interchange: $mi(AMT)"
    }

    set mc_inchg_detail "
        select sum(case when (ipm.r_msg_type = '1240' 
                              and ipm.r_function_cd in ('200','205','282') 
                              and ipm.r_processing_cd = '00' 
                              and ipm.DEBIT_CREDIT_IND6 = 'C') 
                        then ipm.AMT_NET_FEE_R/100 else 0 end) as MS_S_INCHG, 
               sum(case when (ipm.r_msg_type = '1240' 
                              and ipm.r_function_cd in ('200','205','282') 
                              and ipm.r_processing_cd = '00' 
                              and ipm.DEBIT_CREDIT_IND6 = 'D') 
                        then ipm.AMT_NET_FEE_R/-100 else 0 end) as MS_RV_INCHG,
               sum(case when (ipm.r_msg_type = '1240' 
                              and ipm.r_function_cd in ('200','205','282') 
                              and ipm.r_processing_cd = '20' 
                              and ipm.DEBIT_CREDIT_IND6 = 'D') 
                        then ipm.AMT_NET_FEE_R/-100 else 0 end) as MS_SR_INCHG,
               sum(case when (ipm.r_msg_type = '1240' 
                              and ipm.r_function_cd in ('200','205','282') 
                              and ipm.r_processing_cd = '20' 
                              and ipm.DEBIT_CREDIT_IND6 = 'C') 
                        then ipm.AMT_NET_FEE_R/-100 else 0 end) as MS_SRC_INCHG,
               sum(case when (ipm.r_msg_type = '1442' 
                              and ipm.r_function_cd in ('450','451','454','453') 
                              and ipm.r_processing_cd = '00' 
                              and ipm.DEBIT_CREDIT_IND6 = 'D') 
                        then ipm.AMT_NET_FEE_R/-100 else 0 end) as MS_CK_INCHG,
               sum(case when (ipm.r_msg_type = '1442' 
                              and ipm.r_function_cd in ('450','451','454','453') 
                              and ipm.r_processing_cd = '00' and ipm.DEBIT_CREDIT_IND6 = 'C') 
                        then ipm.AMT_NET_FEE_R/100 else 0 end) as MS_CKRV_INCHG,
               sum(case when (ipm.r_msg_type = '1240' 
                              and ipm.r_function_cd in ('200','205','282') 
                              and ipm.r_processing_cd = '12' and ipm.DEBIT_CREDIT_IND6 = 'C') 
                        then ipm.AMT_NET_FEE_R/100 else 0 end) as MS_CASH_INCHG                        
        from ipm_recon_msg ipm, recon_msg r, in_file_log i
        where ipm.RECON_MSG_SEQ_NBR= r.RECON_MSG_SEQ_NBR
          and r.in_file_nbr= i.in_file_nbr
          and i.institution_id = '05'
          and i.end_dt >= '$date' and i.end_dt < '$tomorrow'
          and r.pri_dest_inst_id = '$instID'
          and (ipm.R_ICHG_RATE_DESIG <> ' ' and ipm.R_ICHG_RATE_DESIG is not null) "

    #puts "mc_inchg_detail: $mc_inchg_detail"
    
    orasql $daily_cursor $mc_inchg_detail
    
    while {[orafetch $daily_cursor -dataarray mcin -indexbyname] != 1403} {
        set ING_MS $mcin(MS_S_INCHG)
        set ING_MR [expr $mcin(MS_SR_INCHG)- $mcin(MS_SRC_INCHG)]
        set ING_MCB $mcin(MS_CK_INCHG)
        set ING_MCBRV $mcin(MS_CKRV_INCHG)
        set ING_MCASH $mcin(MS_CASH_INCHG)
        set ING_MREV $mcin(MS_RV_INCHG)
    }

    puts $cur_file "VISA,$ING_VS,$ING_VR,$ING_VCB,$ING_VCBRV,$ING_VCASH,$ING_VREV,$ING_VF,$ING_VICADJ "
    puts $cur_file "MC,$ING_MS,$ING_MR,$ING_MCB,$ING_MCBRV,$ING_MCASH,$ING_MREV,$ING_MF,$ING_MICADJ"
    puts $cur_file "AMEX,$ING_XS,$ING_XR,$ING_XCB,$ING_XCBRV,$ING_XCASH,$ING_XREV,$ING_XF,$ING_XICADJ"
    puts $cur_file "DISCOVER,$ING_DS,$ING_DR,$ING_DCB,$ING_DCBRV,$ING_DCASH,$ING_DREV,$ING_DF,$ING_DICADJ"
    puts $cur_file "OTHER,$ING_OS,$ING_OR,$ING_OCB,$ING_OCBRV,$ING_OCASH,$ING_OREV,$ING_OF,$ING_OICADJ"

    puts "mc_inchg is done at [clock format [clock seconds]]"   

##========  REPROCESSED REJECTS ==========

    puts $cur_file " "
    puts $cur_file "REPROCESSED REJECTS:"
    puts $cur_file ",COUNT,AMOUNT,COUNT,AMOUNT,,TOTAL COUNT,AMOUNT"

    set query_repro "
        select unique card_scheme, tid, msg_text_block as ind,
               sum(amt_trans)/100 as AMT, count(pan) as CNT
        from in_draft_main
        where SUBSTR(tid,1,11) = '01010300510'
          and substr(msg_text_block,1,9) in ('JPREJECT', 'JPVEPREJ', 'JPMPEREJ')
          and activity_dt >= '$date' and activity_dt < '$tomorrow'
          and SEC_DEST_INST_ID = '$instID'
          and in_file_nbr in (select in_file_nbr from in_file_log 
                              where end_dt >= '$date' and end_dt < '$tomorrow')
        group by card_scheme,tid,msg_text_block
        order by card_scheme,tid"

    set query_repro "
        select SUBSTR(msg_text_block,1,8) IND,
               sum (case when(card_scheme = '04' and tid = '010103005101') 
                         then amt_trans/100
                         when(card_scheme = '04' and tid = '010103005102') 
                         then -1*amt_trans/100 else 0 end) VS_REPROCESS_AMT,
               sum (case when(card_scheme = '04' and (tid = '010103005101' or tid = '010103005102')) 
                         then 1 else 0 end) VS_REPROCESS_CNT,
                         
               sum (case when(card_scheme = '05' and tid = '010103005101') 
                         then amt_trans/100
                        when(card_scheme = '05' and tid = '010103005102') 
                         then -1*amt_trans/100 else 0 end) MC_REPROCESS_AMT,
               sum (case when(card_scheme = '05' and (tid = '010103005101' or tid = '010103005102')) 
                         then 1 else 0 end) MC_REPROCESS_CNT, 
  
               sum (case when(card_scheme = '03' and tid = '010103005101') 
                         then amt_trans/100
                         when(card_scheme = '03' and tid = '010103005102') 
                         then -1*amt_trans/100 else 0 end) AX_REPROCESS_AMT,
               sum (case when(card_scheme = '03' and (tid = '010103005101' or tid = '010103005102')) 
                         then 1 else 0 end) AX_REPROCESS_CNT,   
                         
               sum (case when(card_scheme = '08' and tid = '010103005101') 
                         then amt_trans/100
                         when(card_scheme = '08' and tid = '010103005102') 
                         then -1*amt_trans/100 else 0 end) DS_REPROCESS_AMT,
               sum (case when(card_scheme = '08' and (tid = '010103005101' or tid = '010103005102')) 
                         then 1 else 0 end) DS_REPROCESS_CNT,
               sum(amt_trans)/100 as AMT,
               count(1) as CNT
               
        from in_draft_main
        where SUBSTR(tid,1,11) = '01010300510'
          and substr(msg_text_block,1,8) in ('JPREJECT', 'JPVEPREJ', 'JPMPEREJ')
          and activity_dt >= '$date' and activity_dt < '$tomorrow'
          and SEC_DEST_INST_ID = '$instID'
          and in_file_nbr in (select in_file_nbr from in_file_log 
                              where end_dt >= '$date' and end_dt < '$tomorrow')
        group by SUBSTR(msg_text_block,1,8)"

    # puts "query_repro: $query_repro"
    
    orasql $daily_cursor $query_repro
    
    while {[orafetch $daily_cursor -dataarray w -indexbyname] != 1403} {
    
        if {$w(IND) == "JPREJECT"} {
        
            set V_REPROCESS_AMT $w(VS_REPROCESS_AMT)
            set V_REPROCESS_CNT $w(VS_REPROCESS_CNT)
            set M_REPROCESS_AMT $w(MC_REPROCESS_AMT)
            set M_REPROCESS_CNT $w(MC_REPROCESS_CNT)            
            set X_REPROCESS_AMT $w(AX_REPROCESS_AMT)
            set X_REPROCESS_CNT $w(AX_REPROCESS_CNT)            
            set D_REPROCESS_AMT $w(DS_REPROCESS_AMT)
            set D_REPROCESS_CNT $w(DS_REPROCESS_CNT)
        } elseif {$w(IND) == "JPVEPREJ" || $w(IND) == "JPMPEREJ"} {
            set SUSPEND_CNT [expr $SUSPEND_CNT + $w(CNT)]
            set SUSPEND_AMT [expr $SUSPEND_AMT + $w(AMT)]
        }
    }
    set SUB_REPROCESS_CNT [expr $SUSPEND_CNT + $V_REPROCESS_CNT + $M_REPROCESS_CNT + $X_REPROCESS_CNT + $D_REPROCESS_CNT]
    set SUB_REPROCESS_AMT [expr $SUSPEND_AMT + $V_REPROCESS_AMT + $M_REPROCESS_AMT + $X_REPROCESS_AMT + $D_REPROCESS_AMT]

    puts $cur_file "INTERNAL REJECTS,$SUSPEND_CNT,$$SUSPEND_AMT,0,0,,$SUSPEND_CNT,$$SUSPEND_AMT"
    puts $cur_file "ASSOCIATION REJECTS VISA,$V_REPROCESS_CNT,$$V_REPROCESS_AMT,0,0,,$V_REPROCESS_CNT,$$V_REPROCESS_AMT"
    puts $cur_file "ASSOCIATION REJECTS MC,$M_REPROCESS_CNT,$$M_REPROCESS_AMT,0,0,,$M_REPROCESS_CNT,$$M_REPROCESS_AMT "
    puts $cur_file "ASSOCIATION REJECTS AMEX,$X_REPROCESS_CNT,$$X_REPROCESS_AMT,0,0,,$X_REPROCESS_CNT,$$X_REPROCESS_AMT "
    puts $cur_file "ASSOCIATION REJECTS DISCOVER,$D_REPROCESS_CNT,$$D_REPROCESS_AMT,0,0,,$D_REPROCESS_CNT,$$D_REPROCESS_AMT "
    puts $cur_file "SUBTOTAL,$SUB_REPROCESS_CNT,$$SUB_REPROCESS_AMT,0,0,,$SUB_REPROCESS_CNT,$$SUB_REPROCESS_AMT "

    ##========  REJECTS ==================
    ##========  INTERNAL REJECTS =========

    set suspend_qry "
        select count(1) as CNT,
               sum(amt_trans)/100 as AMOUNT
        from in_draft_main ind, suspend_log s
        where ind.trans_seq_nbr = s.trans_seq_nbr
          and s.in_file_nbr in (select in_file_nbr from in_file_log 
                                where end_dt >= '$date' and end_dt < '$tomorrow' 
                                  and institution_id = '$instID') 
          and s.in_file_nbr = ind.in_file_nbr
          and s.in_batch_nbr = ind.in_batch_nbr
          and s.suspend_status = 'S'"

     #puts "suspend_qry: $suspend_qry"
     
     orasql $daily_cursor $suspend_qry
     
     while {[orafetch $daily_cursor -dataarray susp -indexbyname] != 1403} {
        set SUSP_CNT $susp(CNT)
        set SUSP_AMT $susp(AMOUNT)
     }
    puts $cur_file " "
    puts $cur_file "DAILY REJECTS: "
    puts $cur_file ",COUNT,AMOUNT,COUNT,AMOUNT,,TOTAL COUNT,AMOUNT"
    puts $cur_file "INTERNAL REJECTS,$SUSP_CNT,$$SUSP_AMT,0,0,,$SUSP_CNT,$$SUSP_AMT"  
  
    set rej_qry "
        SELECT sum(case when(ep.card_scheme = '04' and ind.tid in ('010123005101','010123005103','010123005201')) 
                        then 1 else 0 end) as V_1D_REJ_CNT,
               sum(case when(ep.card_scheme = '04' and ind.tid in ('010123005101','010123005103','010123005201')) 
                        then ep.AMT_TRANS/100 else 0 end) as V_1D_REJ_AMT,
               sum(case when(ep.card_scheme = '04' and ind.tid in ('010123005102','010123005202')) 
                        then 1 else 0 end) as V_1C_REJ_CNT,
               sum(case when(ep.card_scheme = '04' and ind.tid in ('010123005102','010123005202')) 
                        then ep.AMT_TRANS/100 else 0 end) as V_1C_REJ_AMT,

               sum(case when(ep.card_scheme = '05' and ind.tid in ('010123005101','010123005103','010123005201')) 
                        then 1 else 0 end) as M_1D_REJ_CNT,
               sum(case when(ep.card_scheme = '05' and ind.tid in ('010123005101','010123005103','010123005201')) 
                        then ep.AMT_TRANS/100 else 0 end) as M_1D_REJ_AMT,
               sum(case when(ep.card_scheme = '05' and ind.tid in ('010123005102','010123005202')) 
                        then 1 else 0 end) as M_1C_REJ_CNT,
               sum(case when(ep.card_scheme = '05' and ind.tid in ('010123005102','010123005202')) 
                        then ep.AMT_TRANS/100 else 0 end) as M_1C_REJ_AMT,

               sum(case when(ep.card_scheme = '03' and ind.tid in ('010123005101','010123005103','010123005201')) 
                        then 1 else 0 end) as X_1D_REJ_CNT,
               sum(case when(ep.card_scheme = '03' and ind.tid in ('010123005101','010123005103','010123005201')) 
                        then ep.AMT_TRANS/100 else 0 end) as X_1D_REJ_AMT,
               sum(case when(ep.card_scheme = '03' and ind.tid in ('010123005102','010123005202')) 
                        then 1 else 0 end) as X_1C_REJ_CNT,
               sum(case when(ep.card_scheme = '03' and ind.tid in ('010123005102','010123005202')) 
                        then ep.AMT_TRANS/100 else 0 end) as X_1C_REJ_AMT,

               sum(case when(ep.card_scheme = '08' and ind.tid in ('010123005101','010123005103','010123005201')) 
                        then 1 else 0 end) as D_1D_REJ_CNT,
               sum(case when(ep.card_scheme = '08' and ind.tid in ('010123005101','010123005103','010123005201')) 
                        then ep.AMT_TRANS/100 else 0 end) as D_1D_REJ_AMT,
               sum(case when(ep.card_scheme = '08' and ind.tid in ('010123005102','010123005202')) 
                        then 1 else 0 end) as D_1C_REJ_CNT,
               sum(case when(ep.card_scheme = '08' and ind.tid in ('010123005102','010123005202')) 
                        then ep.AMT_TRANS/100 else 0 end) as D_1C_REJ_AMT,

               sum(case when(ep.card_scheme = '04' and ind.tid in ('010123005301','010123005303')) 
                        then 1 else 0 end) as V_2D_REJ_CNT,
               sum(case when(ep.card_scheme = '04' and ind.tid in ('010123005301','010123005303')) 
                        then ep.AMT_TRANS/100 else 0 end) as V_2D_REJ_AMT,
               sum(case when(ep.card_scheme = '04' and ind.tid in ('010123005302')) 
                        then 1 else 0 end) as V_2C_REJ_CNT,
               sum(case when(ep.card_scheme = '04' and ind.tid in ('010123005302')) 
                        then ep.AMT_TRANS/100 else 0 end) as V_2C_REJ_AMT,

               sum(case when(ep.card_scheme = '05' and ind.tid in ('010123005301','010123005303')) 
                        then 1 else 0 end) as M_2D_REJ_CNT,
               sum(case when(ep.card_scheme = '05' and ind.tid in ('010123005301','010123005303')) 
                        then ep.AMT_TRANS/100 else 0 end) as M_2D_REJ_AMT,
               sum(case when(ep.card_scheme = '05' and ind.tid in ('010123005302')) 
                        then 1 else 0 end) as M_2C_REJ_CNT,
               sum(case when(ep.card_scheme = '05' and ind.tid in ('010123005302'))  
                        then ep.AMT_TRANS/100 else 0 end) as M_2C_REJ_AMT,

               sum(case when(ep.card_scheme = '03' and ind.tid in ('010123005301','010123005303')) 
                        then 1 else 0 end) as X_2D_REJ_CNT,
               sum(case when(ep.card_scheme = '03' and ind.tid in ('010123005301','010123005303')) 
                        then ep.AMT_TRANS/100 else 0 end) as X_2D_REJ_AMT,
               sum(case when(ep.card_scheme = '03' and ind.tid in ('010123005302')) 
                        then 1 else 0 end) as X_2C_REJ_CNT,
               sum(case when(ep.card_scheme = '03' and ind.tid in ('010123005302'))  
                        then ep.AMT_TRANS/100 else 0 end) as X_2C_REJ_AMT,

               sum(case when(ep.card_scheme = '08' and ind.tid in ('010123005301','010123005303')) 
                        then 1 else 0 end) as D_2D_REJ_CNT,
               sum(case when(ep.card_scheme = '08' and ind.tid in ('010123005301','010123005303')) 
                        then ep.AMT_TRANS/100 else 0 end) as D_2D_REJ_AMT,
               sum(case when(ep.card_scheme = '08' and ind.tid in ('010123005302')) 
                        then 1 else 0 end) as D_2C_REJ_CNT,
               sum(case when(ep.card_scheme = '08' and ind.tid in ('010123005302')) 
                        then ep.AMT_TRANS/100 else 0 end) as D_2C_REJ_AMT

        FROM  ep_event_log ep, in_draft_main ind, tid
        WHERE ind.TRANS_SEQ_NBR = ep.trans_seq_nbr
          AND ind.tid = tid.tid
          AND ep.CARD_SCHEME in ('04', '05', '03', '08')
          AND ep.EMS_ITEM_TYPE in ( 'CR1', 'CR2','PR1')
          AND ep.Event_log_date >= '$date' and ep.Event_log_date < '$tomorrow'
          AND ep.institution_id = '$instID'"

      #puts "rej_qry: $rej_qry"
      
      orasql $daily_cursor $rej_qry
      
      while {[orafetch $daily_cursor -dataarray rej -indexbyname] != 1403} {
            set V_1D_REJ_CNT  $rej(V_1D_REJ_CNT)
            set V_1D_REJ_AMT  $rej(V_1D_REJ_AMT)
            set V_1C_REJ_CNT  $rej(V_1C_REJ_CNT)
            set V_1C_REJ_AMT  $rej(V_1C_REJ_AMT)
            set V_2D_REJ_CNT  $rej(V_2D_REJ_CNT)            
            set V_2D_REJ_AMT  $rej(V_2D_REJ_AMT)
            set V_2C_REJ_CNT  $rej(V_2C_REJ_CNT)
            set V_2C_REJ_AMT  $rej(V_2C_REJ_AMT)
            
            set M_1D_REJ_CNT  $rej(M_1D_REJ_CNT)
            set M_1D_REJ_AMT  $rej(M_1D_REJ_AMT)
            set M_1C_REJ_CNT  $rej(M_1C_REJ_CNT)
            set M_1C_REJ_AMT  $rej(M_1C_REJ_AMT)        
            set M_2D_REJ_CNT  $rej(M_2D_REJ_CNT)
            set M_2D_REJ_AMT  $rej(M_2D_REJ_AMT)
            set M_2C_REJ_CNT  $rej(M_2C_REJ_CNT)
            set M_2C_REJ_AMT  $rej(M_2C_REJ_AMT)

            set X_1D_REJ_CNT  $rej(X_1D_REJ_CNT)
            set X_1D_REJ_AMT  $rej(X_1D_REJ_AMT)
            set X_1C_REJ_CNT  $rej(X_1C_REJ_CNT)
            set X_1C_REJ_AMT  $rej(X_1C_REJ_AMT)        
            set X_2D_REJ_CNT  $rej(X_2D_REJ_CNT)
            set X_2D_REJ_AMT  $rej(X_2D_REJ_AMT)
            set X_2C_REJ_CNT  $rej(X_2C_REJ_CNT)
            set X_2C_REJ_AMT  $rej(X_2C_REJ_AMT)
            
            set D_1D_REJ_CNT  $rej(D_1D_REJ_CNT)
            set D_1D_REJ_AMT  $rej(D_1D_REJ_AMT)
            set D_1C_REJ_CNT  $rej(D_1C_REJ_CNT)
            set D_1C_REJ_AMT  $rej(D_1C_REJ_AMT)
            set D_2D_REJ_CNT  $rej(D_2D_REJ_CNT)
            set D_2D_REJ_AMT  $rej(D_2D_REJ_AMT)
            set D_2C_REJ_CNT  $rej(D_2C_REJ_CNT)
            set D_2C_REJ_AMT  $rej(D_2C_REJ_AMT)
      }
      set NET_V1_REJ_CNT  [expr $V_1D_REJ_CNT + $V_1C_REJ_CNT]
      set NET_V1_REJ_AMT  [expr $V_1D_REJ_AMT - $V_1C_REJ_AMT]
      set NET_V2_REJ_CNT  [expr $V_2D_REJ_CNT + $V_2C_REJ_CNT]
      set NET_V2_REJ_AMT  [expr $V_2D_REJ_AMT - $V_2C_REJ_AMT]
      
      set NET_M1_REJ_CNT  [expr $M_1D_REJ_CNT + $M_1C_REJ_CNT]
      set NET_M1_REJ_AMT  [expr $M_1D_REJ_AMT - $M_1C_REJ_AMT]
      set NET_M2_REJ_CNT  [expr $M_2D_REJ_CNT + $M_2C_REJ_CNT]
      set NET_M2_REJ_AMT  [expr $M_2D_REJ_AMT - $M_2C_REJ_AMT]
      
      set NET_X1_REJ_CNT  [expr $X_1D_REJ_CNT + $X_1C_REJ_CNT]
      set NET_X1_REJ_AMT  [expr $X_1D_REJ_AMT - $X_1C_REJ_AMT]
      set NET_X2_REJ_CNT  [expr $X_2D_REJ_CNT + $X_2C_REJ_CNT]
      set NET_X2_REJ_AMT  [expr $X_2D_REJ_AMT - $X_2C_REJ_AMT]      
      
      set NET_D1_REJ_CNT  [expr $D_1D_REJ_CNT + $D_1C_REJ_CNT]
      set NET_D1_REJ_AMT  [expr $D_1D_REJ_AMT - $D_1C_REJ_AMT]
      set NET_D2_REJ_CNT  [expr $D_2D_REJ_CNT + $D_2C_REJ_CNT]
      set NET_D2_REJ_AMT  [expr $D_2D_REJ_AMT - $D_2C_REJ_AMT]
      
      set SUB_D_REJ_CNT [expr $SUSP_CNT + $V_1D_REJ_CNT + $V_2D_REJ_CNT + \
                                          $M_1D_REJ_CNT + $M_2D_REJ_CNT + \
                                          $X_1D_REJ_CNT + $X_2D_REJ_CNT + \
                                          $D_1D_REJ_CNT + $D_2D_REJ_CNT]
                                          
      set SUB_D_REJ_AMT [expr $SUSP_AMT + $V_1D_REJ_AMT + $V_2D_REJ_AMT + \
                                          $M_1D_REJ_AMT + $M_2D_REJ_AMT + \
                                          $X_1D_REJ_AMT + $X_2D_REJ_AMT + \
                                          $D_1D_REJ_AMT + $D_2D_REJ_AMT]
                              
      set SUB_C_REJ_CNT [expr $V_1C_REJ_CNT + $V_2C_REJ_CNT + \
                              $M_1C_REJ_CNT + $M_2C_REJ_CNT + \
                              $X_1C_REJ_CNT + $X_2C_REJ_CNT + \
                              $D_1C_REJ_CNT + $D_2C_REJ_CNT]
                              
      set SUB_C_REJ_AMT [expr $V_1C_REJ_AMT + $V_2C_REJ_AMT + \
                              $M_1C_REJ_AMT + $M_2C_REJ_AMT + \
                              $X_1C_REJ_AMT + $X_2C_REJ_AMT + \
                              $D_1C_REJ_AMT + $D_2C_REJ_AMT]
                              
      set SUB_REJ_CNT   [expr $SUSP_CNT + $NET_V1_REJ_CNT + $NET_V2_REJ_CNT + \
                                          $NET_M1_REJ_CNT + $NET_M2_REJ_CNT + \
                                          $NET_X1_REJ_CNT + $NET_X2_REJ_CNT + \
                                          $NET_D1_REJ_CNT + $NET_D2_REJ_CNT]
                              
      set SUB_REJ_AMT   [expr $SUSP_AMT + $NET_V1_REJ_AMT + $NET_V2_REJ_AMT + \
                                          $NET_M1_REJ_AMT + $NET_M2_REJ_AMT + \
                                          $NET_X1_REJ_AMT + $NET_X2_REJ_AMT + \
                                          $NET_D1_REJ_AMT + $NET_D2_REJ_AMT]
      
      puts $cur_file "ASSOCIATION REJECTS"
      puts $cur_file "VISA 1st Presentment,$V_1D_REJ_CNT,$$V_1D_REJ_AMT,$V_1C_REJ_CNT,$$V_1C_REJ_AMT,,$NET_V1_REJ_CNT,$$NET_V1_REJ_AMT"
#      puts $cur_file "ASSOCIATION REJECTS"
      puts $cur_file "VISA 2nd Presentment,$V_2D_REJ_CNT,$$V_2D_REJ_AMT,$V_2C_REJ_CNT,$$V_2C_REJ_AMT,,$NET_V2_REJ_CNT,$$NET_V2_REJ_AMT"

#      puts $cur_file "ASSOCIATION REJECTS"
      puts $cur_file "MC 1st Presentment,$M_1D_REJ_CNT,$$M_1D_REJ_AMT,$M_1C_REJ_CNT,$$M_1C_REJ_AMT,,$NET_M1_REJ_CNT,$$NET_M1_REJ_AMT"
#      puts $cur_file "ASSOCIATION REJECTS"
      puts $cur_file "MC 2nd Presentment,$M_2D_REJ_CNT,$$M_2D_REJ_AMT,$M_2C_REJ_CNT,$$M_2C_REJ_AMT,,$NET_M2_REJ_CNT,$$NET_M2_REJ_AMT"

#      puts $cur_file "ASSOCIATION REJECTS "
      puts $cur_file "AMEX 1st Presentment,$X_1D_REJ_CNT,$$X_1D_REJ_AMT,$X_1C_REJ_CNT,$$X_1C_REJ_AMT,,$NET_X1_REJ_CNT,$$NET_X1_REJ_AMT"
#      puts $cur_file "ASSOCIATION REJECTS "
      puts $cur_file "AMEX 2nd Presentment,$X_2D_REJ_CNT,$$X_2D_REJ_AMT,$X_2C_REJ_CNT,$$X_2C_REJ_AMT,,$NET_X2_REJ_CNT,$$NET_X2_REJ_AMT"

#      puts $cur_file "ASSOCIATION REJECTS "
      puts $cur_file "DISCOVER 1st Presentment,$D_1D_REJ_CNT,$$D_1D_REJ_AMT,$D_1C_REJ_CNT,$$D_1C_REJ_AMT,,$NET_D1_REJ_CNT,$$NET_D1_REJ_AMT"
#      puts $cur_file "ASSOCIATION REJECTS "
      puts $cur_file "DISCOVER 2nd Presentment,$D_2D_REJ_CNT,$$D_2D_REJ_AMT,$D_2C_REJ_CNT,$$D_2C_REJ_AMT,,$NET_D2_REJ_CNT,$$NET_D2_REJ_AMT"

      puts $cur_file "SUBTOTAL,$SUB_D_REJ_CNT,$$SUB_D_REJ_AMT,$SUB_C_REJ_CNT,$$SUB_C_REJ_AMT,,$SUB_REJ_CNT,$$SUB_REJ_AMT "
    
##========  CHARGEBACKS     ==========
##========  PRE ARBITRATION ==========
##========  REPRESENTMENT   ==========

    set chgtid "'010103015101','010103015102','010103015201','010103015202','010103015203','010103015103','010103015301','010103015302', '010103015303'"
    set chg_qry "
        select sum(case when (ind.card_scheme = '04' and t.tid in ($chgtid) and t.tid_settl_method = 'C')                
                        then 1 else 0 end) as VCHG_CNT,
               sum(case when (ind.card_scheme = '04' and t.tid in ($chgtid) and t.tid_settl_method = 'C') 
                        then ind.amt_recon/-100 else 0 end) as VCHG_AMT,
               sum(case when (ind.card_scheme = '04' and t.tid in ($chgtid) and t.tid_settl_method = 'D') 
                        then 1 else 0 end) as VCHG_R_CNT,
               sum(case when (ind.card_scheme = '04' and t.tid in ($chgtid) and t.tid_settl_method = 'D') 
                        then ind.amt_recon/100 else 0 end) as VCHG_R_AMT, 

               sum(case when (ind.card_scheme = '05' and t.tid in ($chgtid) and t.tid_settl_method = 'C') 
                        then 1 else 0 end) as MCHG_CNT,
               sum(case when (ind.card_scheme = '05' and t.tid in ($chgtid) and t.tid_settl_method = 'C') 
                        then ind.amt_recon/-100 else 0 end) as MCHG_AMT,
               sum(case when (ind.card_scheme = '05' and t.tid in ($chgtid) and t.tid_settl_method = 'D') 
                        then 1 else 0 end) as MCHG_R_CNT,
               sum(case when (ind.card_scheme = '05' and t.tid in ($chgtid) and t.tid_settl_method = 'D') 
                        then ind.amt_recon/100 else 0 end) as MCHG_R_AMT,

               sum(case when (ind.card_scheme = '03' and t.tid in ($chgtid) and t.tid_settl_method = 'C') 
                        then 1 else 0 end) as XCHG_CNT,
               sum(case when (ind.card_scheme = '03' and t.tid in ($chgtid) and t.tid_settl_method = 'C') 
                        then ind.amt_recon/-100 else 0 end) as XCHG_AMT,
               sum(case when (ind.card_scheme = '03' and t.tid in ($chgtid) and t.tid_settl_method = 'D') 
                        then 1 else 0 end) as XCHG_R_CNT,
               sum(case when (ind.card_scheme = '03' and t.tid in ($chgtid) and t.tid_settl_method = 'D') 
                        then ind.amt_recon/100 else 0 end) as XCHG_R_AMT,

               sum(case when (ind.card_scheme = '08' and t.tid in ($chgtid) and t.tid_settl_method = 'C') 
                        then 1 else 0 end) as DCHG_CNT,
               sum(case when (ind.card_scheme = '08' and t.tid in ($chgtid) and t.tid_settl_method = 'C') 
                        then ind.amt_recon/-100 else 0 end) as DCHG_AMT,
               sum(case when (ind.card_scheme = '08' and t.tid in ($chgtid) and t.tid_settl_method = 'D') 
                        then 1 else 0 end) as DCHG_R_CNT,
               sum(case when (ind.card_scheme = '08' and t.tid in ($chgtid) and t.tid_settl_method = 'D') 
                        then ind.amt_recon/100 else 0 end) as DCHG_R_AMT,

               sum(case when (ind.card_scheme = '04' and t.tid = '010003010102') 
                        then 1 else 0 end) as VARB_C_CNT,
               sum(case when (ind.card_scheme = '04' and t.tid = '010003010102' ) 
                        then ind.amt_trans/-100 else 0 end) as VARB_C_AMT,
               sum(case when (ind.card_scheme = '04' and t.tid = '010003010101') 
                        then 1 else 0 end) as VARB_D_CNT,
               sum(case when (ind.card_scheme = '04' and t.tid = '010003010101' ) 
                        then ind.amt_trans/100 else 0 end) as VARB_D_AMT, 

               sum(case when (ind.card_scheme = '05' and t.tid = '010003010102') 
                        then 1 else 0 end) as MARB_C_CNT,
               sum(case when (ind.card_scheme = '05' and t.tid = '010003010102' ) 
                        then ind.amt_trans/-100 else 0 end) as MARB_C_AMT,
               sum(case when (ind.card_scheme = '05' and t.tid = '010003010101') 
                        then 1 else 0 end) as MARB_D_CNT,
               sum(case when (ind.card_scheme = '05' and t.tid = '010003010101' ) 
                        then  ind.amt_trans/100 else 0 end) as MARB_D_AMT,

               sum(case when (ind.card_scheme = '03' and t.tid = '010003010102') 
                        then 1 else 0 end) as XARB_C_CNT,
               sum(case when (ind.card_scheme = '03' and t.tid = '010003010102' ) 
                        then ind.amt_trans/-100 else 0 end) as XARB_C_AMT,
               sum(case when (ind.card_scheme = '03' and t.tid = '010003010101') 
                        then 1 else 0 end) as XARB_D_CNT,
               sum(case when (ind.card_scheme = '03' and t.tid = '010003010101' ) 
                        then  ind.amt_trans/100 else 0 end) as XARB_D_AMT,

               sum(case when (ind.card_scheme = '08' and t.tid = '010003010102') 
                        then 1 else 0 end) as DARB_C_CNT,
               sum(case when (ind.card_scheme = '08' and t.tid = '010003010102' ) 
                        then ind.amt_trans/-100 else 0 end) as DARB_C_AMT,
               sum(case when (ind.card_scheme = '08' and t.tid = '010003010101') 
                        then 1 else 0 end) as DARB_D_CNT,
               sum(case when (ind.card_scheme = '08' and t.tid = '010003010101' ) 
                        then  ind.amt_trans/100 else 0 end) as DARB_D_AMT

        from in_draft_main ind, in_file_log ifl, tid t
        where ind.in_file_nbr = ifl.in_file_nbr
          and ind.tid = t.tid
          and ifl.end_dt >= '$date' and ifl.end_dt < '$tomorrow'
          and ind.pri_dest_inst_id = '$instID'"
                
    #  puts "chg_qry: $chg_qry"
    
      orasql $daily_cursor $chg_qry
      
      while {[orafetch $daily_cursor -dataarray c -indexbyname] != 1403} {
           set VCHG_CNT     $c(VCHG_CNT)
           set VCHG_AMT     $c(VCHG_AMT)
           set VCHG_R_CNT   $c(VCHG_R_CNT)
           set VCHG_R_AMT   $c(VCHG_R_AMT)
           
           set MCHG_CNT     $c(MCHG_CNT)
           set MCHG_AMT     $c(MCHG_AMT)
           set MCHG_R_CNT   $c(MCHG_R_CNT)
           set MCHG_R_AMT   $c(MCHG_R_AMT)          
         
           set XCHG_CNT     $c(XCHG_CNT)
           set XCHG_AMT     $c(XCHG_AMT)
           set XCHG_R_CNT   $c(XCHG_R_CNT)
           set XCHG_R_AMT   $c(XCHG_R_AMT)
           
           set DCHG_CNT     $c(DCHG_CNT)
           set DCHG_AMT     $c(DCHG_AMT)
           set DCHG_R_CNT   $c(DCHG_R_CNT)
           set DCHG_R_AMT   $c(DCHG_R_AMT)
           
           set VARB_C_CNT   $c(VARB_C_CNT)
           set VARB_C_AMT   $c(VARB_C_AMT)
           set VARB_D_CNT   $c(VARB_D_CNT)
           set VARB_D_AMT   $c(VARB_D_AMT)
           
           set MARB_C_CNT   $c(MARB_C_CNT)
           set MARB_C_AMT   $c(MARB_C_AMT)
           set MARB_D_CNT   $c(MARB_D_CNT)
           set MARB_D_AMT   $c(MARB_D_AMT)
 
           set XARB_C_CNT   $c(XARB_C_CNT)
           set XARB_C_AMT   $c(XARB_C_AMT)
           set XARB_D_CNT   $c(XARB_D_CNT)
           set XARB_D_AMT   $c(XARB_D_AMT) 
           
           set DARB_C_CNT   $c(DARB_C_CNT)
           set DARB_C_AMT   $c(DARB_C_AMT)
           set DARB_D_CNT   $c(DARB_D_CNT)
           set DARB_D_AMT   $c(DARB_D_AMT)
      }
      
      set V_CHG_NET_CNT    [expr $VCHG_CNT + $VCHG_R_CNT]
      set V_CHG_NET_AMT    [expr $VCHG_AMT + $VCHG_R_AMT]

      set M_CHG_NET_CNT    [expr $MCHG_CNT + $MCHG_R_CNT]
      set M_CHG_NET_AMT    [expr $MCHG_AMT + $MCHG_R_AMT]
      
      set X_CHG_NET_CNT    [expr $XCHG_CNT + $XCHG_R_CNT]
      set X_CHG_NET_AMT    [expr $XCHG_AMT + $XCHG_R_AMT]

      set SUB_CHG_AMT      [expr $VCHG_AMT   + $MCHG_AMT   + $XCHG_AMT]
      set SUB_CHG_CNT      [expr $VCHG_CNT   + $MCHG_CNT   + $XCHG_CNT]
      set SUB_CHG_R_AMT    [expr $VCHG_R_AMT + $MCHG_R_AMT + $XCHG_R_AMT]
      set SUB_CHG_R_CNT    [expr $VCHG_R_CNT + $MCHG_R_CNT + $XCHG_R_CNT]
      
      set VARB_NET_CNT     [expr $VARB_C_CNT + $VARB_D_CNT]
      set VARB_NET_AMT     [expr $VARB_D_AMT + $VARB_C_AMT]

      set MARB_NET_CNT     [expr $MARB_C_CNT + $MARB_D_CNT]
      set MARB_NET_AMT     [expr $MARB_D_AMT + $MARB_C_AMT]

      set XARB_NET_CNT     [expr $XARB_C_CNT + $XARB_D_CNT]
      set XARB_NET_AMT     [expr $XARB_D_AMT + $XARB_C_AMT]

      set ARB_SUBC_CNT     [expr $VARB_C_CNT   + $MARB_C_CNT   + $XARB_C_CNT]
      set ARB_SUBC_AMT     [expr $VARB_C_AMT   + $MARB_C_AMT   + $XARB_C_AMT]  
      set ARB_SUBD_CNT     [expr $VARB_C_CNT   + $MARB_D_CNT   + $XARB_D_CNT]
      set ARB_SUBD_AMT     [expr $VARB_C_AMT   + $MARB_D_AMT   + $XARB_D_AMT]       
      set ARB_SUB_CNT      [expr $VARB_NET_CNT + $MARB_NET_CNT + $XARB_NET_CNT]
      set ARB_SUB_AMT      [expr $VARB_NET_AMT + $MARB_NET_AMT + $XARB_NET_AMT]
      
      set VREP_NET_CNT     [expr $VREP_C_CNT + $VREP_R_CNT]
      set VREP_NET_AMT     [expr $VREP_R_AMT + $VREP_C_AMT]

      set MREP_NET_CNT     [expr $MREP_C_CNT + $MREP_R_CNT]
      set MREP_NET_AMT     [expr $MREP_R_AMT + $MREP_C_AMT]

      set XREP_NET_CNT     [expr $XREP_C_CNT + $XREP_R_CNT]
      set XREP_NET_AMT     [expr $XREP_R_AMT + $XREP_C_AMT]

      set REP_SUBC_CNT     [expr $VREP_C_CNT   + $MREP_C_CNT   + $XREP_C_CNT]
      set REP_SUBC_AMT     [expr $VREP_C_AMT   + $MREP_C_AMT   + $XREP_C_AMT]  
      set REP_SUBD_CNT     [expr $VREP_R_CNT   + $MREP_R_CNT   + $XREP_R_CNT]
      set REP_SUBD_AMT     [expr $VREP_R_AMT   + $MREP_R_AMT   + $XREP_R_AMT]       
      set REP_SUB_CNT      [expr $VREP_NET_CNT + $MREP_NET_CNT + $XREP_NET_CNT]
      set REP_SUB_AMT      [expr $VREP_NET_AMT + $MREP_NET_AMT + $XREP_NET_AMT]

      puts $cur_file " "
      puts $cur_file "CHARGEBACKS:"
      puts $cur_file ",COUNT,SALES/DEBIT,COUNT,RETURN/CR,,TOTAL COUNT,NET AMOUNT"
      puts $cur_file "VISA,$VCHG_R_CNT,$$VCHG_R_AMT,$VCHG_CNT,$$VCHG_AMT,,$V_CHG_NET_CNT,$$V_CHG_NET_AMT"
      puts $cur_file "MC,$MCHG_R_CNT,$$MCHG_R_AMT,$MCHG_CNT,$$MCHG_AMT,,$M_CHG_NET_CNT,$$M_CHG_NET_AMT"
      puts $cur_file "AMEX,$XCHG_R_CNT,$$XCHG_R_AMT,$XCHG_CNT,$$XCHG_AMT,,$X_CHG_NET_CNT,$$X_CHG_NET_AMT"
      puts $cur_file "SUBTOTAL,$SUB_CHG_R_CNT,$$SUB_CHG_R_AMT,$SUB_CHG_CNT,$$SUB_CHG_AMT,,[expr $V_CHG_NET_CNT + \
                               $M_CHG_NET_CNT + $X_CHG_NET_CNT],$[expr $V_CHG_NET_AMT + $M_CHG_NET_AMT + $X_CHG_NET_AMT]"
      puts $cur_file " "      
      puts $cur_file "PRE ARBITRATION:"
      puts $cur_file ",COUNT,SALES/DEBIT,COUNT,RETURN/CR,,TOTAL COUNT,NET AMOUNT"
      puts $cur_file "VISA,$VARB_C_CNT,$$VARB_C_AMT,$VARB_D_CNT,$$VARB_D_AMT,,$VARB_NET_CNT,$$VARB_NET_AMT"
      puts $cur_file "MC,$MARB_C_CNT,$$MARB_C_AMT,$MARB_D_CNT,$$MARB_D_AMT,,$MARB_NET_CNT,$$MARB_NET_AMT"
      puts $cur_file "AMEX,$XARB_C_CNT,$$XARB_C_AMT,$XARB_D_CNT,$$XARB_D_AMT,,$XARB_NET_CNT,$$XARB_NET_AMT"      
      puts $cur_file "SUBTOTAL,$ARB_SUBC_CNT,$$ARB_SUBC_AMT,$ARB_SUBD_CNT,$$ARB_SUBD_AMT,,$ARB_SUB_CNT,$$ARB_SUB_AMT"
      puts $cur_file " " 
      puts $cur_file "REPRESENTMENT:"
      puts $cur_file ",COUNT,SALES/DEBIT,COUNT,RETURN/CR,,TOTAL COUNT,NET AMOUNT"
      puts $cur_file "VISA,$VREP_C_CNT,$$VREP_C_AMT,$VREP_R_CNT,$$VREP_R_AMT,,$VREP_NET_CNT,$$VREP_NET_AMT"
      puts $cur_file "MC,$MREP_C_CNT,$$MREP_C_AMT,$MREP_R_CNT,$$MREP_R_AMT,,$MREP_NET_CNT,$$MREP_NET_AMT"
      puts $cur_file "AMEX,$XREP_C_CNT,$$XREP_C_AMT,$XREP_R_CNT,$$XREP_R_AMT,,$XREP_NET_CNT,$$XREP_NET_AMT"
      puts $cur_file "SUBTOTAL,$REP_SUBC_CNT,$$REP_SUBC_AMT,$REP_SUBD_CNT,$$REP_SUBD_AMT,,$REP_SUB_CNT,$$REP_SUB_AMT"
    
##========  MISC ==========

      puts $cur_file " "    
      puts $cur_file "MISC:"
      puts $cur_file ",COUNT,SALES//DEBIT,COUNT,RETURN//CR,,TOTAL COUNT,NET AMOUNT"
      puts $cur_file "VISA,0,0.00,0,0.00,,0,0.00"
      puts $cur_file "MC,0,0.00,0,0.00,,0,0.00"
      puts $cur_file "AMEX,0,0.00,0,0.00,,0,0.00"
      puts $cur_file "SUBTOTAL,0,0.00,0,0.00,,0,0.00"  
      
##========  TOTAL ==========

      puts $cur_file " "    
      puts $cur_file "TOTAL,0,0.00,0,0.00,,0,0.00"   
       
##========  MTD ==========
#==============================

close $cur_file

if {$mode == "TEST"} {
    exec echo "Please see attached." | mutt -a "$cur_file_name" -s $file_name test-clearing@jetpay.com
} elseif {$mode == "PROD"} {
    exec echo "Please see attached." | mutt -a "$cur_file_name" -s $file_name Reports-clearing@jetpay.com

}

set salezip "$file_name.zip"
exec zip  $salezip  $file_name

exec mv  $file_name $apath
exec mv  $salezip $apath         
}

arg_parse

if {[info exists date_arg]} {
    init_dates $date_arg
} else {
    init_dates [clock format [clock seconds] -format %Y%m%d]
}

do_report 117

oraclose $daily_cursor

oralogoff $handler



