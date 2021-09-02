#!/usr/bin/env tclsh

# ###############################################################################
#  $Id: ach_auto.tcl 4314 2017-08-28 18:01:37Z skumar $
#  $Rev: 4314 $
# ###############################################################################
# 
#  File Name:  ach_auto.tcl
# 
#  Description:  This script initiates the upload of ACH files to the appropriate
#                bank.
# 
#  Script Arguments: -i = Institution ID.  Required.
#                    -d = date in YYYYMMDD format (optional)
#                    -e = Email address to send error messages.(optional)
#                    -v = debug level.(optional)
#                    -t = test run option.(optional)
# 
#  Output:  Confirmation emails to configured parties.
# 
#  Return:   0 = Success
#           !0 = Exit with errors
# 
# ###############################################################################
package require Oratcl
package provide random 1.0
lappend auto_path $env(MASCLR_LIB)
package require GetOpts 1.1

source $env(MASCLR_LIB)/masclr_tcl_lib
source $env(MASCLR_LIB)/mas_file_lib
global MODE
set MODE "PROD"

global locpath
set locpath "$env(PWD)"
global programName
set programName [file tail $argv0]

#Environment variables.......
global box mailtolist reporttolist mailfromlist
set box $env(SYS_BOX)
set mailtolist $env(MAIL_TO)
set reporttolist $env(ml2_reports)
set mailfromlist $env(MAIL_FROM)

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
set bank_ach_email ""

# Procedure to send alert mail 
proc send_alert {alert_msg} {
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo inst_id
    if { [catch { exec echo "$mbody_c $sysinfo $alert_msg" | mutt -s "$msubj_c" -- $mailtolist } result] != 0 } {
       if { [string range $result 0 21] == "Waiting for fcntl lock" } {
          puts "Ignore mutt file control lock $result"
       } else {
          error "mutt error message: $result"
       }
    }
};

# Procedure to show the appropriate command line arguements 
proc usage {} {
    global programName
    puts stderr "Usage: $programName -i <inst_id> -d <YYYYMMDD> -e <email_id> -t -v "
    puts stderr "       i - Institution ID"
    puts stderr "       d - date"
    puts stderr "       e - email address to send error messages"
    puts stderr "       t - turn on test mode"
    puts stderr "       v - verbosity level of debug information output"
    exit 1
};

# Procedure to Parse the command line arguments
proc arg_parse {} {
    global argv argv0 MODE cfgname env
    global opt_type mailtolist inst_id curdate reporttolist
    set inst_id ""
    set curdate "[clock format [clock seconds] -format "%Y%m%d"]"
    while { [ set err [ getopt $argv "hi:d:e:tv" opt optarg ]] } {
        if { $err < 0 } then {
            MASCLR::log_message "error: $argv0 : opt $opt, optarg: $optarg "
            usage
            exit 1
        } else {
            MASCLR::log_message "opt: $opt, optarg: $optarg" 1
            switch -exact $opt {
               i {set inst_id $optarg}
               d {set curdate $optarg}
               e {
                   set mailtolist $optarg
                   set reporttolist $optarg
                 }
               t {
                   set MODE "TEST"
                   set mailtolist $env(MAIL_TO)
                   set reporttolist $env(MAIL_TO)
                 }
               v {incr MASCLR::DEBUG_LEVEL}
               h {
                    usage
                    exit 1
                }
            }
        }
    }
};

#Procedure to Parse the config file
proc read_cfg_file {} {
    global cfg_file_name output_fname cur_line ftp_user_id
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo inst_id
    
    set cfg_file_name "bmo.cfg" 
    
    if {[catch {open $cfg_file_name r} file_ptr]} {
        send_alert " ERROR :: File Open Error: Cannot open config file $cfg_file_name"
        exit 1
    }
    set output_fname ""
    set ftp_user_id ""
    set cur_line ""
    set cur_line  [split [set orig_line [gets $file_ptr] ] ~]
    while {$cur_line != ""} {
      if {[string toupper [string trim  [lindex $cur_line 0]]] == $inst_id } {
         set output_fname [lindex $cur_line 15]
         set ftp_user_id [lindex $cur_line 16]
      }
      set cur_line  [split [set orig_line [gets $file_ptr] ] ~]
    }
};

