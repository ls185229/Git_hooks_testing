#!/usr/bin/env tclsh

# $Id: mas_process_lib.tcl 4215 2017-06-26 14:42:37Z bjones $

source $env(MASCLR_LIB)/masclr_tcl_lib


if { [info exists MAS_PROCESS_LIB_LOADED] } {
    return
}
namespace eval MASCLR {

    variable MIN_MAS_FILE_SIZE 115
    variable CLR_OUT_MAS_DIRECTORY [file join $env(CLR_OSITE_DATA) ftp out]
    variable MAS_IN_DIRECTORY [file join $env(MAS_OSITE_DATA) in]
    variable MAS_REJECT_DIRECTORY [file join $env(MAS_OSITE_DATA) reject]
    variable MAS_DONE_DIRECTORY [file join $env(MAS_OSITE_DATA) done]
    variable MAS_PROCESS_DIRECTORY [file join $env(MAS_OSITE_DATA) process]

    variable MAS_BUSY "BUSY"

    proc get_clearing_file_status { database_handle file_name } {

        if { [info exists MASCLR::SCRIPT_ARGUMENTS(SKIPCHECKS)] && $MASCLR::SCRIPT_ARGUMENTS(SKIPCHECKS) == 1 } {
            MASCLR::log_message "Skip checks option enabled.  Skipping check to verify the export from clearing is finished."
            return $MASCLR::PROC_SUCCESS
        }
        if { [catch {set select_cursor [MASCLR::open_cursor $database_handle]} failure] } {
            set message "Could not open cursor: $failure"
            error $message
        }
        MASCLR::log_message "Before set bind_vars" 2
        set bind_vars [dict create :file_name_var [file tail $file_name]]
        MASCLR::log_message "After set bind_vars" 2

        set select_sql " SELECT TO_CHAR (dt, 'YYYY/DD/MM HH24:MI:SS'),
        dir                                   ,
        SUBSTR (fn, 1, 30)                    ,
        ft                                    ,
        ii                                    ,
        fs                                    ,
        ec
        FROM
        (SELECT ctrl.processing_dt dt,
        'I' dir                    ,
        ctrl.external_file_name fn ,
        LOG.file_type ft           ,
        ctrl.institution_id ii     ,
        (TRIM (ctrl.file_status)
        || LOG.in_file_status) fs,
        ctrl.err_reason_cd ec
        FROM in_file_log LOG,
        in_file_ctrl ctrl
        WHERE LOG.external_file_name(+) = ctrl.external_file_name
        and LOG.external_file_name = :file_name_var

        UNION

        SELECT file_creation_dt dt,
        'O' dir                  ,
        external_file_name fn    ,
        dest_file_type ft        ,
        dest_inst_id ii          ,
        out_file_status fs       ,
        '' ec
        FROM out_file_log
        where external_file_name = :file_name_var

        )"
        MASCLR::log_message $select_sql 2
        if { [catch {array set file_status [MASCLR::fetch_single_bind_record_as_array $select_cursor $select_sql $bind_vars]} failure] } {
            set message "Could not check file status for file $file_name: $failure"
            error $message
        }
        set rows_found [MASCLR::get_affected_rows $select_cursor]
        MASCLR::log_message "Found $rows_found rows" 2
        ### close cursor
        catch {MASCLR::close_cursor $select_cursor} failure

        ### logically, this should only happen if the file was a 0 byte file (nothing to export).  So this should be an error
        ### however, this could happen if the file was copied from a different system (from QA to production, for example) or
        ### if the file was renamed between its export from clearing and the running of the script
        if { $rows_found == 0 } {
            set message "File $file_name was not found in file status query.  This indicates the file had nothing to export and will be a 0-byte file or that the file was renamed after its export from clearing or the file was copied from a different system.  The automatic run of this script will not touch this file.  Run, instead, with the --skipchecks option."
            error $message
        }

        ### error if ec (error code) is not null
        if { [string trim $file_status(EC)] != "" } {
            set message "File status shows an error code for the file export: $file_status(EC)."
            error $message
        }

        ### return 1 for success (fs is E)
        ### return 0, still not exported (fs is P or not given a status yet)
        if { [string trim $file_status(FS)] == "E" } {
            MASCLR::log_message "[file tail $file_name] has an export status in clearing of E"
            return $MASCLR::PROC_SUCCESS
        } else {
            return $MASCLR::FAILURE_CONDITION
        }
        ###
    }  ;# get_clearing_file_status
    ###


