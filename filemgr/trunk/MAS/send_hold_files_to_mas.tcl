#!/usr/bin/env tclsh

# $Id: send_hold_files_to_mas.tcl 2962 2015-06-18 18:27:40Z bjones $

# get standard commands from a lib file
source $env(MASCLR_LIB)/masclr_tcl_lib

proc setup {} {
    global argv
    ### specify a log file to log within the tcl script
    ### or (the normal) just leave this call to an empty 
    ### string and logging will go to stdout and redirect
    ### to the log file specified in the calling script
    MASCLR::open_log_file ""

    MASCLR::add_argument inst_id i [list ARG_REQ ARG_HAS_VAL]
    MASCLR::parse_arguments $argv

    MASCLR::set_script_alert_level "HIGH"
    MASCLR::set_debug_level 1
    MASCLR::live_updates

    global env
    namespace eval THIS {
        variable MIN_FILE_SIZE 115
        variable MAX_TIME_FOR_FILE_IMPORT 1000
        variable NOTIFY_TIME_FOR_FILE_IMPORT 500
        variable MAS_BUSY "BUSY"

        variable MAS_IN_DIRECTORY [file join $env(MAS_OSITE_DATA) in]
        variable MAS_REJECT_DIRECTORY [file join $env(MAS_OSITE_DATA) reject]
        variable MAS_DONE_DIRECTORY [file join $env(MAS_OSITE_DATA) done]
        variable MAS_PROCESS_DIRECTORY [file join $env(MAS_OSITE_DATA) process]

        variable ARCHIVE_DIRECTORY [file join [pwd] ARCHIVE]
        variable FILE_HOLD_DIRECTORY [file join [pwd] MAS_FILES]
        variable FILE_PERMISSION_FLAGS "0755"
        variable FILE_MASK "$MASCLR::SCRIPT_ARGUMENTS(INST_ID)"
        append FILE_MASK {\.[[:alnum:]]{8}\.01\.[[:digit:]]{4}\.[[:digit:]]{3}}
        variable FILE_LIST ""
    }
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

    ### Just copy the file given as the parameter 
    ### keep original permissions (use cp -p)

proc copy_file_to_in_directory { file_name } {
    set target_file_name [file join $THIS::MAS_IN_DIRECTORY [file tail $file_name]]
    MASCLR::log_message "set target file name to $target_file_name" 1
    if { [catch {file copy $file_name $target_file_name} failure] } {
        set message "Could not copy file $file_name to $target_file_name: $failure"
        error $message
    } else {
        return 1
    }
    ###
}   ;# copy_file_to_in_directory
###

proc move_file_to_archive { file_name } {
    set target_file_name "[file join $THIS::ARCHIVE_DIRECTORY [file tail $file_name]]-[MASCLR::get_date_with_format [clock format [clock seconds]] $MASCLR::DT_AUTH]"
    MASCLR::log_message "set target archive file name to $target_file_name" 1
    if { [catch {file rename $file_name $target_file_name} failure] } {
        set message "Could not rename file $file_name to $target_file_name: $failure"
        error $message
    } else {
        return 1
    }
    ###
}  ;# move_file_to_archive
###

proc set_permissions_on_file { file_name } {
    MASCLR::log_message "Setting permissions on $file_name" 1
    if { [catch {file attributes $file_name -permissions $THIS::FILE_PERMISSION_FLAGS} failure] } {
        set message "Could not set permissions on file $file_name: $failure"
        error $message
    } else { 
        return 1
    }
    ###
}  ;# set_permissions_on_file
###

proc get_max_time_for_file_import { file_name } {
    return $THIS::MAX_TIME_FOR_FILE_IMPORT
}
proc get_notify_time_for_file_import { file_name } {
    return $THIS::NOTIFY_TIME_FOR_FILE_IMPORT
}

proc monitor_file_progress { database_handle file_name start_time } {

    set last_warning "0"
    set elapsed_time [expr [clock seconds] - $start_time]
    set timeout_seconds [get_max_time_for_file_import $file_name]
    set warning_seconds [get_notify_time_for_file_import $file_name] 

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
        check_for_mas_stop_file

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
            if { [check_mas_in_directory $file_name] } {
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
        if { [check_for_mas_file_reject $file_name] } {
            set message "MAS rejected the file $file_name.  This may be a duplicate file, so try with a different file name.  Or, this may be a badly formed file or a file out of balance.  Check the MAS logs for more detail."
            error $message
        }
            ### check to see if the file is still in process
        if { [check_mas_process_directory $file_name] } {
            ### still being processed, continue
            continue
        }

            ### check to see if MAS moved the file to done
        if { [check_for_done_mas_file $file_name] && [check_mas_file_balance $database_handle $file_name] } {
            ### time to break out of the loop
            set keep_running 0
        } 

    }

    return 1

}

### return 0/false if no stop file found.  throw error if one is found
proc check_for_mas_stop_file { } {
    set stop_file_list [glob -nocomplain [file join $THIS::MAS_IN_DIRECTORY stop]] 
    if { [llength $stop_file_list] != 0 } {
        set message "Found MAS stop file $stop_file_list"
        error $message
    } else {
        return 0
    }
}


### return 0/false if no reject file found.  throw error if one is found
proc check_for_mas_file_reject { file_name } {
    set reject_file_list [glob -nocomplain [file join $THIS::MAS_REJECT_DIRECTORY [file tail $file_name]]] 
    if { [llength $reject_file_list] != 0 } {
        set message "Found reject files: $reject_file_list"
        error $message
    } else {
       return 0
    } 
}

### return 1/true if found in done directory, else return 0/false
proc check_for_done_mas_file { file_name } {
    set done_file_list [glob -nocomplain [file join $THIS::MAS_DONE_DIRECTORY [file tail $file_name]]] 
    if { [llength $done_file_list] != 0 } {
        MASCLR::log_message "Found done files: $done_file_list"
        return 1
    } else {
       return 0
    } 
}


### return 1/true if found in the in directory, else return 0/false
proc check_mas_in_directory { file_name } {
    set in_file_list [glob -nocomplain [file join $THIS::MAS_IN_DIRECTORY [file tail $file_name]]] 
    if { [llength $in_file_list] != 0 } {
        MASCLR::log_message "Found in files: $in_file_list"
        return 1
    } else {
        return 0
    }
}

### return 1/true if found in the process directory, else return 0/false
proc check_mas_process_directory { file_name } {
    set process_file_list [glob -nocomplain [file join $THIS::MAS_PROCESS_DIRECTORY [file tail $file_name]]] 
    if { [llength $process_file_list] != 0 } {
        MASCLR::log_message "Found process files: $process_file_list"
        return 1
    } else { 
       return 0
    } 
}

    ### this will make sure the file is all the way in to mas_trans_log before proceeding or checking for suspends
    ### this compares the file's count/amount in mas_file_log to the sum in mas_trans_log 
    ### and adds the amount from trans_suspend and error
    ### once those are in balance, then proceed.
    ### otherwise, wait until MAS is finished inserting into the tables.
proc check_mas_file_balance { database_handle mas_file } {
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
          SUM(
          CASE
            WHEN mtl.trans_sub_seq = '0'
            THEN mtl.amt_original
            ELSE 0
          END) AS mtl_sum_amount,
          (select sum(CASE
            WHEN trans_sub_seq = '0'
            THEN amt_original
            ELSE 0
          END) from mas_trans_suspend where institution_id = mfl.institution_id and file_id = mfl.file_id)  AS suspend_amount,
          (select sum(CASE
            WHEN trans_sub_seq = '0'
            THEN amt_original
            ELSE 0
          END) from mas_trans_error where institution_id = mfl.institution_id and file_id = mfl.file_id)  AS error_amount,
          mfl.file_cnt          ,
          SUM(
          CASE
            WHEN mtl.trans_sub_seq = '0'
            THEN mtl.NBR_OF_ITEMS
            ELSE 0
          END) AS mtl_count     ,
          (select sum(
          CASE
            WHEN trans_sub_seq = '0'
            THEN NBR_OF_ITEMS
            ELSE 0
          END) from mas_trans_suspend where institution_id = mfl.institution_id and file_id = mfl.file_id) AS suspend_count     ,
          (select sum(
          CASE
            WHEN trans_sub_seq = '0'
            THEN NBR_OF_ITEMS
            ELSE 0
          END) from mas_trans_error where institution_id = mfl.institution_id and file_id = mfl.file_id) AS error_count      ,
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

    MASCLR::log_message [format "%40s %-20.2f %11s %-15d\n\t\t\t\t\
        %25s %-20.2f %11s %-15d\n\t\t\t\t\
        %25s %-20.2f %11s %-15d\n\t\t\t\t\
        %25s %-20.2f %11s %-15d"  "$file_balance(FILE_NAME) file amount:"  $file_balance(FILE_AMT) "file count:" $file_balance(FILE_CNT) "mas_trans_log amount:" $file_balance(MTL_SUM_AMOUNT) "mtl count:" $file_balance(MTL_COUNT) "mas_trans_suspend amount:" $file_balance(SUSPEND_AMOUNT) "mts count:" $file_balance(SUSPEND_COUNT) "mas_trans_error amount:" $file_balance(ERROR_AMOUNT) "mte count:" $file_balance(ERROR_COUNT) ] 



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
        return 1
    } else {
        return 0
    }
}


