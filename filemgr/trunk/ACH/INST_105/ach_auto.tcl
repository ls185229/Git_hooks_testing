#!/usr/bin/env tclsh

#################################################################################
# $Id: ach_auto.tcl 4242 2017-07-25 14:08:04Z lmendis $
####################### UPDATE BELOW FOR NEW INST ###############################

set inst_id [string trim [lindex $argv 0]]
set cycl [string trim [lindex $argv 1]]

####################### CHANGES STOPS HERE ######################################


set inst_dir "INST_$inst_id"
set subroot "ACH"
set locpth $env(PWD)

##################################################################################



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
set cfg_file_name "inst_ach_file.cfg"
puts "T-1 cfg_file_name = $cfg_file_name"
set curdate [clock seconds]
set fdate [clock format [clock scan "-0 day"] -format %Y%m%d]
set epsDate [clock format [clock scan "-0 day"] -format %m%d%y]
puts "T-1 epsDate = $epsDate"
set curdate [clock format $curdate -format "%d%m%y"]
set cdate [clock seconds]
set cdate [clock format $cdate -format "%Y%m%d%H%M%S"]
set upld "1"
#####################################################################################################################
#set bank_ach_email "Clearing.JetPayTX@ncr.com"
#set bank_ach_email "achservices@merrickbank.com"
set bank_ach_email ""
set bank_ach_email_106_52 "ACHprocessing@meridianbanker.com"
#####################################################################################################################

# Check existence of process stop file. If process stop file exists, stop process
# and notify that a process issue exists. If the the stop file does not exist
# create the stop file while running this script, so that other process do not start
# if this scripts is running. When this script completes successfully it will
# remove the stop file at the end of the scripts.

if {[file exists /clearing/filemgr/process.stop]} {
    set mbody "PREVIOUS PROCESS NOT COMPLETED ALL OTHER PROCESSES STOPED : ach_auto.tcl"
    exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
    exit 1
} else {
    catch {open /clearing/filemgr/process.stop {WRONLY CREAT}} fileid
}

##### Open the config file to get the MID and LID for inst 105 and 106 EPS upload #######
if {[catch {open $cfg_file_name r} file_ptr]} {
    puts "File Open Err:Cannot open config file $cfg_file_name"
    exit 1
}


while { [set line [gets $file_ptr]] != {}} {
   set line_parms [split $line ,]
   switch -exact -- [lindex  $line_parms 0] {
      "MID_105_JP" {
         set mid_105 [lindex $line_parms 1]
      }
      "MID_106_RV" {
         set mid_106 [lindex $line_parms 1]
      }
      "LID_105_JP" {
         set lid_105 [lindex $line_parms 1]
      }
      "LID_106_RV" {
         set lid_106 [lindex $line_parms 1]
      }
      "MID_117_MD" {}
      "LID_117_MD" {}
      default {
         puts "Unknown config parameter [lindex $line_parms 0]"
      }
   }
}

close $file_ptr

##### end of config file ######

#grabbing ACH file for upload
if {$inst_id == "101"} {
switch $cycl {
    "62"    {catch {set x [exec find . -name $inst_id-ACH_2_FIRSTPREMIER-62-$fdate* -mtime 0 ]} result; set seq $cycl}
    "72"    {catch {set x [exec find . -name $inst_id-ACH_2_MERIDIAN-72-$fdate* -mtime 0 ]} result; set seq $cycl}
    "52"    {catch {set x [exec find . -name $inst_id-ACH_2_MERRICK-52-$fdate* -mtime 0 ]} result; set seq $cycl; set upld 0}
    "92"    {catch {set x [exec find . -name $inst_id-ACH_2_MERRICK-92-$fdate* -mtime 0 ]} result; set seq $cycl; set upld 0}
    default {puts "File type >$cycl< did not match criteria"; exit 1}
}
}

