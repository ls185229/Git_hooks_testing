#!/usr/bin/env tclsh
#/clearing/filemgr/.profile


package require Oratcl


    global GLOBALS(WAIVE_MIN_ENTITY_LIST)
    global IST_DB

################################################################################
# setup
# set default values for global variables
# these may change depending on arguments to the script
# change any script-specific defaults here
# such as the log file to use
# or a specific config file, etc.
################################################################################

proc setup {} {

    global GLOBALS

    global SUCCESS_CODES

    set GLOBALS(DEBUG) 0

    global env IST_DB
    set IST_DB $env(IST_DB)
    set AUTH_DB $env(ATH_DB)

    global DATABASE_LOGIN_DATA
    set DATABASE_LOGIN_DATA(MASCLR) "masclr/masclr@$IST_DB"
    set DATABASE_LOGIN_DATA(CORE) "boardqa/boardqa1@$AUTH_DB"


    set GLOBALS(LOG_FILE_HANDLE) stderr

    global OPEN_FILES

    # OPEN_FILES is an array with file handles as keys and file names as the values


#    set GLOBALS(LOG_FILE_NAME) "LOGS/MULTI.monmincheck.log"

    set GLOBALS(FEE_LIST) ""

    set GLOBALS(WAIVE_LIST_FILE_NAME) "month_min_waive_list.txt"


    set SUCCESS_CODES(SUCCESS) 0
    set SUCCESS_CODES(DB_ERROR) 1
    set SUCCESS_CODES(IO_ERROR) 5
    set SUCCESS_CODES(MAIL_ERROR) 7
    set SUCCESS_CODES(INVALID_ARGUMENTS) 22
    set SUCCESS_CODES(HELP) 0



    set box $env(SYS_BOX)
    set clrpath $env(CLR_OSITE_ROOT)
    set maspath $env(MAS_OSITE_ROOT)
    set mailtolist $env(MAIL_TO)
    set mailfromlist $env(MAIL_FROM)
    set clrdb $env(IST_DB)
    set authdb $env(ATH_DB)

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

}



################################################################################
# open db connections -- this only opens the logon handle
# individual procs are responsible for their cursors
# database logon handles are passed around in an array
# the array subscripts refer to the logon handle "name".
# dereference the array subscript to get the logon handle, like this:
# set masclr_logon_handle "MASCLR_REPORT"
#    set db_login_data "blah/blah@trnclr4"
#    open_db_connection $masclr_logon_handle $db_login_data
# later open a cursor like this:
#    some_proc $DATABASE_LOGON_HANDLES($masclr_logon_handle)
#    inside some_proc
#    oraopen $parameter_name_that_received_the_logon_handle
################################################################################
proc open_db_connection { handle_name login_data } {
    global SUCCESS_CODES
    global GLOBALS
    global DATABASE_LOGON_HANDLES

    log_message $GLOBALS(LOG_FILE_HANDLE) "Opening database connection $handle_name"
    if {[catch {set new_logon_handle [oralogon $login_data]} result]} {
        log_message $GLOBALS(LOG_FILE_HANDLE) "Could not open database connections.  Result: $result"
        return $SUCCESS_CODES(DB_ERROR)
    }

    set DATABASE_LOGON_HANDLES($handle_name) $new_logon_handle

    return $SUCCESS_CODES(SUCCESS)
}


################################################################################
# close db connections -- this only closes the logon handle
################################################################################
proc close_db_connections {} {
    global SUCCESS_CODES
    global GLOBALS
    global DATABASE_LOGON_HANDLES

    set flat_logon_handles [array get DATABASE_LOGON_HANDLES]
    foreach {handle_name handle} $flat_logon_handles {
        oralogoff $handle
        log_message $GLOBALS(LOG_FILE_HANDLE) "Closing database connection $handle_name"
    }

    return $SUCCESS_CODES(SUCCESS)
}




################################################################################
# exit_with_code
# tries to gracefully close all db connections
# tried to gracefully close all open files

################################################################################
proc exit_with_code { exit_code {exit_message ""} } {
    global command_string
    global GLOBALS
    global OPEN_FILES


    close_db_connections

    close_all_open_files

    log_message $GLOBALS(LOG_FILE_HANDLE) "$exit_message"

    log_message $GLOBALS(LOG_FILE_HANDLE) "Ending $GLOBALS(COMMAND_STRING) with exit code $exit_code"
    puts stderr "Ending $GLOBALS(COMMAND_STRING) with exit code $exit_code"
    set GLOBALS(LOG_FILE_HANDLE) stderr
    log_message $GLOBALS(LOG_FILE_HANDLE) "Closing file $GLOBALS(LOG_FILE_NAME)"
    if {[catch {close $GLOBALS(LOG_FILE_HANDLE)} response]} {
        log_message $GLOBALS(LOG_FILE_HANDLE)  "Cannot close file $GLOBALS(LOG_FILE_NAME).  Changes may not be saved."
    }

    exit $exit_code

}



################################################################################
# open a file (permissions passed in as optional argument)
################################################################################
proc open_file { file_name {permissions "RDWR CREAT TRUNC"} {add_to_open_files_list 1} } {
    global GLOBALS
    global SUCCESS_CODES
    global OPEN_FILES

    # TODO change the file open flags if necessary
    log_message $GLOBALS(LOG_FILE_HANDLE) "Opening file $file_name with permissions $permissions"

    if {[catch {open $file_name $permissions} file_handle]} {
        log_message $GLOBALS(LOG_FILE_HANDLE) "Cannot open file $file_name. "
        return $SUCCESS_CODES(IO_ERROR)
    }

    if { $add_to_open_files_list == 1 } {
        set OPEN_FILES($file_name) $file_handle
    }


    return $file_handle
}



