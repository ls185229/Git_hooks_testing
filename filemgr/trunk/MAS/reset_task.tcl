#!/usr/bin/env tclsh

# $Id: reset_task.tcl 3819 2016-07-05 16:54:54Z skumar $

#NOTE does not check for process.stop.  Does not set process.stop.
# This code needs to be able to run in all circumstances.

#TODO convert to use send_alert_email



package require Oratcl




proc connect_to_db {} {
    global masclr_logon_handle db_connect_handle msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l box clrpath maspath mailtolist mailfromlist clrdb authdb
    global masclr_cursor_update
    global env
    if {[catch {set masclr_logon_handle [oralogon masclr/masclr@$env(IST_DB)]} result] } {
        puts "Encountered error $result while trying to connect to DB"
        set mbody "ALL PROCESSES STOPPED SINCE reset_task.tcl could not logon to DB : Msg sent from reset_task.tcl\n $result"
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        exit 1
    }

    set masclr_cursor_update [oraopen $masclr_logon_handle]

};# end connect_to_db

proc close_db_connections {} {
    global success_codes


    global masclr_cursor_update
    global masclr_logon_handle

    if { [info exists masclr_cursor_update] } {
        oraclose $masclr_cursor_update
    }


    if { [info exists masclr_cursor_update] } {
        oralogoff $masclr_logon_handle
    }



    return $success_codes(SUCCESS)
}


proc send_alert_email { main_email_body message_subject email_body_header exit_code } {
    global GLOBALS
    global success_codes

    exec echo "$email_body_header $GLOBALS(SYSINFO) $main_email_body" | mailx -r $GLOBALS(MAILFROM_LIST) -s "$message_subject" $GLOBALS(MAILTO_LIST)

    exit_with_code $exit_code $main_email_body
}


