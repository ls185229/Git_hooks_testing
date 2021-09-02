#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: acquirer_support_fees.tcl 2377 2013-07-30 20:55:24Z bjones $

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

# VS_ISA_FEE MC_BORDER ZZACQSUPPORTFEE
#
#proc get_sql {f_type } {
#    global cmonth
#    global cyear
#    global clr1dblink
#    global inst_id
#    # query needs currency code, entity ID, mas_code,mid ??, count, amount,
#    # returning amount as a decimal number with decimal separator
#    switch $f_type {
#        "VS_ISA_FEE" {
#            set nm "select mas_trans_log.institution_id,
#                mas_trans_log.entity_id,
#                institution.INST_CURR_CODE,
#                count(in_draft_main.trans_seq_nbr) as \"COUNT\",
#                to_char(sum(in_draft_main.amt_trans)/100, '999999.00') as \"AMOUNT\"
#            from masclr.in_draft_main$clr1dblink,
#                masclr.trans_enrichment$clr1dblink,
#                masclr.mas_trans_log$clr1dblink,
#                masclr.institution$clr1dblink
#            where in_draft_main.trans_seq_nbr = trans_enrichment.trans_seq_nbr AND
#                mas_trans_log.trans_ref_data = in_draft_main.arn AND
#                to_char(mas_trans_log.activity_date_time, 'MM') = $cmonth AND
#                to_char(mas_trans_log.activity_date_time, 'YYYY') = $cyear AND
#                mas_trans_log.card_scheme = '04' AND
#                mas_trans_log.tid = '010003005101' AND
#                mas_trans_log.trans_sub_seq = '0' AND
#                trans_enrichment.iss_cntry_code_a2 <> 'US' AND
#                in_draft_main.src_inst_id in ('$inst_id') and
#                institution.institution_id = mas_trans_log.institution_id
#            group by
#                mas_trans_log.institution_id,
#                mas_trans_log.entity_id,
#                institution.INST_CURR_CODE
#            order by
#                mas_trans_log.entity_id"
#        }
#        "MC_BORDER" {
#            set nm "select mas_trans_log.institution_id,
#                    mas_trans_log.entity_id,
#                    institution.INST_CURR_CODE,
#                    count(mas_trans_log.trans_seq_nbr) as \"COUNT\",
#                    sum(mas_trans_log.amt_original) as \"AMOUNT\"
#             from masclr.trans_enrichment$clr1dblink,
#                  masclr.in_draft_main$clr1dblink,
#                  masclr.mas_trans_log$clr1dblink,
#                  masclr.institution$clr1dblink
#             where to_char(in_draft_main.activity_dt, 'MM') = $cmonth AND
#                   to_char(in_draft_main.activity_dt, 'YYYY') = $cyear AND
#                   in_draft_main.trans_seq_nbr = trans_enrichment.trans_seq_nbr AND
#                   in_draft_main.arn = mas_trans_log.trans_ref_data AND
#                   trans_enrichment.tga <> '3' AND
#                   in_draft_main.card_scheme = '05' AND
#                   mas_trans_log.trans_sub_seq = '0' AND
#                   in_draft_main.tid in ('010103005101', '010103005301')
#                   and mas_trans_log.institution_id in ('$inst_id')
#                   and institution.institution_id = mas_trans_log.institution_id
#             group by
#                    mas_trans_log.institution_id,
#                    mas_trans_log.entity_id,
#                    institution.INST_CURR_CODE
#             order by
#                      mas_trans_log.entity_id"
#        }
#        "ZZACQSUPPORTFEE" {
#            # get from a file, not the database
#            set nm -1
#        }
#        default {puts stdout "Incorrect Count File Type: $f_type\n Valid Values are:
#                                            1) VS_ISA_FEE         -- Visa ISA fees
#                                            2) MC_BORDER          -- MasterCard Interregional/Cross-border fees
#                                            3) ZZACQSUPPORTFEE    -- Acquirer support fee
#
#                                     "
#        exit 1
#        }
#
#    }
#    #puts $nm
#    return $nm
#}


# internal routine that returns the last valid day of a given month and year
proc lastDay {month year} {
    set days [clock format [clock scan "+1 month -1 day" \
                  -base [clock scan "$month/01/$year"]] -format %d]
    return $days
}


proc get_fees_from_file {f_type} {

    switch $f_type {
        "VS_ISA_FEE"          {return}
        "MC_BORDER"           {return}
        "ZZACQSUPPORTFEE"     {
        }
    }


}



