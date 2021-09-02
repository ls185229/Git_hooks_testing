#!/usr/bin/env tclsh

# $Id: dfw_amex_daily_count_sum_file.tcl 3819 2016-07-05 16:54:54Z skumar $


package require Oratcl
package provide random 1.0

#######################################################################################################################

#Environment veriables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(CLR4_DB)
set authdb $env(TSP4_DB)

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

global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year db_login_handle db_logon_handle
global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
global cfg_pth log_pth arch_pth hold_pth upld_pth stop_pth tmp_pth
global counting_date jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime endtime cutoff batchtime
global   tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a tblnm_tr

#TABLE NAMES-----------------------------------------------------

set counting_date [clock format [clock seconds] -format "%Y%m%d"]
#set counting_date [clock format [ clock scan "$counting_date -1 day" ] -format "%Y%m%d"]
set sdate [clock format [ clock scan "$counting_date -1 day" ] -format "%Y%m%d"]
set adate [clock format [ clock scan "$counting_date -1 day" ] -format "%Y%m%d"]
set lydate [clock format [ clock scan "$counting_date" ] -format "%m"]
set rightnow [clock format [clock seconds] -format "%Y%m%d000000"]
set cmonth [clock format $rightnow -format "%m"]
set cdate [clock format $rightnow -format "%d"]
set cyear [clock format $rightnow -format "%Y"]
#set rightnow [clock format $rightnow -format "%Y%m%d%H%M%S"]
set jdate [ clock scan "$counting_date"  -base [clock seconds] ]
set jdate [clock format $jdate -format "%y%j"]
set jdate [string range $jdate 1 end]

set mas_activity_date "[set sdate]000000"
set mas_batch_date "[set sdate]000000"
set mas_file_date "[set sdate]000000"

set begintime "000000"
set endtime "000000"

set dot "."

proc get_sql {f_type midlist} {

    global counting_date jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime endtime cutoff batchtime
    global   tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a tblnm_tr

    # skipping MID RIVER-RIDGE-CAMP on auth counts because this is an ACH only that
# was put into 105.  This will eventually move to 808

    switch $f_type {
        # this is a hardcoded mess for Woot.

        "DFW_AMEX" {
            set nm "select
                         mid,
                         count(amount) as cnt,
                         sum(amount) as amt,
                         card_type,
                         request_type,
                         decode (action_code,'000','A','D') as status
                         from teihost.tranhistory where
                         mid in ($midlist)
                         and SETTLE_DATE like '$counting_date%'
                         and card_type in ('AX')
                         group by
                         mid,
                         card_type,
                         request_type,
                         decode (action_code,'000','A','D')
                         order by mid"
        }

        default {
            puts stdout "Incorrect Count File Type: $f_type\n Valid Values are:
                 1) DFW_AMEX         -- Daily DFW AMEX auth count/sum file
                 "
            exit 1
        }

    }
    puts $nm
    return $nm
}

proc get_mff {f_type} {
    switch $f_type {
        "DFW_AMEX"          {set nm "Y"}
        default {
            puts stdout "Incorrect Count File Type: $f_type\n Valid Values are:
                 1) DFW_AMEX         -- Credit Card Authorization transaction count file
                 "
            exit 1
        }

    }
    return $nm
}

proc get_flag_val {f_type} {
    switch $f_type {
        "DFW_AMEX"          {set nm "AUTHCOUNT"}
        default {
            puts stdout "Incorrect Count File Type: $f_type"
            exit 1
        }

    }

    return $nm

}

proc get_fname {f_type} {

    switch $f_type {
        "DFW_AMEX"          {set nm "DFWAMEXC"}

        default {
            puts stdout "Incorrect Count File Type: $f_type"
            exit 1
        }

    }

    return $nm

}

proc get_tid {f_type tid_idntfr} {

    switch $f_type {

        "DFW_AMEX"          {
            switch $tid_idntfr {
                "0420" {set nm "010070010021"}
                default {set nm "010070010020"}
            }


        }

        default {
            puts stdout "Incorrect Count File Type: $f_type"
            exit 1
        }

    }

    return $nm

}

