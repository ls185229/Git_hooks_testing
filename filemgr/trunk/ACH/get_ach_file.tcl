#!/usr/bin/env tclsh

# ###############################################################################
#  $Id: get_ach_file.tcl 4324 2017-08-29 21:29:04Z skumar $
#  $Rev: 4324 $
# ###############################################################################
# 
#  File Name:  get_ach_file.tcl
# 
#  Description:  This program moves the ACH file from the MAS system to the ACH
#                upload folder.
# 
#  Script Arguments: -i = Institution ID.  Required.
#                    -d = date in YYYYMMDD format (optional)
#                    -e = Email address to send error messages.(optional)
#                    -v = debug level.(optional)
#                    -t = test run option.(optional)
# 
#  Output:  None.
# 
#  Return:   0 = Success
#           !0 = Exit with errors
# 
#  Notes:  None.
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
global maspath reporttolist
set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set reporttolist $env(ml2_reports)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(IST_DB)
set authdb $env(ATH_DB)
global fname
source $env(MASCLR_LIB)/masclr_tcl_lib
set debug true
set debug_level 4
set MASCLR::DEBUG_LEVEL 4
global programName
set programName "[lindex [split [file tail $argv0] .] 0]"

global curdate
set curdate [clock format [clock seconds] -format "%Y%m%d"]
#Email Subjects variables Priority wise

set msubj_c "$box :: Priority : Critical - Clearing and Settlement in $programName"
set msubj_u "$box :: Priority : Urgent - Clearing and Settlement in $programName"
set msubj_h "$box :: Priority : High - Clearing and Settlement in $programName"
set msubj_m "$box :: Priority : Medium - Clearing and Settlement in $programName"
set msubj_l "$box :: Priority : Low - Clearing and Settlement in $programName"

#Email Body Headers variables for assist

set mbody_c "ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
set mbody_u "ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
set mbody_h "ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
set mbody_m "ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
set mbody_l "ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

#System information variables....

set sysinfo "System: $box\n Location: $env(PWD) \n\n"

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
    global opt_type mailtolist inst_id curdate jdate reporttolist
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
    set jdate [ string range [ clock format [clock scan $curdate -base [clock seconds] ] -format "%y%j"] 1 end]
};

#Procedure to Parse the config file
proc read_cfg_file {} {
    global cfg_file_name output_fname cur_line locpath
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo inst_id
    
    set cfg_file_name "$locpath/bmo.cfg" 
    
    if {[catch {open $cfg_file_name r} file_ptr]} {
        set msg " ERROR :: File Open Error: Cannot open config file $cfg_file_name"
        MASCLR::log_message $msg
        send_alert $msg
      exit 1
    }
    set output_fname ""
    set cur_line ""
    set cur_line  [split [set orig_line [gets $file_ptr] ] ~]
    while {$cur_line != ""} {
      if {[string toupper [string trim  [lindex $cur_line 0]]] == $inst_id } {
         set output_fname [lindex $cur_line 15]
      }
      set cur_line  [split [set orig_line [gets $file_ptr] ] ~]
    }
};

proc chkresult {result} {
    global programName
    if {$result != ""} {
        puts "$programName : chkresult -  $result "
        exit 1
    }
};

# Procedure to create fax and ach dump files
proc create_fax_dump_file {inst_id txn_type filePtr fdate} {
    global locpath
    global programName
    global box
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m reporttolist
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    set result ""
    global inst_dir
    
    set achfax "$inst_id\_$txn_type\_$fdate\_achfax.txt"
    set achdump "$inst_id\_$txn_type\_$fdate\_dump.txt"
    
    
    MASCLR::log_message "$programName ACH fax file = $achfax"
    MASCLR::log_message "$programName ACH dump file = $achdump"
    
    ##################################### 
    ### Create ACH fax
    #####################################
    if {[file exists $achfax]} {
       catch {file delete $achfax} result
    }
    catch {exec $locpath/fax_form.tcl $filePtr $inst_id 52 >> "$locpath/$inst_dir/$achfax"} result
    chkresult $result
    
    #####################################
    ### Create ACH dump
    #####################################
    if {[file exists $achdump]} {
       catch {file delete $achdump} result
    }
    catch {exec $locpath/dump_ach.tcl $filePtr >> "$locpath/$inst_dir/$achdump"} result
    chkresult $result
    
    #####################################
    ### Email the fax and dump
    ##################################### 
     if { [catch { exec cat "$locpath/$inst_dir/$achfax" \
     | mutt -a "$locpath/$inst_dir/$achfax" -a "$locpath/$inst_dir/$achdump" -s "$box :: $inst_id $txn_type Clearing Fax $fdate" \
        -- $reporttolist } result] != 0 } {
            if { [string range $result 0 21] == "Waiting for fcntl lock" } {
               puts "Ignore mutt file control lock $result"
            } else {
               error "mutt error message: $result"
            }
     }
    
    file delete "$locpath/$inst_dir/$achdump"
} ; #endof create_fax_dump_file

