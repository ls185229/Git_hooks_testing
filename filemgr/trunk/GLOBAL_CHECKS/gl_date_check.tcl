#!/usr/bin/env tclsh

# $Id: gl_date_check.tcl 3420 2015-09-11 20:05:17Z bjones $

# get standard commands from a lib file
source $env(MASCLR_LIB)/masclr_tcl_lib

proc setup {} {
    global argv
	### specify a log file to log within the tcl script
	### or (the normal) just leave this call to an empty 
	### string and logging will go to stdout and redirect
	### to the log file specified in the calling script
    MASCLR::open_log_file ""
    MASCLR::parse_arguments $argv

    MASCLR::set_script_alert_level "URGENT"
    MASCLR::set_debug_level 1
    MASCLR::live_updates

        ### if you want to see the sql that would be used
        ###     or manually run the sql updates yourself
        ###     turn on save_updates_to_file 
        ### live_updates and save_updates_to_file just 
        ###     toggle a flag on and off
        ### if an out_sql_file_name is not set, a default
        ###     will be used
    #MASCLR::set_out_sql_file_name "masclr_test.sql"
    #MASCLR::save_updates_to_file

    MASCLR::set_up_dates
    ###
}   ;# setup
    ###

proc check_gl_date { database_handle } {
    set success 0

        ### open cursor
    set select_cursor ""
    if { [catch {set select_cursor [MASCLR::open_cursor $database_handle]} failure] } {
        set message "Could not open cursor: $failure"
        error $message
    }

        ### set query
    set check_gl_date_sql "SELECT institution_id, trunc(gl_date) as gl_date, count(1)
            FROM masclr.gl_chart_of_acct
            WHERE institution_id in ([MASCLR::split_list_surround_quotes $MASCLR::MAS_INSTITUTIONS])
            and trunc(gl_date) != trunc(sysdate + 1)
            GROUP BY institution_id, gl_date" 
        ### start fetch
    if { [catch {MASCLR::start_fetch $select_cursor $check_gl_date_sql} failure] } {
        set message "Could not start fetch with orasql: $failure"
        error $message
    }

    set found_error 0

    set check_gl_date_message ""

    while { [MASCLR::get_cursor_status $select_cursor] == $MASCLR::HAS_MORE_RECORDS } {
        ### loop through records until no more records to fetch
            ### do something with each record
            ### with this particular query, I should get no records
        array set new_record [MASCLR::fetch_record $select_cursor]
        if { [MASCLR::get_cursor_status $select_cursor] == $MASCLR::HAS_MORE_RECORDS } {
            incr found_error 
            set message "Institution $new_record(INSTITUTION_ID) has a gl date set to $new_record(GL_DATE)"
            MASCLR::log_message $message
            append check_gl_date_message "\t$message\n"
        }


    }


        ### close cursor
    catch {MASCLR::close_cursor $select_cursor} failure

    if { $found_error > 0 } {
        MASCLR::log_message "Found $found_error error(s).\n$check_gl_date_message"
        set success 1
        set email_subject "GL Export did not complete" 
        set email_body "The check for GL Export found these errors:\n$check_gl_date_message" 
        MASCLR::send_alert_email $email_subject $email_body 
    } else {
        set message "GL Export check found no errors."
        MASCLR::log_message $message
        MASCLR::send_quick_info_email $message $message
    }
    
    return $success
    ###
}   ;# check_gl_date
    ###




proc main {} {
    global env
    set success 0

    if { [catch {setup} failure] } {
        MASCLR::log_message "setup failed: $failure"
        MASCLR::close_all_and_exit_with_code 1 
    }

    set gl_date_checker_login_data "masclr/masclr@$env(IST_DB)"
    if { [catch {set gl_date_checker_handle [MASCLR::open_db_connection "GL_DATE_CHECKER" $gl_date_checker_login_data]} failure] } {
        MASCLR::log_message $failure
        MASCLR::close_all_and_exit_with_code 1
    } 

    if { [catch {set success [check_gl_date $gl_date_checker_handle]} failure ] } {
        catch {MASCLR::perform_rollback $gl_date_checker_handle} rollback_failure
        MASCLR::log_message "$failure\nRolling back:\n$rollback_failure"
        set success 1
    }
    
    MASCLR::close_all_and_exit_with_code $success

    ###
}   ;# main
    ###


main