################################################################################
# close a single file
# if the file exists in the OPEN_FILES global array, remove it
################################################################################
proc close_file { file_name } {
    global GLOBALS
    global SUCCESS_CODES
    global OPEN_FILES

    log_message $GLOBALS(LOG_FILE_HANDLE) "Closing file $file_name"

    if {[catch {close $OPEN_FILES($file_name)} response]} {
        log_message $GLOBALS(LOG_FILE_HANDLE) "Cannot close file $file_name.  Changes may not be saved."
        return $SUCCESS_CODES(IO_ERROR) "Cannot close file $file_name.  Changes may not be saved."
    }
    array_remove_subscript OPEN_FILES $file_name
    return $SUCCESS_CODES(SUCCESS)
}




################################################################################
# close all files in the OPEN_FILES array
################################################################################
proc close_all_open_files {} {
    global OPEN_FILES
    global GLOBALS

    set flat_open_files [array get OPEN_FILES]
    foreach { file_name open_file_id } $flat_open_files {
        if { [catch {close_file $file_name} result] } {
            log_result $GLOBALS(LOG_FILE_HANDLE) "Could not close file $file_name"
        } else {
            array_remove_subscript OPEN_FILES $file_name
        }

    }

}


################################################################################
# rebuild an array but omit the given subscript
################################################################################
proc array_remove_subscript { the_array key } {
    upvar $the_array _array

    set flat_array [array get _array]
    array unset _array
    foreach {flat_key value} $flat_array {
        if {$flat_key == $key} continue
        set _array($flat_key) $value
    }

}

################################################################################
# verify the file name that is proposed.  If it already exists, increment the
# sequence number and check to see if that is an unused name. Repeat until a
# unique name is found, then return that unique name.
################################################################################
proc check_output_filename {file_name_root seq_nbr extension} {
    global GLOBALS
    #if { $GLOBALS(DEBUG) == 1} {
    #    log_message $GLOBALS(LOG_FILE_HANDLE) "checking file $file_name_root.$seq_nbr.$extension" 1
    #}
    if {[file exists $file_name_root.$seq_nbr.$extension] } {
        # loop until we come up with a file name that is unique
        log_message $GLOBALS(LOG_FILE_HANDLE) "Found file $file_name_root.$seq_nbr.$extension.  Generating a unique file name"



        set duplicate_file_name 1
        while { $duplicate_file_name == 1 } {

            set seq_nbr [expr [scan $seq_nbr "%d"] + 1]
            set seq_nbr [format %03s $seq_nbr ]
            #if { $GLOBALS(DEBUG) == 1} {
            #    log_message $GLOBALS(LOG_FILE_HANDLE) "checking sequence $seq_nbr" 1
            #}
            set duplicate_file_name [file exists $file_name_root.$seq_nbr.$extension]

        }
        log_message $GLOBALS(LOG_FILE_HANDLE) "Using file $file_name_root.$seq_nbr.$extension"

    }
    return $file_name_root.$seq_nbr.$extension
}



################################################################################
# pass this a list of values such as { AMEX_AUTH DISC_AUTH VISA_AUTH MC_AUTH OTHER_AUTH }
# and the proc returns this: 'AMEX_AUTH', 'DISC_AUTH', 'VISA_AUTH', 'MC_AUTH', 'OTHER_AUTH'
################################################################################
proc split_list_surround_quotes { the_list } {
    return "\'[join [split $the_list " "] "\',\'"]\'"
}


################################################################################
# rather than just puts a message, this provides a formatted message
# leading with date and time like some logging standards use
################################################################################
proc log_message { log_file_id the_message {debug_level 0} } {

    if { $debug_level > 0 } {
        set debug_level "**DEBUG $debug_level**"
    } else {
        set debug_level ""
    }
    if { [catch {puts $log_file_id "[clock format [clock seconds] -format "%D %T"] $debug_level $the_message"} ]} {
        puts stderr "[clock format [clock seconds] -format "%D %T"] $the_message"
    }

}


proc append_to_file { file_id data } {
    global GLOBALS

    if { [catch {puts $file_id $data} result]  } {
        puts stderr "[clock format [clock seconds] -format "%D %T"] Could not write data to $file_id: $result"
    }

}


proc add_key_value_to_array { array_name key value } {
    global GLOBALS
    upvar $array_name arr
    if { [array exists arr] == 0 } {
        array set arr "$key $value"
    } else {
        set arr($key) $value
    }
}

proc append_array_to_list { array_name } {
    global GLOBALS
    #upvar $list_name _list
    upvar $array_name _array
    if {$GLOBALS(DEBUG) == 1} {
        #log_message $GLOBALS(LOG_FILE_HANDLE) "llength: [llength $GLOBALS(FEE_LIST)] adding [array get _array]"
    }

    lappend GLOBALS(FEE_LIST) [array get _array]
}


