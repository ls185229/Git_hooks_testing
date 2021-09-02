#!/usr/bin/env tclsh

package require Oratcl

# $Id: sch_cmd.cy4.tcl 3819 2016-07-05 16:54:54Z skumar $


#######################################################################################################################
# GLOBALS


global GLOBALS
global success_codes



proc setup {} {
    global GLOBALS
    global argv
    global env
    global success_codes

    global indent
        set indent "    "

    global std_out_channel
    set std_out_channel stdout

    set GLOBALS(RUN_AS_TEST) 0

    set GLOBALS(INST_ID) 0
    set GLOBALS(TASK_NUMBER) 0
    set GLOBALS(ACH_ACCT_NBR) 0
    set GLOBALS(GL_DATE_EQUAL_TODAY) 1
    set GLOBALS(GL_CHECK_BEFORE_106) 1
    set GLOBALS(GL_DATE_EQUAL_TOMORROW) 2
    set GLOBALS(GL_CHECK_AFTER_106) 2

    set GLOBALS(CONFIG_DIR) "./CFG/"
    set GLOBALS(LOG_DIR) "./LOG/"
    set GLOBALS(DEBUG_LOG_FILE_NAME) "$GLOBALS(LOG_DIR)MAS.DEBUG.MULTI.task.log"
    set GLOBALS(LOG_FILE_NAME) "$GLOBALS(LOG_DIR)MAS.MULTI.task.log"


    set GLOBALS(FIELD_VALUE_CONTROL_TABLE) "FIELD_VALUE_CTRL"

    set GLOBALS(SYS_BOX) $env(SYS_BOX)
    set GLOBALS(SYSINFO) "System: $GLOBALS(SYS_BOX)\n Location: $env(PWD) \n\n"
    if { "$env(SYS_BOX)" == "DEV" } {
        set GLOBALS(MAILTO_LIST) "clearing@jetpay.com"
    } else {
        set GLOBALS(MAILTO_LIST) "clearing@jetpay.com"
        #set GLOBALS(MAILTO_LIST) $env(MAIL_TO)
    }
    set GLOBALS(MAILFROM_LIST) $env(MAIL_FROM)
    set GLOBALS(CLEARING_DB) $env(IST_DB)


    # only used in command 105, which we don't use
    # kept for legacy use
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
    set success_codes(MAS_ERROR) 60
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

    set GLOBALS(CURRENT_TIME) [clock format [clock seconds] -format "%H%M%S"]
    set GLOBALS(TODAY_CLR_FORMAT) [string toupper [clock format [clock seconds] -format "%d-%b-%y"]]
    set GLOBALS(CURRENT_DATE) [clock format [clock seconds] -format "%Y%m%d"]
    set GLOBALS(CURRENT_DATE_TIME) [clock format [clock seconds] -format "%Y%m%d%H%M%S"]

    set GLOBALS(RUN_HOUR) [clock format [clock seconds] -format "%H"]
    set GLOBALS(RUN_MINUTE) [clock format [clock seconds] -format "%M"]
    set GLOBALS(CMD_PARAMETERS) ""

    set GLOBALS(TASK_USAGE) "OTHER"


    #switch to remove zero from infront of time variable to avoid octal format.

    switch $GLOBALS(RUN_HOUR) {
        "01" {set GLOBALS(RUN_HOUR) 1}
        "02" {set GLOBALS(RUN_HOUR) 2}
        "03" {set GLOBALS(RUN_HOUR) 3}
        "04" {set GLOBALS(RUN_HOUR) 4}
        "05" {set GLOBALS(RUN_HOUR) 5}
        "06" {set GLOBALS(RUN_HOUR) 6}
        "07" {set GLOBALS(RUN_HOUR) 7}
        "08" {set GLOBALS(RUN_HOUR) 8}
        "09" {set GLOBALS(RUN_HOUR) 9}
          default {set GLOBALS(RUN_HOUR) $GLOBALS(RUN_HOUR)}
    }

    #switch to remove zero from infront of time variable to avoid octal format.

    switch $GLOBALS(RUN_MINUTE) {
        "00" {set GLOBALS(RUN_MINUTE) 1}
        "01" {set GLOBALS(RUN_MINUTE) 2}
        "02" {set GLOBALS(RUN_MINUTE) 3}
        "03" {set GLOBALS(RUN_MINUTE) 4}
        "04" {set GLOBALS(RUN_MINUTE) 5}
        "05" {set GLOBALS(RUN_MINUTE) 6}
        "06" {set GLOBALS(RUN_MINUTE) 7}
        "07" {set GLOBALS(RUN_MINUTE) 8}
        "08" {set GLOBALS(RUN_MINUTE) 9}
        "09" {set GLOBALS(RUN_MINUTE) 10}
          default {set GLOBALS(RUN_MINUTE) $GLOBALS(RUN_MINUTE)}
    }

    #Adding 1 additional minute for any updates to complete.
    set GLOBALS(RUN_MINUTE) [expr $GLOBALS(RUN_MINUTE) + 1]

    #If current minute is 58 or 59 rolling the time to next hour with 0 minute.
    if {$GLOBALS(RUN_MINUTE) == 59 } {
        set GLOBALS(RUN_MINUTE) 0
        incr GLOBALS(RUN_HOUR)

    }

    #Making sure format is correct.
    set GLOBALS(RUN_HOUR) [format %2d $GLOBALS(RUN_HOUR)]
    set GLOBALS(RUN_MINUTE) [format %2d $GLOBALS(RUN_MINUTE)]

}




