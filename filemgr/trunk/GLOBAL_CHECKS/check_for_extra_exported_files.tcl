#!/usr/bin/env tclsh
# secure method of finding/invoking tclsh

################################################################################
# $Id: check_for_extra_exported_files.tcl 3526 2015-10-04 23:00:30Z bjones $
################################################################################
#
# File Name:  check_for_extra_exported_files.tcl
#
# Description:  This program checks for stranded files in clradmin, masadmin,
#               and filemgr.
#
# Script Arguments:  None.
#
# Output:  None.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

# no usage statement on this one.
# This script checks a list of directories in global DIRECTORIES as defined in the setup proc
# Each directory has a list of skip files -- a list defined in the array SKIP_FILES (indexed on the full directory name)
# Each directory also has a list of rules for what to do with empty files, stored in the array EMPTY_FILE_RULES (indexed on the full directory name)
# there is also a mechanism to give each directory a specialized glob search through the array SPECIAL_GLOB (indexed on the full directory name)

# main is the starting point
# main calls setup
# setup defines each of the lists and arrays

# main then creates a global REPORT_STRING set to an empty string
# main calls file_check

# file check loops through the directory list
# for each directory, file_check uses cd to that directory
# then file_check runs a glob on that directory (default is glob *)
# for each file found in the directory, file_check checks to see if the file is in the skip list for that directory
# for any file not in teh skip list, file_check checks to see if it is a 0 byte file
# for any 0 byte file, file_check looks at the EMPTY_FILE_RULES for that directory and either ignores the file or moves it
# moved files go to LOSTFOUNDDIR, which is defined as "/clearing/filemgr/GLOBAL_CHECKS/LOST_FILES"
# the file move checks in LOSTFOUNDDIR to see if a file by that name already exists.  If so, then LOSTFOUNDDIR finds the first available sequence
# that can be appeneded to the file name to make the file unique
# then the file is moved (after ensuring that it will move with a unique name)
# if the file is not a 0 byte file, then the file details are added to the report string by calling ls -l on that file.
# after looping through each file in each directory, the report string is emailed to clearing if any files are found that need attention.

# next, if files DID need attention, main runs file_check again.
# if the second file_check does not find any files needing attention, then an email goes out that says that all files that needed attention were addressed automatically
# if the second file_check still finds files needing attention, then an email goes out that saying that files still need attention.

# if no files are found that need attention the first time, then a success email goes out that everything was good to go



proc set_one_dir {dirname to_skip action} {
    global DIRECTORIES
    global SKIP_FILES
    global EMPTY_FILE_RULES

    lappend DIRECTORIES "$dirname"
    set SKIP_FILES($dirname) $to_skip
    set EMPTY_FILE_RULES($dirname) $action

}