################################################################################
# get the list of entity IDs that should have their fees waived
################################################################################
proc get_waive_fee_list {} {
    global SUCCESS_CODES
    global GLOBALS
    global OPEN_FILES

    if { [catch {open_file $GLOBALS(WAIVE_LIST_FILE_NAME) "RDONLY"} result] } {
        log_message $GLOBALS(LOG_FILE_HANDLE) "WARNING: Continuing without a waive fee list."
        set GLOBALS(WAIVE_MIN_ENTITY_LIST) {}
        return
    }
    set entities_added 0
    set cur_line  [split [set orig_line [gets $OPEN_FILES($GLOBALS(WAIVE_LIST_FILE_NAME))] ] ,]
    while {$cur_line != ""} {
        lappend GLOBALS(WAIVE_MIN_ENTITY_LIST) $cur_line
        if {$GLOBALS(DEBUG) == 1} {
            log_message $GLOBALS(LOG_FILE_HANDLE) "Found entity with waive fees: $cur_line"
        }
        incr entities_added
        set cur_line  [split [set orig_line [gets $OPEN_FILES($GLOBALS(WAIVE_LIST_FILE_NAME))] ] ,]
    }
    if { $entities_added < 1 } {
        lappend GLOBALS(WAIVE_MIN_ENTITY_LIST) ""
    }

    close_file $GLOBALS(WAIVE_LIST_FILE_NAME)

}

################################################################################
# If invalid arguments are give, give a usage statement
################################################################################
proc usage_statement { exit_code } {

    puts stderr
    puts stderr "Usage: [info script] "
    puts stderr [string repeat " " 10][format "%-30s %-40s" "--inst inst_id" "REQUIRED.  Examples: 101, 107, 105, 811"]
    puts stderr [string repeat " " 10][format "%-30s %-40s" "--month_offset X" "OPTIONAL.  Defaults to 0, which means current month."]
    puts stderr [string repeat " " 10][format "%-30s %-40s" " " "Needs to be a whole number > 0 specifying how many months to look back."]
    puts stderr [string repeat " " 10][format "%-30s %-40s" "--settle_date DD-MON-YY" "REQUIRED.  date_to_settle for the fees to check."]


    puts stderr [string repeat " " 10][format "%-30s %-40s" "--debug \[0|1\]" "OPTIONAL.  Defaults to 0. 1 sets debug logging on.  "]
    puts stderr [string repeat " " 10][format "%-30s %-40s" "--help" "OPTIONAL.  Prints this message and exits with an exit code of 0. "]
    puts stderr "  "
    puts stderr "  "
    exit_with_code $exit_code

}

################################################################################
# creates file name in the necessary format.  uses check_output_filename to
# verify and adjust the file name if necessary to avoid collisions
################################################################################
proc create_output_file_name { institution_id month year } {
    return [check_output_filename "month_end_fee_check.$institution_id.$month.$year" "001" "CSV"]
}


################################################################################
# creates an array called arguments that has each
# argument name as an array key and the argument value as that
# key's value
################################################################################
proc parse_arguments {} {
    global SUCCESS_CODES
    global arguments
    global argv
    global use_input_file
    global use_output_file
    global run_as_test

    global GLOBALS

    foreach {argument value} $argv {
        set arguments($argument) $value
    }


    if { [info exists arguments(--help)] || [info exists arguments(-h)] } {
        usage_statement $SUCCESS_CODES(HELP)
    }

    set GLOBALS(DEBUG) 0

    if { [info exists arguments(--debug)] && [info exists arguments(--debug)] != 0 } {
        if { [string range $arguments(--inst) 0 1] == "--" } {
            usage_statement $SUCCESS_CODES(INVALID_ARGUMENTS)
        }
        set GLOBALS(DEBUG) $arguments(--debug)
    } else {
        set GLOBALS(DEBUG) 1
    }
    log_message $GLOBALS(LOG_FILE_HANDLE) "Setting debug level to $GLOBALS(DEBUG)."

    if { [info exists arguments(--inst)]  } {
        if { [string range $arguments(--inst) 0 1] == "--" } {
            usage_statement $SUCCESS_CODES(INVALID_ARGUMENTS)
        }
        set GLOBALS(INST_ID) $arguments(--inst)
        log_message $GLOBALS(LOG_FILE_HANDLE) "Checking monthly minimums for institution ID $GLOBALS(INST_ID)."
        set GLOBALS(LOG_FILE_NAME) "LOGS/MULTI.monmincheck-$GLOBALS(INST_ID).log"
    } else {

        usage_statement $SUCCESS_CODES(INVALID_ARGUMENTS)
    }


    if { [ info exists arguments(--month_offset)]} {
        if { [string range $arguments(--month_offset) 0 1] == "--"} {
            usage_statement $SUCCESS_CODES(INVALID_ARGUMENTS)
        }

        if {! [string is integer $arguments(--month_offset)] || $arguments(--month_offset) < 0 } {
            usage_statement $SUCCESS_CODES(INVALID_ARGUMENTS)
        }
        set GLOBALS(MONTH_OFFSET) $arguments(--month_offset)
    } else {
        # assume current month
        set GLOBALS(MONTH_OFFSET) 0
    }

    if { [ info exists arguments(--settle_date)]} {
        if { [string range $arguments(--settle_date) 0 1] == "--"} {
            usage_statement $SUCCESS_CODES(INVALID_ARGUMENTS)
        }
        if { [ catch {clock format [clock scan $arguments(--settle_date)]} result] } {
            puts stderr "Invalid Date format $arguments(--settle_date)"
            usage_statement $SUCCESS_CODES(INVALID_ARGUMENTS)
        }

        set GLOBALS(DATE_TO_SETTLE) [string toupper [clock format [clock scan $arguments(--settle_date)] -format "%d-%b-%y"]]

    } else {
        # assume current month
        usage_statement $SUCCESS_CODES(INVALID_ARGUMENTS)
    }


    log_message $GLOBALS(LOG_FILE_HANDLE) "Institution ID: $GLOBALS(INST_ID)"

    set GLOBALS(MONTH) [string toupper [clock format [clock scan "$GLOBALS(MONTH_OFFSET) months ago"] -format "%b"]]
    log_message $GLOBALS(LOG_FILE_HANDLE) "Month: $GLOBALS(MONTH)"
    set GLOBALS(SHORT_YEAR) [clock format [clock scan "$GLOBALS(MONTH_OFFSET) months ago"] -format "%y"]
    log_message $GLOBALS(LOG_FILE_HANDLE) "Short year: $GLOBALS(SHORT_YEAR)"


}



