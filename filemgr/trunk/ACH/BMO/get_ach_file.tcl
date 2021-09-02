#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: get_ach_file.tcl 4676 2018-08-30 21:36:28Z skumar $
# $Rev: 4676 $
################################################################################
#
# File Name:  get_ach_file.tcl
#
# Description:  This program moves the ACH file from the MAS system to the ACH
#               upload folder.
#
# Script Arguments:  inst_id = Institution ID.  Required.
#
# Output:  None.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

package require Oratcl
package provide random 1.0
lappend auto_path $env(MASCLR_LIB)
package require GetOpts 1.1

source $env(MASCLR_LIB)/masclr_tcl_lib
set debug true
set debug_level 4
set MASCLR::DEBUG_LEVEL 4
global programName inst_id mode locpath
set programName "[lindex [split [file tail $argv0] .] 0]"
set inst_id ""
set mode ""
set locpath "$env(PWD)"

#Environment variables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
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
}; #end of usage

# Procedure to Parse the command line arguments
proc arg_parse {} {
    global argv argv0 mode cfgname env 
    global opt_type mailtolist inst_id curdate jdate reporttolist
    set inst_id ""
    set curdate "[clock format [clock seconds] -format "%Y%m%d"]"
    set test ""
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
                      set mode "TEST"
                      set test " -t"
                      set mailtolist $env(MAIL_TO)
                      set reporttolist $env(MAIL_TO)
                 }
               v {
                      incr MASCLR::DEBUG_LEVEL
                 }
               h {
                    usage
                    exit 1
                }
            }
        }
    }
    set jdate [ string range [ clock format [clock scan $curdate -base [clock seconds] ] -format "%y%j"] 1 end]
}; #end of arg_parse

proc main {} {
    global filelist filelist2 maspath mode
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo reporttolist
    set filelist ""
    set filelist2 ""
    global mas_pth locpath logfile
    set mas_pth $maspath

    global fname2
    set fname2 ""
    global inst_id curdate jdate
    set logfile ""
    global msg
    set msg ""
    
    arg_parse
    
    #Checking if a process stop file exist. If process stop file exists stoping process and notifying process issue exists.
    #If the the stop file do not exist, create the stop file while running this script, so that other process do not start
    #if this scripts completes successfully and removes the stop file at the end of the scripts.
    
    if {[file exists /clearing/filemgr/process.stop]} {
        set msg "PREVIOUS PROCESS NOT COMPLETED ALL OTHER PROCESSES STOPED : get_ach_file.tcl"
        MASCLR::log_message $msg
        send_alert $msg
        exit 1
    } else {
        catch {open /clearing/filemgr/process.stop {WRONLY CREAT}} fileid
    }
    
    #TODO Currently it looks for current date alone.. Enhance the script 
    #to retrieve file based on the date parameter passed 
    catch {set filelist [exec find $mas_pth/data/ach -mtime 0 | grep $inst_id.ACH.*]} result
    MASCLR::log_message "MAS ACH filelist is $filelist"
    
    if {$filelist == ""} {
        set msg "ACH file not found in MAS ACH folder"
        MASCLR::log_message "$msg"
        send_alert $msg
        exit 1
    } else {
        set i 0
        set logname "ach.log"
        set logfile "$locpath/LOG/$logname"
        foreach file $filelist {
            set fname [file tail $file]
            MASCLR::log_message "ACH file to copy from masadmin: $fname" 3
            set err [catch [exec cp -p $file .] result]
            MASCLR::log_message $err
            if {$err != 0} {
                set msg "attempt to get ach file from MAS ACH folder failure: $err and the error code is $result"
                MASCLR::log_message $msg
                send_alert $msg
                exit 1
            } else {
                file delete -force $file
                exec $locpath/clr_dump.tcl $fname $i $mode $MASCLR::DEBUG_LEVEL >> $logfile
                exec sleep 5
            }
            incr i
        }
    }
    catch {file delete /clearing/filemgr/process.stop} result
}; #end of main

main
