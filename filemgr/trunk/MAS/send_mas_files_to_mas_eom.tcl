#!/usr/bin/env tclsh

# $Id: send_mas_files_to_mas_eom.tcl 3594 2015-12-01 21:19:30Z bjones $

# get standard commands from a lib file
source $env(MASCLR_LIB)/mas_process_lib.tcl

    ### The MASCLR::monitor_clearing_export_status proc requires these two procs
    ### to be defined in the THIS namespace
namespace eval THIS {
    proc get_max_time_for_file_import { file_name } {
        return $THIS::MAX_TIME_FOR_FILE_IMPORT
    }
    proc get_notify_time_for_file_import { file_name } {
        return $THIS::NOTIFY_TIME_FOR_FILE_IMPORT
    }
}

proc setup {} {
    global argv
    MASCLR::open_log_file ""

    MASCLR::add_argument inst_id i [list ARG_REQ ARG_HAS_VAL]
    MASCLR::parse_arguments $argv

    MASCLR::set_script_alert_level "CRITICAL"
    MASCLR::set_debug_level 0
    MASCLR::live_updates

    global env
    namespace eval THIS {
        variable MAX_TIME_FOR_FILE_IMPORT 5400
        variable NOTIFY_TIME_FOR_FILE_IMPORT 3600


        variable ARCHIVE_DIRECTORY [file join [pwd] ARCHIVE]
        variable FILE_HOLD_DIRECTORY [file join [pwd] MAS_FILES]
        variable FILE_PERMISSION_FLAGS "0755"
        variable MAS_FILE_MASK "$MASCLR::SCRIPT_ARGUMENTS(INST_ID)"
        append MAS_FILE_MASK {\.[[:alnum:]]{8}\.01\.[[:digit:]]{4}\.[[:digit:]]{3}}
        variable FILE_LIST ""

        variable REPORT_MESSAGE ""
    }

    MASCLR::set_up_dates
###
}   ;# setup
###

    ### Just copy the file given as the parameter
    ### keep original permissions (use cp -p)
proc copy_file_to_in_directory { file_name } {
    set target_file_name [file join $MASCLR::MAS_IN_DIRECTORY [file tail $file_name]]
    ## set logfile LOG/send_ftp_in.log
    MASCLR::log_message "(copy) source file name to $file_name" 2
    MASCLR::log_message "(copy) set target file name to $target_file_name"
    if { [catch {
            file copy $file_name $target_file_name
            ## MASCLR::log_message "exec send_ftp_in.exp -v -v -v -l $logfile -f ~/scripts/send_ftp_in.cfg $file_name "
            ## exec send_ftp_in.exp -v -v -v -l $logfile -f ~/scripts/send_ftp_in.cfg $file_name
            } failure] } {
        set message "Could not copy file $file_name to $target_file_name: $failure"
        error $message
    } else {
        return $MASCLR::PROC_SUCCESS
    }
###
}   ;# copy_file_to_in_directory
###

proc move_file_to_archive { file_name } {
    set target_file_name "[file join $THIS::ARCHIVE_DIRECTORY [file tail $file_name]]-[MASCLR::get_date_with_format [clock format [clock seconds]] $MASCLR::DT_AUTH]"
    MASCLR::log_message "(move) set target archive file name to $target_file_name" 1
    if { [catch {file rename $file_name $target_file_name} failure] } {
        set message "Could not rename file $file_name to $target_file_name: $failure"
        error $message
    } else {
        return $MASCLR::PROC_SUCCESS
    }
###
}  ;# move_file_to_archive
###

proc set_permissions_on_file { file_name } {
    MASCLR::log_message "Setting permissions on $file_name"
    if { [catch {file attributes $file_name -permissions $THIS::FILE_PERMISSION_FLAGS} failure] } {
        set message "Could not set permissions on file $file_name: $failure"
        ### this is not a fatal error -- if permissions become a problem, this will show up when the file times out
        MASCLR::log_message $message
    } else {
        return $MASCLR::PROC_SUCCESS
    }
###
}  ;# set_permissions_on_file
###

