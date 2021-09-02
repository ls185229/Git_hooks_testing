#!/usr/bin/env tclsh

################################################################################
# $Id: ach_auto.tcl 4282 2017-08-21 18:38:45Z skumar $
# $Rev: 4282 $
################################################################################
#
# File Name:  ach_auto.tcl
#
# Description:  This program automatically uploads ACH files to the specified
#               bank.
#
# Script Arguments:  inst_id = Institution ID.  Required.
#                    cycl = ACH cycle.  Required.
#
# Output:  None.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

set inst_id [string trim [lindex $argv 0]]
set cycl [string trim [lindex $argv 1]]
set inst_dir "INST_$inst_id"
set subroot "ACH"
set locpth $env(PWD)


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
set cd_path "cd out_ach"
set curdate [clock seconds]
set fdate [clock format [clock scan "-0 day"] -format %Y%m%d]
set curdate [clock format $curdate -format "%d%m%y"]
set cdate [clock seconds]
set cdate [clock format $cdate -format "%Y%m%d%H%M%S"]
set upld "1"
set bank_ach_email ""
set upld_dir "ACH"

# Checking if a process stop file exist. If process stop file exists stoping
# process and notifying process issue exists. If the the stop file do not exist
# create the stop file while running this script, so that other process do not
# start if this scripts completes successfully and removes the stop file at
# the end of the scripts.

if {[file exists /clearing/filemgr/process.stop]} {
    set mbody "PREVIOUS PROCESS NOT COMPLETED ALL OTHER PROCESSES STOPED : ach_auto.tcl"
    exec echo "$mbody_c $sysinfo $mbody" | mutt -s "$msubj_c" -- $mailtolist
    exit 1
} else {
    catch {open /clearing/filemgr/process.stop {WRONLY CREAT}} fileid
}

#grabbing ACH file for upload
switch $inst_id {
    "101"   {switch $cycl {
                "62"    {catch {set x [exec find . -name $inst_id-ACH_2_STERLING-62-$fdate* -mtime 0 ]} result; set seq $cycl}
                "72"    {catch {set x [exec find . -name $inst_id-ACH_2_MERIDIAN-72-$fdate* -mtime 0 ]} result; set seq $cycl}
                "52"    {catch {set x [exec find . -name $inst_id-ACH_2_MERRICK-52-$fdate* -mtime 0 ]} result; set seq $cycl; set upld 0}
                "92"    {catch {set x [exec find . -name $inst_id-ACH_2_MERRICK-92-$fdate* -mtime 0 ]} result; set seq $cycl; set upld 0}
                default {puts "File type >$cycl< did not match criteria"; exit 1}
            }}

    "105"   {switch $cycl {
                "62"    {catch {set x [exec find . -name $inst_id-ACH_2_STERLING-62-$fdate* -mtime 0 ]} result; set seq $cycl}
                "52"    {catch {set x [exec find . -name $inst_id-ACH_2_MERIDIAN-52-$fdate* -mtime 0 ]} result; set seq "52"; set upld 0}
                "92"    {catch {set x [exec find . -name $inst_id-ACH_2_MERIDIAN-92-$fdate* -mtime 0 ]} result; set seq "92"; set upld 0}
                default {puts "File type >$cycl< did not match criteria"; exit 1}
            }}

    "107"   {switch $cycl {
                "62"    {catch {set x [exec find . -name $inst_id-ACH_2_STERLING-62-$fdate* -mtime 0 ]} result; set seq $cycl}
                "72"    {catch {set x [exec find . -name $inst_id-ACH_2_MERIDIAN-72-$fdate* -mtime 0 ]} result; set seq $cycl}
                "52"    {catch {set x [exec find . -name $inst_id-ACH_2_MERRICK-52-$fdate* -mtime 0 ]} result; set seq "52"; set upld 0}
                "92"    {catch {set x [exec find . -name $inst_id-ACH_2_MERRICK-92-$fdate* -mtime 0 ]} result; set seq "92"; set upld 0}
                default {puts "File type >$cycl< did not match criteria"; exit 1}
            }}

    "121"   {switch $cycl {
                "62"    {catch {set x [glob -nocomplain $inst_id-ACH_2_FIRST*-62-$fdate* -mtime 0 ]} result; set seq $cycl}
                "72"    {catch {set x [glob -nocomplain $inst_id-ACH_2_ESQ*-72-$fdate* -mtime 0 ]} result; set seq $cycl}
                "52"    {catch {set x [glob -nocomplain $inst_id-ACH_2_ESQ*-52-$fdate* -mtime 0 ]} result; set seq "52"; set upld 0; set upld_dir ""}
                "92"    {catch {set x [glob -nocomplain $inst_id-ACH_2_ESQ*-92-$fdate* -mtime 0 ]} result; set seq "92"; set upld 0; set upld_dir ""}
            }}

    "811"   {switch $cycl {
                "62"    {catch {set x [exec find . -name $inst_id-ACH_2_STERLING-62-$fdate* -mtime 0 ]} result; set seq $cycl}
                "52"    {catch {set x [exec find . -name $inst_id-ACH_2_STERLING-52-$fdate* -mtime 0 ]} result; set seq "52" }
                default {puts "File type >$cycl< did not match criteria"; exit 1}
            }}

    "820"   {switch $cycl {
                "62"    {set seq $cycl}
                "72"    {set seq $cycl}
                "52"    {catch {set x [exec find . -name $inst_id-ACH_2_MERIDIAN-52-$fdate* -mtime 0 ]} result; set seq "52" }
                default {puts "File type >$cycl< did not match criteria"; exit 1}
            }}
    default {puts "Institution >$inst_id< is not supported"; exit 1}
}