proc set_args {} {

    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year argc argv
    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global cfg_pth log_pth arch_pth hold_pth upld_pth stop_pth tmp_pth
    global counting_date jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime endtime cutoff
    global   tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a tblnm_tr

    set inst_id ""
    set cnt_type ""
    set given_date ""
    # need an institution ID and count type
    # if settle date is omitted, default to current date

    if {$argc >= 2} {
        set i 0
        while {$i < $argc} {
            set pind [string range [string trim [lindex $argv $i]] 1 1]
            set pval [string range [lindex $argv $i] 2 end]
            switch $pind {
                "i" {set inst_id $pval}
                "c" {set cnt_type $pval}
                "d" {set given_date $pval}
                #default {puts stdout "$pind is an invalid parameter indicator $i\n\n[show_direction]"; exit 1}
            }
            set i [expr $i + 1]
        }
        if {$inst_id == "" || $cnt_type == ""} {
            puts stdout [show_direction]
            exit 1
        }

        puts stdout "Run Arguments:
        -i = >$inst_id<
        -c = >$cnt_type<
        -d = >$given_date<
        "
        set temp_date ""
        if { $given_date != ""} {
            if { [catch  { clock scan $given_date } failure ]} {
                error "Could not parse date $given_date: $failure"
            }
            set counting_date [clock format [clock scan $given_date] -format "%Y%m%d"]
        }

    } elseif {$argc < 2} {
        puts stdout [show_direction]
        exit 1
    }

    set cfg_pth "./CFG"
    set log_pth "./LOGS"
    set arch_pth "./INST_$inst_id/ARCHIVE"
    set hold_pth "./INST_$inst_id/HOLD_FILES"
    set upld_pth "./INST_$inst_id/UPLOAD"
    set stop_pth "./INST_$inst_id/STOP"
    set tmp_pth "./INST_$inst_id/TEMP"

}

proc show_direction {} {

    set run_instruction "Please follow below instructions to run this code -->
    Code runs with minimum 2 to maximum 5 arguments.
    Arguments parameters:
    1) -i<Institution Id>   (Required Eg: 101, 105, 107 ... etc.)
    2) -c<Count File Type>  (Required Eg: VAU, AUTH, ACH ... etc.)
    3) -d<Settle date>
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
        "cfg_pth"   {set pth "$gbl_pth_ext/CFG"}
        "log_pth"   {set pth "$gbl_pth_ext/LOGS"}
        "arch_pth"  {set pth "$gbl_pth_ext/ARCHIVE"}
        "hold_pth"  {set pth "$gbl_pth_ext/HOLD_FILES"}
        "upld_pth"  {set pth "$gbl_pth_ext/UPLOAD"}
        "stop_pth"  {set pth "$gbl_pth_ext/STOP"}
        "tmp_pth"   {set pth "$gbl_pth_ext/TEMP"}
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

#   global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year argc argv get_run_year
#   global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
#   global cfg_pth log_pth arch_pth hold_pth upld_pth stop_pth tmp_pth
#   global counting_date jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime endtime cutoff batchtime
#   global   tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a tblnm_tr
#
#   if {$argc == 5} {
#       set yeartomnth [expr [get_run_year $run_year] * 12]
#       set mnth [expr [get_run_mnth $run_mnth] + $yeartomnth]
#   } elseif {$argc == 4} {
#       set yeartomnth [expr [get_run_year $run_year] * 12]
#       set mnth [expr [get_run_mnth $run_mnth] + $yeartomnth]
#   } elseif {$argc == 3} {
#       set mnth [get_run_mnth $run_mnth]
#   } elseif {$argc == 2} {
#       set mnth 0
#   } else {
#       set mnth 0
#   }
#
#   set begindatetime "to_char(last_day(add_months(SYSDATE, -[expr 1 + $mnth])), 'YYYYMMDD') || '$cutoff'"
#   set enddatetime "to_char(last_day(add_months(SYSDATE, -[expr 0 + $mnth])), 'YYYYMMDD') || '$cutoff'"
    #set enddatetime "to_char(SYSDATE, 'YYYYMMDD') || '$cutoff'"
