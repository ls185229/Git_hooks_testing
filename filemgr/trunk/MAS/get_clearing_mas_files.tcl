#!/usr/bin/env tclsh

# $Id: get_clearing_mas_files.tcl 3510 2015-09-22 21:22:57Z bjones $

# get standard commands from a lib file
source $env(MASCLR_LIB)/mas_process_lib.tcl

### The MASCLR::monitor_clearing_export_status proc requires these two procs
### to be defined in the THIS namespace
namespace eval THIS {

    proc get_max_time_for_file_import { file_name } {
        return $THIS::MAX_TIME_FOR_FILE_EXPORT
    }

    proc get_notify_time_for_file_import { file_name } {
        return $THIS::NOTIFY_TIME_FOR_FILE_EXPORT
    }

}

proc setup {} {
    global argv

    MASCLR::open_log_file ""

    MASCLR::add_argument inst_id i [list ARG_REQ ARG_HAS_VAL]
    MASCLR::add_argument skipchecks sc [list ARG_NOT_REQ ARG_NO_VAL ]
    MASCLR::parse_arguments $argv

    MASCLR::set_script_alert_level "HIGH"
    MASCLR::set_debug_level 4
    MASCLR::live_updates

    global env
    namespace eval THIS {
        variable MAX_TIME_FOR_FILE_EXPORT 600
        variable NOTIFY_TIME_FOR_FILE_EXPORT 300

        variable ARCHIVE_DIRECTORY [file join [pwd] ARCHIVE]
        # FIXME using ON_HOLD_FILES for testing, production uses MAS_FILES
        # variable FILE_HOLD_DIRECTORY [file join [pwd] MAS_FILES]
        variable FILE_HOLD_DIRECTORY [file join [pwd] ON_HOLD_FILES]

        variable MAS_FILE_MASK "$MASCLR::SCRIPT_ARGUMENTS(INST_ID)"
        append MAS_FILE_MASK     {\.[[:alnum:]]{8}\.01\.[[:digit:]]{4}\.[[:digit:]]{3}}
        append MAS_FILE_ALT_MASK {\.[[:alnum:]]{8}\.01\.[[:digit:]]{4}\.[[:digit:]]{4}\.[[:digit:]]{3}}
        variable FILE_LIST ""

        variable REPORT_MESSAGE ""
    }

    MASCLR::set_up_dates
    ###
}   ;# setup

###

### Just copy the file given as the parameter
proc move_file_to_mas_files_directory { file_name } {
    MASCLR::log_message "file to move: $file_name" 3
    MASCLR::log_message "hold directory: $THIS::FILE_HOLD_DIRECTORY" 3
    MASCLR::log_message "file tail: [file tail $file_name]" 3
    set target_file_name [file join $THIS::FILE_HOLD_DIRECTORY [file tail $file_name]]
    MASCLR::log_message "set target file name to $target_file_name" 1
    # set scp_cmd "scp -q filemgr@dfw-prd-clr-01:$file_name $target_file_name "
    set scp_cmd "scp -q filemgr@$CLEARING_BOX:$file_name $target_file_name "
    MASCLR::log_message "command used: exec $scp_cmd" 3
    if { [catch  {exec $scp_cmd} failure] } {
        set message "ERROR: Could not copy file $file_name to $target_file_name: $failure"
        MASCLR::log_message $message
        error $message
    } else {
        # set ssh_cmd "ssh -q filemgr@dfw-prd-clr-01 mv $file_name [file join $MASCLR::CLR_OUT_MAS_DIRECTORY mas_file_archive] "
        set ssh_cmd "ssh -q filemgr@$CLEARING_BOX mv $file_name [file join $MASCLR::CLR_OUT_MAS_DIRECTORY mas_file_archive] "
        MASCLR::log_message "command used:  exec $ssh_cmd" 3
        if { [catch {exec $ssh_cmd} failure] } {
            set message "ERROR: Could not move file $file_name to mas_file_archive: $failure"
            MASCLR::log_message $message
            error $message
        } else {
            return $MASCLR::PROC_SUCCESS
        }
    }
    ###
}   ;# move_file_to_mas_files_directory

###

