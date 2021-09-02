#!/usr/bin/env tclsh

# $Id: extra_processing_fees.tcl 4383 2017-10-06 20:22:04Z skumar $

# Modified by Shannon Simpson 2009 01 28
# original Written By Rifat Khan
#Jetpay LLC
#Older internal vertion 1.0 , Older version 35.0
#Changed the trans_ref_data from 25 spaces to 23 spaces and changed the line size for MSG detail to 200 bytes.
#revised 20060426 with internal version 1.1 , expected version of 36.0
#
#Changed the complete code reformated for perfomance issue.
#revised 20061201 with internal verion 2.0
#


package require Oratcl
package provide random 1.0
lappend auto_path $env(MASCLR_LIB)
package require GetOpts 1.1

source $env(MASCLR_LIB)/masclr_tcl_lib
source $env(MASCLR_LIB)/mas_file_lib

global MODE
set MODE "PROD"

# Types of counting types
#
# VS_ISA_FEE MC_BORDER MC_GE_1K DS_INTERNATIONAL ZZACQSUPPORTFEE
#
# cnt_type      description                       filename  mas_code
#
# CANADA_TAX    Sales tax for Canada           -  CANADAST  00GST 00QST
# DS_INTERNATIONAL Discover Int'l Service Fee  -  DSBORDER  DS_INTL_PROC DS_INTL_SERV
# FUND_XFER     Funds transfer counts          -  FUNDXFER  00FUNDXFER
# PIN_DB_SPNSR  PIN Debit sponsorship fee      -  PINDBSPN  DBT_ASSMT_SPONSORSHIP
# MC_ANF        MasterCard Annual 12$ n/w fees -  MCANWFEE  MC_ANNUAL_NW
# MC_BORDER     MasterCard Cross Border Fees   -  MCBORDER  MC_BORDER MC_GLOBAL_ACQ
# MC_GE_1K      MasterCard Assessment >= 1000  -  MCASGE1K  MC_ASSMT_GE1K MC_ASSMT_GE1K_DBT
# VS_ISA_FEE    Visa International Service Fee -  VISAISAF  VS_ISA_FEE VS_INT_ACQ_FEE
# ZZACQSUPPORT  Acquirer Support (not used)    -  ACQSUPPO
# MNTHLY_SETL   Monthly Settle fee           -  MNTHSETL  MONTHLY_SETTLE