#   append batchtime $sdate $cutoff
#   puts "Transaction count between $begindatetime :: $enddatetime :: $batchtime"
}

#Proc for array---------------------------------------------------------

proc load_array {aname str lst} {
    upvar $aname a

    for {set i 0} {$i < [llength $str]} { incr i} {
        set a([string touppe [lindex $lst $i]]) [lindex $str $i]
    }
};# end load_array

proc connect_to_dbs {} {
    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year db_logon_handle db_login_handle
    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global cfg_pth log_pth arch_pth hold_pth upld_pth stop_pth tmp_pth
    global counting_date jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime endtime cutoff batchtime
    global   tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a  tblnm_tr
    global env

    #Opening connection to db--------------------------------------------------
    # this will normally use $env(TSP4_DB) but I am using transp1 directly for speed
# concerns on Jan 31 2010
    if {[catch {set db_logon_handle [oralogon teihost/quikdraw@$env(TSP4_DB)]} result]} {
        puts "$authdb efund boarding failed to run"
        set mbody "$authdb efund boarding failed to run"
        #   exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u"
# $mailtolist
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" clearing@jetpay.com
        exit 1
    }

    if {[catch {set db_login_handle [oralogon masclr/masclr@$env(CLR4_DB)]} result]} {
        puts "$clrdb efund boarding failed to run"
        set mbody "$clrdb efund boarding failed to run"
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        exit 1
    }

}

proc open_cursor_masclr {cursr} {
    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year db_logon_handle db_login_handle
    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global cfg_pth log_pth arch_pth hold_pth upld_pth stop_pth tmp_pth
    global counting_date jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime endtime cutoff batchtime
    global   tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a tblnm_tr

    global $cursr
    set $cursr [oraopen $db_login_handle]
}

proc open_cursor_teihost {cursr} {
    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year db_logon_handle db_login_handle
    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global cfg_pth log_pth arch_pth hold_pth upld_pth stop_pth tmp_pth
    global counting_date jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime endtime cutoff batchtime
    global   tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a  tblnm_tr

    global $cursr
    set $cursr [oraopen $db_logon_handle]

}