###########################
# creates an array called arguments that has each
# argument name as an array key and the argument value as that
# key's value
proc parse_arguments {} {
    global success_codes
    global arguments
    global argv
    global std_out_channel
    global indent
    global GLOBALS


    foreach {argument value} $argv {
        set arguments($argument) $value
    }

    # standard arguments (optional)
    if { [info exists arguments(--help)] || [info exists arguments(-h)] } {
        usage_statement $success_codes(HELP)
    }

    #--test (optional)
    if { [info exists arguments(--test)] && $arguments(--test) == 1  } {
        set GLOBALS(RUN_AS_TEST) 1
        puts $std_out_channel "$indent Running as test."
    }
    #--cycle (required)
    if { [info exists arguments(--cycle)]  } {
        if { [string range $arguments(--cycle) 0 1] == "--" } {
            usage_statement $success_codes(INVALID_ARGUMENTS)
        }
        set GLOBALS(CYCLE) [string tolower $arguments(--cycle)]
        if { $GLOBALS(CYCLE) != "all" } {
            set GLOBALS(CYCLE) [format %d $GLOBALS(CYCLE)]
        }
        set valid_cycles "all 1 2 3 4"
        if { [lsearch $valid_cycles $GLOBALS(CYCLE) ] == -1 } {
            puts $std_out_channel "Invalid cycle $GLOBALS(CYCLE)"
            usage_statement $success_codes(INVALID_ARGUMENTS)
        }
        puts $std_out_channel "$indent setting cycle to $GLOBALS(CYCLE)"
    } else {
        usage_statement $success_codes(INVALID_ARGUMENTS)
    }

    #--inst (required)
    if { [info exists arguments(--inst)]  } {
        if { [string range $arguments(--inst) 0 1] == "--" } {
                        usage_statement $success_codes(INVALID_ARGUMENTS)
                }
        set GLOBALS(INST_ID) $arguments(--inst)
        global config_file_name
#        set config_file_name "$GLOBALS(INST_ID).inst.cfg"
        set GLOBALS(DEBUG_LOG_FILE_NAME) "$GLOBALS(LOG_DIR)MAS.DEBUG.$GLOBALS(INST_ID).task.log"
        set GLOBALS(LOG_FILE_NAME) "$GLOBALS(LOG_DIR)MAS.$GLOBALS(INST_ID).task.log"
        puts $std_out_channel "$indent setting institution ID $GLOBALS(INST_ID)"
    } else {
        usage_statement $success_codes(INVALID_ARGUMENTS)
    }

    #--task_nbr (required)
    if { [info exists arguments(--task_nbr)]  } {
        if { [string range $arguments(--task_nbr) 0 1] == "--" } {
                        usage_statement $success_codes(INVALID_ARGUMENTS)
                }
        set GLOBALS(TASK_NUMBER) $arguments(--task_nbr)
        puts $std_out_channel "$indent setting command number to $GLOBALS(TASK_NUMBER)"
    } else {
        usage_statement $success_codes(INVALID_ARGUMENTS)
    }

    #--immediate (optional)
    if { [info exists arguments(--immediate)] && $arguments(--immediate) == 1 } {

        set GLOBALS(IMMEDIATE) 1
        puts $std_out_channel "$indent Scheduling right now instead of delaying a few minutes."
        puts $std_out_channel "$indent --immediate option is not yet implemented."

    }

    #--run_type (required)
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


}

###############
# If invalid arguments are give, give a usage statement
###############
proc usage_statement { exit_code } {
    global std_out_channel
    global indent
    global success_codes

    puts $std_out_channel "$indent Usage: [info script] --run_type \[CRON|MANUAL\] --inst XXX --cycle cycle --task_nbr task ?--test \[1|0\]? ?--acct_nbr accountnumber? "
    puts $std_out_channel "$indent   where --run_type \[CRON|MANUAL\] indicates whether this was run automatically (CRON) or manually "
    puts $std_out_channel "$indent   where --test 1 means just generate the SQL and output that to the screen rather than committing to the database."
    puts $std_out_channel "$indent   --inst XXX means run for institution ID XXX"
    puts $std_out_channel "$indent   --cycle XXX means run for cycle XXX (such as ALL) "
    puts $std_out_channel "$indent   --task_nbr is the MAS command number to schedule."
    puts $std_out_channel "$indent   --acct_nbr is the settle account number to schedule (required only for command 102 but also supplied by config file)."
    exit_with_code $exit_code

}



proc parse_config_file {} {
    global success_codes
    global std_out_channel
    global config_file_name
    global indent
    global GLOBALS

    # note -- this was originally going to be in setup, where it makes more sense,
    #    but I needed to be able to run setup before parsing arguments so the arguments can override setup
    #    that left a catch-22 of needing the institution from the arguments before the arguments were parsed
    #    I moved the assignment of the config file name here as the cleanest of ugly methods
#    set config_file_name "$GLOBALS(CONFIG_DIR)$GLOBALS(INST_ID).inst.cfg"

    if {[catch {open $config_file_name {RDONLY}} config_file_handle]} {
        puts $std_out_channel "$indent Cannot open file $config_file_name. "
        exit_with_code $success_codes(IO_ERROR) "$indent Cannot open file $config_file_name. "
    }

    set cur_line  [split [set orig_line [gets $config_file_handle] ] ,]
    while {$cur_line != ""} {

        set cur_key [lindex $cur_line 0]
        set cur_value [lindex $cur_line 1]

        if { [info exists GLOBALS($cur_key)] } {
            puts $std_out_channel "$indent setting GLOBALS value $cur_key to $cur_value"
            set GLOBALS($cur_key) $cur_value
        } else {
            puts $std_out_channel "$indent Could not find global $cur_key.  Creating new entry in GLOBALS array for $cur_key"
            set GLOBALS($cur_key) $cur_value
        }

        set cur_line  [split [set orig_line [gets $config_file_handle] ] ,]
    }


    if {[catch {close $config_file_handle} response]} {

        return $success_codes(IO_ERROR)
    }

    return $success_codes(SUCCESS)
}

# exit with an exit code
# and clean up anything that needs to be cleaned up
proc exit_with_code { exit_code {log_message ""} } {
    global command_string
    global std_out_channel
    global indent
    global GLOBALS
    global success_codes



    #TODO
    if { $exit_code != $success_codes(SUCCESS) } {
        # keep process.stop file
        # reset tasks for institution
        # append any message from call_reset_task to log_message
        set reset_result [call_reset_task]
        if { $reset_result != $success_codes(SUCCESS) } {
            append log_message "\n [call_reset_task]"
        }



    }

    close_db_connections

    # the log message passed in probably already has an indent
    puts $std_out_channel "$log_message"
    puts $std_out_channel "$indent [clock format [clock seconds] -format "%D %T"]"
        puts $std_out_channel "$indent Ending $command_string with exit code $exit_code"


    exit $exit_code

}