proc monitor_file_progress { database_handle file_name start_time } {

    set last_warning "0"
    set elapsed_time [expr [clock seconds] - $start_time]
    set timeout_seconds [THIS::get_max_time_for_file_import $file_name]
    set warning_seconds [THIS::get_notify_time_for_file_import $file_name]

    set keep_running 1

        ### this loop is broken in the following ways:
        ### keep_running is set to 0 by finding the file in the done directory
        ### error breaks out of the loop and the proc when finding the file in the reject directory
        ### error breaks out of the loop and the proc when the elapsed time is greater than the timeout time
        ### error breaks out of the loop and the proc when the elapsed time is greater than the warning time and the file is still in the "in" directory
        ###
        ### the loop continues if the file is still in the process directory
    while { $keep_running } {

            ### stop file will stop everything right away
        MASCLR::check_for_mas_stop_file

        after [expr 1000 * 30]

            ### first case
            ### if this has taken too long
        set elapsed_time [expr [clock seconds] - $start_time]
        MASCLR::log_message "Elapsed time: [format "%.2f" [expr $elapsed_time / 60.0]] minutes"
        if { $elapsed_time > $timeout_seconds } {
            set message "File $file_name has taken longer than [format "%.2f" [expr $elapsed_time / 60.0]] minutes to import.  Timeout has been triggered and no other files are being sent to MAS.  If MAS is still working on the file, watch this manually until the file is done.  Then this script can be run again."
            error $message
        }
        if { $elapsed_time > $warning_seconds } {
            if { [MASCLR::check_mas_in_directory $file_name] } {
                ### mas still hasn't picked up the file after the warning time
                ### so something is wrong
                set message "MAS has not picked up the file [file tail $file_name].  The file name is wrong, file recognition has not been turned on, or MAS is not running."
                MASCLR::log_message $message
                error $message
            }
            ### send info email once every 10 minutes
            if { $last_warning == "" ||  [expr [clock seconds] - $last_warning ] > [expr 60 * 10] } {
                ### send info email
                set subject "MAS file $file_name still importing"
                set body "MAS file $file_name is not yet done after [format "%.2f" [expr $elapsed_time / 60.0]] minutes."
                MASCLR::log_message $body
                MASCLR::send_quick_info_email $subject $body
                set last_warning [clock seconds]
            }

        }

            ### second case
            ### check to see if MAS moved the file to reject
            ### in the case of a duplicate file name, this will be tricky
            ### the reject directory will need to be cleaned out regularly
        if { [MASCLR::check_for_mas_file_reject $file_name] != $MASCLR::PROC_SUCCESS } {
            set message "MAS rejected the file $file_name.  This may be a duplicate file, so try with a different file name.  Or, this may be a badly formed file or a file out of balance.  Check the MAS logs for more detail."
            error $message
        }
            ### check to see if the file is still in process
        if { [MASCLR::check_mas_process_directory $file_name] } {
            ### still being processed, continue
            continue
        }

            ### check to see if MAS moved the file to done
        if { [MASCLR::check_for_done_mas_file $file_name] && [check_mas_file_balance $database_handle $file_name $elapsed_time] } {
            ### time to break out of the loop
            set keep_running 0
        }

    }

    return $MASCLR::PROC_SUCCESS
###
}  ;# monitor_file_progress
###


    ### this will make sure the file is all the way in to mas_trans_log before proceeding or checking for suspends
    ### this compares the file's count/amount in mas_file_log to the sum in mas_trans_log
    ### and adds the amount from trans_suspend and error
    ### once those are in balance, then proceed.
    ### otherwise, wait until MAS is finished inserting into the tables.
