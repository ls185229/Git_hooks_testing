#!/usr/bin/env tclsh

package require Oratcl



########################
# setup
# set default values for global variables
# these may change depending on arguments to the script
# change any script-specific defaults here
# such as the log file to use
# or a specific config file, etc.
########################

proc setup {} {
    
    global GLOBALS


    set GLOBALS(DEBUG) 0


    global STD_OUT_CHANNEL
    set STD_OUT_CHANNEL stdout

    global env
    set SYSTEM $env(SYS_BOX)
    
    # if running on production, the db link will be empty
    set GLOBALS(MASCLR_DB_LINK) ""
    set MASCLR_DB $env(SEC_DB)

    # if running on the QA server, setup a db link to production
#    if { $SYSTEM == "QA" || $SYSTEM == "DEV" } {
#        set GLOBALS(MASCLR_DB_LINK) "@masclr_trnclr1"
#    }
    
    global DATABASE_LOGIN_DATA
    set DATABASE_LOGIN_DATA(MASCLR_REPORT) "masclr/masclr@$MASCLR_DB"
    
    
    set GLOBALS(LOG_FILE_HANDLE) stderr

    # OPEN_FILES is an array with file handles as keys and file names as the values
    global OPEN_FILES
    
    
    set GLOBALS(LOG_FILE_NAME) "LOGS/MERRICK.DDA.REPORT.RUN.log"

    global SUCCESS_CODES
    set SUCCESS_CODES(SUCCESS) 0
    set SUCCESS_CODES(DB_ERROR) 1
    set SUCCESS_CODES(IO_ERROR) 5
    set SUCCESS_CODES(MAIL_ERROR) 7
    set SUCCESS_CODES(INVALID_ARGUMENTS) 22
    set SUCCESS_CODES(HELP) 0
    

}