#Procedure for connecting to DB.

proc connect_to_db {} {
    global masclr_logon_handle
    global masclr_cursor_query1
    global masclr_cursor_update
    global std_out_channel
    global GLOBALS
    global success_codes
    global indent
    global env

    if {[catch {set masclr_logon_handle [oralogon masclr/masclr@$env(IST_DB)]} result] } {
        puts $std_out_channel "$indent Encountered error $result while trying to connect to DB"
        set main_email_body "ALL PROCESSES STOPPED SINCE [info script] could not logon to DB : Msg sent from [info script]\n $result"
        send_alert_email $main_email_body $GLOBALS(EMAIL_CRITICAL_SUBJECT) $GLOBALS(EMAIL_CRITICAL_BODY) $success_codes(DB_ERROR)
    }

    set masclr_cursor_query1 [oraopen $masclr_logon_handle]
    set masclr_cursor_update [oraopen $masclr_logon_handle]


};# end connect_to_db


proc close_db_connections {} {
    global success_codes
    global masclr_cursor_update
    global masclr_cursor_query1
    global masclr_logon_handle

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

    return $success_codes(SUCCESS)
}


#setting up procedure for time out will take one argument in munber of minutes.
proc timeout { {t 2} } {
    global std_out_channel
    global success_codes

    set mxrotation [expr $t * 60]
    set i 0
    while {$i < $mxrotation} {
        after 20000
        puts -nonewline $std_out_channel "."
        flush $std_out_channel
        set i [expr $i + 20]
    }
    puts $std_out_channel " "
}




# check to see if another MAS command is still executing.
#Procedure for checking task_log for MAS
proc check_task_log {} {
    global GLOBALS
    global indent
    global masclr_cursor_query1
    global masclr_cursor_update
    global std_out_channel
    global indent
    global success_codes


    puts $std_out_channel "$indent Checking task_log to see if 138, 107, 110 or 109 are still running."
    set check_task_log_sql "select * from masclr.task_log where institution_id = '$GLOBALS(INST_ID)' and usage = 'MAS' \
                    and cmd_nbr in ('107','110','109','138') and result = 'EXECUTED' and ACTUAL_START_DT like '$GLOBALS(TODAY_CLR_FORMAT)%'"

    orasql $masclr_cursor_query1 $check_task_log_sql


    if {[catch {orafetch $masclr_cursor_query1 -dataarray task_log_result_arr -indexbyname} result_code] } {
        puts "$indent Error with $check_task_log_sql"
        puts "$indent Could not check running tasks: [oramsg $masclr_cursor_query1 rc] [oramsg $masclr_cursor_query1 error]"
        exit_with_code $success_codes(DB_ERROR) "$indent Could not check running tasks: [oramsg $masclr_cursor_query1 rc] [oramsg $masclr_cursor_query1 error]"
    } else {
        if { $result_code == "1403" } {
            # no rows, so no tasks still executing
            puts $std_out_channel "$indent There are no MAS task running at this time. Continuing process update task table"
        } else {
            set main_email_body "CMD_NBR: $task_log_result_arr(CMD_NBR) for INST_ID: $GLOBALS(INST_ID) is still running and RESULT is $task_log_result_arr(RESULT)\nStopping all processes."
            send_alert_email $main_email_body $GLOBALS(EMAIL_CRITICAL_SUBJECT) $GLOBALS(EMAIL_CRITICAL_BODY) $success_codes(SERVER_BUSY_ERROR)
        }
    }

}


#Procedure for checking server status

proc check_server_status {} {
    global GLOBALS
    global masclr_cursor_query1
    global masclr_cursor_update
    global std_out_channel
    global indent
    global success_codes

        set GLOBALS(TIGR) 1
        set GLOBALS(CNT) 0
        set GLOBALS(LP) 0

    puts $std_out_channel "$indent Checking server status."
    while {$GLOBALS(CNT) < 10} {

        set field_value_control_sql "select * from $GLOBALS(FIELD_VALUE_CONTROL_TABLE) where FIELD_NAME like '%R_STATUS'"
        orasql $masclr_cursor_query1 $field_value_control_sql
        puts $std_out_channel "$indent $GLOBALS(CNT)"
        incr GLOBALS(CNT)


        while {1} {
            if {[catch {orafetch $masclr_cursor_query1 -dataarray field_value_control_result_arr -indexbyname} result_code]} {
                puts stderr "$indent Error with $field_value_control_sql"
                puts stderr "$indent [oramsg $masclr_cursor_query1 rc] [oramsg $masclr_cursor_query1 error]"
                # break or exit or ignore
            }
            if {[oramsg $masclr_cursor_query1 rc] != 0} break
            # do something
            puts "$indent $field_value_control_result_arr(INSTITUTION_ID) $field_value_control_result_arr(FIELD_NAME) = $field_value_control_result_arr(FIELD_VALUE1)"
                set field_value [string trim $field_value_control_result_arr(FIELD_VALUE1)]
                if {$field_value != "IDLE"} {
                # found a busy one
                        set GLOBALS(TIGR) 1
                        set GLOBALS(LP) 1
                }

        }

        # if found a busy one
        if {$GLOBALS(LP) == 1} {
            # after uses milliseconds
                after 120000
                set GLOBALS(LP) 0
        } else {
            # no busy one, set GLOBALS(CNT) to a value that will break the while loop
            set GLOBALS(TIGR) 0
            set GLOBALS(CNT) 15
            set GLOBALS(LP) 0
        }

    }


    # if we tried to wait 10 times and still have a busy process
    puts $std_out_channel "$indent tigr: $GLOBALS(TIGR), cnt: $GLOBALS(CNT), lp: $GLOBALS(LP)"
    if { $GLOBALS(CNT) == 10 } {

        set GLOBALS(CURRENT_DATE_TIME) [clock format [clock seconds] -format "%Y%m%d%H%M%S"]

        # clear all run times for the institution
        set reset_result [call_reset_task]
        if { $reset_result != $success_codes(SUCCESS) } {

        } else {
            set reset_result ""
        }

        puts $std_out_channel "$indent SERVER STATUS IS NOT IDLE after 20 minutes at $GLOBALS(CURRENT_DATE_TIME) $reset_result"

        set main_email_body "$GLOBALS(SYS_BOX) FOR INST ID: $GLOBALS(INST_ID) :: CMD NBR : $GLOBALS(TASK_NUMBER). Failed\n\n SERVER STATUS IS NOT IDLE after 20 minutes: Tasks reset to NULL at $GLOBALS(CURRENT_DATE_TIME) \n\n$reset_result"
        send_alert_email $main_email_body $GLOBALS(EMAIL_CRITICAL_SUBJECT) $GLOBALS(EMAIL_CRITICAL_BODY) $success_codes(SERVER_BUSY_ERROR)


        #oracommit $masclr_logon_handle


        exit_with_code $success_codes(MAS_ERROR) "$indent $main_email_body"


    }


}


