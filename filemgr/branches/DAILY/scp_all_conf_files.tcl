#!/usr/local/bin/tclsh
#/clearing/filemgr/.profile

package require Oratcl

################################################################################
# $Id: scp_all_conf_files.tcl 4054 2017-02-06 23:16:14Z millig $
# $Rev: 4054 $
################################################################################
#
#    File Name   -  scp_all_conf_files.tcl
#
#    Description -  This is a custom report used to download and email the 
#                   Canadian and US confirmation and reject files the sftp server
#                   for B2B and PTC
#    
#
#    Arguments      3-digit institution id
#
################################################################################

set box $env(SYS_BOX)
global argv
global inst_dir
global inst_id

set inst_id [string trim [lindex $argv 0]]

if {$inst_id == ""} {
   puts "ERROR:- Institution id missing"
   exit 1
}

set inst_dir "INST_$inst_id"

set reports_dir "/clearing/filemgr/ACH/$inst_dir/reports"
set dnload_dir  "/clearing/filemgr/ACH/$inst_dir/DOWNLOAD"
set mailtolist "reports-clearing@jetpay.com"
set mailfromlist "reports-clearing@jetpay.com"

##################################################################################

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

####################################################################################

################################################################################
#    Procedure Name - readCfgFile
#    Description - Get the DB variables
#    Arguments -
#    Return -
###############################################################################

proc readCfgFile {} {
   global sql_inst
   global cfg_file_name
   global scp_command
   global argv mail_to mail_err
   global inst_id
   global inst_nm
   global scp_src
   global scp_dst
   global inst

   set cfg_file_name "scp_all_conf_files.cfg"
   puts " Default Config File: $cfg_file_name"
   
   if {[catch {open $cfg_file_name r} file_ptr]} {
        puts " *** File Open Err: Cannot open config file $cfg_file_name"
        exit 1
   }

   while { [set line [gets $file_ptr]] != {}} {
       set line_parms [split $line ,]
      switch -exact -- [lindex  $line_parms 0] {
         "MAIL_ERR" {
            set mail_err [lindex $line_parms 1]
         }
         "MAIL_TO" {
            set mail_to [lindex $line_parms 1]
         }
         "INST_LINE" {
            set inst [lindex $line_parms 1]
            if {$inst == $inst_id }  {
                 puts "institution: $inst"
                 
                 set inst_nm [lindex $line_parms 2]
                 puts "inst name: $inst_nm"
                
                 set scp_src [lindex $line_parms 3]
                 puts "scp source: $scp_src"
                 
                 set scp_dst [lindex $line_parms 4]
                 puts "download dir: $scp_dst"
            }
         }
         default {
            puts "Unknown config parameter [lindex $line_parms 0]"
         }
      }
   }
   close $file_ptr
 }

set logdate [clock seconds]
set curdate [clock format $logdate -format "%Y%m%d"]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]
puts " "

readCfgFile 

global scpresult
global newname
global filedate
global mailfile
global scp_cmd
global scp_opt
global scp_src
global scp_dst
global inst_nm

set newname ""

set scp_cmd "scp"
set scp_opt "-p"
set scp_dst $dnload_dir

catch {exec $scp_cmd $scp_opt $scp_src $scp_dst} scpresult
if {$scpresult != ""} {
   puts $scpresult
   set mbody "File download from $inst_nm sftp failed.\n\n $scpresult"
   exec echo "$mbody_h $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_h" $mailtolist
   exit 1 }
  
   catch {set filelist [exec find $dnload_dir -mtime 0 -name 01*.txt]} result
   if {$filelist == ""} {
       exec echo "No $inst_nm Confirmation Files Found" | mailx -r $mailfromlist -s "No $inst_nm Confirmation Files Found" $mailtolist
       exit 1
       } else {
        foreach file $filelist { 
          set filedate [clock format [clock seconds] -format "%Y%m%d%H%M"]
          set fname [file tail $file]
          set newname [file rootname $fname]
          append newname "_$filedate.txt"
          set fname $newname
          exec cp $file $dnload_dir/$newname
          exec sleep 2
          exec rm $file
          exec echo "Please see attached." | mutt -a $dnload_dir/$newname -s "$inst_nm Confirmation File $newname Attached" -- $mailtolist
          exec sleep 2 
          exec mv $dnload_dir/$newname $reports_dir/$newname
        }
     }

set logdate [clock seconds]
set logdate [clock format $logdate -format "%Y%m%d%H%M%S"]
puts "END LOG of $inst_nm Confirmation Files - $logdate"
puts " "