# utility procs
proc check_output_filename {file_name_root seq_nbr extension} {
    global GLOBALS
 
    if {[file exists $file_name_root.$seq_nbr.$extension] } {
        # loop until we come up with a file name that is unique
        log_message $GLOBALS(LOG_FILE_HANDLE) "Found file $file_name_root.$seq_nbr.$extension.  Generating a unique file name"
        
        set duplicate_file_name 1
        while { $duplicate_file_name == 1 } {
            
            set seq_nbr [expr [scan $seq_nbr "%d"] + 1]
            set seq_nbr [format %03s $seq_nbr]
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



################################################################################
# rebuild an array but omit the given subscript
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
# creates an array called arguments that has each
# argument name as an array key and the argument value as that
# key's value
################################################################################
proc parse_arguments {} {
    global SUCCESS_CODES
    global argv
    global GLOBALS

    foreach {argument value} $argv {
        set arguments($argument) $value
    }
    
    
    if { [info exists arguments(--help)] || [info exists arguments(-h)] } {
        usage_statement $SUCCESS_CODES(HELP)
    }
    
    
    
    
    if { [info exists arguments(--debug)] && [info exists arguments(--debug)] != 0 } {
        if { [string range $arguments(--debug) 0 1] == "--" } {
            usage_statement $SUCCESS_CODES(INVALID_ARGUMENTS)
        }
        set GLOBALS(DEBUG) $arguments(--debug)
    } else {
        set GLOBALS(DEBUG) 0
    }
    log_message $GLOBALS(LOG_FILE_HANDLE) "Setting debug level to $GLOBALS(DEBUG)."
    
    
    if { [ info exists arguments(--date_offset)]} {
        if { [string range $arguments(--date_offset) 0 1] == "--"} {
            usage_statement $SUCCESS_CODES(INVALID_ARGUMENTS)
        }
        
        if {! [string is integer $arguments(--date_offset)] || $arguments(--date_offset) > 0 } {
            usage_statement $SUCCESS_CODES(INVALID_ARGUMENTS)
        }
        set GLOBALS(DATE_OFFSET) $arguments(--date_offset)
    } else {
        # assume current date
        set GLOBALS(DATE_OFFSET) 0
    }
    
    set GLOBALS(REPORT_DATE) [string toupper [clock format [clock scan "$GLOBALS(DATE_OFFSET) days"] -format "%d-%h-%y"]]
    
    
    log_message $GLOBALS(LOG_FILE_HANDLE) "Start date: $GLOBALS(REPORT_DATE)"
    

}

################################################################################
# If invalid arguments are give, give a usage statement
################################################################################
proc usage_statement { exit_code } {
    
    puts stderr 
    puts stderr "Usage: [info script] "
    
    puts stderr [string repeat " " 10][format "%-30s %-40s" "--date_offset X" "OPTIONAL.  Defaults to 0, which means current day."]
    puts stderr [string repeat " " 10][format "%-30s %-40s" " " "Needs to be a whole number <= 0 specifying how many days ago to report on."]    
    puts stderr [string repeat " " 10][format "%-30s %-40s" "--debug \[0|1\]" "OPTIONAL.  Defaults to 0. 1 sets debug logging on.  "]
    puts stderr [string repeat " " 10][format "%-30s %-40s" "--help" "OPTIONAL.  Prints this message and exits with an exit code of 0. "]
    puts stderr "  "
    puts stderr "  "
    exit_with_code $exit_code

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
# open a file (permissions passed in as argument)
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
# exit_with_code
proc exit_with_code { exit_code {exit_message ""} } {
    global command_string
    global GLOBALS
    global OPEN_FILES


    close_db_connections

    close_all_open_files

    #set flat_open_files [array get OPEN_FILES]
    #foreach {open_file file_name} $flat_open_files {
    #    close_file $open_file $file_name
    #}


    log_message $GLOBALS(LOG_FILE_HANDLE) "$exit_message"


    log_message $GLOBALS(LOG_FILE_HANDLE) "Ending $GLOBALS(COMMAND_STRING) with exit code $exit_code"

    set GLOBALS(LOG_FILE_HANDLE) stderr
    if { [info exists GLOBALS(LOG_FILE_NAME)]} {
        log_message $GLOBALS(LOG_FILE_HANDLE) "Closing file $GLOBALS(LOG_FILE_NAME)"
        if {[catch {close $GLOBALS(LOG_FILE_HANDLE)} response]} {
            log_message $GLOBALS(LOG_FILE_HANDLE)  "Cannot close file $GLOBALS(LOG_FILE_NAME).  Changes may not be saved."
        }

    }
    
    exit $exit_code

}

################################################################################
# close the output file
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

proc main {} {
    global GLOBALS
    global OPEN_FILES
    global argv
    setup
    log_message $GLOBALS(LOG_FILE_HANDLE) "" 
    
    
    set GLOBALS(COMMAND_STRING) "[info script]"
    foreach argument $argv {
        append GLOBALS(COMMAND_STRING) " $argument"
    }   
    
    # report the script and its arguments
    log_message $GLOBALS(LOG_FILE_HANDLE) "Called $GLOBALS(COMMAND_STRING)"
    
    parse_arguments
    # need to get a date to start from.  This will be the beginning date in the sql query
    # this is going to be a negative number that specified the number of days ago to use as the start date.
    
    #set merrick_entity_ids "'101', '107'"
    
    set report_extension "csv"
    set report_name_root "UPLOAD/MERRICK.DDA.REPORT.$GLOBALS(REPORT_DATE)"
    set report_seq [format %03s 1]
    set report_name [string toupper [check_output_filename $report_name_root $report_seq $report_extension]]
    open_file $report_name
    
    puts $OPEN_FILES($report_name) "\"Visa ID\",\"Account usage\",\"Effective Change Date\",\"Original ABA\",\"Original DDA\",\"New ABA\",\"New DDA\""
    
    # array index is the entity ID + date
    #puts $report_name "\"Visa ID\",\"Account usage\",\"Effective Change Date\",\"Original ABA\",\"New ABA\",\"Original DDA\",\"New DDA\""
    set old_aba_index 0
    set aba_index 1
    set old_dda_index 2
    set dda_index 3
    
    set changes_found 0
    
    
    global DATABASE_LOGIN_DATA
    global DATABASE_LOGON_HANDLES
    
    set masclr_handle_name "MASCLR_REPORT"
    #set db_login_data "masclr/masclr@$report_db"
    
    
    open_db_connection $masclr_handle_name $DATABASE_LOGIN_DATA(MASCLR_REPORT)
    
    set masclr_cursor [oraopen $DATABASE_LOGON_HANDLES($masclr_handle_name)]
    set masclr_cursor_inner_loop [oraopen $DATABASE_LOGON_HANDLES($masclr_handle_name)]
    #log_message $GLOBALS(LOG_FILE_HANDLE) "Start date: $GLOBALS(REPORT_DATE)"
    
    set get_account_id_list "SELECT a.institution_id,
        ea.owner_entity_id,
        a.entity_acct_id,
        ea.acct_posting_type,
        ea.entity_acct_desc,
        a.trans_routing_nbr,
        a.acct_nbr,
        TRUNC(payment_proc_dt),
        (SELECT MAX(TRUNC(payment_proc_dt))
        FROM masclr.payment_log$GLOBALS(MASCLR_DB_LINK) c
        WHERE a.institution_id = c.institution_id
        AND a.entity_acct_id = c.entity_acct_id
        AND a.trans_routing_nbr != c.trans_routing_nbr
        AND a.acct_nbr != c.acct_nbr)
        \"last_date_for_old_dda\"
        FROM masclr.payment_log$GLOBALS(MASCLR_DB_LINK) a
        join masclr.entity_acct$GLOBALS(MASCLR_DB_LINK) ea on a.institution_id = ea.institution_id
        and a.entity_acct_id = ea.entity_acct_id
        WHERE(a.institution_id,   a.entity_acct_id) IN
        (SELECT b.institution_id,
        b.entity_acct_id
        FROM
        (SELECT DISTINCT a.institution_id,
        a.entity_acct_id,
        a.trans_routing_nbr,
        a.acct_nbr
        FROM masclr.payment_log$GLOBALS(MASCLR_DB_LINK) a
        WHERE a.settl_routing_nbr = '124384602')
        b
        GROUP BY b.institution_id,
        b.entity_acct_id HAVING COUNT(1) > 1)
        AND TRUNC(payment_proc_dt) LIKE TRUNC(to_date('$GLOBALS(REPORT_DATE)', 'DD-MON-YY'))
        and (SELECT MAX(TRUNC(payment_proc_dt))
        FROM masclr.payment_log$GLOBALS(MASCLR_DB_LINK) c
        WHERE a.institution_id = c.institution_id
        AND a.entity_acct_id = c.entity_acct_id
        AND a.trans_routing_nbr != c.trans_routing_nbr
        AND a.acct_nbr != c.acct_nbr) is not null
        GROUP BY a.institution_id,
        ea.owner_entity_id,
        a.entity_acct_id,
        ea.acct_posting_type,
        ea.entity_acct_desc,
        a.trans_routing_nbr,
        a.acct_nbr,
        TRUNC(payment_proc_dt)
        ORDER BY a.institution_id,
        a.entity_acct_id,
        MAX(TRUNC(payment_proc_dt)) DESC"
    if { $GLOBALS(DEBUG) == 1 } {
        log_message $GLOBALS(LOG_FILE_HANDLE) "Running $get_account_id_list" 1
    }
    
    if {[catch {orasql $masclr_cursor $get_account_id_list} result_code]} {
        log_message $GLOBALS(LOG_FILE_HANDLE) "Error with $get_account_id_list"
        log_message $GLOBALS(LOG_FILE_HANDLE) "[oramsg $masclr_cursor rc] [oramsg $masclr_cursor error]"
        exit_with_code 1 "Error with $get_account_id_list.\n\n[oramsg $masclr_cursor rc] [oramsg $masclr_cursor error]"
        
    }
    
    while {1} {
        if {[catch {orafetch $masclr_cursor -dataarray account_id_arr -indexbyname} result_code]} {
            log_message $GLOBALS(LOG_FILE_HANDLE) "Error with $get_account_id_list"
            log_message $GLOBALS(LOG_FILE_HANDLE) "[oramsg $masclr_cursor rc] [oramsg $masclr_cursor error]"
            # break or exit or ignore
        }
        if {[oramsg $masclr_cursor rc] != 0} break
        
        # this gives us a list of accounts that have changed at SOME point.
        # need to check the account used with the last payment before this one.
        # if that is different, report the change.
        # if the account used with the previous payment is the same, ignore.
        if { $GLOBALS(DEBUG) == 1 } {
            log_message $GLOBALS(LOG_FILE_HANDLE) "Checking $account_id_arr(OWNER_ENTITY_ID) $account_id_arr(ENTITY_ACCT_DESC)" 1
        }
        set select_last_payment_sql "select trans_routing_nbr, acct_nbr from masclr.payment_log$GLOBALS(MASCLR_DB_LINK) where
            payment_proc_dt = 
            (select 
            max(payment_proc_dt) 
            from masclr.payment_log$GLOBALS(MASCLR_DB_LINK)
            where trunc(payment_proc_dt) < TRUNC(to_date('$GLOBALS(REPORT_DATE)', 'DD-MON-YY'))
            and institution_id = '$account_id_arr(INSTITUTION_ID)'
            and entity_acct_id = '$account_id_arr(ENTITY_ACCT_ID)')
            and institution_id = '$account_id_arr(INSTITUTION_ID)'
            and entity_acct_id = '$account_id_arr(ENTITY_ACCT_ID)'"
        
        if {[catch {orasql $masclr_cursor_inner_loop $select_last_payment_sql} result_code]} {
            log_message $GLOBALS(LOG_FILE_HANDLE)  "Error with $select_last_payment_sql"
            log_message $GLOBALS(LOG_FILE_HANDLE)  "[oramsg $masclr_cursor_inner_loop rc] [oramsg $masclr_cursor_inner_loop error]"
            continue
        }
        while {1} {
            
            if {[catch {orafetch $masclr_cursor_inner_loop -dataarray last_payment_arr -indexbyname} result_code]} {
                log_message $GLOBALS(LOG_FILE_HANDLE)  "Error with $select_last_payment_sql"
                log_message $GLOBALS(LOG_FILE_HANDLE)  "[oramsg $masclr_cursor_inner_loop rc] [oramsg $$masclr_cursor_inner_loop error]"
                # break or exit or ignore
            }
            
            # do something when no rows returned
            
            if {[oramsg $masclr_cursor_inner_loop rc] != 0} { break; }
            
            if { $last_payment_arr(TRANS_ROUTING_NBR) !=  $account_id_arr(TRANS_ROUTING_NBR) && $last_payment_arr(ACCT_NBR) != $account_id_arr(ACCT_NBR) } {
                # report this
                #puts $report_name "\"Visa ID\",\"Account usage\",\"Effective Change Date\",\"Original ABA\",\"New ABA\",\"Original DDA\",\"New DDA\""
                puts $OPEN_FILES($report_name) "\"$account_id_arr(OWNER_ENTITY_ID)\",\"$account_id_arr(ENTITY_ACCT_DESC)\",\"$GLOBALS(REPORT_DATE)\",\"$last_payment_arr(TRANS_ROUTING_NBR)\",\"$account_id_arr(TRANS_ROUTING_NBR)\",\"$last_payment_arr(ACCT_NBR)\",\"$account_id_arr(ACCT_NBR)\""
                incr changes_found 
                
            }
            
        }
        
    }
    
    
    log_message $GLOBALS(LOG_FILE_HANDLE) "Found $changes_found changes."
    
    if { $changes_found == 0 } {
        # close file,
        
        if { $GLOBALS(DEBUG) == 1 } {
            log_message $GLOBALS(LOG_FILE_HANDLE) "Closing file to rename it." 1
        }
        close_file $report_name
        
        
        # rename it,
        # insert "no-changes" into file name before the csv extension
        # move straight to the archive directory
        set report_name_root [string replace $report_name_root [string first "UPLOAD/" $report_name_root] [string first "/" $report_name_root] "ARCHIVE/"]
        log_message $GLOBALS(LOG_FILE_HANDLE) "Changed file name root to $report_name_root"
        
        
        set new_extension "NO-CHANGES"
        set new_name [check_output_filename $report_name_root $report_seq $new_extension]
        log_message $GLOBALS(LOG_FILE_HANDLE) "Changed file name to $new_name"
        
        file rename -- $report_name $new_name
    
    }
    
    
    oraclose $masclr_cursor 
    oraclose $masclr_cursor_inner_loop 
    
    
    exit_with_code 0 "Finished report for $GLOBALS(REPORT_DATE)"
    

}


main