#Procedure for check gl date status.
# Before the 106 command, the gl_date should be set to today.
#   and the gl_date should be the same in all records in gl_chart_of_acct
#   and the gl_date should be today in field_value_ctrl for all records for the given institution

# if this is running before the 106
# check first to make sure field_value_ctrl and gl_chart_of_acct have the same date and that it is today.
# if none of these are true, exit with error and email.

# after the 106,
# calculate tomorrow's date.
# make sure  field_value_ctrl and gl_chart_of_acct are all set to tomorrow's date.
# if not then exit with an email

# test cases:
# before the 106
# 1 gl_date is different in some of the records in gl_chart_of_acct
# 2 gl_date is the same in gl_chart_of_acct but is the wrong date (before today)
# 3 gl_date is the same in gl_chart_of_acct but is the wrong date (after today)
# 4 gl_date is the same in gl_chart_of_acct but is the wrong date (tomorrow)
# 5 gl_date in field_value_ctrl is not equal to date in gl_chart_of_acct
# 6 (correct case) gl_date is correct (today) in all records in gl_chart_of_acct and in field_value_ctrl

# after the 106
# 7 (correct case) gl_date is correct (tomorrow) in all records in gl_chart_of_acct and in field_value_ctrl
#

proc chk_gl_date { before_or_after_106 } {
    global GLOBALS
    global masclr_cursor_query1
    global success_codes
    global indent
    global std_out_channel

        set check_gl_chart_of_acct_sql "select to_char(MAX(GL_DATE), 'YYYYMMDD') as MAXDT, to_char(MIN(GL_DATE), 'YYYYMMDD') as MINDT \
                                            from gl_chart_of_acct where institution_id='$GLOBALS(INST_ID)'"


        orasql $masclr_cursor_query1 $check_gl_chart_of_acct_sql

    #TODO add error catching
        orafetch $masclr_cursor_query1 -dataarray gl_chart_of_acct_arr -indexbyname
        if {[oramsg $masclr_cursor_query1 rc]} {
        # meaning if the return code was something other than 0 or on a database error
                set main_email_body "$GLOBALS(SYS_BOX) GL_DATE is null\n\n FOR INST ID: $GLOBALS(INST_ID) :: CMD NBR : $GLOBALS(TASK_NUMBER).\n GL_DATE value is set to null in table gl_chart_of_acct. Exited GL_EXPORT. CALL Clearing Group IMMEDIATELY."
        send_alert_email $main_email_body $GLOBALS(EMAIL_CRITICAL_SUBJECT) $GLOBALS(EMAIL_CRITICAL_BODY) $success_codes(MAS_ERROR)

        }

    # test cases 1-4
        if {$gl_chart_of_acct_arr(MAXDT) != $gl_chart_of_acct_arr(MINDT)} {
        # something went wrong with yesterday's gl_date update or someone manually modified gl_chart_of_acct.  This needs to be corrected so that the gl_date in gl_chart_of_acct is set to today's date in all records.

                set main_email_body "$GLOBALS(SYS_BOX) GL_DATE DO not match\n\n FOR INST ID: $GLOBALS(INST_ID) :: CMD NBR : $GLOBALS(TASK_NUMBER).\n MAX GL_DATE $gl_chart_of_acct_arr(MAXDT) and MIN GL_DATE $gl_chart_of_acct_arr(MINDT) values found in table gl_chart_of_acct. Exited GL_EXPORT. CALL Clearing Group IMMEDIATELY."
        append main_email_body "\n\nsomething went wrong with yesterday's gl_date update or someone manually modified gl_chart_of_acct.  This needs to be corrected so that the gl_date in gl_chart_of_acct is set to today's date in all records."
                send_alert_email $main_email_body $GLOBALS(EMAIL_CRITICAL_SUBJECT) $GLOBALS(EMAIL_CRITICAL_BODY) $success_codes(PROCESS_STOP_FILE_FOUND_ERROR)

        }

    # test case 6
    # the proc should stop here before the GL Export (106 command)
        if {$gl_chart_of_acct_arr(MAXDT) == $gl_chart_of_acct_arr(MINDT)} {
                if {$gl_chart_of_acct_arr(MAXDT) == $GLOBALS(CURRENT_DATE)} {
            # this means that the gl_date was already set to today, which is correct before we run the 106 command
            puts $std_out_channel "$indent gl_date is set to today, which is correct before running the 106 command."
            return $GLOBALS(GL_DATE_EQUAL_TODAY)
                } else {
            # fall through here after the 106 command has run.
            # OR if this is before the 106 but the date is already correct (tomorrow), this will fall through, as well.
        }
        }



    set check_field_value_ctrl_sql "select field_value1 from field_value_ctrl where field_name = 'GL_DATE' and institution_id = '$GLOBALS(INST_ID)'"
    orasql $masclr_cursor_query1 $check_field_value_ctrl_sql
    orafetch $masclr_cursor_query1 -dataarray field_value_ctrl_arr -indexbyname

        if {[oramsg $masclr_cursor_query1 rc]} {
         # meaning if the return code was something other than 0 or on a database error
                set main_email_body "$GLOBALS(SYS_BOX) GL_DATE is null\n\n FOR INST ID: $GLOBALS(INST_ID) :: CMD NBR : $GLOBALS(TASK_NUMBER).\n GL_DATE value is set to null in table field_value_ctrl and FIELD : field_value1. Exited GL_EXPORT. CALL Clearing Group IMMEDIATELY."
                send_alert_email $main_email_body $GLOBALS(EMAIL_CRITICAL_SUBJECT) $GLOBALS(EMAIL_CRITICAL_BODY) $success_codes(MAS_ERROR)

        }

    # test case 5
        if {$gl_chart_of_acct_arr(MAXDT) != $field_value_ctrl_arr(FIELD_VALUE1)} {
        #TODO improve this message
                set main_email_body "$GLOBALS(SYS_BOX) GL_DATE DO not match\n\n FOR INST ID: $GLOBALS(INST_ID) :: CMD NBR : $GLOBALS(TASK_NUMBER).\n MAX GL_DATE $gl_chart_of_acct_arr(MAXDT) and FIELD_VALUE1 GL_DATE $field_value_ctrl_arr(FIELD_VALUE1) values found in table gl_chart_of_acct. Exited GL_EXPORT. CALL Clearing Group IMMEDIATELY."
                send_alert_email $main_email_body $GLOBALS(EMAIL_CRITICAL_SUBJECT) $GLOBALS(EMAIL_CRITICAL_BODY) $success_codes(MAS_ERROR)

        }



        if {$before_or_after_106 == $GLOBALS(GL_CHECK_AFTER_106)} {
                if {$gl_chart_of_acct_arr(MAXDT) == $GLOBALS(CURRENT_DATE)} {
                        puts "$indent FOR INST ID: $GLOBALS(INST_ID) :: CMD NBR : $GLOBALS(TASK_NUMBER).\n GL_DATE is not set for tomorrow.  GL_DATE = $gl_chart_of_acct_arr(MAXDT). Running GL_EXPORT"
                        set main_email_body "$GLOBALS(SYS_BOX) GL_EXPORT FAILED\n\n FOR INST ID: $GLOBALS(INST_ID) :: CMD NBR : $GLOBALS(TASK_NUMBER).\n GL_EXPORT FAILED.  GL_DATE = $gl_chart_of_acct_arr(MAXDT)."
                        send_alert_email $main_email_body $GLOBALS(EMAIL_CRITICAL_SUBJECT) $GLOBALS(EMAIL_CRITICAL_BODY) $success_codes(MAS_ERROR)

                }
        }

        if {$before_or_after_106 == $GLOBALS(GL_CHECK_BEFORE_106)} {
                if {$gl_chart_of_acct_arr(MAXDT) < $GLOBALS(CURRENT_DATE)} {
                        set main_email_body "$GLOBALS(SYS_BOX) GL_EXPORT is not complete.\n\n FOR INST ID: $GLOBALS(INST_ID) :: CMD NBR : $GLOBALS(TASK_NUMBER).\n GL_DATE is not correct.  GL_DATE = $gl_chart_of_acct_arr(MAXDT) is less than Current date: $GLOBALS(CURRENT_DATE)\nThis could mean that GL Export did not run for $GLOBALS(INST_ID) yesterday."
                        send_alert_email $main_email_body $GLOBALS(EMAIL_CRITICAL_SUBJECT) $GLOBALS(EMAIL_CRITICAL_BODY) $success_codes(MAS_ERROR)

                }
        }


        if {$before_or_after_106 == $GLOBALS(GL_CHECK_AFTER_106)} {
                if {$gl_chart_of_acct_arr(MAXDT) < $GLOBALS(CURRENT_DATE)} {
                        set main_email_body "$GLOBALS(SYS_BOX) GL_EXPORT is not complete.\n\n FOR INST ID: $GLOBALS(INST_ID) :: CMD NBR : $GLOBALS(TASK_NUMBER).\n GL_DATE is still not correct.  GL_DATE = $gl_chart_of_acct_arr(MAXDT) is less that Current date: $GLOBALS(CURRENT_DATE)"
                        send_alert_email $main_email_body $GLOBALS(EMAIL_CRITICAL_SUBJECT) $GLOBALS(EMAIL_CRITICAL_BODY) $success_codes(MAS_ERROR)

                }
        }


#set GLOBALS(GL_DATE_EQUAL_TODAY) 1
#    set GLOBALS(GL_CHECK_BEFORE_106) 1
#    set GLOBALS(GL_DATE_EQUAL_TOMORROW) 2
#    set GLOBALS(GL_CHECK_AFTER_106) 2


        if {$gl_chart_of_acct_arr(MAXDT) > $GLOBALS(CURRENT_DATE)} {
                set tomorrow [clock format [ clock scan "+1 day" ] -format %Y%m%d]
        if {$before_or_after_106 == $GLOBALS(GL_CHECK_BEFORE_106)} {
            if {$gl_chart_of_acct_arr(MAXDT) == $tomorrow} {
                puts "$indent FOR INST ID: $GLOBALS(INST_ID) :: CMD NBR : $GLOBALS(TASK_NUMBER).\n Already has the correct GL_DATE. GL_DATE = $gl_chart_of_acct_arr(MAXDT)"
                return $GLOBALS(GL_DATE_EQUAL_TOMORROW)

            } else {
                # test case 3
                set main_email_body "$GLOBALS(SYS_BOX) GL_DATE s greater than $tomorrow\n\n FOR INST ID: $GLOBALS(INST_ID) :: CMD NBR : $GLOBALS(TASK_NUMBER).\n GL_DATE is not correct. GL_DATE = $gl_chart_of_acct_arr(MAXDT) which is greater than $tomorrow"
                send_alert_email $main_email_body $GLOBALS(EMAIL_CRITICAL_SUBJECT) $GLOBALS(EMAIL_CRITICAL_BODY) $success_codes(PROCESS_STOP_FILE_FOUND_ERROR)

            }
        }

        # this is what we want to get to
        if {$before_or_after_106 == $GLOBALS(GL_CHECK_AFTER_106)} {
            if {$gl_chart_of_acct_arr(MAXDT) == $tomorrow} {
                puts "$indent FOR INST ID: $GLOBALS(INST_ID) :: CMD NBR : $GLOBALS(TASK_NUMBER).\n$indent GL_DATE UPDATED SUCCESSFULLY.  GL_DATE = $gl_chart_of_acct_arr(MAXDT)"
                return $GLOBALS(GL_DATE_EQUAL_TOMORROW)
            }
        }
    }

} ;# end chk_gl_date