proc setup {} {
    global GLOBALS
    global env
    global success_codes
    global argv
    global std_out_channel


    set std_out_channel stdout
    global indent
    set indent "    "

    set GLOBALS(RUN_AS_TEST) 0

    set GLOBALS(INST_ID) 0
    set GLOBALS(TASK_NBR) 0
    set GLOBALS(GLOBALS(SETTLEMENT_ROUTING_NBR)) 0
    set GLOBALS(SYS_BOX) $env(SYS_BOX)
    set GLOBALS(PROCESS_STOP_FILE) "/clearing/filemgr/process.stop"
    set GLOBALS(SYSINFO) "System: $GLOBALS(SYS_BOX)\n Location: $env(PWD) \n\n"


    #set clrpath $env(CLR_OSITE_ROOT)
    #set maspath $env(MAS_OSITE_ROOT)
    set GLOBALS(MAILTO_LIST) $env(MAIL_TO)
    set GLOBALS(MAILFROM_LIST) $env(MAIL_FROM)
    set GLOBALS(CLEARING_DB) $env(IST_DB)
    #set authdb $env(ATH_DB)

    #declearing variables for commandline arguments.

    #TODO move to GLOBALS
#    set GLOBALS(INST_ID) [lindex $argv 0]
#    set GLOBALS(TASK_NBR) [lindex $argv 1]

    #TODO move to GLOBALS
    #set GLOBALS(SETTLEMENT_ROUTING_NBR) [lindex $argv 2]

    # only used in command 105, which we don't use
    # kept for legacy use
    #set srtn [lindex $argv 3]
    set srtn ""


    # success codes used for procs and to exit the script
    set success_codes(SUCCESS) 0
    set success_codes(DB_ERROR) 1
    set success_codes(IO_ERROR) 5
    set success_codes(MAIL_ERROR) 7
    set success_codes(INVALID_ARGUMENTS) 22
    set success_codes(SEND_FILE_ERROR) 30
    set success_codes(PROCESS_STOP_FILE_FOUND_ERROR) 40
    set success_codes(SERVER_BUSY_ERROR) 50
    set success_codes(HELP) 9


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

###########################
# creates an array called arguments that has each
# argument name as an array key and the argument value as that
# key's value
proc parse_arguments {} {
    global success_codes
    global arguments
    global argv
    global use_input_file
    global use_output_file
    global std_out_channel
    global indent

    global GLOBALS


    # command line arguments like
    # command --inst 101 --f filename --destdir dirname --run_as_test 1
    # will be added to the arguments array for retrieval later



    foreach {argument value} $argv {
        set arguments($argument) $value
    }

    # standard arguments
    if { [info exists arguments(--help)] || [info exists arguments(-h)] } {
        usage_statement $success_codes(HELP)
    }
    if { [info exists arguments(--inst)]  } {
        if { [string range $arguments(--inst) 0 1] == "--" } {
            usage_statement $success_codes(INVALID_ARGUMENTS)
        }
        set GLOBALS(INST_ID) $arguments(--inst)


        puts $std_out_channel "$indent setting institution ID $GLOBALS(INST_ID)"
    } else {
        # assume all institutions

        set GLOBALS(INST_ID) "ALL"
        puts $std_out_channel "$indent resetting for all institutions"
    }

    if { [info exists arguments(--run_type)]  } {
        if { [string range $arguments(--run_type) 0 1] == "--" } {
            usage_statement $success_codes(INVALID_ARGUMENTS)
        }
        if { $arguments(--run_type) == "CRON" } {
            set GLOBALS(RUN_TYPE) "CRON"
        } else {
            # no matter what else is given, it must be manual
            set GLOBALS(RUN_TYPE) "MANUAL"
        }
        puts $std_out_channel "$indent setting run type to $GLOBALS(RUN_TYPE)"
    } else {
        usage_statement $success_codes(INVALID_ARGUMENTS)
    }


    if { [info exists arguments(--test)] && $arguments(--test) == 1   } {
        set GLOBALS(RUN_AS_TEST) $arguments(--test)
        puts $std_out_channel "$indent running as test"
    }



    if { [info exists arguments(--task_nbrs)]  } {
        if { [string range $arguments(--task_nbrs) 0 1] == "--" } {
            usage_statement $success_codes(INVALID_ARGUMENTS)
        }
        set GLOBALS(TASK_NBRS) $arguments(--task_nbrs)
        puts -nonewline $std_out_channel "$indent tasks to reset: "
        foreach task $arguments(--task_nbrs) {
            puts -nonewline $std_out_channel "$task "
        }
        puts $std_out_channel ""
    }

}

###############
# If invalid arguments are give, give a usage statement
###############
proc usage_statement { exit_code } {
    global std_out_channel

    puts $std_out_channel "Usage: [info script] --run_type \[CRON|MANUAL\] --inst XXX ?--test \[1|0\]? ?--task_nbrs task_list? "
    puts $std_out_channel "  where --run_type \[CRON|MANUAL\] indicates whether this was run automatically (CRON) or manually "
    puts $std_out_channel "  --inst XXX means run for institution ID XXX.  XXX can be ALL, which will reset the tasks for "
    puts $std_out_channel "  --task_nbrs can be a list of specific task numbers to reset.  This will be converted to a tcl list.  Make sure that the list of task numbers is surrounded in quotes."
    exit_with_code $exit_code

}


# exit with an exit code
# and clean up anything that needs to be cleaned up
proc exit_with_code { exit_code {log_message ""} } {
    global command_string
    global std_out_channel
    global indent



    close_db_connections

    puts $std_out_channel $log_message
    puts $std_out_channel "$indent [clock format [clock seconds] -format "%D %T"]"
    puts $std_out_channel "$indent Ending $command_string with exit code $exit_code"



    exit $exit_code

}


# pass this a list of values such as { AMEX_AUTH DISC_AUTH VISA_AUTH MC_AUTH OTHER_AUTH }
# and the proc returns this: 'AMEX_AUTH', 'DISC_AUTH', 'VISA_AUTH', 'MC_AUTH', 'OTHER_AUTH'
proc split_list_surround_quotes { the_list } {
    return "\'[join [split $the_list " "] "\',\'"]\'"
}


#######################################################################################################################

global GLOBALS
global env
global success_codes
global argv

#Environment variables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
if { "$env(SYS_BOX)" == "DEV" } {
    set mailtolist "clearing@jetpay.com"
} else {
    set mailtolist $env(MAIL_TO)
}
set mailfromlist $env(MAIL_FROM)
set clrdb $env(IST_DB)
set authdb $env(ATH_DB)

#Email Subjects variables Priority wise

set msubj_c "$box :: Priority : Critical - Clearing and Settlement"
set msubj_u "$box :: Priority : Urgent - Clearing and Settlement"
set msubj_h "$box :: Priority : High - Clearing and Settlement"
set msubj_m "$box :: Priority : Medium - Clearing and Settlement"
set msubj_l "$box :: Priority : Low - Clearing and Settlement"


#Email Body Headers variables for assist

set mbody_c "ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
set mbody_u "ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
set mbody_h "ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
set mbody_m "ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
set mbody_l "ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

#System information variables....

set sysinfo "System: $box\n Location: $env(PWD) \n\n"

#######################################################################################################################



set logdate [clock seconds]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]
#set inst_id [lindex $argv 0]
#set tsk_nbr [lindex $argv 1]

