#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: get_ach_file.tcl 4242 2017-07-25 14:08:04Z lmendis $
# $Rev: 4242 $
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

set inst_id ""
set locpth "$env(PWD)"

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

set filelist ""
set mas_pth $maspath

set inst_id [lindex $argv 0]
#Checking if a process stop file exist. If process stop file exists stoping process and notifying process issue exists.
#If the the stop file do not exist, create the stop file while running this script, so that other process do not start
#if this scripts completes successfully and removes the stop file at the end of the scripts.

if {[file exists /clearing/filemgr/process.stop]} {
    set mbody "PREVIOUS PROCESS NOT COMPLETED ALL OTHER PROCESSES STOPPED : get_ach_file.tcl"
    if { [catch { exec echo "$mbody_c $sysinfo $mbody" | mutt -s "$msubj_c" -- $mailtolist  } result] != 0 } {
           if { [string range $result 0 21] == "Waiting for fcntl lock" } {
              puts "Ignore mutt file control lock $result"
           } else {
              error "mutt error message: $result"
           }
    }
    exit 1
} else {
    catch {open /clearing/filemgr/process.stop {WRONLY CREAT}} fileid
}


if {$argc == 3} {

    set fname $infile

} else {
    set cyl [lindex $argv 1]
    catch {set filelist [exec find $mas_pth/data/ach -mtime 0 | grep $inst_id.ACH.*]} result
    puts $result

    if {$filelist == ""} {
        set mbody "ACH file not found in MAS ACH folder"
        if { [catch { exec echo "$mbody_c $sysinfo $mbody" | mutt -s "$msubj_c" -- $mailtolist } result] != 0 } {
           if { [string range $result 0 21] == "Waiting for fcntl lock" } {
              puts "Ignore mutt file control lock $result"
           } else {
              error "mutt error message: $result"
           }
       }
    }

    set i 0

    if {[llength $filelist] >=  3} {
        set mbody "Multiple ACH file found in MAS ACH folder: \n\n $filelist"
        if { [catch { exec echo "$mbody_c $sysinfo $mbody" | mutt -s "$msubj_c" -- $mailtolist } result] != 0 } {
           if { [string range $result 0 21] == "Waiting for fcntl lock" } {
              puts "Ignore mutt file control lock $result"
           } else {
              error "mutt error message: $result"
           }
       }
        #exit 1
    }

    set logfile $env(PWD)/LOG/ach.log
    foreach file $filelist {
        set fname [file tail $file]
        puts $fname
        set err [catch [exec cp -p $file .] result]
        puts $err
        if {$err != 0} {
            puts "attempt to get ach file failure: $result"
        } else {
            file delete -force $file
            exec $env(PWD)/clr_dump.tcl $fname $i >> $logfile
        }
        incr i
    }
}

catch {file delete /clearing/filemgr/process.stop} result