proc check_mas_status { database_handle } {
    MASCLR::log_message "Checking to see if MAS is busy" 1
    if { [catch {set select_cursor [MASCLR::open_cursor $database_handle]} failure] } {
        set message "Could not open cursor: $failure"
        error $message
    }
    set select_sql "select institution_id, field_name, field_value1 from field_value_ctrl where field_name in ('FR_STATUS', 'SERVER_STATUS') and FIELD_VALUE1 = 'BUSY'"
    if { [catch {set busy_count [MASCLR::fetch_single_value $select_cursor $select_sql] } failure] } {
        set message "Could not check for mas status: $failure"
        error $message
    }
        ### close cursor
    catch {MASCLR::close_cursor $select_cursor} failure

    if { $busy_count > 0 } {
        set message "MAS is busy.  Waiting."
        MASCLR::log_message $message 
        return $THIS::MAS_BUSY
    } else { 
        MASCLR::log_message "MAS does not appear to be busy" 1
        return 0
    }
}

### return 0/false to answer the question of is_mas_busy
### this will break with an error if mas stays busy too long
proc is_mas_busy { database_handle file_name start_time } {
    set last_warning "0"
    set elapsed_time [expr [clock seconds] - $start_time]
    set timeout_seconds [get_max_time_for_file_import $file_name]
    set warning_seconds [get_notify_time_for_file_import $file_name] 

    set keep_running 1
    while { $keep_running } {
        if { [check_mas_status $database_handle] != $THIS::MAS_BUSY} {
            set keep_running 0
            continue
        }

        after [expr 1000 * 30]
        set elapsed_time [expr [clock seconds] - $start_time]
        MASCLR::log_message "Elapsed time waiting for MAS to be free: [format "%.2f" [expr $elapsed_time / 60.0]] minutes" 
        if { $elapsed_time > $timeout_seconds } {
            set message "MAS has been in a busy status for [format "%.2f" [expr $elapsed_time / 60.0]].  Timeout has been triggered and no other files are being sent to MAS.  See if a MAS process has started or of MAS is stuck in a busy state.  Then this script can be run again."
            error $message 
        }
        if { $elapsed_time > $warning_seconds } {
            if { $last_warning == "0" || [expr [clock seconds] - $last_warning ] > [expr 60 * 10] } {
            ### send info email
                set subject "MAS is still busy while waiting to import $file_name"
                set body "MAS is still busy after [format "%.2f" [expr $elapsed_time / 60.0]] minutes."
                MASCLR::log_message $body
                MASCLR::send_quick_info_email $subject $body
                set last_warning [clock seconds]
            } 
        }
    }
    return 0
}