proc check_mas_file_balance { database_handle mas_file elapsed_time } {
    set select_cursor ""
    if { [catch {set select_cursor [MASCLR::open_cursor $database_handle]} failure] } {
        set message "Could not open cursor: $failure"
        error $message
    }
    set bind_vars [dict create :file_name_var [file tail $mas_file]]
    set select_sql "SELECT mfl.institution_id,
          mfl.file_id             ,
          mfl.file_name           ,
          mfl.file_amt            ,
        nvl(SUM(
            CASE WHEN mtl.trans_sub_seq = '0' THEN mtl.amt_original ELSE 0 END), 0)  AS mtl_sum_amount,
        nvl((select sum(
                CASE WHEN trans_sub_seq = '0' THEN amt_original ELSE 0 END)
            from mas_trans_suspend
            where institution_id = mfl.institution_id and file_id = mfl.file_id), 0) AS suspend_amount,
        nvl((select sum(
                CASE WHEN trans_sub_seq = '0' THEN amt_original ELSE 0 END)
            from mas_trans_error
            where institution_id = mfl.institution_id and file_id = mfl.file_id), 0) AS error_amount,
          mfl.file_cnt          ,
        nvl(SUM(
            CASE WHEN mtl.trans_sub_seq = '0' THEN mtl.NBR_OF_ITEMS ELSE 0 END), 0)  AS mtl_count,
        nvl((select sum(
                CASE WHEN trans_sub_seq = '0' THEN NBR_OF_ITEMS ELSE 0 END)
            from mas_trans_suspend
            where institution_id = mfl.institution_id and file_id = mfl.file_id), 0) AS suspend_count,
        nvl((select sum(
                CASE WHEN trans_sub_seq = '0' THEN NBR_OF_ITEMS ELSE 0 END)
            from mas_trans_error
            where institution_id = mfl.institution_id and file_id = mfl.file_id),0)  AS error_count,
          mfl.activity_date_time,
          mfl.file_status       ,
          mfl.receive_date_time
           FROM mas_file_log mfl
        LEFT JOIN mas_trans_log mtl
             ON mtl.institution_id = mfl.institution_id
          AND mfl.file_id          = mtl.file_id
          WHERE file_name = :file_name_var
        GROUP BY mfl.institution_id,
          mfl.file_id              ,
          mfl.file_name            ,
          mfl.file_amt             ,
          mfl.file_cnt             ,
          mfl.activity_date_time   ,
          mfl.file_status          ,
          mfl.receive_date_time"

    if { [catch {array set file_balance [MASCLR::fetch_single_bind_record_as_array $select_cursor $select_sql $bind_vars]} failure] } {
        set message "Could not check file balance for file $mas_file: $failure"
        error $message
    }
    set rows_found [MASCLR::get_affected_rows $select_cursor]
    ### close cursor
    catch {MASCLR::close_cursor $select_cursor} failure

    ### if the file hasn't been added to the file log, yet, then skip this turn
    if { $rows_found == 0 } {
        return 0
    }

    set file_report [format "%s %s %-30s\n\t\t\t\t\
        %25s %-20.2f %11s %-15d\n\t\t\t\t\
        %25s %-20.2f %11s %-15d\n\t\t\t\t\
        %25s %-20.2f %11s %-15d\n\t\t\t\t\
        %25s %-20.2f %11s %-15d" "file_id = '$file_balance(FILE_ID)'" $file_balance(FILE_NAME) "elapsed time: $elapsed_time" \
        "file amount:"  $file_balance(FILE_AMT) "file count:" $file_balance(FILE_CNT) \
        "mas_trans_log amount:" $file_balance(MTL_SUM_AMOUNT) "mtl count:" $file_balance(MTL_COUNT) \
        "mas_trans_suspend amount:" $file_balance(SUSPEND_AMOUNT) "mts count:" $file_balance(SUSPEND_COUNT) \
        "mas_trans_error amount:" $file_balance(ERROR_AMOUNT) "mte count:" $file_balance(ERROR_COUNT) ]

    MASCLR::log_message $file_report


    ### if the file count is equal to the mas_trans_log, mas_trans_error and mas_trans_suspend count sum
    ### and if the file amount is equal to the mas_trans_log, mas_trans_error and mas_trans_suspend amount sum
    ### then return 1 (file is now balanced)
    ### else return 0
    set normalized_count_balance [expr round($file_balance(MTL_COUNT) * 100) + round($file_balance(SUSPEND_COUNT) * 100) + round($file_balance(ERROR_COUNT) * 100)]
    MASCLR::log_message "normalized count balance: $normalized_count_balance" 2
    set normalized_amount_balance [expr round($file_balance(MTL_SUM_AMOUNT) * 100) + round($file_balance(SUSPEND_AMOUNT) * 100) + round($file_balance(ERROR_AMOUNT) * 100) ]
    MASCLR::log_message "normalized amount balance: $normalized_amount_balance" 2
    set normalized_file_amount [expr round($file_balance(FILE_AMT) * 100)]
    MASCLR::log_message "normalized file amount: $normalized_file_amount" 2
    set normalized_file_count [expr round($file_balance(FILE_CNT) * 100)]
    MASCLR::log_message "normalized file count: $normalized_file_count" 2
    if { $normalized_file_count == $normalized_count_balance && $normalized_file_amount == $normalized_amount_balance } {
        append THIS::REPORT_MESSAGE "Progress for $file_report\n\n"
        return $MASCLR::PROC_SUCCESS
    } else {
        return 0
    }
###
}  ;# check_mas_file_balance
###


    ### need an allowed file type list
    ### need
proc find_files_to_send_to_mas { } {
    set full_dir_listing [glob [file join $THIS::FILE_HOLD_DIRECTORY *]]
    foreach f_name $full_dir_listing {
        if { [regexp -- $THIS::MAS_FILE_MASK [file tail $f_name]] } {
            if { [file isfile $f_name] } {
                MASCLR::log_message "Adding $f_name to the list of files"
                lappend THIS::FILE_LIST $f_name
            }
        }
    }
    MASCLR::log_message "Files in file list: $THIS::FILE_LIST"
###
}  ;# find_files_to_send_to_mas
###

