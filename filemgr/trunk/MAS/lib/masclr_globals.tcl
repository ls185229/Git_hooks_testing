# this is a library file, not a standalone tcl script
# include this file in a different script by using
# source this_file_name
# $Id$
# prevent loading the file more than once
if { [info exists MASCLR_GLOBALS_LOADED] } {
    return
}


namespace eval MASCLR {
        namespace export clear_database_logon_handles
	namespace export add_database_logon_handle
	namespace export add_open_file
	namespace export set_log_file_name
	namespace export set_log_file_channel
	namespace export set_command_string
	namespace export remove_open_file
	namespace export set_script_email_subject
	namespace export set_script_email_body 

	variable LOG_FILE_NAME
	variable LOG_FILE_CHANNEL stdout
	variable COMMAND_STRING ""
	variable OPEN_FILES
	array set OPEN_FILES {}
	variable DEBUG 0

	variable ARG_ERROR "ARG_ERROR"

  	global env
	variable CRITICAL
	array set CRITICAL { SUBJECT "$env(SYS_BOX) :: Priority : Critical - Clearing and Settlement" BODY "ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n" }

	variable URGENT 
	array set URGENT { SUBJECT "$env(SYS_BOX) :: Priority : Urgent - Clearing and Settlement" BODY "ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n" }

	variable HIGH 
	array set HIGH { SUBJECT "$env(SYS_BOX) :: Priority : High - Clearing and Settlement" BODY "ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n" }

	variable MEDIUM
	array set MEDIUM { SUBJECT "$env(SYS_BOX) :: Priority : Medium - Clearing and Settlement" BODY "ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n" }

	variable LOW
	array set LOW { SUBJECT "$env(SYS_BOX) :: Priority : Low - Clearing and Settlement" BODY "ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n" }
	
	
	variable DEFAULT
	array set DEFAULT {SUBJECT "DEFAULT CLEARING EMAIL SUBJECT" BODY "DEFAULT CLEARING EMAIL BODY"} 


	variable SCRIPT_EMAIL_SUBJECT $DEFAULT(SUBJECT)
	variable SCRIPT_EMAIL_BODY $DEFAULT(BODY) 

##################################################
# set_script_email_subject
# this one needs to error
# tested with set_script_email_subject-1.0
##################################################
	proc set_script_email_subject { level } {
	    	variable SCRIPT_EMAIL_SUBJECT
		variable CRITICAL 
		variable URGENT 
		variable HIGH 
		variable MEDIUM 
		variable LOW
		variable DEBUG
		variable DEFAULT

		if { $DEBUG > 0 } {
                    MASCLR::log_message "Setting SCRIPT_EMAIL_SUBJECT to $level"
		}
		if { [array exists $level] } {
		    set SCRIPT_EMAIL_SUBJECT [lindex [array get $level "SUBJECT"] 1]
		} else {
		    set level "DEFAULT"
		    set SCRIPT_EMAIL_SUBJECT [lindex [array get $level "SUBJECT"] 1]
		    MASCLR::log_message "Invalid level specified.  Could not set appropriate email subject.  Defaulting to $SCRIPT_EMAIL_SUBJECT"
		    error "Invalid level specified.  Could not set appropriate email subject. "    
		}
	}

##################################################
# set_script_email_body
# this one needs to error
# tested with set_script_email_body-1.0
##################################################
	proc set_script_email_body { level } {
	    	variable SCRIPT_EMAIL_BODY
		variable CRITICAL 
		variable URGENT 
		variable HIGH 
		variable MEDIUM 
		variable LOW
		variable DEBUG
		variable DEFAULT

		if { $DEBUG > 0 } {
                    MASCLR::log_message "Setting SCRIPT_EMAIL_BODY to $level"
		}
		if { [array exists $level] } {
		    set SCRIPT_EMAIL_BODY [lindex [array get $level "BODY"] 1]
		} else { 
		    set level "DEFAULT"
		    set SCRIPT_EMAIL_BODY [lindex [array get $level "BODY"] 1]
		    MASCLR::log_message "Invalid level specified.  Could not set appropriate email body.  Defaulting to $SCRIPT_EMAIL_BODY"
		    error "Invalid level specified.  Could not set appropriate email body."    
		}
	}

##################################################
# set_log_file_name
# tested with setLogFileName
##################################################
	proc set_log_file_name { new_name } {
	    	variable LOG_FILE_NAME
		variable DEBUG

		if { $DEBUG > 0 } {
                    MASCLR::log_message "Setting LOG_FILE_NAME to $new_name"
		}
		set LOG_FILE_NAME $new_name
	}

##################################################
# set_log_file_name
# tested with set_debug-1.0
# tested with default_debug_value-1.0
##################################################
        proc set_debug { debug_value } {
                variable DEBUG
                set DEBUG $debug_value
        }


##################################################
# set_log_file_channel
# tested with setLogFileChannel
##################################################
	proc set_log_file_channel { new_channel } {
		variable LOG_FILE_CHANNEL
		set LOG_FILE_CHANNEL $new_channel
	}
##################################################
# set_command_string
# tested with setCommandString
##################################################
	proc set_command_string { new_command_string } {
		variable COMMAND_STRING
		set COMMAND_STRING $new_command_string 
	}
##################################################
# get_command_string
# tested with get_command_string-1.0 
##################################################
	proc get_command_string {} {
		variable COMMAND_STRING
		if { $COMMAND_STRING == "" } {
			uplevel 1 { MASCLR::set_command_string [info script]}
                }
		return $COMMAND_STRING
        }
			
##################################################
# add_open_file
# tested with add_open_file-1.0
##################################################
	proc add_open_file { file_name file_handle } {
		variable OPEN_FILES
		set OPEN_FILES($file_name) $file_handle
	}	
##################################################
# remove_open_file
# tested with remove_open_file-1.0
##################################################
	proc remove_open_file { file_name } {
		variable OPEN_FILES
		array_remove_subscript OPEN_FILES $file_name
	}
##################################################
# array_remove_subscript
# not tested 
##################################################
	proc array_remove_subscript { the_array key } {
       	 	upvar $the_array _array

	        set flat_array [array get _array]
       		array unset _array
	        foreach {flat_key value} $flat_array {
	            if {$flat_key == $key} continue
	            set _array($flat_key) $value
	        }

    	}
	


}

set MASCLR_GLOBALS_LOADED 1