puts $result

if {$result != ""} {
    puts $result
}

if {$x == ""} {
    set mbody "ACH file not found in MAS ACH folder"
    exec echo "$mbody_c $sysinfo $mbody" | mutt -s "$msubj_c" -- $mailtolist
    exit 1
}
set i 0
set fname [file tail [lindex $x $i] ]
puts $fname

if {[llength $x] >=  2} {
    set mbody "Multiple ACH file found in MAS ACH folder\n\n $x"
    exec echo "$mbody_c $sysinfo $mbody" | mutt -s "$msubj_c" -- $mailtolist
    #exit 1
}

puts $curdate

if {$upld == 0} {
    set dummy 0

    #passing file to upload script
    set dummy [catch {exec $locpth/upload.exp $fname $upld_dir >> $locpth/LOG/upload.log} result]

} elseif {$seq == "62"} {

    set dummy 0

    set dummy [catch {exec $locpth/upload_1pb.exp $fname ACH >> $locpth/LOG/upload.log} result]
} elseif {$seq == "52" && $inst_id == "811"} {
    set dummy 0
    set dummy [catch {exec $locpth/upload_1pb.exp $fname ACH >> $locpth/LOG/upload.log} result]
} else {
    set dummy 0
}

#If upload successfull emailing fax form to bank else stoping process.

if {$dummy == 0} {
    set bank_ach_email ""
    switch -exact -- $inst_id  {
        105 {set subj "105";
                if {(($seq == "52") || ($seq == "92"))} {
                    #set bank_ach_email "ApexCardPrograms@meridianbanker.com jcoupland@meridianbanker.com"
                    set bank_ach_email "Clearing.JetPayTX@ncr.com"
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
    set num [llength $x]
    for { set i 0} {$i < $num} {incr i} {
        exec cat $inst_id.achfax.$seq.$i.txt | mutt -s "$box: ACH File Transmittal $subj" \
            -- reports-clearing.JetPayTX@ncr.com $bank_ach_email
    }
    file delete /clearing/filemgr/process.stop
    exec mv $fname ARCHIVE/sent-$fname

} else {
    set    mbody "Assist Please contact clearing group or On call Engr. immediately.  "
    append mbody "Clearing ACH failed to upload to bank ftp site.\n"
    append mbody "For more detail, please look in to the log file at $env(PWD)/LOG/upload.log"
    exec echo "$mbody_c $sysinfo $mbody" | mutt -s "$msubj_c" -- $mailtolist
}
