#!/usr/bin/env tclsh

################################################################################
# $Id: check_esquire_upload_files.tcl 3420 2015-09-11 20:05:17Z bjones $
# $Rev: 3420 $
################################################################################
#
# File Name:  check_esquire_upload_files.tcl
#
# Description:  This program checks for successful file uploads to Esquire Bank.
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

#############################
# input/output
#############################
global output_file
global output_file_name
global std_out_channel


#############################
# usage options
#############################
global run_as_test
global run_as_test_string
global email_to_list
global email_from
global email_subject


proc log_message { log_file_id the_message {debug_level 0} } {

    if { $debug_level > 0 } {
        set debug_level "**DEBUG $debug_level**"
    } else {
        set debug_level ""
    }
    if { [catch {puts $log_file_id "[clock format [clock seconds] -format "%D %T"] $debug_level $the_message"} ]} {
        puts stderr "[clock format [clock seconds] -format "%D %T"] $the_message"
    }

}


proc open_output_file {} {
    global output_file_name
    global output_file
    
    if {[catch {open $output_file_name {RDWR CREAT TRUNC}} output_file]} {
        log_message stdout "Cannot open file $output_file_name. " 
        return
    }
}


proc close_output_file {} {
    global output_file_name
    global output_file
    
    if {[catch {close $output_file} response]} {
        log_message stdout "Cannot close file $output_file_name.  Changes may not be saved."
        return
    }
}


proc parse_arguments {} {
    global arguments
    global argv
    
    foreach {argument value} $argv {
        set arguments($argument) $value
        puts "arguments($argument) = $arguments($argument)"
    }    
}


proc check_files {} {

	global output_file
	global std_out_channel


	puts $output_file "Checking the Esquire upload directories for files."

	puts $output_file "**********Checking /clearing/filemgr/ACH/INST_121/ for .ach files"
	log_message stdout "**********Checking /clearing/filemgr/ACH/INST_121/ for .ach files"
	puts $output_file "Found these files:"
	log_message stdout "Found these files:"
	foreach filename [glob -nocomplain /clearing/filemgr/ACH/INST_121/*.ach] {
		puts $output_file ""
        puts $output_file "$filename"
		puts $output_file "\t[file size $filename] bytes"
		
		log_message stdout "\t$filename"
	}
	log_message stdout ""
	puts $output_file ""
	log_message stdout ""
    puts $output_file ""
	

	puts $output_file "**********Checking /clearing/filemgr/JOURNALS/INST_121/UPLOAD/ for .csv files"
	log_message stdout "**********Checking /clearing/filemgr/JOURNALS/INST_21/UPLOAD/ for .csv files"
	puts $output_file "Found these files:"
	log_message stdout "Found these files:"
	foreach filename [glob -nocomplain /clearing/filemgr/JOURNALS/INST_121/UPLOAD/*.csv] {
		
		puts $output_file "$filename"
		puts $output_file "\t[file size $filename] bytes"
		puts $output_file "\t\t[exec tail -1 $filename]"
		
		log_message stdout "\t$filename"
		puts $output_file ""
	}
	log_message stdout ""
    puts $output_file ""
    log_message stdout ""
    puts $output_file ""


	puts $output_file "**********Checking /clearing/filemgr/JOURNALS/ROLLUP/UPLOAD/ for .csv files"
	log_message stdout "**********Checking /clearing/filemgr/JOURNALS/ROLLUP/UPLOAD/ for .csv files"
	puts $output_file "Found these files:"
	log_message stdout "Found these files:"
	set file_list [glob -nocomplain /clearing/filemgr/JOURNALS/ROLLUP/UPLOAD/*.csv]
	
	foreach filename [lsort $file_list] {
		
		puts $output_file "$filename"
		puts $output_file "\t[file size $filename] bytes"
		puts $output_file "\t\t[exec tail -1 $filename]"
		
		log_message stdout "\t$filename"
		puts $output_file ""
	}
}

proc send_file {} {
	global run_as_test
	global email_to_list
	global email_from
	global email_subject
	global output_file_name
	global env

        set email_subject "$env(SYS_BOX) $email_subject"
	# send the results through email
	if { $run_as_test == 0 } {
		# call mailx to send the file to the email list
		exec mailx -s $email_subject -r $email_from $email_to_list < $output_file_name
	}
}	

proc usage_statement {} {

    puts stdout "Usage: [info script] ?-run_as_test? "
    puts stdout "  If -run_as_test is used, the output will not be sent by email."
    exit 1

}


#################################################################
# main
#################################################################

########################
# setup
########################

set run_as_test_string "-run_as_test"
set run_as_test 0
set output_file_name "./LOG/esquire_upload_file_check.txt"
set email_to_list "clearing@jetpay.com"
set email_from "clearing@jetpay.com"
set email_subject "Esquire files for upload"

set command_string "[info script]"
foreach argument $argv {
    append command_string " $argument"
}
log_message stdout "Beginning $command_string"



parse_arguments

open_output_file


if { [info exists arguments(-run_as_test)] } {
    set run_as_test 1
    puts stdout "running as test"
}

check_files

close_output_file

send_file


log_message stdout "Ending $command_string"

#close_log_file



