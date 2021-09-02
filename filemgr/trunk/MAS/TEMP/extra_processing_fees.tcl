#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: extra_processing_fees.tcl 3016 2015-06-25 19:27:17Z jkruse $
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


package require Oratcl 4.3
package provide random 1.0

source $env(MASCLR_LIB)/masclr_tcl_lib

global MODE
set MODE "PROD"


# VS_ISA_FEE MC_BORDER ZZACQSUPPORTFEE

proc get_sql {f_type } {
    global cmonth
    global cyear
    global inst_id
    # query needs currency code, entity ID, mas_code,mid ??, count, amount,
    # returning amount as a decimal number with decimal separator
    switch $f_type {
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
              AND idm.mas_code                    IN ('08INTLBASE','08INTLELEC')
            GROUP BY
                ifl.institution_id ,
                idm.merch_id ,
                idm.TRANS_CCD ,
                te.acq_cntry_code_a2
            ORDER BY
                idm.merch_id "
        }
        "ZZACQSUPPORTFEE" {
        # get from a file, not the database
            set nm -1
        }
        default {puts stdout "Incorrect Count File Type: $f_type\n Valid Values are:
                 1) VS_ISA_FEE         -- Visa ISA fees
                 2) MC_BORDER          -- MasterCard Interregional/Cross-border fees
                 3) DS_INTERNATIONAL   -- Discover International processing/suppart fee
                 4) ZZACQSUPPORTFEE    -- Acquirer support fee

                 "
                 exit 1
        }

    }
    #puts $nm
    return $nm
}





# VS_ISA_FEE MC_BORDER ZZACQSUPPORTFEE
proc get_fname {f_type} {

    switch $f_type {
        "VS_ISA_FEE"          {set nm "VISAISAF"}
        "MC_BORDER"           {set nm "MCBORDER"}
        "DS_INTERNATIONAL"    {set nm "DSBORDER"}
        "ZZACQSUPPORTFEE"     {set nm "ACQSUPPO"}
    }

    return $nm

}