proc get_inst {} {
    global inst_dictionary, inst_id
    global clr_get1
    global icurr_code inst_curr_cd
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

proc get_sql {f_type } {
    global cmonth
    global cyear
    global inst_id
    # query needs currency code, entity ID, mas_code,mid ??, count, amount,
    # returning amount as a decimal number with decimal separator
    switch $f_type {

        "CANADA_TAX" {
            set nm "
                select
                    mtl.institution_id ,
                    mtl.entity_id,
                    trunc(mtl.gl_date, 'MM') gl_month,
                    mtl.curr_cd_original curr_cd,
                    nvl(ma.PROV_STATE_ABBREV,'XX') prov_abbr,
                    'CDN_TAX_' || nvl(ma.PROV_STATE_ABBREV,'XX') mas_code,
                    1 count,
                    sum(  case when mtl.tid_settl_method = 'D' then 1 else -1 end *
                            mtl.amt_billing
                    ) Amount
                from
                    (select 'mtl' tab, institution_id, entity_id, gl_date, tid,
                        mas_code, nbr_of_items, amt_original, amt_billing,
                        tid_settl_method, principal_amt, curr_cd_original
                    from mas_trans_log
                    union all
                    select 'mtlmf' tab, institution_id, entity_id, gl_date, tid,
                        mas_code, nbr_of_items, amt_original, amt_billing,
                        tid_settl_method, principal_amt, curr_cd_original
                    from mas_trans_log_missed_fees)  mtl
                    join acq_entity ae
                        on mtl.institution_id = ae.institution_id
                        and mtl.entity_id = ae.entity_id
                    left outer join acq_entity_address aea
                    on mtl.institution_id = aea.institution_id
                    and mtl.entity_id = aea.entity_id
                    and aea.address_role = 'LOC'
                    left outer join master_address ma
                    on aea.institution_id = ma.institution_id
                    and aea.address_id = ma.address_id

                where
                    mtl.gl_date >=          to_date(:year_var || :month_var, 'YYYYMM')
                and mtl.gl_date <  last_day(to_date(:year_var || :month_var, 'YYYYMM'))+1
                and mtl.institution_id               = :inst_id_var
                and mtl.tid like '010004%'
                and mtl.tid != '010004620000'
                and mtl.tid != '010004620001'
                and mtl.tid != '010004620005'
                and  mtl.amt_billing != 0
                group by
                    mtl.institution_id,
                    mtl.entity_id,
                    trunc(mtl.gl_date, 'MM'),
                    nvl(ma.PROV_STATE_ABBREV,'XX'),
                    'CDN_TAX_' || nvl(ma.PROV_STATE_ABBREV,'XX'),
                    mtl.curr_cd_original
                having sum(  case when mtl.tid_settl_method = 'D' then 1 else -1 end *
                        mtl.amt_billing
                    ) > 0
            order by
                mtl.entity_id
            "
        }
        "MC_ANF" {
            set nm "
             select distinct
                mtl.institution_id ,
                mtl.entity_id,
                mtl.card_scheme,
                mtl.curr_cd_original CURR_CD,
                1 count,
                1 amount
            from
                masclr.mas_trans_log mtl
                join acq_entity ae
                on mtl.institution_id = ae.institution_id
                  and mtl.entity_id = ae.entity_id
                  and ae.entity_status =  'A'
                  and ae.entity_level = '70'
                  and ae.termination_date is null
            where
                mtl.institution_id = :inst_id_var
                and mtl.card_scheme = '05'
                and mtl.gl_date  >=          to_date(:year_var || :month_var, 'YYYYMM')
                and mtl.gl_date  <  last_day(to_date(:year_var || :month_var, 'YYYYMM'))+1
                and mtl.amt_billing != 0
                and mtl.TRANS_SUB_SEQ = 0
           group by
                mtl.institution_id ,
                mtl.entity_id,
                mtl.card_scheme,
                mtl.curr_cd_original
            order by
                mtl.entity_id
            "
        }
        "PIN_DB_SPNSR" {
            set nm "
             select
                mtl.institution_id ,
                mtl.entity_id,
                mtl.card_scheme,
                mtl.curr_cd_original CURR_CD,
                COUNT(mtl.trans_seq_nbr) COUNT,
                SUM(mtl.amt_original) amount

            from
                masclr.mas_trans_log mtl
            where
                mtl.institution_id = :inst_id_var
                and mtl.card_scheme = '02'
                and mtl.gl_date  >=          to_date(:year_var || :month_var, 'YYYYMM')
                and mtl.gl_date  <  last_day(to_date(:year_var || :month_var, 'YYYYMM'))+1
                and mtl.amt_billing != 0
                and mtl.TRANS_SUB_SEQ = 0
           group by
                mtl.institution_id ,
                mtl.entity_id,
                mtl.card_scheme,
                mtl.curr_cd_original
            order by
                mtl.entity_id
            "
        }
        "VS_ISA_FEE" {
            set nm "
            SELECT
                ifl.institution_id ,
                idm.merch_id ENTITY_ID,
                idm.mcc ,
                idm.TRANS_CCD CURR_CD,
                MAX(efp.fee_pkg_id) fee_pkg_id,
                COUNT(idm.trans_seq_nbr) COUNT,
                TO_CHAR(SUM(idm.amt_trans)/100, '9999999.00') amount
            FROM masclr.in_draft_main idm
            JOIN masclr.trans_enrichment te
              ON te.trans_seq_nbr = idm.trans_seq_nbr
            JOIN masclr.in_file_log ifl
              ON ifl.in_file_nbr = idm.in_file_nbr
            JOIN masclr.entity_fee_pkg efp
              ON efp.entity_id = idm.merch_id
            WHERE TO_CHAR(ifl.end_dt, 'MM')   = :month_var
              AND TO_CHAR(ifl.end_dt, 'YYYY') = :year_var
              AND ifl.institution_id          = :inst_id_var
              AND idm.tid                    IN ('010103005101')
              AND idm.card_scheme             = '04'
              AND te.iss_cntry_code_a2 NOT   IN ('US')
              AND idm.src_inst_id            IN ( :inst_id_var )
              AND idm.TRANS_CLR_STATUS       IS NULL
              AND efp.fee_pkg_id             IN ('45','47')
              AND efp.end_date               IS NULL
              AND ifl.in_file_status         IN ('P','C')
            GROUP BY
                ifl.institution_id ,
                idm.merch_id,
                idm.mcc ,
                idm.TRANS_CCD
            ORDER BY
                idm.merch_id "
        }

        "MC_BORDER" {
            set nm "
            SELECT
                ifl.institution_id ,
                idm.merch_id ENTITY_ID,
                idm.TRANS_CCD CURR_CD ,
                '45' fee_pkg_id,
                COUNT(idm.trans_seq_nbr) COUNT,
                TO_CHAR(SUM(idm.amt_trans)/100, '9999999.00') amount
            FROM
                masclr.in_draft_main idm
            JOIN masclr.trans_enrichment te
              ON  idm.trans_seq_nbr = te.trans_seq_nbr
            JOIN masclr.in_file_log ifl
              ON  ifl.in_file_nbr = idm.in_file_nbr
            WHERE
                  TO_CHAR(ifl.incoming_dt, 'MM')     = :month_var
              AND TO_CHAR(ifl.incoming_dt, 'YYYY') = :year_var
              AND ifl.institution_id               = :inst_id_var
              AND te.tga                          <> '3'
              AND idm.card_scheme                  = '05'
              AND idm.tid                         IN ('010103005101', '010103005301')
              AND idm.src_inst_id                 IN ( :inst_id_var )
            GROUP BY
                ifl.institution_id ,
                idm.merch_id ,
                idm.TRANS_CCD
            ORDER BY
                idm.merch_id "
        }

        "MC_GE_1K" {
            set nm "
            SELECT
                mtl.institution_id ,
                mtl.entity_id,
                mtl.card_scheme,
                mtl.curr_cd_original CURR_CD,
                case when mcg.mas_code in ('MCCR') then 'MC_ASSMT_GE1K'
                     end mas_code,
                COUNT(mtl.trans_seq_nbr) COUNT,
                SUM(mtl.amt_original) amount
            FROM masclr.mas_trans_view mtl
            left outer join mas_code_grp mcg
            on mcg.institution_id = mtl.institution_id
            and mcg.mas_code_grp_id = 60
            and mcg.qualify_mas_code = mtl.mas_code
            WHERE
                  mtl.gl_date >=          to_date(:year_var || :month_var, 'YYYYMM')
              AND mtl.gl_date <= last_day(to_date(:year_var || :month_var, 'YYYYMM'))
              AND mtl.institution_id               = :inst_id_var
              AND mtl.card_scheme                  = '05'
              AND mcg.mas_code IN ('MCCR')
              AND mtl.major_cat IN ('SALES')
              and mtl.amt_original >= 1000
            group by
                mtl.institution_id ,
                mtl.entity_id,
                mtl.card_scheme,
                mtl.curr_cd_original,
                case when mcg.mas_code in ('MCCR') then 'MC_ASSMT_GE1K'
                     end
            order by
                mtl.institution_id ,
                mtl.entity_id,
                mtl.card_scheme
            "
        }

        "DS_INTERNATIONAL" {
            set nm "
            SELECT
                ifl.institution_id ,
                idm.merch_id ENTITY_ID,
                '45' fee_pkg_id,
                idm.TRANS_CCD CURR_CD ,
                te.acq_cntry_code_a2,
                COUNT(idm.trans_seq_nbr) COUNT,
                TO_CHAR(SUM(idm.amt_trans)/100, '9999999.00') amount
            FROM
                masclr.in_draft_main idm
            JOIN masclr.trans_enrichment te
              ON  idm.trans_seq_nbr = te.trans_seq_nbr
            JOIN masclr.in_file_log ifl
              ON  ifl.in_file_nbr = idm.in_file_nbr
            WHERE
                  TO_CHAR(ifl.incoming_dt, 'MM')   = :month_var
              AND TO_CHAR(ifl.incoming_dt, 'YYYY') = :year_var
              AND ifl.institution_id               = :inst_id_var
              AND ifl.in_file_nbr                  = idm.in_file_nbr
              AND idm.trans_seq_nbr                = te.trans_seq_nbr
              AND idm.card_scheme                  = '08'
              AND idm.src_inst_id                 IN ( :inst_id_var )
              AND idm.mas_code                   like '%INTL%'
            GROUP BY
                ifl.institution_id ,
                idm.merch_id ,
                idm.TRANS_CCD ,
                te.acq_cntry_code_a2
            ORDER BY
                idm.merch_id "
        }
        "MNTHLY_SETL" {
            set nm "
            SELECT
                mtl.INSTITUTION_ID                                          INSTITUTION_ID,
                mtl.ENTITY_ID                                               ENTITY_ID,
                ae.ENTITY_DBA_NAME                                          MERCH_NAME,
                mtl.CURR_CD_ORIGINAL                                        CURR_CD,
                COUNT(mtl.trans_seq_nbr)                                    COUNT,
                'MONTHLY_SETTLE'                                            MAS_CODE,
                SUM(
                   case when mtl.tid_settl_method = 'C' then 1 else -1 end
                         * mtl.amt_original)                                 AMOUNT
            FROM
                masclr.mas_trans_log mtl join
                (
                   SELECT DISTINCT ae.institution_id,ae.entity_id, spt.settl_plan_id
                   FROM ACQ_ENTITY ae join SETTL_PLAN_TID spt
                   ON spt.institution_id = ae.institution_id and spt.settl_plan_id = ae.settl_plan_id
                   WHERE
                   ae.institution_id = :inst_id_var
                   and ae.entity_status = 'A'
                   and ae.entity_level = '70'
                   and spt.settl_freq = 'M'
                   and spt.tid = '010004010000'
                   and spt.card_scheme = '04'
                ) merch_list on mtl.institution_id = merch_list.institution_id
                   and mtl.settl_plan_id = merch_list.settl_plan_id
                   and mtl.entity_id = merch_list.entity_id
                join acq_entity ae
                   on ae.institution_id = mtl.institution_id
                   and ae.entity_id = mtl.entity_id
                join tid_adn ta
                   on ta.tid = mtl.tid
                   and ta.usage = 'MAS'
                join
                (
                   SELECT DISTINCT institution_id,entity_id
                   FROM merchant_flag
                   WHERE  flag_type = 'MONTHLY_SETTLE' and flag_type_value = 'Y'
                ) mf on mf.institution_id = mtl.institution_id
                  and mf.entity_id = mtl.entity_id
            WHERE
                mtl.institution_id = :inst_id_var
                and mtl.gl_date >=          to_date(:year_var || :month_var, 'YYYYMM')
                and mtl.gl_date <  last_day(to_date(:year_var || :month_var, 'YYYYMM'))+1
                and ta.major_cat in ('SALES')
                and mtl.trans_sub_seq = 0
            GROUP BY
                mtl.institution_id ,
                mtl.entity_id,
                ae.entity_dba_name,
                mtl.curr_cd_original,
                'MONTHLY_SETTLE'
            ORDER BY
                mtl.entity_id"
        }

        "ZZACQSUPPORTFEE" {
            # get from a file, not the database
            set nm -1
        }

        default {puts stdout "
            Incorrect Count File Type: $f_type\n Valid Values are:
                1) CANADA_TAX         -- Sales tax for Canada
                2) DS_INTERNATIONAL   -- Discover International processing/suppart fee
                3) MC_BORDER          -- MasterCard Interregional/Cross-border fees
                4) MC_GE_1K           -- MasterCard Assessment on Trans Amt >= 1000
                5) VS_ISA_FEE         -- Visa ISA fees
                6) ZZACQSUPPORTFEE    -- Acquirer support fee
                7) PIN_DB_SPNSR       -- PIN Debit sponsorship fee
                8) MC_ANF             -- MC Annual Network 12$ fee
                9) MNTHLY_SETL        -- Monthly Settle fee
                "
            exit 1
        }

    }
    #puts $nm
    return $nm
}

