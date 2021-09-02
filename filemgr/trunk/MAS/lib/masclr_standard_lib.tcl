# this is a library file, not a standalone tcl script
# include this file in a different script by using
# source this_file_name
# $Id$
# prevent loading the file more than once
if { [info exists MASCLR_STANDARD_LIB_LOADED] } {
    return
}

source $env(MASCLR_TCL_LIB)/masclr_globals.tcl

namespace eval MASCLR {

    namespace export print_to_file
        
    variable LOGGED_PRINT_ERROR 0

    proc print_to_file { file_name text_to_print {no_new_line 0}} {
	if { $no_new_line == 1 } {
	    if { [catch {puts -nonewline $MASCLR::OPEN_FILES($file_name) $text_to_print} failure ] } {
	        if { $MASCLR::LOGGED_PRINT_ERROR == 0 } {
		    MASCLR::log_message "Cannot print to file $file_name: $failure"
    		    set MASCLR::LOGGED_PRINT_ERROR 1
	        }	
                puts -nonewline stdout $text_to_print
            }

        } else {
            if { [catch {puts $MASCLR::OPEN_FILES($file_name) $text_to_print} failure ] } {
	        if { $MASCLR::LOGGED_PRINT_ERROR == 0 } {
		    MASCLR::log_message "Cannot print to file $file_name: $failure"
    		    set MASCLR::LOGGED_PRINT_ERROR 1
	        }	
                puts stdout $text_to_print
            }
        }
	    
    }



}

namespace eval MASCLR {
    
    namespace export close_all_and_exit_with_code exit_with_code
    namespace export open_file close_file close_all_open_files

################################################################################
# proc close_all_and_exit_with_code { exit_code {exit_message ""} } 
# parameters:
#    exit_code -- numeric code passed out of the program
#    exit_message -- optional -- message logged with the exit 
#
# exit_with_code
# tries to gracefully close all db connections
# tried to gracefully close all open files
################################################################################
    proc close_all_and_exit_with_code { exit_code {exit_message ""} } {
        global env    
        source $env(MASCLR_TCL_LIB)/masclr_oratcl_tools.tcl
        set close_log_file 0 
        if { [info exists MASCLR::LOG_FILE_CHANNEL] == 1 } {
	    set close_log_file 1
            set MASCLR::LOG_FILE_CHANNEL stdout
        }
	MASCLR::log_message [MASCLR::close_db_connections]
        MASCLR::log_message [MASCLR::close_all_open_files] 
        
    
        MASCLR::log_message "$exit_message"
    
        MASCLR::log_message "Ending [MASCLR::get_command_string] with exit code $exit_code"
#        MASCLR::log_message "Closing file $MASCLR::LOG_FILE_NAME"
        set MASCLR::LOG_FILE_CHANNEL stdout
        if { $close_log_file == 1 } {
            if {[catch {close $MASCLR::LOG_FILE_CHANNEL} response]} {
                log_message "Cannot close file $MASCLR::LOG_FILE_NAME.  Changes may not be saved."
            }
        } 
        exit $exit_code
    
    }


################################################################################
# proc exit_with_code { exit_code {exit_message ""} }
# parameters:
#    exit_code -- numeric code passed out of the program
#    exit_message -- optional -- message logged with the exit
# simple exit.  does not close any files, db connections, etc.
# tested with exit_with_code-1.0
# tested with exit_with_code-log_file_open-1.0
################################################################################
    proc exit_with_code { exit_code {exit_message ""} } {
        set close_log_file 0 
        if { [info exists MASCLR::LOG_FILE_CHANNEL] != 1 } {
            set MASCLR::LOG_FILE_CHANNEL stdout
            set close_log_file 1
        }
        if { [info exists MASCLR::COMMAND_STRING] != 1 } {
            set MASCLR::COMMAND_STRING [info script]
        }
        MASCLR::log_message "$exit_message"
    
        MASCLR::log_message "Ending $MASCLR::COMMAND_STRING with exit code $exit_code"
        set MASCLR::LOG_FILE_CHANNEL stdout
        if { $close_log_file == 1 } {
            MASCLR::log_message "Closing file $MASCLR::LOG_FILE_NAME"
            if {[catch {close $MASCLR::LOG_FILE_CHANNEL} response]} {
                log_message "Cannot close file $MASCLR::LOG_FILE_NAME."
            }
        }
    
        exit $exit_code
    
    }
    
    
################################################################################
# open a log file for writing, append
# arguments
#   file_name -- the log file name
#   autocreate -- (optional) if not 0, add CREAT option to create the file if missing
# 	-- defaults to 1 (automatically creates if missing)
################################################################################
    proc open_log_file { file_name { autocreate 1 } } {
        if { [catch {log_message "Log file $MASCLR::LOG_FILE_NAME already open for writing."} failure] } {
	    if { $autocreate == 0 } {
	        set options "RDWR APPEND"
            } else {
	        set options "RDWR APPEND CREAT"
            }
            if { [catch { set log_channel [open_file $file_name $options ]}  failure ] } {
		set log_channel stdout
		set $file_name "standard out"
		MASCLR::log_message "Could not open log file $file_name.  Directing output to stdout" 
		puts $failure

	    }
	    MASCLR::set_log_file_channel $log_channel
	    MASCLR::set_log_file_name $file_name
	
	    MASCLR::log_message ""
	    MASCLR::log_message "Beginning [MASCLR::get_command_string]"
        }    
    }
    
    
################################################################################
# open a file (permissions passed in as optional argument)
# not tested with unit tests yet
################################################################################
    proc open_file { file_name {permissions "RDWR CREAT TRUNC"} {add_to_open_files_list 1} } {
        
        if { [info exists MASCLR::LOG_FILE_CHANNEL] != 1 } {
            set MASCLR::LOG_FILE_CHANNEL stdout
        }
    
        # TODO change the file open flags if necessary
        MASCLR::log_message "Opening file $file_name with permissions $permissions" 
    
        if {[catch {open $file_name $permissions} file_handle]} {
            MASCLR::log_message "Cannot open file $file_name."
            error "Cannot open file $file_name."
        }
    
        if { $add_to_open_files_list == 1 } {
	    MASCLR::add_open_file $file_name $file_handle
        }
    
    
        return $file_handle
    }

################################################################################
# add_open_file
# add the passed in file name and handle to OPEN_FILES
# not tested with unit tests yet
################################################################################
    proc add_open_file { file_name file_handle } {
        variable OPEN_FILES

        set OPEN_FILES($file_name) $file_handle
        MASCLR::log_message "Added $file_name to open files list"
    }


################################################################################
# close a single file
# if the file exists in the OPEN_FILES global array, remove it
# tested with ????
################################################################################
    proc close_file { file_name } {
        
        MASCLR::log_message "Closing file $file_name"
    
        if {[catch {close $MASCLR::OPEN_FILES($file_name)} response]} {
            MASCLR::log_message "Cannot close file $file_name.  Changes may not be saved."
            error "Cannot close file $file_name.  Changes may not be saved."
        }
        MASCLR::remove_open_file $file_name
        
    }




################################################################################
# close all files in the OPEN_FILES array
# tested with ???
################################################################################
    proc close_all_open_files {  } {
    
        set flat_open_files [array get MASCLR::OPEN_FILES]
	set results ""
        foreach { file_name open_file_id } $flat_open_files {
            if { [catch {close_file $file_name} failure] } {
	    	append results "\n\t\tCould not close file $file_name $failure"
            } else {
                MASCLR::remove_open_file $file_name
		append results "\n\t\tClosed file $file_name"
            }
    
        }
        return $results
    
    }
    
################################################################################
# rebuild an array but omit the given subscript
################################################################################
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



namespace eval MASCLR {
    variable ARGUMENT_INDICATOR "-"
    
