#!/usr/bin/env tclsh

##############################################################################
# $Id: ach_day.tcl 2973 2015-06-22 17:30:15Z bjones $
##############################################################################
#
# File Name:  ach_day.tcl
#
# Description:  This script determines if the current day is not a bank
#               holiday.
#
# Running options: Usually run from bankday.sh with no options.
#
# Shell Arguments:  none
#
# Output:       The return code determines the next step.
#
# Return:   0 = Success (this is a weekday and not a holiday)
#           1 = Exit with errors (this is either a weekend or a holiday)
#
##############################################################################

# get standard commands from a lib file
source $env(MASCLR_LIB)/masclr_tcl_lib

proc setup {} {
    global argv
    ### specify a log file to log within the tcl script
    ### or (the normal) just leave this call to an empty
    ### string and logging will go to stdout and redirect
    ### to the log file specified in the calling script
    MASCLR::open_log_file ""

    MASCLR::set_debug_level 0
    MASCLR::parse_arguments $argv

    MASCLR::set_script_alert_level "HIGH"
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

proc check_ach_date { database_handle } {
    set success 0

        ### open cursor
    set select_cursor ""
    if { [catch {set select_cursor [MASCLR::open_cursor $database_handle]} failure] } {
        set message "Could not open cursor: $failure"
        error $message
    }

        ### set query
    set check_ach_date_sql "select hlst.holiday_key, hlst.holiday_date,
            hlst.Holiday_desc, hlnk.description
        from holiday_list hlst
        join holiday_link hlnk on hlst.holiday_key = hlnk.holiday_key
        where hlst.holiday_date = trunc(sysdate)"
        ### start fetch
    if { [catch {MASCLR::start_fetch $select_cursor $check_ach_date_sql} failure] } {
        set message "Could not start fetch with orasql: $failure"
        error $message
    }

    set found_error 0
    set check_ach_date_message ""

    while { [MASCLR::get_cursor_status $select_cursor] == $MASCLR::HAS_MORE_RECORDS } {
        ### loop through records until no more records to fetch
            ### do something with each record
            ### with this particular query, I should get no records
        array set new_record [MASCLR::fetch_record $select_cursor]
        if { [MASCLR::get_cursor_status $select_cursor] == $MASCLR::HAS_MORE_RECORDS } {
            incr found_error
            set message "Today is $new_record(HOLIDAY_DESC) on list $new_record(DESCRIPTION)"
            MASCLR::log_message $message
            #append check_ach_date_message "\n$message"
        }
    }

        ### close cursor
    catch {MASCLR::close_cursor $select_cursor} failure

    if { $found_error > 0 } {
        set success 1
    } else {
        set message "Not a holiday"
        MASCLR::log_message $message
    }

    return $success
    ###
}   ;# check_ach_date
    ###

proc main {} {
    global env
    set success 0

    if { [catch {setup} failure] } {
        MASCLR::log_message "setup failed: $failure"
        MASCLR::close_all_and_exit_with_code 1
    }

    set weekday [clock format [clock seconds] -format  "%w"]

    if { $weekday == 0 || $weekday == 6} {
        # is Saturday or Sunday
        set message "Saturday or Sunday"
        MASCLR::log_message $message
        set success 1
    } else {

        set clrdb $env(IST_DB)
        set ach_date_checker_login_data "masclr/masclr@$clrdb"
        if { [catch {set ach_date_checker_handle [MASCLR::open_db_connection "ACH_DATE_CHECKER" $ach_date_checker_login_data]} failure] } {
            MASCLR::log_message $failure
            MASCLR::close_all_and_exit_with_code 1
        }

        if { [catch {set success [check_ach_date $ach_date_checker_handle]} failure ] } {
            catch {MASCLR::perform_rollback $ach_date_checker_handle} rollback_failure
            MASCLR::log_message "$failure\nRolling back:\n$rollback_failure"
            set success 1
        }
    }

    MASCLR::close_all_and_exit_with_code $success

    ###
}   ;# main
    ###

main