proc get_fname {f_type} {

    switch $f_type {
        "CANADA_TAX"          {set nm "CANADAST"}
        "DS_INTERNATIONAL"    {set nm "DSBORDER"}
        "MC_BORDER"           {set nm "MCBORDER"}
        "MC_GE_1K"            {set nm "MCASGE1K"}
        "VS_ISA_FEE"          {set nm "VISAISAF"}
        "ZZACQSUPPORTFEE"     {set nm "ACQSUPPO"}
        "PIN_DB_SPNSR"        {set nm "PINDBSPN"}
        "MC_ANF"              {set nm "MCANWFEE"}
        "MNTHLY_SETL"         {set nm "MNTHSETL"}
    }

    return $nm

}

proc get_tid {f_type tid_idntfr} {

    switch $f_type {
        "CANADA_TAX"          {set nm "010070020001"}
        "DS_INTERNATIONAL"    {set nm "010070020001"}
        "MC_BORDER"           {set nm "010070020001"}
        "MC_GE_1K"            {set nm "010070020001"}
        "VS_ISA_FEE"          {set nm "010070020001"}
        "ZZACQSUPPORTFEE"     {set nm "010070020001"}
        "PIN_DB_SPNSR"        {set nm "010070020001"}
        "MC_ANF"              {set nm "010070020001"}
        "MNTHLY_SETL"         {set nm "010070020001"}
    }
    return $nm
}