proc get_outfile {f_seq} {

    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year
    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global cfg_pth log_pth arch_pth hold_pth upld_pth stop_pth tmp_pth env
    global counting_date jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime endtime cutoff batchtime
    global   tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a  tblnm_tr

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

#Defining tcr records type , lenght and description below

#Mas file Header Record

set tcr(FH) {
    fhtrans_type             2 a {File Header Transmission Type}
    file_type            2 a {File Type}
    file_date_time          16 x {File Date and Time}
    activity_source         16 a {Activity Source}
    activity_job_name        8 a {Activity Job name}
    suspend_level            1 a {Suspend Level}
}

#Mas Batch Header Record

set tcr(BH) {
    bhtrans_type             2 a {Batch Header Transmission Type}
    batch_curr           3 a {Currency of the batch}
    activity_date_time_bh       16 x {System date and time}
    merchantid          30 a {ID of the merchant}
    inbatchnbr           9 n {Batch number}
    infilenbr            9 n {File number}
    billind              1 a {Non Activity Batch Header Fee}
    orig_batch_id            9 a {Original Batch ID}
    orig_file_id             9 a {Original File ID}
    ext_batch_id            25 a {External Batch ID}
    ext_file_id         25 a {External File ID}
    sender_id           25 a {Merchant ID for the batch}
    microfilm_nbr           30 a {Microfilm Locator number}
    institution_id          10 a {Institution ID}
    batch_capture_dt        16 a {Batch Capture Date and Time}
}

#Mas Batch Trailer Record

set tcr(BT) {
    bttrans_type             2 a {Batch Trailer Transmission Type}
    batch_amt           12 n {Total Transaction Amount in a Batch}
    batch_cnt           10 n {Total Transaction count in a Batch}
    batch_add_amt1          12 n {Total additional1 amount in a Batch}
    batch_add_cnt1          10 n {Total additional1 count in a Batch}
    batch_add_amt2          12 n {Total additional2 amount in a Batch}
    batch_add_cnt2          10 n {Total additional2 count in a Batch}
}

#Mas File Trailer Record

set tcr(FT) {
    fttrans_type             2 a {File Trailer Transmission Type}
    file_amt            12 n {Total Transaction Amount in a File}
    file_cnt            10 n {Total Transaction count in a File}
    file_add_amt1           12 n {Total additional1 amount in a File}
    file_add_cnt1           10 n {Total additional1 count in a File}
    file_add_amt2           12 n {Total additional2 amount in a File}
    file_add_cnt2           10 n {Total additional2 count in a File}
}

#Mas Massage Detail Record

set tcr(01) {
    mgtrans_type             2 a {Message Deatail Transmission Type}
    trans_id            12 a {Unique Transmission identifier}
    entity_id           18 a {Internal entity id}
    card_scheme          2 a {Card Scheme identifier}
    mas_code            25 a {Mas Code}
    mas_code_downgrade      25 a {Mas codes for Downgraded Transaction}
    nbr_of_items            10 n {Number of items in the transaction record}
    amt_original            12 n {Original amount of a Transaction}
    add_cnt1            10 n {Number of items included in add_amt1}
    add_amt1            12 n {Additional Amount 1}
    add_cnt2            10 n {Number of items included in add_amt2}
    add_amt2            12 n {Additional Amount 2}
    external_trans_id       25 a {The extarnal transaction id}
    trans_ref_data          23 a {Reference Data}
    suspend_reason           2 a {The Suspend reason code}
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

#Below all Procedures write_??_record to assign values to the tcr fields and call
# write_tcr to constuct the tcr records

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
    set rec(trans_ref_data) $a(trans_ref_data)
    set rec(suspend_reason) [format %-2s " "]
    set rec(external_trans_id) $25spcs

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

###### Loading Visa/MC id as exntity_id into an array with index of MID from the
# Database

proc get_curr_cd {f_type midlist} {

    #--GLOBAL LIST
    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year auth_get clr_get clr_get1 clr_get2
    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global cfg_pth log_pth arch_pth hold_pth upld_pth stop_pth tmp_pth
    global counting_date jdate sdate adate rightnow cmonth cdate cyear begindatetime enddatetime begintime endtime cutoff batchtime
    global   tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf tblnm_bt tblnm_mf tblnm_e2a tblnm_tr

    ###### Loading Visa/MC id as exntity_id into an array with index of MID from the
# Database
    if {$f_type == "VAU" || $f_type == "MBU"} {
        set get_ent "select mid, visa_id, mastercard_id, currency_code from teihost.merchant where mid in (select mid from teihost.terminal where tid in ($midlist))"
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
        set get_ent "select mid, entity_id from masclr.entity_to_auth where mid in ($midlist) and status in ('A','H') and institution_id = '$inst_id'"
        orasql $clr_get2 $get_ent

        while {[set x [orafetch $clr_get2 -dataarray ent -indexbyname]] == 0} {
            set amid $ent(MID)
            set entt_id $ent(ENTITY_ID)
            uplevel "set entity_id($amid) $entt_id"

        }
        set get_ent "select mid, currency_code from teihost.merchant where mid in ($midlist)"
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
#global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u
# msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
#global cfg_pth log_pth arch_pth hold_pth upld_pth stop_pth tmp_pth
#global counting_date jdate sdate adate rightnow cmonth cdate cyear begindatetime
# enddatetime begintime endtime cutoff batchtime
#global   tblnm_mm tblnm_mr tblnm_tn tblnm_sc tblnm_mfcg tblnm_bw tblnm_bf
# tblnm_bt tblnm_mf tblnm_e2a tblnm_tr
#--PROC LIST
#proc get_fname {f_type}
#proc set_args {}
#proc show_direction {}
#proc get_cfg {inst_id cfg_pth}
#proc set_dir_paths {inst_id pth_varname gbl_pth_ext}
#proc get_run_mnth {rmnth}
#proc get_run_year {ryear}
#proc set_run_dates {}
#proc load_array {aname str lst}
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
#proc get_mff {f_type}
#proc get_fname {f_type tid_idntfr}
#proc get_curr_cd {f_type midlist}
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

#Initializing for count file run -------------------------------------------

set_args
connect_to_dbs
get_cfg $inst_id $cfg_pth
set_run_dates

set pth ""
set fn [get_fname $cnt_type]
set fchk $pth$inst_id$dot$fn$dot
catch {exec find $env(PWD)/MAS_FILES -name "$fchk*"} result

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
open_cursor_teihost auth_get
open_cursor_teihost auth_get1

#Pulling Mas codes and building an array for later use.

set s "select * from masclr.MAS_FILE_CODE_GRP order by CARD_SCHEME, REQUEST_TYPE, ACTION"

orasql $m_code_sql $s

while {[set y [orafetch $m_code_sql -datavariable mscd]] == 0} {
    set ms_cd [lindex $mscd 0]
    set ind_cs [lindex $mscd 1]
    set ind_rt [lindex $mscd 2]
    set ind_ac [lindex $mscd 3]
    set mas_cd($ind_cs-$ind_rt-$ind_ac) $ms_cd
}

########################################################################################################################
### MAIN
# ###############################################################################################################
########################################################################################################################

set midlist ""
set y 0

if {$cnt_type == "DFW_AMEX" } {

    ##### Getting mid list from entity_to_auth.

    set get_ent_mid "select mid from teihost.merchant
    where mmid in (select mmid from teihost.master_merchant where mmid in (
    'DFW_AIRPORT',
    'DFW-CUSTOMER-001',
    'DFW-DPS-GUN-RANG',
    'DFW-GROUND-TRAN',
    'DFW-DPS-FIRE-TRA',
    'DFW-ACCESS-CONTR')
    and shortname = '$arr_cfg(SETTLE_SHORTNAME)')"

    orasql $auth_get $get_ent_mid

    set mid_count 0
    set mid_list_count 0
    set list_of_mid_lists [list midlist$mid_list_count]
    set list_name "midlist$mid_list_count"
    set $list_name ""

    while {[set x1 [orafetch $auth_get -dataarray e2a -indexbyname]] == 0} {
        if {$mid_count == 0} {
            puts "appending '$e2a(MID)' to $list_name"
            append $list_name "'$e2a(MID)'"
            set mid_count [expr $mid_count + 1]
        } else {
            puts "appending '$e2a(MID)' to $list_name"
            append $list_name ",'$e2a(MID)'"
            set mid_count [expr $mid_count + 1]
        }
        if {$mid_count > 999} {

            #puts "$list_name"
            set mid_list_count [expr $mid_list_count + 1]
            set list_name "midlist$mid_list_count"
            lappend list_of_mid_lists $list_name
            puts "Switching to list name $list_name after reaching mid count $mid_count"
            set mid_count 0
        }
    }



}
#else {
#
#   set get_ent_mid "select mid, flag_use from masclr.merchant_flag where institution_id = '$arr_cfg(INST_ID)' and FLAG_TYPE = '[get_flag_val $cnt_type]' and STATUS in ( 'A','H' ) and FLAG_TYPE_VALUE = 'Y' and mid in (select mid from masclr.entity_to_auth where institution_id = '$arr_cfg(INST_ID)' and STATUS in ( 'A','H' ) and FILE_GROUP_ID = '$arr_cfg(SETTLE_SHORTNAME)')"
#   #puts $get_ent_mid
#
#   orasql $clr_get1 $get_ent_mid
#
#   set mid_count 0
#   set mid_list_count 0
#   set list_of_mid_lists [list midlist$mid_list_count]
#   set list_name "midlist$mid_list_count"
#   set $list_name ""
#   while {[set x1 [orafetch $clr_get1 -dataarray e2a -indexbyname]] == 0} {
#       if {$e2a(FLAG_USE) == ""} {
#           if {$mid_count == 0} {
#               append $list_name "'$e2a(MID)'"
#               set mid_count [expr $mid_count + 1]
#           } else {
#               append $list_name ",'$e2a(MID)'"
#               set mid_count [expr $mid_count + 1]
#           }
#       }
#       if {$mid_count > 999} {
#           #puts "$list_name"
#           set mid_list_count [expr $mid_list_count + 1]
#           set list_name "midlist$mid_list_count"
#           lappend list_of_mid_lists $list_name
#           set mid_count 0
#       }
#   }
#   foreach midlist $list_of_mid_lists {
#       if {[set $midlist] == ""} {
#           puts "No merchants found with institution_id = '$arr_cfg(INST_ID)' and FLAG_TYPE = '[get_flag_val $cnt_type]' and STATUS in ( 'A','H' ) and FLAG_TYPE_VALUE = 'Y'"
#           #exit 0
#       }
#   }
#   if {$cnt_type == "VAU" || $cnt_type == "MBU"} {
#       set i2 0
#       foreach midlist $list_of_mid_lists {
#           set get_tids "select tid from teihost.terminal where mid in ([set $midlist])"
#           #puts $get_tids
#           catch {orasql $auth_get1 $get_tids} result
#           while {[set q [orafetch $auth_get1 -dataarray tid1 -indexbyname]] == 0} {
#               lappend tid_list "$tid1(TID)"
#               set i2 [expr $i2 + 1]
#           }
#       }
#       set mid_count 0
#       set mid_list_count 0
#       set list_of_mid_lists [list midlist$mid_list_count]
#       set list_name "midlist$mid_list_count"
#       set $list_name ""
#       foreach ltid $tid_list {
#           if {$mid_count == 0} {
#               append $list_name "'$ltid'"
#               set mid_count [expr $mid_count + 1]
#           } else {
#               append $list_name ",'$ltid'"
#               set mid_count [expr $mid_count + 1]
#           }
#           if {$mid_count > 999} {
#               #puts "$list_name"
#               set mid_list_count [expr $mid_list_count + 1]
#               set list_name "midlist$mid_list_count"
#               lappend list_of_mid_lists $list_name
#               set mid_count 0
#           }
#       }
#   }
#
#
#
#}

foreach midlist $list_of_mid_lists {
    if {[set $midlist] == ""} {
        puts "No merchants found with institution_id = '$arr_cfg(INST_ID)' and FLAG_TYPE = '[get_flag_val $cnt_type]' and STATUS in ( 'A','H' ) and FLAG_TYPE_VALUE = 'Y'"
        exit 0
    } else {
        #puts "$midlist: [set $midlist]"
        #exit 0
    }
}
set fileseq 1
foreach midlist $list_of_mid_lists {
    #Opening Output file to write to

    set outfile [get_outfile $fileseq]
    puts "using $outfile for midlist $midlist"

    set fileseq [expr $fileseq + 1]

    if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
        puts stderr "Cannot open /duplog : $fileid"
        exit 1
    }

    ###### Writing File Header into the Mas file

    set rec(file_date_time) $rightnow
    set rec(activity_source) "JETPAYLLC"
    set rec(activity_job_name) "AUTHCNT"

    write_fh_record $fileid rec

    #Checking if merchant processes vs mc
    #foreach midlist $list_of_mid_lists {
        get_curr_cd $cnt_type [set $midlist]
    #}

    #puts "$midlist: [set $midlist]"
    ###### Sql Select to get all merchants daily transations count and sum amount

    set get_info "[get_sql $cnt_type [set $midlist]]"

    #puts $get_info

    orasql $auth_get $get_info

    ###### Writing File Header into the Mas file

    ###### Declearing Variables and intializing

    set chkmid " "
    set chkmidt " "
    set totcnt 0
    set totamt 0
    set ftotcnt 0
    set ftotamt 0
    set trlcnt 0
    ###### While Loop for to fetch records gathered by Sql Select get_info

    while {[set loop [orafetch $auth_get -dataarray a -indexbyname]] == 0} {
        ### clear variables
        set rec(mas_code) ""
        set rec(trans_id) ""
        switch $a(CARD_TYPE) {
            "VS" {set c_sch "04"}
            "MC" {set c_sch "05"}
            "AX" {set c_sch "03"}
            "DS" {set c_sch "08"}
            "DC" {set c_sch "07"}
            "JC" {set c_sch "09"}
            default  {set c_sch "00"}
        }
        set rec(card_scheme) $c_sch

        ### set the mas_code
        ### do this early so the trans type can skip if needed
        if { $cnt_type == "VAU" } {
            set rec(mas_code) "00VAUCHK"
        } elseif { $cnt_type == "MBU" } {
            set rec(mas_code) "00MBUCHK"
        } elseif { $cnt_type == "WOOT" } {
            switch $c_sch {
                "04" { set rec(mas_code) "VISA_BANK_SPONSOR" }
                "05" { set rec(mas_code) "MC_BANK_SPONSOR" }
            }
        } elseif { $cnt_type == "WOOT2" } {
            set rec(mas_code) "00BUSRULE"
        } elseif {[info exists mas_cd($c_sch-$a(REQUEST_TYPE)-$a(STATUS))]} {
            if {[set mcdchk $mas_cd($c_sch-$a(REQUEST_TYPE)-$a(STATUS))] != "IGNORE"} {
                set rec(mas_code) $mas_cd($c_sch-$a(REQUEST_TYPE)-$a(STATUS))
            } else {
                continue
            }
        } else {
            puts "New request type mas_cd($c_sch-$a(REQUEST_TYPE)-$a(STATUS) not found in MAS_FILE_CODE_GRP table"
        }
        ###### Writing Batch Header Or Batch Trailer

        if {$chkmid != $a(MID)} {
            set trlcnt 1
            if {$chkmid != " "} {
                # added by SNS to fix integer overflow
                #   puts "position 1: totamt = $totamt"
                set rec(batch_amt)  $totamt
                set rec(batch_cnt) $totcnt
                write_bt_record $fileid rec
                set chkmidt $a(MID)
                set totcnt 0
                set totamt 0
                #   set trlcnt 1
            }

            set rec(batch_curr) "$curr_cd($a(MID))"
            set rec(activity_date_time_bh) $mas_activity_date
            set rec(merchantid) "$entity_id($a(MID))"
            set rec(inbatchnbr) [pbchnum]
            set rec(infilenbr)  1
            set rec(batch_capture_dt) $mas_batch_date
            set rec(sender_id) $a(MID)

            write_bh_record $fileid rec
            set chkmid $a(MID)
        }

        ###### Writing Massage Detail records
        set tid_idntfr "$a(REQUEST_TYPE)" ; #<tid_idntfr> can be needed for multiple tid option""
        if {$cnt_type != "ACH"} {
            set mas_tid [get_tid $cnt_type $a(REQUEST_TYPE)]
            set rec(trans_id) $mas_tid
        } else {
            get_tid $cnt_type $tid_idntfr
            set rec(trans_id) $mas_tid($a(REQUEST_TYPE))
        }

        set rec(entity_id) $entity_id($a(MID))
        set rec(trans_ref_data) $a(MID)
        #A switch to convert card types----------------

        set rec(nbr_of_items) $a(CNT)
        set rec(amt_original) [expr wide(round([expr $a(AMT) * 100]))]

        write_md_record $fileid rec

        set totcnt [expr $totcnt + $a(CNT)]
        set totamt [expr $totamt + $rec(amt_original)]

        set ftotcnt [expr $ftotcnt + $a(CNT)]
        set ftotamt [expr $ftotamt + $rec(amt_original)]
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
    catch {exec  mv $outfile $env(PWD)/MAS_FILES/.} result
}
puts "==============================================END OF FILE=============================================================="
#===============================================END
# PROGRAM==================================================================