    ### right now, just check to see if the file is a valid file size (greater than minimum)
    ### throw error if the file size is invalid
    ### measures in bytes
    proc validate_mas_file_size { file_name } {
        if { [file size $file_name] < $MASCLR::MIN_MAS_FILE_SIZE } {
            set message "File $file_name is too small to be a valid MAS file.  \n\n[exec ls -l $file_name]"
            error $message
        }
        MASCLR::log_message "[file tail $file_name] has a valid file size of [file size $file_name]" 1
        ## return success
        return $MASCLR::PROC_SUCCESS
        ###
    }  ;# validate_mas_file_size
    ###

    proc file_modified_in_past_24_hours { file_name } {
        if { [info exists MASCLR::SCRIPT_ARGUMENTS(SKIPCHECKS)] && $MASCLR::SCRIPT_ARGUMENTS(SKIPCHECKS) == 1 } {
            MASCLR::log_message "Skip checks option enabled.  Skipping check to verify that the file was modified in the past 24 hours."
            return $MASCLR::PROC_SUCCESS
        }
        set one_day_of_minutes [expr 60 * 24]
        set last_mod_in_minutes [expr abs([expr [file mtime $file_name] - [clock seconds]]) / 60]
        MASCLR::log_message "Number minutes since mtime of $file_name: $last_mod_in_minutes" 1

        return [expr $last_mod_in_minutes < $one_day_of_minutes]
        ###
    }  ;# file_modified_in_past_24_hours
    ###


    ### use this to verify that the file is completely exported from clearing
    ### a file with a status of P has not been fully exported
    ################################################################################
    # monitor_clearing_export_status database_handle file_name
    # parameters:
    #   database_handle -- previously opened database handle
    #   file_name -- the full file name (including path) to monitor
    # Note that this uses two procs that must be defined in the calling script:
    # THIS::get_max_time_for_file_import and THIS::get_notify_time_for_file_import
    # public use
    ################################################################################
    proc monitor_clearing_export_status { database_handle file_name start_time } {
        set last_warning "0"
        set elapsed_time [expr [clock seconds] - $start_time]
        set timeout_seconds [THIS::get_max_time_for_file_import $file_name]
        set warning_seconds [THIS::get_notify_time_for_file_import $file_name]
        MASCLR::log_message "timeout_seconds: $timeout_seconds" 2
        MASCLR::log_message "warning_seconds: $warning_seconds" 2
        set keep_running 1

        ### this loop is broken in the following ways:
        ### the file gets a file status of E, returning a 1 from get_clearing_file_status
        ### get_clearing_file_status throws an error due to an error status given by
        ### clearing
        ### fstat query does not show the file, which indicates a 0-byte file
        while { $keep_running } {

            ### if the file has an export status of E, break the loop and move on
            ### let any thrown error from get_clearing_file_status throw up the stack
                        if { [MASCLR::get_clearing_file_status $database_handle $file_name] == $MASCLR::PROC_SUCCESS } {
                            MASCLR::log_message "setting keep_running to 0" 2
                            set keep_running 0
                            continue
                        }


            after [expr 1000 * 30]
            set elapsed_time [expr [clock seconds] - $start_time]
            MASCLR::log_message "Waiting for export to finish.  Elapsed time: [format "%.2f" [expr $elapsed_time / 60.0]] minutes"
            if { $elapsed_time > $timeout_seconds } {
                set message "File $file_name has taken longer than [format "%.2f" [expr $elapsed_time / 60.0]] minutes to export from clearing.  Timeout has been triggered and no other files are being sent to MAS.  If MAS is still working on the file, watch this manually until the file is done.  Then this script can be run again."
                error $message
            }
            if { $elapsed_time > $warning_seconds } {
                ### send info email once every 10 minutes
                if { $last_warning == "" ||  [expr [clock seconds] - $last_warning ] > [expr 60 * 10] } {
                    ### send info email
                    set subject "MAS file $file_name still exporting"
                    set body "MAS file $file_name has not yet exported after [format "%.2f" [expr $elapsed_time / 60.0]] minutes."
                    MASCLR::log_message $body
                    MASCLR::send_quick_info_email $subject $body
                    set last_warning [clock seconds]
                }

            }

            ###
        }  ;# end while keep_running
        ###

        return $MASCLR::PROC_SUCCESS

        ###
    }  ;# monitor_clearing_export_status
    ###

