#!/usr/bin/env tclsh

##############################################################################
#
# File Name:  ach_day.tcl
#
# Description:  This script determines if the current day is not a bank
#               holiday.
#
# Running options: Usually run from bankday.sh with no options.
#
# Shell Arguments:  inst_id = Institution ID.  Required.
#                   d = Date. [format YYYYMMDD]Optional field
#
# Output:       The return code determines the next step.
#
# Return:   0 = Success (this is a weekday and not a holiday)
#           1 = Exit with errors (this is either a weekend or a holiday)
#
##############################################################################

# get standard commands from a lib file
source $env(MASCLR_LIB)/masclr_tcl_lib
lappend auto_path $env(MASCLR_LIB)
package require GetOpts 1.1

## Global Variable ##
global programName

set programName [file tail $argv0]

proc usage {} {
    global programName
    puts stderr "Usage: $programName -i institution_id -d date"
    puts stderr "       where -i is a Institution_Id (Eg: 101, 105, 107 ... etc.)"
    puts stderr "       where -d is a date in YYYYMMDD format (Eg: 20160919 - September 19 2016)"
    puts stderr "Example:  $programName -i101 -d 20160919"
    exit 1
}

proc arg_parse {} {
    global argv argv0
    global inst_id t_date
    set inst_id ""
    set t_date ""

    while { [ set err [ getopt $argv "d:hi:" opt optarg ]] } {
        if { $err < 0 } then {
            MASCLR::log_message "error: $argv0 : opt $opt, optarg: $optarg "
            usage
            exit 1
        } else {
            MASCLR::log_message "opt: $opt, optarg: $optarg" 1
            switch -exact $opt {
               i {set inst_id $optarg}
               d {set t_date $optarg}
               h {
                    usage
                    exit 1
                }
            }
        }
    }
}

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
    global inst_id t_date

        ### open cursor
    set select_cursor ""
    if { [catch {set select_cursor [MASCLR::open_cursor $database_handle]} failure] } {
        set message "Could not open cursor: $failure"
        error $message
    }

    set check_ach_date_sql "select hlst.holiday_key, hlst.holiday_date,
            hlst.Holiday_desc, hlnk.description
        from MASCLR.inst_calendar ical
        join MASCLR.calendar cal on ical.calendar_id = cal.calendar_id
        join MASCLR.holiday_list hlst on cal.holiday_key = hlst.holiday_key
        join MASCLR.holiday_link hlnk on cal.holiday_key = hlnk.holiday_key
        where ical.INSTITUTION_ID = '$inst_id'
        and ical.CAL_ACTIVITY_ID = 'DELIVERY-DAYS'
        and ical.USAGE = 'MAS_PAY'
        and trunc(hlst.holiday_date) = to_date($t_date,'yyyymmdd')"

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
    arg_parse
    global inst_id t_date
    if {[string length $inst_id] <= 0} {
        usage
        exit 1
    }
    if { [string length $t_date] <= 0 } {
        set t_date [ clock format [clock scan "-0 day"] -format %Y%m%d]
        MASCLR::log_message "Using default system date: $t_date" 1
    }
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
        set clrdb_user $env(IST_DB_USERNAME)
        set clrdb_pass $env(IST_DB_PASSWORD)
        set ach_date_checker_login_data "$clrdb_user/$clrdb_pass@$clrdb"
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