set GLOBALS(TASK_NBRS) {}


setup

global indent
global command_string
set command_string "[info script]"
foreach argument $argv {
    append command_string " $argument"
}

    # report the script and its arguments

puts $std_out_channel "$indent [clock format [clock seconds] -format "%D %T"]"
puts $std_out_channel "$indent Beginning $command_string"

parse_arguments
puts $std_out_channel "$indent Run type: $GLOBALS(RUN_TYPE)"


connect_to_db


# test cases will be
# set reset all tasks
# reset all tasks for a single institution
# reset 1 specific task for a single institution
# reset 2 tasks for a single institution
# reset 3 tasks for a single institution
# reset 1 specific task for all institutions
# reset 2 tasks for all institutions
# reset 3 tasks for all institutions


set use_where_clause 0
set use_inst_id 0
set specify_tasks 0
puts "$indent Resetting tasks table.  Institution: $GLOBALS(INST_ID)."

# don't include institution_id in the update statement
if { $GLOBALS(INST_ID) == "ALL"} {
    set inst_id_string ""
    set use_inst_id 0
} else {
    set inst_id_string "institution_id = '$GLOBALS(INST_ID)'"
    set use_where_clause 1
    set use_inst_id 1
}

if { $GLOBALS(TASK_NBRS) == "ALL" } {

    set specify_tasks 0


} elseif { [llength $GLOBALS(TASK_NBRS)] > 0 } {

    set use_where_clause 1
    set specify_tasks 1
    set task_nbrs_string "task_nbr in ( [split_list_surround_quotes $GLOBALS(TASK_NBRS)] )"


}

# in its raw form, this resets all tasks for all institutions
set update_task_sql "update tasks set run_hour = '', run_min = '' where usage = 'MAS' "
if { $use_where_clause == 1 } {

    if { $use_inst_id == 1 } {
        append update_task_sql " and $inst_id_string "
    }
    if { $specify_tasks == 1 } {

        append update_task_sql " and $task_nbrs_string "
    } else {
    }

}


if { $GLOBALS(RUN_AS_TEST) == 1 } {
    puts $std_out_channel "$indent $update_task_sql ;"
} else {
    if {[catch {orasql $masclr_cursor_update $update_task_sql} result_code]} {
        puts $std_out_channel $update_task_sql
        puts $std_out_channel "$indent Error with orasql: $result_code"
        exit_with_code $success_codes(DB_ERROR) "$indent Error with orasql: $result_code"

    }
    puts $std_out_channel "$indent $update_task_sql"
    puts $std_out_channel "$indent Rows affected: [oramsg $masclr_cursor_update rows] rows"

    if {[catch {oracommit $masclr_logon_handle} result_code]} {
        puts $std_out_channel "$indent Error with oracommit: $result_code"
        exit_with_code $success_codes(DB_ERROR) "$indent Error with oracommit: $result_code"

    }
    #orasql $masclr_cursor_update $update_task_sql
    #oracommit $masclr_logon_handle
}


exit_with_code $success_codes(SUCCESS)