# VS_ISA_FEE MC_BORDER ZZACQSUPPORTFEE
proc get_fname {f_type} {

    switch $f_type {
        "VS_ISA_FEE"          {set nm "VISAISAF"}
        "MC_BORDER"           {set nm "MCBORDER"}
        "ZZACQSUPPORTFEE"     {set nm "ACQSUPPO"}
    }

    return $nm

}

proc get_tid {f_type tid_idntfr} {

    switch $f_type {
        "VS_ISA_FEE"          {set nm "010070020001"}
        "MC_BORDER"           {set nm "010070020001"}
        "ZZACQSUPPORTFEE"     {set nm "010070020001"}
    }

    return $nm

}


# called first
proc set_args {} {

    global  arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year argc argv
    global  box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c
    global  msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m
    global  mbody_l sysinfo cfg_pth log_pth arch_pth ms_fl_pth hold_pth upld_pth
    global  stop_pth tmp_pth currdate jdate sdate adate rightnow cmonth cdate
    global  cyear begindatetime enddatetime begintime endtime cutoff dbhost
    global  dbhost1 tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw
    global  tblnm_bf tblnm_bt tblnm_mf tblnm_e2a tblnm_tr

    set inst_id ""
    set cnt_type ""
    set run_mnth [clock format [clock scan seconds] -format %m]
    set run_year [clock format [clock scan seconds] -format %m]
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
                "

    } elseif {$argc < 2} {
           puts stdout [show_direction]
           exit 1
    }

    set cfg_pth "./CFG"
    set log_pth "./LOG"
    set arch_pth "./INST_$inst_id/ARCHIVE"
    set ms_fl_pth "./INST_$inst_id/MAS_FILES"
    set hold_pth "./INST_$inst_id/HOLD_FILES"
    set upld_pth "./INST_$inst_id/UPLOAD"
    set stop_pth "./INST_$inst_id/STOP"
    set tmp_pth "./INST_$inst_id/TEMP"

}



proc show_direction {} {

    set run_instruction "Please follow below instructions to run this code -->
			Code runs with minimum 2 to maximum 5 arguments.
			Arguments parameters:
				1) -i<Institution Id>	(Required Eg: 101, 105, 107 ... etc.)
				2) -c<Count File Type>	(Required Eg: VAU, AUTH, ACH ... etc.)
				3) -m<Month>		(Optional Eg: 1-12 OR JAN-DEC <> Defualt Value: Current Month)
				4) -y<Year>		(Optional Eg: 2008, 2007 <> Format: YYYY <> Default Value: Current Year)
				5) -t<Cutoff Time>	(Optional Eg: 020000, 143000 <> Format: HH24MISS <> Default Value: 000000)
			Example:
				mas_txn_count_sum_file_v13.tcl -i101 -cAUTH -m9
				mas_txn_count_sum_file_v13.tcl -i107 -cVAU -mJAN -y2007
			Note:
				You can not run this code for future Months. It will autometically set it to Above Defualt Values.
		   "
    return $run_instruction
}

proc get_cfg {inst_id cfg_pth} {
	global arr_cfg
	set cfg_file "$inst_id.inst.cfg"
	set in_cfg [open $cfg_pth/$cfg_file r]
	set cur_line  [split [set orig_line [gets $in_cfg] ] ,]
	while {$cur_line != ""} {
		if {[string toupper [string trim [lindex $cur_line 0]]] != ""} {
			set arr_cfg([string toupper [string trim [lindex $cur_line 0]]]) [string trim [lindex $cur_line 1]]
		}
	puts "arr_cfg([string toupper [string trim [lindex $cur_line 0]]]) [string trim [lindex $cur_line 1]]"
	set cur_line  [split [set orig_line [gets $in_cfg] ] ,]
	}
    return arr_cfg
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
    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global cfg_pth log_pth arch_pth ms_fl_pth hold_pth upld_pth stop_pth tmp_pth
    global currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime endtime cutoff batchtime
    global dbhost dbhost1 tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a tblnm_tr


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
    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global cfg_pth log_pth arch_pth ms_fl_pth hold_pth upld_pth stop_pth tmp_pth
    global currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime endtime cutoff batchtime
    global dbhost dbhost1 tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a  tblnm_tr


    #Opening connection to db--------------------------------------------------
    #if {[catch {set db_logon_handle [oralogon teihost/quikdraw@$authdb]} result]} {
    #        puts "$authdb efund boarding failed to run"
    #	set mbody "$authdb efund boarding failed to run"
    #	exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
    #        exit 1
    #}

    if {[catch {set db_login_handle [oralogon masclr/masclr@$clrdb]} result]} {
            puts "$clrdb efund boarding failed to run"
            set mbody "$clrdb efund boarding failed to run"
            exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
            exit 1
    }

}