#MAIN

proc main {} {
    global filelist filelist2 maspath
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
    global MODE
    
    global output_fname cfg_file_name
    arg_parse
    read_cfg_file

    if { $output_fname == ""} {
        set msg " ERROR :: Unable to find the Output file name in the $cfg_file_name config file"
        MASCLR::log_message $msg
        send_alert $msg
      exit 1
    }
    
    
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
    
    global inst_dir
    set inst_dir "INST_$inst_id"

    set logname "ach.log"
    set logfile "$locpath/$inst_dir/LOG/$logname"
    MASCLR::log_message "locate MAS ACH file for the date: $curdate & its julian date : $jdate" 3
    # Grab the ACH files from the masadmin folder
    catch {set filelist [exec find $mas_pth/data/ach -type f -mtime 0 | grep $inst_id.ACH.*]} result
    # below is not working 
    #catch {set filelist [glob -nocomplain -directory "$mas_pth/data/ach" -type f "$inst_id.ACH.*$jdate*"] } result

    MASCLR::log_message "MAS ACH filelist is $filelist"

    # Currently for all canadian institution it will return only one
    if {($filelist == "") } {
        set msg "ACH file not found in MAS ACH folder"
        MASCLR::log_message "$msg"
        send_alert $msg
       exit 1
    } else {
        foreach fname $filelist {
            set fname2 [file tail $fname]
            MASCLR::log_message "ACH file name =  $fname2"
            set err [catch [exec cp -p $fname "$locpath/$inst_dir/."] result]
            if {$err != 0} {
              set msg "attempt to get ach file from MAS ACH folder failure: $err and the error code is $result"
              MASCLR::log_message $msg
              send_alert $msg
                exit 1
            } else {
               file delete -force $fname
            }
            exec sleep 5
            exec create_bmo_eft_file.tcl $inst_id $fname2 $MODE >> $logfile
            exec sleep 5
            # move original ACH file to archive directory
            exec mv "$locpath/$inst_dir/$fname2" "$locpath/$inst_dir/ARCHIVE/."
        }
    }

    global filelist2
    set filelist2 ""
    catch {set filelist2 [glob -nocomplain -directory "$locpath/$inst_dir" -type f "$output_fname*$curdate*"]} result
    #  split the ACH file into credit and debit ACH files. 
    if { $filelist2 == "" } {
        set msg " ERROR :: Unable to find the $output_fname*$curdate files in the $locpath directory"
        MASCLR::log_message $msg
        send_alert $msg
      exit 1
    }

    MASCLR::log_message "List of ACH files to upload: $filelist2"
 
 
    # create fax and dump file for each credit and debit ACH files
    global txn_type
    foreach file $filelist2 {
        set file_name [file tail $file]
        set file_type [string range $file_name [string length $output_fname] [string length $output_fname] ]
        set file_date [lindex [split $file_name _] 1]
        MASCLR::log_message "Running file : $file_name , file_type : $file_type and its date : $file_date"
        set txn_type ""
        exec sleep 1
        if { $file_type == "C" } {
          set txn_type "CR"
          create_fax_dump_file $inst_id $txn_type $file $file_date
        }
        if { $file_type == "D" } { 
          set txn_type "DB"
          create_fax_dump_file $inst_id $txn_type $file $file_date
        }
        exec sleep 5
    }

    #file_size 2928 is an empty ACH file. 
    #ACH files with no transactions should not upload to the bank.
    #Move it ARCHIVE to avoid upload.
    foreach file $filelist2 {
       set fname [file tail $file]
       if { [file size $file] == 2928 } {
          exec mv "$locpath/$inst_dir/$fname" "$locpath/$inst_dir/ARCHIVE/."
          set file_date [lindex [split $fname _] 1]
          set file_type [string range $fname [string length $output_fname] [string length $output_fname]]
          if { $file_type == "C" } {
              set txn_type "CR"
          } else {
              set txn_type "DB"
          }
          #set txn_type [lindex [split $fname _] 0]
          set faxFname "$inst_id\_$txn_type\_$file_date\_achfax.txt"
          MASCLR::log_message "Moving file name: $fname Fax file name: $faxFname to ARCHIVE directory as its doesnt have any transactions"
          exec mv "$locpath/$inst_dir/$faxFname" "$locpath/$inst_dir/ARCHIVE/."
        }
    }

     catch {file delete /clearing/filemgr/process.stop} result

}; #end of main

main
