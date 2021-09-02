#!/usr/bin/env tclsh
# ~/.profile

################################################################################
# $Id: clr_dump.tcl 4242 2017-07-25 14:08:04Z lmendis $
# $Rev: 4242 $
################################################################################
#
# File Name:  clr_dump.tcl
#
# Description:  This program displays the contents of a specified ACH file.
#               It invokes net_zero_file.tcl, as well.
#
# Script Arguments:  file_name = Name of file to display.
#                    seq       (optional sequence number for muliple files)
#
# Output:  None.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

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
set locPath $env(PWD)

#################################################################################

### Set Global Variables
set programName "[lindex [split [file tail $argv0] .] 0]"
set curdate [clock seconds]
set curdate [clock format $curdate -format "%Y/%m/%d"]
set cdate [clock seconds]
set cdate [clock format $cdate -format "%Y%m%d%H%M%S"]
exec sleep 1

proc chkresult {result} {
    global programName
    if {$result != ""} {
        puts "$programName : chkresult -  $result "
        #exit 1
    }
}

proc create_fax_dump_file {inst_id file_type txn_type filePtr bank {seq 0} } {
   global curdate
   global locPath
   global programName
   global box

   set result ""
   if {$seq !=0} {append txn_type .$seq}

   set achfax  "$inst_id.achfax.$file_type.$txn_type.txt"
   set achdump "$inst_id.dump.$file_type.$txn_type.txt"
   puts "$programName Fax file $achfax"
   puts "$programName ACH dump file $achdump"

   ### Create fax
   if {[file exists $achfax]} {
      catch {file delete $achfax} result
   }
   catch {exec $locPath/fax_form.tcl $filePtr $inst_id $file_type >> $achfax} result
   chkresult $result

   ### Create ACH view
   if {[file exists $achdump]} {
      catch {file delete $achdump} result
   }
   catch {exec $locPath/dump_ach.tcl $filePtr >> $achdump} result
   chkresult $result

   ### Email the fax and view
   if { [catch { exec cat $achfax \
    | mutt -a $achfax -a $achdump -s "$box :: $inst_id $bank $txn_type Clearing Fax $curdate" \
        -- reports-clearing.JetPayTX@ncr.com  } result] != 0 } {
           if { [string range $result 0 21] == "Waiting for fcntl lock" } {
              puts "Ignore mutt file control lock $result"
           } else {
              error "mutt error message: $result"
           }
    }

   file delete $achdump
} ; #endof create_fax_dump_file

### MAIN FUNCTION ###
set file_name [lindex $argv 0]
set file_seq  [lindex $argv 1]

puts $file_name
set orig_line $file_name
set varlist [split $orig_line .]
puts $varlist

set inst_id     [lindex $varlist 0]
set file_cat    [lindex $varlist 1]
set file_type   [lindex $varlist 2]
set fbank       [lindex $varlist 3]
set fjdate      [lindex $varlist 4]
set fseq        [lindex $varlist 5]

if {$inst_id == "101" || $inst_id == "107"} {
   if {$file_type == "52"} {
      set fbank "WELLSFARGO"
   }
}

if {[string length $fbank] <= 3 && $file_type == "62"} {
    set fbank "FIRSTPREMIER"
}

#T-1 new config file
set cfg_file_name inst_ach_file.cfg

# T-1 Set default values
set mid_105 "71541"
set mid_106 "117001"
set lid_105 "245149"
set lid_106 "411673"


set cd_path "cd out_ach"
set curdate [clock seconds]
set curdate [clock format $curdate -format "%Y/%m/%d"]
set cdate [clock seconds]
set cdate [clock format $cdate -format "%Y%m%d%H%M%S"]
set date [clock seconds]
set eps_date [clock format $date -format "%m%d%y%H%M%S"]
puts "T-1 EPS - $eps_date"
puts $curdate
exec cd $env(PWD)
#print "Beginning file transfer from MAS System $file_name"

#T-1 these logic has changed
#set fname "$inst_id-ACH_2_$fbank-$file_type-$cdate.ach"
#puts $fname

if {[catch {open $cfg_file_name r} file_ptr]} {
    puts "File Open Err:$cfg_file_name Cannot open config file $cfg_file_name"
    exit 1
}


while { [set line [gets $file_ptr]] != {} } {
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
        default {
            puts "Unknown config parameter [lindex $line_parms 0]"
        }
    }
}


close $file_ptr


if {($inst_id == 105) && (($file_type == "52") || ($file_type == "92"))} {
    set fname "$mid_105\_$lid_105\_$eps_date.ACH"
} elseif {$inst_id == 106 && $file_type == "52"} {
    set fname "$mid_106\_$lid_106\_$eps_date.ACH"
} else {
    set fname "$inst_id-ACH_2_$fbank-$file_type-$cdate.ach"
}

puts "T-1 NAME -$fname"


catch {exec $env(PWD)/net_zero_file.tcl $file_name $fname} result
puts $result
chkresult $result

create_fax_dump_file $inst_id $file_type "" $fname $fbank $file_seq

exec mv $file_name ARCHIVE
if {($inst_id == 105) && (($file_type == "52") || ($file_type == "92"))} {
    exec mv $fname ARCHIVE
}