if {$inst_id == "107"} {
switch $cycl {
        "62"   {catch {set x [exec find . -name $inst_id-ACH_2_FIRSTPREMIER-62-$fdate* -mtime 0 ]} result; set seq $cycl}
        "72"   {catch {set x [exec find . -name $inst_id-ACH_2_MERIDIAN-72-$fdate* -mtime 0 ]} result; set seq $cycl}
        "52"   {catch {set x [exec find . -name $inst_id-ACH_2_MERRICK-52-$fdate* -mtime 0 ]} result; set seq "52"; set upld 0}
        "92"   {catch {set x [exec find . -name $inst_id-ACH_2_MERRICK-92-$fdate* -mtime 0 ]} result; set seq "92"; set upld 0}
        default {puts "File type >$cycl< did not match criteria"; exit 1}
}
}
if {$inst_id == "105"} {
switch $cycl {
        "62"   {catch {set x [exec find . -name $inst_id-ACH_2_FIRSTPREMIER-62-$fdate* -mtime 0 ]} result; set seq $cycl}
        "52"   {
                  #catch {set x [exec find . -name $inst_id-ACH_2_MERIDIAN-52-$fdate* -mtime 0 ]} result
                  set fname_105 $mid_105\_$lid_105\_$epsDate*.ACH
                  puts "T-1 fname_105= $fname_105"
                  catch {set x [exec find . -name $fname_105 -mtime 0 ]} result
                  set seq "52"
                  set upld 0
               }
        "92"   {
                  #catch {set x [exec find . -name $inst_id-ACH_2_MERIDIAN-92-$fdate* -mtime 0 ]} result
                  set fname_105 $mid_105\_$lid_105\_$epsDate*.ACH
                  puts "T-1 fname_105= $fname_105"
                  catch {set x [exec find . -name $fname_105 -mtime 0 ]} result
                  set seq "92"
                  set upld 0
               }
        default {puts "File type >$cycl< did not match criteria"; exit 1}
}
}
if {$inst_id == "106"} {
switch $cycl {
        "62"   {catch {set x [exec find . -name $inst_id-ACH_2_FIRSTPREMIER-62-$fdate* -mtime 0 ]} result; set seq $cycl}
        "52"   {
                  #catch {set x [exec find . -name $inst_id-ACH_2_MERIDIAN-52-$fdate* -mtime 0 ]} result
                  set fname_106 $mid_106\_$lid_106\_$epsDate*.ACH
                  puts "T-1 fname_106= $fname_106"
                  catch {set x [exec find . -name $fname_106 -mtime 0 ]} result
                  set seq "52"
                  set upld 0
               }
        default {puts "File type >$cycl< did not match criteria"; exit 1}
}
}
if {$inst_id == "811"} {
switch $cycl {
        "62"   {catch {set x [exec find . -name $inst_id-ACH_2_FIRSTPREMIER-62-$fdate* -mtime 0 ]} result; set seq $cycl}
        "52"   {catch {set x [exec find . -name $inst_id-ACH_2_FIRSTPREMIER-52-$fdate* -mtime 0 ]} result; set seq "52" }
                default {puts "File type >$cycl< did not match criteria"; exit 1}
}
}
if {$inst_id == "820"} {
switch $cycl {
        "62"   {set seq $cycl}
        "72"   {set seq $cycl}
        "52"   {catch {set x [exec find . -name $inst_id-ACH_2_MERIDIAN-52-$fdate* -mtime 0 ]} result; set seq "52" }
                default {puts "File type >$cycl< did not match criteria"; exit 1}
}
}

puts $result

if {$result != ""} {
  puts $result
}

if {$x == ""} {
    set mbody "ACH file not found in MAS ACH folder"
    exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
}
set i 0

set fname [string range [lindex $x $i] 2 end]

puts "T-1 x=$x, fname=$fname"

puts $fname

if {[llength $x] >=  2} {
    set mbody "Multiple ACH file found in MAS ACH folder\n\n $x"
    exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
    exit 1
}

puts $curdate

if {$upld == 0} {
set dummy 0

#passing file to upload script

set dummy [catch {exec $locpth/upload.exp $fname ACH >> $locpth/LOG/upload.log} result]

} elseif {$seq == "62"} {
     exec uuencode $fname $fname | mailx -r $mailfromlist -s "$box: $inst_id ACH file for 1st premier bank" Clearing.JetPayTX@ncr.com
     set dummy 0
     set dummy [catch {exec $locpth/upload_1pb.exp $fname ACH >> $locpth/LOG/upload.log} result]
} elseif {$seq == "52" && $inst_id == "811"} {
        exec uuencode $fname $fname | mailx -r $mailfromlist -s "$box: $inst_id ACH file for 1st premier bank" Clearing.JetPayTX@ncr.com
set dummy 0
} else {
set dummy 0
}

# If upload successful emailing fax form to bank else stopping process.

if {$dummy == 0} {
    set bank_ach_email ""
    switch $inst_id {
        "101" {set subj "900005000"}
        "105" {set subj "105";
                if {(($seq == "52") || ($seq == "92"))} {
                        #set bank_ach_email "ApexCardPrograms@meridianbanker.com jcoupland@meridianbanker.com"
                        #set bank_ach_email $bank_ach_email_106_52
                        set bank_ach_email "Clearing.JetPayTX@ncr.com"
                } else {
                        set bank_ach_email "Clearing.JetPayTX@ncr.com"
                }
              }
        "106" {set subj "106";
                if {$seq == "52"} {
                        #set bank_ach_email "ApexCardPrograms@meridianbanker.com jcoupland@meridianbanker.com"
                        #set bank_ach_email $bank_ach_email_106_52
                        set bank_ach_email "Clearing.JetPayTX@ncr.com"
                } else {
                        set bank_ach_email "Clearing.JetPayTX@ncr.com"
                }
              }
        "107" {set subj "900005004"}
        "811" {set subj "811"}
        "820" {set subj "820"}
           default {set subj ""}
    }
    exec cat $inst_id.achfax.$seq.txt | mailx -r $mailfromlist -s "$box: ACH File Transmittal $subj " reports-clearing.JetPayTX@ncr.com
    file delete /clearing/filemgr/process.stop
    exec mv $fname ARCHIVE/sent-$fname

} else {
    set mbody "Assist Please contact clearing group or On call Engr. immediately. Clearing ACH failed to upload to bank ftp site.\nFor more detail Please look in to the log file at $env(PWD)/LOG/upload.log"
    exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
}