proc check_suspend_error { database_handle } {
    MASCLR::log_message "Checking for error and suspend records." 1
        ### open cursor
    if { [catch {set select_cursor [MASCLR::open_cursor $database_handle]} failure] } {
        set message "Could not open cursor: $failure"
        error $message
    }

    set select_sql "select count(1) from mas_trans_suspend"
    if { [catch {set suspend_count [MASCLR::fetch_single_value $select_cursor $select_sql] } failure] } {
        set message "Could not check for suspended transactions: $failure"
        error $message
    }

    set select_sql "select count(1) from mas_trans_error"
    if { [catch {set error_count [MASCLR::fetch_single_value $select_cursor $select_sql] } failure] } {
        set message "Could not check for error transactions: $failure"
        error $message
    }

        ### close cursor
    catch {MASCLR::close_cursor $select_cursor} failure

    if { [expr $error_count + $suspend_count] > 0 } {
        set message "Found $error_count records in mas_trans_error.  Found $suspend_count records in mas_trans_suspend"
        error $message 
    } 
    MASCLR::log_message "Found no error or suspend records." 1
}

    ### need an allowed file type list
    ### need 
proc find_files_to_send_to_mas { } {
    set full_dir_listing [glob [file join $THIS::FILE_HOLD_DIRECTORY *]]    
    foreach f_name $full_dir_listing {
        if { [regexp -- $THIS::FILE_MASK [file tail $f_name]] } {
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

# schedule a 100 command right now
proc schedule_file_recognition { database_handle } {
    MASCLR::log_message "Turn on file recognition for institution $MASCLR::SCRIPT_ARGUMENTS(INST_ID)"
        ### open cursor
    if { [catch {set update_cursor [MASCLR::open_cursor $database_handle]} failure] } {
        set message "Could not open cursor: $failure"
        error $message
    }
    set bind_vars [dict create :inst_id_var $MASCLR::SCRIPT_ARGUMENTS(INST_ID)] 
    set update_sql "update tasks set run_hour = to_char(sysdate,'HH24'), run_min = to_char(sysdate,'mi') where cmd_nbr = '100' and institution_id = :inst_id_var"
    if { [catch {MASCLR::update_bind_record $update_cursor $update_sql $bind_vars} failure] } {
        set message "Could not update tasks to enable file recognition: $failure"
        error $message
    }
        ### close cursor
    catch {MASCLR::close_cursor $update_cursor} failure
    if { [catch {MASCLR::perform_commit $database_handle} failure] } {
        set message "Could not commit change to schedule file recognition"
        error $message
    }
}

# schedule a 200 command right now
proc turn_off_file_recognition { database_handle } {
    MASCLR::log_message "Turn on file recognition for institution $MASCLR::SCRIPT_ARGUMENTS(INST_ID)"
        ### open cursor
    if { [catch {set update_cursor [MASCLR::open_cursor $database_handle]} failure] } {
        set message "Could not open cursor: $failure"
        error $message
    }
    set bind_vars [dict create :inst_id_var $MASCLR::SCRIPT_ARGUMENTS(INST_ID)] 
    set update_sql "update tasks set run_hour = to_char(sysdate,'HH24'), run_min = to_char(sysdate,'mi') where cmd_nbr = '200' and institution_id = :inst_id_var"
    if { [catch {MASCLR::update_bind_record $update_cursor $update_sql $bind_vars} failure] } {
        set message "Could not update tasks to enable file recognition: $failure"
        error $message
    }
        ### close cursor
    catch {MASCLR::close_cursor $update_cursor} failure
    if { [catch {MASCLR::perform_commit $database_handle} failure] } {
        set message "Could not commit change to schedule file recognition"
        error $message
    }
}


proc main {} {

    if { [catch {setup} failure] } {
        MASCLR::log_message "setup failed: $failure"
        MASCLR::close_all_and_exit_with_code 1 
    }
    global env
    set mas_file_mover_login_data "masclr/masclr@$env(IST_DB)"
    if { [catch {set mas_file_mover_handle [MASCLR::open_db_connection "mas_file_mover" $mas_file_mover_login_data]} failure] } {
        MASCLR::log_message $failure
        MASCLR::close_all_and_exit_with_code 1
    } 

    if { [catch {find_files_to_send_to_mas } failure ] } {
        MASCLR::log_message "$failure"
        set success 1
    }

    schedule_file_recognition $mas_file_mover_handle

    if { [catch {
        foreach mas_file $THIS::FILE_LIST { 
            ### set permissions on file
            ### copy the file to MAS in directory
            ### move the file to ARCHIVE
            ### watch the file in the MAS directories (in/reject/done/process)
            ### check for suspends or errors
            if { [check_for_done_mas_file $mas_file] } {
                set message "File $mas_file is already in the MAS done directory.  This is a duplicate file.  The script will not send this file to MAS."
                error $message 
            }
            check_for_mas_stop_file
            ### if the file is smaller than the bare-bones empty MAS file, skip it and let it move to ARCHIVE
            ### send out a warning.
            set file_size [file size $mas_file]
            MASCLR::log_message "$mas_file is $file_size bytes in size" 2
            if { $file_size < $THIS::MIN_FILE_SIZE } {
                set subject "[file tail $mas_file] is invalid size for a MAS file"
                set body "[file tail $mas_file] is $file_size bytes in size.  This does not appear to be a valid MAS file.  Moving directly to ARCHIVE"
                MASCLR::log_message $body
                MASCLR::send_quick_info_email $subject $body
                continue
            }
                ### start the timer on this file
            set start_time [clock seconds] 
            is_mas_busy $mas_file_mover_handle $mas_file $start_time
            ### check to see if MAS is busy.  If it is, wait 30 seconds and check again
            ### do this until the max timeout has been reached.
            MASCLR::log_message "Sending $mas_file to MAS"
            set_permissions_on_file $mas_file
            copy_file_to_in_directory $mas_file
            move_file_to_archive $mas_file
            monitor_file_progress $mas_file_mover_handle $mas_file $start_time
            check_suspend_error $mas_file_mover_handle
        }
    } failure ] } {
        turn_off_file_recognition $mas_file_mover_handle
        MASCLR::log_message "Failed sending file to MAS: $failure"
        MASCLR::close_all_and_exit_with_code 1
    }

    turn_off_file_recognition $mas_file_mover_handle
    MASCLR::close_all_and_exit_with_code 0

    ###
}   ;# main
###


main
