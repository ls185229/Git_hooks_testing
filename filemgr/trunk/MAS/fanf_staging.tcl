#!/usr/bin/env tclsh
# ###############################################################################
# $Id: fanf_staging.tcl 4822 2019-03-11 16:47:43Z bjones $
# $Rev: 4822 $
# ###############################################################################
#
# File Name:  fanf_staging.tcl
#
# Description:  This script determines if the fanf_processing script to be
#               executed or not.
#
# Running options: -d date -i institution
#
# Shell Arguments: none
#
# Output:       The return code determines the next step.
#
# Return:   0 = Success (All the Clearing MAS files are processed)
#           1 = Exit with errors (Clearing file count doesnt match or Database error or Clearing file is still under process)
# #############################################################################

package require Oratcl
package provide random 1.0
lappend auto_path $env(MASCLR_LIB)
package require GetOpts 1.1

source $env(MASCLR_LIB)/masclr_tcl_lib
source $env(MASCLR_LIB)/mas_file_lib

global MODE datevar instvar
set MODE "TEST"
# Procedure to send alert mail
proc send_alert {alert_msg} {
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo inst_id err_msg
    if { [catch { exec echo "$mbody_c $sysinfo $alert_msg" | mutt -s "$msubj_c" -- $mailtolist } result] != 0 } {
       if { [string range $result 0 21] == "Waiting for fcntl lock" } {
          puts "Ignore mutt file control lock $result"
       } else {
          set err_msg "mutt error message: $result"
          MASCLR::log_message $err_msg
       }
    }
};

proc connect_to_dbs {} {

    global arr_cfg inst_id s_name fname dot cnt_type run_mnth run_year db_logon_handle db_login_handle
    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo cfg_pth log_pth arch_pth hold_pth

    if {[catch {set db_login_handle [oralogon masclr/masclr@$clrdb]} result]} {
        set mbody "$clrdb failed to open database handle"
        puts $mbody
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        exit 1
    }

};

proc open_cursor_masclr {cursr} {
    global db_login_handle
    global $cursr
    if {[catch {set $cursr [oraopen $db_login_handle]} result]} {
        set mbody "$cursr failed to open statement handle"
        puts $mbody
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        exit 1
    }
};

proc arg_parse {} {
    global argv argv0 datevar instvar
    global mailtolist

    while { [ set err [ getopt $argv "h:d:i:tv" opt optarg ]] } {
        if { $err < 0 } then {
            MASCLR::log_message "error: $argv0 : opt $opt, optarg: $optarg "
            usage
            exit 1
        } else {
            MASCLR::log_message "opt: $opt, optarg: $optarg" 1
            switch -exact $opt {
               d {set datevar $optarg}
               i {set instvar $optarg}
               t {set mailtolist "clearing@jetpay.com"}
               v {incr MASCLR::DEBUG_LEVEL}
               h {
                    usage
                    exit 1
                }
            }
        }
    }
};

proc readCfgFile {} {
    global inst_list file_type cfg_name programName
    set cfg_name "fanf.cfg"
    if {[catch {open $cfg_name} filePtr]} {
        puts "File Open Err in : $programName Cannot open the config file $cfg_name"
        exit 2
    }

    while { [set line [gets $filePtr]] != {}} {
      set lineParms [split $line =]
      switch -exact -- [lindex  $lineParms 0] {
            "INST_LIST" {
                set inst_list [lindex $lineParms 1]
            }
         default {
            puts "Unknown config parameter [lindex $lineParms 0]"
          }
       }
    }

    close $filePtr
};