# called first
proc set_args {} {

    global MODE
    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year argc argv
    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l
    global mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global cfg_pth log_pth arch_pth ms_fl_pth hold_pth upld_pth stop_pth tmp_pth
    global currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime
    global endtime cutoff
    #    global dbhost dbhost1 tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt
    #    global tblnm_mf tblnm_e2a tblnm_tr

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
                default {puts stdout "$pind is an invalid parameter indicator $i\n\n[show_direction]"; exit 1}
            }
            set i [expr $i + 1]
        }
        if {$inst_id == "" || $cnt_type == ""} {
            puts stdout [show_direction]
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
        -v = >$MASCLR::DEBUG_LEVEL< (debug level)
        -T = >$MODE<
        "

    } elseif {$argc < 2} {
        puts stdout [show_direction]
        exit 1
    }

    set cfg_pth     "./CFG"
    set log_pth     "./LOGS"
    set arch_pth    "./INST_$inst_id/ARCHIVE"
    set ms_fl_pth   "./INST_$inst_id/MAS_FILES"
    set hold_pth    "./INST_$inst_id/HOLD_FILES"
    set upld_pth    "./INST_$inst_id/UPLOAD"
    set stop_pth    "./INST_$inst_id/STOP"
    set tmp_pth     "./INST_$inst_id/TEMP"

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
    6) -v                   (Optional increase verbosity, i.e., debug level)
    7) -T                   (Optional set the MODE to TEST)
    Example:
    extra_processing_fees.tcl -i101 -cAUTH -m9
    extra_processing_fees.tcl -i107 -cVAU -mJAN -y2007
    Note:
    You can not run this code for future Months. It will autometically set it to Above Defualt Values.
    "
    return $run_instruction
}

proc get_cfg {inst_id cfg_pth} {
    #    global arr_cfg
    #    set cfg_file "$inst_id.inst.cfg"
    #    set in_cfg [open $cfg_pth/$cfg_file r]
    #    set cur_line  [split [set orig_line [gets $in_cfg] ] ,]
    #    while {$cur_line != ""} {
    #        if {[string toupper [string trim [lindex $cur_line 0]]] != ""} {
    #            set arr_cfg([string toupper [string trim [lindex $cur_line 0]]]) [string trim [lindex $cur_line 1]]
    #        }
    #        puts "arr_cfg([string toupper [string trim [lindex $cur_line 0]]]) [string trim [lindex $cur_line 1]]"
    #        set cur_line  [split [set orig_line [gets $in_cfg] ] ,]
    #    }
    #    return arr_cfg
}