#MAIN
proc main {} {

#Checking if a process stop file exist. If process stop file exists stoping process and notifying process issue exists. If the the stop file do not exist
#create the stop file while running this script, so that other process do not start if this scripts completes successfully and removes the stop file at
#the end of the scripts.
    global msg
    set msg ""
    global locpath
    arg_parse
    read_cfg_file

    global inst_id output_fname curdate locpath MODE ftp_user_id
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m box reporttolist
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo inst_id
    if { $output_fname == ""} {
        set msg " ERROR :: Unable to find the Output file name in the $cfg_file_name config file"
        MASCLR::log_message $msg
        send_alert $msg
      exit 1
    }

    if {[file exists /clearing/filemgr/process.stop]} {
        send_alert "PREVIOUS PROCESS NOT COMPLETED ALL OTHER PROCESSES STOPED : ach_auto.tcl"
        exit 1
    } else {
        catch {open /clearing/filemgr/process.stop {WRONLY CREAT}} fileid
    }
    
    global inst_dir
    set inst_dir "INST_$inst_id"

    set logname "ach.log"
    set logfile "$locpath/$inst_dir/LOG/$logname"
    
    #grabbing ACH file for upload
    catch {set x [glob -nocomplain -directory "$locpath/$inst_dir" -type f "$output_fname*$curdate*"] } result;
    
    if {$x == ""} {
        send_alert "ACH file not found in $inst_id ACH folder $result"
        exit 1
    }

    MASCLR::log_message "Found files:- $result"
    MASCLR::log_message "Time before upload - [clock format [clock scan "-0 day"] -format %Y%m%d%H%M%S]"
    set upload_log_name "$locpath/$inst_dir/LOG/upload.log"
    MASCLR::log_message "upload_log_file name : $upload_log_name"
    foreach fname $x {
        MASCLR::log_message "File to upload $fname"
        if { $MODE == "PROD"} {
            set dummy [catch {exec $locpath/upload.exp $fname $ftp_user_id >> $upload_log_name} result]
        } else {
            set dummy 0
            MASCLR::log_message "ftp_user_id: $ftp_user_id" 3
        }
        if { $dummy != 0 } {
            MASCLR::log_message "\nFirst try failed to upload ACH file: $fname Error reason: $result Exit Code: $dummy"
            exec sleep 10
            set dummy [catch {exec $locpath/upload.exp $fname $ftp_user_id >> $upload_log_name} result]
            if { $dummy != 0 } {
                MASCLR::log_message "\nSecond try failed to upload ACH file: $fname Error reason: $result Exit Code: $dummy"
                send_alert "Assist Please contact clearing group or On call Engr. immediately. \
                    \n ACH file : $fname failed to upload to bank ftp site.\n \
                    For more detail Please look in to the log file at $upload_log_name"
                set dummy 1
            } else {
                set dummy 0
                MASCLR::log_message "\n File uploaded to the bank site:$fname"
                set filename [file tail $fname]
                exec mv $fname "$locpath/$inst_dir/ARCHIVE/sent-$filename"
                set file_type [string range $filename [string length $output_fname] [string length $output_fname]]
                if { $file_type == "C" } {
                    set txn_type "CR"
                } else {
                    set txn_type "DB"
                }
                set filedate [lindex [split $filename _] 1]
                MASCLR::log_message "Running file name: $filename file_type: $file_type and its date : $filedate"
                set faxFname "$inst_id\_$txn_type\_$filedate\_achfax.txt"
                MASCLR::log_message "Fax file name: $faxFname"
                exec cat "$locpath/$inst_dir/$faxFname" | mailx -r $mailfromlist -s "$box: ACH File Transmittal $inst_id $faxFname" \
                $reporttolist
                exec mv "$locpath/$inst_dir/$faxFname" "$locpath/$inst_dir/ARCHIVE/sent-$faxFname"
                exec sleep 2
            }
        } else {
             set dummy 0
             MASCLR::log_message "\n File uploaded to the bank site:$fname"
             set filename [file tail $fname]
             exec mv $fname "$locpath/$inst_dir/ARCHIVE/sent-$filename"
             set file_type [string range $filename [string length $output_fname] [string length $output_fname]]
             if { $file_type == "C" } {
                 set txn_type "CR"
             } else {
                 set txn_type "DB"
             }
             set filedate [lindex [split $filename _] 1]
             MASCLR::log_message "Running file name: $filename file_type: $file_type and its date : $filedate"
             set faxFname "$inst_id\_$txn_type\_$filedate\_achfax.txt"
             MASCLR::log_message "Fax file name: $faxFname"
             exec cat "$locpath/$inst_dir/$faxFname" | mailx -r $mailfromlist -s "$box: ACH File Transmittal $inst_id $faxFname" \
               $reporttolist
             exec mv "$locpath/$inst_dir/$faxFname" "$locpath/$inst_dir/ARCHIVE/sent-$faxFname"
             exec sleep 2
          }
    }

    if {$dummy == 1} {
        send_alert "Assist Please contact clearing group or On call Engr. immediately. \
             Clearing ACH failed to upload to bank ftp site.\nFor more detail Please look in to the log file at $env(PWD)/LOG/upload.log"
    }
    catch {file delete /clearing/filemgr/process.stop} result
    exit 0
};

main