proc main {} {

    if { [catch {setup} failure] } {
        MASCLR::log_message "setup failed: $failure"
        MASCLR::close_all_and_exit_with_code $MASCLR::FAILURE_CONDITION
    }
    global env
    set mas_file_mover_login_data "masclr/masclr@$env(IST_DB)"
    if { [catch {set mas_file_mover_handle [MASCLR::open_db_connection "mas_file_mover" $mas_file_mover_login_data]} failure] } {
        MASCLR::log_message $failure
        MASCLR::close_all_and_exit_with_code $MASCLR::FAILURE_CONDITION
    }

    if { [catch {find_files_to_send_to_mas } failure ] } {
        MASCLR::log_message "$failure"
        set success $MASCLR::FAILURE_CONDITION
    }
    append THIS::REPORT_MESSAGE "\nThe following files were found and were queued to be sent to MAS for processing:\n\t[join $THIS::FILE_LIST \n\t]\n\n"

    MASCLR::schedule_file_recognition $mas_file_mover_handle

    if { [catch {
        foreach mas_file $THIS::FILE_LIST {
            ### set permissions on file
            ### copy the file to MAS in directory
            ### move the file to ARCHIVE
            ### watch the file in the MAS directories (in/reject/done/process)
            ### check for suspends or errors
            if { [MASCLR::check_for_done_mas_file $mas_file] } {
                set message "File $mas_file is already in the MAS done directory.  This is a duplicate file.  The script will not send this file to MAS."
                error $message
            }
            MASCLR::check_for_mas_stop_file
            ### if the file is smaller than the bare-bones empty MAS file, skip it and let it move to ARCHIVE
            ### send out a warning.
            set file_size [file size $mas_file]
            MASCLR::log_message "$mas_file is $file_size bytes in size" 2
            if { $file_size < $MASCLR::MIN_MAS_FILE_SIZE } {
                set subject "[file tail $mas_file] is invalid size for a MAS file"
                set body "[file tail $mas_file] is $file_size bytes in size.  This does not appear to be a valid MAS file.  Moving directly to ARCHIVE"
                move_file_to_archive $mas_file
                MASCLR::log_message $body
                MASCLR::send_quick_info_email $subject $body
                continue
            }
                ### start the timer on this file
            set start_time [clock seconds]
            MASCLR::is_mas_busy $mas_file_mover_handle $mas_file $start_time
            ### check to see if MAS is busy.  If it is, wait 30 seconds and check again
            ### do this until the max timeout has been reached.
            MASCLR::log_message "Sending $mas_file to MAS"
            set_permissions_on_file $mas_file
            copy_file_to_in_directory $mas_file
            move_file_to_archive $mas_file
            monitor_file_progress $mas_file_mover_handle $mas_file $start_time
            # No suspend or error checkin during eom run
            #   MASCLR::check_suspend_error $mas_file_mover_handle <
        }
    } failure ] } {
        MASCLR::set_script_alert_level "CRITICAL"
        MASCLR::log_message "Failed sending file to MAS: $failure"
        set subject_line "Send files to MAS for $MASCLR::SCRIPT_ARGUMENTS(INST_ID) progress before error"
        set body "ENGINEER:\nIf files for institution $MASCLR::SCRIPT_ARGUMENTS(INST_ID) are still waiting in $THIS::FILE_HOLD_DIRECTORY after you correct the issue, run this script again from the cron job.\n\nSummary of progress sending files to MAS for $MASCLR::SCRIPT_ARGUMENTS(INST_ID) before error:\n$THIS::REPORT_MESSAGE\nFailed sending file to MAS: $failure"
        MASCLR::log_message $subject_line
        MASCLR::log_message $body 2
        MASCLR::send_alert_email $subject_line $body

        MASCLR::turn_off_file_recognition $mas_file_mover_handle
        MASCLR::close_all_and_exit_with_code $MASCLR::FAILURE_CONDITION
    }
    if { [llength $THIS::FILE_LIST] > 0 } {
        set subject_line "Send files to MAS for $MASCLR::SCRIPT_ARGUMENTS(INST_ID) completed"
        set body "Summary of files sent to MAS for $MASCLR::SCRIPT_ARGUMENTS(INST_ID):\n$THIS::REPORT_MESSAGE"
        MASCLR::log_message $subject_line
        MASCLR::log_message $body 2
        ### Stopped sending emails on normal completion
        ### MASCLR::send_quick_info_email $subject_line $body
    }
    MASCLR::turn_off_file_recognition $mas_file_mover_handle
    MASCLR::close_all_and_exit_with_code $MASCLR::SCRIPT_SUCCESS

    ###
}   ;# main
###

main