proc set_dir_paths {inst_id pth_varname gbl_pth_ext} {
    switch $pth_varname {
        "cfg_pth"       {set pth "$gbl_pth_ext/CFG"}
        "log_pth"       {set pth "$gbl_pth_ext/LOGS"}
        "arch_pth"      {set pth "$gbl_pth_ext/ARCHIVE"}
        "ms_fl_pth"     {set pth "$gbl_pth_ext/MAS_FILES"}
        "hold_pth"      {set pth "$gbl_pth_ext/HOLD_FILES"}
        "upld_pth"      {set pth "$gbl_pth_ext/UPLOAD"}
        "stop_pth"      {set pth "$gbl_pth_ext/STOP"}
        "tmp_pth"       {set pth "$gbl_pth_ext/TEMP"}
        defualt {}
    }
    return $pth
}


puts "========================================================================================"

# Set Dates for the run
proc get_run_mnth {rmnth} {
    global rightnow cmonth cdate cyear jdate

    if {[string is digit $rmnth]} {
        switch $rmnth {
            "01" {set rmnth 1}
            "02" {set rmnth 2}
            "03" {set rmnth 3}
            "04" {set rmnth 4}
            "05" {set rmnth 5}
            "06" {set rmnth 6}
            "07" {set rmnth 7}
            "08" {set rmnth 8}
            "09" {set rmnth 9}
            "10" {set rmnth 10}
            "11" {set rmnth 11}
            "12" {set rmnth 12}
            "1"  {set rmnth 1}
            "2"  {set rmnth 2}
            "3"  {set rmnth 3}
            "4"  {set rmnth 4}
            "5"  {set rmnth 5}
            "6"  {set rmnth 6}
            "7"  {set rmnth 7}
            "8"  {set rmnth 8}
            "9"  {set rmnth 9}
            default {set rmnth 0}
        }
    } else {
        set rmnth [string range $rmnth 0 2]
        switch $rmnth {
            "JAN" {set rmnth 1}
            "FEB" {set rmnth 2}
            "MAR" {set rmnth 3}
            "APR" {set rmnth 4}
            "MAY" {set rmnth 5}
            "JUN" {set rmnth 6}
            "JUL" {set rmnth 7}
            "AUG" {set rmnth 8}
            "SEP" {set rmnth 9}
            "OCT" {set rmnth 10}
            "NOV" {set rmnth 11}
            "DEC" {set rmnth 12}
            default {set rmnth 0}
        }
    }

    if {$rmnth > 12} {
        puts "Invalid Month provided $rmnth. It should be either 1 - 12 OR JAN - DEC"
        exit 1
    } else {
        #Added the below line to solve the octal month issue which occurs for august and september month
        regsub {^[0]} $cmonth {\1} cmonth
        set dfmnth [expr $cmonth - $rmnth]
    }

    return $dfmnth

}

proc get_run_year {ryear} {
    global rightnow cmonth cdate cyear jdate
    if {$ryear <= $cyear} {
        set yr [expr $cyear - $ryear]
    } else {
        puts "Cannot run code for future Month or Year."
        exit 1
    }
    return $yr
}



# setting run dates
proc set_run_dates {} {

    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year argc argv get_run_year
    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l
    global mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global cfg_pth log_pth arch_pth ms_fl_pth hold_pth upld_pth stop_pth tmp_pth
    global currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime
    global endtime cutoff batchtime
    #    global dbhost dbhost1 tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt
    #    global tblnm_mf tblnm_e2a tblnm_tr


    #if {$argc == 5} {
    #    set yeartomnth [expr [get_run_year $run_year] * 12]
    #    set mnth [expr [get_run_mnth $run_mnth] + $yeartomnth]
    #} elseif {$argc == 4} {
    #    set yeartomnth [expr [get_run_year $run_year] * 12]
    #    set mnth [expr [get_run_mnth $run_mnth] + $yeartomnth]
    #} elseif {$argc == 3} {
    #    set mnth [get_run_mnth $run_mnth]
    #} elseif {$argc == 2} {
    #    set mnth 0
    #} else {
    #    set mnth 0
    #}

    #set begindatetime "to_char(last_day(add_months(SYSDATE, -[expr 1 + $mnth])), 'YYYYMMDD') || '$cutoff'"
    #set enddatetime "to_char(last_day(add_months(SYSDATE, -[expr 0 + $mnth])), 'YYYYMMDD') || '$cutoff'"
    append batchtime $sdate $cutoff
    #puts "Transaction count between $begindatetime :: $enddatetime :: $batchtime"
}




proc connect_to_dbs {} {
    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year  db_login_handle
    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l
    global mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global cfg_pth log_pth arch_pth ms_fl_pth hold_pth upld_pth stop_pth tmp_pth
    global currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime
    global endtime cutoff batchtime
    #    global dbhost dbhost1 tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt
    #    global tblnm_mf tblnm_e2a  tblnm_tr

    global env

    # this should use env variable $env(CLR4_DB) but for testing i have to go against trnclr4 evev on dev box
    if {[catch {set db_login_handle [oralogon masclr/masclr@$env(CLR4_DB)]} result]} {
        puts "$clrdb [info script] failed to run: $result"
        set mbody "$clrdb [info script] failed to run"
        #            exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        exit 1
    }

}

