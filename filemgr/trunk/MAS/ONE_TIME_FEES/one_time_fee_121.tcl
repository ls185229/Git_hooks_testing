#!/usr/bin/env tclsh

################################################################################
# $Id: one_time_fee_121.tcl 2343 2013-07-12 01:33:04Z millig $
# $Rev: 2343 $
################################################################################
#
# File Name:  one_time_fee_121.tcl
#
# Description:  This program generates MAS one-time files by institution.
#
# Script Arguments:  None.
#
# Output:  MAS one-time files by institution.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

source $env(MASCLR_LIB)/masclr_tcl_lib

########################
# setup
# set default values for global variables
# these may change depending on arguments to the script
# change any script-specific defaults here
# such as the log file to use
# or a specific config file, etc.
########################

set seq_ctrl_update_file_name ""
set fee_output_file ""
set verification_query_file_name ""

proc setup {} {

    MASCLR::open_log_file "./LOGS/MAS.one_time_fee.log"
    MASCLR::set_script_alert_level "LOW"
    MASCLR::set_debug_level 0
#    MASCLR::save_updates_to_file
    MASCLR::live_updates
    MASCLR::set_up_dates

    global input_file_name
    set input_file_name "feefile.txt"

    ###
}  ;# setup
    ###


proc usage_statement {} {

    puts stdout "Usage: [info script] "
    puts stdout "  reads a list of one-time fees from a file called feefile.txt"
    puts stdout "  feefile.txt should have this format: "
    puts stdout "  entity ID,card_scheme,TID,mas code to use,next generate date,fee amount,fee description"
    MASCLR::close_all_and_exit_with_code 0
    ###
}  ;# usage_statement
    ###

proc check_tid { tid_to_check the_cursor } {
    set the_sql "select count(1) from tid where tid = '$tid_to_check'"
    if { [catch {set count [MASCLR::fetch_single_value $the_cursor $the_sql]} failure ] } {
        error "$failure"
    }

    if {$count != "1"} {
        MASCLR::log_message "Could not find TID $tid_to_check in MASCLR.TID table."
        MASCLR::close_all_and_exit_with_code 1
    }
    ###
}  ;# check_tid
    ###