proc setup {} {
    global VERSION
    set VERSION "1.0"

    global env

    global SUCCESS_CODES
    set SUCCESS_CODES(SUCCESS) 0
    set SUCCESS_CODES(DB_ERROR) 1
    set SUCCESS_CODES(IO_ERROR) 5
    set SUCCESS_CODES(MAIL_ERROR) 7
    set SUCCESS_CODES(INVALID_ARGUMENTS) 22
    set SUCCESS_CODES(HELP) 9


    global STD_OUT_CHANNEL
    set STD_OUT_CHANNEL stdout

    global LOSTFOUNDDIR
    set LOSTFOUNDDIR "/clearing/filemgr/GLOBAL_CHECKS/LOST_FILES"

    global env

    global MASPATH
    set MASPATH [set env(MAS_OSITE_DATA)]

    global CLRPATH
    set CLRPATH [set env(CLR_OSITE_DATA)]

    global FILEMGRPATH
    set FILEMGRPATH "/clearing/filemgr"

    global DIRECTORIES
    global SKIP_FILES
    global EMPTY_FILE_RULES
    global SPECIAL_GLOB

    set DIRECTORIES {}



    # lappend DIRECTORIES "$CLRPATH/out/ipm"
    # set SKIP_FILES([lindex $DIRECTORIES 0]) {output.txt tvslog }
    # set EMPTY_FILE_RULES([lindex $DIRECTORIES 0]) { MOVE }
    #
    # lappend DIRECTORIES "$CLRPATH/out/base2"
    # set SKIP_FILES([lindex $DIRECTORIES 1]) { tvslog }
    # set EMPTY_FILE_RULES([lindex $DIRECTORIES 1]) { MOVE }
    #
    #
    # lappend DIRECTORIES "$CLRPATH/out/discover"
    # set SKIP_FILES([lindex $DIRECTORIES 2]) { tvslog }
    # set EMPTY_FILE_RULES([lindex $DIRECTORIES 2]) { MOVE }
    #
    # lappend DIRECTORIES "$FILEMGRPATH/DISCOVER/UPLOAD"
    # set SKIP_FILES([lindex $DIRECTORIES 3]) { discover_file_upload.exp discover_file_upload.exp-new discover_file_upload.exp-old discover_upload.sh ftp.log map_discover_file_upload.exp map_discover_upload.sh map_ftp.log discover_file_transfer_sr_auto.exp discover_file_xfer_ftp.log }
    # set EMPTY_FILE_RULES([lindex $DIRECTORIES 3]) { IGNORE }
    #
    # lappend DIRECTORIES "$CLRPATH/out/mas"
    # set SKIP_FILES([lindex $DIRECTORIES 4]) { tvslog }
    # set EMPTY_FILE_RULES([lindex $DIRECTORIES 4]) { MOVE }


    global GLOBALS

    set GLOBALS(RUN_AS_TEST) 0
    set GLOBALS(INDENT) "\t"

    set GLOBALS(SYS_BOX) [set env(SYS_BOX)]
    set GLOBALS(SYSINFO) "System: $GLOBALS(SYS_BOX)\n Location: [set env(PWD)] \n\n"
    set GLOBALS(MAILTO_LIST) [set env(MAIL_TO)]
    set GLOBALS(MAILFROM_LIST) [set env(MAIL_FROM)]

    #Email Subjects variables Priority wise
    set GLOBALS(EMAIL_CRITICAL_SUBJECT) "$GLOBALS(SYS_BOX) :: Priority : Critical - Clearing and Settlement"
    set GLOBALS(EMAIL_URGENT_SUBJECT) "$GLOBALS(SYS_BOX) :: Priority : Urgent - Clearing and Settlement"
    set GLOBALS(EMAIL_HIGH_SUBJECT) "$GLOBALS(SYS_BOX) :: Priority : High - Clearing and Settlement"
    set GLOBALS(EMAIL_MEDIUM_SUBJECT) "$GLOBALS(SYS_BOX) :: Priority : Medium - Clearing and Settlement"
    set GLOBALS(EMAIL_LOW_SUBJECT) "$GLOBALS(SYS_BOX) :: Priority : Low - Clearing and Settlement"


    #Email Body Headers variables for assist
    set GLOBALS(EMAIL_CRITICAL_BODY) "ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
    set GLOBALS(EMAIL_URGENT_BODY) "ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
    set GLOBALS(EMAIL_HIGH_BODY) "ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
    set GLOBALS(EMAIL_MEDIUM_BODY) "ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
    set GLOBALS(EMAIL_LOW_BODY) "ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"






}

proc pad_front { field_length string_to_pad filler } {

    if { [string length $string_to_pad] >= $field_length } {
        return [string range $string_to_pad 0 [expr $field_length - 1]]
    } else {
        set front_padding [string repeat $filler [expr {$field_length} - [string length $string_to_pad]]]
        return [ append front_padding $string_to_pad]
    }

}


proc set_moved_file_name { target_dir initial_file_name } {
    global SUCCESS_CODES
    global STD_OUT_CHANNEL
    global GLOBALS

    set sequence 1


    set unique_file_name 0
    set final_file_name $initial_file_name

    #check target directory for duplicate file name
    if { [file exists $target_dir/$initial_file_name] } {
        set unique_file_name 0
    } else {
        set unique_file_name 1
    }

    while { !$unique_file_name } {
        incr sequence

        puts $STD_OUT_CHANNEL "\t\tFound $target_dir/$final_file_name.  Creating new file name."
        set final_file_name $final_file_name.[pad_front 3 $sequence 0]
        if { [file exists $target_dir/$final_file_name] } {
            set unique_file_name 0
        } else {
            set unique_file_name 1
            puts $STD_OUT_CHANNEL "\t\tUsing unique file name $final_file_name."
        }
    }


    return $final_file_name
}