proc build_fanf_staging {} {
    global fanf_query1 fanf_query2 fanf_query3
    global fanf_query4 fanf_query5 fanf_query6
    global fanf_query7 fanf_query8 fanf_query9
    global fanf_query10 fanf_query11 fanf_query12
    global cmonth cdate cyear cday
    global db_login_handle
    global clr_get
    global inst_list err_msg
    set fanf_query1 "
        delete fanf_staging
        where month_requested = trunc(to_date('$cday-$cmonth-$cyear', 'DD-MON-YYYY'),'MM')"

    MASCLR::log_message "\n inside insert_fanf_staging query_string: \n$fanf_query1\n\n" 3

    #if delete is success or NO_DATA_FOUND then do insert_fanf_staging
    if { [catch {orasql $clr_get $fanf_query1} result ] } {
        set err_msg "Encountered DB error $result while trying to delete fanf_staging records"
        MASCLR::log_message $err_msg
        send_alert $err_msg
        MASCLR::close_all_and_exit_with_code 1
    }

    if { [catch {
        set fanf_query2 "
            insert into fanf_staging
                (tax_id, entity_id, institution_id, default_mcc, cp_amt, cnp_amt,
                month_requested, date_of_request, inst_name, possible_hv_merch)
            select a.tax_id,a.entity_id,a.institution_id,a.default_mcc,
                sum(case when v.moto_e_com_ind not in ('1','2','3','4','5','6','7','8','9') or
                               v.moto_e_com_ind is NULL
                        then amt_billing else 0 end) cp_amt,
                sum(case when v.moto_e_com_ind     in ('1','2','3','4','5','6','7','8','9')
                        then amt_billing else 0 end) cnp_amt,
                trunc(to_date('$cday-$cmonth-$cyear', 'DD-MON-YYYY'), 'MM'),
                trunc(sysdate) date_of_request,
                inst.inst_name,
                case when
                    (a.default_mcc between 3000 and 3999 or
                     a.default_mcc in
                        ('4511', '7011', '7512', '4411', '4829', '5200', '5300', '5309', '5310',
                        '5311', '5411', '5511', '5532', '5541', '5542', '5651', '5655', '5712',
                        '5732', '5912', '5943', '7012', '7832'))
                    then 'Y'
                    else 'N' end possible_hv_merch
            from mas_trans_log m
            join acq_entity a
            on  a.institution_id = m.institution_id
            and a.entity_id = m.entity_id
            join institution inst
            on  m.institution_id = inst.institution_id
            join in_draft_main i
            on  m.external_trans_nbr = i.trans_seq_nbr
            left outer join visa_adn v
            on     v.trans_seq_nbr = m.external_trans_nbr
            where a.entity_status = 'A'
            and m.trans_sub_seq = '0'
            and m.tid like '0100030051%'
            and m.tid != '010003005102'
            and m.card_scheme = '04'
            and m.settl_flag = 'Y'
            and length(m.external_trans_nbr) <= 12
            and m.gl_date >=          to_date(:year_var || :month_var, 'YYYYMON')
            and m.gl_date <= last_day(to_date(:year_var || :month_var, 'YYYYMON'))
            and m.institution_id in ($inst_list)
            group by a.institution_id, a.entity_id, a.tax_id, a.default_mcc,
                inst.inst_name
            having sum(m.amt_billing) != 0
            order by a.tax_id,a.entity_id,a.institution_id,a.default_mcc"

        MASCLR::log_message "\n inside insert_fanf_staging query_string: \n$fanf_query2\n\n" 3
        oraparse $clr_get $fanf_query2
        orabind $clr_get :month_var $cmonth :year_var $cyear
        oraexec $clr_get } failure] } {
        set err_msg "Error parsing, binding or executing fanf_query2 sql: $failure \n $clr_get"
        MASCLR::log_message $err_msg
        send_alert $err_msg
        MASCLR::close_all_and_exit_with_code 1
    }
    MASCLR::log_message "\n fanf_query2 sql is successfully executed" 3

    if { [catch {
        set fanf_query3 "
            update fanf_staging c
            set (c.tot_cp_amt, c.tot_hv_cp) = (
                SELECT distinct
                    ( SELECT SUM(cp_amt ) FROM fanf_staging b
                        WHERE a.tax_id = b.tax_id
                        AND a.inst_name = b.INST_NAME
                        AND a.MONTH_REQUESTED = b.MONTH_REQUESTED)  bank_cp,
                    ( SELECT SUM(cp_amt ) FROM fanf_staging b
                        WHERE a.tax_id = b.tax_id
                        AND a.inst_name = b.INST_NAME
                        AND a.MONTH_REQUESTED = b.MONTH_REQUESTED
                        and b.possible_hv_merch = 'Y' )             bank_hv_cp
                    FROM fanf_staging a
                    WHERE a.tax_id = c.tax_id
                    AND a.inst_name = c.INST_NAME
                    AND a.MONTH_REQUESTED = c.MONTH_REQUESTED
                )
            WHERE c.tax_id = c.tax_id
            AND c.month_requested = trunc(to_date('$cday-$cmonth-$cyear', 'DD-MON-YYYY'), 'MM')"
        MASCLR::log_message "\n inside insert_fanf_staging query_string: \n$fanf_query3\n\n" 3
        orasql $clr_get $fanf_query3} failure] } {
        set err_msg "Error parsing, binding or executing fanf_query3 sql: $failure \n $clr_get"
        MASCLR::log_message $err_msg
        send_alert $err_msg
        MASCLR::close_all_and_exit_with_code 1
    }
    MASCLR::log_message "\n fanf_query3 sql is successfully executed" 3

    if { [catch {
        set fanf_query4 "
            update fanf_staging c
            set (c.tot_cnp_amt) = (
                SELECT distinct
                    ( SELECT SUM(cnp_amt) FROM fanf_staging b
                        WHERE a.tax_id = b.tax_id
                        AND a.inst_name = b.INST_NAME
                        AND a.MONTH_REQUESTED = b.MONTH_REQUESTED)  bank_cnp
                    FROM fanf_staging a
                    WHERE a.tax_id = c.tax_id
                    and a.inst_name = c.inst_name
                    AND a.MONTH_REQUESTED = c.MONTH_REQUESTED
                )
            WHERE c.tax_id = c.tax_id
            AND c.month_requested = trunc(to_date('$cday-$cmonth-$cyear', 'DD-MON-YYYY'), 'MM')"
        MASCLR::log_message "\n inside insert_fanf_staging query_string: \n$fanf_query4\n\n" 3
        orasql $clr_get $fanf_query4} failure] } {
        set err_msg "Error parsing, binding or executing fanf_query4 sql: $failure \n $clr_get"
        MASCLR::log_message $err_msg
        send_alert $err_msg
        MASCLR::close_all_and_exit_with_code 1
    }
    MASCLR::log_message "\n fanf_query4 sql is successfully executed" 3

    if { [catch {
        set fanf_query5 "
            update fanf_staging a set
                a.cp_percentage =
                   case when (a.tot_cp_amt + a.tot_cnp_amt) = 0 then 0
                   else
                      a.tot_cp_amt / (a.tot_cp_amt + a.tot_cnp_amt) * 100.0
                   end
            where a.month_requested = trunc(to_date('$cday-$cmonth-$cyear', 'DD-MON-YYYY'), 'MM')"
        MASCLR::log_message "\n inside insert_fanf_staging query_string: \n$fanf_query5\n\n" 3
        orasql $clr_get $fanf_query5} failure] } {
        set err_msg "Error parsing, binding or executing fanf_query5 sql: $failure \n $clr_get"
        MASCLR::log_message $err_msg
        send_alert $err_msg
        MASCLR::close_all_and_exit_with_code 1
    }
    MASCLR::log_message "\n fanf_query5 sql is successfully executed" 3

    if { [catch {
        set fanf_query6 "
            update fanf_staging a
                set a.num_of_locations = (
                        select count(1) as loc_count
                        from fanf_staging b
                        where
                            a.tax_id = b.tax_id and
                            a.inst_name = b.inst_name and
                            b.cp_amt > 0 and
                            b.month_requested = trunc(to_date('$cday-$cmonth-$cyear', 'DD-MON-YYYY'), 'MM'))
            where
                a.cp_amt > 0 and
                a.month_requested = trunc(to_date('$cday-$cmonth-$cyear', 'DD-MON-YYYY'), 'MM')"
        MASCLR::log_message "\n inside insert_fanf_staging query_string: \n$fanf_query6\n\n" 3
        orasql $clr_get $fanf_query6} failure] } {
        set err_msg "Error parsing, binding or executing fanf_query6 sql: $failure \n $clr_get"
        MASCLR::log_message $err_msg
        send_alert $err_msg
        MASCLR::close_all_and_exit_with_code 1
    }
    MASCLR::log_message "\n fanf_query6 sql is successfully executed" 3

    if { [catch {
        set fanf_query7 "
            update fanf_staging a set
                a.actual_hv_merch = null
            where
                a.month_requested = trunc(to_date('$cday-$cmonth-$cyear', 'DD-MON-YYYY'), 'MM')"
        MASCLR::log_message "\n inside insert_fanf_staging query_string: \n$fanf_query7\n\n" 3
        orasql $clr_get $fanf_query7} failure] } {
        set err_msg "Error parsing, binding or executing fanf_query7 sql: $failure \n $clr_get"
        MASCLR::log_message $err_msg
        send_alert $err_msg
        MASCLR::close_all_and_exit_with_code 1
    }
    MASCLR::log_message "\n fanf_query7 sql is successfully executed" 3

    if { [catch {
        set fanf_query8 "
            update fanf_staging a set
                a.actual_hv_merch = 'Y'
            where
                a.tot_hv_cp > 0 and
                a.tot_cp_amt > 0 and
                a.cp_amt > 0 and
                (a.tot_hv_cp / a.tot_cp_amt) > .5 and
                a.month_requested = trunc(to_date('$cday-$cmonth-$cyear', 'DD-MON-YYYY'), 'MM')"
        MASCLR::log_message "\n inside insert_fanf_staging query_string: \n$fanf_query8\n\n" 3
        orasql $clr_get $fanf_query8} failure] } {
        set err_msg "Error parsing, binding or executing fanf_query8 sql: $failure \n $clr_get"
        MASCLR::log_message $err_msg
        send_alert $err_msg
        MASCLR::close_all_and_exit_with_code 1
    }
    MASCLR::log_message "\n fanf_query8 sql is successfully executed" 3

        if { [catch {
        set fanf_query9 "
            update fanf_staging a set
                a.table_1 =
                    case when a.cp_percentage > 0 and
                                a.actual_hv_merch = 'Y' then '1A'
                         when a.cp_percentage > 0 and
                                (a.actual_hv_merch <> 'Y' or
                                a.actual_hv_merch is NULL) then '1B'
                         else ' ' end
            where
                a.month_requested = trunc(to_date('$cday-$cmonth-$cyear', 'DD-MON-YYYY'), 'MM')"
        MASCLR::log_message "\n inside insert_fanf_staging query_string: \n$fanf_query9\n\n" 3
        orasql $clr_get $fanf_query9} failure] } {
        set err_msg "Error parsing, binding or executing fanf_query9 sql: $failure \n $clr_get"
        MASCLR::log_message $err_msg
        send_alert $err_msg
        MASCLR::close_all_and_exit_with_code 1
    }
    MASCLR::log_message "\n fanf_query9 sql is successfully executed" 3

        if { [catch {
        set fanf_query10 "
            update fanf_staging a set
                (a.table_1_tier, a.cp_fee )   =  (
                        select ft.tier, ft.fee
                        from fanf_table ft
                        where ft.tbl = a.table_1
                        and  ft.locations_min <= a.num_of_locations
                        and (ft.locations_max >= a.num_of_locations
                            or ft.locations_max is null)
                        )
            where a.table_1 is not null
            and a.month_requested = trunc(to_date('$cday-$cmonth-$cyear', 'DD-MON-YYYY'), 'MM')"
        MASCLR::log_message "\n inside insert_fanf_staging query_string: \n$fanf_query10\n\n" 3
        orasql $clr_get $fanf_query10} failure] } {
        set err_msg "Error parsing, binding or executing fanf_query10 sql: $failure \n $clr_get"
        MASCLR::log_message $err_msg
        send_alert $err_msg
        MASCLR::close_all_and_exit_with_code 1
    }
    MASCLR::log_message "\n fanf_query10 sql is successfully executed" 3

    if { [catch {
        set fanf_query11 "
            update fanf_staging a set
                (a.table_1_tier, a.cp_fee) = (
                        select ft.tier, ft.pct * a.cp_amt / 100
                        from fanf_table ft
                        where ft.tbl = a.table_1
                        and ft.sales_min <= a.tot_cp_amt
                        and ft.sales_max >= a.tot_cp_amt
                        )
            where a.table_1 is not null
            and a.tot_cp_amt <= 1250
            and a.tax_id not in (
                select distinct b.tax_id
                from fanf_staging b
                join fanf_merchant m
                on b.institution_id = m.institution_id
                and b.entity_id = m.entity_id
                where m.partial_acquirer = 'Y'
                and b.institution_id = a.institution_id
                and b.entity_id = a.entity_id
                )
            and a.month_requested = trunc(to_date('$cday-$cmonth-$cyear', 'DD-MON-YYYY'), 'MM')"
        MASCLR::log_message "\n inside insert_fanf_staging query_string: \n$fanf_query11\n\n" 3
        orasql $clr_get $fanf_query11} failure] } {
        set err_msg "Error parsing, binding or executing fanf_query11 sql: $failure \n $clr_get"
        MASCLR::log_message $err_msg
        send_alert $err_msg
        MASCLR::close_all_and_exit_with_code 1
    }
    MASCLR::log_message "\n fanf_query11 sql is successfully executed" 3

    if { [catch {
        set fanf_query12 "
            update fanf_staging a set
                (a.table_2_tier, a.cnp_fee) = (
                        select ft.tier,
                            case
                                when pct is null then
                                    case when a.cnp_amt = a.tot_cnp_amt then ft.fee
                                    else
                                        ft.fee * a.cnp_amt / a.tot_cnp_amt
                                    end
                                else pct * a.tot_cnp_amt / 100
                            end
                        from fanf_table ft
                        where ft.tbl = '2'
                        and ft.sales_min  <= a.tot_cnp_amt
                        and (ft.sales_max >= a.tot_cnp_amt
                            or ft.sales_max is null)
                        )
            where a.tot_cnp_amt > 0
            and a.month_requested = trunc(to_date('$cday-$cmonth-$cyear', 'DD-MON-YYYY'), 'MM')"
        MASCLR::log_message "\n inside insert_fanf_staging query_string: \n$fanf_query12\n\n" 3
        orasql $clr_get $fanf_query12} failure] } {
        set err_msg "Error parsing, binding or executing fanf_query12 sql: $failure \n $clr_get"
        MASCLR::log_message $err_msg
        send_alert $err_msg
        MASCLR::close_all_and_exit_with_code 1
    }
    MASCLR::log_message "\n fanf_query12 sql is successfully executed" 3

    if { [catch {oracommit $db_login_handle } result ] } {
       set err_msg "Encountered error $result while trying to commit DB handles"
       MASCLR::log_message $err_msg
       send_alert $err_msg
       MASCLR::close_all_and_exit_with_code 1
    }
    return 0
};