proc gather_values_from_fee_file { database_handle fee_output_file_name verification_file_name } {
    global input_file_name seq_ctrl_update_file_name

    set masclr_cursor_query1 [MASCLR::open_cursor $database_handle]
    set masclr_cursor_query2 [MASCLR::open_cursor $database_handle]
    set acq_entity_cursor_query1 [MASCLR::open_cursor $database_handle]
    set settl_plan_cursor_query1 [MASCLR::open_cursor $database_handle]
    set input_file_id [MASCLR::open_file $input_file_name RDONLY 1]

    set last_inst ""
    set where_clause ""

    #puts stdout "  feefile.txt should have this format: "
    #puts stdout "  entity ID,card_scheme,TID,mas code to use,next generate date,fee amount,fee description"
    set cur_line  [split [set orig_line [gets $input_file_id] ] ,]
    while {$cur_line != ""} {
        set ent_id [string trim [lindex $cur_line 0]]
        set card_scheme_var [string trim [lindex $cur_line 1]]

        set the_sql "select INSTITUTION_ID, ENTITY_ID, ENTITY_DBA_NAME from acq_entity
                     where entity_id = '$ent_id' and institution_id = '121'"
        if { [catch {MASCLR::start_fetch $masclr_cursor_query1 $the_sql} failure] } {
            set message "Could not start fetch with orasql: $failure"
            error $message
        }
        # I know this will only give one row, and thath this should be changed to an if instead of while.
        # That will happen later
        while { [MASCLR::get_cursor_status $masclr_cursor_query1] == $MASCLR::HAS_MORE_RECORDS } {
            array set acq_entity_arr [MASCLR::fetch_record $masclr_cursor_query1]
        }

        set inst_id $acq_entity_arr(INSTITUTION_ID)

        if {$last_inst == $inst_id} {
            append where_clause ", "
        } else {
            set last_inst $inst_id
            if { $where_clause != ""} {
                append where_clause "))\n or \n"
            }
            append where_clause "(enfp.institution_id = '$inst_id' and enfp.non_act_fee_pkg_id in ("
        }

        set tmp_tid [string trim [lindex $cur_line 2]]


        if { [string length $tmp_tid] == 12 } {
            # verify that the TID exists
            check_tid $tmp_tid $masclr_cursor_query2
            # if we get here, the TID was found
            set tid_to_use $tmp_tid
        } else {
            MASCLR::log_message  "Invalid TID length.  Exiting."
            MASCLR::close_all_and_exit_with_code 1
        }

        # find settle plan ID
        set settle_plan_id "-1"
        set the_sql "select SETTL_PLAN_ID from acq_entity where entity_id = '$ent_id' and institution_id = '$inst_id'"
        set settle_plan_id [MASCLR::fetch_single_value $masclr_cursor_query2 $the_sql]
        if { $settle_plan_id == "-1" } {
            MASCLR::log_message "Could not find the settle plan for the entity:"
            MASCLR::log_message "$check_settle_plan_sql"
            MASCLR::close_all_and_exit_with_code 1
        }

        set mas_code_to_use [string trim [lindex $cur_line 3]]

        set next_gen_date [string trim [lindex $cur_line 4]]
        if { [ catch {clock format [clock scan $next_gen_date]} result] } {
            # a result of 1 means clock scan couldn't convert the string, so an invalid date was passed.
            MASCLR::log_message "Invalid date entered: $next_gen_date."
            MASCLR::close_all_and_exit_with_code 1
        }
        set next_gen_date [clock format [clock scan $next_gen_date] -format "%d-%h-%Y"]
        set next_gen_date "$next_gen_date 12:00:00 AM"
        set next_gen_date [string toupper $next_gen_date]

        set fee_end_date [clock format [clock scan "$next_gen_date 2 days"] -format "%d-%h-%Y"]
        set fee_end_date "$fee_end_date 12:00:00 AM"
        set fee_end_date [string toupper $fee_end_date]

        set fee_amount [string trim [lindex $cur_line 5]]

        set fee_amount [format "%.2f" $fee_amount]

        set fee_desc [string trim [lindex $cur_line 6]]
        if { [string length $fee_desc] > 14 } {
            MASCLR::log_message "Truncating to 14 characters"
            set fee_desc [string range $fee_desc 0 13]
        }
        set fee_desc "$ent_id $fee_desc"
        set fee_desc [string map {+ " " & " " _ " " ' " " / " " ? " " ! " " % " " $ " " * " " ( " " ) " " \" " " \  " " \. " "} $fee_desc]

        set misc_notes [lindex $cur_line 7]

        MASCLR::print_to_file_name $fee_output_file_name "REM  $acq_entity_arr(ENTITY_ID) $acq_entity_arr(ENTITY_DBA_NAME) "
        MASCLR::print_to_file_name $fee_output_file_name "REM  Fee amount: \$ $fee_amount"
        MASCLR::print_to_file_name $fee_output_file_name "REM  $misc_notes "

        MASCLR::print_to_file_name $verification_file_name "REM  $acq_entity_arr(ENTITY_ID) $acq_entity_arr(ENTITY_DBA_NAME) "
        MASCLR::print_to_file_name $verification_file_name "REM  Fee amount: \$ $fee_amount"
        MASCLR::print_to_file_name $verification_file_name "REM  $misc_notes "

        MASCLR::print_to_file_name $verification_file_name "REM Query to check at end of month in trnclr1"
        MASCLR::print_to_file_name $verification_file_name "\n"
        MASCLR::print_to_file_name $verification_file_name "select entity_id, tid, mas_code, amt_original, date_to_settle, gl_date "
        MASCLR::print_to_file_name $verification_file_name "from mas_trans_log "
        MASCLR::print_to_file_name $verification_file_name "where entity_id = '$acq_entity_arr(ENTITY_ID)' and mas_code = '$mas_code_to_use'"
        MASCLR::print_to_file_name $verification_file_name " and tid = '$tid_to_use' and amt_original = '$fee_amount'"
        MASCLR::print_to_file_name $verification_file_name " and (   to_char(date_to_settle,'DD-MON-YYYY') like '[string range  $next_gen_date 0 10]%'"
        MASCLR::print_to_file_name $verification_file_name "      or to_char(gl_date,'DD-MON-YYYY') like '[string range  $next_gen_date 0 10]%' )"
        MASCLR::print_to_file_name $verification_file_name " and NON_ACT_FEE_PKG_ID is not null;"
        MASCLR::print_to_file_name $verification_file_name "\n"

        MASCLR::print_to_file_name $fee_output_file_name "\n"
        MASCLR::print_to_file_name $fee_output_file_name "\n\nREM Use the following SQL insert statents in trnclr1:"
        MASCLR::print_to_file_name $fee_output_file_name "\n"


        # check to see if the tid is in the entity's settle plan
        set the_sql "SELECT count(1) FROM SETTL_PLAN_TID WHERE INSTITUTION_ID='$inst_id' AND TID = '$tid_to_use'
            AND SETTL_PLAN_ID IN  (SELECT SETTL_PLAN_ID FROM ACQ_ENTITY
            WHERE ENTITY_ID = '$ent_id' AND INSTITUTION_ID = '$inst_id')
            and CARD_SCHEME = '$card_scheme_var'"

        if { [catch {set count [MASCLR::fetch_single_value $settl_plan_cursor_query1 $the_sql]} failure ] } {
            error "$failure"
        }

        if {$count < 0} {
            MASCLR::log_message "Could not find TID $tid_to_use in settle plan for $ent_id."
            MASCLR::close_all_and_exit_with_code 1
        }

        set non_act_fee_pkg_id_var [get_next_nonact_fee_pkg_id $inst_id $masclr_cursor_query2]
        # get new non_act_fee_pkg_id and generate new  non_act_fee_pkg
        MASCLR::print_to_file_name $fee_output_file_name "\n"
        MASCLR::print_to_file_name $fee_output_file_name "insert into non_act_fee_pkg (institution_id, non_act_fee_pkg_id, fee_start_date, fee_end_date, nonact_feepkg_name)  values ('$inst_id', '$non_act_fee_pkg_id_var', to_date(to_char(sysdate, 'DD-MON-YYYY')||' 12:00:00 AM', 'DD-MON-YYYY HH:MI:SS AM') ,to_date('$fee_end_date','DD-MON-YYYY HH:MI:SS AM') , '$fee_desc');"

        MASCLR::print_to_file_name $fee_output_file_name "\n"

        MASCLR::print_to_file_name $fee_output_file_name "insert into non_activity_fees (institution_id, non_act_fee_pkg_id, charge_method,tid, mas_code,   fee_amt, fee_curr, nbr_installments, threshold, generate_freq, gen_date_list_id, last_generate_date, next_generate_date, day_of_month, start_day_month, end_day_month, card_scheme)
             values ('$inst_id','$non_act_fee_pkg_id_var', 'I','$tid_to_use', '$mas_code_to_use', '$fee_amount', '840','1','0', 'D','0', to_date(to_char(sysdate, 'DD-MON-YYYY')||' 12:00:00 AM', 'DD-MON-YYYY HH:MI:SS AM'), to_date('$next_gen_date','DD-MON-YYYY HH:MI:SS AM'), '0', '0', '0', '$card_scheme_var');"

        MASCLR::print_to_file_name $fee_output_file_name "\n"

        MASCLR::print_to_file_name $fee_output_file_name "insert into ent_nonact_fee_pkg (institution_id, entity_id, non_act_fee_pkg_id, start_date,end_date, inc_child_ent_flag) values('$inst_id', '$ent_id', '$non_act_fee_pkg_id_var', to_date(to_char(sysdate, 'DD-MON-YYYY')||' 12:00:00 AM', 'DD-MON-YYYY HH:MI:SS AM'),to_date('$fee_end_date','DD-MON-YYYY HH:MI:SS AM'), 'N');"

        MASCLR::print_to_file_name $fee_output_file_name "\n"

        set cur_line  [split [set orig_line [gets $input_file_id] ] ,]

        append where_clause "$non_act_fee_pkg_id_var"

    }

    append where_clause "))"

    MASCLR::close_file $fee_output_file_name
    lappend files_to_send_list $fee_output_file_name

    MASCLR::print_to_file_name $verification_file_name "select"
    MASCLR::print_to_file_name $verification_file_name "    substr(enfp.institution_id,1,4) Inst,"
    MASCLR::print_to_file_name $verification_file_name "    substr(enfp.entity_id, 1, 15) entity_id,"
    MASCLR::print_to_file_name $verification_file_name "    substr(ae.entity_dba_name,1,25) entity_dba_name,"
    MASCLR::print_to_file_name $verification_file_name "    to_char(naf.fee_amt, '999,999.99') Amt_planned,"
    MASCLR::print_to_file_name $verification_file_name "    CASE WHEN naf.tid like '%5' THEN 'Cr'"
    MASCLR::print_to_file_name $verification_file_name "                                else 'Db'"
    MASCLR::print_to_file_name $verification_file_name "    END   DbCr,"
    MASCLR::print_to_file_name $verification_file_name "    to_char("
    MASCLR::print_to_file_name $verification_file_name "    CASE WHEN mtl.tid is null THEN naf.next_generate_date"
    MASCLR::print_to_file_name $verification_file_name "                              else mtl.gl_date"
    MASCLR::print_to_file_name $verification_file_name "    END, 'DD-MON-YY')   gen_date,"
    MASCLR::print_to_file_name $verification_file_name "    --naf.tid,"
    MASCLR::print_to_file_name $verification_file_name "    --naf.mas_code,"
    MASCLR::print_to_file_name $verification_file_name "    --naf.last_generate_date,"
    MASCLR::print_to_file_name $verification_file_name "    --naf.next_generate_date,"
    MASCLR::print_to_file_name $verification_file_name "    --mtl.entity_id,"
    MASCLR::print_to_file_name $verification_file_name "    --mtl.tid,"
    MASCLR::print_to_file_name $verification_file_name "    substr(naf.mas_code,1,12) m_c,"
    MASCLR::print_to_file_name $verification_file_name "    substr(mc.mas_desc,1,29) descr,"
    MASCLR::print_to_file_name $verification_file_name "    to_char(mtl.amt_billing, '999,999.99')  amt,"
    MASCLR::print_to_file_name $verification_file_name "    mtl.tid_settl_method DbCr,"
    MASCLR::print_to_file_name $verification_file_name "    to_char(mtl.date_to_settle, 'DD-MON-YY') settle,"
    MASCLR::print_to_file_name $verification_file_name "    --mtl.gl_date GL,"
    MASCLR::print_to_file_name $verification_file_name "    enfp.non_act_fee_pkg_id n_a_f_p"
    MASCLR::print_to_file_name $verification_file_name "from ent_nonact_fee_pkg enfp"
    MASCLR::print_to_file_name $verification_file_name ""
    MASCLR::print_to_file_name $verification_file_name "join  non_activity_fees naf"
    MASCLR::print_to_file_name $verification_file_name "on enfp.institution_id = naf.institution_id"
    MASCLR::print_to_file_name $verification_file_name "and enfp.non_act_fee_pkg_id = naf.non_act_fee_pkg_id"
    MASCLR::print_to_file_name $verification_file_name ""
    MASCLR::print_to_file_name $verification_file_name "join mas_code mc"
    MASCLR::print_to_file_name $verification_file_name "on naf.mas_code = mc.mas_code"
    MASCLR::print_to_file_name $verification_file_name ""
    MASCLR::print_to_file_name $verification_file_name "join acq_entity ae"
    MASCLR::print_to_file_name $verification_file_name "on enfp.institution_id = ae.institution_id"
    MASCLR::print_to_file_name $verification_file_name "and enfp.entity_id = ae.entity_id"
    MASCLR::print_to_file_name $verification_file_name ""
    MASCLR::print_to_file_name $verification_file_name "left outer join mas_trans_log mtl"
    MASCLR::print_to_file_name $verification_file_name "on enfp.institution_id = mtl.institution_id"
    MASCLR::print_to_file_name $verification_file_name "and enfp.non_act_fee_pkg_id = mtl.non_act_fee_pkg_id"
    MASCLR::print_to_file_name $verification_file_name "and enfp.entity_id = mtl.posting_entity_id"
    MASCLR::print_to_file_name $verification_file_name ""
    MASCLR::print_to_file_name $verification_file_name "where"
    MASCLR::print_to_file_name $verification_file_name "\n"
    MASCLR::print_to_file_name $verification_file_name " $where_clause "
    MASCLR::print_to_file_name $verification_file_name ";"

    MASCLR::close_file $verification_file_name
    lappend files_to_send_list $verification_file_name

    set seq_ctrl_update_file_name "1t-seq_ctrl_update-[clock format [clock seconds] -format "%Y%m%d%H%M%S"].sql"
    generate_seq_ctrl_update_file $seq_ctrl_update_file_name
    lappend files_to_send_list $seq_ctrl_update_file_name

    MASCLR::close_file $input_file_name

    send_file $files_to_send_list {clearing@jetpay.com} {"One time fees"} "One time fees generated on $MASCLR::CURRENT_EF_DB_DATE"

    oraclose $masclr_cursor_query1
    oraclose $masclr_cursor_query2

}

proc generate_seq_ctrl_update_file { seq_ctrl_update_file_name } {

    if { [catch {
        MASCLR::open_file $seq_ctrl_update_file_name

        MASCLR::print_to_file_name $seq_ctrl_update_file_name "REM Run this script last, from transqa, so the seq_ctrl table is updated.  "

        foreach inst_id {121} {
            # set update_seq_ctrl_dev_sql "update seq_ctrl@masclr_transd
            #     set LAST_SEQ_NBR =
            #     (select LAST_SEQ_NBR from seq_ctrl @masclr_trnclr1 where SEQ_NAME = 'non_act_fee_pkg_id' and institution_id = '$inst_id')
            #     where SEQ_NAME = 'non_act_fee_pkg_id' and institution_id = '$inst_id';"
            #     MASCLR::print_to_file_name $seq_ctrl_update_file_name $update_seq_ctrl_dev_sql

            set update_seq_ctrl_prod_sql "update seq_ctrl
            set LAST_SEQ_NBR =
            (select LAST_SEQ_NBR from seq_ctrl @masclr_trnclr1 where SEQ_NAME = 'non_act_fee_pkg_id' and institution_id = '$inst_id')
            where SEQ_NAME = 'non_act_fee_pkg_id' and institution_id = '$inst_id';"
            MASCLR::print_to_file_name $seq_ctrl_update_file_name $update_seq_ctrl_prod_sql
        }

        MASCLR::close_file "$seq_ctrl_update_file_name"

    } failure] } {
        error $failure
    }
    ###
}  ;# generate_seq_ctrl_update_file
    ###

proc add_tid_to_settl_plan { tid_to_add settl_plan_id institution_id billing_type settle_frequency } {

}

proc get_next_nonact_fee_pkg_id { inst_id the_cursor } {

    set the_sql "select LAST_SEQ_NBR from seq_ctrl where institution_id = '$inst_id' and SEQ_NAME = 'non_act_fee_pkg_id'"
    if { [catch {set package_id [MASCLR::fetch_single_value $the_cursor $the_sql]} failure ] } {
        error "$failure"
    }

    set id_available 0
    while {$id_available == 0} {

        set the_sql "select count(1) from non_act_fee_pkg where institution_id = $inst_id and non_act_fee_pkg_id = '$package_id'"
        if { [catch {set id_in_use_var [MASCLR::fetch_single_value $the_cursor $the_sql]} failure ] } {
            error "$failure"
        }

        if { $id_in_use_var == 0 } {
            set id_available 1
        }
        incr package_id
    }

    set the_sql "update seq_ctrl set LAST_SEQ_NBR = '$package_id' where institution_id = '$inst_id'
        and seq_name = 'non_act_fee_pkg_id'"
    if { [catch {MASCLR::update_record $the_cursor $the_sql} failure] } {
        error $failure
        MASCLR::log_message $failure
    }
    if { [MASCLR::get_affected_rows $the_cursor] != 1 } {
        set failure "Expected to update 1 row.  [MASCLR::get_affected_rows $the_cursor] rows affected instead."
        MASCLR::log_message $failure
        error $failure
    }

    return $package_id
    ###
}  ;# get_next_nonact_fee_pkg_id
    ###

proc check_output_filename {file_name_root seq_nbr extension} {

    if {[file exists $file_name_root.$seq_nbr.$extension] } {
        MASCLR::log_message  "Found file $file_name_root.$seq_nbr.$extension.  Generating a unique file name"

        set duplicate_file_name 1
        while { $duplicate_file_name == 1 } {
            set seq_nbr [expr [scan $seq_nbr "%d"] + 1]
            set seq_nbr [format %03s $seq_nbr]
            set duplicate_file_name [file exists $file_name_root.$seq_nbr.$extension]
        }
        MASCLR::log_message  "Using file $file_name_root.$seq_nbr.$extension"

    }
    return $file_name_root.$seq_nbr.$extension
    ###
}  ;# check_output_filename
    ###

#######################
# should check return value
# and log an error if there is a problem sending
# should also send a simple message (no attachment, etc) with mailx if mutt fails
#######################
proc send_file { file_to_send_list email_to_list {email_subject ""} {email_body ""}  } {

    set attachment_string ""
    if { [ llength $file_to_send_list ] } {
        foreach filename $file_to_send_list {
            if { [ file exists $filename ] } {
                append attachment_string "-a $filename "
            }
        }

    }

    set mailpipe [open "| mutt -s $email_subject $attachment_string -- $email_to_list" w ]
    if { [info exists mailpipe] } {
        if { [ catch {
            if { [file exists $email_body] } {
                set email_body_file_id [open $email_body]
                puts $mailpipe [read $email_body_file_id]
            } else {
                #parameter is plain text
                puts $mailpipe $email_body
            }
            close $mailpipe
        } result ] } {
            MASCLR::log_message  $result
            return 1
        }
    }
    return 0
    ###
}  ;# send_file
    ###

###########################
# creates an array called arguments that has each
# argument name as an array key and the argument value as that
# key's value
proc parse_arguments {} {
    global argv
    foreach {argument value} $argv {
        set arguments($argument) $value
    }

    # standard arguments
    if { [info exists arguments(--help)] || [info exists arguments(-h)] } {
        usage_statement
    }
    ###
}  ;# parse_arguments
    ###

#################################################################
# main
#################################################################

proc main {} {
    global argv seq_ctrl_update_file_name fee_output_file verification_query_file_name

    parse_arguments

    #initialize global variables
    if { [catch {setup} failure] } {
        MASCLR::log_message "setup failed: $failure"
        MASCLR::close_all_and_exit_with_code 1
    }

    set fee_handle_name "FEE_HANDLE"
    set DB $env(IST_DB)

    # log in to trncl1 because have to update package IDs
    set fee_login_data "masclr/masclr@$DB"
    if { [catch {set fee_handle [MASCLR::open_db_connection $fee_handle_name $fee_login_data ]} failure] } {
        error "Could not open database handle: $failure"
    }
    if { [catch {set fee_cursor [MASCLR::open_cursor $fee_handle]} failure] } {
        error "$failure"
    }

    set report_seq [format %03s 1]
    set fee_output_file "1t-combined-one-time-fees-[clock format [clock seconds] -format "%Y%m%d%H%M%S"]"
    set fee_output_file [check_output_filename $fee_output_file $report_seq "sql"]
    MASCLR::open_file $fee_output_file

    set verification_seq [format %03s 1]
    set verification_query_file_name "1t-verification_query_file-[clock format [clock seconds] -format "%Y%m%d%H%M%S"]"
    set verification_query_file_name [check_output_filename $verification_query_file_name $verification_seq "sql" ]
    MASCLR::open_file $verification_query_file_name

    if { [catch {gather_values_from_fee_file $fee_handle $fee_output_file $verification_query_file_name} failure]} {
        MASCLR::log_message "Error: $failure"
        catch {MASCLR::perform_rollback $fee_handle } failure2

        MASCLR::log_message "Rolling back: $failure2"
        MASCLR::close_all_and_exit_with_code 1
    } else {

        if { [catch {MASCLR::perform_commit $fee_handle} failure] } {
            error "Could not commit changes: $failure"
        }
    }

    if { [catch {MASCLR::close_cursor $fee_cursor} failure] } {
        MASCLR::log_message "$failure"
        MASCLR::close_all_and_exit_with_code 0
    }

after 10000
exec mv $seq_ctrl_update_file_name ./ARCHIVE
exec mv $fee_output_file ./ARCHIVE
exec mv $verification_query_file_name ./ARCHIVE
exec cp feefile.txt ./ARCHIVE/feefile-[clock format [clock seconds] -format "%Y%m%d%H%M%S"].txt
    MASCLR::close_all_and_exit_with_code 0

}

###############
# Run proc main
###############
main