# pass in a main message body, a message body header such as "ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
# and a message subject
proc send_alert_email { main_email_body message_subject email_body_header exit_code } {
    global GLOBALS
    global success_codes
    global indent
    global std_out_channel


    if { $GLOBALS(RUN_AS_TEST) == 1 } {
        puts $std_out_channel "$indent exec echo \"$email_body_header $GLOBALS(SYSINFO) $main_email_body\" | mailx -r $GLOBALS(MAILFROM_LIST) -s \"$message_subject\" $GLOBALS(MAILTO_LIST)"
    } else {
        exec echo "$email_body_header $GLOBALS(SYSINFO) $main_email_body" | mailx -r $GLOBALS(MAILFROM_LIST) -s "$message_subject" $GLOBALS(MAILTO_LIST)
    }


    exit_with_code $exit_code "$indent $main_email_body"
}

proc call_reset_task {} {
    global GLOBALS
    global success_codes
    global std_out_channel
    global indent

    if { $GLOBALS(RUN_AS_TEST) == 1 } {
        puts $std_out_channel "$indent catch {exec ./reset_task.sh CRON $GLOBALS(INST_ID) >> $GLOBALS(LOG_FILE_NAME)} result"
    } else {
        puts $std_out_channel "$indent ======================================================"
        puts $std_out_channel "$indent Calling ./reset_task.sh CRON $GLOBALS(INST_ID)"
        catch {exec ./reset_task.sh $GLOBALS(INST_ID) CRON >> $GLOBALS(LOG_FILE_NAME)} result

        if {$result != ""} {
            return "reset_task.sh could not complete. Result: $result.  \nSee log file $GLOBALS(LOG_FILE_NAME)"
        }
    }


    return $success_codes(SUCCESS)

}


