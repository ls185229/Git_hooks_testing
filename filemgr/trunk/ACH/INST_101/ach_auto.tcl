#!/usr/bin/env tclsh

# ###############################################################################
# $Id: ach_auto.tcl 4721 2018-09-28 15:29:11Z skumar $
# $Rev: 4721 $
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

global fbank ftp_user_id ftp_machine MODE
global inst_id cycl MODE reporttolist box
global inst_dir subroot locpth mailfromlist

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


set cd_path "cd out_ach"
set curdate [clock seconds]
set fdate [clock format [clock scan "-0 day"] -format %Y%m%d]
set curdate [clock format $curdate -format "%d%m%y"]
set cdate [clock seconds]
set cdate [clock format $cdate -format "%Y%m%d%H%M%S"]
set upld "1"
set MODE "PROD"

set fbank ""
set ftp_machine ""
set ftp_user_id ""
#####################################################################################################################
#set bank_ach_email "clearing@jetpay.com"
#set bank_ach_email "achservices@merrickbank.com"
set bank_ach_email ""
#####################################################################################################################
# Procedure to show the appropriate command line arguements
proc usage {} {
    global programName
    puts stderr "Usage: $programName -i <inst_id> -d <YYYYMMDD> -e <email_id> -t -v "
    puts stderr "       i - Institution ID"
    puts stderr "       c - cycle"
    puts stderr "       d - date"
    puts stderr "       e - email address to send error messages"
    puts stderr "       t - turn on test mode"
    puts stderr "       v - verbosity level of debug information output"
    exit 1
};