proc free_db_dandle {} {
    global clr_get
    global db_login_handle err_msg
    # close all the DB connections
    oraclose $clr_get

    if { [catch {oralogoff $db_login_handle } result ] } {
       set err_msg "Encountered set err_msg $result while trying to close DB handles"
       MASCLR::log_message $err_msg
       send_alert $err_msg
    }
};

proc set_var {} {
    global rightnow cmonth cdate cyear cday datevar instvar
    if {"$datevar" != ""} {
        set rightnow [clock scan $datevar]
    } else {
        set rightnow [clock seconds]
    }
    set cmonth [clock format $rightnow -format "%b"]
    set cyear [clock format $rightnow -format "%Y"]
    set cday  [clock format $rightnow -format "%w"]
    global argv inst_list
    ### specify a log file to log within the tcl script
    ### or (the normal) just leave this call to an empty
    ### string and logging will go to stdout and redirect
    ### to the log file specified in the calling script
    MASCLR::open_log_file ""
    MASCLR::parse_arguments $argv
    MASCLR::set_script_alert_level "LOW"
    MASCLR::live_updates
};

###########################################################################################################

#Environment variables.......

set box $env(SYS_BOX)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(SEC_DB)

global programName

set programName [file tail $argv0]
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
### MAIN ##################################################################################################
###########################################################################################################
proc main {} {
    #GLOBALS

    global arr_cfg s_name fname dot cnt_type run_mnth run_year db_login_handle
    global box clrpath maspath mailtolist mailfromlist clrdb authdb
    global msubj_c msubj_u msubj_h msubj_m msubj_l
    global mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global datevar instvar

    arg_parse
    set_var
    readCfgFile
    #sql logon handles #################################################

    connect_to_dbs
    open_cursor_masclr clr_get
    build_fanf_staging
    free_db_dandle
    MASCLR::close_all_and_exit_with_code 0
};

main