proc set_task_parameters {} {
    global GLOBALS
    global std_out_channel
    global indent
    global success_codes
    global masclr_cursor_query1

    switch $GLOBALS(TASK_NUMBER) {

      "100"             {
        # start file recognition
            set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID)";
        }

      "102"             {
      # ACH Payment
      if { [ catch {
            set get_abadda "select * from BRD_SETTL_ACCT_TO_PMTCYL where institution_id = '$GLOBALS(INST_ID)' and payment_cycle = '$GLOBALS(CYCLE)'"


            orasql $masclr_cursor_query1 $get_abadda

            if {[orafetch $masclr_cursor_query1 -dataarray set_acct -indexbyname] != 0} {
                puts "CMD_NBR: $GLOBALS(TASK_NUMBER) INST_ID: $GLOBALS(INST_ID) and PMT_CYCL: $GLOBALS(CYCLE) :: Could not find ABA DDA \nStoping all processes."
                exit 1
            }

            set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -c$GLOBALS(CYCLE) -d$GLOBALS(CURRENT_DATE) -t$GLOBALS(CURRENT_TIME) -oN -f$set_acct(SETTL_ROUTING_NBR)" } failure] } {
        puts "Could not set parameters for task $GLOBALS(TASK_NUMBER): $failure"
            exit 1
            }

        }

      "103"             {
        # Wire
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -c$GLOBALS(CYCLE) -d$GLOBALS(CURRENT_DATE) -t$GLOBALS(CURRENT_TIME) -oY -wY -f$set_acct(SETTL_ROUTING_NBR)";
        }

      "104"             {
        # Manual Wire
        puts "!! NOT ALLOWED !!"; exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -c$GLOBALS(CYCLE) -d$GLOBALS(CURRENT_DATE) -t$GLOBALS(CURRENT_TIME) -oY -f$set_acct(SETTL_ROUTING_NBR)";
      }

      "105"             {
        # Invoice Generation
        puts "!! NOT ALLOWED !!"; exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -c$GLOBALS(CYCLE) -d$GLOBALS(CURRENT_DATE) -t$GLOBALS(CURRENT_TIME) -oY -bY -f$set_acct(SETTL_ROUTING_NBR)";
      }

      "106"             {
        # GL Export
        set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -d$GLOBALS(CURRENT_DATE) -t$GLOBALS(CURRENT_TIME) ";
      }

      "107"             {
        # Transaction Counting
        set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -d$GLOBALS(CURRENT_DATE)";
      }

      "108"             {
        # Rate Re-assessment
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -d$GLOBALS(CURRENT_DATE) -c$GLOBALS(CYCLE)";
      }

      "109"             {
        # Calculate Next Settlement Date
        set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -d$GLOBALS(CURRENT_DATE) -c$GLOBALS(CYCLE)";
      }

      "110"             {
        # Non-Activity Fees
        set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -d$GLOBALS(CURRENT_DATE) -c$GLOBALS(CYCLE)";
      }

      "111"             {
        # Remittance
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -d$GLOBALS(CURRENT_DATE) -t$GLOBALS(CURRENT_TIME)";
      }

      "112"             {
        # Aging
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -d$GLOBALS(CURRENT_DATE) -t$GLOBALS(CURRENT_TIME)";
      }

      "113"             {
        # Adjustment
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID)";
      }

      "114"             {
        # Fee Group Rate Update
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID)";
      }

      "115"             {
        # Mas Fee Future Effective Date
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -d$GLOBALS(CURRENT_DATE)";
      }

      "116"             {
        # Resubmit Suspended Batch
        set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -ba";
      }

      "117"             {
        # Expected Merchant's Transmission
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -d$GLOBALS(CURRENT_DATE) -t<Time(HHMM)>";
      }

      "118"             {
        # Cycle Balancing
        set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -cN>";
      }

      "119"             {
        # Payment Count
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -d<Monthly Period(YYYYMM)>";
      }

      "120"             {
        # Reprocess Lost Transactions
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -f<File Name>";
      }

      "121"             {
        # MAS Outbounder File
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -d$GLOBALS(CURRENT_DATE) -r<Payment Run>";
      }

      "122"             {
        # Re-generate Invoice
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -d$GLOBALS(CURRENT_DATE) -r<Payment Run> -bY -f$set_acct(SETTL_ROUTING_NBR)";
      }

      "123"             {
        # EOD Balancing
        set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID)";
      }

      "124"             {
        # Monthly Summary
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -d<Monthly Period(YYYYMM)>";
      }

      "125"             {
        # Submit Mas_trans_error
        set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID)";
      }

      "126"             {
        # Re-generate ACH
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -d$GLOBALS(CURRENT_DATE) -r<Payment Run> -f$set_acct(SETTL_ROUTING_NBR)";
      }

      "127"             {
        # Re-generate Wire
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -d$GLOBALS(CURRENT_DATE) -r<Payment Run> -f$set_acct(SETTL_ROUTING_NBR)";
      }

      "128"             {
        # Re-generate Manual Wire
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -d$GLOBALS(CURRENT_DATE) -r<Payment Run> -f$set_acct(SETTL_ROUTING_NBR)";
      }

      "129"             {
        # Generate Payment Log File
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -d$GLOBALS(CURRENT_DATE) -r<Payment Run>";
      }

      "130"             {
        # Cycle Balancing Report
        set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -c$GLOBALS(CYCLE)";
      }

      "131"             {
        # EOD Balancing Report
        set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -d$GLOBALS(CURRENT_DATE)";
      }

      "132"             {
        # System Call
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-c<Command>";
      }

      "133"             {
        # Write-Off Suspend Transactions
        set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID)";
      }

      "134"             {
        # System Call w/ StopFR
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-c<Command>";
      }

      "135"             {
        # Undo ACH
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -c$GLOBALS(CYCLE) -d$GLOBALS(CURRENT_DATE) -t$GLOBALS(CURRENT_TIME)";
      }

      "136"             {
        # Undo Wire
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -c$GLOBALS(CYCLE) -d$GLOBALS(CURRENT_DATE) -t$GLOBALS(CURRENT_TIME)";
      }

      "137"             {
        # Undo Manual Wire
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -c$GLOBALS(CYCLE) -d$GLOBALS(CURRENT_DATE) -t$GLOBALS(CURRENT_TIME)";
      }

      "138"             {
        # Build Item to Accum
        set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -d$GLOBALS(CURRENT_DATE) -c$GLOBALS(CYCLE)";
      }

      "139"             {
        # Delete Entity
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID)";
      }

      "140"             {
        # Undo Invoice
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -c$GLOBALS(CYCLE) -d$GLOBALS(CURRENT_DATE)";
      }

      "200"             {
        # Stop File Recognition
        set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID)";
      }

      "301"             {
        # Batch Cycle 00 ACH
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID)";
      }

      "302"             {
        # Batch Cycle 21 Inv/Wire
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID)";
      }

      "303"             {
        # Batch Cycle 00/21 ACH/Inv/Wire
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID)";
      }

      "304"             {
        # Batch Cycle 00 ACH/Inv
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID)";
      }

      "305"             {
        # Batch EOD phase 1
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID)";
      }

      "306"             {
        # Batch EOD type 1
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID)";
      }

      "307"             {
        #Batch EOD type 2
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID)";
      }

      "501"             {
        # End of Cycle
        set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -c$GLOBALS(CYCLE) -d$GLOBALS(CURRENT_DATE) -t$GLOBALS(CURRENT_TIME)";
      }

      "502"             {
        # End of Cycle (Month End)
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -c$GLOBALS(CYCLE) -d$GLOBALS(CURRENT_DATE) -t$GLOBALS(CURRENT_TIME)";
      }

      "503"             {
      # End of Day
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -c$GLOBALS(CYCLE) -d$GLOBALS(CURRENT_DATE) -t$GLOBALS(CURRENT_TIME)";
      }

      "551"             {
        # End of Cycle
        set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -c$GLOBALS(CYCLE)";
      }

      "552"             {
        # End of Cycle (Month End)
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -c$GLOBALS(CYCLE)";
      }

      "553"             {
        # End of Day
        puts "!! NOT ALLOWED !!";  exit 0 ;  set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -c$GLOBALS(CYCLE)";
      }

      "701"             {
        # End of Cycle (No Ach)
        set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -c$GLOBALS(CYCLE) -d$GLOBALS(CURRENT_DATE) -t$GLOBALS(CURRENT_TIME)";
      }

      "751"             {
        # End of Cycle (No Ach)
        set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID) -c$GLOBALS(CYCLE)";
      }

      "901"             {
        # Flush Servers Read Caches
        set GLOBALS(CMD_PARAMETERS) "-i$GLOBALS(INST_ID)";
      }
      "201"             {
        set GLOBALS(TASK_USAGE) "CLR"
      }
      "321"             {
        set GLOBALS(TASK_USAGE) "CLR"
      }
      "341"             {
        set GLOBALS(TASK_USAGE) "CLR"
      }
      "355"             {
        set GLOBALS(TASK_USAGE) "CLR"
      }
      "241"     {
        set GLOBALS(TASK_USAGE) "CLR"
      }
      "255"     {
        set GLOBALS(TASK_USAGE) "CLR"
      }

        default         {
            # TODO switch to exit_with_code
            puts "$indent TASK NUMBER NOT FOUND: TASK SWITCH FAILED: SCRIPT EXITED WITH ERROR";
            exit 0
        }
    }



}