proc file_check { } {
    global COMMAND_STRING
    global DIRECTORIES
    global SKIP_FILES
    global SPECIAL_GLOB
    global EMPTY_FILE_RULES
    global STD_OUT_CHANNEL
    global SUCCESS_CODES
    global LOSTFOUNDDIR
    global REPORT_STRING
    global GLOBALS

    set found_file_to_report 0

    foreach directory $DIRECTORIES {

        puts $STD_OUT_CHANNEL "\n\tChecking $directory"
        append REPORT_STRING "Checking $directory\n"
        puts $STD_OUT_CHANNEL "\tcd $directory"
        if { [catch {puts $STD_OUT_CHANNEL "\t[cd $directory]"} failure] } {
            ## if the directory does not exist or cannot cd into it for
            ## any particular reason, consider this an error but continue
        append REPORT_STRING "\t\tCould not cd to $directory: $failure\n"
        set found_file_to_report 1
        continue
    }

        if { [info exists SPECIAL_GLOB($directory)] } {
            puts $STD_OUT_CHANNEL "\tSetting glob to $SPECIAL_GLOB($directory)"
            set files [glob -nocomplain $SPECIAL_GLOB($directory)]
        } else {
            set files [glob -nocomplain *]
        }



        foreach file $files {
            # check to see if this file is in the skip file list
            if { [lsearch $SKIP_FILES($directory) $file ] != -1 } {
                puts $STD_OUT_CHANNEL "\t\tFound $file.  This is in the skip file list.  Skipping."
                #append REPORT_STRING "\tFound $file.  This is in the skip file list.  Skipping.\n"
                continue
            }
            # ignore directories
            if { [file isdirectory $file] == 1 } {
                puts $STD_OUT_CHANNEL "\t\tFound $file.  This is a directory.  Skipping."
                #append REPORT_STRING "\tFound $file.  This is a directory.  Skipping.\n"
                continue
            }

            puts $STD_OUT_CHANNEL "\t\tFound $file."
            append REPORT_STRING "\t\tFound $file.\n"
            set found_file_to_report 1
            # not a directory, not a skip file
            # is it 0 bytes?
                # if so, what does this directory do with 0 byte files?
            if { [file size $file] == 0 } {
                puts $STD_OUT_CHANNEL "\t\t$file is a 0 byte file."
                append REPORT_STRING "\t\t$file is a 0 byte file.\n"
                if { [lindex $EMPTY_FILE_RULES($directory) 0] == "IGNORE" } {
                    puts $STD_OUT_CHANNEL "\t\tDirectory rules are to leave empty files.  Keeping $file in $directory"
                    append REPORT_STRING "\t\tDirectory rules are to leave empty files.  Keeping $file in $directory\n"

                } elseif { [lindex $EMPTY_FILE_RULES($directory) 0] == "MOVE" } {
                    puts $STD_OUT_CHANNEL "\t\tDirectory rules are to move empty files.  Moving $file to $LOSTFOUNDDIR"
                    append REPORT_STRING "\t\tDirectory rules are to move empty files.  Moving $file to $LOSTFOUNDDIR\n"
                    file rename $file $LOSTFOUNDDIR/[set_moved_file_name $LOSTFOUNDDIR [file tail $file]]

                } else {
                    # treat as ignore but still report.

                }
            } else {
                # just report the file, don't touch it.
                puts $STD_OUT_CHANNEL "\t\t[exec ls -l $file]"
                append REPORT_STRING "\t\t[exec ls -l $file]\n"
            }



        }

        #puts $STD_OUT_CHANNEL "\n\n"
        append REPORT_STRING "\n\n"



    }
    return $found_file_to_report

}