    proc check_mas_status { database_handle } {
        MASCLR::log_message "Checking to see if MAS is busy"
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
            return $MASCLR::MAS_BUSY
        } else {
            MASCLR::log_message "MAS does not appear to be busy"
            return $MASCLR::PROC_SUCCESS
        }
    ###
    }  ;# check_mas_status
    ###

    ### return 0/false if no stop file found.  throw error if one is found
    proc check_for_mas_stop_file { } {
        set stop_file_list [glob -nocomplain [file join $MASCLR::MAS_IN_DIRECTORY stop]]
        if { [llength $stop_file_list] != 0 } {
            set message "Found MAS stop file $stop_file_list"
            error $message
        } else {
            return $MASCLR::PROC_SUCCESS
        }
    ###
    }  ;# check_for_mas_stop_file
    ###

    ### return 0/false if no reject file found.  throw error if one is found
    proc check_for_mas_file_reject { file_name } {
        set reject_file_list [glob -nocomplain [file join $MASCLR::MAS_REJECT_DIRECTORY [file tail $file_name]]]
        if { [llength $reject_file_list] != 0 } {
            set message "Found reject files: $reject_file_list"
            error $message
        } else {
            return $MASCLR::PROC_SUCCESS
        }
    ###
    }  ;# check_for_mas_file_reject
    ###

    ### return 1/true if found in done directory, else return 0/false
    proc check_for_done_mas_file { file_name } {
        set done_file_list [glob -nocomplain [file join $MASCLR::MAS_DONE_DIRECTORY [file tail $file_name]]]
        if { [llength $done_file_list] != 0 } {
            MASCLR::log_message "Found done files: $done_file_list"
            return $MASCLR::PROC_SUCCESS
        } else {
            return 0
        }
    ###
    }  ;# check_for_done_mas_file
    ###


    ### return 1/true if found in the in directory, else return 0/false
    proc check_mas_in_directory { file_name } {
        set in_file_list [glob -nocomplain [file join $MASCLR::MAS_IN_DIRECTORY [file tail $file_name]]]
        if { [llength $in_file_list] != 0 } {
            MASCLR::log_message "Found in files: $in_file_list"
            return $MASCLR::PROC_SUCCESS
        } else {
            return 0
        }
    ###
    }  ;# check_mas_in_directory
    ###

    ### return 1/true if found in the process directory, else return 0/false
    proc check_mas_process_directory { file_name } {
        set process_file_list [glob -nocomplain [file join $MASCLR::MAS_PROCESS_DIRECTORY [file tail $file_name]]]
        if { [llength $process_file_list] != 0 } {
            MASCLR::log_message "Found process files: $process_file_list"
            return $MASCLR::PROC_SUCCESS
        } else {
            return 0
        }
    ###
    }  ;# check_mas_process_directory
    ###


    ### return 0/false to answer the question of is_mas_busy
    ### this will break with an error if mas stays busy too long
    proc is_mas_busy { database_handle file_name start_time } {
        set last_warning "0"
        set elapsed_time [expr [clock seconds] - $start_time]
        set timeout_seconds [THIS::get_max_time_for_file_import $file_name]
        set warning_seconds [THIS::get_notify_time_for_file_import $file_name]
        MASCLR::log_message "timeout_seconds: $timeout_seconds" 2
        MASCLR::log_message "warning_seconds: $warning_seconds" 2

        set keep_running 1
        while { $keep_running } {
            if { [MASCLR::check_mas_status $database_handle] != $MASCLR::MAS_BUSY} {
            ### break out of the loop by explicitly setting keep_running to 0
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
        return $MASCLR::FALSE
    ###
    }  ;# is_mas_busy
    ###


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

        if {$suspend_count > 0} {
           move_suspend_to_wip $database_handle
        }
        if {$error_count > 0} {
           move_error_to_wip $database_handle
        }
        if {($suspend_count == 0 ) && ($error_count == 0)} {
           MASCLR::log_message "Found no error or suspend records."
           return $MASCLR::PROC_SUCCESS
        }

        #if { [expr $error_count + $suspend_count] > 0 } {
            #set message "Found $error_count records in mas_trans_error.  Found $suspend_count records in mas_trans_suspend"
            #error $message
        #}
        #MASCLR::log_message "Found no error or suspend records."
        #return $MASCLR::PROC_SUCCESS
        ###
    }  ;# check_suspend_error
    ###

    proc move_suspend_to_wip {database_handle} {
        MASCLR::log_message "Moving suspend records to WIP table if under threshold."
        ### open cursor
        if { [catch {set select_cursor [MASCLR::open_cursor $database_handle]} failure] } {
            set message "Could not open cursor: $failure"
            error $message
        }
        if { [catch {set check_cursor [MASCLR::open_cursor $database_handle]} failure] } {
            set message "Could not open cursor: $failure"
            error $message
        }
        if { [catch {set insert_cursor [MASCLR::open_cursor $database_handle]} failure] } {
            set message "Could not open cursor: $failure"
            error $message
        }
        if { [catch {set delete_cursor [MASCLR::open_cursor $database_handle]} failure] } {
            set message "Could not open cursor: $failure"
            error $message
        }

        set notifyFlag 0
        set moveFlag 1
        set query "select institution_id,
                            file_id,
                            count(1) as cnt,
                            sum(amt_original) as amt
                    from mas_trans_suspend
                    group by institution_id,file_id"

        orasql $select_cursor $query

        while {[orafetch $select_cursor -dataarray suspend -indexbyname] != 1403} {
            ### Filter the month end file and check for threshold
            if { ($suspend(CNT) > 100) || ($suspend(AMT) > 5000)} {
                set query "
                    select count(1) as cnt
                    from mas_file_log
                    where institution_id = '$suspend(INSTITUTION_ID)'
                    and file_id = '$suspend(FILE_ID)'
                    and  substr(file_name,5,8) not in (
                        'VSMCRCLS', 'ACHCOUNT', 'ACQSUPPO', 'AVSCOUNT', 'BINBLOCK',
                        'BTCHHEDR', 'COUNTDBT', 'COUNTING', 'CVVCOUNT', 'DSBORDER',
                        'FPREPORT', 'FPRPT002', 'MBUCOUNT', 'MCBORDER', 'RECYLING',
                        'VAUCOUNT', 'VISAFANF', 'VISAISAF', 'VSMCRCLS', 'WOOTRULE',
                        'WOOTSETT')"

                MASCLR::log_message "INSTITUTION-$suspend(INSTITUTION_ID) File-$suspend(FILE_ID) AMT=$suspend(AMT),query=$query"
                orasql $check_cursor $query
                while {[orafetch $check_cursor -dataarray mfl -indexbyname] != 1403} {
                    if {$mfl(CNT) > 0} {
                        set notifyFlag 1
                        set moveFlag 0
                        set message "Found $suspend(CNT) records in mas_trans_suspend for $suspend(INSTITUTION_ID)"
                        error $message
                    } else {
                        set moveFlag 1
                    }
                }
            }
            if {$moveFlag == 1} {
                set query "insert into mas_trans_suspend_wip
                            select *
                            from mas_trans_suspend
                            where institution_id = '$suspend(INSTITUTION_ID)'
                            and file_id = '$suspend(FILE_ID)'"

                if { [catch {orasql $insert_cursor $query} result] } {
                    set message "ERROR:- The insert query failed, query - $query, ERROR-$result"
                    error $message
                } else {

                    set table_adn "MAS_TRANS_SUS_ADDN"
                    set sqlcpy [format "insert into %s_wip
                        select * from %s
                        where (institution_id, trans_seq_nbr) in (
                            select institution_id, trans_seq_nbr
                            from mas_trans_suspend
                            where institution_id = '$suspend(INSTITUTION_ID)'
                            and file_id = '$suspend(FILE_ID)'
                        )" $table_adn $table_adn]
                    MASCLR::log_message "sqlcpy \n\n\t$sqlcpy" 3
                    if {[catch {orasql $insert_cursor $sqlcpy} result]} {
                        append mbody "Encountered oracle error while transferring reords to the $table_adn wip table"
                        append mbody "Oracle error: [oramsg $handle all]"
                        puts [oramsg $handle all]
                        exit 3
                    }

                    set sqldel "delete $table_adn
                        where (institution_id, trans_seq_nbr) in (
                            select institution_id, trans_seq_nbr
                            from mas_trans_suspend
                            where institution_id = '$suspend(INSTITUTION_ID)'
                            and file_id = '$suspend(FILE_ID)'
                        )"
                    MASCLR::log_message "sqldel \n\n\t$sqldel " 3
                    if {[catch {orasql $delete_cursor $sqldel} result]} {
                        set emsg "Error deleting records from $table_adn"
                        puts "[oramsg $handle all]"
                        append mbody "Encountered oracle error while deleting reords from the $table_adn table"
                        append mbody "Oracle error: [oramsg $handle all]"
                        exit 3
                    }

                    set query "delete mas_trans_suspend
                            where institution_id = '$suspend(INSTITUTION_ID)'
                            and file_id = '$suspend(FILE_ID)'"
                    if { [catch {orasql $delete_cursor $query} result] } {
                    set message "ERROR:- The delete query failed, query - $query, ERROR-$result"
                    error $message
                    } else {
                    if { [catch {MASCLR::perform_commit $database_handle} failure] } {
                        set message "Could not commit change to mas_trans_suspend and wip table"
                        error $message
                    }
                    set subject "Moved MAS Suspends to WIP"
                    set body "Moved MAS suspend to WIP, Institution=$suspend(INSTITUTION_ID)\
                                file_id=$suspend(FILE_ID),Count=$suspend(CNT),Amount=$suspend(AMT).\
                                Clear them ASAP"
                    MASCLR::send_quick_info_email $subject $body
                    }
                }
            }
        } ;#endof while suspend

    } ; #endof move_suspend_to_wip

    proc move_error_to_wip {database_handle} {
       MASCLR::log_message "Moving error records to WIP table if under threshold."
       ### open cursor
       if { [catch {set select_cursor [MASCLR::open_cursor $database_handle]} failure] } {
           set message "Could not open cursor: $failure"
           error $message
       }
       if { [catch {set check_cursor [MASCLR::open_cursor $database_handle]} failure] } {
           set message "Could not open cursor: $failure"
           error $message
       }
       if { [catch {set insert_cursor [MASCLR::open_cursor $database_handle]} failure] } {
           set message "Could not open cursor: $failure"
           error $message
       }
       if { [catch {set delete_cursor [MASCLR::open_cursor $database_handle]} failure] } {
           set message "Could not open cursor: $failure"
           error $message
       }

       set notifyFlag 0
       set moveFlag 1
       set query "select institution_id,
                         file_id,
                         count(1) as cnt,
                         sum(amt_original) as amt
                  from mas_trans_error
                  group by institution_id,file_id"


       orasql $select_cursor $query

       while {[orafetch $select_cursor -dataarray error -indexbyname] != 1403} {
          ### Filter the month end file and check for threshold
          if { ($error(CNT) > 100) || ($error(AMT) > 5000)} {
             set query "select count(1) as cnt
                        from mas_file_log
                        where institution_id = '$error(INSTITUTION_ID)'
                        and file_id = '$error(FILE_ID)'
                        and  substr(file_name,5,8) not in
                             ('VSMCRCLS','ACHCOUNT','ACQSUPPO','AVSCOUNT','BINBLOCK','BTCHHEDR','COUNTDBT',
                              'COUNTING','CVVCOUNT','DSBORDER','FPREPORT','FPRPT002','MBUCOUNT','MCBORDER',
                              'RECYLING','VAUCOUNT','VISAFANF','VISAISAF','VSMCRCLS','WOOTRULE','WOOTSETT')"

             MASCLR::log_message "INSTITUTION-$suspend(INSTITUTION_ID) File-$suspend(FILE_ID) AMT=$suspend(AMT),query=$query"
             orasql $check_cursor $query
             while {[orafetch $check_cursor -dataarray mfl -indexbyname] != 1403} {
                 if {$mfl(CNT) > 0} {
                    set notifyFlag 1
                    set moveFlag 0
                    set message "Found $error(CNT) records in mas_trans_error for $error(INSTITUTION_ID)"
                    error $message
                 } else {
                    set moveFlag 1
                 }
             }
          }
          if {$moveFlag == 1} {
             set query "insert into mas_trans_error_wip
                        select *
                        from mas_trans_error
                        where institution_id = '$error(INSTITUTION_ID)'
                        and file_id = '$error(FILE_ID)'"

             if { [catch {orasql $insert_cursor $query} result] } {
                set message "ERROR:- The insert query failed, query - $query, ERROR-$result"
                error $message
             } else {
                set query "delete mas_trans_error
                           where institution_id = '$error(INSTITUTION_ID)'
                           and file_id = '$error(FILE_ID)'"
                if { [catch {orasql $delete_cursor $query} result] } {
                   set message "ERROR:- The delete query failed, query - $query, ERROR-$result"
                   error $message
                } else {
                  if { [catch {MASCLR::perform_commit $database_handle} failure] } {
                     set message "Could not commit change to mas_trans_error and wip table"
                     error $message
                  }
                  set subject "Moved MAS errors to WIP"
                  set body "Moved MAS errors to WIP, Institution=$error(INSTITUTION_ID)\
                              file_id=$error(FILE_ID),Count=$error(CNT),Amount=$error(AMT).\
                              Clear them ASAP"
                  MASCLR::send_quick_info_email $subject $body
                }
             }
          }
       } ;#endof while error

    } ; #endof move_error_to_wip


    # schedule a 100 command right now
    proc schedule_file_recognition { database_handle } {
        MASCLR::log_message "Turn on file recognition for institution $MASCLR::SCRIPT_ARGUMENTS(INST_ID)"
        ### open cursor
        if { [catch {set update_cursor [MASCLR::open_cursor $database_handle]} failure] } {
            set message "Could not open cursor: $failure"
            error $message
        }
        set bind_vars [dict create :inst_id_var $MASCLR::SCRIPT_ARGUMENTS(INST_ID)]
        set update_sql "update tasks set run_hour = to_char(sysdate,'HH24'), run_min = to_char(sysdate,'mi')+2 where cmd_nbr = '100' and institution_id = :inst_id_var"
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
        return $MASCLR::PROC_SUCCESS
        ###
    }  ;# schedule_file_recognition
    ###

    # schedule a 200 command right now
    proc turn_off_file_recognition { database_handle } {
        MASCLR::log_message "Turn on file recognition for institution $MASCLR::SCRIPT_ARGUMENTS(INST_ID)"
        ### open cursor
        if { [catch {set update_cursor [MASCLR::open_cursor $database_handle]} failure] } {
            set message "Could not open cursor: $failure"
            error $message
        }
        set bind_vars [dict create :inst_id_var $MASCLR::SCRIPT_ARGUMENTS(INST_ID)]
        set update_sql "update tasks set run_hour = to_char(sysdate,'HH24'), run_min = to_char(sysdate,'mi')+2 where cmd_nbr = '200' and institution_id = :inst_id_var"
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
        return $MASCLR::PROC_SUCCESS
        ###
    }  ;# turn_off_file_recognition
    ###

    proc luhn {digitString  {test 0}} {
        regsub -all {[^0-9]} $digitString {} newstring
        if {$test > 2} {puts "len [string length $digitString]: $digitString : len [string length $newstring] $newstring" }
        if {[string length $digitString] >= [expr [string length $newstring] * 2] } {
            return 0
        }
        if {[regexp {[^0-9]} $newstring]} {error "not a number"}
        set sum 0
        set flip 1
        foreach ch [lreverse [split $newstring {}]] {
            incr sum [lindex {
                {0 1 2 3 4 5 6 7 8 9}
                {0 2 4 6 8 1 3 5 7 9}
            } [expr {[incr flip] & 1}] $ch]
        }
        return [expr {($sum % 10) == 0}]
    }

    proc mask_card {testlist {test 0}} {
        set pattern {(?:(?:^|[^.,=])\y([1-9](?:[ \.\-\,\_\t]*\d){9,18})\y)}

        if {$test} {puts "Pattern: $pattern\nBefore:\n $testlist"}
        set newlist $testlist
        foreach mtch_index [regexp -all -inline -indices $pattern $testlist] {
            set mtch [string range $testlist [lindex $mtch_index 0] [lindex $mtch_index 1]]
            set found_one [luhn $mtch $test]
            if $found_one {
                set    new_mtch [string range $mtch 0 5]
                append new_mtch [string repeat {*} [expr [string length $mtch] - 10]]
                append new_mtch [string range $mtch end-3 end]
                set newlist [
                    string range $newlist 0 [expr [lindex $mtch_index 0] - 1]
                    ]$new_mtch[
                    string range $newlist [expr [lindex $mtch_index 1] + 1] end
                    ]
            }
        }
        if {$test} {puts "After:\n$newlist"}
        return $newlist
    }



}

set MAS_PROCESS_LIB_LOADED 1