proc find_minimum_activity {} {

}


################################################################################
# find all the fees with a charge_method of M --
# those are the monthly minimum fees or any other potential future fees
# that are based on counted activity
################################################################################
proc find_all_m_fees_for_institution { masclr_logon_handle } {
    global GLOBALS
    global SUCCESS_CODES
    #upvar $fee_list _list

    set masclr_query_cursor [oraopen $masclr_logon_handle]

    set get_entity_list_sql "SELECT ae.institution_id,
        ae.entity_id,
        ae.entity_dba_name,
        ae.entity_name,
        naf.tid,
        naf.mas_code,
        naf.fee_amt,
        naf.item_cnt_plan_id
        FROM masclr.non_activity_fees naf
        JOIN masclr.non_act_fee_pkg nafp ON nafp.institution_id = naf.institution_id
        AND nafp.non_act_fee_pkg_id = naf.non_act_fee_pkg_id
        JOIN masclr.ent_nonact_fee_pkg enfp ON enfp.institution_id = naf.institution_id
        AND enfp.non_act_fee_pkg_id = naf.non_act_fee_pkg_id
        JOIN masclr.acq_entity ae ON naf.institution_id = ae.institution_id
        AND enfp.entity_id = ae.entity_id
        WHERE (ae.termination_date > sysdate or ae.termination_date is null)
        AND ae.entity_status = 'A'
        AND(nafp.fee_end_date > sysdate OR nafp.fee_end_date IS NULL)
        AND(enfp.end_date > sysdate OR enfp.end_date IS NULL)
        AND naf.item_cnt_plan_id IS NOT NULL
        AND naf.fee_amt > 0
        AND naf.charge_method = 'M'
        AND ae.entity_id not in ( [split_list_surround_quotes $GLOBALS(WAIVE_MIN_ENTITY_LIST)] )
        AND naf.institution_id = :institution_id_var
    ORDER BY ae.entity_id"

    if {$GLOBALS(DEBUG) == 1} {
        log_message $GLOBALS(LOG_FILE_HANDLE) $get_entity_list_sql
    }



    if {[catch {
        oraparse $masclr_query_cursor $get_entity_list_sql
        orabind $masclr_query_cursor :institution_id_var $GLOBALS(INST_ID)
        oraexec $masclr_query_cursor

    } result_code]} {
        log_message $GLOBALS(LOG_FILE_HANDLE)  "Error with $get_entity_list_sql"
        log_message $GLOBALS(LOG_FILE_HANDLE)  "[oramsg $masclr_query_cursor rc] [oramsg $masclr_query_cursor error]"
        oraclose $masclr_query_cursor
        return $SUCCESS_CODES(DB_ERROR)
    }
    while {1} {
        if {[catch {orafetch $masclr_query_cursor -dataarray this_action_result_arr -indexbyname} result_code]} {
            log_message $GLOBALS(LOG_FILE_HANDLE)  "Error with $get_entity_list_sql"
            log_message $GLOBALS(LOG_FILE_HANDLE)  "[oramsg $masclr_query_cursor rc] [oramsg $masclr_query_cursor error]"
            # break or exit or ignore
        }

        #if {[oramsg $masclr_query_cursor rc] != 1403} { break; }

        if {[oramsg $masclr_query_cursor rc] != 0} { break; }

        if {$GLOBALS(DEBUG) == 1} {
            log_message $GLOBALS(LOG_FILE_HANDLE) "adding $this_action_result_arr(ENTITY_ID)"
        }

        append_array_to_list this_action_result_arr


    }





    oraclose $masclr_query_cursor
}



