#!/usr/bin/env tclsh

# $Id: monitor_tasks.tcl 3526 2015-10-04 23:00:30Z bjones $

package require Oratcl
package require Expect

#Environment variables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(IST_DB)
set authdb $env(ATH_DB)

#Email Subjects variables Priority wise
#TODO set subject lines from config file
set msubj_c "$box :: Priority : Critical - Clearing and Settlement"
set msubj_u "$box :: Priority : Urgent - Clearing and Settlement"
set msubj_h "$box :: Priority : High - Clearing and Settlement"
set msubj_m "$box :: Priority : Medium - Clearing and Settlement"
set msubj_l "$box :: Priority : Low - Clearing and Settlement"


#Email Body Headers variables for assist
# TC50 is a non-essential task -- set priority medium
set mbody_c "ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
set mbody_u "ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
set mbody_h "ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
set mbody_m "ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
set mbody_l "ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

#System information variables....

set sysinfo "System: $box\n Location: $env(PWD) \n\n"


#################################################################
# globals
#################################################################

#############################
# database connections
#############################
#TODO keep the database connection names you will use
# comment or delete the rest
global uses_masclr

global database_login_data
global masclr_cursor_insert
global masclr_cursor_update
global masclr_cursor_query1
global masclr_cursor_query2
global masclr_logon_handle

global database_name_masclr


#############################
# input/output
#############################


global STD_OUT_CHANNEL


#############################
# usage options
#############################


#############################
# common globals
#############################


#############################
# exit codes
#############################
global SUCCESS_CODES
global arguments


#################################################################
# procs
#################################################################

proc open_db_connections {} {
    global SUCCESS_CODES
# TODO Only include the database connections that you need
# comment the rest
    global masclr_cursor_insert
    global masclr_cursor_update
    global masclr_cursor_query1
    global masclr_cursor_query2
    global masclr_logon_handle

    global database_login_data
    global STD_OUT_CHANNEL
    global uses_masclr


    if { $uses_masclr == 1 } {
        if {[catch {set masclr_logon_handle [oralogon $database_login_data(MASCLR)]} result]} {
            puts $STD_OUT_CHANNEL "Could not open database connections.  Result: $result"
            exit_with_code $SUCCESS_CODES(DB_ERROR)
        }
        set masclr_cursor_insert [oraopen $masclr_logon_handle]
        set masclr_cursor_update [oraopen $masclr_logon_handle]
        set masclr_cursor_query1 [oraopen $masclr_logon_handle]
        set masclr_cursor_query2 [oraopen $masclr_logon_handle]
    }


    # now clear the database_login_data array
    array unset database_login_data
    return $SUCCESS_CODES(SUCCESS)
}

proc close_db_connections {} {
    global SUCCESS_CODES
# TODO Only include the database connections that you need
# comment the rest
    global masclr_cursor_insert
    global masclr_cursor_update
    global masclr_cursor_query1
    global masclr_cursor_query2
    global masclr_logon_handle

    global uses_masclr


    if { $uses_masclr == 1 } {
        if { [info exists masclr_cursor_insert] } {
            oraclose $masclr_cursor_insert
        }
        if { [info exists masclr_cursor_update] } {
            oraclose $masclr_cursor_update
        }
        if { [info exists masclr_cursor_query1] } {
            oraclose $masclr_cursor_query1
        }
        if { [info exists masclr_cursor_query2] } {
            oraclose $masclr_cursor_query2
        }
        if { [info exists masclr_logon_handle] } {
            oralogoff $masclr_logon_handle
        }
    }


    return $SUCCESS_CODES(SUCCESS)
}