proc get_tid {f_type tid_idntfr} {

    switch $f_type {
        "VS_ISA_FEE"          {set nm "010070020001"}
        "MC_BORDER"           {set nm "010070020001"}
        "DS_INTERNATIONAL"    {set nm "010070020001"}
        "ZZACQSUPPORTFEE"     {set nm "010070020001"}
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

    set cfg_pth "./CFG"
    set log_pth "./LOGS"
    set arch_pth "./INST_$inst_id/ARCHIVE"
    set ms_fl_pth "./INST_$inst_id/MAS_FILES"
    set hold_pth "./INST_$inst_id/HOLD_FILES"
    set upld_pth "./INST_$inst_id/UPLOAD"
    set stop_pth "./INST_$inst_id/STOP"
    set tmp_pth "./INST_$inst_id/TEMP"

}



proc show_direction {} {
    # TODO - show direction is deprecaded and should no longer be used

    set run_instruction "Please follow below instructions to run this code -->
    Code runs with minimum 2 to maximum 5 arguments.
    Arguments parameters:
    1) -i<Institution Id>	(Required Eg: 101, 105, 107 ... etc.)
    2) -c<Count File Type>	(Required Eg: VAU, AUTH, ACH ... etc.)
    3) -m<Month>		(Optional Eg: 1-12 OR JAN-DEC <> Defualt Value: Current Month)
    4) -y<Year>		    (Optional Eg: 2008, 2007 <> Format: YYYY <> Default Value: Current Year)
    5) -t<Cutoff Time>	(Optional Eg: 020000, 143000 <> Format: HH24MISS <> Default Value: 000000)
    6) -v               (Optional increase verbosity, i.e., debug level)
    7) -T               (Optional set the MODE to TEST)
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
        "cfg_pth"	{set pth "$gbl_pth_ext/CFG"}
        "log_pth"	{set pth "$gbl_pth_ext/LOGS"}
        "arch_pth"	{set pth "$gbl_pth_ext/ARCHIVE"}
        "ms_fl_pth"	{set pth "$gbl_pth_ext/MAS_FILES"}
        "hold_pth"	{set pth "$gbl_pth_ext/HOLD_FILES"}
        "upld_pth"	{set pth "$gbl_pth_ext/UPLOAD"}
        "stop_pth"	{set pth "$gbl_pth_ext/STOP"}
        "tmp_pth"	{set pth "$gbl_pth_ext/TEMP"}
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
            "1" {set rmnth 1}
            "2" {set rmnth 2}
            "3" {set rmnth 3}
            "4" {set rmnth 4}
            "5" {set rmnth 5}
            "6" {set rmnth 6}
            "7" {set rmnth 7}
            "8" {set rmnth 8}
            "9" {set rmnth 9}
            default {set rmnth 0}
        }
    } else {
        set rmnth [string range $rmnth 0 2]
        switch $rmnth {
            "JAN" {set rmnth 1}
            "FEB" {set rmnth 2}
            "MER" {set rmnth 3}
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


    if {$argc == 5} {
        set yeartomnth [expr [get_run_year $run_year] * 12]
        set mnth [expr [get_run_mnth $run_mnth] + $yeartomnth]
    } elseif {$argc == 4} {
        set yeartomnth [expr [get_run_year $run_year] * 12]
        set mnth [expr [get_run_mnth $run_mnth] + $yeartomnth]
    } elseif {$argc == 3} {
        set mnth [get_run_mnth $run_mnth]
    } elseif {$argc == 2} {
        set mnth 0
    } else {
        set mnth 0
    }

    set begindatetime "to_char(last_day(add_months(SYSDATE, -[expr 1 + $mnth])), 'YYYYMMDD') || '$cutoff'"
    set enddatetime "to_char(last_day(add_months(SYSDATE, -[expr 0 + $mnth])), 'YYYYMMDD') || '$cutoff'"
    append batchtime $sdate $cutoff
    puts "Transaction count between $begindatetime :: $enddatetime :: $batchtime"
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
        set a [string range $fname $cur_pos [expr $cur_pos + $flength - 1] ]
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


#Below all Procedures write_??_record to assign values to the tcr fields and call write_tcr to constuct
#the tcr records

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
    set rec(external_trans_id) $a(external_trans_id)

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

#Defining tcr records type , lenght and description below

#Mas file Header Record

set tcr(FH) {
    fhtrans_type			 2 a {File Header Transmission Type}
    file_type			 2 a {File Type}
    file_date_time			16 x {File Date and Time}
    activity_source			16 a {Activity Source}
    activity_job_name		 8 a {Activity Job name}
    suspend_level			 1 a {Suspend Level}
}

#Mas Batch Header Record

set tcr(BH) {
    bhtrans_type			 2 a {Batch Header Transmission Type}
    batch_curr			 3 a {Currency of the batch}
    activity_date_time_bh		16 x {System date and time}
    merchantid			30 a {ID of the merchant}
    inbatchnbr			 9 n {Batch number}
    infilenbr			 9 n {File number}
    billind				 1 a {Non Activity Batch Header Fee}
    orig_batch_id			 9 a {Original Batch ID}
    orig_file_id			 9 a {Original File ID}
    ext_batch_id			25 a {External Batch ID}
    ext_file_id			25 a {External File ID}
    sender_id			25 a {Merchant ID for the batch}
    microfilm_nbr			30 a {Microfilm Locator number}
    institution_id			10 a {Institution ID}
    batch_capture_dt		16 a {Batch Capture Date and Time}
}

#Mas Batch Trailer Record

set tcr(BT) {
    bttrans_type			 2 a {Batch Trailer Transmission Type}
    batch_amt			12 n {Total Transaction Amount in a Batch}
    batch_cnt			10 n {Total Transaction count in a Batch}
    batch_add_amt1			12 n {Total additional1 amount in a Batch}
    batch_add_cnt1			10 n {Total additional1 count in a Batch}
    batch_add_amt2			12 n {Total additional2 amount in a Batch}
    batch_add_cnt2			10 n {Total additional2 count in a Batch}
}

#Mas File Trailer Record

set tcr(FT) {
    fttrans_type			 2 a {File Trailer Transmission Type}
    file_amt			12 n {Total Transaction Amount in a File}
    file_cnt			10 n {Total Transaction count in a File}
    file_add_amt1			12 n {Total additional1 amount in a File}
    file_add_cnt1			10 n {Total additional1 count in a File}
    file_add_amt2			12 n {Total additional2 amount in a File}
    file_add_cnt2			10 n {Total additional2 count in a File}
}

#Mas Massage Detail Record

set tcr(01) {
    mgtrans_type			 2 a {Message Deatail Transmission Type}
    trans_id			12 a {Unique Transmission identifier}
    entity_id			18 a {Internal entity id}
    card_scheme			 2 a {Card Scheme identifier}
    mas_code			25 a {Mas Code}
    mas_code_downgrade		25 a {Mas codes for Downgraded Transaction}
    nbr_of_items			10 n {Number of items in the transaction record}
    amt_original			12 n {Original amount of a Transaction}
    add_cnt1			10 n {Number of items included in add_amt1}
    add_amt1			12 n {Additional Amount 1}
    add_cnt2			10 n {Number of items included in add_amt2}
    add_amt2			12 n {Additional Amount 2}
    external_trans_id		25 a {The extarnal transaction id}
    trans_ref_data			23 a {Reference Data}
    suspend_reason			 2 a {The Suspend reason code}
}


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
    MASCLR::log_message "cmonth:  $cmonth" 3
    MASCLR::log_message "cyear:   $cyear" 3
    MASCLR::log_message "inst_id: $inst_id" 3
    oraparse $clr_get $get_info
    orabind $clr_get :month_var $cmonth :year_var $cyear :inst_id_var $inst_id
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

###### While Loop for to fetch records gathered by Sql Select get_info
# query needs currency code, entity ID, mas_code, count, amount,
while {[set loop [orafetch $clr_get -dataarray fee_data_array -indexbyname]] == 0} {

###### Writing Batch Header Or Batch Trailer

    if {$chkmid != $fee_data_array(ENTITY_ID)} {
        set trlcnt 1
        if {$chkmid != " "} {

        #	puts "position 1: totamt = $totamt"
            set rec(batch_amt)  $totamt
            set rec(batch_cnt) $totcnt
            write_bt_record $fileid rec
            set chkmidt $fee_data_array(ENTITY_ID)
            set totcnt 0
            set totamt 0
            #	set trlcnt 1
        }

        set rec(batch_curr) "$fee_data_array(CURR_CD)"
        set rec(activity_date_time_bh) $batchtime
        set rec(merchantid) "$fee_data_array(ENTITY_ID)"
        set rec(inbatchnbr) [pbchnum]
        set rec(infilenbr)  1
        set rec(batch_capture_dt) $batchtime
        set rec(sender_id) " "

        write_bh_record $fileid rec
        set chkmid $fee_data_array(ENTITY_ID)
    }

    ###### Writing Massage Detail records
    set tid_idntfr "" ; #<tid_idntfr> can be needed for multiple tid option""


    set mas_tid [get_tid $cnt_type $tid_idntfr]
    set rec(trans_id) $mas_tid


    set rec(entity_id) $fee_data_array(ENTITY_ID)
    set rec(nbr_of_items) $fee_data_array(COUNT)
    set rec(amt_original) [expr wide([expr $fee_data_array(AMOUNT) * 100])]
    set rec(external_trans_id) " "

    #A switch to convert card types----------------
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
        "DS_INTERNATIONAL" {
            set rec(card_scheme) "08"
            foreach mas_code_var $ds_mas_code_list {
                ## the international service charge is assessed only when card is not issued in
                ## the US but the acquirer is in the US
                if { $mas_code_var == "DS_INTL_SERV" && $fee_data_array(ACQ_CNTRY_CODE_A2) == "US" } {
                    set rec(mas_code) $mas_code_var
                    write_md_record $fileid rec

                    set totcnt [expr $totcnt + $fee_data_array(COUNT)]
                    set totamt [expr $totamt + $rec(amt_original)]

                    set ftotcnt [expr $ftotcnt + $fee_data_array(COUNT)]
                    set ftotamt [expr $ftotamt + $rec(amt_original)]


                } elseif { $mas_code_var == "DS_INTL_PROC" } {
                    ## the intl processing fee is assessed if card issuer differs from the merchant location
                    set rec(mas_code) $mas_code_var
                    write_md_record $fileid rec

                    set totcnt [expr $totcnt + $fee_data_array(COUNT)]
                    set totamt [expr $totamt + $rec(amt_original)]

                    set ftotcnt [expr $ftotcnt + $fee_data_array(COUNT)]
                    set ftotamt [expr $ftotamt + $rec(amt_original)]

                }
            }
        }
        default  {set c_sch "00"}

    }

    #        write_md_record $fileid rec

    #        set totcnt [expr $totcnt + $fee_data_array(COUNT)]
    #        set totamt [expr $totamt + $rec(amt_original)]

    #        set ftotcnt [expr $ftotcnt + $fee_data_array(COUNT)]
    #        set ftotamt [expr $ftotamt + $rec(amt_original)]


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

puts "==============================================END OF FILE============================================"
#===============================================END PROGRAM================================================