################################################################################################################
# main
proc main {} {
    global DATABASE_LOGON_HANDLES
    global OPEN_FILES
    global GLOBALS
    global SUCCESS_CODES
    global argv IST_DB

    set GLOBALS(COMMAND_STRING) "[info script]"
    foreach argument $argv {
        append GLOBALS(COMMAND_STRING) " $argument"
    }

    setup

    parse_arguments

    set GLOBALS(LOG_FILE_HANDLE) [open_file $GLOBALS(LOG_FILE_NAME) {RDWR CREAT APPEND} 0]
    if { $GLOBALS(LOG_FILE_HANDLE) == $SUCCESS_CODES(IO_ERROR) } {
        log_message $GLOBALS(LOG_FILE_HANDLE) "Could not open file $GLOBALS(LOG_FILE_NAME).  Redirecting output to standard out."
        set GLOBALS(LOG_FILE_HANDLE) stdout
    }


    # report the script and its arguments
    log_message $GLOBALS(LOG_FILE_HANDLE) "Beginning $GLOBALS(COMMAND_STRING)"


    set GLOBALS(OUTPUT_FILE_NAME) [create_output_file_name $GLOBALS(INST_ID) $GLOBALS(MONTH) $GLOBALS(SHORT_YEAR) ]


    open_file $GLOBALS(OUTPUT_FILE_NAME)

    append_to_file $OPEN_FILES($GLOBALS(OUTPUT_FILE_NAME)) "\"INSTITUTION $GLOBALS(INST_ID)\",\"$GLOBALS(MONTH)\",\"$GLOBALS(SHORT_YEAR)\""
    append_to_file $OPEN_FILES($GLOBALS(OUTPUT_FILE_NAME)) "\"\",\"\",\"\""


    set masclr_logon_handle "MASCLR_REPORT"
    set db_login_data "masclr/masclr@$IST_DB"
    open_db_connection $masclr_logon_handle $db_login_data


    get_waive_fee_list

    find_all_m_fees_for_institution $DATABASE_LOGON_HANDLES($masclr_logon_handle)

    set item_cnt_plan_det_cursor [oraopen $DATABASE_LOGON_HANDLES($masclr_logon_handle)]
    set mas_trans_log_cursor [oraopen $DATABASE_LOGON_HANDLES($masclr_logon_handle)]
    set find_fee_charged_cursor [oraopen $DATABASE_LOGON_HANDLES($masclr_logon_handle)]
    append_to_file $OPEN_FILES($GLOBALS(OUTPUT_FILE_NAME)) "\"INST ID\",\"ENTITY ID\",\"DBA\",\"FEE TID\",\"MAS CODE\",\"Configured FEE\",\"Calculated fee\",\"$GLOBALS(MONTH) Fee in MAS\",\"Adjustment needed\",\"NOTES\",\"Sum applied to minimum\",\"Before and after confirmation\",\"Before and after confirmation 2\",\"Before and after confirmation 3\",\"update for acct_accum_det\",\"update for mas_trans_log\",\"Update to acct_accum_gldate\",\"Before and after confirmation\",\"Before and after confirmation 2\",\"Before and after confirmation 3\""
    foreach _arr $GLOBALS(FEE_LIST) {
        array set current_fee_information $_arr


        log_message $GLOBALS(LOG_FILE_HANDLE) "Checking $current_fee_information(ENTITY_ID) for $current_fee_information(MAS_CODE) for $GLOBALS(MONTH) $GLOBALS(SHORT_YEAR)"


        set fee_amount_charged 0
        set sum_applied_to_minimum 0
        set found_duplicate_fee 0
        set found_no_fee 0
        set minimum_amount $current_fee_information(FEE_AMT)
        set apply_toward_minimum 0
        set remove_from_minimum 0
        set fee_to_charge 0
        set need_adjustment 0
        set notes ""
        set confirmation1 ""
        set confirmation2 ""
        set confirmation3 ""
        set update_acct_accum_det ""
        set update_mas_trans_log ""
        set update_acct_accum_gldate ""

        puts "$current_fee_information(ENTITY_ID) $current_fee_information(ENTITY_DBA_NAME)"

        # gather the details of that particular item count plan for that fee

        set item_cnt_plan_det_sql "SELECT icpd.institution_id,
                                    icpd.item_cnt_plan_id,
                                    icpd.tid_to_accum,
                                    icpd.mas_code_to_accum,
                                    icpd.tid_src_to_accum,
                                    icpd.card_sch_to_accum,
                                    icpd.curr_code_to_accum,
                                    icpd.cnt_sign,
                                    icpd.amt_method,
                                    icpd.add_amt1_method,
                                    icpd.add_amt2_method,
                                    icpd.cnt_method,
                                    icpd.add_cnt1_method,
                                    icpd.add_cnt2_method
                                  FROM item_cnt_plan_det icpd
                                  WHERE icpd.item_cnt_plan_id = :itm_cnt_plan_id_var
                                  and icpd.institution_id = :institution_id_var
                                  order by cnt_sign"

        if {[catch {
                oraparse $item_cnt_plan_det_cursor $item_cnt_plan_det_sql
                orabind $item_cnt_plan_det_cursor :institution_id_var $current_fee_information(INSTITUTION_ID) :itm_cnt_plan_id_var $current_fee_information(ITEM_CNT_PLAN_ID)
                oraexec $item_cnt_plan_det_cursor

            } result_code]} {
                log_message $GLOBALS(LOG_FILE_HANDLE)  "Error with $item_cnt_plan_det_sql"
                log_message $GLOBALS(LOG_FILE_HANDLE)  "[oramsg $item_cnt_plan_det_cursor rc] [oramsg $item_cnt_plan_det_cursor error]"
                oraclose $item_cnt_plan_det_cursor
                return $SUCCESS_CODES(DB_ERROR)
            }
#        if {[catch {orasql $item_cnt_plan_det_cursor $item_cnt_plan_det_sql} result_code]} {
#            log_message $GLOBALS(LOG_FILE_HANDLE) "Error with $item_cnt_plan_det_sql"
#            log_message $GLOBALS(LOG_FILE_HANDLE) "[oramsg $item_cnt_plan_det_cursor rc] [oramsg $item_cnt_plan_det_cursor error]"
#            exit_with_code $SUCCESS_CODES(DB_ERROR)
#        }
#        if {[catch {orasql $item_cnt_plan_det_cursor $item_cnt_plan_det_sql} result_code]} {
#            log_message $GLOBALS(LOG_FILE_HANDLE)  "Error with $item_cnt_plan_det_sql"
#            log_message $GLOBALS(LOG_FILE_HANDLE)  "[oramsg $item_cnt_plan_det_cursor rc] [oramsg $item_cnt_plan_det_cursor error]"
#            oraclose $item_cnt_plan_det_cursor
#            exit_with_code $SUCCESS_CODES(DB_ERROR)
#        }
        while {1} {



            if {[catch {orafetch $item_cnt_plan_det_cursor -dataarray item_cnt_plan_det_arr -indexbyname} result_code]} {
                log_message $GLOBALS(LOG_FILE_HANDLE)  "Error with $this_action_sql"
                log_message $GLOBALS(LOG_FILE_HANDLE)  "[oramsg $item_cnt_plan_det_cursor rc] [oramsg $$item_cnt_plan_det_cursor error]"
                # break or exit or ignore
            }


            if {[oramsg $item_cnt_plan_det_cursor rc] != 0} { break; }

            # for each detail record of the item count plan, find the transactions in mas_trans_log that match those details
        # have to use like for mas_code because of the way the item count plan stores mas codes
            set mas_trans_log_sum_sql "SELECT SUM(amt_original)
                                        FROM masclr.mas_trans_log
                                        WHERE gl_date between to_date(:gl_date_var,'DD-MON-YY') and last_day(to_date(:gl_date_var,'DD-MON-YY'))
                                         AND tid = :tid_var
                                         AND ( mas_code like :mas_code_var
                                            OR substr(mas_code,0,4) = :mas_code_var)
                                         AND tid_src = :tid_src_var
                                         AND card_scheme = :card_scheme_var
                                         AND curr_cd_original = :curr_cd_var
                                         AND posting_entity_id = :entity_id_var
                                         AND institution_id = :institution_id_var
                    AND payment_seq_nbr in (select payment_seq_nbr from acct_accum_det where settl_date >= to_date(:gl_date_var,'DD-MON-YY'))"



            if {[catch {
                            #puts ":institution_id_var $current_fee_information(INSTITUTION_ID) :tid_var $item_cnt_plan_det_arr(TID_TO_ACCUM) :mas_code_var $item_cnt_plan_det_arr(MAS_CODE_TO_ACCUM) :tid_src_var $item_cnt_plan_det_arr(TID_SRC_TO_ACCUM) :card_scheme_var $item_cnt_plan_det_arr(CARD_SCH_TO_ACCUM) :curr_cd_var $item_cnt_plan_det_arr(CURR_CODE_TO_ACCUM) :entity_id_var $current_fee_information(ENTITY_ID) :gl_date_var 01-$GLOBALS(MONTH)-$GLOBALS(SHORT_YEAR) "
                            oraparse $mas_trans_log_cursor $mas_trans_log_sum_sql
                            orabind $mas_trans_log_cursor :institution_id_var $current_fee_information(INSTITUTION_ID) :tid_var $item_cnt_plan_det_arr(TID_TO_ACCUM) :mas_code_var $item_cnt_plan_det_arr(MAS_CODE_TO_ACCUM) :tid_src_var $item_cnt_plan_det_arr(TID_SRC_TO_ACCUM) :card_scheme_var $item_cnt_plan_det_arr(CARD_SCH_TO_ACCUM) :curr_cd_var $item_cnt_plan_det_arr(CURR_CODE_TO_ACCUM) :entity_id_var $current_fee_information(ENTITY_ID) :gl_date_var 01-$GLOBALS(MONTH)-$GLOBALS(SHORT_YEAR)
                            oraexec $mas_trans_log_cursor

                        } result_code]} {
                            log_message $GLOBALS(LOG_FILE_HANDLE)  "Error with $mas_trans_log_sum_sql"
                            log_message $GLOBALS(LOG_FILE_HANDLE)  "[oramsg $mas_trans_log_cursor rc] [oramsg $mas_trans_log_cursor error]"
                            oraclose $mas_trans_log_cursor
                            return $SUCCESS_CODES(DB_ERROR)
                        }
#            if {[catch {orasql $mas_trans_log_cursor $mas_trans_log_sum_sql} result_code]} {
#                log_message $GLOBALS(LOG_FILE_HANDLE) "Error with $mas_trans_log_sum_sql"
#                log_message $GLOBALS(LOG_FILE_HANDLE) "[oramsg $mas_trans_log_cursor rc] [oramsg $mas_trans_log_cursor error]"
#                exit_with_code $SUCCESS_CODES(DB_ERROR)
#            }
            if {[orafetch $mas_trans_log_cursor -datavariable amt_original_var] != 0} {
                log_message $GLOBALS(LOG_FILE_HANDLE) "Error with $mas_trans_log_sum_sql"
                log_message $GLOBALS(LOG_FILE_HANDLE) "[oramsg $mas_trans_log_cursor rc] [oramsg $mas_trans_log_cursor error]"
                exit_with_code $SUCCESS_CODES(DB_ERROR)
            }


            # if the item count plan has this item as a +, apply it to the minimum
            if { $item_cnt_plan_det_arr(CNT_SIGN) == "+"} {
                set apply_toward_minimum [ expr $apply_toward_minimum + $amt_original_var ]
                log_message $GLOBALS(LOG_FILE_HANDLE) "Adding $amt_original_var for $item_cnt_plan_det_arr(TID_TO_ACCUM) $item_cnt_plan_det_arr(MAS_CODE_TO_ACCUM) $item_cnt_plan_det_arr(TID_SRC_TO_ACCUM)"
            } else {
                # add the sum of the items to the amount to remove from the minimum
                set remove_from_minimum [ expr $remove_from_minimum + $amt_original_var ]
                log_message $GLOBALS(LOG_FILE_HANDLE) "Subtracting $amt_original_var for $item_cnt_plan_det_arr(TID_TO_ACCUM) $item_cnt_plan_det_arr(MAS_CODE_TO_ACCUM) $item_cnt_plan_det_arr(TID_SRC_TO_ACCUM)"
            }
        }

        if { $remove_from_minimum > $apply_toward_minimum } {
            append notes "Discount is not high enough to cover interchange and assessment"
            set sum_applied_to_minimum 0
        } else {
            set sum_applied_to_minimum [expr $remove_from_minimum - $apply_toward_minimum]
        }

        set fee_to_charge [expr $current_fee_information(FEE_AMT) - $apply_toward_minimum + $remove_from_minimum ]

        if { $fee_to_charge < 0 } {
            set fee_to_charge 0
        }

        set find_fee_charged_sql "SELECT trans_seq_nbr, amt_original
                                    FROM masclr.mas_trans_log
                                    WHERE gl_date LIKE :gl_date_var
                                     AND tid = :tid_var
                                     AND mas_code = :mas_code_var
                                     AND trunc(date_to_settle) = to_date(:date_to_settle, 'DD-MON-YY')
                                     AND posting_entity_id = :entity_id_var
                                     AND institution_id = :institution_id_var "
        if { $GLOBALS(DEBUG) == 1 } {
            puts $find_fee_charged_sql

        }
        if {[catch {
                                    oraparse $find_fee_charged_cursor $find_fee_charged_sql
                                    orabind $find_fee_charged_cursor :institution_id_var $current_fee_information(INSTITUTION_ID) :tid_var $current_fee_information(TID) :mas_code_var $current_fee_information(MAS_CODE) :entity_id_var $current_fee_information(ENTITY_ID) :date_to_settle $GLOBALS(DATE_TO_SETTLE) :gl_date_var %-$GLOBALS(MONTH)-$GLOBALS(SHORT_YEAR)%
                                    oraexec $find_fee_charged_cursor

                                } result_code]} {
                                    log_message $GLOBALS(LOG_FILE_HANDLE)  "Error with $mas_trans_log_sum_sql"
                                    log_message $GLOBALS(LOG_FILE_HANDLE)  "[oramsg $find_fee_charged_cursor rc] [oramsg $find_fee_charged_cursor error]"
                                    oraclose $find_fee_charged_cursor
                                    return $SUCCESS_CODES(DB_ERROR)
                                }
#        if {[catch {orasql $find_fee_charged_cursor $find_fee_charged_sql} result_code]} {
#            log_message $GLOBALS(LOG_FILE_HANDLE) "Error with $find_fee_charged_sql"
#            log_message $GLOBALS(LOG_FILE_HANDLE) "[oramsg $find_fee_charged_cursor rc] [oramsg $find_fee_charged_cursor error]"
#            exit_with_code $SUCCESS_CODES(DB_ERROR)
#        }
        if {[orafetch $find_fee_charged_cursor -dataarray fee_amount_charged_arr -indexbyname] == 1403} {
            log_message $GLOBALS(LOG_FILE_HANDLE) "No fee found for $current_fee_information(MAS_CODE)"
            set fee_amount_charged 0
            set found_no_fee 1

        } else {
            set fee_amount_charged $fee_amount_charged_arr(AMT_ORIGINAL)
            #check to see if more than one fee was charged

        }
        if {[orafetch $find_fee_charged_cursor -dataarray fee_amount_charged_dup_check_arr -indexbyname] != 1403} {
            set need_adjustment 1
            set found_duplicate_fee 1
            append notes "Found multiple $current_fee_information(MAS_CODE) fees with date_to_settle LIKE '$GLOBALS(DATE_TO_SETTLE)%'"
            log_message $GLOBALS(LOG_FILE_HANDLE) $notes
            set fee_amount_charged [ expr $fee_amount_charged + $fee_amount_charged_dup_check_arr(AMT_ORIGINAL)]

        }



        log_message $GLOBALS(LOG_FILE_HANDLE) "Fee to charge: $fee_to_charge; Fee charged $fee_amount_charged"
        set adjustment_needed_sum [expr $fee_to_charge - $fee_amount_charged]
        if { $fee_to_charge != $fee_amount_charged} {
            if { $adjustment_needed_sum >= 0 } {
                set need_adjustment 0

            } else {
                set need_adjustment 1
            }

        }

        # found a fee, needs adjustment, no duplicate fee
        if { $need_adjustment == 1 && $found_duplicate_fee == 0 && $found_no_fee == 0 } {
            set confirmation1 "select tid_settl_method, sum(amt_original) from mas_trans_log where (institution_id, payment_seq_nbr) in (select institution_id, payment_seq_nbr from mas_trans_log where institution_id = '$current_fee_information(INSTITUTION_ID)' and trans_seq_nbr = '$fee_amount_charged_arr(TRANS_SEQ_NBR)') and settl_flag = 'Y' group by tid_settl_method;"
            set confirmation2 "select INSTITUTION_ID,ENTITY_ACCT_ID,SETTL_DATE,PAYMENT_PROC_DT,PAYMENT_SEQ_NBR,AMT_PAY,AMT_FEE,AMT_PAY_GL,AMT_FEE_GL,payment_status from acct_accum_det where (institution_id, payment_seq_nbr) in  (select institution_id, payment_seq_nbr from mas_trans_log where institution_id = '$current_fee_information(INSTITUTION_ID)' and trans_seq_nbr = '$fee_amount_charged_arr(TRANS_SEQ_NBR)'); "
            set confirmation3 "select INSTITUTION_ID,ENTITY_ACCT_ID,GL_DATE,PAYMENT_SEQ_NBR,ENTITY_ID,AMT_PAY,AMT_FEE from masclr.acct_accum_gldate where (institution_id, payment_seq_nbr,trunc(gl_date)) in (select institution_id, payment_seq_nbr,trunc(gl_date) from mas_trans_log where institution_id = '$current_fee_information(INSTITUTION_ID)' and trans_seq_nbr = '$fee_amount_charged_arr(TRANS_SEQ_NBR)');"
            if { $adjustment_needed_sum > 0 } {
                set update_acct_accum_det "update acct_accum_det SET amt_fee =(amt_fee + $adjustment_needed_sum   ),   amt_fee_gl =(amt_fee_gl + $adjustment_needed_sum   ) WHERE(institution_id,   payment_seq_nbr) IN   (SELECT institution_id,      payment_seq_nbr    FROM mas_trans_log    WHERE institution_id = '$current_fee_information(INSTITUTION_ID)'    AND trans_seq_nbr = '$fee_amount_charged_arr(TRANS_SEQ_NBR)') ;"
            } else {
                set update_acct_accum_det "update acct_accum_det SET amt_fee =(amt_fee + $adjustment_needed_sum   ),   amt_fee_gl =(amt_fee_gl + $adjustment_needed_sum   ) WHERE(institution_id,   payment_seq_nbr) IN   (SELECT institution_id,      payment_seq_nbr    FROM mas_trans_log    WHERE institution_id = '$current_fee_information(INSTITUTION_ID)'    AND trans_seq_nbr = '$fee_amount_charged_arr(TRANS_SEQ_NBR)') ;"
            }

            set update_mas_trans_log "update mas_trans_log set amt_original = $fee_to_charge,amt_billing = $fee_to_charge where institution_id = '$current_fee_information(INSTITUTION_ID)' and trans_seq_nbr = '$fee_amount_charged_arr(TRANS_SEQ_NBR)';"
            if { $adjustment_needed_sum > 0 } {
                set update_acct_accum_gldate "update masclr.acct_accum_gldate SET amt_fee =(amt_fee + $adjustment_needed_sum   )  WHERE(institution_id,   payment_seq_nbr,   TRUNC(gl_date)) IN   (SELECT institution_id,      payment_seq_nbr,      TRUNC(gl_date)    FROM mas_trans_log    WHERE institution_id = '$current_fee_information(INSTITUTION_ID)'    AND trans_seq_nbr = '$fee_amount_charged_arr(TRANS_SEQ_NBR)') ;"
            } else {
                set update_acct_accum_gldate "update masclr.acct_accum_gldate SET amt_fee =(amt_fee + $adjustment_needed_sum   )  WHERE(institution_id,   payment_seq_nbr,   TRUNC(gl_date)) IN   (SELECT institution_id,      payment_seq_nbr,      TRUNC(gl_date)    FROM mas_trans_log    WHERE institution_id = '$current_fee_information(INSTITUTION_ID)'    AND trans_seq_nbr = '$fee_amount_charged_arr(TRANS_SEQ_NBR)') ;"
            }
        # found no fee, needs adjustment
        } elseif { $need_adjustment == 1 && $found_duplicate_fee == 1 || $found_no_fee == 1} {
            set update_acct_accum_det "Need manual adjustment."
            set update_mas_trans_log "Need manual adjustment."
            set update_acct_accum_gldate "Need manual adjustment."
        }


        # include $sum_applied_to_minimum as last column
        append_to_file $OPEN_FILES($GLOBALS(OUTPUT_FILE_NAME)) "\"\'$current_fee_information(INSTITUTION_ID)\'\",\"\'$current_fee_information(ENTITY_ID)\'\",\"$current_fee_information(ENTITY_DBA_NAME)\",\"\'$current_fee_information(TID)\'\",\"$current_fee_information(MAS_CODE)\",\"$current_fee_information(FEE_AMT)\",\"$fee_to_charge\",\"$fee_amount_charged\",\"$adjustment_needed_sum\",\"$notes\",\"$sum_applied_to_minimum\",\"$confirmation1\",\"$confirmation2\",\"$confirmation3\",\"$update_acct_accum_det\",\"$update_mas_trans_log\",\"$update_acct_accum_gldate\",\"$confirmation1\",\"$confirmation2\",\"$confirmation3\""

    }


    # do stuff

    oraclose $item_cnt_plan_det_cursor
    oraclose $mas_trans_log_cursor

    exit_with_code $SUCCESS_CODES(SUCCESS) "Final message"

}


main