###########################
# creates an array called arguments that has each
# argument name as an array key and the argument value as that
# key's value
proc parse_arguments {} {
    global SUCCESS_CODES
    global arguments
    global argv
    global use_input_file
    global use_output_file
    global run_as_test
    global STD_OUT_CHANNEL
    global GLOBALS

    # command line arguments like
    # command --inst 101 --f filename --destdir dirname --run_as_test 1
    # will be added to the arguments array for retrieval later


    foreach {argument value} $argv {
        set arguments($argument) $value
    }

    # standard arguments
    if { [info exists arguments(--help)] || [info exists arguments(-h)] } {
        usage_statement $SUCCESS_CODES(HELP)
    }

    if { [info exists arguments(--inst)]  } {
        set GLOBALS(INST_ID) $arguments(--inst)
        puts $STD_OUT_CHANNEL "Monitoring tasks for institution ID $GLOBALS(INST_ID)."
    } else {
        usage_statement $SUCCESS_CODES(INVALID_ARGUMENTS)
    }

    if { [info exists arguments(--usage)] } {
        if { [string range $arguments(--usage) 0 1] == "--" } {
            usage_statement $success_codes(INVALID_ARGUMENTS)
        }
        if { $arguments(--usage) == "MAS" || $arguments(--usage) == "CLEARING" } {
            set GLOBALS(USAGE) [split_list_surround_quotes $arguments(--usage) ]
        } else {
            set GLOBALS(USAGE) [split_list_surround_quotes {MAS CLEARING}]
        }
        set GLOBALS(USAGE)

    } else {
        set GLOBALS(USAGE) [split_list_surround_quotes {MAS CLEARING}]
    }

}


proc parse_database_login_file {} {
    global SUCCESS_CODES
    global STD_OUT_CHANNEL
    global database_login_file_name
    global database_login_data
    global uses_masclr


    #TODO use one of two methods and comment the other one

    # old method
    # rather than using database login file, the login is hardcoded pending a different solution from sysops
    global clrdb
    set database_login_data(MASCLR) "masclr/masclr@$clrdb"


    # or new method

    if {[catch {open $database_login_file_name {RDONLY}} database_login_file_handle]} {
        puts $STD_OUT_CHANNEL "Cannot open file $database_login_file_name. "
        return $SUCCESS_CODES(IO_ERROR)
    }

    # read the database logins
    set cur_line  [split [set orig_line [gets $database_login_file_handle] ] ,]
    while {$cur_line != ""} {

        set schema [string trim [lindex $cur_line 0]]

        switch -exact -- $schema {
            "MASCLR" {
                if { $uses_masclr == 1} {
                    set database_login_data(MASCLR) "[string trim [lindex $cur_line 1]]/[string trim [lindex $cur_line 2]]@[string trim [lindex $cur_line 3]]"
                }
            }
        }

        set cur_line  [split [set orig_line [gets $database_login_file_handle] ] ,]
    }

    if {[catch {close $database_login_file_handle} response]} {
        return $SUCCESS_CODES(IO_ERROR)
    }

    return $SUCCESS_CODES(SUCCESS)
}


proc pad_front { field_length string_to_pad filler } {

    if { [string length $string_to_pad] >= $field_length } {
        return [string range $string_to_pad 0 [expr $field_length - 1]]
    } else {
        set front_padding [string repeat $filler [expr {$field_length} - [string length $string_to_pad]]]
        return [ append front_padding $string_to_pad]
    }

}

proc pad_end { field_length string_to_pad filler } {

    if { [string length $string_to_pad] >= $field_length } {
        return [string range $string_to_pad 0 [expr $field_length - 1]]
    } else {
        set end_padding [string repeat $filler [expr {$field_length} - [string length $string_to_pad]]]
        return [ append string_to_pad $end_padding ]
    }
}

#######################
# should check return value
# and log an error if there is a problem sending
# should also send a simple message (no attachment, etc) with mailx if mutt fails
#######################
proc send_file { email_to_list {email_subject ""} {email_body ""} {email_file_attachments_list ""} } {
    global SUCCESS_CODES
    global STD_OUT_CHANNEL

    set attachment_string ""
    if { [ llength $email_file_attachments_list ] } {
        foreach filename $email_file_attachments_list {
            if { [ file exists $filename ] } {
                append attachment_string "-a $filename "
            }
        }
    }


    set mailpipe [open "| mutt -s $email_subject $attachment_string $email_to_list" w ]
    if { [info exists mailpipe] } {
        if { [ catch {
            if { [file exists $email_body] } {
                set email_body_file_id [open $email_body]
                puts $mailpipe [read $email_body_file_id]
            } else {
                #parameter is plain text
                puts $mailpipe $email_body
            }
        } result ] } {
            puts $STD_OUT_CHANNEL $result
            return $SUCCESS_CODES(MAIL_ERROR)
        }
    }
    return $SUCCESS_CODES(SUCCESS)
}