proc open_cursor_masclr {cursr} {
    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year  db_login_handle
    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l
    global mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global cfg_pth log_pth arch_pth ms_fl_pth hold_pth upld_pth stop_pth tmp_pth
    global currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime
    global endtime cutoff batchtime
    #    global dbhost dbhost1 tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt
    #    global tblnm_mf tblnm_e2a tblnm_tr



    global $cursr
    set $cursr [oraopen $db_login_handle]
}



proc get_outfile {f_seq} {

    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year
    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l
    global mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global cfg_pth log_pth arch_pth ms_fl_pth hold_pth upld_pth stop_pth tmp_pth env
    global currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime
    global endtime cutoff batchtime
    #    global dbhost dbhost1 tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt
    #    global tblnm_mf tblnm_e2a  tblnm_tr



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
    append outfile $pth $inst_id $dot $fname $dot $one $dot $jdate $dot $fileno

    while {$hk == 1} {
        if {[set ex [file exists $env(PWD)/$outfile]] == 1 ||
            [set ux [file exists $env(PWD)/MAS_FILES/$outfile]] == 1} {
            set fname [get_fname $cnt_type]
            set f_seq [expr $f_seq + 1]
            set fileno $f_seq
            set fileno [format %03s $f_seq]
            set one "01"
            set pth ""
            set outfile ""
            append outfile $pth $inst_id $dot $fname $dot $one $dot $jdate $dot $fileno
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


###### Loading Visa/MC id as exntity_id into an array with index of MID from the Database



###########################################################################################################

#Environment veriables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(SEC_DB)
set authdb $env(RPT_DB)

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

###########################################################################################################

#GLOBALS

global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year db_login_handle
global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l
global mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
global cfg_pth log_pth arch_pth ms_fl_pth hold_pth upld_pth stop_pth tmp_pth
global currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime endtime
global cutoff batchtime
global inst_curr_cd
#global dbhost dbhost1 tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt tblnm_mf
#global tblnm_e2a tblnm_tr

#TABLE NAMES-----------------------------------------------------

#set dbhost "teihost"
#set dbhost1 "masclr"
#if {$env(SYS_BOX) == "QA"} {
#    set p1dblink "@transp4_teihost"
#    set clr1dblink "@masclr_trnclr1"
#} else {
#    set p1dblink ""
#    set clr1dblink ""
#}
#set tblnm_sc "$dbhost1.ALL_SEQ_CTRL_TBL$clr1dblink"
#set tblnm_mfcg "$dbhost1.MAS_FILE_CODE_GRP$clr1dblink"
#set tblnm_mf "$dbhost1.MERCHANT_FLAG"
#set tblnm_e2a "$dbhost1.entity_to_auth$clr1dblink"

set currdate [clock format [clock seconds] -format "%Y%m%d"]
set sdate [clock format [ clock scan "$currdate" ] -format "%Y%m%d"]
set adate [clock format [ clock scan "$currdate -1 day" ] -format "%Y%m%d"]
set lydate [clock format [ clock scan "$currdate" ] -format "%m"]
set rightnow [clock seconds]
set cmonth [clock format $rightnow -format "%m"]
set cdate [clock format $rightnow -format "%d"]
set cyear [clock format $rightnow -format "%Y"]
set rightnow [clock format $rightnow -format "%Y%m%d%H%M%S"]
set jdate [ clock scan "$currdate"  -base [clock seconds] ]
set jdate [clock format $jdate -format "%y%j"]
set jdate [string range $jdate 1 end]

set begintime "000000"
set endtime "000000"

set dot "."


#Initializing for count file run -------------------------------------------




set_args
connect_to_dbs
#get_cfg $inst_id $cfg_pth
set_run_dates

set pth ""
set fn [get_fname $cnt_type]
set fchk $pth$inst_id$dot$fn$dot
catch {exec find $env(PWD)/INST_$inst_id/MAS_FILES -name "$fchk*"} result

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



###########################################################################################################
### MAIN ##################################################################################################
###########################################################################################################

set y 0


set fileseq 1

#Opening Output file to write to

set outfile [get_outfile $fileseq]

set fileseq [expr $fileseq + 1]

if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
    puts stderr "Cannot open /duplog : $fileid"
    exit 1
}


###### Writing File Header into the Mas file

set rec(file_date_time) $rightnow
set rec(activity_source) "JETPAYLLC"
set rec(activity_job_name) "ACQFEES"


write_fh_record $fileid rec



###### Sql Select to get all merchants daily transations count and sum amount

# set get_info "[get_sql $cnt_type ]"
# if {$get_info == -1 } {
# # get the information from an input file instead
#
# }
# #puts $get_info
# MASCLR::log_message "get_info: $get_info" 3
if { [catch {
    set get_info "[get_sql $cnt_type ]"
    MASCLR::log_message "get_info: $get_info" 3
    MASCLR::log_message "month:  $run_mnth" 3
    MASCLR::log_message "year:   $run_year" 3
    MASCLR::log_message "inst_id: $inst_id" 3
    oraparse $clr_get $get_info
    #changed cmonth and cyear to run_mnth and run_year
    orabind $clr_get :month_var $run_mnth :year_var $run_year :inst_id_var $inst_id
    oraexec $clr_get
} failure] } {
    error "Error parsing, binding or executing sql: $failure\n$clr_get"
}

#orasql $clr_get $get_info

###### Writing File Header into the Mas file

###### Declaring Variables and initializing
set mc_mas_code_list [list MC_BORDER MC_GLOBAL_ACQ]
set ds_mas_code_list [list DS_INTL_PROC DS_INTL_SERV]
set vs_mas_code_list [list VS_ISA_FEE VS_INT_ACQ_FEE]
set chkmid " "
set chkmidt " "
set totcnt 0
set totamt 0
set ftotcnt 0
set ftotamt 0
set trlcnt 0
set rec(trans_ref_data) ""

##Based on the institution currency_code cd to be set
if { $cnt_type == "MC_ANF"} {
    get_inst
}

###### While Loop for to fetch records gathered by Sql Select get_info
# query needs currency code, entity ID, mas_code, count, amount,
while {[set loop [orafetch $clr_get -dataarray fee_data_array -indexbyname]] == 0} {

    ###### Writing Batch Header Or Batch Trailer

    if {$chkmid != $fee_data_array(ENTITY_ID)} {
        set trlcnt 1
        if {$chkmid != " "} {

            #   puts "position 1: totamt = $totamt"
            set rec(batch_amt)  $totamt
            set rec(batch_cnt) $totcnt
            write_bt_record $fileid rec
            set chkmidt $fee_data_array(ENTITY_ID)
            set totcnt 0
            set totamt 0
            #   set trlcnt 1
        }

        set rec(institution_id) $fee_data_array(INSTITUTION_ID)

        ##Based on the inst curr cd to be set check with Broadus
        if { $cnt_type == "MC_ANF"} {
            set rec(batch_curr) "$inst_curr_cd"
        } else {
            set rec(batch_curr) "$fee_data_array(CURR_CD)"
        }
        set rec(activity_date_time_bh) $batchtime
        set rec(merchantid) "$fee_data_array(ENTITY_ID)"
        set rec(inbatchnbr) [pbchnum]
        set rec(infilenbr)  1
        set rec(batch_capture_dt) $batchtime
        set rec(sender_id) " "

        write_bh_record $fileid rec
        set chkmid $fee_data_array(ENTITY_ID)
    }

    ###### Writing Message Detail records
    set tid_idntfr "" ; #<tid_idntfr> can be needed for multiple tid option ""

    set mas_tid [get_tid $cnt_type $tid_idntfr]
    set rec(trans_id) $mas_tid

    set rec(entity_id) $fee_data_array(ENTITY_ID)
    set rec(nbr_of_items) $fee_data_array(COUNT)
    set rec(amt_original) [expr wide([expr $fee_data_array(AMOUNT) * 100])]
    set rec(external_trans_id) " "

    MASCLR::log_message "fee_data_array [array get fee_data_array]" 3

    # A switch to convert card types----------------
    switch $cnt_type {
        "VS_ISA_FEE" {
            set rec(card_scheme) "04"
            # we have two scenarios
            # the old incorrect way which was to assign the VISA_ISA_FEE to every transaction
            # unless it was a high risk MCC, then assign the VS_ISA_HI_RISK_FEE instead
            #
            # but the proper was is for everyone to get the isa fee + the IAF, and the form of IAF
            # depends on whether it's high risk
            # now to handle this in a single piece of code
            #set vs_mas_code_list [list VS_ISA_FEE VS_INT_ACQ_FEE]
            switch $fee_data_array(FEE_PKG_ID) {
                "47" {
                    # new way
                    foreach mas_code_var $vs_mas_code_list {
                        #
                        switch $mas_code_var {
                            "VS_INT_ACQ_FEE" {
                                ## high risk gets one fee, non-high risk gets the other
                                switch $fee_data_array(MCC) {
                                    5962 -
                                    5966 -
                                    5967 {
                                        set rec(mas_code) "VS_ISA_HI_RISK_FEE"
                                    }
                                    default {
                                        set rec(mas_code) "VS_INT_ACQ_FEE"
                                    }
                                }
                            }

                            "VS_ISA_FEE" {
                                ## every interregional gets the ISA fee
                                set rec(mas_code) "VS_ISA_FEE"
                            }
                        }
                        write_md_record $fileid rec

                        set totcnt [expr $totcnt + $fee_data_array(COUNT)]
                        set totamt [expr $totamt + $rec(amt_original)]

                        set ftotcnt [expr $ftotcnt + $fee_data_array(COUNT)]
                        set ftotamt [expr $ftotamt + $rec(amt_original)]
                    }
                }

                "45" -
                default {
                    # old way, one fee (high risk or normal)
                    switch $fee_data_array(MCC) {
                        5962 -
                        5966 -
                        5967 {
                            set rec(mas_code) "VS_ISA_HI_RISK_FEE"
                        }
                        default {
                            set rec(mas_code) "VS_ISA_FEE"
                        }
                    }
                    write_md_record $fileid rec

                    set totcnt [expr $totcnt + $fee_data_array(COUNT)]
                    set totamt [expr $totamt + $rec(amt_original)]

                    set ftotcnt [expr $ftotcnt + $fee_data_array(COUNT)]
                    set ftotamt [expr $ftotamt + $rec(amt_original)]
                }
            }
        }

        "MC_BORDER" {
            set rec(card_scheme) "05"
            foreach mas_code_var $mc_mas_code_list {
                set rec(mas_code) $mas_code_var
                write_md_record $fileid rec

                set totcnt [expr $totcnt + $fee_data_array(COUNT)]
                set totamt [expr $totamt + $rec(amt_original)]

                set ftotcnt [expr $ftotcnt + $fee_data_array(COUNT)]
                set ftotamt [expr $ftotamt + $rec(amt_original)]
            }
        }

        "MC_GE_1K" {
            set rec(card_scheme) "05"
            set mas_code_var $fee_data_array(MAS_CODE)
            set rec(mas_code) $mas_code_var
            write_md_record $fileid rec

            set totcnt [expr $totcnt + $fee_data_array(COUNT)]
            set totamt [expr $totamt + $rec(amt_original)]

            set ftotcnt [expr $ftotcnt + $fee_data_array(COUNT)]
            set ftotamt [expr $ftotamt + $rec(amt_original)]
        }

        "DS_INTERNATIONAL" {

            set rec(card_scheme) "08"
            foreach mas_code_var $ds_mas_code_list {

                ## the international service charge is assessed only when card is
                ## not issued in the US but the acquirer is in the US

                if { $mas_code_var == "DS_INTL_SERV" && $fee_data_array(ACQ_CNTRY_CODE_A2) == "US" } {
                    set rec(mas_code) $mas_code_var
                    write_md_record $fileid rec

                    set totcnt [expr $totcnt + $fee_data_array(COUNT)]
                    set totamt [expr $totamt + $rec(amt_original)]

                    set ftotcnt [expr $ftotcnt + $fee_data_array(COUNT)]
                    set ftotamt [expr $ftotamt + $rec(amt_original)]

                } elseif { $mas_code_var == "DS_INTL_PROC" } {

                    ## the intl processing fee is assessed if card issuer differs
                    ## from the merchant location

                    set rec(mas_code) $mas_code_var
                    write_md_record $fileid rec

                    set totcnt [expr $totcnt + $fee_data_array(COUNT)]
                    set totamt [expr $totamt + $rec(amt_original)]

                    set ftotcnt [expr $ftotcnt + $fee_data_array(COUNT)]
                    set ftotamt [expr $ftotamt + $rec(amt_original)]
                }
            }
        }

        "CANADA_TAX" {
            set rec(card_scheme) "00"
            set rec(mas_code) $fee_data_array(MAS_CODE)
            write_md_record $fileid rec

            set totcnt [expr $totcnt + $fee_data_array(COUNT)]
            set totamt [expr $totamt + $rec(amt_original)]

            set ftotcnt [expr $ftotcnt + $fee_data_array(COUNT)]
            set ftotamt [expr $ftotamt + $rec(amt_original)]
        }
        "PIN_DB_SPNSR" {
            set rec(card_scheme) "02"
            set mas_code_var "DBT_ASSMT_SPONSORSHIP"
            set rec(mas_code) $mas_code_var
            write_md_record $fileid rec

            set totcnt [expr $totcnt + $fee_data_array(COUNT)]
            set totamt [expr $totamt + $rec(amt_original)]

            set ftotcnt [expr $ftotcnt + $fee_data_array(COUNT)]
            set ftotamt [expr $ftotamt + $rec(amt_original)]
        }
        "MC_ANF" {
            set rec(card_scheme) "05"
            set mas_code_var "MC_ANNUAL_NW"
            set rec(mas_code) $mas_code_var
            write_md_record $fileid rec

            set totcnt [expr $totcnt + $fee_data_array(COUNT)]
            set totamt [expr $totamt + $rec(amt_original)]

            set ftotcnt [expr $ftotcnt + $fee_data_array(COUNT)]
            set ftotamt [expr $ftotamt + $rec(amt_original)]
        }
        "MNTHLY_SETL" {
            set rec(card_scheme) "00"
            set mas_code_var $fee_data_array(MAS_CODE)
            set rec(mas_code) $mas_code_var
            write_md_record $fileid rec

            set totcnt [expr $totcnt + $fee_data_array(COUNT)]
            set totamt [expr $totamt + $rec(amt_original)]

            set ftotcnt [expr $ftotcnt + $fee_data_array(COUNT)]
            set ftotamt [expr $ftotamt + $rec(amt_original)]
        }
        default  {set c_sch "00"}

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
#catch {exec  mv $outfile $env(PWD)/INST_$inst_id/MAS_FILES/.} result
#catch {exec  mv $outfile $env(PWD)/MAS_FILES/.} result
if {$MODE == "TEST"} {
    catch {exec  mv $outfile $env(PWD)/ON_HOLD_FILES/.} result
} elseif {$MODE == "PROD"} {
    catch {exec  mv $outfile $env(PWD)/MAS_FILES/.} result
}

puts "============================== END OF FILE =============================="
     #============================== END PROGRAM ==============================