proc open_cursor_masclr {cursr} {
    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year  db_login_handle
    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global cfg_pth log_pth arch_pth ms_fl_pth hold_pth upld_pth stop_pth tmp_pth
    global currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime endtime cutoff batchtime
    global dbhost dbhost1 tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a tblnm_tr



    global $cursr
	set $cursr [oraopen $db_login_handle]
}

#proc open_cursor_teihost {cursr} {
#  global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year  db_login_handle
#  global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
#  global cfg_pth log_pth arch_pth ms_fl_pth hold_pth upld_pth stop_pth tmp_pth
#  global currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime endtime cutoff batchtime
#  global dbhost dbhost1 tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a  tblnm_tr
#
#
#
#        global $cursr
#        set $cursr [oraopen $db_logon_handle]
#
#}


proc get_outfile {f_seq} {

  global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year
  global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
  global cfg_pth log_pth arch_pth ms_fl_pth hold_pth upld_pth stop_pth tmp_pth env
  global currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime endtime cutoff batchtime
  global dbhost dbhost1 tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a  tblnm_tr



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
	if {[set ex [file exists $env(PWD)/$outfile]] == 1 || [set ux [file exists $env(PWD)/MAS_FILES/$outfile]] == 1} {
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
        set a [string range $cur_pos [expr $cur_pos + $flength - 1] ]
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


#Below all Procedures write_??_record to assign values to the tcr fields and call write_tcr to constuct the tcr records

proc write_fh_record {fd aname} {
    global tcr
    upvar $aname a
	set rec(tcr) "FH"
	set rec(fhtrans_type) "FH"
	set rec(file_type) "01"
	set rec(file_date_time) $a(file_date_time)
	set rec(activity_source) $a(activity_source)
	set rec(activity_job_name) $a(activity_job_name)
	set rec(suspend_level) "B"
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

proc get_curr_cd {f_type midlist} {

    #--GLOBAL LIST
    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year auth_get clr_get clr_get1 clr_get2
    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global cfg_pth log_pth arch_pth ms_fl_pth hold_pth upld_pth stop_pth tmp_pth
    global currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime endtime cutoff batchtime
    global dbhost dbhost1 tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a tblnm_tr



    ###### Loading Visa/MC id as exntity_id into an array with index of MID from the Database
    if {$f_type == "VAU"} {
        set get_ent "select mid, visa_id, mastercard_id, currency_code from $tblnm_mr where mid in (select mid from $tblnm_tr where tid in ($midlist))"
        orasql $auth_get $get_ent

        while {[set x [orafetch $auth_get -dataarray  ent -indexbyname]] == 0} {
            set amid $ent(MID)
            set vs_id $ent(VISA_ID)
            set mc_id $ent(MASTERCARD_ID)
            set cur_cd $ent(CURRENCY_CODE)
            uplevel "set entity_id($amid) $vs_id "
            uplevel "set curr_cd($amid) $ent(CURRENCY_CODE)"

        }

    } else {
        set get_ent "select mid, entity_id from $tblnm_e2a where mid in ($midlist) and status in ('A', 'H')"
        orasql $clr_get2 $get_ent

        while {[set x [orafetch $clr_get2 -dataarray ent -indexbyname]] == 0} {
            set amid $ent(MID)
            set entt_id $ent(ENTITY_ID)
            uplevel "set entity_id($amid) $entt_id"

        }
        set get_ent "select mid, currency_code from $tblnm_mr where mid in ($midlist)"
        orasql $auth_get $get_ent
        while {[set x [orafetch $auth_get -dataarray curr -indexbyname]] == 0} {
            set amid $curr(MID)
            set cur_cd $curr(CURRENCY_CODE)
            uplevel "set curr_cd($amid) $curr(CURRENCY_CODE)"

        }
    }

}



#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#--GLOBAL LIST
#global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year
#global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
#global cfg_pth log_pth arch_pth ms_fl_pth hold_pth upld_pth stop_pth tmp_pth
#global currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime endtime cutoff batchtime
#global dbhost dbhost1 tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a tblnm_tr
#--PROC LIST
#proc get_fname {f_type}
#proc set_args {}
#proc show_direction {}
#proc get_cfg {inst_id cfg_pth}
#proc set_dir_paths {inst_id pth_varname gbl_pth_ext}
#proc get_run_mnth {rmnth}
#proc get_run_year {ryear}
#proc set_run_dates {}

#proc connect_to_dbs {}
#proc open_cursor_masclr {cursr}
#proc open_cursor_teihost {cursr}
#proc get_outfile {}
#proc write_tcr {aname}
#proc read_tcr {inrec aname }
#proc print_tcr {fd aname}
#proc write_fh_record {fd aname}
#proc write_bh_record {fd aname}
#proc write_md_record {fd aname}
#proc write_bt_record {fd aname}
#proc write_ft_record {fd aname}
#proc pbchnum {}

#proc get_fname {f_type tid_idntfr}
#proc get_curr_cd {f_type midlist}
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


#######################################################################################################################

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

#######################################################################################################################

#GLOBALS

global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year db_login_handle
global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
global cfg_pth log_pth arch_pth ms_fl_pth hold_pth upld_pth stop_pth tmp_pth
global currdate jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime endtime cutoff batchtime
global dbhost dbhost1 tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a tblnm_tr

#TABLE NAMES-----------------------------------------------------

set dbhost "teihost"
set dbhost1 "masclr"
if {$env(SYS_BOX) == "QA"} {
    set p1dblink "@transp4_teihost"
    set clr1dblink "@masclr_trnclr1"
} else {
    set p1dblink ""
    set clr1dblink ""
}
set tblnm_sc "$dbhost1.ALL_SEQ_CTRL_TBL$clr1dblink"
set tblnm_mfcg "$dbhost1.MAS_FILE_CODE_GRP$clr1dblink"
set tblnm_mf "$dbhost1.MERCHANT_FLAG"
set tblnm_e2a "$dbhost1.entity_to_auth$clr1dblink"

set currdate [clock format [clock seconds] -format "%Y%m%d"]
set sdate [clock format [ clock scan "$currdate" ] -format "%Y%m%d"]
set adate [clock format [ clock scan "$currdate -1 day" ] -format "%Y%m%d"]
set lydate [clock format [ clock scan "$currdate" ] -format "%m"]
set rightnow [clock seconds]
set cmonth [clock format $rightnow -format "%m"]
set cdate [clock format $rightnow -format "%d"]
set cyear [clock format $rightnow -format "%Y"]

set rightnow [clock format $rightnow -format "%Y%m%d%H%M%S"]
set rightnow "$cyear$cmonth[lastDay $cmonth $cyear]000000"
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
get_cfg $inst_id $cfg_pth
set_run_dates

set pth ""
set fn [get_fname $cnt_type]
set fchk $pth$inst_id$dot$fn$dot
catch {exec find /clearing/filemgr/INST_$inst_id/MAS_FILES -name "$fchk*"} result

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
#open_cursor_teihost auth_get
#open_cursor_teihost auth_get1

#Pulling Mas codes and building an array for later use.
#
#set s "select * from $tblnm_mfcg order by CARD_SCHEME, REQUEST_TYPE, ACTION"
#
#orasql $m_code_sql $s
#
#while {[set y [orafetch $m_code_sql -datavariable mscd]] == 0} {
#	set ms_cd [lindex $mscd 0]
#	set ind_cs [lindex $mscd 1]
#	set ind_rt [lindex $mscd 2]
#	set ind_ac [lindex $mscd 3]
#	set mas_cd($ind_cs-$ind_rt-$ind_ac) $ms_cd
#}


########################################################################################################################
### MAIN ###############################################################################################################
########################################################################################################################

#set midlist ""
set y 0

#if {$cnt_type == "AUTH"} {
#
###### Getting mid list from entity_to_auth.
#
#
#
##set get_ent_mid "select mid from $tblnm_e2a where institution_id = '$arr_cfg(INST_ID)' and FILE_GROUP_ID = '$arr_cfg(SETTLE_SHORTNAME)' and STATUS = 'A' and mas_file_flag = '[get_mff $cnt_type]'"
#
##orasql $clr_get1 $get_ent_mid
#
#	set mcnt 0
#	set mlistcnt 0
#	set lmidlist [list midlist$mlistcnt]
#	set lname "midlist$mlistcnt"
#	set $lname ""
#
#	while {[set x1 [orafetch $clr_get1 -dataarray e2a -indexbyname]] == 0} {
#	       if {$mcnt == 0} {
#		       append $lname "'$e2a(MID)'"
#		       set mcnt [expr $mcnt + 1]
#	       } else {
#		       append $lname ",'$e2a(MID)'"
#		       set mcnt [expr $mcnt + 1]
#	       }
#	       if {$mcnt > 999} {
#			#puts "$lname"
#	                set mlistcnt [expr $mlistcnt + 1]
#			set lname "midlist$mlistcnt"
#	                lappend lmidlist $lname
#			set mcnt 0
#	       }
#	}
#
#     foreach midlist $lmidlist {
#	if {[set $midlist] == ""} {
#        	puts "No merchants found with institution_id = '$arr_cfg(INST_ID)' and FILE_GROUP_ID = '$arr_cfg(SETTLE_SHORTNAME)' and STATUS = 'A' and mas_file_flag = '[get_mff $cnt_type]'"
#        	exit 0
#	}
#     }
#
#} else {
#
#	set get_ent_mid "select mid, flag_use from $tblnm_mf where institution_id = '$arr_cfg(INST_ID)' and FLAG_TYPE = '[get_flag_val $cnt_type]' and STATUS = 'A' and FLAG_TYPE_VALUE = 'Y' and mid in (select mid from $tblnm_e2a where institution_id = '$arr_cfg(INST_ID)' and STATUS = 'A' and FILE_GROUP_ID = '$arr_cfg(SETTLE_SHORTNAME)')"
#        #puts $get_ent_mid
#
#	orasql $clr_get1 $get_ent_mid
#
#	set mcnt 0
#	set mlistcnt 0
#	set lmidlist [list midlist$mlistcnt]
# 	set lname "midlist$mlistcnt"
# 	set $lname ""
#	while {[set x1 [orafetch $clr_get1 -dataarray e2a -indexbyname]] == 0} {
#	    if {$e2a(FLAG_USE) == ""} {
#	       if {$mcnt == 0} {
#	       append $lname "'$e2a(MID)'"
#	       set mcnt [expr $mcnt + 1]
#            } else {
#	       append $lname ",'$e2a(MID)'"
#	       set mcnt [expr $mcnt + 1]
#            }
#	    }
#        	if {$mcnt > 999} {
#	                #puts "$lname"
#	                set mlistcnt [expr $mlistcnt + 1]
#	                set lname "midlist$mlistcnt"
#	                lappend lmidlist $lname
#	                set mcnt 0
#        	}
#       }
#    foreach midlist $lmidlist {
#        if {[set $midlist] == ""} {
#                puts "No merchants found with institution_id = '$arr_cfg(INST_ID)' and FLAG_TYPE = '[get_flag_val $cnt_type]' and STATUS = 'A' and FLAG_TYPE_VALUE = 'Y'"
#                exit 0
#        }
#    }
#    if {$cnt_type == "VAU"} {
#	set i2 0
#	foreach midlist $lmidlist {
#		set get_tids "select tid from $tblnm_tr where mid in ([set $midlist])"
#		#puts $get_tids
#		catch {orasql $auth_get1 $get_tids} result
#			while {[set q [orafetch $auth_get1 -dataarray tid1 -indexbyname]] == 0} {
#				        lappend tid_list "$tid1(TID)"
#				        set i2 [expr $i2 + 1]
#			}
#	}
#        set mcnt 0
#        set mlistcnt 0
#        set lmidlist [list midlist$mlistcnt]
#        set lname "midlist$mlistcnt"
#        set $lname ""
#	foreach ltid $tid_list {
#            if {$mcnt == 0} {
#               append $lname "'$ltid'"
#               set mcnt [expr $mcnt + 1]
#            } else {
#               append $lname ",'$ltid'"
#               set mcnt [expr $mcnt + 1]
#            }
#                if {$mcnt > 999} {
#                        #puts "$lname"
#                        set mlistcnt [expr $mlistcnt + 1]
#                        set lname "midlist$mlistcnt"
#                        lappend lmidlist $lname
#                        set mcnt 0
#                }
#	}
#    }
#
#    foreach midlist $lmidlist {
#	if {[set $midlist] == ""} {
#	        puts "No merchants found with institution_id = '$arr_cfg(INST_ID)' and FLAG_TYPE = '[get_flag_val $cnt_type]' and STATUS = 'A' and FLAG_TYPE_VALUE = 'Y'"
#	        exit 0
#	}
#    }
#
#}

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

#set get_info "[get_sql $cnt_type ]"
#if {$get_info == -1 } {
    # get the information from an input file instead

#}
#puts $get_info

#orasql $clr_get $get_info

###### Writing File Header into the Mas file


###### Declaring Variables and initializing

set chkmid " "
set chkmidt " "
set totcnt 0
set totamt 0
set ftotcnt 0
set ftotamt 0
set trlcnt 0
###### While Loop for to fetch records gathered by Sql Select get_info
# query needs currency code, entity ID, mas_code, count, amount,

set input_file_name "$inst_id-acq_support_fee_file.csv"
# format of entity_id, count, amount

# this will need to change if we start supporting international
set curr_code_var "840"
set mas_code_var "ZZACQSUPPORTFEE"

if {[catch {open $input_file_name {RDONLY}} input_file_id]} {
    puts "Cannot open file $input_file_name"
    log_message $GLOBALS(LOG_FILE_HANDLE) "Cannot open file $input_file_name"
    exit 1
}
# this one's a loop through lines in a text file, not rows in a query
set cur_line  [split [set orig_line [gets $input_file_id] ] "," ]

while {$cur_line != ""} {

    set entity_id_var [string map {\" ""} [string trim [lindex $cur_line 0]]]
    set count_var [string map {\" ""} [string trim [lindex $cur_line 1]]]
    set amount_var [string map {\" ""} [string trim [lindex $cur_line 2]]]


    ###### Writing Batch Header Or Batch Trailer

    if {$chkmid != $entity_id_var} {
        set trlcnt 1
        if {$chkmid != " "} {

            #	puts "position 1: totamt = $totamt"
            set rec(batch_amt) [expr wide(round([expr $totamt * 100]))]
            set rec(batch_add_amt2) $rec(batch_amt)
            set rec(batch_cnt) $totcnt
            write_bt_record $fileid rec
            set chkmidt $entity_id_var
            set totcnt 0
            set totamt 0
            #	set trlcnt 1
        }

        set rec(batch_curr) "$curr_code_var"
        #set rec(activity_date_time_bh) $batchtime
        set rec(activity_date_time_bh) $rightnow
        set rec(merchantid) "$entity_id_var"
        set rec(inbatchnbr) [pbchnum]
        set rec(infilenbr)  1
        set rec(batch_capture_dt) $batchtime
        set rec(sender_id) " "

        write_bh_record $fileid rec
        set chkmid $entity_id_var
    }

    ###### Writing Massage Detail records
    set tid_idntfr "" ; #<tid_idntfr> can be needed for multiple tid option""


    set mas_tid "010070020001"
    set rec(trans_id) $mas_tid


    set rec(entity_id) $entity_id_var
    #A switch to convert card types----------------
    set c_sch "00"

    set rec(card_scheme) $c_sch


    switch $cnt_type {
        default {set mas_code_var $cnt_type}
    }
    set rec(mas_code) $mas_code_var

    set rec(nbr_of_items) $count_var
    set rec(amt_original) [expr wide(round([expr $amount_var * 100]))]
    set rec(add_amt2) [expr wide(round([expr $amount_var * 100]))]
    set rec(external_trans_id) " "
    write_md_record $fileid rec

    set totcnt [expr $totcnt + $count_var]
    set totamt [expr $totamt + $amount_var]

    set ftotcnt [expr $ftotcnt + $count_var]
    set ftotamt [expr $ftotamt + $amount_var]

    set cur_line  [split [set orig_line [gets $input_file_id] ] "," ]
}

###### Writing last batch Trailer Record
if {$trlcnt == 1} {
    set rec(batch_amt) [expr wide(round([expr $totamt * 100]))]
    set rec(batch_add_amt2) [expr wide(round([expr $totamt * 100]))]
    set rec(batch_cnt) $totcnt
    write_bt_record $fileid rec
    set totcnt 0
    set totamt 0
}
###### Writing File Trailer Record
set rec(file_amt) [expr wide(round([expr $ftotamt * 100]))]
set rec(file_add_amt2) [expr wide(round([expr $ftotamt * 100]))]
set rec(file_cnt) $ftotcnt

write_ft_record $fileid rec

###### Closing Output file

close $fileid
#catch {exec  mv $outfile $env(PWD)/INST_$inst_id/MAS_FILES/.} result

puts "==============================================END OF FILE=============================================================="
#===============================================END PROGRAM==================================================================