    namespace export parse_arguments
    
################################################################################
# parse arguments passed in by the shell
#
# parameters:
#   arg_list --
#   arg_array --
#   required_list --
# tested with parseArguments
# tested with parseArgumentsMissingRequiredArgument
################################################################################
    proc parse_arguments { arg_list arg_array required_list } {
        variable ARGUMENT_INDICATOR
        upvar $arg_array argument_array

        
        foreach {argument value} $arg_list {
            set arg_name [string range $argument [string length $MASCLR::ARGUMENT_INDICATOR] end ]
            MASCLR::log_message "Setting $arg_name to $value"
            set argument_array($arg_name) $value
        }

        foreach required_argument $required_list {
            if { [info exists argument_array($required_argument)] == 0} {
                set error_message "required argument $required_argument was not supplied"
                MASCLR::log_message $error_message
                error $error_message
            }
        }
        

        
    }
    
}


namespace eval MASCLR {
    
    namespace export log_message
    
################################################################################
# rather than just puts a message, this provides a formatted message
# leading with date and time like some logging standards use
# tested with log_message-1.0
# tested with log_message-bad_file_name-1.0
# tested with log_message-log_to_file-1.0
################################################################################
    proc log_message { the_message {debug_level 0} } {
    
        if { $debug_level > 0 } {
            set debug_level "**DEBUG $debug_level**"
        } else {
            set debug_level ""
        }
        if { [catch {puts -nonewline $MASCLR::LOG_FILE_CHANNEL "[clock format [clock seconds] -format "%D %T"] $debug_level $the_message\n"} ]} {
            puts -nonewline stderr "[clock format [clock seconds] -format "%D %T"] $debug_level $the_message\n"
        }
    
    }


}

namespace eval MASCLR {
    namespace export send_email

################################################################################
# send email with mutt, which sends attachments with MIME format 
# parameters
#     file_to_send_list: space separate list of files to attach
#     email_to_list: space separated list of addresses
#     email_subject: optional subject (defaults to empty)
#     email_body: optional body (defaults to empty)
# parameters sent as a list built from an array
#        set email(file_list) 
#        set email(mailto) 
#        set email(subject)
#        set email(body) 
# on failure, logs a message, does not throw an error
# TODO throw an error on failure
# not yet tested in a test suite
################################################################################
    proc send_email { email_array } {
        array set email $email_array 
        if { [info exists email(body)] == 0 } {
            set email(body) ""
        }

        if { [info exists email(subject)] == 0 } {
            set email(subject) ""
        }

        set attachment_string ""
        if { [ llength $email(file_list) ] } {
            foreach filename $email(file_list) {
                if { [ file exists $filename ] } {
                    append attachment_string "-a $filename "
                }
            }
   
        }
        MASCLR::log_message "Calling mutt with mutt $attachment_string -s \"$email(subject) -- \" $email(mailto) w"

        set mailpipe [open "| mutt $attachment_string -s \"$email(subject) -- \" $email(mailto)" w ]
        if { [info exists mailpipe] } {
            if { [ catch {
                if { [file exists $email(body)] } {
                    set email_body_file_id [open $email(body)]
                    puts $mailpipe [read $email_body_file_id]
                } else {
                    #parameter is plain text
                    puts $mailpipe $email(body)
                }
                close $mailpipe
            } result ] } {
                MASCLR::log_message "Could not open channel to mutt to send email: $result"
            }
        }
   }
}

set MASCLR_STANDARD_LIB_LOADED 1