# pass in a main message body, a message body header such as "ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
# and a message subject
# modified from normal send alert.  This does not exit
proc send_alert_email { main_email_body message_subject email_body_header } {
    global GLOBALS
    global SUCCESS_CODES
    global STD_OUT_CHANNEL


    if { $GLOBALS(RUN_AS_TEST) == 1 } {
        puts $STD_OUT_CHANNEL "\t$GLOBALS(INDENT) exec echo \"$email_body_header $GLOBALS(SYSINFO) $main_email_body\" | mailx -r $GLOBALS(MAILFROM_LIST) -s \"$message_s
ubject\" $GLOBALS(MAILTO_LIST)"
    } else {
        exec echo "$email_body_header $GLOBALS(SYSINFO) $main_email_body" | mailx -r $GLOBALS(MAILFROM_LIST) -s "$message_subject" $GLOBALS(MAILTO_LIST)
    }



}




proc main {} {
    global GLOBALS
    global COMMAND_STRING
    global DIRECTORIES
    global SKIP_FILES
    global SPECIAL_GLOB

    global STD_OUT_CHANNEL
    global SUCCESS_CODES
    global LOSTFOUNDDIR
    global REPORT_STRING

    global argv

    set COMMAND_STRING "[info script]"
    foreach argument $argv {
        append COMMAND_STRING " $argument"
    }

    setup

    puts $STD_OUT_CHANNEL "[clock format [clock seconds] -format "%D %T"]"
    puts $STD_OUT_CHANNEL "Beginning $COMMAND_STRING"



    # start out with the urgent body.
    set REPORT_STRING ""

    if { [file_check] == 1 } {
        # report the results with an URGENT subject line and indication of change before cleanup
        # check again after making the changes.


        # proc send_alert_email { main_email_body message_subject email_body_header }
        ##send_alert_email $REPORT_STRING  "$GLOBALS(EMAIL_LOW_SUBJECT) Global extra files check " $GLOBALS(EMAIL_LOW_BODY)

        # reset the report string
        set REPORT_STRING ""

        if { [file_check] == 0 } {
            # report the results again with an URGENT subject line and indication of post-cleanup
            # and indicate that all problems were corrected
            ##send_alert_email $REPORT_STRING  "$GLOBALS(EMAIL_LOW_SUBJECT)Global extra files check CLEANUP SUCCEEDED" "Cleanup succeeded!"
            after 5
        } else {
            # report the results again with an URGENT subject line and indication of post-cleanup
            # and indicate that problems could not be auto-corrected
            send_alert_email $REPORT_STRING  "$GLOBALS(EMAIL_URGENT_SUBJECT) Global extra files check CLEANUP NEEDED" $GLOBALS(EMAIL_URGENT_BODY)
        }

    } else {
        # successful email -- not URGENT -- indicating we are good to go.
        set REPORT_STRING "All directories checked.  No 0 byte or extra files found. We are good to go."
        set successful_subject "$GLOBALS(SYS_BOX) Global extra files check succeeded."
        ##send_alert_email $REPORT_STRING $successful_subject "NO ATTENTION NEEDED\n"

    }



    exit_with_code $SUCCESS_CODES(SUCCESS)


}



###############
# If invalid arguments are give, give a usage statement
###############
proc usage_statement { exit_code } {
    global STD_OUT_CHANNEL

    puts $STD_OUT_CHANNEL "Usage: [info script] (no options) "
    exit_with_code $exit_code

}



# exit with an exit code
# and clean up anything that needs to be cleaned up
proc exit_with_code { exit_code {log_message ""} } {
    global COMMAND_STRING
    global STD_OUT_CHANNEL
    global GLOBALS
    #global use_input_file

    # TODO comment the procs that you aren't using
    #if { $use_input_file == 1 } {
    #    close_input_file
    #}

    #close_output_file
    #close_db_connections


    puts $STD_OUT_CHANNEL "[clock format [clock seconds] -format "%D %T"]"
    puts $STD_OUT_CHANNEL "Ending $COMMAND_STRING with exit code $exit_code"


    #close_log_file

    exit $exit_code

}



main