### need an allowed file type list
### add files to the list if they match the file pattern
### and if they were modified in the past 24 hours
### and if they are a valid minimum size
### if encountering a 0 byte file, this should be an error condition indicating
# something went wrong with that institution
proc find_clearing_mas_files { database_handle } {
    MASCLR::log_message "Files in file list: $THIS::FILE_LIST" 2
    if { [catch {
        # set full_dir_listing [exec ssh -q filemgr@dfw-prd-clr-01 ls [file join $MASCLR::CLR_OUT_MAS_DIRECTORY "*CLEARING*" ] ]} failure ] } {
        set full_dir_listing [exec ssh -q filemgr@$CLEARING_BOX ls [file join $MASCLR::CLR_OUT_MAS_DIRECTORY "*CLEARING*" ] ]} failure ] } {
        error "There are no MAS files in the clearing export directory $MASCLR::CLR_OUT_MAS_DIRECTORY"
    }
    MASCLR::log_message "full_dir_listing: $full_dir_listing" 3

    foreach f_name $full_dir_listing {
        MASCLR::log_message "File: $f_name" 3
        if { [regexp -- $THIS::MAS_FILE_MASK [file tail $f_name]] } {
            MASCLR::log_message "Match mask: $THIS::MAS_FILE_MASK - $f_name" 3
            ## if { [file isfile $f_name] } {
            ##    MASCLR::log_message "isfile: $THIS::MAS_FILE_MASK - $f_name" 3
                ## if { [MASCLR::file_modified_in_past_24_hours $f_name] } {
                ##     MASCLR::log_message "File modified: $THIS::MAS_FILE_MASK - $f_name" 3
                    ### start the timer on this file
                    set start_time [clock seconds]
                    ## if { [MASCLR::validate_mas_file_size $f_name] == $MASCLR::PROC_SUCCESS} {
                    ##     MASCLR::log_message "Valid file size: $THIS::MAS_FILE_MASK - $f_name" 3
                        ## if { [MASCLR::monitor_clearing_export_status $database_handle $f_name $start_time] == $MASCLR::PROC_SUCCESS} {
                        ##     MASCLR::log_message "Monitor clearing export: $THIS::MAS_FILE_MASK - $f_name" 3
                            MASCLR::log_message "Adding $f_name to the list of files"
                            lappend THIS::FILE_LIST $f_name
                        ## } else {
                        ##     MASCLR::log_message "Skipping file $f_name" 2
                        ## }
                    ## } else {
                    ##     MASCLR::log_message "Skipping file $f_name" 2
                    ## }
                ## } else {
                ##     MASCLR::log_message "Skipping file $f_name" 2
                ## }

            ## } else {
            ##     ### Found an old file -- send a warning email
            ##     ### but leave the file alone
            ##     set subject_line "WARNING: Found old MAS file in clearing's out/mas directory"
            ##     set body "Found an old MAS file in clearing's out/mas directory.  This file will be left alone (will not be moved to MAS for import), but this should be investigated and removed manually.\n\n[exec ls -l $f_name]"
            ##     MASCLR::log_message $subject_line
            ##     MASCLR::log_message $body
            ##     MASCLR::send_quick_info_email $subject_line $body
            ## }
        } else {
            MASCLR::log_message "Skipping file $f_name" 2
        }
    }

    MASCLR::log_message "Files in file list: $THIS::FILE_LIST" 1
###
}  ;# find_clearing_mas_files

###

### error condition on 0 files
### error condition on more than 1 file
proc validate_number_of_files {} {
    if { [llength $THIS::FILE_LIST] == 0 } {
        set message "No files matched $THIS::MAS_FILE_MASK in $MASCLR::CLR_OUT_MAS_DIRECTORY.  \n\t\tCheck to see if institution $MASCLR::SCRIPT_ARGUMENTS(INST_ID) had activity in clearing for today.  \n\t\tCheck to see if the MAS export command (321) for $MASCLR::SCRIPT_ARGUMENTS(INST_ID) finished running."
        error $message
    }
    if { [llength $THIS::FILE_LIST] > 1 } {
        set message "Found more than one MAS file matching $THIS::MAS_FILE_MASK in $MASCLR::CLR_OUT_MAS_DIRECTORY.  \n\t\tThis could be a duplicate MAS file.  Run a diff of the files to verify.  If each file is safe for MAS to import, move the files to $THIS::FILE_HOLD_DIRECTORY.  File list:\n\t[join $THIS::FILE_LIST] \n\t]"
        error $message
    }
    MASCLR::log_message "Found exactly 1 MAS file for $MASCLR::SCRIPT_ARGUMENTS(INST_ID) : [join $THIS::FILE_LIST]" 1
    ## return success
    return $MASCLR::PROC_SUCCESS
    ###
}  ;# validate_number_of_files

###

proc main {} {

    if { [catch {setup} failure] } {
        MASCLR::log_message "ERROR: Setup failed: $failure"
        MASCLR::close_all_and_exit_with_code $MASCLR::FAILURE_CONDITION
    }
    global env
    set mas_file_mover_login_data "masclr/masclr@$env(IST_DB)"
    if { [catch {set mas_file_mover_handle [MASCLR::open_db_connection "mas_file_mover" $mas_file_mover_login_data]} failure] } {
        MASCLR::log_message "ERROR: $failure"
        MASCLR::close_all_and_exit_with_code $MASCLR::FAILURE_CONDITION
    }

    ### look in the clearing out/mas directory for MAS files for the given
# institution
    ### previous incarnation of this script looked only at files with a file access
# time of the last 24 hours
    ### changed this to modified time.  And if a file is found that has a modified
# time greater than 24 hours ago
    ### the script will send a warning email with LOW priority
    set success $MASCLR::SCRIPT_SUCCESS
    set script_failures ""
    if { [catch {
                find_clearing_mas_files $mas_file_mover_handle
                MASCLR::log_message "Calling validate_number_of_files" 2
                validate_number_of_files
            } failure ] } {
        MASCLR::log_message "$failure"
        set success $MASCLR::FAILURE_CONDITION
        append script_failures "\n$failure"
    }
    MASCLR::log_message "success = $success" 2
    ### on failure of the above, or on failure of the catch, log and report error
# condition
    if { $success == $MASCLR::FAILURE_CONDITION ||  [catch {
                append THIS::REPORT_MESSAGE "The following files will be sent to MAS for processing:\n\t[join $THIS::FILE_LIST] \n\t\n\n"
                MASCLR::log_message $THIS::REPORT_MESSAGE 2
                foreach mas_file $THIS::FILE_LIST {
                    move_file_to_mas_files_directory $mas_file
                }
            } failure ] } {
        set message "ERROR: Failed moving clearing MAS file to $THIS::FILE_HOLD_DIRECTORY:\n $script_failures\n$failure"
        MASCLR::log_message $message

        MASCLR::close_all_and_exit_with_code $MASCLR::FAILURE_CONDITION
    }

    MASCLR::close_all_and_exit_with_code $MASCLR::SCRIPT_SUCCESS

    ###
}   ;# main

###

main