#NOTE This proc has been taken from http://wiki.tcl.tk/15659
proc lremove {args} {
     if {[llength $args] < 2} {
        puts stderr {Wrong # args: should be "lremove ?-all? list pattern"}
     }
     set list [lindex $args end-1]
     set elements [lindex $args end]
     if [string match -all [lindex $args 0]] {
        foreach element $elements {
            set list [lsearch -all -inline -not -exact $list $element]
        }
     } else {
        # Using lreplace to truncate the list saves having to calculate
        # ranges or offsets from the indexed element. The trimming is
        # necessary in cases where the first or last element is the
        # indexed element.
        foreach element $elements {
            set idx [lsearch $list $element]
            set list [string trim \
                "[lreplace $list $idx end] [lreplace $list 0 $idx]"]
        }
     }
     return $list
 }

proc monitor_tasks {} {
    global SUCCESS_CODES
    global GLOBALS
    global database_name_masclr
    global masclr_cursor_query1
    global STD_OUT_CHANNEL

    global TASK_LIST
    set TASK_LIST {}
    global IGNORE_TASK
    global RUNNING_TASK
    set RUNNING_TASK {}
    lappend IGNORE_TASK "100"
    lappend IGNORE_TASK "200"

    set status_message ""
    #TODO if more than one institution will be monitored at one time, need to account for institution ID

    set debugging 0

    set timeout 10
    set continue_monitoring 1
    set check_tasks_sql "select tl.INSTITUTION_ID, tl.TASK_LOG_SEQ, tl.USAGE, tl.CMD_NBR, t.TASK_NAME, tl.actual_start_dt , to_char(tl.ACTUAL_START_DT, 'DD-MON-YYYY HH:MI:SS AM') as \"FULL_START_DT\", to_char(tl.ACTUAL_FINISH_DT, 'DD-MON-YYYY HH:MI:SS AM') as \"ACTUAL_FINISH_DT\", tl.RESULT
    from task_log tl, tasks t
where tl.institution_id = $GLOBALS(INST_ID)
and actual_start_dt like sysdate
and tl.usage in ( $GLOBALS(USAGE) )
and tl.institution_id = t.institution_id
and tl.CMD_NBR = t.CMD_NBR
order by actual_start_dt"
    while { $continue_monitoring == 1 } {

        puts $STD_OUT_CHANNEL [exec clear]

        puts $STD_OUT_CHANNEL "[pad_end 10 "INST ID" " "][pad_end 8 "USAGE" " "] [pad_end 7 "CMD_NBR" " "] [pad_end 40 "TASK_NAME" " "] [pad_end 23 "ACTUAL_START_DT" " "]  [pad_end 23 "ACTUAL_FINISH_DT" " "]  [pad_end 11 "RESULT" " "]"
        orasql $masclr_cursor_query1 $check_tasks_sql

        while {1} {
            if {[catch {orafetch $masclr_cursor_query1 -dataarray tasks_result_arr -indexbyname} result_code]} {
                puts stderr "Error with $check_tasks_sql"
                puts stderr "[oramsg $masclr_cursor_query1 rc] [oramsg $masclr_cursor_query1 error]"
                # break or exit or ignore

            }
            if {[oramsg $masclr_cursor_query1 rc] != 0} break

            # if MAS task, not in the ignore list is not DONE and not already in the RUNNING_TASK or TASK_LIST list, add it to RUNNING_TASK
            if { $tasks_result_arr(USAGE) == "MAS"
                    &&  [lsearch -exact $IGNORE_TASK $tasks_result_arr(CMD_NBR)] == -1
                    && $tasks_result_arr(RESULT) != "DONE"
                    && $tasks_result_arr(RESULT) != "SUCCESSFUL"
                    && [lsearch -exact $RUNNING_TASK $tasks_result_arr(TASK_LOG_SEQ)] == -1
                    &&  [lsearch -exact $TASK_LIST $tasks_result_arr(TASK_LOG_SEQ)] == -1 } {
                # add to RUNNING_TASK
                append status_message "Found NEW TASK $tasks_result_arr(CMD_NBR) $tasks_result_arr(TASK_NAME)\n"
                lappend RUNNING_TASK $tasks_result_arr(TASK_LOG_SEQ)
                #if { $debugging == 1 } {
                #    append status_message "append status_message \"Found NEW TASK $tasks_result_arr(CMD_NBR) $tasks_result_arr(TASK_NAME)\n\"\n"
                #    append status_message "lappend RUNNING_TASK $tasks_result_arr(TASK_LOG_SEQ)\n"
                #}

            } elseif { $tasks_result_arr(USAGE) == "MAS"
                    && ($tasks_result_arr(RESULT) == "DONE"
                    || $tasks_result_arr(RESULT) == "SUCCESSFUL")
                    && [lsearch -exact $TASK_LIST $tasks_result_arr(TASK_LOG_SEQ)] == -1} {
                # if task log seq not in TASK_LIST and MAS command already DONE, add to task list and display message
                append status_message "Found NEW TASK that is already FINISHED $tasks_result_arr(CMD_NBR) $tasks_result_arr(TASK_NAME)\n"
                #if { $debugging == 1 } {
                #    append status_message "append status_message \"Found NEW TASK that is already FINISHED $tasks_result_arr(CMD_NBR) $tasks_result_arr(TASK_NAME)\n\"\n"
                #
                #}

            } elseif { [lsearch -exact $TASK_LIST $tasks_result_arr(TASK_LOG_SEQ)] == -1
                    &&  [lsearch -exact $IGNORE_TASK $tasks_result_arr(CMD_NBR)] == -1 } {
                # just add the task seq nbr to TASK_LIST.  This is probably a clearing task
                append status_message "Found NEW TASK $tasks_result_arr(CMD_NBR) $tasks_result_arr(TASK_NAME)\n"
                #if { $debugging == 1 } {
                #    append status_message "append status_message \"Found NEW TASK $tasks_result_arr(CMD_NBR) $tasks_result_arr(TASK_NAME)\n\"\n"
                #
                #}
            }

            # if task_log_seq in RUNNING_TASK list and the result is now DONE
            if { [lsearch -exact $RUNNING_TASK $tasks_result_arr(TASK_LOG_SEQ)] != -1
                    && ($tasks_result_arr(RESULT) == "DONE"
                    || $tasks_result_arr(RESULT) == "SUCCESSFUL")} {
                append status_message "$tasks_result_arr(CMD_NBR) $tasks_result_arr(TASK_NAME) FINISHED\n"

                set RUNNING_TASK [lremove $RUNNING_TASK $tasks_result_arr(TASK_LOG_SEQ)]
                if { $debugging == 1 } {
                    append status_message "append status_message \"$tasks_result_arr(CMD_NBR) $tasks_result_arr(TASK_NAME) FINISHED\n\"\n"
                    append status_message "lremove $RUNNING_TASK $tasks_result_arr(TASK_LOG_SEQ)\n"
                    append status_message "RUNNING_TASK: $RUNNING_TASK\n"
                }
            }

            # if existing task still running
            if { [lsearch -exact $RUNNING_TASK $tasks_result_arr(TASK_LOG_SEQ)] != -1
                    && $tasks_result_arr(RESULT) != "DONE"
                    && $tasks_result_arr(RESULT) != "SUCCESSFUL"} {
                append status_message "$tasks_result_arr(CMD_NBR) $tasks_result_arr(TASK_NAME) STILL RUNNING\n"
                #if { $debugging == 1 } {
                #    append status_message "append status_message \"$tasks_result_arr(CMD_NBR) $tasks_result_arr(TASK_NAME) STILL RUNNING\n\"\n"
                #
                #}
            }


            if { [lsearch -exact $TASK_LIST $tasks_result_arr(TASK_LOG_SEQ)] == -1 } {
                lappend TASK_LIST $tasks_result_arr(TASK_LOG_SEQ)
                #if { $debugging == 1 } {
                #    append status_message "lappend TASK_LIST $tasks_result_arr(TASK_LOG_SEQ)\n"
                #
                #}
            }


            puts $STD_OUT_CHANNEL "[pad_end 10 $tasks_result_arr(INSTITUTION_ID) " "] [pad_end 8 $tasks_result_arr(USAGE) " "] [pad_end 7 $tasks_result_arr(CMD_NBR) " "] [pad_end 40 $tasks_result_arr(TASK_NAME) " "][pad_end 23 $tasks_result_arr(FULL_START_DT) " "]  [pad_end 23 $tasks_result_arr(ACTUAL_FINISH_DT) " "]  [pad_end 11 $tasks_result_arr(RESULT) " "]"

        }
        # give user time to indicate that monitoring should stop.


        puts $STD_OUT_CHANNEL "\nRefreshed at [clock format [clock seconds] -format "%d-%B-%Y %H:%M:%S"]\n\n"
        puts $STD_OUT_CHANNEL $status_message
        puts $STD_OUT_CHANNEL "\nUse q <Enter> to stop monitoring."
        set status_message ""

        expect {
            q               {set continue_monitoring 0}
            Q               {set continue_monitoring 0}
            timeout         {set continue_monitoring 1}
        }
    }
}


# pass this a list of values such as { AMEX_AUTH DISC_AUTH VISA_AUTH MC_AUTH OTHER_AUTH }
# and the proc returns this: 'AMEX_AUTH', 'DISC_AUTH', 'VISA_AUTH', 'MC_AUTH', 'OTHER_AUTH'
proc split_list_surround_quotes { the_list } {
    return "\'[join [split $the_list " "] "\',\'"]\'"
}


#################################################################
# main
#################################################################

proc main {} {
    global SUCCESS_CODES
    global STD_OUT_CHANNEL
    global COMMAND_STRING
    global use_input_file
    global use_output_file
    global run_as_test
    global argv
    global arguments


    #initialize global variables
    setup

    set COMMAND_STRING "[info script]"
    foreach argument $argv {
        append COMMAND_STRING " $argument"
    }

    # report the script and its arguments
    puts $STD_OUT_CHANNEL "[clock format [clock seconds] -format "%D %T"] Beginning $COMMAND_STRING"

    #TODO if using an internally controlled log file, keep this
    # if calling from cron and redirecting std out to a log file, you may not need
    # to keep an internally controlled log file, so this could be removed
    # if a log file cannot be opened, STD_OUT_CHANNEL will be standard output


    parse_arguments


    # TODO comment the procs that you aren't using
    parse_database_login_file
    open_db_connections


    monitor_tasks


    #######################################################
    #  TODO real stuff starts here.
    #######################################################

    exit_with_code $SUCCESS_CODES(SUCCESS)

}


########################
# setup
# set default values for global variables
# these may change depending on arguments to the script
# change any script-specific defaults here
# such as the log file to use
# or a specific config file, etc.
########################

proc setup {} {
    global SUCCESS_CODES

    global arguments

    global STD_OUT_CHANNEL
    set STD_OUT_CHANNEL stdout

    global database_login_file_name
    set database_login_file_name "database_login.cfg"

    set SUCCESS_CODES(SUCCESS) 0
    set SUCCESS_CODES(DB_ERROR) 1
    set SUCCESS_CODES(IO_ERROR) 5
    set SUCCESS_CODES(MAIL_ERROR) 7
    set SUCCESS_CODES(INVALID_ARGUMENTS) 22
    set SUCCESS_CODES(HELP) 9

    global uses_masclr
    set uses_masclr 1

    global database_name_masclr
    set database_name_masclr(PROD) "@masclr_trnclr1"
    set database_name_masclr(QA) ""
    set database_name_masclr(DEV) "@masclr_transd"

}


###############
# If invalid arguments are give, give a usage statement
###############
proc usage_statement { exit_code } {
    global STD_OUT_CHANNEL

    puts $STD_OUT_CHANNEL "Usage: [info script] --inst inst_id ?--usage usage_options?"
    puts $STD_OUT_CHANNEL "  where --inst inst_id indicates the institution ID to monitor"
    puts $STD_OUT_CHANNEL "  and --usage usage_options is an optional MAS or CLEARING option"
    puts $STD_OUT_CHANNEL "  so only those tasks are shown "
    exit_with_code $exit_code

}

# exit with an exit code
# and clean up anything that needs to be cleaned up
proc exit_with_code { exit_code {log_message ""} } {
    global COMMAND_STRING
    global STD_OUT_CHANNEL

    close_db_connections

    if { $exit_code != 0 } {
        puts $STD_OUT_CHANNEL $log_message
        puts $STD_OUT_CHANNEL "Ending $COMMAND_STRING with exit code $exit_code"
    }

    exit $exit_code

}

###############
# Run proc main
###############
main