proc update_task {} {

    global GLOBALS
    global std_out_channel
    global masclr_cursor_update
    global masclr_logon_handle
    global indent
    global success_codes

    #This sections updates Task table in db according to task number. Depending on which tasks needs updating that part of the section gets invoked.



    if {$GLOBALS(TASK_NUMBER) == "106"} {

        #This section for gl export 106
        # have to make sure that the gl_date will be exported correctly
        # after updating the gl_date, check again to make sure it did get exported correctly
        # an export today with today's date changes the gl_date to the next day
        #TODO rework this
        if {$GLOBALS(TIGR) == 0} {

            puts $std_out_channel "$indent Checking gl_date before running 106 command."
            set check_gl_date_result [chk_gl_date $GLOBALS(GL_CHECK_BEFORE_106) ]
            # chk_gl_date either returns GLOBALS(GL_DATE_EQUAL_TODAY) or it exits

            # TODO change the switch to use global variables instead of hard-coded values.
            #set GLOBALS(GL_DATE_EQUAL_TODAY) 1
            #    set GLOBALS(GL_CHECK_BEFORE_106) 1
            #    set GLOBALS(GL_DATE_EQUAL_TOMORROW) 2
            #    set GLOBALS(GL_CHECK_AFTER_106) 2

            switch $check_gl_date_result {
                "1"     {
                    puts "Running Gl export"
                    }
                "2" {
                    # gl_date is already correct, do not schedule the task.
                    puts $std_out_channel "$indent gl_date is already correct.  106 will not be scheduled."
                    exit_with_code $success_codes(SUCCESS) "$indent gl_date is already correct.  106 will not be scheduled."
                }
                default {
                    puts $std_out_channel "chk_gl_date returned $check_gl_date_result"
                }

            }

        #updating mas tasks
            set update_tasks_sql "update tasks set run_hour ='$GLOBALS(RUN_HOUR)',run_min = '$GLOBALS(RUN_MINUTE)', CMD_PARAM = '$GLOBALS(CMD_PARAMETERS)'  where institution_id = '$GLOBALS(INST_ID)' and task_nbr = '$GLOBALS(TASK_NUMBER)'"

            if { $GLOBALS(RUN_AS_TEST) == 1 } {
                puts $std_out_channel "$indent $update_tasks_sql"

            } else {
                orasql $masclr_cursor_update $update_tasks_sql
                puts $std_out_channel "$indent Time set to run_hour = $GLOBALS(RUN_HOUR) ,run_min= $GLOBALS(RUN_MINUTE)"
                oracommit $masclr_logon_handle
            }
            #TODO add error checking




        }

        timeout

        puts $std_out_channel "$indent Checking gl_date after running 106 command."
        set check_gl_date_after_export [chk_gl_date $GLOBALS(GL_CHECK_AFTER_106)]

        switch $check_gl_date_after_export {
            "2" {
                puts $std_out_channel "$indent GL EXPORT SUCCESSFUL."
            }
            default {
                puts $std_out_channel "$indent chk_gl_date returned $check_gl_date_after_export. GL EXPORT WAS NOT SUCCESSFUL."
                # should not get to this point -- script should exit in chk_gl_date
            }

        }

    } else {

        #This section is for all other tasks.

        if {$GLOBALS(TIGR) == 0} {

            if {$GLOBALS(TASK_USAGE) == "CLR"} {
            #           updating clearing tasks
                set update_tasks_sql "update tasks set run_hour ='$GLOBALS(RUN_HOUR)',run_min = '$GLOBALS(RUN_MINUTE)' where institution_id = '$GLOBALS(INST_ID)' and task_nbr = '$GLOBALS(TASK_NUMBER)'"
                if { $GLOBALS(RUN_AS_TEST) == 1 } {
                    puts $std_out_channel $update_tasks_sql

                } else {
                    orasql $masclr_cursor_update $update_tasks_sql
                    puts $std_out_channel "$indent UPDATE TASK FOR INST ID: $GLOBALS(INST_ID) :: CMD NBR : $GLOBALS(TASK_NUMBER) : $GLOBALS(RUN_HOUR):$GLOBALS(RUN_MINUTE)"
                    oracommit $masclr_logon_handle
                }
                set GLOBALS(TASK_USAGE) "OTHER"

            } else {
            #           updating mas tasks
                set update_tasks_sql "update tasks set run_hour ='$GLOBALS(RUN_HOUR)',run_min = '$GLOBALS(RUN_MINUTE)', CMD_PARAM = '$GLOBALS(CMD_PARAMETERS)'  where institution_id = '$GLOBALS(INST_ID)' and task_nbr = '$GLOBALS(TASK_NUMBER)'"

                if { $GLOBALS(RUN_AS_TEST) == 1 } {

                    puts $std_out_channel "$indent $update_tasks_sql"
                } else {

                    orasql $masclr_cursor_update $update_tasks_sql
                    puts $std_out_channel "$indent UPDATE TASK FOR INST ID: $GLOBALS(INST_ID) :: CMD NBR : $GLOBALS(TASK_NUMBER) : $GLOBALS(RUN_HOUR):$GLOBALS(RUN_MINUTE)"
                    oracommit $masclr_logon_handle
                }



            }
        }
    }

}

######
#MAIN#
######

proc main {} {
    global GLOBALS
    global success_codes
    global std_out_channel
    global masclr_cursor_update
    global argv
    global indent
    global command_string

    setup


    set command_string "[info script]"
    foreach argument $argv {
        append command_string " $argument"
    }

        # report the script and its arguments
    puts $std_out_channel "$indent [clock format [clock seconds] -format "%D %T"]"
    puts $std_out_channel "$indent Beginning $command_string"

    # config file needs the institution ID, which comes from the arguments. so parse arguments has to come before parse config file.
    # but the arguments need to be able to override the config file.
    parse_arguments
    #parse_config_file

    puts $std_out_channel "$indent Run type: $GLOBALS(RUN_TYPE)"

    connect_to_db


    set_task_parameters




    #Calling status check Procedure to check server status is Idle.
    #Declare few variables

    #set err ""
    #set tblnm_ifl "OUT_FILE_LOG"

    set GLOBALS(TIGR) 1
    set GLOBALS(CNT) 0
    set GLOBALS(LP) 1

    check_task_log
    check_server_status


    update_task

    # this is done in exit_with_code



    exit_with_code $success_codes(SUCCESS)


}






main