# Procedure to Parse the command line arguments
proc arg_parse {} {
    global argv argv0 MODE cfgname env cycl
    global opt_type mailtolist inst_id curdate reporttolist
    global inst_dir subroot locpth

    set inst_id ""
    set cycl ""
    set inst_dir ""
    set subroot ""
    set locpth ""

    set curdate "[clock format [clock seconds] -format "%Y%m%d"]"
    while { [ set err [ getopt $argv "hi:d:c:e:tv" opt optarg ]] } {
        if { $err < 0 } then {
            MASCLR::log_message "error: $argv0 : opt $opt, optarg: $optarg "
            usage
            exit 1
        } else {
            MASCLR::log_message "opt: $opt, optarg: $optarg" 1
            switch -exact $opt {
               i {set inst_id $optarg}
               c {set cycl $optarg}
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
    set inst_dir "INST_$inst_id"
    set subroot "ACH"
    set locpth $env(PWD)
};

#Procedure to Parse the config file
proc read_cfg_file {} {
    global cfg_file_name output_fname cur_line fbank ftp_user_id
    global inst_id MODE bank_ach_email ftp_machine
    global encrypt_flag ssh_id

    set cfg_file_name "bmo_harris.cfg"
    set encrypt_flag ""
    puts "Inside read_cfg_file MODE: $MODE"
    if {[catch {open $cfg_file_name r} file_ptr]} {
        puts " ERROR :: File Open Error: Cannot open config file $cfg_file_name"
        exit 1
    }
    set output_fname ""
    set fbank ""
    set ftp_user_id ""
    set ftp_machine ""
    set ssh_id ""

    set cur_line ""
    set cur_line  [split [set orig_line [gets $file_ptr] ] ~]
    while {$cur_line != ""} {
      if {[string toupper [string trim  [lindex $cur_line 0]]] == $inst_id } {
         set fbank [lindex $cur_line 2]
         set ftp_machine [lindex $cur_line 3]
         set ftp_user_id [lindex $cur_line 4]
         set encrypt_flag [lindex $cur_line 6]
         set bank_ach_email [lindex $cur_line 9]
         set ssh_id [lindex $cur_line 10]
      }
      set cur_line  [split [set orig_line [gets $file_ptr] ] ~]
    }
    puts "bank $fbank, ftp_user_id : $ftp_user_id, bank_ach_email: $bank_ach_email"
    puts "ftp_machine : $ftp_machine encrypt_flag : $encrypt_flag ssh_id: $ssh_id"
};

#MAIN
proc main {} {
# Checking if a process stop file exist. If process stop file exists stopping
# process and notifying process issue exists. If the the stop file do not exist
# create the stop file while running this script, so that other process do not
# start if this scripts completes successfully and removes the stop file at
#the end of the scripts.

    global fbank ftp_user_id ftp_machine MODE
    global inst_id cycl MODE reporttolist box
    global inst_dir subroot locpth curdate bank_ach_email
    global mailtolist mailfromlist clrdb msubj_c msubj_u msubj_h msubj_m
    global msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo
    global encrypt_flag ssh_id

    if {[file exists /clearing/filemgr/process.stop]} {
        set mbody "PREVIOUS PROCESS NOT COMPLETED ALL OTHER PROCESSES STOPED : ach_auto.tcl"
        exec echo "$mbody_c $sysinfo $mbody" | mutt -s "$msubj_c" -- $mailtolist
        exit 1
    } else {
        catch {open /clearing/filemgr/process.stop {WRONLY CREAT}} fileid
    }
    arg_parse
    read_cfg_file

    #grabbing ACH file for upload
    if { ($inst_id == "101" || $inst_id == "107") } {
       switch $cycl {
            "62" {
               catch {set x [exec find . -name $inst_id\_ACH_2_FIRSTPREMIER\_62*$curdate* -mtime 0 ]} result;
               set seq $cycl
               set upld 1
            }
            "72" {
               catch {set x [exec find . -name $inst_id-ACH_2_MERIDIAN-72-$curdate* -mtime 0 ]} result;
               set seq $cycl
            }
            "52" {
              if { $encrypt_flag == "YES"} {
                  catch {set x [glob -nocomplain $inst_id\_ACH\_$fbank\_52*$curdate*.gpg -mtime 0 ]} result;
              } else {
                  catch {set x [glob -nocomplain $inst_id\_ACH\_$fbank\_52*$curdate*.ach -mtime 0 ]} result;
              }
              if {$x == ""} {
                  set mbody "Warning: ACH file not found in MAS ACH folder"
                  puts "$mbody :$result"
                  exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
                  exit 1
              } else {
                set seq $cycl
                set upld 0
              }
            }
            "92" {
              if { $encrypt_flag == "YES"} {
                  catch {set x [glob -nocomplain $inst_id\_ACH\_$fbank\_92*$curdate*.gpg -mtime 0 ]} result;
              } else {
                  catch {set x [glob -nocomplain $inst_id\_ACH\_$fbank\_92*$curdate*.ach -mtime 0 ]} result;
              }
              if {$x == ""} {
                  set mbody "Warning: ACH file not found in MAS ACH folder"
                  puts "$mbody :$result"
                  exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
                  exit 1
              } else {
                set seq $cycl
                set upld 0
              }
            }
            default {
              puts "File type >$cycl< did not match criteria";
              exit 1
            }
       } ; #endof switch
    }; #end of if


    if {$x == ""} {
        set mbody "ACH file not found in MAS ACH folder"
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        exit 1
    }

    puts "Found files:- $result"

    puts "Time before upload - [clock format [clock scan "-0 day"] -format %Y%m%d%H%M%S]"

    if {$upld == 0} {
       set dummy 0
       if { ($inst_id == "101" || $inst_id == "107") && (($cycl == "52") || ($cycl == "92")) } {
          foreach fname $x {
              puts "File to upload $fname"
              set dummy [catch {exec $locpth/upload.exp $fname $ftp_user_id $ftp_machine $ssh_id >> $locpth/LOG/upload.log} result]
              if { $dummy != 0 } {
                  puts "\nFirst try failed to upload ACH file: $fname Error reason: $result Exit Code: $dummy"
                  exec sleep 10
                  set dummy [catch {exec $locpth/upload.exp $fname $ftp_user_id $ftp_machine $ssh_id >> $locpth/LOG/upload.log} result]
                  if { $dummy != 0 } {
                      puts "\nSecond try failed to upload ACH file: $fname Error reason: $result Exit Code: $dummy"
                      set mbody "Assist Please contact clearing group or On call Engr. immediately. \
                                 \n ACH file : $fname failed to upload to bank ftp site.\n \
                                 For more detail Please look in to the log file at $env(PWD)/LOG/upload.log"
                      exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
                      set dummy 1
                  } else {
                      set dummy 0
                      puts "\n File uploaded to the bank site:$fname"
                      exec mv $fname ARCHIVE/sent-$fname
                      set achFname "[lindex [split $fname .] 0]"
                      set faxFname "$achFname.achfax.txt"
                      set achFdate "[lindex [split $achFname _] 5]"
                      #puts "\n faxFname: $faxFname"
                      exec cat $faxFname | mailx -r $mailfromlist -s \
                           "$fbank-JetPayTX - ACH File Confirmation - JTPYTX - $inst_id $faxFname" \
                                              reports-clearing.JetPayTX@ncr.com $bank_ach_email
                      exec mv $faxFname ARCHIVE/sent-$faxFname
                 }
              } else {
                  set dummy 0
                  puts "\n File uploaded to the bank site:$fname"
                  exec mv $fname ARCHIVE/sent-$fname
                  set achFname "[lindex [split $fname .] 0]"
                  set faxFname "$achFname.achfax.txt"
                  set achFdate "[lindex [split $achFname _] 5]"
                  exec cat $faxFname | mailx -r $mailfromlist -s \
                       "$fbank-JetPayTX - ACH File Confirmation – JTPYTX-$inst_id $achFdate" \
                                              reports-clearing.JetPayTX@ncr.com $bank_ach_email
                  exec mv $faxFname ARCHIVE/sent-$faxFname
              }
          }
       } else {
          set fname [string range [lindex $x 0] 2 end]
          puts "File to upload $fname"
          set dummy [catch {exec $locpth/upload.exp $fname $ftp_user_id $ftp_machine $ssh_id >> $locpth/LOG/upload.log} result]
       }
    } elseif {$seq == "62"} {
       set fname [string range [lindex $x 0] 2 end]
       puts "File to upload $fname"
       set dummy 0
       if { $MODE == "TEST"} {
           puts "$fname is uploaded "
       } else {
           set dummy [catch {exec $locpth/upload_1pb.exp $fname ACH >> $locpth/LOG/upload.log} result]
       }
    } elseif {$seq == "52" && $inst_id == "811"} {
       set fname [string range [lindex $x 0] 2 end]
       puts "File to upload $fname"
       set dummy 0
       set dummy [catch {exec $locpth/upload_1pb.exp $fname ACH >> $locpth/LOG/upload.log} result]
    } else {
       set dummy 0
    }

    #If upload successfull emailing fax form to bank else stoping process.

    if {$dummy == 0} {
        set bank_ach_email ""
        switch $inst_id {
            "105" {set subj "105";
                    if {(($seq == "52") || ($seq == "92"))} {
                            set bank_ach_email "ApexCardPrograms@meridianbanker.com jcoupland@meridianbanker.com"
                    } else {
                            set bank_ach_email "Clearing.JetPayTX@ncr.com"
                    }
                  }
            "106" {set subj "106";
                    if {$seq == "52"} {
                            set bank_ach_email "ApexCardPrograms@meridianbanker.com jcoupland@meridianbanker.com"
                    } else {
                            set bank_ach_email "Clearing.JetPayTX@ncr.com"
                    }
                  }
            101 -
            107 -
            121 -
            811 -
            820 {set subj "$inst_id $seq"}
            default {set subj "$inst_id $seq"}
        }
       if { ($inst_id == "101" || $inst_id == "107") && (($cycl == "52") || ($cycl == "92")) } {
           #Nothing to do
       } else {
          exec cat $inst_id.$seq.achfax.txt | mailx -r $mailfromlist -s "$box: ACH File Transmittal $subj " \
                                              reports-clearing.JetPayTX@ncr.com $bank_ach_email
          exec mv $fname ARCHIVE/sent-$fname
       }

       file delete /clearing/filemgr/process.stop

    } else {
        set mbody "Assist Please contact clearing group or On call Engr. immediately. Clearing ACH failed to upload to bank ftp site.\nFor more detail Please look in to the log file at $env(PWD)/LOG/upload.log"
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
    }
}; #end of main

main
